@echo on
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
if "%COMPCODE%" == "" goto edcodeerror
set EDCODE=%COMPCODE%
if "%EDCODE%" == "F95" set EDCODE=DOS
if "%EDCODE%" == "WXS" set EDCODE=GID

cd %CRYSBUILD%
mkdir script
mkdir errors

FOR %%I IN ( %CRYSSRC%\scriptsrc\*.ssc ) DO call buildfile.bat %%~nI
FOR %%I IN ( %CRYSSRC%\scriptsrc\*.sda ) DO call buildfile.bat %%~nI


cd %CRYSBUILD%

echo The following files (if any) are present in the source,
echo but have not been created - check SCRIPT.BAT
fc %CRYSSRC%\scriptsrc\*.ssc script\*.scp |grep -i "no such"
fc %CRYSSRC%\scriptsrc\*.sda script\*.dat |grep -i "no such"

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
rem Revision 1.49  2002/02/15 11:37:13  ckp2
rem Oops. This one builds the dat files, aswell as the scripts.
rem
rem Revision 1.48  2002/02/15 11:35:54  ckp2
rem Now we all have NT, this batch file can be used. It no longer requires
rem the names of all the script to be built, but just builds everything in
rem scriptsrc.
rem
rem Revision 1.45  2002/01/17 17:26:16  Administrator
rem Add refinf
rem
rem Revision 1.44  2002/01/16 10:27:35  ckpgroup
rem SH: Added xfovsfc.
rem
rem Revision 1.43  2001/12/18 14:09:43  ckp2
rem BUild new script files.
rem
rem Revision 1.42  2001/11/23 08:54:33  ckp2
rem Build sum.scp
rem
rem Revision 1.41  2001/10/04 10:54:55  Administrator
rem add cannonical numbering and structinf
rem
rem Revision 1.40  2001/09/26 07:08:38  ckp2
rem Added xvis to build.
rem
rem Revision 1.39  2001/09/12 13:29:29  Administrator
rem Add regularise sub-script XREGD
rem
rem Revision 1.38  2001/09/11 11:18:33  ckp2
rem *** empty log message ***
rem
rem Revision 1.37  2001/09/11 09:27:50  ckp2
rem *** empty log message ***
rem
rem Revision 1.36  2001/09/07 14:31:30  ckp2
rem *** empty log message ***
rem
rem Revision 1.35  2001/08/15 07:59:04  ckp2
rem Some new scripts.
rem
rem Revision 1.34  2001/07/26 12:53:14  ckp2
rem xncycles and xbench were missing from the batch file.
rem
rem Revision 1.33  2001/07/25 15:09:58  ckp2
rem Build untwin and xrotax scripts.
rem
rem Revision 1.32  2001/07/19 08:11:37  ckp2
rem Build xcwindow.
rem
rem Revision 1.31  2001/06/11 15:22:24  richard
rem Removed some obsolete scripts from build.
rem
rem Revision 1.30  2001/06/11 15:11:51  richard
rem New/renamed scripts
rem
rem Revision 1.29  2001/04/19 07:54:25  CKP2
rem add in xnstyle
rem
rem Revision 1.28  2001/04/18 16:12:47  richard
rem Nextfree
rem
rem Revision 1.27  2001/03/30 10:19:31  richard
rem Script xsplit checks that an atom is anisotropic before attempting
rem to split it. Prints warning otherwise.
rem
rem Revision 1.26  2001/03/28 11:07:21  richard
rem Build the quiz scripts and data.
rem
rem Revision 1.25  2001/03/28 09:16:39  richard
rem xfoptwt and xfsqwt
rem
rem Revision 1.24  2001/03/27 15:12:19  richard
rem xqmerge.
rem
rem Revision 1.23  2001/03/26 16:48:15  richard
rem Added addtwin.
rem
rem Revision 1.22  2001/03/26 10:51:01  richard
rem *** empty log message ***
rem

:exit

