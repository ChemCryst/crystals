@echo Building manuals
@echo off
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
if "%COMPCODE%" == "" goto edcodeerror
set EDCODE=%COMPCODE%
if "%EDCODE%" == "F95" set EDCODE=DOS
if "%EDCODE%" == "WXS" set EDCODE=GID
cd %CRYSBUILD%
mkdir manual
cd %CRYSBUILD%\manual
perl -w %cryssrc%\manual\mangen.pl faq.man primer.man guide.man crystals.man cameron.man menu.man readme.man workshop.man
if NOT %ERRORLEVEL% == 0 goto exit

copy %CRYSBUILD%\manual\html\* %CRYSBUILD%\manual
copy %CRYSSRC%\manual\*.jpg %CRYSBUILD%\manual
copy %CRYSSRC%\manual\*.gif %CRYSBUILD%\manual
copy %CRYSSRC%\manual\*.css %CRYSBUILD%\manual

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
rem Revision 1.9  2003/03/26 10:39:08  rich
rem Moved mangen.pl into the manual subdirectory.
rem
rem Revision 1.8  2003/03/26 10:26:19  rich
rem Stop batch file on error in perl program.
rem
rem Revision 1.7  2002/04/03 12:44:31  richard
rem Changes to mangen for picture style. Added workshop.man to buildman.
rem
rem Revision 1.6  2002/02/28 14:12:40  ckp2
rem Update manual building program so that pictures may be included in the HTML output.
rem Put the name of the picture file (gif or jpg) after a #HI tag on a line by itself.
rem e.g. to include mypic.jpg #HImypic.jpg#. Put mypic.jpg into \relsrc\manual, add it
rem with the -kb flag (it is binary), and the commit it.
rem
rem Revision 1.5  2002/02/12 10:34:34  ckp2
rem Build two new manuals, menu.man and readme.man
rem
rem Revision 1.4  2002/01/31 13:38:39  ckp2
rem RIC: New graphics for the manual.
rem
rem Revision 1.3  2001/02/16 14:03:28  richard
rem
rem Copy pictures across from source to build.
rem
rem Revision 1.2  2001/02/16 13:23:58  richard
rem Check env first.
rem

:exit


