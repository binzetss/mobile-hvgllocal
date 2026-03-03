@echo off
REM Deploy Flutter Web to IIS - Windows Batch Script
REM Sửa IP_SERVER, USERNAME, PASSWORD trước khi chạy

setlocal enabledelayedexpansion

REM ============ CẤU HÌNH ============
set IP_SERVER=192.168.1.100
set USERNAME=Administrator
set REMOTE_PATH=\\!IP_SERVER!\c$\inetpub\wwwroot\hvgl
set LOCAL_BUILD=D:\Appmobilenoibo\hvgl\build\web

echo.
echo ================================
echo   Flutter Web Deploy to IIS
echo ================================
echo.

REM 1. Build
echo [1/4] Building Flutter web...
cd /d D:\Appmobilenoibo\hvgl
flutter build web --release

if errorlevel 1 (
    echo.
    echo [ERROR] Build failed!
    pause
    exit /b 1
)

echo [OK] Build successful!
echo.

REM 2. Copy files
echo [2/4] Copying files to server...
echo Source: !LOCAL_BUILD!
echo Destination: !REMOTE_PATH!
echo.

REM Check if destination exists
if exist "!REMOTE_PATH!" (
    echo [BACKUP] Backing up old files...
    for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
        set mydate=%%c%%a%%b
    )
    for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (
        set mytime=%%a%%b
    )
    set BACKUP_PATH=!REMOTE_PATH!_backup_!mydate!_!mytime!
    
    REM Create backup (requires robocopy or xcopy)
    robocopy "!REMOTE_PATH!" "!BACKUP_PATH!" /E /R:1 /W:1 >nul 2>&1
    if errorlevel 0 (
        echo [OK] Backup created: !BACKUP_PATH!
    )
    
    REM Clear destination
    echo [CLEAR] Clearing old files...
    for /d %%x in ("!REMOTE_PATH!\*") do (
        rd /s /q "%%x" 2>nul
    )
    del /q "!REMOTE_PATH!\*" 2>nul
)

REM Copy new files
xcopy "!LOCAL_BUILD!\*" "!REMOTE_PATH!\" /E /Y /I

if errorlevel 1 (
    echo.
    echo [ERROR] Copy failed! Check:
    echo   - Server is online
    echo   - Correct IP address: !IP_SERVER!
    echo   - Correct credentials
    echo   - Firewall allows SMB (port 445)
    pause
    exit /b 1
)

echo [OK] Files copied successfully!
echo.

REM 3. Copy web.config
echo [3/4] Copying web.config...
xcopy "D:\Appmobilenoibo\hvgl\web\web.config" "!REMOTE_PATH!" /Y /I >nul 2>&1

if errorlevel 0 (
    echo [OK] web.config copied!
)

echo.

REM 4. Info
echo [4/4] Done!
echo.
echo ================================
echo   Deployment Complete!
echo ================================
echo.
echo Next steps:
echo   1. Log in to server: !IP_SERVER!
echo   2. Run: iisreset
echo   3. Access: http://!IP_SERVER!
echo.
echo Important:
echo   - web.config must be at: C:\inetpub\wwwroot\hvgl\web.config
echo   - Run 'iisreset' if you see 404 errors
echo   - Check URL Rewrite module is installed
echo.

pause
