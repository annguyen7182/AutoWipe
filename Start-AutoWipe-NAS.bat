@echo off
setlocal DisableDelayedExpansion

REM =========================
REM AutoWipe NAS Launcher
REM =========================

set "LOG_FILE=%~dp0Start-AutoWipe-NAS.log"
2>nul (>>"%LOG_FILE%" echo.) || set "LOG_FILE=%TEMP%\Start-AutoWipe-NAS.log"
call :Log "[INFO] ------------------------------------------------------------"
call :Log "[INFO] AutoWipe NAS launcher starting..."
call :Log "[INFO] Log file: %LOG_FILE%"
call :Log "[INFO] Script path: %~f0"

where powershell.exe >nul 2>&1
if errorlevel 1 (
    call :Log "[ERROR] powershell.exe not found in PATH."
    pause
    exit /b 1
)
call :Log "[INFO] powershell.exe found."

REM --- Require admin so NAS auth + app run in same elevated context ---
net session >nul 2>&1
if not "%errorlevel%"=="0" (
    call :Log "[INFO] Non-admin token detected."
    call :Log "[INFO] Requesting Administrator permission..."
    call :Log "[INFO] ACTION REQUIRED: In 'Open File - Security Warning', click Run."
    call :Log "[INFO] ACTION REQUIRED: Then accept the UAC prompt."
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    set "ELEVATE_EXIT=%errorlevel%"
    call :Log "[INFO] Start-Process return code: %ELEVATE_EXIT%"
    if not "%ELEVATE_EXIT%"=="0" (
        call :Log "[ERROR] Elevation was cancelled or failed."
        pause
    ) else (
        call :Log "[INFO] Elevated instance launch requested successfully. Closing non-admin instance."
    )
    exit /b
)
call :Log "[INFO] Running with Administrator privileges."

REM --- NAS settings ---
set "NAS_HOST_PRIMARY=truenas"
set "NAS_HOST_FALLBACK=192.168.0.184"
set "NAS_SHARE=td_nas"

REM --- Credentials ---
set "NAS_USER=tdnas"
set "NAS_PASS=Luckykid!23"

call :ConnectAndSetRoot "%NAS_HOST_PRIMARY%"
if errorlevel 1 call :ConnectAndSetRoot "%NAS_HOST_FALLBACK%"
if errorlevel 1 (
    call :Log "[ERROR] Could not authenticate to NAS using hostname or IP."
    pause
    exit /b 1
)

if not exist "%APP_PS1%" (
    call :Log "[ERROR] App not found: %APP_PS1%"
    pause
    exit /b 1
)
call :Log "[INFO] App found: %APP_PS1%"

set "AUTOWIPE_MACHINE_ROOT=%NAS_ROOT%\Autowipe\machines\%COMPUTERNAME%"
call :Log "[INFO] AUTOWIPE_MACHINE_ROOT=%AUTOWIPE_MACHINE_ROOT%"

call :Log "[INFO] Launching AutoWipe from NAS..."
pushd "%APP_DIR%" || (
    call :Log "[ERROR] Could not switch to %APP_DIR%"
    pause
    exit /b 1
)
call :Log "[INFO] Working directory: %CD%"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%APP_PS1%"
set "APP_EXIT=%errorlevel%"
popd
call :Log "[INFO] AutoWipe process exit code: %APP_EXIT%"

if not "%APP_EXIT%"=="0" (
    call :Log "[ERROR] AutoWipe exited with code %APP_EXIT%."
    pause
)
if "%APP_EXIT%"=="0" call :Log "[INFO] AutoWipe exited normally."

exit /b %APP_EXIT%

:ConnectAndSetRoot
set "NAS_HOST=%~1"
set "NAS_ROOT=\\%NAS_HOST%\%NAS_SHARE%"
set "APP_DIR=%NAS_ROOT%\Autowipe"
set "APP_PS1=%APP_DIR%\autowipe_v4.5.ps1"

call :Log "[INFO] Connecting to %NAS_ROOT% ..."
net use "\\%NAS_HOST%\*" /delete /y >nul 2>&1
set "NETDEL_EXIT=%errorlevel%"
call :Log "[INFO] net use delete return code: %NETDEL_EXIT%"
net use "%NAS_ROOT%" /user:%NAS_USER% "%NAS_PASS%" /persistent:no >nul 2>&1
set "NETUSE_EXIT=%errorlevel%"
if not "%NETUSE_EXIT%"=="0" (
    call :Log "[WARN] NAS authentication failed for %NAS_ROOT% (code %NETUSE_EXIT%)."
    exit /b 1
)
call :Log "[INFO] NAS authentication succeeded for %NAS_ROOT%."

exit /b 0

:Log
set "LOG_MSG=%~1"
echo %LOG_MSG%
>>"%LOG_FILE%" echo [%DATE% %TIME%] %LOG_MSG%
exit /b 0
