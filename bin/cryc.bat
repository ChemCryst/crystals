@                         
@echo building %1.obj for %COMPCODE% platform.
@
@del crel\%1.obj
@del cdbg\%1.obj
@
@goto %COMPCODE%
@

:GIL
g++ -c -D"WIN32"  -D"__LINUX__" -D"__WXGTK__" -I/usr/lib/glib/include -o crel/%1.obj -s -O3 %SRCDIR%/%1.cpp
g++ -c -D"WIN32"  -D"__LINUX__" -D"__WXGTK__" -I/usr/lib/glib/include -o cdbg/%1.obj -g -D_DEBUG %SRCDIR%/%1.cpp
@goto next1

:GID
@set CL=/EHs /D"WIN32" /D"_WINDOWS" /D"__CR_WIN__" /D"_MBCS" /D"_AFXDLL" /W3 /nologo /c
@CL /Focrel\%1.obj /O2 /D "NDEBUG" /MD /TP /I %SRCDIR% %SRCDIR%\%1.cpp > %CRYSBUILD%\errors\cpp%1.lis
@type %CRYSBUILD%\errors\cpp%1.lis
@CL /Focdbg\%1.obj /Od /RTC1 /D "_DEBUG"  /MDd /Z7 /TP /I %SRCDIR% %SRCDIR%\%1.cpp > %CRYSBUILD%\errors\dcpp%1.lis
@type %CRYSBUILD%\errors\dcpp%1.lis
@goto next1



:WXS

@set WXDIR=/usr/local/lib/wx/include/msw-2.4

@set WXINC=-I/usr/local/lib/wx/include/msw-2.4
@set WXDEF=-D_X86 -DWIN32 -D_WIN32 -DWINVER=0x0400 -D__WIN95__ -D__GNUWIN32__ -D__WIN32__ -DSTRICT -D__WXMSW__ -D__WINDOWS__  -D__WINMSW__ -D__BOTHWX__ -D__BOTHWIN__ -DWXUSINGDLL=1 -D_FILE_OFFSET_BITS=64 -D_LARGE_FILES -fno-pcc-struct-return

g++ -c %WXDEF% %WXINC% -o crel/%1.obj -s -O3 %SRCDIR%/%1.cpp
g++ -c %WXDEF% %WXINC% -o cdbg/%1.obj -g -D__WXDEBUG__ -D_DEBUG %SRCDIR%/%1.cpp
@goto next1


:next1
