rem ==========补充文件=========

rem Explorer BitLocker integration

rem full feature
rem call AddFiles "@\Windows\System32\#nbde*.exe,fve*.exe,bde*.dll,fve*.dll,BitLocker*.*,EhStor*.*"

call AddFiles "\Windows\System32\bdesvc.dll,bdeunlock.exe,fvenotify.exe,Windows.UI.Immersive.dll"
call AddFiles "\Windows\System32\bdeui.dll,fveapi.dll,fvecerts.dll,fveui.dll"
call AddFiles "\Windows\System32\StructuredQuery.dll,Windows.Storage.Search.dll"

rem ==========补充注册表==========

rem call RegCopy HKLM\System\ControlSet001\Services\BDESVC
call RegCopy HKLM\Software\Classes\Drive\shell\unlock-bde
reg add HKLM\Tmp_Software\Classes\Drive\shell\unlock-bde /v Icon /d bdeunlock.exe /f

rem remove unsupported menu
reg delete HKLM\Tmp_Software\Classes\Drive\shell\encrypt-bde-elev /f

rem fix menu
reg delete HKLM\Tmp_Software\Classes\Drive\shell\unlock-bde /v AppliesTo /f
reg delete HKLM\Tmp_Software\Classes\Drive\shell\unlock-bde /v DefaultAppliesTo /f

goto :EOF
