echo [MACRO]AddEnvVar %*

setlocal enabledelayedexpansion
set "raw_path=%~1"

set "replace_list=%%X_PF%%=X:\Program Files;%%X_PF(x86)%%=Program Files (x86);%%X_WIN%%=X:\Windows;%%X_SYS%%=X:\Windows\System32;%%X_WOW64%%=X:\Windows\SysWOW64;%%X%%=X:"
for %%m in ("!replace_list:;=" "!") do (
  for /f "tokens=1,2 delims==" %%a in (%%m) do set "raw_path=!raw_path:%%a=%%b!"
)

for /f "tokens=2*" %%a in ('reg query "HKLM\Tmp_DEFAULT\Environment" /v "Path" 2^>nul') do (
  reg add "HKLM\Tmp_DEFAULT\Environment" /v "Path" /t REG_SZ /d "%%b;!raw_path!" /f
)
endlocal
