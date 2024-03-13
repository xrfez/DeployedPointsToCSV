import flatty
import std/tables
import std/os

# Global processed file list
var processedFiles*: Table[string, string] = initTable[string, string]()

proc getComputerName*(fileName: string): string =
  ## Get the computer name from the file name
  result = fileName.splitpath()[0].splitpath[1][15 .. ^1]

proc getOrDefaultProcessedFiles*() =
  ## Load the processed files from a flat binary file
  ## Returns a table of processed files
  ## If the file does not exist, an empty table is returned
  if not fileExists("processedFiles.bin"):
    let temp = initTable[string, string]()
    writeFile("processedFiles.bin", toFlatty(temp))
  try:
    processedFiles = fromFlatty(readFile("processedFiles.bin"), Table[string, string])
  except:
    processedFiles = initTable[string, string]()

proc addProcessedFile*(file: string) =
  ## Add a file to the processed file list and save it to a flat binary file
  processedFiles[file] = getComputerName(file)
  writeFile("processedFiles.bin", toFlatty(processedFiles))

proc removeProcessedFile*(file: string) =
  ## Remove a file from the processed file list and save it to a flat binary file
  processedFiles.del(file)
  writeFile("processedFiles.bin", toFlatty(processedFiles))

proc deleteProcessedFiles*() =
  ## Delete the processed file list
  if fileExists("processedFiles.bin"):
    let temp = initTable[string, string]()
    writeFile("processedFiles.bin", toFlatty(temp))
  processedFiles = initTable[string, string]()
