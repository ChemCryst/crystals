
@call make_w32_include.bat

@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy
@if "%1" == "link" goto link

@if exist ..\crystals.exe del ..\crystals.exe
@if exist ..\crystalsd.exe del ..\crystalsd.exe
@if exist link.lis del link.lis
@if exist dlink.lis del dlink.lis
@if not exist obj mkdir obj
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" if not exist dobj mkdir dobj
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
@FOR %%I IN ( ..\gui\*.cpp )  DO call buildfile.bat %%~nI  

call buildfile.bat lapack

@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res ..\gui\script1.rc

@if "%CRDEBUG%" == "TRUE"  goto debug
:link
@%LD% %OPT% %LDFLAGS% obj\*.obj %LIBS% %OUT%crystals.exe >link.lis
@goto fini

:debug
@%LD% %LDEBUG% %LDFLAGS% dobj\*.obj %LIBS% %OUT%crystals.exe >link.lis

:fini
@type link.lis
@goto next1

:error
echo Failed
perl ..\bin\errmail.pl FPP_RELEASE_COMPILE %%I obj\listing.lis
goto exit

:clean
@del crystals.exe

:tidy
@del *.obj *.lis *.res *.ilk *.opt *.pdb

:next1
@time /t

