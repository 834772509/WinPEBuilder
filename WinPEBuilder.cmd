@echo off
chcp 65001>nul
setlocal enabledelayedexpansion

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

:cui
set /p cddir=输入虚拟光驱盘符：
if "%cddir%"=="" (echo 没有输入虚拟光驱盘符 & goto :cui)
if exist "%cddir:~,1%:\sources\install.wim" (
  set APP_SRC=%cddir:~,1%:\sources\install.wim
) else (
  if exist "%cddir:~,1%:\sources\install.esd" (
    set APP_SRC=%cddir:~,1%:\sources\install.esd
  ) else (
    echo 没找到 install.wim 和 install.esd
    goto :cui
  )
)
echo ————————————————————————————————————————————————
for /f "tokens=2 delims=: " %%a in ('Dism.exe /English /Get-WimInfo /WimFile:"%APP_SRC%" ^| findstr /i Index') do (
  for /f "tokens=2 delims=:" %%b in ('Dism.exe /English /Get-WimInfo /WimFile:"%APP_SRC%" /Index:%%a ^| findstr /i Name') do (set Name=%%b)
  for /f "tokens=2 delims=:" %%c in ('Dism.exe /English /Get-WimInfo /WimFile:"%APP_SRC%" /Index:%%a ^| findstr /i Version') do (set Version=%%c)
  for /f "tokens=3 delims=: " %%d in ('Dism.exe /English /Get-WimInfo /WimFile:"%APP_SRC%" /Index:%%a ^| findstr /i Build') do (set Build=%%d)
  for /f "tokens=2 delims=:" %%e in ('Dism.exe /English /Get-WimInfo /WimFile:"%APP_SRC%" /Index:%%a ^| findstr /i Architecture') do (set Architecture=%%e)
  echo  %%a	!Name! !Version!.!Build! !Architecture!
  set index=%%a
)
echo ————————————————————————————————————————————————
set /p APP_SRC_INDEX=输入install分卷号：
if "%APP_SRC_INDEX%"=="" (set APP_SRC_INDEX=1&echo 没有输入分卷号，已自动选择卷1)
if %APP_SRC_INDEX% lss 1 (echo 没有选择对应的分卷号 & goto :cui)
if %APP_SRC_INDEX% gtr %index% (echo 没有选择对应的分卷号 & goto :cui)

set index=0
echo.
echo 已有的项目：
echo ————————————————————————————————————————————————
for /d %%i in ("%cd%\projects\*") do (
set /a index=index+1
echo  !index!     %%~nxi
)
echo ————————————————————————————————————————————————
set /p project=请输入项目序号：
if "%project%"=="" (echo 没有选择项目 & goto :cui)
if "%project%" lss "1" (echo 没有选择对应的项目 & goto :cui)
if "%project%" gtr "%index%" (echo 没有选择对应的项目 & goto :cui)
set index=0
for /d %%x in ("%cd%\projects\*") do (
  set /a index=index+1
  if "!index!"=="%project%" (set PROJECT_NAME=%%~nx)
)

