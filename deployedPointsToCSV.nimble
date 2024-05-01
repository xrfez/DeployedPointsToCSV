# Package
backend       = "cpp"
version       = "0.2.4"
author        = "Joshua Fenner"
description   = "Navigator DeployedPoints.xml Decoder"
license       = "MIT"
srcDir        = "src"
bin           = @["deployedPointsToCSV"]

# Dependencies

# TODO https://github.com/nim-lang/nimble/issues/1166
# Using exact version here and adding path manually :facepalm:
# run `nimble setup -l` to hopefully make it work
requires "nim >= 2.0.0 & <= 2.0.2",
          "csvtools",
          "timezones",
          "flatty",
          "imgui >= 1.89",
          "nimgl",
          "winim",
          "packy"
          
