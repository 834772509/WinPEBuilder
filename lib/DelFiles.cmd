echo [MACRO]DelFiles %*
setlocal enabledelayedexpansion

if "%~2"=="" (
  set "code_file="
  set "code_word=%~1"
) else (
  set "code_file=%~1"
  set "code_word=%2"
)

rem single line mode
if "%code_file%"=="" (
  for %%F in ("%code_word%") do set "g_path=%%~pF"
  call :parser "%code_word%"
)

rem multi line mode
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

goto :EOF

:parser
set "line=%~1"

rem empty line
if "%line%"=="" goto :EOF

rem comment line
if "%line:~0,1%"==";" goto :EOF

rem mutil lines
if "%line:~-1,1%"=="\" set "g_path=%line%" && goto :EOF

for %%a in ("%line:,=","%") do (
  set "part=%%~a"
  call :delfile "!part!"
)
goto :EOF

:delfile
set "fn=%~1"
if not "%fn:~0,1%"=="\" set "fn=%g_path%%fn%"
if not exist "%X%\%fn%" goto :EOF

dir/ad "%X%\%fn%" >nul 2>nul && (
  rem delete dir
  rd /s /q "%X%\%fn%"
)|| (
  rem delete file
  del /f /a /q "%X%\%fn%"

  for %%F in ("%fn%") do set "name=%%~nxF"
  rem delete mui file
  if /i "%fn:~0,18%"=="\Windows\System32\" del /f /a /q "%X%\Windows\System32\%APP_PE_LANG%\%name%.mui"2>nul
  if /i "%fn:~0,18%"=="\Windows\SysWOW64\" del /f /a /q "%X%\Windows\SysWOW64\%APP_PE_LANG%\%name%.mui"2>nul

  rem delete mun file
  if /i "%fn:~0,18%"=="\Windows\System32\" del /f /a /q "%X%\Windows\SystemResources\%name%.mun"2>nul
)

goto :EOF
