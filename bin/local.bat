@echo off
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
if "%COMPCODE%" == "" goto edcodeerror
set EDCODE=%COMPCODE%
if "%EDCODE%" == "F95" set EDCODE=DOS
if "%EDCODE%" == "WXS" set EDCODE=GID
cd %CRYSBUILD%
mkdir errors
copy %CRYSSRC%\cryssrc\empty .
editor %CRYSSRC%\cryssrc\crystals.ssr crystals.srt code=%EDCODE% incl=+ excl=- comm=#  macro=empty strip
editor %CRYSSRC%\camsrc\cameron.ssr   cameron.srt  code=%EDCODE% incl=+ excl=- comm=#  macro=empty strip
editor %CRYSSRC%\camsrc\button.scm    script\button.cmn   code=%EDCODE% incl=+ excl=- comm=?? macro=empty strip
editor %CRYSSRC%\camsrc\colour.scm    script\colour.cmn   code=%EDCODE% incl=+ excl=- comm=?? macro=empty strip
editor %CRYSSRC%\camsrc\command.scm   script\command.cmn  code=%EDCODE% incl=+ excl=- comm=?? macro=empty strip
editor %CRYSSRC%\camsrc\genhelp.scm   script\genhelp.cmn  code=%EDCODE% incl=+ excl=- comm=?? macro=empty strip
editor %CRYSSRC%\camsrc\order.scm     script\order.cmn    code=%EDCODE% incl=+ excl=- comm=?? macro=empty strip
editor %CRYSSRC%\camsrc\prop.scm      script\prop.cmn     code=%EDCODE% incl=+ excl=- comm=?? macro=empty strip
editor %CRYSSRC%\camsrc\title.scm     script\title.cmn    code=%EDCODE% incl=+ excl=- comm=?? macro=empty strip
FOR %%I IN ( %CRYSSRC%\guisrc\*.ssr ) DO editor %%I %%~nI.srt code=%EDCODE% incl=+ excl=- comm=#  macro=empty strip

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
@rem $Log: not supported by cvs2svn $
@rem Revision 1.12  2003/09/19 18:01:19  rich
@rem Build all .ssr files in the guisrc directory into .srt's.
@rem
@rem Revision 1.11  2001/02/26 13:01:46  richard
@rem No longer copy bitmaps, they get copied in from precomp.
@rem
@rem Revision 1.10  2001/02/16 13:33:27  richard
@rem Removed rc93.srt building command. This file is in PRECOMP.
@rem
@rem Revision 1.9  2001/01/15 12:36:19  richard
@rem wxWindows
@rem
@rem Revision 1.8  2000/12/19 12:07:10  CKP2
@rem include include polaroid.bmp
@rem
@rem Revision 1.7  2000/12/11 11:59:30  richard
@rem RIC: copy the new ADDH bitmap files across
@rem
@rem Revision 1.6  2000/12/05 14:47:34  CKP2
@rem fix<CR>
@rem
@rem Revision 1.5  2000/11/03 11:01:27  csduser
@rem Include new files.
@rem
@rem Revision 1.4  2000/10/31 15:31:27  ckp2
@rem Fixed building of CMN files.
@rem
:exit
