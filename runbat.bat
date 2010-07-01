@echo off

setlocal

rem We need at least one argument
if "x%1" == "x" call :usage && goto :eof

rem The first argument should point to a script/program
if not exist "%1" call :file_not_found "%1" && goto :eof

rem The script must have a valid extension
echo %PATHEXT%; | findstr >NUL /I /C:"%~x1;"
if errorlevel 1 goto :not_executable "%1" && goto :eof

set logfile=%~dpn1.log

echo %1
echo %logfile%

endlocal

goto :eof

:usage
echo USAGE: %~nx0 ^<program/script name^> [arguments to program/script]
echo.
echo Runs the given program or script and sends its
echo output to a log file. The log file will be rolled.
echo.

goto :eof


:file_not_found
echo File not found: %1
echo.

goto :eof


:not_executable
echo File is not executable: %1
echo (Extention much match one of %PATHEXT%)
echo.

goto :eof
