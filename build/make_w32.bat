@if not exist .\make_w32.bat echo Only build in the build directory!&&goto exit
@echo This script builds crystals using the Digital Fortran and Microsoft
@echo Visual C++ compilers. All other compilers and environments use make
@echo instead.
@echo -------------------------------------------------------------------
@if "%COMPCODE%" == "" goto edcodeerror
for /f "delims=" %%a in ('svnversion') do @set CRYSVNVER=%%a

@echo CrySVNver = %CRYSVNVER%

@if "%1" == "debug" set CRDEBUG=TRUE&& shift && echo Building DEBUG version.
@if "%1" == "dist" goto dist

@SETLOCAL
@if not exist ..\editor\cryseditor.exe cd ..\editor&&call make_w32.bat&&cd ..
@ENDLOCAL


@call make_w32_crystals.bat %1 || ( echo make_w32_crystals.bat returned an error & exit /b 1 )
@call make_w32_data.bat %1
@call make_w32_script.bat %1
@call make_w32_manual.bat %1
@call make_w32_bits.bat %1

@if "%1" == "clean" goto clean
@goto exit

:edcodeerror
@echo ----------------------------------------------------------------
@echo Set COMPCODE environment variable before running make.
@echo type   SET COMPCODE=DOS    for FTN77 version.
@echo type   SET COMPCODE=DVF    for text-only Digital Fortran version.
@echo type   SET COMPCODE=F95    for FTN95 version.
@echo type   SET COMPCODE=GID    for GUI version [Digital and Microsoft]
@echo type   SET COMPCODE=INW    for GUI version [Intel and Microsoft]
@echo ----------------------------------------------------------------
@goto exit

:dist
@if not "%INNOSETUP%" == "" goto dist2
@set INNOSETUP=c:\progra~1\innose~1

:dist2
@call make_w32_crystals.bat tidy
@call make_w32_data.bat tidy
@call make_w32_script.bat tidy
@call make_w32_manual.bat tidy
@call make_w32_bits.bat tidy
@del crystals.pst
@del cameron.pst
@mkdir ..\installer
@cd ..\installer
@echo Running the setup compiler...
"%INNOSETUP%"\iscc.exe ../bin/crystals.iss
@echo Setup.exe will be in the ..\installer folder if it
@echo was successful.
@echo If unsuccessful take out the ECHO OFF statement from the batch file
@echo "%0" to find out what's going wrong...
@cd ..\build
goto exit

:clean
rmdir /q /s ..\installer
goto exit

:exit
@time /t
