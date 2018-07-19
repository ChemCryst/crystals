

add_definitions(-D_FILE_OFFSET_BITS=64)

if(APPLE)
SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
IF(CMAKE_BUILD_TYPE MATCHES Debug)
    SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
    message("debug mode - only building x86_64")
ENDIF(CMAKE_BUILD_TYPE MATCHES Debug) 

#SET(CMAKE_OSX_DEPLOYMENT_TARGET "10.7") 
#SET(CMAKE_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk")

#add_definitions("-DMACOSX_DEPLOYMENT_TARGET=10.7")
#add_definitions("-std=gnu++11")
#add_definitions("-mmacosx-version-min=10.7")
#add_definitions("-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
ENDIF(APPLE)

if (WIN32)
   FIND_PACKAGE(wxWidgets REQUIRED html scintilla stc adv core gl base)
else ()
   FIND_PACKAGE(wxWidgets REQUIRED html stc adv core gl base)
endif ()
INCLUDE(${wxWidgets_USE_FILE})

IF(CMAKE_BUILD_TYPE MATCHES Debug)
   add_definitions("-D__CRDEBUG__")
   add_definitions("-DCRY_DEBUG")
ENDIF(CMAKE_BUILD_TYPE MATCHES Debug) 


#-s -fexceptions -I/usr/local/include `wx-config --cppflags` -D_GNUF77_ 
# -framework IOKit -framework Carbon -framework Cocoa -framework AudioToolbox -framework
# System -framework OpenGL -lwx_osx_cocoau_xrc-2.9 -lwx_osx_cocoau_webview-2.9 -
# lwx_osx_cocoau_html-2.9 -lwx_osx_cocoau_qa-2.9 -lwx_osx_cocoau_adv-2.9 
# -lwx_osx_cocoau_core-2.9 -lwx_baseu_xml-2.9 -lwx_baseu_net-2.9 -lwx_baseu-2.9 

add_library(CrystalsUserInterface OBJECT 
ccchartcolour.cpp 
ccchartdoc.cpp 
ccchartellipse.cpp 
ccchartline.cpp 
ccchartobject.cpp 
ccchartpoly.cpp 
cccharttext.cpp 
cccontroller.cpp 
cccoord.cpp 
cccrystcommandlistener.cpp 
cclistenerperformer.cpp 
cclock.cpp 
ccmenuitem.cpp 
ccmodelatom.cpp 
ccmodelbond.cpp 
ccmodeldoc.cpp 
ccmodeldonut.cpp 
ccmodelobject.cpp 
ccmodelsphere.cpp 
ccmutex.cpp 
ccplotbar.cpp 
ccplotdata.cpp 
ccplotscatter.cpp 
ccpoint.cpp 
ccrect.cpp 
ccsemaphore.cpp 
ccstatus.cpp 
ccthread.cpp 
crbitmap.cpp 
crbutton.cpp 
crchart.cpp 
crcheckbox.cpp 
crdropdown.cpp 
creditbox.cpp 
crgrid.cpp 
crguielement.cpp 
crhidden.cpp 
cricon.cpp 
crlistbox.cpp 
crlistctrl.cpp 
crmenu.cpp 
crmenubar.cpp 
crmodel.cpp 
crmodlist.cpp 
crmultiedit.cpp 
crplot.cpp 
crprogress.cpp 
crradiobutton.cpp 
crresizebar.cpp 
crstretch.cpp 
crtab.cpp 
crtext.cpp 
crtextout.cpp 
crtoolbar.cpp 
crweb.cpp 
crwindow.cpp 
cxbitmap.cpp 
cxbutton.cpp 
cxchart.cpp 
cxcheckbox.cpp 
cxdropdown.cpp 
cxeditbox.cpp 
cxgrid.cpp 
cxgroupbox.cpp 
cxicon.cpp 
cxlistbox.cpp 
cxlistctrl.cpp 
cxmenu.cpp 
cxmenubar.cpp 
cxmodel.cpp 
cxmodlist.cpp 
cxmultiedit.cpp 
cxplot.cpp 
cxprogress.cpp 
cxradiobutton.cpp 
cxresizebar.cpp 
cxstretch.cpp 
cxtab.cpp 
cxtext.cpp 
cxtextout.cpp 
cxtoolbar.cpp 
cxweb.cpp 
cxwindow.cpp 
stdafx.cpp
crslider.cpp
cxslider.cpp )


