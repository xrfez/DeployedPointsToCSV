import imgui
import imgui/impl_opengl
import imgui/impl_glfw
import nimgl/opengl
import nimgl/glfw

import std/typetraits
import std/times
import std/os
import std/tables

import configTools, meaty

import winim

type cStringArray = array[100, char]

proc igStyleColorsSAE*(dst: ptr ImGuiStyle = nil): void =
  ## To conmemorate this bindings this style is included as a default.
  ## Style created originally by r-lyeh
  var style = igGetStyle()
  if dst != nil:
    style = dst

  const ImVec4 =
    proc(x: float32, y: float32, z: float32, w: float32): ImVec4 =
        ImVec4(x: x, y: y, z: z, w: w)
  # const igHI = proc(v: float32): ImVec4 = ImVec4(0.502f, 0.075f, 0.256f, v)
  const igHI =
    proc(v: float32): ImVec4 =
        ImVec4(0.25f, 0.56f, 0.80f, v)
  # const igMED = proc(v: float32): ImVec4 = ImVec4(0.455f, 0.198f, 0.301f, v)
  const igMED =
    proc(v: float32): ImVec4 =
        ImVec4(0.25f, 0.56f, 0.80f, v)
  const igLOW =
    proc(v: float32): ImVec4 =
        ImVec4(0.232f, 0.201f, 0.271f, v)
  const igBG =
    proc(v: float32): ImVec4 =
        ImVec4(0.200f, 0.220f, 0.270f, v)
  const igTEXT =
    proc(v: float32): ImVec4 =
        ImVec4(0.860f, 0.930f, 0.890f, v)

  style.colors[ImGuiCol.Text.int32] = igTEXT(0.88f)
  style.colors[ImGuiCol.TextDisabled.int32] = igTEXT(0.28f)
  style.colors[ImGuiCol.WindowBg.int32] = ImVec4(0.13f, 0.14f, 0.17f, 1.00f)
  # style.colors[ImGuiCol.WindowBg.int32]             = ImVec4(0.502f, 0.075f, 0.256f, 1.00f)
  style.colors[ImGuiCol.PopupBg.int32] = igBG(0.9f)
  style.colors[ImGuiCol.Border.int32] = ImVec4(0.31f, 0.31f, 1.00f, 0.00f)
  style.colors[ImGuiCol.BorderShadow.int32] = ImVec4(0.00f, 0.00f, 0.00f, 0.00f)
  style.colors[ImGuiCol.FrameBg.int32] = igBG(1.00f)
  style.colors[ImGuiCol.FrameBgHovered.int32] = igMED(0.78f)
  style.colors[ImGuiCol.FrameBgActive.int32] = igMED(1.00f)
  style.colors[ImGuiCol.TitleBg.int32] = igLOW(1.00f)
  style.colors[ImGuiCol.TitleBgActive.int32] = igHI(1.00f)
  style.colors[ImGuiCol.TitleBgCollapsed.int32] = igBG(0.75f)
  style.colors[ImGuiCol.MenuBarBg.int32] = igBG(0.47f)
  style.colors[ImGuiCol.ScrollbarBg.int32] = igBG(1.00f)
  style.colors[ImGuiCol.ScrollbarGrab.int32] = ImVec4(0.09f, 0.15f, 0.16f, 1.00f)
  style.colors[ImGuiCol.ScrollbarGrabHovered.int32] = igMED(0.78f)
  style.colors[ImGuiCol.ScrollbarGrabActive.int32] = igMED(1.00f)
  # style.colors[ImGuiCol.CheckMark.int32]            = ImVec4(0.71f, 0.22f, 0.27f, 1.00f)
  style.colors[ImGuiCol.CheckMark.int32] = ImVec4(0.30f, 0.50f, 0.70f, 0.80f)
  style.colors[ImGuiCol.SliderGrab.int32] = ImVec4(0.47f, 0.77f, 0.83f, 0.14f)
  style.colors[ImGuiCol.SliderGrabActive.int32] = ImVec4(0.71f, 0.22f, 0.27f, 1.00f)
  style.colors[ImGuiCol.Button.int32] = ImVec4(0.47f, 0.77f, 0.83f, 0.14f)
  style.colors[ImGuiCol.ButtonHovered.int32] = igMED(0.86f)
  style.colors[ImGuiCol.ButtonActive.int32] = igMED(1.00f)
  style.colors[ImGuiCol.Header.int32] = igMED(0.76f)
  style.colors[ImGuiCol.HeaderHovered.int32] = igMED(0.86f)
  style.colors[ImGuiCol.HeaderActive.int32] = igHI(1.00f)
  style.colors[ImGuiCol.ResizeGrip.int32] = ImVec4(0.47f, 0.77f, 0.83f, 0.04f)
  style.colors[ImGuiCol.ResizeGripHovered.int32] = igMED(0.78f)
  style.colors[ImGuiCol.ResizeGripActive.int32] = igMED(1.00f)
  style.colors[ImGuiCol.PlotLines.int32] = igTEXT(0.63f)
  style.colors[ImGuiCol.PlotLinesHovered.int32] = igMED(1.00f)
  style.colors[ImGuiCol.PlotHistogram.int32] = igTEXT(0.63f)
  style.colors[ImGuiCol.PlotHistogramHovered.int32] = igMED(1.00f)
  style.colors[ImGuiCol.TextSelectedBg.int32] = igMED(0.43f)

  style.windowPadding = ImVec2(x: 6f, y: 4f)
  style.windowRounding = 0.0f
  style.framePadding = ImVec2(x: 5f, y: 2f)
  style.frameRounding = 3.0f
  style.itemSpacing = ImVec2(x: 7f, y: 1f)
  style.itemInnerSpacing = ImVec2(x: 1f, y: 1f)
  style.touchExtraPadding = ImVec2(x: 0f, y: 0f)
  style.indentSpacing = 6.0f
  style.scrollbarSize = 12.0f
  style.scrollbarRounding = 16.0f
  style.grabMinSize = 20.0f
  style.grabRounding = 2.0f

  style.windowTitleAlign.x = 0.50f

  style.colors[ImGuiCol.Border.int32] = ImVec4(0.539f, 0.479f, 0.255f, 0.162f)
  # style.colors[ImGuiCol.Border.int32] = ImVec4(0.25f, 0.56f, 0.80f, 1.00f)
  style.frameBorderSize = 0.0f
  style.windowBorderSize = 1.0f

  style.displaySafeAreaPadding.y = 0
  style.framePadding.y = 1
  style.itemSpacing.y = 1
  style.windowPadding.y = 3
  style.scrollbarSize = 13
  style.frameBorderSize = 1
  style.tabBorderSize = 1

