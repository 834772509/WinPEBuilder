@echo off
if "x%~1"=="x" goto :EOF
set "project_path=%~1"

if exist "%project_path%\main.cmd" (
    echo Applying Patch %project_path%\main.cmd
    pushd "%project_path%"
    call "%project_path%\main.cmd"
    popd
)

for /r "%project_path%" /d %%i in (*) do (
    if exist "%%i\main.cmd" (
        echo Applying Patch %%i\main.cmd
        pushd "%%i"
        call "%%i\main.cmd"
        popd
    )
    if exist "%%i\last.cmd" (
        echo Applying Patch %%i\last.cmd
        pushd "%%i"
        call "%%i\last.cmd"
        popd
    )
)
