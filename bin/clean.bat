@echo off
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
if "%COMPCODE%" == "" goto edcodeerror
set EDCODE=%COMPCODE%
if "%EDCODE%" == "F95" set EDCODE=DOS
if "%EDCODE%" == "WXS" set EDCODE=GID

cd %CRYSBUILD%

echo ...
echo ...
echo Cleaning non-release files from %CRYSBUILD%. Customize this
echo file, it is called %0

rem The CODE and ERRORS directories do not need to be removed,
rem as the installer includes things by directory, and these
rem are not mentioned.

echo REMOVE ANY CRYSTALS FILES LEFT LYING AROUND
del bfile*
del crfilev2.dsc
del script.log
del nket\bfile*
del example\bfile*
del demo\cyclo\bfile*
del demo\mogul\bfile*
del demo\demo\bfile*
del demo\editor\bfile*
del demo\keen\bfile*
del demo\peach\bfile*
del demo\quick\bfile*
del demo\shape\bfile*
del demo\shape2\bfile*
del demo\twin\bfile*
del demo\twin2\bfile*
del demo\twin3\bfile*
del demo\ylid\bfile*
del demo\disorder\bfile*
del demo\kpenv\bfile*
del demo\zoltan\bfile*
rem
del crfilev2.dsc
del nket\crfilev2.dsc
del example\crfilev2.dsc
del demo\cyclo\crfilev2.dsc
del demo\mogul\crfilev2.dsc
del demo\demo\crfilev2.dsc
del demo\editor\crfilev2.dsc
del demo\keen\crfilev2.dsc
del demo\peach\crfilev2.dsc
del demo\quick\crfilev2.dsc
del demo\shape\crfilev2.dsc
del demo\shape2\crfilev2.dsc
del demo\twin\crfilev2.dsc
del demo\twin2\crfilev2.dsc
del demo\twin3\crfilev2.dsc
del demo\ylid\crfilev2.dsc
del demo\disorder\crfilev2.dsc
del demo\kpenv\crfilev2.dsc
del demo\zoltan\crfilev2.dsc

echo REMOVE FILES WHICH GET RE-WRITTEN BY THE INSTALLER
del sir92.bat
del kccdin.bat
del rc93.bat
del script\winsizes.ini
copy %CRYSSRC%\precomp\script\winsizes.ini %CRYSBUILD%\script\winsizes.ini

echo REMOVE ANY DEBUG FILES
del crystalsd.exe
del define.exe
del *.ilk
del *.opt
del *.pdb

echo REMOVE ANY CVS INFO WHICH HAS BEEN COPIED ACROSS
rmdir /q /s nket\cvs
rmdir /q /s mce\cvs
rmdir /q /s example\cvs
rmdir /q /s demo\cvs
rmdir /q /s demo\cyclo\cvs
rmdir /q /s demo\zoltan\cvs
rmdir /q /s demo\mogul\cvs
rmdir /q /s demo\demo\cvs
rmdir /q /s demo\editor\cvs
rmdir /q /s demo\keen\cvs
rmdir /q /s demo\peach\cvs
rmdir /q /s demo\quick\cvs
rmdir /q /s demo\shape\cvs
rmdir /q /s demo\shape2\cvs
rmdir /q /s demo\twin\cvs
rmdir /q /s demo\twin2\cvs
rmdir /q /s demo\twin3\cvs
rmdir /q /s demo\ylid\cvs
rmdir /q /s demo\disorder\cvs
rmdir /q /s demo\kpenv\cvs

echo REMOVE BITS OF MANUAL WHICH ARE NOT FOR DISTRIBUTION
rmdir /q /s manual\html
rmdir /q /s manual\website
echo ...
echo ...

goto exit

:cryssrcerror
echo -----------------------------------------------------
echo Set CRYSSRC environment variable before running %0
echo e.g. SET CRYSSRC=c:\src 
echo -----------------------------------------------------
goto exit

:crysbuilderror
echo -----------------------------------------------------
echo Set CRYSSRC environment variable before running %0
echo e.g. SET CRYSSRC=c:\src 
echo -----------------------------------------------------
goto exit

:edcodeerror
echo ----------------------------------------------------------------
echo Set COMPCODE environment variable before running make.
echo type   SET COMPCODE=DOS    for FTN77 version.
echo type   SET COMPCODE=DVF    for text-only Digital Fortran version.
echo type   SET COMPCODE=F95    for FTN95 version.
echo type   SET COMPCODE=GID    for GUI version [Digital and Microsoft]
echo type   SET COMPCODE=LIN    for Linux Version [g77]
echo type   SET COMPCODE=GIL    for GUI version [Linux g77 and gcc]
echo ----------------------------------------------------------------
goto exit

rem $Log: not supported by cvs2svn $
rem Revision 1.10  2004/11/24 11:42:02  rich
rem Clean out the zoltan demo directory when making a release.
rem
rem Revision 1.9  2003/07/17 00:12:33  rich
rem Clean and install the demo\mogul subdirectory.
rem
rem Revision 1.8  2003/03/26 10:26:39  rich
rem Remove cvs subfolder from MCE subfolder.
rem
rem Revision 1.7  2002/12/17 10:17:24  rich
rem Clean new directories.
rem
rem Revision 1.6  2002/07/29 12:57:32  richard
rem Support for new demo directories.
rem
rem Revision 1.5  2002/07/09 15:16:03  richard
rem Copy back proper winsizes.ini (in case developer has run CRYSTALS before
rem releasing).
rem
rem Revision 1.4  2002/03/15 16:51:33  richard
rem Clean some files out of the demo directories. (Ideally build directory should be
rem removed and recreated before release, but this tends to work ok.)
rem
rem Revision 1.3  2001/11/23 08:37:29  ckp2
rem deltree replaced with rmdir /s/q under Windows NT. (But left in for
rem compatibility with 95.) Ignore error messages.
rem
rem Revision 1.2  2001/02/26 10:44:32  richard
rem
rem Winsizes.ini removed on clean up.
rem
rem Revision 1.1  2001/02/16 13:28:34  richard
rem Installation files.
rem

:exit

