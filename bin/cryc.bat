                         
@echo building %1.obj for %COMPCODE% platform.
@if exist %1.obj del %1.obj
@goto %COMPCODE%
:GID
@set CL=/EHs /D"WIN32" /D"_WINDOWS" /D"__CR_WIN__" /D"_MBCS" /D"_AFXDLL" /W3 /nologo /c
@CL /Fo%1.obj /O2 /D"NDEBUG" /MD /TP /I %SRCDIR% %SRCDIR%\%1.cc > cc%1.lis
@type %CRYSBUILD%\errors\cc%1.lis
@rem CL /Focdbg\%1.obj /Od /RTC1 /D "_DEBUG"  /MDd /Z7 /TP /I %SRCDIR% %SRCDIR%\%1.cc > %CRYSBUILD%\errors\dcc%1.lis
@rem type %CRYSBUILD%\errors\dcc%1.lis
@goto next1

:next1
