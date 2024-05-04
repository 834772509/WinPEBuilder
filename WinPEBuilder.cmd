@echo off
chcp 65001>nul

cd /d "%~dp0"
title %~n0(%cd%)

set "APP_ROOT=%cd%"
set "PATH=%APP_ROOT%\bin;%PATH%"
set "PATH=%APP_ROOT%\lib;%PATH%"

set PROCESSOR_ARCHITECTURE=AMD64
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
  set PROCESSOR_ARCHITECTURE=x86
)

set APP_ARCH=x86
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
  set APP_ARCH=x64
  set "PATH=%APP_ROOT%\bin\x64;%PATH%"
) else (
  set "PATH=%APP_ROOT%\bin\x86;%PATH%"
)

rem run with Administrators right
IsAdmin.exe
if "x%APP_RUNAS_TI%"=="x" (
  set APP_RUNAS_TI=1
  NSudoC.exe -UseCurrentConsole -Wait -U:T "%~0"
  goto :EOF
)

set /p APP_SRC=请输入install.wim文件路径：
if /i "%APP_SRC%"=="" (
  echo 没有输入install.wim文件路径
  pause
  exit
)

set APP_SRC_INDEX=1

set /p APP_BASE_PATH=请输入基础wim文件路径（留空则为WinRE.wim）：
if /i "%APP_BASE_PATH%"=="" (
  wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\Recovery\winre.wim" --dest-dir="%cd%\target" --nullglob --no-acls
  set "APP_BASE_PATH=%cd%\target\winre.wim"
)

set APP_BASE_INDEX=1

echo ==========
for /d %%i in ("%cd%\projects\*") do (
  echo %%~nxi
)
echo ==========
set /p PROJECT_NAME=请输入项目名称：

:build
set startime=%time:~0,2%%time:~3,2%%time:~6,2%

set "SRC_PATH=%cd%\target\install"
set "APP_TMP_PATH=%cd%\target\temp"
set "PROJECT_PATH=%cd%\projects\%PROJECT_NAME%"
set "BUILD_WIM=%cd%\target\boot.wim"
set APP_PE_LANG=zh-CN

set "X=%cd%\target\mounted"
set X_WIN=%X%\Windows
set X_SYS=%X_WIN%\System32
set X_WOW64=%X_WIN%\SysWOW64
set X_Desktop=%X%\Users\Default\Desktop

if not exist "%X%" mkdir "%X%"
if not exist "%APP_TMP_PATH%" mkdir "%APP_TMP_PATH%"

wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\DEFAULT" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct
wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\DRIVERS" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct
wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\SYSTEM" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct
wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\SOFTWARE" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct

rem 挂载基础镜像
Dism /mount-wim /wimfile:"%APP_BASE_PATH%" /index:1 /mountdir:"%X%"

rem 处理文件权限
echo updating files' ACL rights...(Please, be patient)
takeown /f "%X%" /a /r /d y>nul
icacls "%X%" /grant administrators:F /t>nul
echo Update files with Administrators' FULL ACL rights successfully

rem 挂载注册表
reg load HKLM\Src_SOFTWARE %SRC_PATH%\Windows\System32\config\SOFTWARE
reg load HKLM\Src_SYSTEM %SRC_PATH%\Windows\System32\config\SYSTEM
reg load HKLM\Src_DEFAULT %SRC_PATH%\Windows\System32\config\DEFAULT
reg load HKLM\Src_DRIVERS %SRC_PATH%\Windows\System32\config\DRIVERS

reg load HKLM\Tmp_SOFTWARE %X%\Windows\System32\config\SOFTWARE
reg load HKLM\Tmp_SYSTEM %X%\Windows\System32\config\SYSTEM
reg load HKLM\Tmp_DEFAULT %X%\Windows\System32\config\DEFAULT
reg load HKLM\Tmp_DRIVERS %X%\Windows\System32\config\DRIVERS

rem 执行项目脚本
call ApplyProjectPatches "%PROJECT_PATH%"
echo 项目执行完成

rem 卸载注册表
reg unload HKLM\Src_SOFTWARE
reg unload HKLM\Src_SYSTEM
reg unload HKLM\Src_DEFAULT
reg unload HKLM\Src_DRIVERS

reg unload HKLM\Tmp_SOFTWARE
reg unload HKLM\Tmp_SYSTEM
reg unload HKLM\Tmp_DEFAULT
reg unload HKLM\Tmp_DRIVERS

rem 清理注册表日志文件
del /f /q /a "%X%\Windows\System32\config\*.LOG*" 1>nul 2>nul
del /f /q /a "%X%\Windows\System32\config\*{*}*" 1>nul 2>nul
del /f /q /a "%X%\Windows\System32\SMI\Store\Machine\*.LOG*" 1>nul 2>nul
del /f /q /a "%X%\Windows\System32\SMI\Store\Machine\*{*}*" 1>nul 2>nul
del /f /q /a "%X%\Users\Default\*.LOG*" 1>nul 2>nul
del /f /q /a "%X%\Users\Default\*{*}*" 1>nul 2>nul

rem 导出镜像
wimlib-imagex.exe capture "%X%" "%BUILD_WIM%" --boot --compress=LZX "WindowsPE" "WindowsPE"

rem 卸载卷
Dism /Unmount-Image /MountDir:"%X%" /discard

rem 清理文件
rd /s /q "%SRC_PATH%"
rd /s /q "%X%"
rd /s /q "%APP_TMP_PATH%"
del /A /F /Q "%cd%\target\winre.wim"

set endtime=%time:~0,2%%time:~3,2%%time:~6,2%
set /a finaltime=%endtime%-%startime%

echo 制作完成，耗时%finaltime%秒.
cmd /k
