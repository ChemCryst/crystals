@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

SETLOCAL
@set OPATH=%PATH%
@set OLIB=%LIB%
call "c:\program files\microsoft visual studio\df98\bin\dfvars.bat"

%F77% /fpp %FDEF% /I..\crystals ..\bits\sir92\sir92.fpp /Fosir92.o /static /libs:qwin /optimize:4 /nolink
%F77% /fpp %FDEF% /I..\crystals ..\bits\sir92\norm92.fpp /Fonorm92.o /nostatic /libs:qwin /optimize:4 /nolink
%F77% sir92.o norm92.o /libs:qwin
%F77% /fpp %FDEF% /I..\crystals ..\bits\cif2cry\cif2cry.fpp /optimize:4 /MD
rem contour has not been updated to work woth the new graphics/compiler
rem %F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\contour\contour.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\convplat\convplat.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\csd2cry\csd2cry.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\delred\delred.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\dipin\dipin.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\hklf5\ctwin.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\hklf5\hklf52cry.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\foxman\pcf2cry.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\kccdin\kccdin.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\OxDiff\OxDiffin.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals /I..\bits\Diffractometers\ ..\bits\Diffractometers\diffin.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\rc93\rc93.fpp  /automatic /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\reindex\reindex.fpp /optimize:4 /MD
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\shelxs\shelxs.fpp /optimize:4 /MD 
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\shelxs\sxtocry.fpp /optimize:4 /MD

@set PATH=%OPATH%
@set LIB=%OLIB%
ENDLOCAL

CL ..\bits\loader\crysload.cc %CDEF% /EHs /W3 /TP /O2 /D"NDEBUG" /MD /link shell32.lib advapi32.lib user32.lib
del crysload.obj

copy ..\bits\sir92\form.sda form.dat
copy ..\bits\rc93\rc93.ssr rc93.srt
goto exit

:clean
del cif2cry.exe convplat.exe csd2cry.exe delred.exe dipin.exe ctwin.exe
del kccdin.exe rc93.exe reindex.exe shelxs.exe sxtocry.exe sir92.exe
del rc93.src form.dat crysload.exe

:tidy
del sir92.o norm92.o

:exit
