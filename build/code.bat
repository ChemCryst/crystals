@call make_w32_include.bat
@
@set EDCODE=%COMPCODE%
@if "%EDCODE%" == "F95" set EDCODE=DOS
@echo Linking for the %EDCODE% platform ...
@
@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res ..\gui\script1.rc
@
@if "%CRDEBUG%" == "TRUE"  goto debug
@
@%LD% %OPT% %LDFLAGS% *.obj %LIBS% %OUT%crystals.exe
@goto fini
:debug
@%LD% %LDEBUG% %LDFLAGS% *.obj %LIBS% %OUT%crystals.exe
:fini
@time /t
