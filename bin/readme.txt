Required environment
====================

CRYSSRC=c:\src
CRYSBUILD=c:\build
COMPCODE=GID


extend PATH
PATH = "C:\SRC\BIN;%PATH%"


The CRYSSRC directory should contain the subdirectories
from the CVS repository: 
 \bin, \camsrc, \cryssrc, \guisrc, \scriptsrc, \manual

Use: cvs checkout bin


USAGE
=====

The files in the bin directory are used to build the 
crystals program and associated files.

BUILDALL.BAT     -  builds everything

SCRIPT.BAT       -  creates all the .scp and .dat 
                    files in the script directory.

DSC.BAT          -  creates the commands.dsc file 
                    (requires define.exe)
 
CODE.BAT         -  compiles and links the CRYSTALS 
                    program

CODE.BAT link    -  link only

CODE.BAT fortran - compile fortran then link

CODE.BAT gui     - compile c++ then link

BUILDFILE.BAT filename (without extension)
                 - builds any file from the source 
                   directories


e.g. if you have changed FOURIER.SRC, then type

  BUILDFILE FOURIER
  CODE LINK

e.g. if you have changed XNEWGUI.SSC, then type

  BUILDFILE XNEWGUI

e.g. if you have changed MACROFIL.MAC, type

  CODE fortran

e.g. if you have changed CCCONTROLLER.CPP, type

  BUILDFILE cccontroller
  CODE LINK

e.g. if you have changed CCCONTROLLER.H, type

  CODE gui

