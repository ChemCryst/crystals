
@if not "%WXWIN%" == "" goto WX2
@set WXWIN=c:\wx3
:WX2
@if not "%WXLIB%" == "" goto WX3
@set WXLIB=%WXWIN%\lib\vc90_dll
:WX3
@if not "%WXNUM%" == "" goto WX4
@set WXNUM=30
:WX4
@
@set FOPATH=obj
@if "%CRDEBUG%" == "TRUE" set FOPATH=dobj

@if defined CRYSVNVER goto SVER
@set CRYSVNVER=00000
@for /f "delims=" %%a in ('svnversion ..') do @set CRYSVNVER=%%a
@echo CrySVNver = %CRYSVNVER%
:SVER
@if defined CRYMONTH goto SDATE
@echo off
FOR /F "skip=1 tokens=1-6" %%A IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
    IF NOT "%%~F"=="" (
        SET /A SortDate = 10000 * %%F + 100 * %%D + %%A
        set CRYYEAR=!SortDate:~0,4!
        set CRYMON=!SortDate:~4,2!
        set CRYDAY=!SortDate:~6,2!
        set CRYMN=%%D
    )
)
@echo on
@set months=January February March April May June^
 July August September October November December
@for /f "tokens=%crymn%" %%a in ("%months%") do @set CRYMONTH=%%a
@echo YR=!CRYYEAR! MON=!CRYMON! DAY=!CRYDAY! MONTH=!CRYMONTH!

:SDATE
@goto %COMPCODE%


:WXS
@if "%CRDEBUG%" == "TRUE"     set LIBS=/LIBPATH:%WXWIN%\lib\vc_lib  wxbase28d.lib wxmsw28d_core.lib wxzlibd.lib wxjpegd.lib wxtiffd.lib wxpngd.lib wxmsw28d_gl.lib wxmsw28d_aui.lib user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@if not "%CRDEBUG%" == "TRUE" set LIBS=/LIBPATH:%WXWIN%\lib\vc_lib  wxbase28.lib  wxmsw28_core.lib  wxzlib.lib  wxjpeg.lib  wxtiff.lib  wxpng.lib  wxmsw28_gl.lib  wxmsw28_aui.lib  user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@set LIBS=%LIBS% rc.o
@rem @set LIBS=/LIBPATH:%WXWIN%\lib\vc_lib msvcrtd.lib libcmtd.lib wxbase28d.lib wxmsw28d_core.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib  user32.lib ole32.lib /NODEFAULTLIB:MSVCRT.lib
@set CDEF=/D"__WXMSW__" /D"CRY_FORTDIGITAL" /DCRYSVNVER="%CRYSVNVER%"
@set FDEF=/define:__%COMPCODE%__ /define:CRY_FORTDIGITAL
goto ALLDVF

