@echo on
@
@if "%COMPCODE%" == "" goto edcodeerror
@set EDCODE=%COMPCODE%
@if "%EDCODE%" == "F95" set EDCODE=DOS
@set FILEFOUND=
@rem  Find the file:
@
@if "%1" == "" goto clerror
:restart
@
@rem CRYSTALS FORTRAN FILES
@if not exist ..\crystals\%1.fpp goto next1
@set SRCDIR=..\crystals
@call ..\bin\cryf.bat %1
@set FILEFOUND=OK
@
:next1
@rem GUI CC FILES
@if not exist ..\gui\%1.cc goto next2
@set SRCDIR=..\gui
@call ..\bin\cryc.bat %1
@set FILEFOUND=OK
@
:next2
:next3
:next4
@rem CAMSRC FORTRAN FILES
@if not exist ..\cameron\%1.fpp goto next5
@set SRCDIR=..\cameron
@call ..\bin\cryf.bat %1
@set FILEFOUND=OK
@
@
:next5
@rem CRYSTALS FORTRAN FILES
@if not exist ..\crystals\%1.f goto next6
@set SRCDIR=..\crystals
@call ..\bin\cryf.bat %1
@set FILEFOUND=OK
@
@
:next6
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
@echo File %1 not found in any directories >> missing.log
@goto exit
@
:edcodeerror
@echo ----------------------------------------------------------------
@echo Set COMPCODE environment variable before running make.
@echo type   SET COMPCODE=DOS    for FTN77 version.
@echo type   SET COMPCODE=DVF    for text-only Digital Fortran version.
@echo type   SET COMPCODE=F95    for FTN95 version.
@echo type   SET COMPCODE=GID    for GUI version [Digital and Microsoft]
@echo ----------------------------------------------------------------
@goto exit
@
:exit
@time /t
@
