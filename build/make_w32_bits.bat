@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

@set OPATH=%PATH%
@set OLIB=%LIB%
@set PATH=C:\Progra~1\Micros~3\vc98\bin;C:\Progra~1\Micros~3\df98\bin;%PATH%
@set LIB=C:\Progra~1\Micros~3\vc98\lib;C:\Progra~1\Micros~3\df98\lib;%LIB%
@set LINK=
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\sir92\sir92.fpp /Fosir92.o /static /libs:qwin /optimize:4 /nolink
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\sir92\norm92.fpp /Fonorm92.o /nostatic /libs:qwin /optimize:4 /nolink
DF sir92.o norm92.o /libs:qwin
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\cif2cry\cif2cry.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\convplat\convplat.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\csd2cry\csd2cry.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\delred\delred.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\dipin\dipin.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\hklf5\ctwin.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\kccdin\kccdin.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\rc93\rc93.fpp  /automatic /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\reindex\reindex.fpp /optimize:4 /MD
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\shelxs\shelxs.fpp /optimize:4 /MD 
DF /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\shelxs\sxtocry.fpp /optimize:4 /MD
copy ..\bits\sir92\form.sda form.dat
copy ..\bits\rc93\rc93.ssr rc93.src
@set PATH=%OPATH%
@set LIB=%OLIB%
goto exit

:clean
del cif2cry.exe convplat.exe csd2cry.exe delred.exe dipin.exe ctwin.exe
del kccdin.exe rc93.exe reindex.exe shelxs.exe sxtocry.exe sir92.exe
del rc93.src form.dat

:tidy
del sir92.o norm92.o

:exit
