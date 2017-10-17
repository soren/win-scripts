@echo off

setlocal enableDelayedExpansion

set paths=%PATH%

:loop
	if "!paths!" == "" goto:finito
	
	for /f "delims=;" %%p in ("%paths%") do (
		set dir=%%p
		if not exist !dir!\NUL set dir=!dir! *Does NOT exist*
		echo !dir!
		if "%%p" == "!paths!" (
		   set paths=
		) else (
		   set paths=!paths:%%p;=!
		)
	)

goto:loop

:finito

endlocal
