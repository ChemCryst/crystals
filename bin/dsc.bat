@echo off
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
if "%COMPCODE%" == "" goto edcodeerror
set EDCODE=%COMPCODE%
if "%EDCODE%" == "WXS" set EDCODE=GID
if "%EDCODE%" == "F95" set EDCODE=DOS

cd %CRYSBUILD%
mkdir errors

deltree /Y dscbuild
rmdir /q /s dscbuild
mkdir dscbuild
editor %CRYSSRC%\cryssrc\commands.ssr dscbuild\commands.src code=%EDCODE% incl=+ excl=- comm=#  macro=empty strip
copy %CRYSSRC%\cryssrc\crysdef.srt dscbuild\crystals.srt
cd %CRYSBUILD%\dscbuild
SETLOCAL
SET CRYSDIR=.\
SET USECRYSDIR=TRUE
start /w ..\crystalsd.exe
ENDLOCAL
cd %CRYSBUILD%
copy dscbuild\commands.dsc .
goto exit

:cryssrcerror
echo -----------------------------------------------------
echo Set CRYSSRC environment variable before running %0
echo e.g. SET CRYSSRC=c:\src 
echo -----------------------------------------------------
goto exit

:crysbuilderror
echo -----------------------------------------------------
echo Set CRYSSRC environment variable before running %0
echo e.g. SET CRYSSRC=c:\src 
echo -----------------------------------------------------
goto exit

:edcodeerror
echo ----------------------------------------------------------------
echo Set COMPCODE environment variable before running make.
echo type   SET COMPCODE=DOS    for FTN77 version.
echo type   SET COMPCODE=DVF    for text-only Digital Fortran version.
echo type   SET COMPCODE=F95    for FTN95 version.
echo type   SET COMPCODE=GID    for GUI version [Digital and Microsoft]
echo type   SET COMPCODE=LIN    for Linux Version [g77]
echo type   SET COMPCODE=GIL    for GUI version [Linux g77 and gcc]
echo ----------------------------------------------------------------
goto exit


:exit
