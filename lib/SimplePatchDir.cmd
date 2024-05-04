echo [MACRO]%~n0 %*

if not exist "%~1" goto :EOF

pushd "%~1"
for /f "delims=" %%i in ('dir /b *.cmd *.reg') do (
    echo Applying %~1\%%i ...
    if /i "%%~xi"==".cmd" call "%~1\%%i"
    if /i "%%~xi"==".reg" reg import "%~1\%%i"
)
popd
