
@call make_w32_include.bat

@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

@if exist ..\crystals.exe del ..\crystals.exe
@if exist ..\crystalsd.exe del ..\crystalsd.exe
@if exist link.lis del link.lis
@if exist dlink.lis del dlink.lis
@set FOPTIONS=%FDEF% %FWIN% %FOPTS%
@if "%CRDEBUG%" == "TRUE" set FOPTIONS=%FDEF% %FWIN% %FDEBUG%
@set COPTIONS=%CDEF% %COPTS%
@if "%CRDEBUG%" == "TRUE" set COPTIONS=%CDEF% %CDEBUG%
@FOR %%I IN ( ..\crystals\*.fpp ) DO %F77% %%I %FOUT%%%~nI.obj %FOPTIONS%
@FOR %%I IN ( ..\cameron\*.fpp )  DO %F77% %%I %FOUT%%%~nI.obj %FOPTIONS%
@FOR %%I IN ( ..\gui\*.cc )       DO %CC%  %%I %COUT%%%~nI.obj %COPTIONS%
@%F77% ..\crystals\lapack.f  %FOUT%lapack.obj %FWIN% %FDEF% %FNOOPT%

@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res ..\gui\script1.rc

@if "%CRDEBUG%" == "TRUE"  goto debug
@%LD% %OPT% %LDFLAGS% *.obj %LIBS% %OUT%crystals.exe    >link.lis
@goto fini

:debug
@%LD% %LDEBUG% %LDFLAGS% *.obj %LIBS% %OUT%crystals.exe >link.lis

:fini
@type link.lis
@goto next1

:clean
@del crystals.exe

:tidy
@del *.obj *.lis *.res *.ilk *.opt *.pdb

:next1
@time /t

