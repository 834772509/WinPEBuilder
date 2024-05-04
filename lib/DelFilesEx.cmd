rem 宏: 白名单删除文件
rem 分析语法, 通过指定的文件列表，反向删除其他文件

rem 用法
rem   call DelFilesEx \Windows\zh-cn\* "notepad.exe.mui,regedit.exe.mui"
rem   call DelFilesEx \Windows\System32\dm*.dll "dm1.dll,dm2.dll"

echo [MACRO]DelFilesEx %*
setlocal enabledelayedexpansion

set "directory=%~1"
set "fileList=%~2"

for %%i in (%fileList%) do (
  set "fileToKeep[%%i]=1"
)

for %%f in ("%x%%directory%") do (
  set "fileName=%%~nxf"
  if not defined fileToKeep[!fileName!] (
    del /f /a /q "%%f"
  )
)

goto :EOF