echo.
echo 提取基础wim镜像
echo ————————————————————————————————————————————————
echo  1     boot.wim (卷2) (适用于Boot修订号同步的镜像)
echo  2     winre.wim (卷1) (适用于winre修订号同步的镜像)
echo        自定义基础镜像 (卷1)
echo ————————————————————————————————————————————————
set /p bore=请输入基础镜像：
if "%bore%"=="" (set bore=2&echo 没有选择 wim,已自动选择 winre.wim)
if "%bore%"=="1" (
  copy /y "%cddir:~,1%:\sources\boot.wim" "%cd%\target\base.wim"
  set "APP_BASE_PATH=%cd%\target\base.wim"
  set APP_BASE_INDEX=2
) else if "%bore%"=="2" (
  set "APP_BASE_PATH=%cd%\target\winre.wim"
  set APP_BASE_INDEX=1
  echo \033[93;46m [构建] 提取winre.wim...... | CmdColor.exe
  wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\Recovery\winre.wim" --dest-dir="%cd%\target" --nullglob --no-acls
) else if exist "%bore%" (
  copy /y "%bore%" "%cd%\target\base.wim"
  set "APP_BASE_PATH=%cd%\target\base.wim"
  set APP_BASE_INDEX=1
) else echo 没有选择对应的项目 & goto :cui

:build
set startime=%time:~0,2%%time:~3,2%%time:~6,2%

echo \033[93;46m [构建] 获取基础镜像信息...... | CmdColor.exe
for /f "tokens=1,2 delims=:(" %%i in ('Dism.exe /Get-WimInfo /WimFile:"%APP_BASE_PATH%" /Index:%APP_BASE_INDEX% /English') do (
  if "%%i"=="Architecture " set APP_PE_ARCH=%%j
  if "%%i"=="Version " set APP_PE_VER=%%j
  if "%%i"=="ServicePack Build " set APP_PE_BUILD=%%j
  if "x!LANG_FLAG!"=="x1" (
    set APP_PE_LANG=%%i
    set LANG_FLAG=
  )
  if "%%i"=="Languages " set LANG_FLAG=1
)
if "x%APP_PE_LANG%"=="x" (
  echo \033[93;46m [构建] 获取基础镜像信息失败 | CmdColor.exe
  cmd /k
)

set "APP_PE_ARCH=%APP_PE_ARCH: =%"
set "APP_PE_VER=%APP_PE_VER: =%"
set "APP_PE_BUILD=%APP_PE_BUILD: =%"
rem here is TAB, not SPACE 
set "APP_PE_LANG=%APP_PE_LANG:	=%"
set "APP_PE_LANG=%APP_PE_LANG: =%"

echo %APP_PE_VER%.%APP_PE_BUILD%,%APP_PE_ARCH%,%APP_PE_LANG%

set "SRC_PATH=%cd%\target\install"
set "APP_TMP_PATH=%cd%\target\temp"
set "PROJECT_PATH=%cd%\projects\%PROJECT_NAME%"
set "BUILD_WIM=%cd%\target\boot.wim"
set "APP_PE_LANG=zh-CN"

set "X=%cd%\target\mounted"
set "X_WIN=%X%\Windows"
set "X_SYS=%X_WIN%\System32"
set "X_WOW64=%X_WIN%\SysWOW64"
set "X_Desktop=%X%\Users\Default\Desktop"

if not exist "%X%" mkdir "%X%"
if not exist "%APP_TMP_PATH%" mkdir "%APP_TMP_PATH%"

echo \033[93;46m [构建] 提取安装镜像注册表...... | CmdColor.exe
wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\DEFAULT" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct
wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\DRIVERS" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct
wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\SYSTEM" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct
wimlib-imagex.exe extract "%APP_SRC%" %APP_SRC_INDEX% "\Windows\System32\config\SOFTWARE" --dest-dir="%SRC_PATH%" --nullglob --no-acls --preserve-dir-struct

rem 挂载基础镜像
echo \033[93;46m [构建] 挂载基础镜像: %APP_BASE_PATH% | CmdColor.exe
Dism /mount-wim /wimfile:"%APP_BASE_PATH%" /index:%APP_BASE_INDEX% /mountdir:"%X%"

rem 挂载注册表
echo \033[93;46m [构建] 挂载安装镜像镜像注册表 | CmdColor.exe
reg load HKLM\Src_SOFTWARE %SRC_PATH%\Windows\System32\config\SOFTWARE
reg load HKLM\Src_SYSTEM %SRC_PATH%\Windows\System32\config\SYSTEM
reg load HKLM\Src_DEFAULT %SRC_PATH%\Windows\System32\config\DEFAULT
reg load HKLM\Src_DRIVERS %SRC_PATH%\Windows\System32\config\DRIVERS

echo \033[93;46m [构建] 挂载基础镜像注册表 | CmdColor.exe
reg load HKLM\Tmp_SOFTWARE %X%\Windows\System32\config\SOFTWARE
reg load HKLM\Tmp_SYSTEM %X%\Windows\System32\config\SYSTEM
reg load HKLM\Tmp_DEFAULT %X%\Windows\System32\config\DEFAULT
reg load HKLM\Tmp_DRIVERS %X%\Windows\System32\config\DRIVERS

rem 执行项目脚本
call ApplyProjectPatches "%PROJECT_PATH%"
echo \033[93;46m [构建] 项目执行完成，正在清理...... | CmdColor.exe

rem 卸载注册表
reg unload HKLM\Src_SOFTWARE
reg unload HKLM\Src_SYSTEM
reg unload HKLM\Src_DEFAULT
reg unload HKLM\Src_DRIVERS

reg unload HKLM\Tmp_SOFTWARE
reg unload HKLM\Tmp_SYSTEM
reg unload HKLM\Tmp_DEFAULT
reg unload HKLM\Tmp_DRIVERS

rem 清理日志文件
del /f /q /a "%X%\Windows\System32\config\*.LOG*" 1>nul 2>nul
del /f /q /a "%X%\Windows\System32\config\*{*}*" 1>nul 2>nul
del /f /q /a "%X%\Windows\System32\SMI\Store\Machine\*.LOG*" 1>nul 2>nul
del /f /q /a "%X%\Windows\System32\SMI\Store\Machine\*{*}*" 1>nul 2>nul
del /f /q /a "%X%\Users\Default\*.LOG*" 1>nul 2>nul
del /f /q /a "%X%\Users\Default\*{*}*" 1>nul 2>nul

rem 保存并卸载卷
echo \033[93;46m [构建] 正在卸载基础镜像...... | CmdColor.exe
Dism /Unmount-Image /MountDir:"%X%" /commit

rem 导出镜像
echo \033[93;46m [构建] 正在导出WinPE镜像...... | CmdColor.exe
if exist "%BUILD_WIM%" del /A /F /Q "%BUILD_WIM%"
rem wimlib-imagex.exe export "%APP_BASE_PATH%" %APP_BASE_INDEX% "%BUILD_WIM%" --boot
Dism /Export-Image /SourceImageFile:"%APP_BASE_PATH%" /SourceIndex:%APP_BASE_INDEX% /DestinationImageFile:"%BUILD_WIM%" /Bootable

rem 清理文件
rd /s /q "%SRC_PATH%"
rd /s /q "%X%"
rd /s /q "%APP_TMP_PATH%"
del /A /F /Q "%cd%\target\winre.wim"
del /A /F /Q "%cd%\target\base.wim"

set endtime=%time:~0,2%%time:~3,2%%time:~6,2%
set /a finaltime=%endtime%-%startime%

echo \033[93;46m [完成] WinPE制作完成，总耗时%finaltime%秒. | CmdColor.exe
cmd /k
