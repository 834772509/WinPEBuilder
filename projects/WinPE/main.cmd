rem set "RunAs"="Interactive User" -* "RunAs"=""
echo REGEDIT4 > "%APP_TMP_PATH%\RunAsUpdateTmp.reg"
echo. >> "%APP_TMP_PATH%\RunAsUpdateTmp.reg"
for /F %%i IN ('Reg Query HKLM\Tmp_Software\Classes\AppID /s /f "Interactive User" ^|findstr Tmp_Software') do (
    echo [%%i]
    echo "RunAs"=""
) >> "%APP_TMP_PATH%\RunAsUpdateTmp.reg"
reg import "%APP_TMP_PATH%\RunAsUpdateTmp.reg"

echo Update registry (C:\ =^> X:\) ...
regfind -p HKLM\Tmp_Software -y C:\ -r X:\

rem set Tmp_Software everyone access
SetACL.exe -on "HKLM\Tmp_Software" -ot reg -actn setowner -ownr "n:Everyone" -rec yes -silent
SetACL.exe -on "HKLM\Tmp_Software" -ot reg -actn ace -ace "n:Everyone;p:full;m:grant;i:so,sc" -op DACL:p_c -rec yes -silent
