@setlocal EnableExtensions EnableDelayedExpansion
@call make_w32_include.bat

@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy
@if "%1" == "link" goto link

@if exist ..\crystals.exe del ..\crystals.exe
@if exist ..\crystalsd.exe del ..\crystalsd.exe
@if not exist obj mkdir obj
@if "%COMPCODE%" == "INW" del crystals\lapack.f
@set ALLOWF2003=TRUE
@if "%COMPCODE%" == "DVF" set ALLOWF2003=FALSE
@if "%COMPCODE%" == "GID" set ALLOWF2003=FALSE
@set F90FILES=..\crystals\XDAVAL.INC.F90 ..\crystals\XDISC.INC.F90 ..\crystals\XERVAL.INC.F90 ..\crystals\XIOBUF.INC.F90 ..\crystals\XSSVAL.INC.F90 ..\crystals\XUNITS.INC.F90 ..\crystals\crystals_hdf5.F90 ..\crystals\c_strings.F90 ..\crystals\globalvars.F90 ..\crystals\math.F90 ..\crystals\mrgrnk.f90 ..\crystals\solve_helper.F90 
@if "%ALLOWF2003%"=="TRUE" set F90FILES=%F90FILES% ..\crystals\unitcell.F90
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" if not exist dobj mkdir dobj
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
@REM - explicit ordering of f90 files so that required modules are build first.

@FOR %%I IN ( %F90FILES% ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
REM @FOR %%I IN ( ..\crystals\*.f90 ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@FOR %%I IN ( ..\gui\*.F90 )      DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@FOR %%I IN ( ..\crystals\*.F ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@FOR %%I IN ( ..\cameron\*.F ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@FOR %%I IN ( ..\gui\*.cc )      DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@if not "%COMPCODE%" == "INW" @call buildfile.bat lapack

@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res ..\gui\script1.rc
@if "%COMPCODE%" == "WXS" rc /fo rc.o ..\gui\wx.rc
@if "%COMPCODE%" == "INW" rc /fo rc.res %CDEF% ..\gui\wx.rc
@rem  --include-dir c:\wxWidgets-2.8.11\include

@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxbase%WXNUM%u_vc90.dll
@if "%COMPCODE%" == "INW" copy %WXLIB%\wxbase%WXNUM%u_vc90.dll
@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxmsw%WXNUM%u_core_vc90.dll
@if "%COMPCODE%" == "INW" copy %WXLIB%\wxmsw%WXNUM%u_core_vc90.dll
@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxmsw%WXNUM%u_gl_vc90.dll
@if "%COMPCODE%" == "INW" copy %WXLIB%\wxmsw%WXNUM%u_gl_vc90.dll
@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxmsw%WXNUM%u_stc_vc90.dll
@if "%COMPCODE%" == "INW" copy %WXLIB%\wxmsw%WXNUM%u_stc_vc90.dll
@rem @if "%COMPCODE%" == "INW" copy ..\hdf5\bin\*.dll .
@if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIFCOREMD.DLL"
@if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIFPORTMD.DLL"
@if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBMMD.DLL"

@if "%CROPENMP%" == "TRUE" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIOMP5MD.DLL"
@if "%CROPENMP%" == "TRUE" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\SVML_DISPMD.DLL"

@if "%CRDEBUG%" == "TRUE"  goto debug
:link
%LD% %OPT% %OUT%crystals.exe %LDFLAGS% obj\*.obj %LIBS%  || ( make_err.bat  )
@if "%COMPCODE%" == "INW" mt.exe -manifest crystals.exe.manifest -outputresource:crystals.exe;1
@goto fini

:debug
@%LD% %LDEBUG% %OUT%crystalsd.exe %LDFLAGS% dobj\*.obj %LIBS% 
@if "%COMPCODE%" == "INW" mt.exe -manifest crystalsd.exe.manifest -outputresource:crystalsd.exe;1

:fini
@goto next1

:error
echo Failed
rem perl ..\bin\errmail.pl FPP_RELEASE_COMPILE %%I obj\listing.lis
@if "%CRBUILDEXIT%" == "TRUE"  exit 1
exit /b 1

:clean
@del crystals.exe

:tidy
@del *.obj *.lis *.res *.ilk *.opt *.pdb *.mod

:next1
@time /t

