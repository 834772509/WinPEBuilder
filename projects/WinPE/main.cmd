echo 设置 Tmp_Software 为 everyone 权限
SetACL.exe -on "HKLM\Tmp_Software" -ot reg -actn setowner -ownr "n:Everyone" -rec yes -silent
SetACL.exe -on "HKLM\Tmp_Software" -ot reg -actn ace -ace "n:Everyone;p:full;m:grant;i:so,sc" -op DACL:p_c -rec yes -silent

echo 删除Interactive User（仅SYSTEM账户需要，否则资源管理器窗口无法打开）
regfind "Interactive User" -r "" -p "HKEY_LOCAL_MACHINE\Tmp_Software"

rem echo 更新注册表 (C:\ =^> X:\) ...
rem regfind -p HKLM\Tmp_Software -y C:\ -r X:\

@REM echo 正在更新文件ACL权限......
@REM takeown /f "%X%" /a /r /d y>nul
@REM icacls "%X%" /grant administrators:F /t>nul
