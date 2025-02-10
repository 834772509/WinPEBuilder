rem 执行当前目录的全部脚本
for %%i in (*.cmd) do (
  if /i not "%%i"=="%~nx0" (
    echo 执行: %%~nxi
    call "%%i"
  )
)