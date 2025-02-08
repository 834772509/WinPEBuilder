@echo off
if "x%~1"=="x" goto :EOF
set "project_path=%~1"

if exist "%project_path%\main.cmd" (
    echo \033[93;46m [执行] %project_path%\main.cmd | CmdColor.exe
    pushd "%project_path%"
    call "%project_path%\main.cmd" || (
        echo 调用"%project_path%\main.cmd"失败
    )
    popd
)

for /d %%i in ("%project_path%\*") do (
    if exist "%%i\main.cmd" (
        echo \033[93;46m [执行] %%i\main.cmd | CmdColor.exe
        pushd "%%i"
        call "%%i\main.cmd" || (
            echo 调用"%%i\main.cmd"失败
        )
        popd
    )
)

for /d %%i in ("%project_path%\*") do (
    if exist "%%i\last.cmd" (
        echo \033[93;46m [执行] %%i\last.cmd | CmdColor.exe
        pushd "%%i"
        call "%%i\last.cmd" || (
            echo 调用"%%i\last.cmd"失败
        )
        popd
    )
)
