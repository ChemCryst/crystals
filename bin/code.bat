@set EDCODE=%COMPCODE%
@if "%EDCODE%" == "F95" set EDCODE=DOS
@     
@echo MAKING DIRECTORIES ...
@
@cd %CRYSBUILD%
@mkdir errors
@mkdir code

@cd %CRYSBUILD%\code
@mkdir frel
@mkdir fdbg
@mkdir crel
@mkdir cdbg
@mkdir loader
@
@echo Compiling for the %EDCODE% platform ...
@
@if "%1" == "nloader"  goto onlynloader
@if not "%1" == ""  goto skip2
@goto skip3
:skip2
@if not "%1" == "fortran" goto skip4
:skip3
@
call buildfile.bat crystals
@
rem CRYSTALS:
call buildfile.bat absorb
call buildfile.bat accumula
call buildfile.bat alter5
call buildfile.bat aniso
call buildfile.bat anisotfs
call buildfile.bat bari
call buildfile.bat calcul
call buildfile.bat characte
call buildfile.bat control
call buildfile.bat csdcode
call buildfile.bat difabs
call buildfile.bat disc
call buildfile.bat distan
call buildfile.bat distangl
call buildfile.bat empabs
call buildfile.bat execute
call buildfile.bat fiddle
call buildfile.bat findfrag
call buildfile.bat foreig
call buildfile.bat fourie
call buildfile.bat fourier
call buildfile.bat genedit
call buildfile.bat geomet
call buildfile.bat geometry
call buildfile.bat guibit
call buildfile.bat hydrogen
call buildfile.bat input
call buildfile.bat input6
call buildfile.bat invert
call buildfile.bat lapack
call buildfile.bat lexical
call buildfile.bat link
call buildfile.bat list4
call buildfile.bat list6
call buildfile.bat list11
call buildfile.bat list12
call buildfile.bat list16
call buildfile.bat list26
call buildfile.bat list50
call buildfile.bat lists1
call buildfile.bat lists2
call buildfile.bat lists3
call buildfile.bat lists4
call buildfile.bat matrix
call buildfile.bat modify5
call buildfile.bat mtapes
call buildfile.bat planes
call buildfile.bat prcss
call buildfile.bat prcss6
call buildfile.bat presets
call buildfile.bat publsh
call buildfile.bat punch
call buildfile.bat read
call buildfile.bat read6
call buildfile.bat reductio
call buildfile.bat regular
call buildfile.bat restr
call buildfile.bat results
call buildfile.bat script
call buildfile.bat service
call buildfile.bat setting
call buildfile.bat sfls
call buildfile.bat slant
call buildfile.bat solve
call buildfile.bat sort
call buildfile.bat spacegrp
call buildfile.bat specific
call buildfile.bat summary
call buildfile.bat special
call buildfile.bat syntax
call buildfile.bat torsion
call buildfile.bat trial
call buildfile.bat weight
call buildfile.bat rotax
call buildfile.bat normal
rem CAMERON:
if "%COMPCODE%" == "DVF" goto skip4
call buildfile.bat altered
call buildfile.bat block
call buildfile.bat button
call buildfile.bat ccontrol
call buildfile.bat comm
call buildfile.bat cspecific
call buildfile.bat general
call buildfile.bat graphics
call buildfile.bat maths1
call buildfile.bat maths2
call buildfile.bat mouse
call buildfile.bat outer
call buildfile.bat vander

if "%COMPCODE%" == "DOS" call buildfile.bat wincode
if "%COMPCODE%" == "F95" call buildfile.bat wincode

rem if "%COMPCODE%" == "GIL" call buildfile.bat four3d
rem if "%COMPCODE%" == "GID" call buildfile.bat four3d
@
:skip4
@
@if not "%1" == ""  goto skip5
@goto skip6
:skip5
@if not "%1" == "gui" goto skip7
:skip6

call buildfile.bat ccchartcolour
call buildfile.bat ccchartdoc
call buildfile.bat ccchartellipse
call buildfile.bat ccchartline
call buildfile.bat ccchartobject
call buildfile.bat ccchartpoly
call buildfile.bat cccharttext
call buildfile.bat cccontroller
call buildfile.bat cccoord
call buildfile.bat ccmenuitem
call buildfile.bat ccmodelatom
call buildfile.bat ccmodelbond
call buildfile.bat ccmodelsphere
call buildfile.bat ccmodeldonut
call buildfile.bat ccmodeldoc
call buildfile.bat ccmodelobject
call buildfile.bat ccrect
call buildfile.bat ccstatus

