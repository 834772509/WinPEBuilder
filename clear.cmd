@echo off
cd /d "%~dp0"

set "X=%cd%\target\mounted"
set "SRC_PATH=%cd%\target\install"
set "APP_TMP_PATH=%cd%\target\temp"
set "PROJECT_PATH=%cd%\projects\%PROJECT_NAME%"
set "BUILD_WIM=%cd%\target\boot.wim"

rem 卸载注册表
reg unload HKLM\Src_SOFTWARE
reg unload HKLM\Src_SYSTEM
reg unload HKLM\Src_DEFAULT
reg unload HKLM\Src_DRIVERS

reg unload HKLM\Tmp_SOFTWARE
reg unload HKLM\Tmp_SYSTEM
reg unload HKLM\Tmp_DEFAULT
reg unload HKLM\Tmp_DRIVERS

rem 卸载基础镜像......
Dism /Unmount-Image /MountDir:"%cd%\target\mounted" /discard

rem 清理文件
rd /s /q "%SRC_PATH%"
rd /s /q "%X%"
rd /s /q "%APP_TMP_PATH%"
del /A /F /Q "%cd%\target\winre.wim"
del /A /F /Q "%cd%\target\base.wim"
