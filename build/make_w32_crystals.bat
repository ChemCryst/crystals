
@call make_w32_include.bat

@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

@if exist ..\crystals.exe del ..\crystals.exe
@if exist ..\crystalsd.exe del ..\crystalsd.exe
@if exist link.lis del link.lis
@if exist dlink.lis del dlink.lis

@FOR %%I IN ( ..\crystals\*.fpp ) DO %F77% %%I %FOUT%%%~nI.obj %FDEBUG% %FDEF% %FWIN% %FOPTS%
@FOR %%I IN ( ..\cameron\*.fpp )  DO %F77% %%I %FOUT%%%~nI.obj %FDEBUG% %FDEF% %FWIN% %FOPTS% 
@FOR %%I IN ( ..\gui\*.cc )       DO %CC%  %%I %COUT%%%~nI.obj %CDEBUG% %CDEF% %COPTS% 
@%F77% ..\crystals\lapack.f  %FOUT%lapack.obj %FDEBUG% %FWIN% %FDEF% %FNOOPT%

@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res ..\gui\script1.rc

@%LD% %OPT% %LDFLAGS% *.obj %DEBUG% %LIBS% %OUT%crystals.exe   >link.lis

@type link.lis
@goto next1

:clean
@del crystals.exe

:tidy
@del *.obj *.lis *.res *.ilk *.opt *.pdb

:next1
@time /t

