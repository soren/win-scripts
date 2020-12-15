@echo off

setlocal enableExtensions enableDelayedExpansion

rem we need year, month and day later when deleting old backups

if "%date:~4,1%"=="-" (
   set year=%date:~0,4%
   set month=%date:~5,2%
   set day=%date:~8,2%
) else (
   set year=%date:~6,4%
   set month=%date:~3,2%
   set day=%date:~0,2%
)
set today=%year%-%month%-%day%

echo Today is %today%


rem how many days do we keep a backup

set day_diff=3
if %day:~0,1%==0 set day=%day:~1%

echo the date %day_diff% days ago was:

rem calculate date of backup from %day_diff% days ago

if %day% leq %day_diff% (

   rem find last day of previous month
   set new_day=31
   echo %month%|findstr >nul /r "\<0[57]\> \<1[02]\>"&&set new_day=30
   if %month%==03 set new_day=28

   rem if previous month is february adjust last day if leap year
   if !new_day!==28 call :is_leap_year %year%
   if %ERRORLEVEL% equ 1 set new_day=29

   set /a day_diff=%day_diff%-1
   if !day_diff! gtr 0 set /a new_day=!new_day!-!day_diff!

   if %month%==01 (
      set new_month=12
      set /a new_year=%year%-1
   ) else (
      set /a new_month=%month%-1
      if !new_month! lss 10 set new_month=0!new_month!
      set new_year=%year%
   )

) else (
  set /a new_day=!day!-%day_diff%
  if !new_day! lss 10 set new_day=0!new_day!
  set new_month=%month%
  set new_year=%year%
)

echo %new_year%-%new_month%-%new_day%

endlocal

rem end

goto :eof


:is_leap_year

rem if year is divisible by 400 then it's a leap year
set /a div=%1%%400
if %div%==0 exit /b 1

rem else if year is divisible by 100 then it's not a leap year
set /a div=%1%%100
if %div%==0 exit /b 0

rem else if year is divisible by 4 then it's a leap year
set /a div=%1%%4
if %div%==0 exit /b 1

rem else is's not a leap year
exit /b 0
