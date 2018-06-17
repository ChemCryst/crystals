@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

SETLOCAL
@set OPATH=%PATH%
@set OLIB=%LIB%
goto %COMPCODE%

:DVF
:GID
@set BITS_FOPTS=/optimize:4
call "c:\program files\microsoft visual studio\df98\bin\dfvars.bat"
goto BUILD

:INW
@set BITS_FOPTS=/O3


:BUILD
%CC%  /c ..\sginfo\sgclib.c ..\sginfo\sgfind.c ..\sginfo\sghkl.c ..\sginfo\sgio.c ..\sginfo\sgsi.c ..\sginfo\sginfo_extra.c
%F77% /c ..\sginfo\sginfo_type.F90  
%F77% /c ..\sginfo\sginfo.F90 /object:fsginfo.obj
lib sgclib.obj sgfind.obj sghkl.obj sgio.obj sgsi.obj sginfo_extra.obj sginfo_type.obj fsginfo.obj /out:sginfo.lib
%F77% /c ..\bits\shelx2cry\crystal_data.F90
%F77% /c ..\bits\shelx2cry\shelx_procedures.F90 
%F77% /c ..\bits\shelx2cry\shelx2cry_dict.F90 
%F77% /c ..\bits\shelx2cry\shelx2cry_mod.F90 
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\shelx2cry\shelx2cry.F90 shelx2cry_mod.obj  shelx_procedures.obj shelx2cry_dict.obj crystal_data.obj  sginfo.lib %BITS_FOPTS%  /exe:shelx2cry.exe

%CC% ..\bits\Common\nobuf.c /Foobj\nobuf.obj /nologo /c /I..\gui /O2 /Zi /Oy- /D"NDEBUG" /MD  || ( make_err.bat )

%F77% /fpp %FDEF% /I..\crystals /I..\bits\cif2cry ..\bits\cif2cry\cif2cry.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
rem contour has not been updated to work woth the new graphics/compiler
rem %F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\contour\contour.F %BITS_FOPTS% /MD
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\convplat\convplat.F %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\convplat\platanom.F %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\csd2cry\csd2cry.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\delred\delred.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\dipin\dipin.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\hklf5\ctwin.F %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\hklf5\hklf52cry.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals /I..\bits\foxman ..\bits\foxman\pcf2cry.F %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals /I..\bits\kccdin ..\bits\kccdin\kccdin.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals /I..\bits\OxDiff ..\bits\OxDiff\OxDiffin.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals /I..\bits\Diffractometers ..\bits\Diffractometers\diffin.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals /I..\bits\rc93 ..\bits\rc93\rc93.F obj\nobuf.obj /automatic %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\reindex\reindex.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp /define:_%COMPCODE%_ /I..\crystals ..\bits\shelxs\shelxs.F %BITS_FOPTS% /MD  || ( make_err.bat )
%F77% /fpp %FDEF% /define:_%COMPCODE%_ /I..\crystals ..\bits\shelxs\sxtocry.F obj\nobuf.obj %BITS_FOPTS% /MD || ( make_err.bat )
%F77% /fpp %FDEF% /I..\crystals ..\bits\sir92\sir92.F /Fosir92.o /static /libs:qwin %BITS_FOPTS% /nolink || ( make_err.bat )
%F77% /fpp %FDEF% /I..\crystals ..\bits\sir92\norm92.F /Fonorm92.o /nostatic /libs:qwin %BITS_FOPTS% /nolink || ( make_err.bat )
%F77% sir92.o norm92.o /libs:qwin || ( make_err.bat )

@set PATH=%OPATH%
@set LIB=%OLIB%
ENDLOCAL

CL ..\bits\loader\crysload.cc %CDEF% /EHs /W3 /TP /O2 /D"NDEBUG" /MD /link shell32.lib advapi32.lib user32.lib || ( make_err.bat )
del crysload.obj

copy ..\bits\sir92\form.sda form.dat || ( make_err.bat )
copy ..\bits\rc93\rc93.ssr rc93.srt || ( make_err.bat )
goto exit

:clean
del cif2cry.exe convplat.exe csd2cry.exe delred.exe dipin.exe ctwin.exe
del kccdin.exe rc93.exe reindex.exe shelxs.exe sxtocry.exe sir92.exe
del rc93.src form.dat crysload.exe

:tidy
del sir92.o norm92.o

:exit
