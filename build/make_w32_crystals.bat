
@call make_w32_include.bat

@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy
@if "%1" == "link" goto link

@if exist ..\crystals.exe del ..\crystals.exe
@if exist ..\crystalsd.exe del ..\crystalsd.exe
@if exist link.lis del link.lis
@if exist dlink.lis del dlink.lis
@if not exist obj mkdir obj
@if "%COMPCODE%" == "INW" del crystals\lapack.f
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" if not exist dobj mkdir dobj
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
@FOR %%I IN ( ..\crystals\*.f90 ) DO ( @call buildfile.bat %%I || (echo buildfile.bat returned an error & goto error ))
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
@if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIFCOREMD.DLL"
@if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIFPORTMD.DLL"
@if "%COMPCODE%" == "INW" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBMMD.DLL"

@if "%CROPENMP%" == "TRUE" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\LIBIOMP5MD.DLL"
@if "%CROPENMP%" == "TRUE" copy "c:\program files (x86)\common files\intel\shared libraries\redist\ia32\compiler\SVML_DISPMD.DLL"

@if "%CRDEBUG%" == "TRUE"  goto debug
:link
@echo %LD% %OPT% %LDFLAGS% obj\*.obj %LIBS% %OUT%crystals.exe
@%LD% %OPT% %LDFLAGS% obj\*.obj %LIBS% %OUT%crystals.exe >link.lis || ( make_err.bat FPP_RELEASE_COMPILE %LD% link.lis )
@if "%COMPCODE%" == "INW" mt.exe -manifest crystals.exe.manifest -outputresource:crystals.exe;1
@goto fini

:debug
@%LD% %LDEBUG% %LDFLAGS% dobj\*.obj %LIBS% %OUT%crystalsd.exe >link.lis
@if "%COMPCODE%" == "INW" mt.exe -manifest crystalsd.exe.manifest -outputresource:crystalsd.exe;1

:fini
@type link.lis
@goto next1

:error
echo Failed
rem perl ..\bin\errmail.pl FPP_RELEASE_COMPILE %%I obj\listing.lis
@if "%CRBUILDEXIT%" == "TRUE"  exit 1
exit /b 1

:clean
@del crystals.exe

:tidy
@del *.obj *.lis *.res *.ilk *.opt *.pdb

:next1
@time /t

