rem ==========补充注册表==========
call RegCopy HKLM\Software\Classes\Wow6432Node\CLSID

call RegCopy HKLM\Software\Classes\WOW6432Node\DirectShow
call RegCopy "HKLM\Software\Classes\WOW6432Node\Media Type"
call RegCopy HKLM\Software\Classes\WOW6432Node\MediaFoundation

call RegCopy HKLM\Software\Wow6432Node

call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SMI
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,x86_microsoft.windows.c..-controls.resources_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,x86_microsoft.windows.common-controls_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,wow64_microsoft.windows.gdiplus.systemcopy_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,x86_microsoft.windows.gdiplus_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,x86_microsoft.windows.i..utomation.proxystub_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,x86_microsoft.windows.isolationautomation_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,x86_microsoft.windows.systemcompatible_*
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners,x86_microsoft-windows-m..tion-isolationlayer_*

rem ==========补充文件=========

rem 清空WinRE自带文件
DEL /F /A /Q %X%\Windows\SysWOW64\*.*
DEL /F /A /Q %X%\Windows\SysWOW64\zh-CN\*.*

if not exist "%X%\Program Files (x86)\Common Files\" mkdir "%X%\Program Files (x86)\Common Files"

call AddFiles %0 :end_files
goto :end_files

; 添加32位程序支持System32下必需的文件
\Windows\System32\wow64.dll
\Windows\System32\wow64cpu.dll
\Windows\System32\wow64win.dll
\Windows\System32\ntdll.dll
\Windows\System32\TextShaping.dll
\Windows\System32\wowreg32.exe

; 增补的支持 Windows 11 的dll文件
\Windows\System32\wow64base.dll
\Windows\System32\wow64con.dll

; 添加32位程序支持SysWOW64下必需的文件
\Windows\SysWOW64\
actxprxy.dll
advapi32.dll
advpack.dll
AudioSes.dll
avicap32.dll
avifil32.dll
avrt.dll
bcrypt.dll
bcryptprimitives.dll
cabinet.dll
cfgmgr32.dll
chcp.com
cmd.exe
cmdext.dll
combase.dll
comdlg32.dll
coml2.dll
credui.dll
crypt32.dll
cryptbase.dll
cryptnet.dll
cryptsp.dll
cscapi.dll
DataExchange.dll
davhlpr.dll
dbgcore.dll
dbghelp.dll
dciman32.dll
ddraw.dll
devenum.dll
devobj.dll
devrtl.dll
dhcpcsvc.dll
dhcpcsvc6.dll
directmanipulation.dll
dllhost.exe
dnsapi.dll
dpapi.dll
dsound.dll
dsparse.dll
dsrole.dll
dui70.dll
duser.dll
dwmapi.dll
DWrite.dll
DXCore.dll
dxgi.dll
dxva2.dll
edputil.dll
ExplorerFrame.dll
fc.exe
find.exe
findstr.exe
fltLib.dll
FWPUCLNT.DLL
gdi32.dll
gdi32full.dll
glu32.dll
gpapi.dll
hid.dll
hlink.dll
icmp.dll
iertutil.dll
ifsutil.dll
imagehlp.dll
imm32.dll
IPHLPAPI.DLL
kernel.appcore.dll
kernel32.dll
KernelBase.dll
ksuser.dll
linkinfo.dll
mfc42.dll
mlang.dll
MMDevAPI.dll
mpr.dll
msacm32.dll
msacm32.drv
msasn1.dll
msctf.dll
msdelta.dll
msdmo.dll
msftedit.dll
msi.dll
msimg32.dll
msimtf.dll
msls31.dll
msvcp60.dll
msvcp_win.dll
msvcrt.dll
msvfw32.dll
mswsock.dll
msxml3.dll
msxml3r.dll
ncrypt.dll
ncryptsslp.dll
ndadmin.exe
netapi32.dll
netutils.dll
newdev.dll
nsi.dll
ntasn1.dll
ntdll.dll
ntdsapi.dll
ntmarta.dll
odbc32.dll
ole32.dll
oleacc.dll
oleaccrc.dll
oleaut32.dll
oledlg.dll
olepro32.dll
OnDemandConnRouteHelper.dll
opengl32.dll
pdh.dll
powrprof.dll
profapi.dll
propsys.dll
psapi.dll
rasadhlp.dll
rasapi32.dll
rasman.dll
reg.exe
regedt32.exe
regsvr32.exe
ResourcePolicyClient.dll
riched20.dll
riched32.dll
rpcrt4.dll
rsaenh.dll
rundll32.exe
samcli.dll
sc.exe
schannel.dll
sechost.dll
secur32.dll
SensApi.dll
setupapi.dll
sfc.dll
sfc_os.dll
SHCore.dll
shell32.dll
shellstyle.dll
shfolder.dll
shlwapi.dll
spfileq.dll
spinf.dll
srpapi.dll
srvcli.dll
sspicli.dll
stdole2.tlb
sxs.dll
t2embed.dll
TextShaping.dll
TextInputFramework.dll
traffic.dll
ucrtbase.dll
ulib.dll
umpdc.dll
urlmon.dll
user32.dll
userenv.dll
usp10.dll
uxtheme.dll
version.dll
wdmaud.drv
webio.dll
wimgapi.dll
win32u.dll
Windows.FileExplorer.Common.dll
windows.storage.dll
WindowsCodecs.dll
winhttp.dll
wininet.dll
winmm.dll
winmmbase.dll
winnlsres.dll
winnsi.dll
winspool.drv
winsta.dll
wintrust.dll
WinTypes.dll
wkscli.dll
Wldap32.dll
wldp.dll
wmiclnt.dll
ws2_32.dll
wsock32.dll
wtsapi32.dll
xcopy.exe
xmllite.dll

