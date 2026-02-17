@echo off
setlocal DisableDelayedExpansion

REM =========================
REM AutoWipe NAS Launcher
REM =========================

REM --- Require admin so NAS auth + app run in same elevated context ---
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%ComSpec%' -ArgumentList '/c ""%~f0""' -Verb RunAs"
    exit /b
)

REM --- NAS settings ---
set "NAS_HOST=truenas"
set "NAS_SHARE=TD_NAS"
set "NAS_ROOT=\\%NAS_HOST%\%NAS_SHARE%"
set "APP_DIR=%NAS_ROOT%\Autowipe"
set "APP_PS1=%APP_DIR%\autowipe_v4.5.ps1"

REM --- Credentials ---
set "NAS_USER=tdnas"
set "NAS_PASS=Luckykid!23"

echo [INFO] Connecting to %NAS_ROOT% ...
net use "%NAS_ROOT%" /delete /y >nul 2>&1
net use "%NAS_ROOT%" /user:%NAS_USER% "%NAS_PASS%" /persistent:no >nul 2>&1
if errorlevel 1 (
    echo [ERROR] NAS authentication failed for %NAS_ROOT%.
    pause
    exit /b 1
)

if not exist "%APP_PS1%" (
    echo [ERROR] App not found: %APP_PS1%
    pause
    exit /b 1
)

set "AUTOWIPE_MACHINE_ROOT=%NAS_ROOT%\Autowipe\machines\%COMPUTERNAME%"

echo [INFO] Launching AutoWipe from NAS...
pushd "%APP_DIR%" || (
    echo [ERROR] Could not switch to %APP_DIR%
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%APP_PS1%"
set "APP_EXIT=%errorlevel%"
popd

exit /b %APP_EXIT%
