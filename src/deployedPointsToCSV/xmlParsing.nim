import std/[strutils, streams, parsexml, times]

import timezones

# Longitude (DDDMM.MMM)	Ellipsoidoid Height (USFT)	UTC Time (HH:MM:SS)	GPS Mode	Number of Sats	HDOP	Orthometric Height (MSL)
type CSVEntry* = object
  stnval: string = ""
  latitude: string = ""
  longitude: string = ""
  elipsoidHeight: string = ""
  utcTime: string = ""
  gpsMode: string = ""
  sats: string = ""
  hdop: string = ""
  zOffset: string = ""
  vehicle: string = ""
  date: string = ""
  dateTime: string = ""

type DP = object
  featureID: string
  lat: string
  lon: string
  alt: string
  gpsString: string
  line: string
  station: string
  pointDateTime: string

proc `$`(dp: DP): string {.used.} =
  return
    dp.featureID & ";" & dp.lat & ";" & dp.lon & ";" & dp.alt & ";" & dp.gpsString & ";" &
    dp.line & ";" & dp.station & ";" & dp.pointDateTime

proc readDeployedPointsXML(filename: string): seq[DP] =
  ## Read DeployedPoints.xml

  let s = newFileStream(filename, fmRead)
  if s == nil:
    quit("cannot open the file " & filename)

  var
    elemstart: string
    x: XmlParser

  open(x, s, filename)
  while true:
    case x.kind
    of xmlAttribute:
      discard
    of xmlElementStart:
      elemstart = x.elementName
      if elemstart == "DeployedPoint":
        result.add DP()
    of xmlCharData:
      if elemstart == "FeatureId":
        result[^1].featureID = x.charData
      if elemstart == "Lat":
        result[^1].lat = x.charData
      if elemstart == "Lon":
        result[^1].lon = x.charData
      if elemstart == "Alt":
        result[^1].alt = x.charData
      if elemstart == "GPSString":
        result[^1].gpsString = x.charData
      if elemstart == "Line":
        result[^1].line = x.charData
      if elemstart == "Station":
        result[^1].station = x.charData
      if elemstart == "PointDateTime":
        result[^1].pointDateTime = x.charData
    of xmlEof:
      break
    else:
      discard
    x.next()
  x.close()

proc ggaExtractLatitude(gpsString: string): string =
  ## Extract Latitude from GGA
  # $GPGGA,194754.8,7009.06510,N,15156.30600,W,4,19,0.7,26.2,M,-0.9,M,0.8,0000*4D,$GNGSA,A,3,80,71,88,72,81,82,73,,,,,,1.4,0.7,1.3*20
  let splitString = gpsString.split(',')
  if splitString[0] != "$GPGGA":
    return ""
  result = splitString[2] & splitString[3]

proc ggaExtractLongitude(gpsString: string): string =
  ## Extract Longitude from GGA
  # $GPGGA,194754.8,7009.06510,N,15156.30600,W,4,19,0.7,26.2,M,-0.9,M,0.8,0000*4D,$GNGSA,A,3,80,71,88,72,81,82,73,,,,,,1.4,0.7,1.3*20
  let splitString = gpsString.split(',')
  if splitString[0] != "$GPGGA":
    return ""
  result = splitString[4] & splitString[5]

proc ggaExtractConvertedElevation(gpsString: string): string =
  ## Convert Meters to USFT
  # $GPGGA,194754.8,7009.06510,N,15156.30600,W,4,19,0.7,26.2,M,-0.9,M,0.8,0000*4D,$GNGSA,A,3,80,71,88,72,81,82,73,,,,,,1.4,0.7,1.3*20
  let splitString = gpsString.split(',')
  if splitString[0] != "$GPGGA":
    return ""
  result = $((parsefloat(splitString[9]) + parsefloat(splitString[11])) * 3.28083333)

proc ggaExtractTime(gpsString: string): string =
  ## Extract UTC Time from GGA
  # $GPGGA,194754.8,7009.06510,N,15156.30600,W,4,19,0.7,26.2,M,-0.9,M,0.8,0000*4D,$GNGSA,A,3,80,71,88,72,81,82,73,,,,,,1.4,0.7,1.3*20
  let splitString = gpsString.split(',')
  if splitString[0] != "$GPGGA":
    return ""
  result = format(parse(splitString[1][0 .. 5], "HHmmss", local()), "HH:mm:ss")

