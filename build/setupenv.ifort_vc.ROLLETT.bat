call "d:\Progs\IntelSWTools\compilers_and_libraries_2018.1.156\windows\bin\ipsxe-comp-vars.bat" intel64 vs2015
set WXNUM=31
set WXVC=vc_x64
set WXMINOR=2
SET WXWIN=d:\wxdll
SET WXLIB=%WXWIN%\lib\%WXVC%_dll
set PATH=%WXLIB%;%PATH%
set INNOSETUP=d:\Progs\Inno


SETLOCAL ENABLEEXTENSIONS
setlocal EnableExtensions EnableDelayedExpansion

