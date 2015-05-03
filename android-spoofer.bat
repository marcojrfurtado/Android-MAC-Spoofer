@echo off
REM Written by Antonio Carlos Furtado

REM set default variables
SET ANDROID_SDK_TOOLS=
SET SPOOF_SCRIPT=.\device\spoof.sh
SET DEVICE_MACSPOOF_DATA_DIR=/sdcard/mac-spoof
SET DEVICE_MACSPOOF_SCRIPT_DIR=/data/local

REM collect arguments from command line
set RESTVAR=
:loop1
if "%1"=="" goto after_loop
set RESTVAR=%RESTVAR% %1
shift
goto loop1

:after_loop

REM Check where ADB.EXE is located
IF NOT '%ANDROID_HOME%'=='' (
	IF EXIST %ANDROID_HOME%\platform-tools\adb.exe (
		SET ANDROID_SDK_TOOLS=%ANDROID_HOME%\platform-tools\
	)
) 
REM IF variable is still empty
IF "%ANDROID_SDK_TOOLS%"=="" (
	SET ANDROID_SDK_TOOLS=.\sdk-tools\
)
set ADB_EXE=%ANDROID_SDK_TOOLS%\adb.exe

REM copy shell script to device
%ADB_EXE% push %SPOOF_SCRIPT% %DEVICE_MACSPOOF_DATA_DIR%/spoof.sh 2>nul
REM copy to root
%ADB_EXE% shell "su -c cp %DEVICE_MACSPOOF_DATA_DIR%/spoof.sh %DEVICE_MACSPOOF_SCRIPT_DIR%/"
REM make it executable
%ADB_EXE% shell "su -c chmod 755 %DEVICE_MACSPOOF_SCRIPT_DIR%/spoof.sh"

REM run script with arguments
%ADB_EXE% shell "su -c %DEVICE_MACSPOOF_SCRIPT_DIR%/spoof.sh %RESTVAR%"


EXIT /B 0