:INW
@rem @if "%CRDEBUG%" == "TRUE"     set LIBS=/link /subsystem:windows -libpath:%WXLIB% -libpath:..\hdf5\lib -libpath:..\crashrpt wxbase%WXNUM%ud.lib wxmsw%WXNUM%ud_core.lib wxmsw%WXNUM%ud_aui.lib wxmsw%WXNUM%ud_stc.lib wxzlibd.lib  wxjpegd.lib  wxtiffd.lib  wxpngd.lib  wxmsw%WXNUM%ud_gl.lib  CrashRpt1403.lib hdf5.lib hdf5_fortran.lib shell32.lib user32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@rem @if not "%CRDEBUG%" == "TRUE" set LIBS=/link /subsystem:windows -libpath:%WXLIB%  -libpath:..\hdf5\lib -libpath:..\crashrpt wxbase%WXNUM%u.lib  wxmsw%WXNUM%u_core.lib  wxmsw%WXNUM%u_aui.lib  wxmsw%WXNUM%u_stc.lib  wxzlib.lib  wxjpeg.lib  wxtiff.lib  wxpng.lib  wxmsw%WXNUM%u_gl.lib  CrashRpt1403.lib hdf5.lib hdf5_fortran.lib user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@if "%CRDEBUG%" == "TRUE"     set LIBS=/link /subsystem:windows -libpath:%WXLIB% -libpath:..\crashrpt wxbase%WXNUM%ud.lib wxmsw%WXNUM%ud_core.lib wxmsw%WXNUM%ud_aui.lib wxmsw%WXNUM%ud_stc.lib wxzlibd.lib  wxjpegd.lib  wxtiffd.lib  wxpngd.lib  wxmsw%WXNUM%ud_gl.lib  CrashRpt1403.lib shell32.lib user32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@if not "%CRDEBUG%" == "TRUE" set LIBS=/link /subsystem:windows -libpath:%WXLIB% -libpath:..\crashrpt wxbase%WXNUM%u.lib  wxmsw%WXNUM%u_core.lib  wxmsw%WXNUM%u_aui.lib  wxmsw%WXNUM%u_stc.lib  wxzlib.lib  wxjpeg.lib  wxtiff.lib  wxpng.lib  wxmsw%WXNUM%u_gl.lib  CrashRpt1403.lib user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@set LIBS=%LIBS% rc.res
@if "%CRDEBUG%" == "TRUE"     @set CDEF= /I%WXWIN%\include /I%WXLIB%\mswud  /I..\crashrpt /D"WXUSINGDLL" /D"CRY_DEBUG"
@if not "%CRDEBUG%" == "TRUE" @set CDEF= /I%WXWIN%\include /I%WXLIB%\mswu /I..\crashrpt /D"WXUSINGDLL"
@if "%CROPENMP%" == "TRUE" @set COPENMP=/Qopenmp
@if not "%CROPENMP%" == "TRUE" @set COPENMP=
@set FDEF=-D__INW__ -DCRY_GUI -DCRY_USEWX -DCRY_OSWIN32 -DCRY_FORTINTEL -D_NOHDF5_ 
@rem @set FDEF=-D__INW__ -DCRY_GUI -DCRY_USEWX -DCRY_OSWIN32 -DCRY_FORTINTEL /I..\hdf5\include
@rem @set LD=xilink
@set LD=ifort
@set OUT=/exe:
@set OPT=/O2 /Zi
@set LIBS=%LIBS% opengl32.lib glu32.lib   mkl_intel_c.lib mkl_sequential.lib  mkl_core.lib
@set LDEBUG=/Zi
@rem /debugtype:cv /pdb:none /incremental:no
@set LDCFLAGS=/SUBSYSTEM:console
@set LDFLAGS= /Qmkl %COPENMP%

@set CC=cl
@set CDEF=%CDEF% /D"WIN32" /D"_WINDOWS" /D"_UNICODE"  /D__WXMSW__ /D__%COMPCODE%__ /D_CRT_SECURE_NO_WARNINGS /DCRYSVNVER="%CRYSVNVER%"
@set COPTS=/EHs  /W3 /nologo /c /TP /I..\gui /O2 /Zi /Oy- /D"NDEBUG" /MD 
@set CDEBUG=/EHs /W3 /nologo /c /TP /I..\gui /Od /D"DEBUG" /RTC1 /MDd /Z7  
@set COUT=/Foobj\

@set F77=ifort
@set FDEF=%FDEF%
@set FOPTS=/fpp /I..\crystals /MD /O2 /QaxSSE2 /fp:source /Zi /Oy- /Qdiag-disable:8290 /Qdiag-disable:8291 /nolink %COPENMP%
@set FNOOPT=/fpp /I..\crystals /MD -O0 /fp:source /Qdiag-disable:8290 /Qdiag-disable:8291 /nolink
@set FWIN=/winapp
@set FOUT=/object:obj\
@set FDEBUG=/fpp /I..\crystals /MDd /debug /fp:source /check:bounds /check:format /check:overflow /check:pointers /check:uninit  /warn:argument_checking /warn:nofileopt /Qdiag-disable:8290 /Qdiag-disable:8291 /nolink /traceback /Qtrapuv
@if "%CRDEBUG%" == "TRUE" set FOUT=/object:dobj\
@if "%CRDEBUG%" == "TRUE" set COUT=/Fodobj\
@goto exit

