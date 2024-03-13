import deployedPointsToCSV/[ui, configTools, processedFilesTools]
import packy

packDep(r"E:\Programing\01_sandbox\DeployedPointsToCSV\typeface\garamond\Garamond.ttf", r"typeface\garamond")

when isMainModule:
  getOrDefaultConfig()
  getOrDefaultProcessedFiles()
  mainUI()


