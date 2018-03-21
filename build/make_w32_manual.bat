echo on
@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

SETLOCAL
mkdir manual
mkdir manual\analyse
mkdir manual\Xray-data
cd manual
set CRYSSRC=..\..
perl -w ..\..\manual\mangen.pl faq.man primer.man guide.man crystals.man cameron.man menu.man readme.man workshop.man
cd ..
copy    manual\html\* manual
copy ..\manual\*.jpg manual
copy ..\manual\*.gif manual
copy ..\manual\*.css manual
copy ..\manual\*.pdf manual
rem copy ..\manual\*.pst manual
copy ..\manual\analyse\*.html manual\analyse
copy ..\manual\analyse\*.jpg  manual\analyse
copy ..\manual\analyse\*.gif  manual\analyse
copy ..\manual\analyse\*.tif  manual\analyse
copy ..\manual\analyse\*.css  manual\analyse
copy ..\manual\analyse\*.pdf  manual\analyse
copy ..\manual\analyse\*.png  manual\analyse

copy ..\manual\Xray-data\*.html manual\Xray-data
copy ..\manual\Xray-data\*.jpg  manual\Xray-data

ENDLOCAL
@goto exit

:clean
rmdir /q /s manual

:tidy
rmdir /q /s manual\html manual\latex manual\website


:exit

