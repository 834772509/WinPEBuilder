call X2X
ren "%X_PF%\WinXShell\WinXShell_%APP_PE_ARCH%.exe" WinXShell.exe
del /q "%X_PF%\WinXShell\WinXShell_*.exe"

if "x%APP_PE_LANG%"=="xzh-CN" (
    copy /y "%X_PF%\WinXShell\WinXShell.zh-CN.jcfg" "%X_PF%\WinXShell\WinXShell.jcfg"
    del /q "%X_PF%\WinXShell\WinXShell.zh-CN.*
)

reg add "HKLM\Tmp_DEFAULT\Software\Classes\Folder\shell" /ve /t REG_SZ /d "360FileBrowser" /f
reg add "HKLM\Tmp_DEFAULT\Software\Classes\Folder\shell\360FileBrowser" /ve /t REG_SZ /d "360文件夹打开" /f
reg add "HKLM\Tmp_DEFAULT\Software\Classes\Folder\shell\360FileBrowser\command" /ve /t REG_SZ /d "\"X:\Program Files\360FileBrowser\360FileBrowser.exe\" \"%%1\"" /f
reg add "HKLM\Tmp_DEFAULT\Software\Classes\Folder\shell\newwindow" /ve /t REG_SZ /d "在新窗口中打开(&E)" /f
reg add "HKLM\Tmp_DEFAULT\Software\Classes\Folder\shell\newwindow\command" /ve /t REG_SZ /d "\"X:\Program Files\360FileBrowser\360FileBrowser.exe\" /OpenInNewWindow \"%%1\"" /f
