@echo off
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
if "%COMPCODE%" == "" goto edcodeerror
set EDCODE=%COMPCODE%
if "%EDCODE%" == "F95" set EDCODE=DOS
if "%EDCODE%" == "WXS" set EDCODE=GID

cd %CRYSBUILD%

echo ...
echo Copying from %CRYSSRC%\precomp\all to %CRYSBUILD%
echo Only source files NEWER than destination will be copied.

xcopy %CRYSSRC%\precomp\all %CRYSBUILD% /S /D /F

echo Copying from %CRYSSRC%\precomp\%COMPCODE% to %CRYSBUILD%
echo Only source files NEWER than destination will be copied.

xcopy %CRYSSRC%\precomp\%COMPCODE% %CRYSBUILD% /S /D /F

echo Only source files NEWER than destination have been copied.
echo ...

echo ...
echo Creating temporary batch files so that you can run the
echo installation from the build directory.
call %CRYSBUILD%\writebat.bat %CRYSBUILD%\
echo ...
echo !!! D O N ' T   C L O S E   T H E   W I N D O W !!!
echo !!! D O N ' T   C L O S E   T H E   W I N D O W !!!
echo          That's for during installation only.
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

rem $Log: not supported by cvs2svn $
rem Revision 1.4  2004/05/19 15:00:00  rich
rem New precomp for windows platforms, using the new PRECOMP layout.
rem
rem Revision 1.3  2002/10/11 10:52:01  rich
rem Warning message for during build.
rem
rem Revision 1.2  2001/08/24 13:47:31  Administrator
rem remove trailing slash from precomp for win2000
rem
rem Revision 1.1  2001/02/16 13:29:14  richard
rem Copies pre-compiled files into the build directory to produce a working
rem system.
rem
rem Revision 1.16  2001/02/08 16:20:55  richard
rem Updated SCRIPT.BAT to build the new script HLAST.SCP.
rem
rem Revision 1.15  2001/01/15 12:37:02  richard
rem wxWindows support.
rem
rem Revision 1.14  2001/01/12 13:20:14  richard
rem Added "buildfile xkccdin".
rem
rem Revision 1.13  2001/01/11 17:08:24  richard
rem Added kccd to the list of scripts to be built.
rem
rem Revision 1.12  2000/12/19 12:11:36  CKP2
rem add Kccd and polaroid
rem
rem Revision 1.11  2000/12/13 14:11:48  richard
rem RIC: Add XWADDH to script building batch file.
rem
rem Revision 1.10  2000/12/11 12:24:25  richard
rem Previous version was corrupted by checking in a conflicting merged file. Sorry.
rem
rem Revision 1.9  2000/12/08 16:45:29  richard
rem Build ED30 script.
rem
rem Revision 1.8  2000/12/05 14:43:03  CKP2
rem *** empty log message ***
rem
rem Revision 1.7  2000/12/01 17:02:43  richard
rem Some new scripts to build
rem
rem Revision 1.6  2000/11/03 11:01:27  csduser
rem Include new files.
rem
rem Revision 1.5  2000/11/01 10:10:59  ckp2
rem New files + after compilation checks that all files are created.
rem

:exit