call buildfile.bat crbutton
call buildfile.bat crchart
call buildfile.bat crcheckbox
call buildfile.bat crdropdown
call buildfile.bat creditbox
call buildfile.bat crguielement
call buildfile.bat crgrid
call buildfile.bat crlistbox
call buildfile.bat crlistctrl
call buildfile.bat crmenu
call buildfile.bat crmodel
call buildfile.bat crmultiedit
call buildfile.bat crprogress           
call buildfile.bat crradiobutton
call buildfile.bat crtext
call buildfile.bat crwindow

call buildfile.bat cxbutton
call buildfile.bat cxchart
call buildfile.bat cxcheckbox
call buildfile.bat cxdropdown
call buildfile.bat cxeditbox
call buildfile.bat cxgrid
call buildfile.bat cxgroupbox
call buildfile.bat cxlistbox
call buildfile.bat cxlistctrl
call buildfile.bat cxmenu
call buildfile.bat cxmodel
call buildfile.bat cxmultiedit
call buildfile.bat cxprogress
call buildfile.bat cxradiobutton
call buildfile.bat cxtext
call buildfile.bat cxwindow
call buildfile.bat stdafx
call buildfile.bat gcrystals
call buildfile.bat ccpoint
call buildfile.bat cxmenubar
call buildfile.bat cxtextout
call buildfile.bat crtextout
call buildfile.bat crbitmap
call buildfile.bat cxbitmap
call buildfile.bat crmenubar
call buildfile.bat crtab
call buildfile.bat cxtab
call buildfile.bat crtoolbar
call buildfile.bat cxtoolbar
call buildfile.bat crresizebar
call buildfile.bat cxresizebar
call buildfile.bat crstretch
call buildfile.bat cxstretch
call buildfile.bat cclock
call buildfile.bat cxplot
call buildfile.bat crplot
call buildfile.bat ccplotdata
call buildfile.bat ccplotbar
call buildfile.bat ccplotscatter
call buildfile.bat crhidden
call buildfile.bat cxmodlist
call buildfile.bat crmodlist
                                
if "%COMPCODE%" == "GIL" call buildfile.bat ccthread
rem if "%COMPCODE%" == "GIL" call buildfile.bat glcanvas

if "%COMPCODE%" == "GID" call buildfile.bat cricon
if "%COMPCODE%" == "GID" call buildfile.bat cxicon

:onlynloader
call buildfile.bat nloader
@move crel\nloader.obj loader\loader.obj
@del cdbg\nloader.obj

:skip7
@
@if "%COMPCODE%" == "GID" rc /d__CR_WIN__ /fo script1.res %CRYSSRC%\guisrc\script1.rc
@
@echo LINKING...
if exist ..\crystals.exe del ..\crystals.exe
if exist ..\crystalsd.exe del ..\crystalsd.exe
@goto %COMPCODE%
@
:DOS
:F95
SLINK frel\*.obj             -OUT:..\crystals.exe
SLINK fdbg\*.obj -DEBUG:FULL -OUT:..\crystalsd.exe
goto next1

:DVF
@set LINK=/SUBSYSTEM:console
@copy df60.pdb fdbg\df60.pdb
LINK /OUT:..\crystalsd.exe  /DEBUG  /incremental:no   fdbg\*.obj >dlink.lis
LINK /OUT:..\crystals.exe   /OPT:REF                  frel\*.obj >link.lis


goto next1

