import xmlParsing, configTools, processedFilesTools

import csvtools

import std/[os, tables]

proc meat*(startDirectory: string, saveName: string, recursive: bool, delProcessed: bool) =
  var csvEntriesList: seq[CSVEntry] = @[]
  if delProcessed:
    deleteProcessedFiles()
  case recursive
  of true:
    for fileName in walkDirRec(startDirectory, relative = false):
      if fileName.extractFilename == "DeployedPoints.xml":
        if not processedFiles.hasKey(fileName):
          let unitID = computerNameToVehicle[getComputerName(fileName)]
          let antenaOffset = antenaOffsets[unitID]
          csvEntriesList &= csvEntryFromDeployedPointsXML(
            fileName, unitID, antenaOffset
          )
          addProcessedFile(fileName)
    if csvEntriesList.len > 0:
      writeToCSV(csvEntriesList, saveName)
  of false:
    for fileName in walkDir(startDirectory, relative = false):
      if fileName[1].extractFilename == "DeployedPoints.xml":
        if not processedFiles.hasKey(fileName[1]):
          let unitID = computerNameToVehicle[getComputerName(fileName[1])]
          let antenaOffset = antenaOffsets[unitID]
          csvEntriesList &= csvEntryFromDeployedPointsXML(
            fileName[1], unitID, antenaOffset
          )
          addProcessedFile(fileName[1])
    if csvEntriesList.len > 0:
      writeToCSV(csvEntriesList, saveName)
