@echo off

if not exist %~dpn0.cmd (
  echo Unable to open configuration file.
  echo.
  echo You need to create a configuration file: %~dpn0.cmd
  echo.
  echo The file should contain lines like this:
  echo.
  echo set conn.#=computername:sharename:domainname:username-postfix
  echo.
  echo where # is 1,2,3...
  exit /b 1
)

setlocal enableDelayedExpansion

call %~dpn0.cmd

for /l %%i in (1,1,1000) do (
  call set conn=%%conn.%%i%%
  if not defined conn goto:no_more_connections
  for /f "tokens=1-4 delims=:" %%a in ("!conn!") do set computername=%%a&&set sharename=%%b&&set domainname=%%c&&set postfix=%%d
  net use /d \\!computername!\!sharename!
  echo Connnecting \\!computername!\!sharename! ...
  echo.
  net use \\!computername!\!sharename! /user:!domainname!\%USERNAME%!postfix!
  echo.
)

:no_more_connections

endlocal