:LIN
g77    frel/*.obj -o ../crystals.exe
g77 -g fdbg/*.obj -o ../crystalsd.exe
goto next1

:GIL
g77    frel/*.obj crel/*.obj -L/usr/local/lib -lpthread-0.7 -lwx_gtk2 -ldl -L/usr/lib -lg++ -L/usr/X11R6/lib -lgtk -lgdk -lglib -lXi -lXext -lX11 -lm -lMesaGL -lMesaGLU -L/usr/lib/gcc-lib/i386-redhat-linux/egcs-2.90.29 -lgcc -lf2c  `/usr/local/bin/wx-config --cflags` -o ../crystals.exe
g77 -g fdbg/*.obj cdbg/*.obj -L/usr/local/lib -lpthread-0.7 -lwx_gtk2 -ldl -L/usr/lib -lg++ -L/usr/X11R6/lib -lgtk -lgdk -lglib -lXi -lXext -lX11 -lm -lMesaGL -lMesaGLU -L/usr/lib/gcc-lib/i386-redhat-linux/egcs-2.90.29 -lgcc -lf2c  `/usr/local/bin/wx-config --cflags` -o ../crystalsd.exe
goto next1

:GID
@if exist link.lis del link.lis
@if exist dlink.lis del dlink.lis
@set LINK=/SUBSYSTEM:WINDOWS
@copy df60.pdb fdbg\df60.pdb
@if not "%1" == "link" LINK /OUT:..\crysload.exe loader\*.obj shell32.lib advapi32.lib user32.lib
@rem
LINK /OUT:..\crystalsd.exe /DEBUG /debugtype:cv /pdb:none /incremental:no script1.res fdbg\*.obj cdbg\*.obj opengl32.lib glu32.lib >dlink.lis
LINK /OUT:..\crystals.exe  /OPT:REF script1.res frel\*.obj crel\*.obj opengl32.lib glu32.lib >link.lis
@rem
type dlink.lis
@goto next1

:next1
@time /t

@rem $Log: not supported by cvs2svn $
@rem Revision 1.35  2004/10/12 09:01:25  rich
@rem Quieten down. Print time at end. Remove WXS version (now uses code script, not code.bat)
@rem
@rem Revision 1.34  2004/07/02 13:30:16  rich
@rem Removed build of harwell and nag. Added build of lapack.
@rem
@rem Revision 1.32  2004/02/09 20:24:53  rich
@rem Fix WXS build tools (wxWin libs on Windows).
@rem
@rem Revision 1.31  2003/10/10 12:47:46  rich
@rem No more DEFINE on the Win32 platform.
@rem
@rem Revision 1.30  2003/05/21 10:10:37  rich
@rem For now, do not build resources for WX version of CRYSTALS.
@rem
@rem Revision 1.29  2003/05/07 12:18:53  rich
@rem
@rem RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
@rem using only free compilers and libraries. Hurrah, but it isn't very stable
@rem yet (CRYSTALS, not the compilers...)
@rem
@rem Revision 1.28  2003/03/26 10:27:15  rich
@rem Allow crysload to be built and linked easily by typing "code nloader"
@rem
@rem Revision 1.27  2002/12/17 10:18:19  rich
@rem Some changes for building the DVF version.
@rem
@rem Revision 1.26  2002/11/18 17:28:15  djw
@rem Remove specific reference of dformd library. (GID version)
@rem
@rem Revision 1.25  2002/09/27 14:45:47  rich
@rem Code.bat modified to work with DF6 - I've got the CD...
@rem
@rem Revision 1.24  2002/08/23 09:04:21  richard
@rem Slightly quieter building + errors in CPP files echoed to screen.
@rem
@rem Revision 1.23  2002/07/03 14:12:43  richard
@rem Changes to work with Visual C++7.
@rem
@rem Revision 1.22  2002/07/02 15:28:26  richard
@rem Compile new ccmodelobject classes: sphere and donut.
@rem
@rem Revision 1.21  2002/05/14 17:03:57  richard
@rem New gui files to build.
@rem
@rem Revision 1.20  2002/03/16 19:10:08  richard
@rem Some obsolete C++ files removed.
@rem
@rem Revision 1.19  2002/02/28 11:35:17  ckp2
@rem Build wilson plot code (normal.src).
@rem
@rem Revision 1.18  2002/01/31 15:14:15  ckp2
@rem Added building of geometry.src.
@rem
@rem Revision 1.17  2001/10/11 10:17:24  ckpgroup
@rem New Plot classes
@rem
@rem Revision 1.16  2001/07/03 09:00:00  ckp2
@rem Build rotax source.
@rem
@rem Revision 1.15  2001/06/19 13:04:43  richard
@rem Pass __CR_WIN__ definition to the resource compiler (rc).
@rem
@rem Revision 1.14  2001/06/17 14:18:03  richard
@rem
@rem Build cclock - remove unnecessary wx libraries from link command.
@rem
@rem Revision 1.13  2001/03/12 15:52:48  richard
@rem
@rem Set EDCODE.
@rem
@rem Revision 1.12  2001/03/08 16:49:17  richard
@rem Some new classes to build. Non incremental linking of debug version allows
@rem traceback display when program crashes.
@rem
@rem Revision 1.11  2001/01/25 17:16:13  richard
@rem Removed ccmodelcell and ccmodeltri.
@rem Added crtab and cxtab.
@rem Prevent building of define when "code link" is typed. "code anythingelse" will
@rem still build it.
@rem
@rem Revision 1.10  2001/01/15 15:31:02  richard
@rem Removed cclink references.
@rem
@rem Revision 1.9  2001/01/15 12:32:07  richard
@rem Instructions for building wxWindows version.
@rem
@rem Revision 1.8  2000/12/05 14:44:58  CKP2
@rem fix <CR>
@rem
@rem Revision 1.7  2000/12/05 14:43:48  CKP2
@rem fix <CR>
@rem
@rem Revision 1.6  2000/12/01 16:59:03  richard
@rem Remove ciftbx.for and label.for from being built
@rem Add code to build the loader (CRYSLOAD).
@rem
@rem Revision 1.5  2000/11/03 11:01:27  csduser
@rem Include new files.
@rem
@rem Revision 1.4  2000/10/31 15:29:53  ckp2
@rem Made rem statements non echoing
@rem
@rem Revision 1.3  2000/10/31 15:28:30  ckp2
@rem Comment out building of FOUR3D.for - no longer used.
@rem