proc newcStringArray(): cStringArray =
  return result

proc toFlag[T](flags: varargs[T]): T =
  for flag in flags:
    result = (ord(result) or ord(flag)).T

proc getSaveFileName(): string =
  ## use the winim windows api library to open a folder dialog and select a folder

  var
    f_SysHr: HRESULT
    f_FileSystem: ptr IFileSaveDialog
    pDefaultFolder: ptr IShellItem = nil
    f_HWND: HWND
    f_Files: ptr IShellItem
    fileTypes: array[1, COMDLG_FILTERSPEC] = [
      COMDLG_FILTERSPEC(pszName: "CSV Files", pszSpec: "*.csv")
    ]
    f_Path: PWSTR

  # create File Object instace
  f_SysHr = CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE)
  if f_SysHr:
    discard MessageBoxA(0, "Failed to initialize COM library", "Exception", MB_OK)
    return ""

  # Create a FileOpenDialog object
  f_SysHr =
    CoCreateInstance(
      &CLSID_FileSaveDialog,
      nil,
      CLSCTX_ALL,
      &IID_IFileSaveDialog,
      cast[ptr pointer](addr f_FileSystem),
    )
  if f_SysHr:
    CoUninitialize()
    discard MessageBoxA(0, "Failed to create FileOpenDialog object", "Exception", MB_OK)
    return ""

  # Set the options for the dialog
  {.push discardable.}
  SetTitle(f_FileSystem, "Save As")
  SetOkButtonLabel(f_FileSystem, "Save")
  SetFileName(f_FileSystem, outputName)
  SHCreateItemFromParsingName(
    writeDirectory, nil, &IID_IShellItem, cast[ptr pointer](addr pDefaultFolder)
  )
  SetFolder(f_FileSystem, pDefaultFolder)
  SetDefaultExtension(f_FileSystem, "csv")
  SetFileTypes(f_FileSystem, 1, cast[ptr COMDLG_FILTERSPEC](&fileTypes))
  {.pop.}

  # Show the open file dialog
  # get the HWND from GLFW *Passed in to proc.  Just set some random value for now
  f_SysHr = Show(f_FileSystem, f_HWND)
  Release(pDefaultFolder)
  if f_SysHr:
    Release(pDefaultFolder)
    CoUninitialize()
    discard MessageBoxA(0, "Failed to show the Open File Dialog", "Exception", MB_OK)
    return ""

  # Get the file name from the dialog
  f_SysHr = GetResult(f_FileSystem, &f_Files)
  if f_SysHr:
    Release(f_FileSystem)
    CoUninitialize()
    discard MessageBoxA(
        0, "Failed to get the filename frm the dialog", "Exception", MB_OK
      )
    return ""
  if isNil(f_Files):
    Release(f_FileSystem)
    CoUninitialize()
    discard MessageBoxA(
        0, "Failed to get the filename frm the dialog", "Exception", MB_OK
      )
    return ""

  # Store and convert the filename
  f_SysHr = GetDisplayName(f_Files, SIGDN_FILESYSPATH, &f_Path)
  if f_SysHr:
    Release(f_Files)
    Release(f_FileSystem)
    CoUninitialize()
    discard MessageBoxA(
        0, "Failed to get the filename frm the dialog", "Exception", MB_OK
      )
    return ""

  # Format and store the filepath
  if not isNil(f_Path):
    result = $f_Path
  else:
    result = ""

  # Clean up
  CoTaskMemFree(f_Path)
  Release(f_Files)
  Release(f_FileSystem)
  CoUninitialize()

