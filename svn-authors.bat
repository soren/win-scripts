@echo off

setlocal

set me=%~nx0

if "%~1" == "-a" set AUTHOR_SORT=true&&shift
if "%~1" == "" goto args_count_ok

echo USAGE: %me% [-a]
echo.
echo Where
echo    -a sort by author (default sort by number of commits)
exit /b 1

:args_count_ok

if defined AUTHOR_SORT goto:author_sort
svn log --quiet | perl -anE "chomp;next if/^-/; $A{lc((split/ \| /,$_)[1])}+=1; END{say $_.':'.$A{$_} for sort {$A{$b}<=>$A{$a}} keys %%A}"
goto :finito

:author_sort
svn log --quiet | perl -anE "chomp;next if/^-/; $A{(split/ \| /,$_)[1]}+=1; END{say $_.':'.$A{$_} for sort keys %%A}"

:finito
endlocal
