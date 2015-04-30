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
@set FILESTEM=%~nx1
@
@rem  Find the file:
:restart
@
@rem CRYSTALS FORTRAN FILES with extension
@if not exist ..\crystals\%FILESTEM% goto tryCPPwithExt
@set FILESTEM=%~n1
@set SRCDIR=..\crystals
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@if "%~x1" == ".f90" goto f90comp
@if "%~x1" == ".F90" goto f90comp
@goto fcomp
@
:tryCPPwithExt
@rem GUI CC FILES
@if not exist ..\gui\%FILESTEM% goto tryWEBwithExt
@set CCSRC=..\gui\%FILESTEM%
@set FILESTEM=%~n1
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto ccomp
@
:tryWEBwithExt
@rem webconnect CPP FILES
@if not exist ..\webconnect\%FILESTEM% goto tryCamFPPwithExt
@set CCSRC=..\webconnect\%FILESTEM%
@set FILESTEM=%~n1
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto ccomp
@
:tryCamFPPwithExt
@rem CAMSRC FORTRAN FILES
@if not exist ..\cameron\%FILESTEM% goto tryScriptswithExt
@echo Cam source with extension
@set FILESTEM=%~n1
@set SRCDIR=..\cameron
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto fcomp
@
@
:tryScriptswithExt
@rem CRYSTALS FORTRAN FILES
@if not exist ..\script\%FILESTEM% goto tryWithoutExtensions
@set FILESTEM=%~n1
@echo Script source with extension
@set JUMPBACK=endofloop
@set FILEFOUND=OK
@goto scomp
@
:tryWithoutExtensions
@
@rem CRYSTALS FORTRAN FILES
@if not exist ..\crystals\%FILESTEM%.F goto tryCPP
@set SRCDIR=..\crystals
@set JUMPBACK=tryCPP
@set FILEFOUND=OK
@goto fcomp
@
:tryCPP
@rem GUI CC FILES
@if not exist ..\gui\%FILESTEM%.cc goto tryWEB
@set CCSRC=..\gui\%FILESTEM%.cc
@set JUMPBACK=tryWEB
@set FILEFOUND=OK
@goto ccomp
@
:tryWEB
@rem webconnect CPP FILES
@if not exist ..\webconnect\%FILESTEM%.cpp goto tryCamFPP
@set CCSRC=..\webconnect\%FILESTEM%.cpp
@set JUMPBACK=tryCamFPP
@set FILEFOUND=OK
@goto ccomp
@
:tryCamFPP
@rem CAMSRC FORTRAN FILES
@if not exist ..\cameron\%FILESTEM%.F goto tryScripts
@set SRCDIR=..\cameron
@set JUMPBACK=tryScripts
@set FILEFOUND=OK
@goto fcomp
@
@
@
:tryScripts
@rem CRYSTALS FORTRAN FILES
@if not exist ..\script\%FILESTEM%.* goto endofloop
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
@if exist %FILESTEM%.obj del %FILESTEM%.obj
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
%CC% %CCSRC% %COUT%%FILESTEM%.obj %COPTIONS% || ( make_err.bat CPP_RELEASE_COMPILE %CCSRC% obj\output )
@goto %JUMPBACK%

:fcomp
@echo building %FILESTEM%.obj
@if exist %FILESTEM%.obj del %FILESTEM%.obj
@if  not "%FILESTEM%" == "lapack" set FSRC= %SRCDIR%\%FILESTEM%.F
@if      "%FILESTEM%" == "lapack" set FSRC= %SRCDIR%\%FILESTEM%.f
@if  not "%FILESTEM%" == "lapack" set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@if      "%FILESTEM%" == "lapack" set FOPTIONS=%FDEF% %FWIN% %FNOOPT%
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
%F77% %FSRC% %FOUT%%FILESTEM%.obj %FOPTIONS%  || ( make_err.bat FPP_RELEASE_COMPILE %FSRC% obj\output )
@goto %JUMPBACK%

:f90comp
@echo building %FILESTEM%.obj from f90
@if exist %FILESTEM%.obj del %FILESTEM%.obj
@set FSRC= %SRCDIR%\%FILESTEM%.f90
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
%F77% %FSRC% %FOUT%%FILESTEM%.obj %FOPTIONS%  || ( make_err.bat FPP_RELEASE_COMPILE %FSRC% obj\output )
@goto %JUMPBACK%


:scomp
@if not exist ..\script\%FILESTEM%.ssc @goto dcomp
@echo building %FILESTEM%.scp
@..\editor\cryseditor ..\script\%FILESTEM%.ssc script\%FILESTEM%.scp code=%EDCODE% incl=+ excl=- comm=%%%%
:dcomp
@if not exist ..\script\%FILESTEM%.sda @goto %JUMPBACK%
@echo building %FILESTEM%.dat
@..\editor\cryseditor ..\script\%FILESTEM%.sda script\%FILESTEM%.dat code=%EDCODE% incl=+ excl=- comm=#
@goto %JUMPBACK%



:exit
@rem @time /t

