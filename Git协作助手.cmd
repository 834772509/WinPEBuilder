@echo off
title Git协作助手 v1.0
set "PATH=%~dp0\bin;%PATH%"

:menu
cls
echo.
echo   ============== Git协作助手 v1.0 ==============
echo.
echo        请选择要执行的操作（输入数字回车）：
echo.
echo        0. 初始化Git仓库（全新项目时使用）
echo        1. 拉取最新代码（每日开始工作前必做）
echo        2. 提交我的代码（完成工作后使用）
echo        3. 查看当前代码状态
echo        4. 创建新功能分支
echo        5. 切换现有分支
echo        6. 显示帮助说明
echo.
echo   ============================================
echo.

set /p choice=请输入数字选择：
if "%choice%"=="0" goto init
if "%choice%"=="1" goto pull
if "%choice%"=="2" goto commit
if "%choice%"=="3" goto status
if "%choice%"=="4" goto newbranch
if "%choice%"=="5" goto switchbranch
if "%choice%"=="6" goto help

echo 输入无效，请重新输入
pause
goto menu

:init
cls
echo 正在初始化Git仓库...
rd /s /q .git
git init
if %errorlevel% neq 0 (
    echo 初始化失败，请检查当前目录权限
    pause
    goto menu
)
git remote add origin https://github.com/834772509/WinPEBuilder
echo.
echo 初始化成功！接下来需要配置您的Git用户信息
echo 这些信息将用于记录代码提交记录
echo.
:configure_user
set /p username=请输入您的昵称（用于提交记录）：
if "%username%"=="" (
    echo 昵称不能为空，请重新输入
    goto configure_user
)
:configure_email
set /p email=请输入您的邮箱（用于提交记录）：
if "%email%"=="" (
    echo 邮箱不能为空，请重新输入
    goto configure_email
)
echo.
echo 正在配置用户信息...
git config user.name "%username%"
git config user.email "%email%"
echo.
echo 初始化成功！
pause
goto menu

:pull
cls
echo 正在从服务器获取最新代码...
git pull
if %errorlevel% neq 0 (
    echo.
    echo 拉取代码失败！
    echo 请按以下步骤操作：
    echo 1. 重新拉取
    echo 2. 根据指导解决冲突
)
pause
goto menu

:commit
cls
echo 请输入提交说明（描述你做的修改，用中文即可）
set /p message=提交说明：
echo.
echo 正在保存代码到本地...
git add .
git commit -m "%message%"
if %errorlevel% neq 0 (
    echo 提交失败，请检查是否有变更需要提交
    pause
    goto menu
)

:push_attempt
echo.
echo 正在上传到Github，请确保网络畅通...
git push
if %errorlevel% neq 0 (
    echo.
    echo 错误：推送代码到Github失败！
    echo 可能原因：
    echo 1. 网络连接不稳定
    echo 2. 没有远程仓库权限
    echo 3. 远程仓库有未拉取的新变更
    echo.
    choice /c YN /m "是否立即尝试重新推送？(Y/N)"
    if %errorlevel% equ 1 (
        cls
        goto push_attempt
    )
    echo.
    echo 你可以：
    echo 1. 稍后手动重新推送
    echo 2. 先执行拉取更新（菜单选项1）
    echo 3. 联系管理员协助解决
) else (
    echo.
    echo 提交成功！代码已同步到服务器
)
pause
goto menu

:status
cls
git status
pause
goto menu

:newbranch
cls
echo 创建新功能分支（用于开发新功能）
echo 分支命名规范建议：feature/姓名-功能
set /p branch=请输入新分支名称：
git checkout -b %branch%
echo 已切换到新分支：%branch%
pause
goto menu

:switchbranch
cls
echo 可切换的分支列表：
git branch
echo.
set /p branch=请输入要切换的分支名称：
git checkout %branch%
echo 已切换到分支：%branch%
pause
goto menu

:help
cls
echo =========== 使用帮助 ===========
echo.
echo 【每日工作流程】
echo 1. 开始工作前选1拉取最新代码
echo 2. 完成工作后选2提交你的代码
echo.
echo 【分支使用规范】
echo - 主分支：main/master（不要直接修改）
echo - 功能分支：feature/姓名-功能
echo - 紧急修复：hotfix/问题描述
echo.
echo 【提交说明规范】
echo 示例：增加32位程序支持
echo 示例：修复无声音问题
echo.
echo 【遇到冲突怎么办】
echo 立即停止操作并联系团队负责人！
pause
goto menu