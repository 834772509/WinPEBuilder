rem 宏: 增加文件
rem 分析语法, 通过文件列表删除文件

rem 用法：
rem 单行增加文件
rem   call AddFiles \Windows\System32\config\SOFTWARE
rem   call AddFiles \Windows\System32\dm*.dll
rem   call AddFiles "\windows\system32\devmgmt.msc,devmgr.dll"

rem 多行增加文件
rem   call AddFiles %0 :end_files
rem   goto :end_files
rem   ; Explorer
rem   \Windows\explorer.exe
rem   \Windows\??-??\explorer.exe.mui
rem   ; ...
rem   :end_files

echo [MACRO]AddFiles %*
if "x%APP_TMP_PATH%"=="x" goto :EOF
setlocal enabledelayedexpansion

if "x%ADDFILES_INITED%"=="x" (
  wimlib-imagex.exe dir "%APP_SRC%" %APP_SRC_INDEX% --path=\Windows\System32\%APP_PE_LANG%\ >"%APP_TMP_PATH%\AddFiles_SYSMUI.txt"
  wimlib-imagex.exe dir "%APP_SRC%" %APP_SRC_INDEX% --path=\Windows\SysWOW64\%APP_PE_LANG%\ >>"%APP_TMP_PATH%\AddFiles_SYSMUI.txt"
  rem *.mun files present from 19H1
  if exist "%X%\Windows\SystemResources\shell32.dll.mun" (
    wimlib-imagex.exe dir "%APP_SRC%" %APP_SRC_INDEX% --path=\Windows\SystemResources\ >"%APP_TMP_PATH%\AddFiles_SYSRES.txt"
  )
)

type nul>"%APP_TMP_PATH%\AddFiles.txt"

if "%~2"=="" (
  set code_file=
  set code_word=%1
) else (
  set code_file=%~1
  set code_word=%2
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
    set line=%%i

    if /i "!line!"=="!strStartCode!" (
      set bCode=1
    ) else (
      if /i "!line!"=="!strEndCode!" goto :end
      if !bCode!==1 call :parser "!line!"
    )
  )
)
:end

rem extract AddFiles.txt to mounted directory with wimlib
wimlib-imagex.exe extract %APP_SRC% %APP_SRC_INDEX% @"%APP_TMP_PATH%\AddFiles.txt" --dest-dir="%X%" --no-acls --nullglob
goto :EOF

:parser
set line=%~1

rem empty line
if "%line%"=="" goto :EOF

rem comment line
if "%line:~0,1%"==";" goto :EOF

rem mutil lines
if "%line:~-1,1%"=="\" set "g_path=%line%" && goto :EOF

set output=
for /f "delims=" %%F in ("%line%") do (
  call :addfile %%F
)
goto :EOF

:addfile
set fn=%1

if not "%fn:~0,1%"=="\" set fn=%g_path%%fn%
echo %output%%fn%>>"%APP_TMP_PATH%\AddFiles.txt"

for %%F in ("%fn%") do set "name=%%~nxF"

rem append mui file
set muifile=
if /i "%fn:~0,18%"=="\Windows\System32\" set "muifile=\Windows\System32\%APP_PE_LANG%\%name%.mui"
if /i "%fn:~0,18%"=="\Windows\SysWOW64\" set "muifile=\Windows\SysWOW64\%APP_PE_LANG%\%name%.mui"
if not "%muifile%"=="" (
  findstr /i /c:"%muifile%" "%APP_TMP_PATH%\AddFiles_SYSMUI.txt">nul && echo %output%%muifile%>>"%APP_TMP_PATH%\AddFiles.txt"
)

rem append mun file
if /i "%fn:~0,18%"=="\Windows\System32\" (
  set "munfile=\Windows\SystemResources\%name%.mun"
  findstr /i /c:"!munfile!" "%APP_TMP_PATH%\AddFiles_SYSRES.txt">nul && echo %output%%munfile%>>"%APP_TMP_PATH%\AddFiles.txt"
) 

goto :EOF
