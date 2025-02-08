echo [MACRO]AddEnvVar %*

for /f "tokens=2*" %%a in ('reg query "HKLM\Tmp_DEFAULT\Environment" /v "Path"') do (
  reg add "HKLM\Tmp_DEFAULT\Environment" /v "Path" /t REG_SZ /d "%%b;%1" /f
)
