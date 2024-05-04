rem 宏: 解压文件

echo [MACRO]Extract2X %*
7z x -aoa "%~1" -o"%~2"
