

if (WIN32)
   FIND_PACKAGE(wxWidgets REQUIRED html scintilla stc adv core gl base)
else ()
   FIND_PACKAGE(wxWidgets REQUIRED html stc adv core gl base)
endif ()

INCLUDE(${wxWidgets_USE_FILE})


add_library(CrystalsUserInterface STATIC 
startupdialog.cpp
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

target_link_libraries(CrystalsUserInterface INTERFACE ${wxWidgets_LIBRARIES})
target_compile_definitions(CrystalsUserInterface PRIVATE "$<$<CONFIG:Debug>:__CRDEBUG__>")
target_compile_definitions(CrystalsUserInterface PRIVATE "$<$<CONFIG:Debug>:CRY_DEBUG>")
target_compile_definitions(CrystalsUserInterface PRIVATE WXUSINGDLL)
target_compile_definitions(CrystalsUserInterface PRIVATE FILE_OFFSET_BITS=64)

