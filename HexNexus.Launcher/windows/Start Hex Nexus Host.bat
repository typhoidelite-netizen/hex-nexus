@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Start-HexNexusHost.ps1"
if errorlevel 1 (
    echo.
    echo Hex Nexus could not start. Please send a screenshot of this window.
    pause
)
endlocal

