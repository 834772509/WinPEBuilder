for /d %%i in ("%~dp0\*") do (
  if exist "%%i\main.cmd" (
    echo [执行] 子模块:%%~nxi
    pushd "%%i"
    call "%%i\main.cmd"
    popd
  )
)