proc openFolderDialog(): string =
  ## use the winim windows api library to open a folder dialog and select a folder
  # create File Object instace
  var
    f_SysHr: HRESULT
    f_FileSystem: ptr IFileDialog
    pfos: FILEOPENDIALOGOPTIONS
    pDefaultFolder: ptr IShellItem = nil
    f_Files: ptr IShellItem
    f_HWND: HWND
    f_Path: PWSTR

  f_SysHr = CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE)
  if f_SysHr:
    discard MessageBoxA(0, "Failed to initialize COM Library", "Exception", MB_OK)
    return ""

  # Create a FileOpenDialog object
  f_SysHr =
    CoCreateInstance(
      &CLSID_FileOpenDialog,
      nil,
      CLSCTX_ALL,
      &IID_IFileOpenDialog,
      cast[ptr pointer](addr f_FileSystem),
    )
  if f_SysHr:
    CoUninitialize()
    discard MessageBoxA(0, "Failed to create File Dialog Object", "Exception", MB_OK)
    return ""

  # Set the options for the dialog
  {.push discardable.}
  GetOptions(f_FileSystem, &pfos)
  SetOptions(f_FileSystem, pfos or FOS_PICKFOLDERS)
  SetTitle(f_FileSystem, "Select the folder to start searching for XML files in.")
  SHCreateItemFromParsingName(
    readDirectory, nil, &IID_IShellItem, cast[ptr pointer](addr pDefaultFolder)
  )
  SetFolder(f_FileSystem, pDefaultFolder)
  {.pop.}

  # Show the open file dialog
  # get the HWND from GLFW *Passed in to proc.  Just set some random value for now
  f_SysHr = Show(f_FileSystem, f_HWND)
  Release(pDefaultFolder)
  if f_SysHr:
    Release(pDefaultFolder)
    CoUninitialize()
    discard MessageBoxA(0, "Failed to show open file dialog", "Exception", MB_OK)
    return ""

  # Get the file name from the dialog
  f_SysHr = GetResult(f_FileSystem, &f_Files)
  if f_SysHr:
    Release(f_FileSystem)
    CoUninitialize()
    discard MessageBoxA(
        0, "Failed to get the filename frm the dialog", "Exception", MB_OK
      )
    return ""
  if isNil(f_Files):
    Release(f_FileSystem)
    CoUninitialize()
    discard MessageBoxA(
        0, "Failed to get the filename frm the dialog", "Exception", MB_OK
      )
    return ""

  # Store and convert the filename
  f_SysHr = GetDisplayName(f_Files, SIGDN_FILESYSPATH, &f_Path)
  if f_SysHr:
    Release(f_Files)
    Release(f_FileSystem)
    CoUninitialize()
    discard MessageBoxA(
        0, "Failed to get the filename frm the dialog", "Exception", MB_OK
      )
    return ""

  # Format and store the filepath with name
  if not isNil(f_Path):
    result = $f_Path
  else:
    result = ""

  # Clean up
  CoTaskMemFree(f_Path)
  Release(f_Files)
  Release(f_FileSystem)
  CoUninitialize()