:GID
@set LIBS=script1.res
@set CDEF=/D__%COMPCODE%__ /D"_AFXDLL" /D_CRT_SECURE_NO_WARNINGS 
@set FDEF=-D__GID__ -DCRY_GUI -DCRY_USEMFC -DCRY_OSWIN32 -DCRY_FORTDIGITAL -D_NOHDF5_

:ALLDVF
@set LD=link
@set OUT=/OUT:
@set OPT=/OPT:REF 
@set LDFLAGS=/SUBSYSTEM:WINDOWS
@set LDCFLAGS=/SUBSYSTEM:console
@set LIBS=%LIBS% opengl32.lib glu32.lib
@set LDEBUG=/DEBUG /debugtype:cv /pdb:none /incremental:no

@set CC=CL
@set CDEF=%CDEF% /D"WIN32" /D"_WINDOWS" /D"_MBCS" /DS /DCRYSVNVER="%CRYSVNVER%"
@set COPTS=/EHs /W3 /nologo /c /TP /I..\gui /O2 /D"NDEBUG" /MD
@set CDEBUG=/EHs /W3 /nologo /c /Od /RTC1 /MDd /Z7 /TP /I..\gui
@set COUT=/Foobj\

@set F77=DF
@set FDEF=%FDEF%
@set FOPTS=/fpp /include:..\crystals /MD /optimize:4  /nolink 
@set FNOOPT=/fpp /include:..\crystals /MD /optimize:0 /nolink
@set FWIN=/winapp
@set FOUT=/object:obj\
@set FDEBUG=/fpp /I..\crystals /MDd /debug /Zt /check:bounds /check:format /check:overflow /check:underflow /warn:argument_checking /warn:nofileopt /nolink 
@if "%CRDEBUG%" == "TRUE" set FOUT=/object:dobj\
@if "%CRDEBUG%" == "TRUE" set COUT=/Fodobj\
@goto exit

:DVF
set LD=link
set OUT=/OUT:
set OPT=/OPT:REF
set LDFLAGS=/SUBSYSTEM:console
set LDCFLAGS=/SUBSYSTEM:console
set LIBS=
set LDEBUG=/DEBUG /debugtype:cv /pdb:none /incremental:no
set CC=rem
set CDEF=
set COPTS=
set CDEBUG=
set COUT=
set F77=DF
set FDEF=/define:__%COMPCODE%__ /define:CRY_FORTDIGITAL  
set FOPTS=/fpp /I..\crystals /ML /optimize:4 /winapp /nolink
set FNOOPT=/fpp /I..\crystals /ML /optimize:0 /winapp /nolink
set FOUT=/object:obj\
set FDEBUG=/fpp /I..\crystals /MLd /debug /Zt /check:bounds /check:format /check:overflow /check:underflow /warn:argument_checking /warn:nofileopt /nolink
@if "%CRDEBUG%" == "TRUE" set FOUT=/object:dobj\
goto exit

:DOS
:F95
set LD=slink
set OUT=-OUT:
set OPT=
set LDFLAGS=
set LDCFLAGS=
set LIBS=
set LDEBUG=-DEBUG:FULL
set CC=rem
set CDEF=
set COPTS=
set CDEBUG=
set COUT=
set F77=ftn77
set FDEF=/define:__%COMPCODE%__
set FOPTS=/cfpp /I..\crystals  /no_warn73 /zero
set FNOOPT=/fpp /I..\crystals  /no_warn73 /zero 
set FOUT=/binary obj\
set FDEBUG=/debug
@if "%CRDEBUG%" == "TRUE" set FOUT=/binary obj\

:exit

