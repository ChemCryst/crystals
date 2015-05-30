@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

@SETLOCAL
@if not exist ..\editor\cryseditor.exe cd ..\editor&&call make_w32.bat&&cd ..
@ENDLOCAL

@echo Copying datafiles
@FOR %%I IN ( ..\datafiles\*.ssr ) DO ..\editor\cryseditor %%I %%~nI.srt code=%COMPCODE% incl=+ excl=- comm=# strip

@echo Copying precompiled stuff
echo CVS > cvs.txt
echo .svn >> cvs.txt
xcopy ..\precomp\all . /S  /F /Y /EXCLUDE:cvs.txt 
xcopy ..\precomp\%COMPCODE% . /S  /F /Y /EXCLUDE:cvs.txt
if "%COMPCODE%" == "GID" goto win32 
if "%COMPCODE%" == "WXS" goto win32 
if "%COMPCODE%" == "INW" goto win32 
goto skipwin32

:win32
xcopy ..\precomp\WIN32 . /S  /F /Y /EXCLUDE:cvs.txt

:skipwin32
del cvs.txt

@echo Creating COMMANDS.DSC file.
SETLOCAL
if not exist ..\editor\cryseditor.exe cd ..\editor&&call make_w32.bat&&cd ..
ENDLOCAL
rmdir /q /s dscbuild
mkdir dscbuild
copy ..\datafiles\commands.src dscbuild\commands.src
copy ..\datafiles\crysdef.srt dscbuild\crystals.srt
SETLOCAL
cd dscbuild
set CRYSDIR=./
@if "%CRDEBUG%" == "TRUE"     ..\crystalsd.exe
@if not "%CRDEBUG%" == "TRUE" ..\crystals.exe
cd ..
ENDLOCAL
if not exist dscbuild\commands.dsc make_err.bat
copy dscbuild\commands.dsc .
@goto exit

:clean
del commands.dsc
del *.srt
rmdir /q /s demo
rmdir /q /s mce
del script\*.bmp script\*.cmn script\*.dat script\*.gif script\*.jpg
del *.dll 
del Tables.txt oshell.bat contour.exe guide92.txt

:tidy
rmdir /q /s dscbuild
rmdir /q /s nket\cvs
rmdir /q /s mce\cvs
rmdir /q /s example\cvs

rmdir /q /s demo\cvs
rmdir /q /s demo\cyclo\cvs
rmdir /q /s demo\demo\cvs
rmdir /q /s demo\disorder\cvs
rmdir /q /s demo\editor\cvs
rmdir /q /s demo\example\cvs
rmdir /q /s demo\keen\cvs
rmdir /q /s demo\kpenv\cvs
rmdir /q /s demo\LLewellyn\cvs
rmdir /q /s demo\mogul\cvs
rmdir /q /s demo\nket\cvs
rmdir /q /s demo\peach\cvs
rmdir /q /s demo\quick\cvs
rmdir /q /s demo\shape\cvs
rmdir /q /s demo\shape2\cvs
rmdir /q /s demo\twin\cvs
rmdir /q /s demo\twin2\cvs
rmdir /q /s demo\twin3\cvs
rmdir /q /s demo\ylid\cvs
rmdir /q /s demo\zoltan\cvs

rmdir /q /s script\cvs

:exit

