@echo off

setlocal enableDelayedExpansion

set UNINSTALL_REG_KEY1=HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall
set UNINSTALL_REG_KEY2=HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
set JAVA_TOOLS_DIR=C:\Java\Tools
set TOOLS_DIR=c:\Tools

call :check_command_in_path_with_call 7za.exe 1 1-4
call :check_uninstall_key "7-Zip"
call :check_tool_pattern apache-jmeter-* "Apache JMeter"
call :check_java_tool_junction apache-maven
echo Maven Notifier ?
call :check_uninstall_key "AutoHotkey"
call :check_command_in_path baretail.exe
call :check_tool_pattern burp\burpsuite_pro_*.jar "Burp Suite Pro"
call :check_uninstall_key {4D753458-961F-45DA-B5E3-7B44D4E368B4}_is1 "CNTLM"
echo cmder ?
call :check_command_in_path_with_call curl.exe 0 1-3 --version
echo Cygwin ? (c:\cygwin64\bin\uname -sor)
call :check_eclipse_version
echo EclEmma Java Code Coverage ?
echo Darkest Dark Theme ?
echo EasyShell ?
echo EPIC ?
echo FindBugs Feature ?
echo SonarLint for Eclipse ?
call :check_command_in_path_with_call emacs.exe 0 1-3 --version
call :check_gnuwin32_package coreutils
call :check_gnuwin32_package diffutils
call :check_gnuwin32_package grep
call :check_gnuwin32_package sed
call :check_gnuwin32_package wget
call :check_uninstall_key "GPL Ghostscript 9.21"

call :check_uninstall_key "GIMP-2_is1"
call :check_uninstall_key "Google Chrome"
call :check_uninstall_key "IBM MQ Explorer V9.0"
call :check_uninstall_key "ImageMagick 7.0.5 Q16 (64-bit)_is1"
call :check_uninstall_key "IrfanView64"
call :check_uninstall_key "Mozilla Firefox 54.0.1 (x86 en-US)"
call :check_uninstall_key "Network Password Manager"
call :check_uninstall_key "Notepad2"
call :check_uninstall_key {E3617D29-6D71-4B5C-B9E2-C927C705E317}_is1 "PDFtk"
call :check_command_in_path_with_call plink.exe 1 2
call :check_command_in_path_with_call pscp.exe 1 2
call :check_uninstall_key {E2B51919-207A-43EB-AE78-733F9C6797C2} "Python"
call :check_command_in_path_with_call rg.exe 0 1-2 --version
call :check_command_in_path_with_call ruby.exe 0 1-4 --version
call :check_uninstall_key {B93D1235-6D18-4602-9D8C-202B357D3327} "Slik SVN"
call :check_uninstall_key "SmartSVN c:/program files (x86)/smartsvn_is1"
call :check_uninstall_key 5517-2803-0637-4585 "SoapUI"
call :check_uninstall_key {4593B5F3-B1AE-4632-80ED-8DECC493A2C4} "Rakudo Perl"
call :check_uninstall_key {2F7B3B17-7104-1014-B6DC-867E31843670} "Strawberry Perl"
call :check_uninstall_key "Totalcmd64"
call :check_uninstall_key {43FE640D-34C4-4C52-B1D0-A36C2C0538B9} "Vagrant"
call :check_uninstall_key "VirtuaWin_is1"
call :check_uninstall_key {6487D3C0-8C39-4585-A44C-64DC40F22CB7} "VirtualBox"

endlocal

goto:eof

:check_command_in_path
for /f "usebackq" %%p in (`where %1`) do set where=%%p
echo %1 (%where%)
goto:eof

:check_command_in_path_with_call
for /f "usebackq" %%p in (`where %1`) do set where=%%p
set skip=
if %2 gtr 0 set skip=skip=%2
set tokens=tokens=%3
set command=%where%
if not "%4" == "" set command=%command% %4
for /f "usebackq %skip% tokens=*" %%a in (`%command%`) do set output=%%a&&goto:got_output
:got_output
for /f "%tokens% delims= " %%a in ("%output%") do set display_name=%%a %%b %%c %%d
set display_name=!display_name: %%d=!
set display_name=!display_name: %%c=!
set display_name=!display_name: %%b=!
if "%tokens:-=%" == "%tokens%" set display_name=%~n1 !display_name!
echo %display_name% (%where%)
goto:eof

:check_uninstall_key
set display_name=
set display_version=
set where=?
for /f "usebackq tokens=1,2,*" %%r in (`reg query "%UNINSTALL_REG_KEY1%\%~1" 2^>NUL`) do (
	if "%%r" == "DisplayName" set display_name=%%t
	if "%%r" == "DisplayVersion" set display_version=%%t
	if "%%r" == "InstallLocation" set where=%%t
)
if defined display_name goto:found_key
for /f "usebackq tokens=1,2,*" %%r in (`reg query "%UNINSTALL_REG_KEY2%\%~1" 2^>NUL`) do (
	if "%%r" == "DisplayName" set display_name=%%t
	if "%%r" == "DisplayVersion" set display_version=%%t
	if "%%r" == "InstallLocation" set where=%%t
)
:found_key
if defined display_version (
   echo "%display_name%" | findstr /C:"%display_version%" >NUL
   if %errorlevel% equ 0 set display_name="%display_name% %display_version%"
)
if not defined where set where=?
echo %display_name:"=% (%where%)
goto:eof


:check_tool_pattern
set fullpath=%TOOLS_DIR%\%1
set dirname=
for %%f in (%fullpath%) do set dirname=%%~dpf
for /f "usebackq" %%d in (`dir /b %fullpath%`) do set file=%%d
if defined dirname (
  set where=%dirname%%file%
) else (
  set where=%TOOLS_DIR%\%file%
)
if "%file:~-4%" == ".jar" set file=%file:~0,-4%
for /f "tokens=3 delims=_-" %%v in ("%file%") do set display_name=%~2 %%v
echo %display_name% (%where%)
goto:eof

:check_java_tool_junction
for /f "usebackq tokens=4,5 delims=[] " %%a in (`dir /al %JAVA_TOOLS_DIR% ^| findstr "<JUNCTION>"`) do if "%%a" == "%1" set where=%%b
for /f "tokens=3 delims=-" %%v in ("%where%") do set display_name=Apache Maven %%v
echo %display_name% (%where%)
goto:eof

:check_eclipse_version
set where=%TOOLS_DIR%\eclipse-oxygen
for /f "tokens=1,2 delims==" %%a in (%where%\.eclipseproduct) do (
	if %%a == name set display_name=%%b
	if %%a == version set display_name=!display_name! %%b
)
echo %display_name% (%where%)
goto:eof

:check_gnuwin32_package
set ver_file=
set where=%TOOLS_DIR%\gnuwin32
for /f "usebackq" %%f in (`dir /b %where%\manifest\%1-*-bin.ver`) do set ver_file=%%f
for /f "delims=:" %%a in (%where%\manifest\%ver_file%) do set ver_info=%%a&&goto:got_ver_info
:got_ver_info
for /f "tokens=1-2 delims=-" %%a in ("%ver_info%") do set display_name=%%a %%b
echo %display_name% (%where%)
goto:eof