proc `$`(data: cStringArray): string =
  ## Convert a cStringArray to a string
  result = $cast[cstring](addr data[0])

proc cleanConfigList(configSequence: seq[seq[cStringArray]]) =
  ## Remove and update the config.ini file with the new config information
  # if anything is empty dont update
  for computerVehicleAntena in configSequence:
    if computerVehicleAntena[0][0] == '\0' and computerVehicleAntena[1][0] == '\0' and
        computerVehicleAntena[2][0] == '\0':
      continue
    if computerVehicleAntena[0][0] == '\0':
      return
    if computerVehicleAntena[1][0] == '\0':
      return
    if computerVehicleAntena[2][0] == '\0':
      return

  emptyConfig()
  for computerVehicleAntena in configSequence:
    addToConfig("Computer Name", $computerVehicleAntena[0], $computerVehicleAntena[1])
    addToConfig("Antena Offsets", $computerVehicleAntena[1], $computerVehicleAntena[2])
  getOrDefaultConfig()

proc mainUI*() =
  ## Frontend UI for deployedPointsToCSV
  ## Ui allowsuser to select input directory and save location as well as
  ## view and edit the confif.ini file and view and edit th processed files list
  doAssert glfwInit()
  glfwWindowHint(GLFWContextVersionMajor, 3)
  glfwWindowHint(GLFWContextVersionMinor, 3)
  glfwWindowHint(GLFWOpenglForwardCompat, GLFW_TRUE)
  glfwWindowHint(GLFWOpenglProfile, GLFW_OPENGL_CORE_PROFILE)
  glfwWindowHint(GLFWResizable, GLFW_TRUE)

  var w: GLFWWindow = glfwCreateWindow(1280, 720)
  #var image = GLFWImage(pixels: cast[ptr cuchar](nimglLogo[0].addr), width: nimglLogoWidth, height: nimglLogoHeight)
  #w.setWindowIcon(1, image.addr)
  w.setWindowTitle("Deployed Points XML to CSV Converter")
  if w == nil:
    quit(-1)

  w.makeContextCurrent()
  doAssert glInit()

  let
    context = igCreateContext()
    io = igGetIO()
    font1 = io.fonts.addFontFromFileTTF(r"typeface\garamond\Garamond.ttf", 36)
    font2 = io.fonts.addFontFromFileTTF(r"typeface\garamond\Garamond.ttf", 24)
    font3 = io.fonts.addFontFromFileTTF(r"typeface\garamond\Garamond.ttf", 20)

  doAssert igGlfwInitForOpenGL(w, true)
  doAssert igOpenGL3Init()
  var mainViewPort = igGetMainViewport()
  var platformData = newImGuiPlatformImeData()

  igStyleColorsSAE()

  # Variables go here
  var
    # Frame limiter
    frameDelta: float
    # Window flags
    windowFlags =
      toFlag(
        ImGuiWindowFlags.NoScrollbar,
        ImGuiWindowFlags.NoResize,
        ImGuiWindowFlags.NoMove,
        ImGuiWindowFlags.NoCollapse,
      )
    startDirectory: string = readDirectory
    saveFileName: string = writeDirectory / outputName
    walkRecursive: bool = true
    deleteProcessedFiles: bool = false

  # Create 2D Sequence of computer names and vehicles and offsets
  var configSequence: seq[seq[cStringArray]]
  for computerVehicle in computerNameToVehicle.pairs:
    configSequence.add @[newcStringArray(), newcStringArray(), newcStringArray()]
    copyMem(
      addr configSequence[^1][0], addr computerVehicle[0][0], computerVehicle[0].len
    )
    copyMem(
      addr configSequence[^1][1], addr computerVehicle[1][0], computerVehicle[0].len
    )
    try:
      copyMem(
        addr configSequence[^1][2],
        addr antenaOffsets[computerVehicle[1]][0],
        antenaOffsets[computerVehicle[1]].len,
      )
    except:
      discard MessageBoxA(
          0, "No Antena Offset for " & computerVehicle[1], "Exception", MB_OK
        )
  configSequence.add @[newcStringArray(), newcStringArray(), newcStringArray()]
  var lastConfigSequence = configSequence

  # Main Loop
  while not w.windowShouldClose:
    frameDelta = cpuTime()
    glfwPollEvents()

    igOpenGL3NewFrame()
    igGlfwNewFrame()
    igNewFrame()

    igSetNextWindowPos(mainViewPort.workPos)
    igSetNextWindowSize(mainViewPort.workSize)

    # Start window
    if cpuTime() - frameDelta < 0.01:
      sleep(10)

    if igBegin("Deployed Points XML to CSV Converter", nil, windowFlags):
      igPushFont(font2)
      if igButton("Select Start Directory"):
        startDirectory = openFolderDialog()
        if startDirectory != "":
          addToConfig("Global", "Read Directory", startDirectory)
          getOrDefaultConfig()
        else:
          startDirectory = readDirectory
      igSameLine()
      igText(startDirectory)
      if igButton("Select Save Filename"):
        saveFileName = getSaveFileName()
        echo saveFileName
        if saveFileName != "":
          addToConfig("Global", "Write Directory", splitPath(saveFileName)[0])
          addToConfig("Global", "Output Name", splitPath(saveFileName)[1])
          getOrDefaultConfig()
        else:
          saveFileName = readDirectory / outputName
      igSameLine()
      igText(saveFileName)
      igSeparator()
      igNewLine()
      if igButton("Process"):
        meat(startDirectory, saveFileName, walkRecursive, deleteProcessedFiles)
      igSameLine()
      igCheckbox("Recursive", &walkRecursive)
      igSameLine()
      igCheckbox("Delete Processed Files", &deleteProcessedFiles)
      igNewLine()
      igSeparator()
      igPopFont()
      igPushFont(font1)
      igText("Configuration")
      igPopFont()
      igPushFont(font3)
      if igBeginTable("ConfigTable", 3, ImGuiTableFlags.Borders):
        igTableSetupColumn("Computer Name", ImGuiTableColumnFlags.None)
        igTableSetupColumn("Unit ID", ImGuiTableColumnFlags.None)
        igTableSetupColumn("Antena Offset", ImGuiTableColumnFlags.None)
        igTableHeadersRow()
        for computerVehicleAntena in configSequence:
          igTableNextRow()
          igTableSetColumnIndex(0)
          igPushID(cast[int32](addr computerVehicleAntena))
          igPushItemWidth(0.0f)
          igInputText(
            "##ComputerName", cast[cstring](addr computerVehicleAntena[0][0]), 100
          )
          igPopItemWidth()
          igTableSetColumnIndex(1)
          igPushItemWidth(0.0f)
          igInputText("##UnitID", cast[cstring](addr computerVehicleAntena[1][0]), 100)
          igPopItemWidth()
          igTableSetColumnIndex(2)
          igPushItemWidth(0.0f)
          igInputText(
            "##AntenaOffset", cast[cstring](addr computerVehicleAntena[2][0]), 100
          )
          igPopItemWidth()
          igPopID()
        igEndTable()
      if lastConfigSequence != configSequence:
        lastConfigSequence = configSequence
        cleanConfigList(configSequence)
      igPopFont()
      igEnd()
    # End Window

    igRender()

    glClearColor(0.45f, 0.55f, 0.60f, 1.00f)
    glClear(GL_COLOR_BUFFER_BIT)

    igOpenGL3RenderDrawData(igGetDrawData())

    w.swapBuffers()

  igOpenGL3Shutdown()
  igGlfwShutdown()
  context.igDestroyContext()

  w.destroyWindow()
  glfwTerminate()