proc ggaExtractGPSMode(gpsString: string): string =
  ## GPS Mode
  # $GPGGA,194754.8,7009.06510,N,15156.30600,W,4,19,0.7,26.2,M,-0.9,M,0.8,0000*4D,$GNGSA,A,3,80,71,88,72,81,82,73,,,,,,1.4,0.7,1.3*20
  let splitString = gpsString.split(',')
  if splitString[0] != "$GPGGA":
    return ""
  if parseint(splitString[6]) == 4:
    result = "FIX"
  else:
    result = "FLOAT"

proc ggaExtractSats(gpsString: string): string =
  ## Number of Sats
  # $GPGGA,194754.8,7009.06510,N,15156.30600,W,4,19,0.7,26.2,M,-0.9,M,0.8,0000*4D,$GNGSA,A,3,80,71,88,72,81,82,73,,,,,,1.4,0.7,1.3*20
  let splitString = gpsString.split(',')
  if splitString[0] != "$GPGGA":
    return ""
  result = splitString[7]

proc ggaExtractHDOP(gpsString: string): string =
  ## Horizontal Dilution of Precision
  # $GPGGA,194754.8,7009.06510,N,15156.30600,W,4,19,0.7,26.2,M,-0.9,M,0.8,0000*4D,$GNGSA,A,3,80,71,88,72,81,82,73,,,,,,1.4,0.7,1.3*20
  let splitString = gpsString.split(',')
  if splitString[0] != "$GPGGA":
    return ""
  result = splitString[8]

proc applyDateCorrection(dp: var CSVEntry) =
  ## Apply Hueristic to determine if date is accurate bassed off GGA HH:mm:ss and PointDateTime
  # let pointDateTime = parseTime(dp.dateTime, "yyyy-MM-dd'T'HH:mm:ss'.'ffffffZZZ", local())
  let
    zone = tz(dp.dateTime[^6 .. dp.dateTime.high])
    pointDateTime = parseTime(
      dp.dateTime[0 .. 18],
      "yyyy-MM-dd'T'HH:mm:ss", #[ '.'ffffff" ]#
      zone,
    )
    correctedTimeStr = $pointDateTime.inZone(utc())
    correctedTime = pointDateTime.inZone(utc())
    correctedDate = parse(correctedTimeStr[0 .. 9], "yyyy-MM-dd", utc())
    fabricatedTime =
      try:
        parse(correctedTimeStr[0 .. 10] & dp.utcTime, "yyyy-MM-dd'T'HH:mm:ss", utc())
      except:
        parse(correctedTimeStr[0 .. 10] & "00:00:00", "yyyy-MM-dd'T'HH:mm:ss", utc())

  if fabricatedTime < correctedTime:
    if correctedTime - fabricatedTime > initDuration(hours = 22, minutes = 30):
      dp.date = format(correctedDate + initDuration(days = 1), "MM/dd/yyyy")
    else:
      dp.date = format(correctedDate, "MM/dd/yyyy")
  else:
    if fabricatedTime - correctedTime > initDuration(hours = 22, minutes = 30):
      dp.date = format(correctedDate - initDuration(days = 1), "MM/dd/yyyy")
    else:
      dp.date = format(correctedDate, "MM/dd/yyyy")

proc createCSVEntry(dp: seq[DP], vehicle: string, zOffset: string): seq[CSVEntry] =
  ## Create CSVEntry from DP
  for idx, entry in dp:
    result.add CSVEntry()
    result[idx].stnval = entry.line & entry.station
    result[idx].latitude = ggaExtractLatitude(entry.gpsString)
    result[idx].longitude = ggaExtractLongitude(entry.gpsString)
    result[idx].elipsoidHeight = ggaExtractConvertedElevation(entry.gpsString)
    result[idx].utcTime = ggaExtractTime(entry.gpsString)
    result[idx].gpsMode = ggaExtractGPSMode(entry.gpsString)
    result[idx].sats = ggaExtractSats(entry.gpsString)
    result[idx].hdop = ggaExtractHDOP(entry.gpsString)
    result[idx].zOffset = zOffset
    result[idx].vehicle = vehicle
    result[idx].date = entry.pointDateTime
    result[idx].dateTime = entry.pointDateTime
    applyDateCorrection(result[idx])

proc csvEntryFromDeployedPointsXML*(
    filename: string, vehicle: string, zOffset: string
): seq[CSVEntry] =
  createCSVEntry(readDeployedPointsXML(filename), vehicle, zOffset)
