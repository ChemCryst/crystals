@ECHO OFF

call clean.bat

cd %CRYSBUILD%
del crystals.pst
del cameron.pst
mkdir output
cd %CRYSBUILD%\output
mkdir output

rem   *** Write the setup script ***
echo Writing setup script...

type %CRYSSRC%\bin\header.is                      > crystals.iss

echo AppVerName=CRYSTALS 12.40 (July 2004)        >> crystals.iss
echo AppVersion=12.40                             >> crystals.iss

echo WizardImageFile=%CRYSSRC%\bin\instimage.bmp  >> crystals.iss
echo LicenseFile=%CRYSSRC%\bin\licence.txt        >> crystals.iss
echo InfoAfterFile=%CRYSSRC%\bin\postinst.txt     >> crystals.iss

echo [Files]                                      >> crystals.iss
echo Source: %CRYSBUILD%\*.*; DestDir: {app}\;    >> crystals.iss
echo Source: %CRYSBUILD%\script\*.*; DestDir: {app}\script\;        >> crystals.iss
echo Source: %CRYSBUILD%\mce\*.*; DestDir: {app}\mce\;              >> crystals.iss
echo Source: %CRYSBUILD%\nket\*.*; DestDir: {app}\nket\;            >> crystals.iss
echo Source: %CRYSBUILD%\example\*.*; DestDir: {app}\example\;      >> crystals.iss
echo Source: %CRYSBUILD%\manual\*.*; DestDir: {app}\manual\;        >> crystals.iss
echo Source: %CRYSBUILD%\demo\cyclo\*.*; DestDir: {app}\demo\cyclo\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\demo\*.*; DestDir: {app}\demo\demo\;  >> crystals.iss
echo Source: %CRYSBUILD%\demo\editor\*.*; DestDir: {app}\demo\editor\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\keen\*.*; DestDir: {app}\demo\keen\;  >> crystals.iss
echo Source: %CRYSBUILD%\demo\peach\*.*; DestDir: {app}\demo\peach\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\quick\*.*; DestDir: {app}\demo\quick\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\shape\*.*; DestDir: {app}\demo\shape\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\shape2\*.*; DestDir: {app}\demo\shape2\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\twin\*.*; DestDir: {app}\demo\twin\;  >> crystals.iss
echo Source: %CRYSBUILD%\demo\twin2\*.*; DestDir: {app}\demo\twin2\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\twin3\*.*; DestDir: {app}\demo\twin3\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\ylid\*.*; DestDir: {app}\demo\ylid\;  >> crystals.iss
echo Source: %CRYSBUILD%\demo\disorder\*.*; DestDir: {app}\demo\disorder\;  >> crystals.iss
echo Source: %CRYSBUILD%\demo\kpenv\*.*; DestDir: {app}\demo\kpenv\;>> crystals.iss
echo Source: %CRYSBUILD%\demo\mogul\*.*; DestDir: {app}\demo\mogul\;>> crystals.iss
type %CRYSSRC%\bin\footer.is                                        >> crystals.iss

rem    ***   Run the setup compiler   ***
echo Running the setup compiler...

c:\progra~1\innose~1\compil32.exe /cc crystals.iss

cd %CRYSBUILD%\output\output
explorer .\

echo Setup.exe will be in the %CRYSBUILD%\output\Output folder if it
echo was successful.
echo If unsuccessful take out the ECHO OFF statement from the batch file
echo "%0" to find out what's going wrong...

