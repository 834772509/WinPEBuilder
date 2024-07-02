rem 宏: 删除文件
rem 分析语法, 通过文件列表删除文件

rem 用法：
rem 单行删除文件
rem   call DelFiles \Windows\System32\winpe.jpg
rem   call DelFiles \Windows\System32\*.jpg
rem   call DelFiles "\windows\system32\winpe.jpg,winre.jpg"

rem 多行删除文件
rem   call DelFiles %0 :end_files
rem   goto :end_files
rem   ; 完整路径
rem   \Windows\System32\winpe.jpg
rem   \Windows\System32\winre.jpg
rem   ; 简写文件名
rem   \Windows\System32\
rem   winpe.jpg
rem   winre.jpg
rem   :end_files

echo [MACRO]DelFiles %*
setlocal enabledelayedexpansion

if "%~2"=="" (
  set "code_file="
  set "code_word=%~1"
) else (
  set "code_file=%1"
  set "code_word=%2"
)

if "%code_file%"=="" (
  for %%F in ("%code_word%") do set "g_path=%%~pF"
  call :parser "%code_word%"
) else (
  set "strStartCode=goto !code_word!"
  set "strEndCode=!code_word!"

  if "!code_word:~0,2!"==":[" (
    set "strStartCode=!code_word!"
    set "strEndCode=goto :EOF"
  )

  set bCode=0
  for /f "delims=" %%i in (!code_file!) do (
    set "line=%%i"

    if /i "!line!"=="!strStartCode!" (
      set bCode=1
    ) else (
      if /i "!line!"=="!strEndCode!" goto :EOF
      if !bCode!==1 call :parser "!line!"
    )
  )
)
goto :EOF

:parser
set "line=%~1"

rem empty line
if "%line%"=="" goto :EOF

rem comment line
if "%line:~0,1%"==";" goto :EOF

rem mutil lines
if "%line:~-1,1%"=="\" set "g_path=%line%" && goto :EOF

for %%F in (%line%) do call :delfile "%%F"
goto :EOF

:delfile
set "fn=%~1"
if not "%fn:~0,1%"=="\" set "fn=%g_path%%fn%"

rem delete file
del /f /a /q "%X%\%fn%" && (
  for %%F in ("%fn%") do set "name=%%~nxF"
  
  rem delete mui file
  if /i "%fn:~0,18%"=="\Windows\System32\" del /f /a /q "%X%\Windows\System32\%APP_PE_LANG%\%name%.mui"2>nul
  if /i "%fn:~0,18%"=="\Windows\SysWOW64\" del /f /a /q "%X%\Windows\SysWOW64\%APP_PE_LANG%\%name%.mui"2>nul

  rem delete mun file
  if /i "%fn:~0,18%"=="\Windows\System32\" del /f /a /q "%X%\Windows\SystemResources\%name%.mun"2>nul
)

goto :EOF
