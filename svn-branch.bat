@echo off

setlocal enabledelayedexpansion

set VERSION=0.1-win

set COMMAND=%1
if x%COMMAND% == xls set COMMAND=list
if x%COMMAND% == xsw set COMMAND=switch
if x%COMMAND% == xh set COMMAND=help
if x%COMMAND% == x? set COMMAND=help

echo %COMMAND%|findstr /b /e "list help switch" >NUL
if %ERRORLEVEL% gtr 0 goto :help

if %COMMAND% == help goto :usage

set REPO_ROOT=
for /f "usebackq tokens=3" %%i in (`svn 2^>NUL info^|findstr /c:"Repository Root:"`) do set REPO_ROOT=%%i

if not defined REPO_ROOT goto :not_svn_wc

if %COMMAND% == list (
    echo.
    echo [DIR] %REPO_ROOT%
    for /f "usebackq" %%i in (`svn ls %REPO_ROOT%`) do (
        echo   ^|
        echo   +---[DIR] %%i
        if %%i == branches/ for /f "usebackq" %%j in (`svn ls %REPO_ROOT%/%%i`) do echo   ^|     ^|&&echo   ^|     +---[DIR] %%j
    )
) else if %COMMAND% == switch (
    if x%2 == x goto :usage
    svn switch %REPO_ROOT%/branches/%2
)

goto :finito

:help
echo Type '%~n0 help' for usage.
goto :finito

:usage
if x%2 == x goto :no_usage_args

echo %2|findstr /b /e "help ? h" >NUL
if %ERRORLEVEL% equ 0 (
    echo help ^(?, h^): Describe the usage of this program or its subcommands.
    echo usage: help [SUBCOMMAND...]
    goto :finito
)

echo %2|findstr /b /e "list ls" >NUL
if %ERRORLEVEL% equ 0 (
    echo list ^(ls^): List directory entries in the repository root and branches directory if present.
    echo usage: list
    goto :finito
)

echo %2|findstr /b /e "switch sw" >NUL
if %ERRORLEVEL% equ 0 (
    echo switch ^(sw^): Update the working copy to a different URL.
    echo usage: switch BRANCH
    goto :finito
)

echo "%2": unknown command.
goto :finito

:no_usage_args
echo usage: %~n0 ^<subcommand^> [args]
echo Subversion Branch command-line client, version %VERSION%
echo Type '%~n0 help ^<subcommand^>' for help on a specific subcommand.
echo Type '%~n0 --version' to see the program version number.
echo.
echo Available subcommands:
echo.
echo    help (?, h)
echo    list (ls)
echo    switch (sw)
echo.
echo Subversion Branch is a tool for simpler branching in Subversion.
echo For additional information, see
goto :finito

:not_svn_wc
echo This directory does not seem to be under subversion control.
goto :finito

:finito
endlocal
