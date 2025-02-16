@echo off
set MATLAB=C:\MATLABR7a
set MSVCDir=c:\program files\microsoft visual studio 8\VC

"C:\MATLABR7a\rtw\bin\win32\envcheck" INCLUDE "c:\program files\microsoft visual studio 8\VC\platformsdk\include"
if errorlevel 1 goto vcvars32
"C:\MATLABR7a\rtw\bin\win32\envcheck" INCLUDE "c:\program files\microsoft visual studio 8\VC\include"
if errorlevel 1 goto vcvars32
"C:\MATLABR7a\rtw\bin\win32\envcheck" PATH "c:\program files\microsoft visual studio 8\VC\bin"
if errorlevel 1 goto vcvars32
goto make

:vcvars32
set VSINSTALLDIR=c:\program files\microsoft visual studio 8
set VCINSTALLDIR=c:\program files\microsoft visual studio 8\VC
set FrameworkSDKDir=c:\program files\microsoft visual studio 8\SDK\v2.0
set FrameworkDir=c:\program files\microsoft visual studio 8\Framework
call "C:\MATLABR7a\toolbox\rtw\rtw\private\vcvars32_800.bat"

:make
cd .
nmake -f RTex.mk  GENERATE_REPORT=0 ADD_MDL_NAME_TO_GLOBALS=1 VISUAL_VER=8.0
@if errorlevel 1 goto error_exit
exit /B 0

:error_exit
echo The make command returned an error of %errorlevel%
An_error_occurred_during_the_call_to_make