; 添加32位程序支持SysWOW64_zh-CN下必需的文件
\Windows\SysWOW64\zh-CN\
advpack.dll.mui
avicap32.dll.mui
avifil32.dll.mui
fwpuclnt.dll.mui
gpapi.dll.mui
hlink.dll.mui
iertutil.dll.mui
msacm32.drv.mui
msftedit.dll.mui
msvfw32.dll.mui
msxml3r.dll.mui
ntdll.dll.mui
reg.exe.mui
sxs.dll.mui
urlmon.dll.mui
user32.dll.mui
wimgapi.dll.mui
wldap32.dll.mui

; 添加32位程序支持SysWOW64_en-US下必需的文件
\Windows\SysWOW64\en-US\comctl32.dll.mui

; 添加32位程序支持 WinSxS
; //- Language without fallback language should be enough for WinSxS
\Windows\WinSxS\x86_microsoft.windows.c..-controls.resources_*_zh-CN*\*.*
\Windows\WinSxS\x86_microsoft.windows.common-controls*\*.*
\Windows\WinSxS\wow64_microsoft.windows.gdiplus.systemcopy_*\*.*
\Windows\WinSxS\x86_microsoft.windows.gdiplus_*\*.*
\Windows\WinSxS\x86_microsoft.windows.isolationautomation_*\*.*
\Windows\WinSxS\x86_microsoft.windows.i..utomation.proxystub_*\*.*
\Windows\WinSxS\x86_microsoft-windows-servicingstack_*\*.*

\Windows\WinSxS\manifests\x86_microsoft.windows.c..-controls.resources_*_zh-CN*.manifest
\Windows\WinSxS\Manifests\x86_microsoft.windows.common-controls_*.manifest
\Windows\WinSxS\Manifests\wow64_microsoft.windows.gdiplus.systemcopy_*.manifest
\Windows\WinSxS\Manifests\x86_microsoft.windows.gdiplus_*.manifest
\Windows\WinSxS\Manifests\x86_microsoft.windows.isolationautomation_*.manifest
\Windows\WinSxS\Manifests\x86_microsoft.windows.i..utomation.proxystub_*.manifest
\Windows\WinSxS\Manifests\x86_microsoft.windows.systemcompatible_*.manifest
\Windows\WinSxS\Manifests\x86_microsoft-windows-servicingstack_*.manifest

; 增补的支持 Windows 11 的声音文件
\Windows\SysWOW64\RESAMPLEDMO.DLL

:end_files
