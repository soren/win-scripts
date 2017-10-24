@echo off

setlocal enableDelayedExpansion

set PATH=C:\HashiCorp\Vagrant\bin;%PATH%

if "%1" == "connect" goto:connect
vagrant %*
goto:finito

:connect
echo Checking status of virtual machine...
for /f "usebackq tokens=2" %%s in (`vagrant status ^| findstr /R ^^^^d.*`) do set status=%%s

if not "%status%" == "running" echo Virtual Machine isn't running, please call 'vagrant up' first&&goto:finito

echo Getting SSH Configuration...
for /f "usebackq tokens=1,2 delims= " %%a in (`vagrant ssh-config`) do (
    if %%a == HostName set host=%%b
    if %%a == User set user=%%b
    if %%a == Port set port=%%b
    if %%a == IdentityFile set key=%%b
)

echo Starting: PuTTY %user%@%host% -P %port% -i "%key%.ppk"
start putty %user%@%host% -P %port% -i "%key%.ppk"

:finito

endlocal
