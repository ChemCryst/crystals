@goto %COMPCODE%
:GID
@set LD=link
@set OUT=/OUT:
@set OPT=/OPT:REF
@set LDFLAGS=/SUBSYSTEM:WINDOWS
@set LDCFLAGS=/SUBSYSTEM:console
@set LIBS=script1.res opengl32.lib glu32.lib
@set LDEBUG=/DEBUG /debugtype:cv /pdb:none /incremental:no
@set CC=CL
@set CDEF=/D"WIN32" /D"_WINDOWS" /D"__CR_WIN__" /D"_MBCS" /D"_AFXDLL"
@set COPTS=/EHs /W3 /nologo /c /TP /I..\gui
@set CDEBUG=/O2 /D"NDEBUG" /MD
@set COUT=/Fo
@rem set CDEBUG=/Od /RTC1 /D"_DEBUG" /MDd /Z7
@set F77=DF
@set FDEF=/define:_%COMPCODE%_
@set FOPTS=/fpp /I..\crystals /MD /optimize:4  /nolink
@set FNOOPT=/fpp /I..\crystals /MD /optimize:0 /nolink
@set FWIN=/winapp
@set FOUT=/object:
@set FDEBUG=
goto exit

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
set FDEF=/define:_%COMPCODE%_
set FOPTS=/fpp /I..\crystals /ML /optimize:4 /winapp /nolink
set FNOOPT=/fpp /I..\crystals /ML /optimize:0 /winapp /nolink
set FOUT=/object:
set FDEBUG=
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
set FDEF=/define:_%COMPCODE%_
set FOPTS=/cfpp /I..\crystals  /no_warn73 /zero
set FNOOPT=/fpp /I..\crystals  /no_warn73 /zero 
set FOUT=/binary  
set FDEBUG=
rem set FDEBUG=/debug


:exit

