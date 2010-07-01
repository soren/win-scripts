@echo off

if "x%1" == "x" goto usage
if not "x%2" == "x" goto usage 

cscript //B "%~dpn0.vbs" %*
goto :eof

:usage
echo %~nx0 ^<seconds^>
