@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

SETLOCAL
@set OPATH=%PATH%
@set OLIB=%LIB%
call "c:\program files\microsoft visual studio\df98\bin\dfvars.bat"

REM DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\diffractometers\OxDiffin.fpp /optimize:4 /MD
REM DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\diffractometers\kccdin.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\diffractometers\diffin.fpp /optimize:4 /MD
@set PATH=%OPATH%
@set LIB=%OLIB%
ENDLOCAL

goto exit


:exit
