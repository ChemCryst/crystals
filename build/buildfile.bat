@setlocal EnableExtensions EnableDelayedExpansion
@echo on
@
@if "%COMPCODE%" == "" goto edcodeerror
@set EDCODE=%COMPCODE%
@if "%EDCODE%" == "F95" set EDCODE=DOS
@set FILEFOUND=
@
@if "%1" == "debug" set CRDEBUG=TRUE&&shift
@call make_w32_include.bat
@
@if "%1" == "" goto clerror
@
@rem  Find the file:
:restart
@set FILESTEM=%~n1
@set FILENAME=%~nx1
@
@rem CRYSTALS FORTRAN FILES with extension
@if not exist ..\crystals\%FILENAME% goto tryF90inGUI
@set SRCDIR=..\crystals
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@if "%~x1" == ".f90" goto f90comp
@if "%~x1" == ".F90" goto f90comp
@goto fcomp
@
:tryF90inGUI
@if not exist ..\gui\%FILENAME% goto tryCPPwithExt
@set SRCDIR=..\gui
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@if "%~x1" == ".f90" goto f90comp
@if "%~x1" == ".F90" goto f90comp
@rem if not F90 - don't try.
@set FILEFOUND=
@set SRCDIR=
@set JUMPBACK=
@
:tryCPPwithExt
@rem GUI CC FILES
@if not exist ..\gui\%FILENAME% goto tryWEBwithExt
@set CCSRC=..\gui\%FILENAME%
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto ccomp
@
:tryWEBwithExt
@rem webconnect CPP FILES
@if not exist ..\webconnect\%FILENAME% goto tryCamFPPwithExt
@set CCSRC=..\webconnect\%FILESTEM%
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto ccomp
@
:tryCamFPPwithExt
@rem CAMSRC FORTRAN FILES
@if not exist ..\cameron\%FILENAME% goto tryScriptswithExt
@echo Cam source with extension
@set SRCDIR=..\cameron
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto fcomp
@
@
:tryScriptswithExt
@rem CRYSTALS FORTRAN FILES
@if not exist ..\script\%FILENAME% goto tryWithoutExtensions
@echo Script source with extension
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto scomp
@
:tryWithoutExtensions
@
@rem CRYSTALS FORTRAN FILES
@if not exist ..\crystals\%FILENAME%.F goto tryCPP
@set SRCDIR=..\crystals
@set JUMPBACK=tryCPP
@set FILEFOUND=OK
@goto fcomp
@
:tryCPP
@rem GUI CC FILES
@if not exist ..\gui\%FILENAME%.cc goto tryWEB
@set CCSRC=..\gui\%FILESTEM%.cc
@set JUMPBACK=tryWEB
@set FILEFOUND=OK
@goto ccomp
@
:tryWEB
@rem webconnect CPP FILES
@if not exist ..\webconnect\%FILENAME%.cpp goto tryCamFPP
@set CCSRC=..\webconnect\%FILESTEM%.cpp
@set JUMPBACK=tryCamFPP
@set FILEFOUND=OK
@goto ccomp
@
:tryCamFPP
@rem CAMSRC FORTRAN FILES
@if not exist ..\cameron\%FILENAME%.F goto tryScripts
@set SRCDIR=..\cameron
@set JUMPBACK=tryScripts
@set FILEFOUND=OK
@goto fcomp
@
@
:tryScripts
@rem CRYSTALS FORTRAN FILES
@if not exist ..\script\%FILENAME%.* goto endofloop
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto scomp
@
@
:endofloop
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
@echo File %FILESTEM% not found in any source directories...
@echo -----------------------------------------------------
@echo File %FILESTEM% not found in any directories >> missing.log
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


:ccomp
@rem @echo building %FILESTEM%.obj for %COMPCODE% platform.
@if exist %FOPATH%\%FILESTEM%.obj del %FOPATH%\%FILESTEM%.obj
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
%CC% %CCSRC% %COUT%%FILESTEM%.obj %COPTIONS% || ( make_err.bat )
@goto %JUMPBACK%

:fcomp
@echo building %FILESTEM%.obj
@if exist %FOPATH%\%FILESTEM%.obj del %FOPATH%\%FILESTEM%.obj
@if  not "%FILESTEM%" == "lapack" set FSRC= %SRCDIR%\%FILESTEM%.F
@if      "%FILESTEM%" == "lapack" set FSRC= %SRCDIR%\%FILESTEM%.f
@if  not "%FILESTEM%" == "lapack" set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@if      "%FILESTEM%" == "lapack" set FOPTIONS=%FDEF% %FWIN% %FNOOPT%
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
%F77% %FSRC% %FOUT%%FILESTEM%.obj %FOPTIONS% || ( make_err.bat )
@goto %JUMPBACK%

:f90comp
@echo building %FILESTEM%.obj from f90
@if exist %FOPATH%\%FILESTEM%.obj del %FOPATH%\%FILESTEM%.obj
@set FSRC= %SRCDIR%\%FILESTEM%.f90
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@if      "%FILESTEM%" == "list26_helper" set FOPTIONS=%FDEF% %FWIN% %FNOPT%
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
%F77% %FSRC% %FOUT%%FILESTEM%.obj %FOPTIONS% || ( make_err.bat )
@goto %JUMPBACK%


:scomp
@if not exist ..\script\%FILESTEM%.ssc @goto dcomp
@echo building %FILESTEM%.scp
@perl ..\editor\filepp.pl -w -imacros ..\gui\crystalsinterface.h -o script\%FILESTEM%.scp -D__%EDCODE%__ -DCRYSVNVER=%CRYSVNVER% -DCRYMONTH=%CRYMONTH% -DCRYYEAR=%CRYYEAR% ..\script\%FILESTEM%.ssc


:dcomp
@if not exist ..\script\%FILESTEM%.sda @goto %JUMPBACK%
@echo building %FILESTEM%.dat
@perl ..\editor\filepp.pl -w -imacros ..\gui\crystalsinterface.h -o script\%FILESTEM%.dat -D__%EDCODE%__ -DCRYSVNVER=%CRYSVNVER% -DCRYMONTH=%CRYMONTH% -DCRYYEAR=%CRYYEAR% ..\script\%FILESTEM%.sda
@goto %JUMPBACK%



:exit
@rem @time /t

