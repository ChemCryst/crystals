

add_definitions(-D_GNUF77_)
#add_definitions(-D__WXMAC__)
#add_definitions(-D__WXOSX__)
#add_definitions(-D__WXOSX_COCOA__)
#add_definitions(-D__WXUSINGDLL)
add_definitions(-D_FILE_OFFSET_BITS=64)
add_definitions("-std=gnu++11")

if(APPLE)
SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
IF(CMAKE_BUILD_TYPE MATCHES Debug)
    SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
    message("debug mode - only building x86_64")
ENDIF(CMAKE_BUILD_TYPE MATCHES Debug) 

#SET(CMAKE_OSX_DEPLOYMENT_TARGET "10.7") 
SET(CMAKE_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk")

#add_definitions("-DMACOSX_DEPLOYMENT_TARGET=10.7")
#add_definitions("-std=gnu++11")
#add_definitions("-mmacosx-version-min=10.7")
#add_definitions("-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk")
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
ENDIF(APPLE)

FIND_PACKAGE(wxWidgets REQUIRED html scintilla adv core gl base stc)
INCLUDE(${wxWidgets_USE_FILE})

IF(CMAKE_BUILD_TYPE MATCHES Debug)
   add_definitions("-D__CRDEBUG__")
ENDIF(CMAKE_BUILD_TYPE MATCHES Debug) 


#-s -fexceptions -I/usr/local/include `wx-config --cppflags` -D_GNUF77_ 
# -framework IOKit -framework Carbon -framework Cocoa -framework AudioToolbox -framework
# System -framework OpenGL -lwx_osx_cocoau_xrc-2.9 -lwx_osx_cocoau_webview-2.9 -
# lwx_osx_cocoau_html-2.9 -lwx_osx_cocoau_qa-2.9 -lwx_osx_cocoau_adv-2.9 
# -lwx_osx_cocoau_core-2.9 -lwx_baseu_xml-2.9 -lwx_baseu_net-2.9 -lwx_baseu-2.9 

add_library(CrystalsUserInterface OBJECT 
ccchartcolour.cc 
ccchartdoc.cc 
ccchartellipse.cc 
ccchartline.cc 
ccchartobject.cc 
ccchartpoly.cc 
cccharttext.cc 
cccontroller.cc 
cccoord.cc 
cccrystcommandlistener.cc 
cclistenerperformer.cc 
cclock.cc 
ccmenuitem.cc 
ccmodelatom.cc 
ccmodelbond.cc 
ccmodeldoc.cc 
ccmodeldonut.cc 
ccmodelobject.cc 
ccmodelsphere.cc 
ccmutex.cc 
ccplotbar.cc 
ccplotdata.cc 
ccplotscatter.cc 
ccpoint.cc 
ccrect.cc 
ccsemaphore.cc 
ccstatus.cc 
ccthread.cc 
crbitmap.cc 
crbutton.cc 
crchart.cc 
crcheckbox.cc 
crdropdown.cc 
creditbox.cc 
crgrid.cc 
crguielement.cc 
crhidden.cc 
cricon.cc 
crlistbox.cc 
crlistctrl.cc 
crmenu.cc 
crmenubar.cc 
crmodel.cc 
crmodlist.cc 
crmultiedit.cc 
crplot.cc 
crprogress.cc 
crradiobutton.cc 
crresizebar.cc 
crstretch.cc 
crtab.cc 
crtext.cc 
crtextout.cc 
crtoolbar.cc 
crweb.cc 
crwindow.cc 
cxbitmap.cc 
cxbutton.cc 
cxchart.cc 
cxcheckbox.cc 
cxdropdown.cc 
cxeditbox.cc 
cxgrid.cc 
cxgroupbox.cc 
cxicon.cc 
cxlistbox.cc 
cxlistctrl.cc 
cxmenu.cc 
cxmenubar.cc 
cxmodel.cc 
cxmodlist.cc 
cxmultiedit.cc 
cxplot.cc 
cxprogress.cc 
cxradiobutton.cc 
cxresizebar.cc 
cxstretch.cc 
cxtab.cc 
cxtext.cc 
cxtextout.cc 
cxtoolbar.cc 
cxweb.cc 
cxwindow.cc 
stdafx.cc )
