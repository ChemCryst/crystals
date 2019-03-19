

if "%CR64BIT%" == "TRUE" (
    call "E:\Program Files\IntelSWTools\compilers_and_libraries_2017.4.210\windows\bin\ipsxe-comp-vars.bat" intel64 vs2015
    ) else (
    call "E:\Program Files\IntelSWTools\compilers_and_libraries_2017.4.210\windows\bin\ipsxe-comp-vars.bat" intel32 vs2015
    )

set WXNUM=31
if "%CR64BIT%" == "TRUE" (
    set WXVC=vc140_x64
) else (
    set WXVC=vc140
)
set WXMINOR=0
SET WXWIN=e:\wx31
SET WXLIB=%WXWIN%\lib\%WXVC%_dll
set PATH=%WXLIB%;%PATH%
set INNOSETUP=c:\program files (x86)\Inno Setup 5

SETLOCAL ENABLEEXTENSIONS
setlocal EnableExtensions EnableDelayedExpansion
