import std/[parsecfg, streams, os, tables]

# Global tables for configuration information
var
  computerNameToVehicle*: Table[string, string]
  antenaOffsets*: Table[string, string]
  readDirectory*: string
  writeDirectory*: string
  outputName*: string

proc getOrDefaultConfig*() =
  ## Fill the global tables with the configuration information
  ## If the file does not exist, create it with default values
  if not fileExists("config.ini"):
    var config = newConfig()
    config.setSectionKey("Global", "Read Directory", "C:")
    config.setSectionKey("Global", "Write Directory", "C:")
    config.setSectionKey("Global", "Output Name", """output.csv""")
    config.setSectionKey("Computer Name", "NAV207", "T17")
    config.setSectionKey("Computer Name", "SAEPC", "T18")
    config.setSectionKey("Antena Offsets", "T17", "10.2")
    config.setSectionKey("Antena Offsets", "T18", "10.2")
    config.writeConfig("config.ini")

  let dict = "config.ini"
  var f = newFileStream(dict, fmRead)
  var section: string
  assert f != nil, "cannot open " & dict
  var p: CfgParser
  open(p, f, dict)
  while true:
    var e = next(p)
    case e.kind
    of cfgEof:
      break
    of cfgSectionStart: ## a `[section]` has been parsed
      section = e.section
    of cfgKeyValuePair:
      if section == "Global":
        case e.key
        of "Read Directory":
          readDirectory = e.value
        of "Write Directory":
          writeDirectory = e.value
        of "Output Name":
          outputName = e.value
        else:
          discard
      if section == "Computer Name":
        computerNameToVehicle[e.key] = e.value
      if section == "Antena Offsets":
        antenaOffsets[e.key] = e.value
    of cfgOption:
      discard
    of cfgError:
      echo e.msg
  close(p)

proc emptyConfig*() =
  ## Empty the global tables for Computer Name and Antena Offsets
  var config = newConfig()
  config.setSectionKey("Global", "Read Directory", readDirectory)
  config.setSectionKey("Global", "Write Directory", writeDirectory)
  config.setSectionKey("Global", "Output Name", outputName)
  config.writeConfig("config.ini")

proc addToConfig*(section: string, key: string, value: string) =
  ## Add a new key-value pair to the configuration file
  var dict = loadConfig("config.ini")
  dict.setSectionKey(section, key, value)
  dict.writeConfig("config.ini")

proc removeFromConfig*(section: string, key: string) =
  ## Remove a key-value pair from the configuration file
  var dict = loadConfig("config.ini")
  dict.delSectionKey(section, key)
  dict.writeConfig("config.ini")
