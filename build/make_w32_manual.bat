echo on
@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

SETLOCAL
mkdir manual
mkdir manual\analyse
cd manual
set CRYSSRC=..\..
perl -w ..\..\manual\mangen.pl faq.man primer.man guide.man crystals.man cameron.man menu.man readme.man workshop.man
cd ..
copy    manual\html\* manual
copy ..\manual\analyse\ manual\analyse
copy ..\manual\*.jpg manual
copy ..\manual\*.gif manual
copy ..\manual\*.css manual
copy ..\manual\*.pdf manual
ENDLOCAL
@goto exit

:clean
rmdir /q /s manual

:tidy
rmdir /q /s manual\html manual\latex manual\website


:exit

