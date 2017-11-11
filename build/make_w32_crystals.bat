@setlocal EnableExtensions EnableDelayedExpansion
@call make_w32_include.bat

@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy
@if "%1" == "link" goto link
@if "%1" == "copylink" goto copylink

@if exist ..\crystals.exe del ..\crystals.exe
@if exist ..\crystalsd.exe del ..\crystalsd.exe
@if not exist obj mkdir obj
@if "%COMPCODE%" == "INW" del crystals\lapack.f
@set ALLOWF2003=TRUE
@if "%COMPCODE%" == "DVF" set ALLOWF2003=FALSE
@if "%COMPCODE%" == "GID" set ALLOWF2003=FALSE
@set F90FILES=..\crystals\STORE.INC.F90 ..\crystals\math.F90 ..\crystals\XRTLSC.INC.F90 ..\crystals\XCHARS.INC.F90 ..\crystals\XDAVAL.INC.F90 ..\crystals\XDISC.INC.F90 ..\crystals\XERVAL.INC.F90 ..\crystals\XIOBUF.INC.F90 ..\crystals\XSSVAL.INC.F90 ..\crystals\XUNITS.INC.F90 ..\crystals\XLST01.INC.F90 ..\crystals\XLST05.INC.F90 ..\crystals\XLST06.INC.F90 ..\crystals\XLST12.INC.F90 ..\crystals\XLST13.INC.F90 ..\crystals\XLST23.INC.F90..\crystals\XLST28.INC.F90 ..\crystals\XLST30.INC.F90 ..\crystals\XLST33.INC.F90 ..\crystals\XLST39.INC.F90 ..\crystals\XCONST.INC.F90 ..\crystals\XOPVAL.INC.F90 ..\crystals\crystals_hdf5.F90 ..\crystals\c_strings.F90 ..\crystals\globalvars.F90 ..\crystals\mrgrnk.f90 ..\crystals\solve_helper.F90 ..\crystals\list26_helper.F90 ..\crystals\sfls_punch.F90  
@if "%ALLOWF2003%"=="TRUE" set F90FILES=%F90FILES% ..\crystals\unitcell.F90
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" if not exist dobj mkdir dobj
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
@REM - explicit ordering of f90 files so that required modules are build first.

@FOR %%I IN ( %F90FILES% ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
REM @FOR %%I IN ( ..\crystals\*.f90 ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@FOR %%I IN ( ..\gui\fwrapper_gui.F90 ..\gui\fwrapperimp_gui.F90 ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))

set FLIST=
for %%x in (..\crystals\*.F) do if not "%%x" == "..\crystals\crystals-cl.F" set FLIST=!FLIST! %%x
set LIST=%LIST:~1%

@FOR %%I IN ( %FLIST% ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@FOR %%I IN ( ..\cameron\*.F ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@FOR %%I IN ( ..\gui\*.cc )      DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
@if not "%COMPCODE%" == "INW" @call buildfile.bat lapack

@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res ..\gui\script1.rc
@if "%COMPCODE%" == "WXS" rc /fo rc.o ..\gui\wx.rc
@if "%COMPCODE%" == "INW" rc /fo rc.res %CDEF% ..\gui\wx.rc
@rem  --include-dir c:\wxWidgets-2.8.11\include

:copylink

@if "%WXVC%" == "" set WXVC=vc140

@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxbase%WXNUM%%WXMINOR%u_%WXVC%.dll
@if "%COMPCODE%" == "INW" copy "%WXLIB%\wxbase%WXNUM%%WXMINOR%u_%WXVC%.dll"
@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxmsw%WXNUM%%WXMINOR%u_core_%WXVC%.dll
@if "%COMPCODE%" == "INW" copy "%WXLIB%\wxmsw%WXNUM%%WXMINOR%u_core_%WXVC%.dll"
@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxmsw%WXNUM%%WXMINOR%u_gl_%WXVC%.dll
@if "%COMPCODE%" == "INW" copy "%WXLIB%\wxmsw%WXNUM%%WXMINOR%u_gl_%WXVC%.dll"
@if "%COMPCODE%" == "INW" echo copy %WXLIB%\wxmsw%WXNUM%%WXMINOR%u_stc_%WXVC%.dll
@if "%COMPCODE%" == "INW" copy "%WXLIB%\wxmsw%WXNUM%%WXMINOR%u_stc_%WXVC%.dll"
@rem @if "%COMPCODE%" == "INW" copy ..\hdf5\bin\*.dll .

del libifcoremd.dll
del libifportmd.dll
del libmmd.dll
del libiomp5md.dll
del svml_dispmd.dll

SET COMMAND=where libifcoremd.dll
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy1 
)
:copy1
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where LIBIFPORTMD.DLL
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy2
)
:copy2
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where LIBMMD.DLL
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy3
)
:copy3
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where LIBIOMP5MD.DLL
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy4
)
:copy4
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where SVML_DISPMD.DLL
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy5
)
:copy5
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

rem @if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIFCOREMD.DLL"
rem @if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIFPORTMD.DLL"
rem @if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBMMD.DLL"

rem @if "%CROPENMP%" == "TRUE" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIOMP5MD.DLL"
rem @if "%CROPENMP%" == "TRUE" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\SVML_DISPMD.DLL"

SET COMMAND=where msvcp140.dll
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy6 
)
:copy6
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where vcruntime140.dll
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy7 
)
:copy7
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where vccorlib140.dll
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy8
)
:copy8
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where concrt140.dll
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy9
)
:copy9
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"

SET COMMAND=where mkl_intel_thread.dll
FOR /F "delims=" %%A IN ('%COMMAND%') DO (
    SET TEMPVAR=%%A
    GOTO :copy10
)
:copy10
ECHO %TEMPVAR%
@if "%COMPCODE%" == "INW" copy "%tempvar%"


@if "%CRDEBUG%" == "TRUE"  goto debug
:link
%LD% %OPT% %OUT%crystals.exe %LDFLAGS% obj\*.obj %LIBS%  || ( make_err.bat )
@if "%COMPCODE%" == "INW" mt.exe -manifest crystals.exe.manifest -outputresource:crystals.exe;1
@goto fini

:debug
@%LD% %LDEBUG% %OUT%crystals.exe %LDFLAGS% dobj\*.obj %LIBS%  || ( make_err.bat )
@if "%COMPCODE%" == "INW" mt.exe -manifest crystals.exe.manifest -outputresource:crystals.exe;1

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

