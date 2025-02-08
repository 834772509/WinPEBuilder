rd /s /q %X%\Windows\WinSxs

wimlib-imagex.exe extract "%APP_BASE_PATH%" %APP_BASE_INDEX% @"%~dp0SlimWinSxSList.txt" --dest-dir="%X%" --no-acls --nullglob
