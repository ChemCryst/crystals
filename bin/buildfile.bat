@echo on
@
@if "%CRYSSRC%" == "" goto cryssrcerror
@if "%CRYSBUILD%" == "" goto crysbuilderror
@if "%COMPCODE%" == "" goto edcodeerror
@set EDCODE=%COMPCODE%
@if "%EDCODE%" == "F95" set EDCODE=DOS
@rem @if "%EDCODE%" == "WXS" set EDCODE=GID
@set FILEFOUND=
@rem  Find the file:
@
@if "%1" == "" goto clerror
:restart
@
@rem CRYSSRC FORTRAN FILES
@if not exist %CRYSSRC%\cryssrc\%1.src goto next1
cd %CRYSBUILD%\code
@set SRCDIR=%CRYSSRC%\cryssrc
@call cryf.bat %1
@set FILEFOUND=OK
@
:next1
@rem GUISRC CPP FILES
@if not exist %CRYSSRC%\guisrc\%1.cpp goto next2
@cd %CRYSBUILD%\code
@set SRCDIR=%CRYSSRC%\guisrc
@call cryc.bat %1
@set FILEFOUND=OK
@
:next2
@rem SCRIPTSRC SCRIPT AND DATA FILES
@if not exist %CRYSSRC%\scriptsrc\%1.ssc goto next3
cd %CRYSBUILD%\script
@set SRCDIR=%CRYSSRC%\scriptsrc
@call crys.bat %1
@set FILEFOUND=OK
@
:next3
@rem SCRIPTSRC SCRIPT AND DATA FILES
@if not exist %CRYSSRC%\scriptsrc\%1.sda goto next4
cd %CRYSBUILD%\script
@set SRCDIR=%CRYSSRC%\scriptsrc
call crys.bat %1
@set FILEFOUND=OK
@
:next4
@rem CAMSRC FORTRAN FILES
@if not exist %CRYSSRC%\camsrc\%1.src goto check
cd %CRYSBUILD%\code
@set SRCDIR=%CRYSSRC%\camsrc
@call cryf.bat %1
@set FILEFOUND=OK
@
@
:check
@if "%FILEFOUND%" == "" goto fileerror
@if "%2" == "" goto exit
@shift
@goto restart

:clerror
@echo -----------------------------------------------------
@echo buildfile.bat requires a filename as an argument...
@echo -----------------------------------------------------
@goto exit
@
:fileerror
@echo -----------------------------------------------------
@echo File %1 not found in any source directories...
@echo -----------------------------------------------------
@echo File %1 not found in any directories >> %CRYSBUILD%\errors\missing.log
@goto exit
@
:cryssrcerror
@echo -----------------------------------------------------
@echo Set CRYSSRC environment variable before running %0
@echo e.g. SET CRYSSRC=c:\src 
@echo -----------------------------------------------------
@goto exit
@
:crysbuilderror
@echo -----------------------------------------------------
@echo Set CRYSSRC environment variable before running %0
@echo e.g. SET CRYSSRC=c:\src 
@echo -----------------------------------------------------
@goto exit
@
:edcodeerror
@echo ----------------------------------------------------------------
@echo Set COMPCODE environment variable before running make.
@echo type   SET COMPCODE=DOS    for FTN77 version.
@echo type   SET COMPCODE=DVF    for text-only Digital Fortran version.
@echo type   SET COMPCODE=F95    for FTN95 version.
@echo type   SET COMPCODE=GID    for GUI version [Digital and Microsoft]
@echo type   SET COMPCODE=LIN    for Linux Version [g77]
@echo type   SET COMPCODE=GIL    for GUI version [Linux g77 and gcc]
@echo ----------------------------------------------------------------
@goto exit
@
:exit
@time /t
@
