@echo off
title GitЭ������ v1.0
set "PATH=%~dp0\bin;%PATH%"

:menu
cls
echo.
echo   ============== GitЭ������ v1.0 ==============
echo.
echo        ��ѡ��Ҫִ�еĲ������������ֻس�����
echo.
echo        0. ��ʼ��Git�ֿ⣨ȫ����Ŀʱʹ�ã�
echo        1. ��ȡ���´��루ÿ�տ�ʼ����ǰ������
echo        2. �ύ�ҵĴ��루��ɹ�����ʹ�ã�
echo        3. �鿴��ǰ����״̬
echo        4. �����¹��ܷ�֧
echo        5. �л����з�֧
echo        6. ��ʾ����˵��
echo.
echo   ============================================
echo.

set /p choice=����������ѡ��
if "%choice%"=="0" goto init
if "%choice%"=="1" goto pull
if "%choice%"=="2" goto commit
if "%choice%"=="3" goto status
if "%choice%"=="4" goto newbranch
if "%choice%"=="5" goto switchbranch
if "%choice%"=="6" goto help

echo ������Ч������������
pause
goto menu

:init
cls
echo ���ڳ�ʼ��Git�ֿ�...
rd /s /q .git
git init
if %errorlevel% neq 0 (
    echo ��ʼ��ʧ�ܣ����鵱ǰĿ¼Ȩ��
    pause
    goto menu
)
git remote add origin https://github.com/834772509/WinPEBuilder
echo.
echo ��ʼ���ɹ�����������Ҫ��������Git�û���Ϣ
echo ��Щ��Ϣ�����ڼ�¼�����ύ��¼
echo.
:configure_user
set /p username=�����������ǳƣ������ύ��¼����
if "%username%"=="" (
    echo �ǳƲ���Ϊ�գ�����������
    goto configure_user
)
:configure_email
set /p email=�������������䣨�����ύ��¼����
if "%email%"=="" (
    echo ���䲻��Ϊ�գ�����������
    goto configure_email
)
echo.
echo ���������û���Ϣ...
git config user.name "%username%"
git config user.email "%email%"
echo.
echo ��ʼ���ɹ���
pause
goto menu

:pull
cls
echo ���ڴӷ�������ȡ���´���...
git pull
if %errorlevel% neq 0 (
    echo.
    echo ��ȡ����ʧ�ܣ�
    echo �밴���²��������
    echo 1. ������ȡ
    echo 2. ����ָ�������ͻ
)
pause
goto menu

:commit
cls
echo �������ύ˵���������������޸ģ������ļ��ɣ�
set /p message=�ύ˵����
echo.
echo ���ڱ�����뵽����...
git add .
git commit -m "%message%"
if %errorlevel% neq 0 (
    echo �ύʧ�ܣ������Ƿ��б����Ҫ�ύ
    pause
    goto menu
)

:push_attempt
echo.
echo �����ϴ���Github����ȷ�����糩ͨ...
git push
if %errorlevel% neq 0 (
    echo.
    echo �������ʹ��뵽Githubʧ�ܣ�
    echo ����ԭ��
    echo 1. �������Ӳ��ȶ�
    echo 2. û��Զ�ֿ̲�Ȩ��
    echo 3. Զ�ֿ̲���δ��ȡ���±��
    echo.
    choice /c YN /m "�Ƿ����������������ͣ�(Y/N)"
    if %errorlevel% equ 1 (
        cls
        goto push_attempt
    )
    echo.
    echo ����ԣ�
    echo 1. �Ժ��ֶ���������
    echo 2. ��ִ����ȡ���£��˵�ѡ��1��
    echo 3. ��ϵ����ԱЭ�����
) else (
    echo.
    echo �ύ�ɹ���������ͬ����������
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
echo �����¹��ܷ�֧�����ڿ����¹��ܣ�
echo ��֧�����淶���飺feature/����-����
set /p branch=�������·�֧���ƣ�
git checkout -b %branch%
echo ���л����·�֧��%branch%
pause
goto menu

:switchbranch
cls
echo ���л��ķ�֧�б�
git branch
echo.
set /p branch=������Ҫ�л��ķ�֧���ƣ�
git checkout %branch%
echo ���л�����֧��%branch%
pause
goto menu

:help
cls
echo =========== ʹ�ð��� ===========
echo.
echo ��ÿ�չ������̡�
echo 1. ��ʼ����ǰѡ1��ȡ���´���
echo 2. ��ɹ�����ѡ2�ύ��Ĵ���
echo.
echo ����֧ʹ�ù淶��
echo - ����֧��main/master����Ҫֱ���޸ģ�
echo - ���ܷ�֧��feature/����-����
echo - �����޸���hotfix/��������
echo.
echo ���ύ˵���淶��
echo ʾ��������32λ����֧��
echo ʾ�����޸�����������
echo.
echo ��������ͻ��ô�졿
echo ����ֹͣ��������ϵ�ŶӸ����ˣ�
pause
goto menu