@call make_w32_include.bat
@echo on
@
@if "%COMPCODE%" == "" goto edcodeerror
@set EDCODE=%COMPCODE%
@if "%EDCODE%" == "F95" set EDCODE=DOS
@set FILEFOUND=
@
@if "%1" == "debug" set CRDEBUG=TRUE&&shift
@
@if "%1" == "" goto clerror
@
@
@
@rem  Find the file:
:restart
@
@rem CRYSTALS FORTRAN FILES
@if not exist ..\crystals\%1.fpp goto tryCPP
@set SRCDIR=..\crystals
@set JUMPBACK=tryCPP
@set FILEFOUND=OK
@goto fcomp
@
:tryCPP
@rem GUI CC FILES
@if not exist ..\gui\%1.cc goto tryCamFPP
@set JUMPBACK=tryCamFPP
@set FILEFOUND=OK
@goto ccomp
@
:tryCamFPP
@rem CAMSRC FORTRAN FILES
@if not exist ..\cameron\%1.fpp goto tryCryF
@set SRCDIR=..\cameron
@set JUMPBACK=tryCryF
@set FILEFOUND=OK
@goto fcomp
@
@
:tryCryF
@rem CRYSTALS FORTRAN FILES
@if not exist ..\crystals\%1.f goto tryScripts
@set SRCDIR=..\crystals
@set JUMPBACK=tryScripts
@set FILEFOUND=OK
@goto fcomp
@
@
:tryScripts
@rem CRYSTALS FORTRAN FILES
@if not exist ..\script\%1.* goto endofloop
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


:ccomp
@echo building %1.obj for %COMPCODE% platform.
@if exist %1.obj del %1.obj
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
%CC% ..\gui\%1.cc %COUT%%1.obj %COPTIONS% 2> obj\output || ( make_err.bat CPP_RELEASE_COMPILE %1.cpp obj\output & exit /b 1 )
@goto %JUMPBACK%

:fcomp
@echo building %1.obj
@if exist %1.obj del %1.obj
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
@if not "%1" == "lapack" %F77% %SRCDIR%\%1.fpp %FOUT%%1.obj %FOPTIONS% 2> obj\output || ( make_err.bat FPP_RELEASE_COMPILE %1.fpp obj\output  & exit /b 1 )
@if "%1" == "lapack" %F77% %SRCDIR%\%1.f %FOUT%%1.obj %FWIN% %FDEF% %FNOOPT% 2> obj\output || ( make_err.bat FPP_RELEASE_COMPILE %1.fpp obj\output  & exit /b 1 )
@goto %JUMPBACK%

:scomp
@if not exist ..\script\%1.ssc goto dcomp
@echo building %1.scp
@..\editor\cryseditor ..\script\%1.ssc script\%1.scp code=%EDCODE% incl=+ excl=- comm=%%%%
:dcomp
@if not exist ..\script\%1.sda goto %JUMPBACK%
@echo building %1.dat
@..\editor\cryseditor ..\script\%1.sda script\%1.dat code=%EDCODE% incl=+ excl=- comm=#
@goto %JUMPBACK%



:exit
@time /t
@

