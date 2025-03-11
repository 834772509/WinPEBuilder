echo [MACRO]Extract2X %*

setlocal enabledelayedexpansion
set "raw_path=%~2"

set "replace_list=%%X_PF%%=X:\Program Files;%%X_PF(x86)%%=Program Files (x86);%%X_WIN%%=X:\Windows;%%X_SYS%%=X:\Windows\System32;%%X_WOW64%%=X:\Windows\SysWOW64"
for %%m in ("!replace_list:;=" "!") do (
  for /f "tokens=1,2 delims==" %%a in (%%m) do (
    set "raw_path=!raw_path:%%a=%%b!"
  )
)

7z x -aoa "%~1" -o"!raw_path!"

endlocal
