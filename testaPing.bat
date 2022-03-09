@echo off
cls
setlocal

ping -n 1 www.google.com | FindStr "TTL" >nul
if %errorlevel% equ 0 (
    echo "Available."
) || (
    echo "Not available."
)

endlocal

PAUSE