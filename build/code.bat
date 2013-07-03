@call make_w32_include.bat
@
@set EDCODE=%COMPCODE%
@if "%EDCODE%" == "F95" set EDCODE=DOS
@echo Linking for the %EDCODE% platform ...
@
@if "%1" == "debug" set CRDEBUG=TRUE
@
@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res ..\gui\script1.rc
@
@if "%CRDEBUG%" == "TRUE"  goto debug
@
@%LD% %OPT% %LDFLAGS% obj\*.obj %LIBS% %OUT%crystals.exe
@if "%COMPCODE%" == "INW" mt.exe -manifest crystals.exe.manifest -outputresource:crystals.exe;1
@goto fini
:debug
@%LD% %LDEBUG% %LDFLAGS% dobj\*.obj %LIBS% %OUT%crystalsd.exe
mt.exe -manifest crystalsd.exe.manifest -outputresource:crystalsd.exe;1
:fini
@time /t
