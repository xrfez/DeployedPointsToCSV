import deployedPointsToCSV/[ui, configTools, processedFilesTools]
import packy

packDep(
  r"C:\Users\xrfez\Documents\Programing\01_Sandbox\DeployedPointsToCSV\typeface\garamond\Garamond.ttf",
  r"typeface\garamond"
)

when isMainModule:
  getOrDefaultConfig()
  getOrDefaultProcessedFiles()
  mainUI()
