@echo off

setlocal enableDelayedExpansion

echo.

for /f "usebackq tokens=4" %%d in (`wmic logicaldisk get description^,name ^| findstr /c:"Local"`) do (
    set drive=%%d
    for /f "usebackq tokens=3-5" %%a in (`dir !drive!\ ^| findstr /c:"bytes free"`) do echo !drive! %%a %%b %%c
)

endlocal
