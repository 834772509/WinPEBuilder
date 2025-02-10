# WinPEBuilder

## 简介

WinPEBuilder 是用于构建 WindowsPE 的批处理库，内含常用的宏命令，可快速实现对基础 boot.wim/winre.wim 进行修改。

## WinPE 项目

在 Project 目录中用于存放 WinPE 制作项目脚本，可创建多个目录表示不同的项目。

### 项目流程

1. 提取基础镜像(`boot.wim`/`winre.wim`)
2. 挂载基础镜像
3. 执行 WinPE 项目脚本（`\Project`）
4. 卸载基础镜像
5. 导出镜像及清理
6. 项目完成

### 注册表挂载路径

- 基础镜像：

  - `SOFTWARE`: `HKLM\Tmp_SOFTWARE`
  - `SYSTEM`: `HKLM\Tmp_SYSTEM`
  - `DEFAULT`: `HKLM\Tmp_DEFAULT`
  - `DRIVERS`: `HKLM\Tmp_DRIVERS`

- 安装镜像：

  - `SOFTWARE`: `HKLM\Src_SOFTWARE`
  - `SYSTEM`: `HKLM\Src_SYSTEM`
  - `DEFAULT`: `HKLM\Src_DEFAULT`
  - `DRIVERS`: `HKLM\Src_DRIVERS`

### 内置环境变量

WinPEBuilder 中内置了许多环境变量，可直接在脚本中进行使用。

- `%X%`: 基础镜像挂载目录
- `%X_WIN%`: `\Windows`目录
- `%X_SYS%`: `\Windows\System32`目录
- `%X_WOW64%`: `\Windows\SysWOW64`目录
- `%X_Desktop%`: `\Users\Default\Desktop`目录

### 脚本执行顺序

1. `Project\项目名称\main.cmd`
2. `Project\项目名称\`下的各个二级目录中的`main.cmd`
3. `Project\项目名称\`下的各个二级目录中的`last.cmd`

注意：仅执行二级目录的脚本，超过二级目录的脚本请在二级目录脚本中进行调用脚本。

### 常用脚本

- 执行当前目录下的全部脚本（除自身）

  ```batch
  for %%i in (*.cmd) do (
    if /i not "%%i"=="%~nx0" (
      echo 执行: %%~nxi
      call "%%i"
    )
  )
  ```

- 执行三级目录中的全部脚本

  ```batch
  for /d %%i in ("%~dp0\*") do (
    if exist "%%i\main.cmd" (
      echo [执行] 子模块:%%~nxi
      pushd "%%i"
      call "%%i\main.cmd"
      popd
    )
  )
  ```

## 宏指令

### AddFiles

增加文件，从 install 系统镜像中提取文件到基础镜像中。

- 单行模式示例（注意：多个文件需要使用引号包裹）

  ```batch
  call AddFiles \Windows\System32\config\SOFTWARE
  call AddFiles \Windows\System32\dm*.dll
  call AddFiles "\windows\system32\devmgmt.msc,devmgr.dll"
  ```

- 多行模式示例

  ```batch
  call AddFiles %0 :end_files
  goto :end_files

  ; Explorer
  \Windows\explorer.exe
  \Windows\zh-CN\explorer.exe.mui
  ; ...
  :end_files
  ```

### DelFiles

删除文件，从基础镜像中删除指定列表文件。

- 单行删除文件（注意：多个文件或文件中含有空格需要使用引号包裹）

  ```batch
  call DelFiles \Windows\System32\winpe.jpg
  call DelFiles \Windows\System32\*.jpg
  call DelFiles "\windows\system32\winpe.jpg,winre.jpg"
  ```

- 多行删除文件

  ```batch
  call DelFiles %0 :end_files
  goto :end_files

  ; 完整路径
  \Windows\System32\winpe.jpg
  \Windows\System32\winre.jpg
  ; 简写文件名
  \Windows\System32\
  winpe.jpg
  winre.jpg
  ; ...
  :end_files
  ```

### RegCopy

复制源镜像的注册表项至基础镜像 HKLM\Src_XXX => HKLM\Tmp_XXX

```batch
call RegCopy HKLM\System\ControlSet001\Services\NlaSvc
call RegCopy HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Winners *_microsoft.vc90.crt_*
```

### RegCopyEx

扩展复制源镜像的注册表项至基础镜像 HKLM\Src_XXX => HKLM\Tmp_XXX

```batch
call RegCopyEx Services NlaSvc
call RegCopyEx Services WPDBusEnum,WpdUpFltr,WudfPf,WUDFRd
call RegCopyEx Classes .msi
call RegCopyEx Classes Msi.Package,Msi.Path
```

### AddEnvVar

增加指定路径至环境变量

```batch
call AddEnv %X%\Windows\tools
```

### X2X

将当前目录中的`特定目录`内的所有文件复制到基础镜像中的指定位置，以下为特定目录所对应的路径。

- `X`: `\`
- `X_WIN`: `\Windows\`
- `X_SYS`: `\Windows\System32`
- `X_PF`: `\Program Files`
- `X_PF(x86)`: `\Program Files(x86)`
- `X_Desktop`: `\Users\Default\Desktop`

```batch
call X2X
```
