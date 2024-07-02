rd /s /q "%X%\sources"

rem 增补删除UUS文件夹（从 Win11 22458.1000 boot.wim 引入UUS文件夹）
rd /s /q %X%\Windows\UUS

rem 精简 System32下的语言文件夹
RD /S /Q %X%\Windows\System32\0409
RD /S /Q %X%\Windows\System32\ar-SA
RD /S /Q %X%\Windows\System32\bg-BG
RD /S /Q %X%\Windows\System32\cs-CZ
RD /S /Q %X%\Windows\System32\da-DK
RD /S /Q %X%\Windows\System32\de-DE
RD /S /Q %X%\Windows\System32\el-GR
RD /S /Q %X%\Windows\System32\en-GB
RD /S /Q %X%\Windows\System32\es-ES
RD /S /Q %X%\Windows\System32\es-MX
RD /S /Q %X%\Windows\System32\et-EE
RD /S /Q %X%\Windows\System32\fi-FI
RD /S /Q %X%\Windows\System32\fr-CA
RD /S /Q %X%\Windows\System32\fr-FR
RD /S /Q %X%\Windows\System32\he-IL
RD /S /Q %X%\Windows\System32\hr-HR
RD /S /Q %X%\Windows\System32\hu-HU
RD /S /Q %X%\Windows\System32\it-IT
RD /S /Q %X%\Windows\System32\ja-JP
RD /S /Q %X%\Windows\System32\ko-KR
RD /S /Q %X%\Windows\System32\lt-LT
RD /S /Q %X%\Windows\System32\lv-LV
RD /S /Q %X%\Windows\System32\nb-NO
RD /S /Q %X%\Windows\System32\nl-NL
RD /S /Q %X%\Windows\System32\pl-PL
RD /S /Q %X%\Windows\System32\pt-BR
RD /S /Q %X%\Windows\System32\pt-PT
RD /S /Q %X%\Windows\System32\ro-RO
RD /S /Q %X%\Windows\System32\ru-RU
RD /S /Q %X%\Windows\System32\sk-SK
RD /S /Q %X%\Windows\System32\sl-SI
RD /S /Q %X%\Windows\System32\sr-Latn-RS
RD /S /Q %X%\Windows\System32\sv-SE
RD /S /Q %X%\Windows\System32\th-TH
RD /S /Q %X%\Windows\System32\tr-TR
RD /S /Q %X%\Windows\System32\uk-UA
RD /S /Q %X%\Windows\System32\zh-TW

rem 增补对 Windows 11 语言文件夹的精简
RD /S /Q %X%\Windows\System32\ca-ES
RD /S /Q %X%\Windows\System32\eu-ES
RD /S /Q %X%\Windows\System32\gl-ES
RD /S /Q %X%\Windows\System32\id-ID
RD /S /Q %X%\Windows\System32\vi-VN

rem 精简 Windows下的文件夹
RD /S /Q %X%\Windows\AppCompat
RD /S /Q %X%\Windows\CbsTemp
RD /S /Q %X%\Windows\DiagTrack
RD /S /Q %X%\Windows\Help
RD /S /Q %X%\Windows\LiveKernelReports
RD /S /Q %X%\Windows\Microsoft.NET
RD /S /Q %X%\Windows\PLA
RD /S /Q %X%\Windows\PolicyDefinitions
RD /S /Q %X%\Windows\ServiceState
RD /S /Q %X%\Windows\Speech
RD /S /Q %X%\Windows\tracing
RD /S /Q %X%\Windows\WaaS
RD /S /Q %X%\Windows\en-US
RD /S /Q %X%\Windows\Logs
RD /S /Q %X%\Windows\schemas
RD /S /Q %X%\Windows\security
RD /S /Q %X%\Windows\Vss

rem 精简 Windows\Boot下的文件夹
RD /S /Q %X%\Windows\Boot\DVD
RD /S /Q %X%\Windows\Boot\EFI
RD /S /Q %X%\Windows\Boot\Misc
RD /S /Q %X%\Windows\Boot\PCAT
RD /S /Q %X%\Windows\Boot\PXE

rem 精简 System32 下的文件夹
RD /S /Q %X%\Windows\System32\AdvancedInstallers
RD /S /Q %X%\Windows\System32\catroot2
RD /S /Q %X%\Windows\System32\DiagSvcs
RD /S /Q %X%\Windows\System32\DriverState
RD /S /Q %X%\Windows\System32\GroupPolicy
RD /S /Q %X%\Windows\System32\GroupPolicyUsers
RD /S /Q %X%\Windows\System32\LogFiles
RD /S /Q %X%\Windows\System32\migration
RD /S /Q %X%\Windows\System32\MUI
RD /S /Q %X%\Windows\System32\oobe
RD /S /Q %X%\Windows\System32\RasToast
RD /S /Q %X%\Windows\System32\Recovery
RD /S /Q %X%\Windows\System32\restore
RD /S /Q %X%\Windows\System32\setup
RD /S /Q %X%\Windows\System32\SMI
RD /S /Q %X%\Windows\System32\Speech
RD /S /Q %X%\Windows\System32\spp
RD /S /Q %X%\Windows\System32\Sysprep
RD /S /Q %X%\Windows\System32\WindowsPowerShell
RD /S /Q %X%\Windows\System32\winevt
RD /S /Q %X%\Windows\System32\WCN
RD /S /Q %X%\Windows\System32\CatRoot\{127D0A1D-4EF2-11D1-8608-00C04FC295EE}

rem 精简 SysWOW64 下的文件夹
RD /S /Q %X%\Windows\SysWOW64\AdvancedInstallers
RD /S /Q %X%\Windows\SysWOW64\config
RD /S /Q %X%\Windows\SysWOW64\Dism
RD /S /Q %X%\Windows\SysWOW64\downlevel
RD /S /Q %X%\Windows\SysWOW64\drivers
RD /S /Q %X%\Windows\SysWOW64\DriverStore
RD /S /Q %X%\Windows\SysWOW64\migration
RD /S /Q %X%\Windows\SysWOW64\oobe
RD /S /Q %X%\Windows\SysWOW64\SMI
RD /S /Q %X%\Windows\SysWOW64\wbem
RD /S /Q %X%\Windows\SysWOW64\WCN

rem 精简System32_wbem文件夹
rd /s /q %X%\Windows\System32\wbem\AutoRecover
rd /s /q %X%\Windows\System32\wbem\Logs
rd /s /q %X%\Windows\System32\wbem\Repository
rd /s /q %X%\Windows\System32\wbem\tmf
rd /s /q %X%\Windows\System32\wbem\xml

rem 精简 Program Files 目录文件
rd /s /q "%X%\Program Files\Common Files\Microsoft Shared"
