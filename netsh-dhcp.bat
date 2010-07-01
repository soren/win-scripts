@echo off

setlocal

rem ---- Config interface ---------------------------------------
set interface=Local Area Connection
rem ----------------------------------------------------------------------

echo Deleting old DNS servers...
netsh interface ip delete dns "%interface%" all

echo Switching to DHCP...
netsh interface ip set address "%interface%" dhcp

netsh interface ip show config "%interface%"

endlocal
