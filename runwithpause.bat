@echo off

setlocal

rem We need at least one argument
if "x%1" == "x" call :usage && goto :eof

rem The first argument should point to a script/program
if not exist "%1" call :notfound "%1" && goto :eof

rem The extension should be a program/script (defined by 
rem the variable PATHEXT)

set ext=%~x1
set extlist=%PATHEXT%
set extok=yes
:checkext
for /F "delims=; tokens=1,*" %%x in ("%extlist%") do (
  if /I "%ext%" == "%%x" goto :extok
  set extlist=%%y
)
if not "x%extlist%" == "x" goto :checkext
set extok=no
:extok

if "%extok%" == "no" goto :wrongtype

set cmd=%*
echo Running %cmd% . . .
echo.
call %cmd%

pause

endlocal

goto :eof

:usage
echo USAGE: %~nx0 ^<program/script name^> [arguments to program/script]
echo.
echo Will run the given program og script and pause after
echo it completes.
echo.
pause
goto :eof

:notfound
echo File not found: %1
echo.
pause
goto :eof

:wrongtype
echo File is wrong type.
echo Must be one of %PATHEXT%
echo.
pause
goto :eof