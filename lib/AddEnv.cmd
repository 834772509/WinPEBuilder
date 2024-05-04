rem 宏: 增加环境变量

rem 用法：AddEnv %X%\Windows\tools

echo [MACRO]AddEnvVar %*

for /f "tokens=2*" %%a in ('reg query "HKLM\Tmp_DEFAULT\Environment" /v "Path"') do (
  reg add "HKLM\Tmp_DEFAULT\Environment" /v "Path" /t REG_SZ /d "%%b;%1" /f
)
