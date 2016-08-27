
////////////////////////////////////////////////////////////////////////
//   Filename:  CrystalsInterface.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   27.2.1998 14:11 Uhr
// $Log: not supported by cvs2svn $
// Revision 1.41  2012/03/26 11:37:07  rich
// Move IDs in range.
//
// Revision 1.40  2011/05/16 10:56:32  rich
// Added pane support to WX version. Added coloured bonds to model.
//
// Revision 1.39  2011/03/24 16:46:09  rich
// Untest.
//
// Revision 1.38  2011/03/24 15:27:48  rich
// Test.
//
// Revision 1.37  2011/03/04 05:54:45  rich
// New DIGITALF77 and GNUF77 defines determine which FORTRAN calling convention to use.
// Changed wx width and height accessor function for latest wxWidgets.
//
// Revision 1.36  2009/07/23 14:15:42  rich
// Removed all uses of OpenGL feedback buffer - was dreadful slow on some new graphics cards.
//
// Revision 1.35  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.1.1.1  2004/12/13 11:16:18  rich
// New CRYSTALS repository
//
// Revision 1.34  2004/11/08 16:48:36  stefan
// 1. Replaces some #ifdef (__WXGTK__) with #if defined(__WXGTK__) || defined(__WXMAC) to make the code compile correctly on the mac version.
//
// Revision 1.33  2004/10/07 11:16:05  rich
// Change _DEBUG to __CRDEBUG__.
//
// Revision 1.32  2004/10/06 13:57:26  rich
// Fixes for WXS version.
//
// Revision 1.31  2004/06/28 13:26:57  rich
// More Linux fixes, stl updates.
//
// Revision 1.30  2004/06/24 09:12:02  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.29  2004/02/09 22:05:55  rich
// Fix token pasting warnings in preprocessor - these have been upgraded
// to errors in gcc 3.3
//
// Revision 1.28  2003/11/28 10:29:11  rich
// Replace min and max macros with CRMIN and CRMAX. These names are
// less likely to confuse gcc.
//
// Revision 1.27  2003/09/16 14:49:31  rich
// Remove default logging from the Linux release version
//
// Revision 1.26  2003/08/13 16:02:05  rich
// Add definition of min and max macros to header.
//
// Revision 1.25  2003/05/07 12:18:57  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.24  2003/01/14 10:27:18  rich
// Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
// Revision 1.23  2002/12/16 18:26:40  rich
// Fix breaking Cameron menus. Add some debugging for debug version.
//
// Revision 1.22  2002/09/27 14:49:04  rich
// New marker for modlistbase.
//
// Revision 1.21  2002/07/23 08:27:02  richard
//
// Extra parameter during GRID creation: "ISOLATE" - grid won't expand when the
// window resizes, even if it contains objects which might like to expand.
//
// Revision 1.20  2002/07/03 14:23:21  richard
// Replace as many old-style stream class header references with new style
// e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
// Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
// stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
// Removed some bits from Steve's Plot classes that were generating (harmless) compiler
// warning messages.
//
// Revision 1.19  2001/10/10 12:44:50  ckp2
// The PLOT classes!
//
// Revision 1.18  2001/07/16 07:27:52  ckp2
// Just fiddling.
//
// Revision 1.17  2001/06/18 12:42:55  richard
// Remove definition of __WXGTK__ as it is defined on the compiler command line.
//
// Revision 1.16  2001/06/17 14:50:00  richard
// Bug in wx version of onchar macro.
//
// Revision 1.15  2001/03/27 15:15:00  richard
// Added a timer to the main window that is activated as the main window is
// created.
// The timer fires every half a second and causes any messages in the
// CRYSTALS message queue to be processed. This is not the main way that messages
// are found and processed, but sometimes the program just seemed to freeze and
// would stay that way until you moved the mouse. This should (and in fact, does
// seem to) remedy that problem.
// Good good good.
//
// Revision 1.14  2001/03/15 11:05:41  richard
// Error checking. Ensure that if ptr_to_cxObject is NULL then we don't call
// any of the Cx object's functions. (This allows CxModel to fail gracefully, and
// the application to continue working). NB. BECAUSE OF CHANGE TO CRYSTALSINTERFACE.H
// I'D RECOMMEND AT LEAST A 'code gui', IF NOT A 'code' or 'buildall'.
//
// Revision 1.13  2001/03/08 15:48:56  richard
// A lot of code was repeated across the Cr and Cx classes. I've moved it here
// in the form of #define macros. Mainly geometry getting and setting stuff.
//
// Revision 1.12  2001/01/25 17:13:32  richard
// kTabBase added. Tidied.
//
// Revision 1.11  2001/01/16 15:35:00  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.10  2000/12/13 18:03:08  richard
// Linux(wxWindows) and Windows(wxWindows) support added.
//
#ifndef     __CrystalsInterface_H__
#define     __CrystalsInterface_H__

#include <string>

typedef std::string tstring;

#ifdef __GID__
  #define CRY_GUI
  #define CRY_USEMFC
  #define CRY_OSWIN32
  #define CRY_TARGET GID
#endif
  
#ifdef __GIL__
  #define CRY_GUI
  #define CRY_USEWX
  #define CRY_OSLINUX
  #define CRY_TARGET GIL
#endif	

#ifdef __WXS__
  #define CRY_GUI
  #define CRY_USEWX
  #define CRY_OSWIN32
  #define CRY_TARGET WXS
#endif	

#ifdef __INW__
  #define CRY_GUI
  #define CRY_USEWX
  #define CRY_OSWIN32
  #define CRY_TARGET INW
#endif	

#ifdef __MAC__
  #define CRY_GUI
  #define CRY_USEWX
  #define CRY_OSMAC
  #define CRY_TARGET MAC
#endif	

#ifdef __MIN__
#ifndef CRY_GUI 
 #define CRY_GUI
#endif
  #define CRY_USEWX
// This next is also defined by CMake scripts for MinGW build - avoiding redefinition warning:
  #ifndef CRY_OSWIN32
     #define CRY_OSWIN32
  #endif
  #define CRY_TARGET MIN
#endif	
	
#ifdef __LIN__
//  #pragma warning(__FILE__" : warning: LIN target should not include crystalsinterface.h")
  #define CRY_TARGET LIN
  #define CRY_NOGUI
#endif	

#ifdef __DVF__
//  #pragma warning(__FILE__" : warning: DVF target should not include crystalsinterface.h")
  #define CRY_TARGET DVF
  #define CRY_NOGUI
#endif	
  



#define CRMAX(a, b)  (((a) > (b)) ? (a) : (b))
#define CRMIN(a, b)  (((a) < (b)) ? (a) : (b))

// Instructions

//NB Try to keep Windows ID's below 32767, I think
//   some bits of the API use short ints.
enum {
    kToolBarBase        =   15000,
    kToolButtonBase     =   20000,
    kMenuBase           =   25000,

    kButtonBase         =   40000,
    kListBoxBase        =   41000,
    kDropDownBase       =   42000,
    kEditBoxBase        =   43000,
    kGridBase           =   44000,
    kGroupBoxBase       =   45000,
    kMultiEditBase      =   46000,
    kTextBase           =   47000,
    kCheckBoxBase       =   48000,
    kRadioButtonBase    =   49000,
    kWindowBase         =   50000,
    kChartBase          =   52000,
    kModelBase          =   53000,
    kProgressBase       =   54000,
    kListCtrlBase       =   55000,
    kTextOutBase        =   56000,
    kBitmapBase         =   57000,
    kTabBase            =   58000,
    kResizeBarBase      =   59000,
    kStretchBase        =   60000,
    kPlotBase           =   61000,
    kModListBase        =   62000,
    kWebBase           =   63000
};
#define kNoAlignment        0
#define kIsolate            1
#define kRightAlign         2
#define kBottomAlign        4
#define kModal              1
#define kZoom               2
#define kClose              4
#define kSize               8
#define kFrame              16
#define EMPTY_CELL          10


#define NOTUSED(a) //Gets rid of warnings about unused variables.


#ifdef CRY_USEMFC
 
 #include "stdafx.h"
 #include "crystals.h"
 #define nil NULL
 #define WM_STUFFTOPROCESS 6351
 #ifdef _DEBUG
    #define __CRDEBUG__
 #endif

#else

 #define nil 0
 #include <wx/wx.h>
 typedef unsigned int UINT;
 #ifdef CRY_DEBUG
    #define __CRDEBUG__
 #endif
 #ifdef __CRDEBUG__
    #include <wx/object.h>
 #endif

 #endif


#define CRLEFT    0
#define CRRIGHT   1
#define CRUP      2
#define CRDOWN    3
#define CRINSERT  4
#define CRDELETE  5
#define CREND     6
#define CRESCAPE  7
#define CRCONTROL 8
#define CRSHIFT   9

#define CRCOVALENT    1
#define CRVDW       2
#define CRTHERMAL   3
#define CRSPARE     4
#define CRTINY      5



#ifdef __CRDEBUG__
 #define LOGERRORS    //        Log errors         (LOGERR macro)
 #define LOGWARNINGS  //        Log warnings       (LOGWARN macro)
 #define LOGSTATUS    //Log lots of things (LOGSTAT macro)
#else
// #define LOGSTATUS    //Log lots of things (LOGSTAT macro)
 #define LOGERRORS    //        Log errors         (LOGERR macro)
 #define LOGWARNINGS  //        Log warnings       (LOGWARN macro)
// #define LOGSTATUS    //Log lots of things (LOGSTAT macro)
#endif


#ifdef LOGERRORS
        #define LOGERR(a) ( (CcController::theController)->LogError(a,0) )
#else
        #define LOGERR(a)
#endif

#ifdef LOGWARNINGS
        #define LOGWARN(a) ( (CcController::theController)->LogError(a,1) )
#else
        #define LOGWARN(a)
#endif

#ifdef LOGSTATUS
        #define LOGSTAT(a) ( (CcController::theController)->LogError(a,2) )
        #define TEXTOUT(a) ( (CcController::theController)->Tokenize(a) )
#else
        #define LOGSTAT(a)
       #define TEXTOUT(a)
#endif




// The following functions are common to many classes,
// so I've made them into macros.

#define CRCALCLAYOUT(a,b)                                              \
CcRect a ::CalcLayout(bool recalc)                                                            \
{                                                                          \
  if(!recalc) return CcRect(0,0,m_InitHeight,m_InitWidth);                 \
  if ( ptr_to_cxObject )  {                           \
  return CcRect(0,0,(int)(m_InitHeight=(( b *)ptr_to_cxObject)->GetIdealHeight()),  \
                          m_InitWidth =(( b *)ptr_to_cxObject)->GetIdealWidth()); }  \
  return CcRect(0,0,0,0); \
};


#define CRGETGEOMETRY(a,b)                         \
CcRect a ::GetGeometry()                          \
{   \
if ( ptr_to_cxObject ) \
return CcRect((( b *)ptr_to_cxObject)->GetTop(),   \
(( b *)ptr_to_cxObject)->GetLeft(),                \
(( b *)ptr_to_cxObject)->GetTop()+                 \
(( b *)ptr_to_cxObject)->GetHeight(),              \
(( b *)ptr_to_cxObject)->GetLeft()+                \
(( b *)ptr_to_cxObject)->GetWidth());              \
return CcRect(0,0,0,0);                            \
};

#define CRSETGEOMETRY(a,b)                         \
void a ::SetGeometry (const CcRect * rect){        \
if ( ptr_to_cxObject ) \
(( b *)ptr_to_cxObject)->SetGeometry(         \
rect->mTop,rect->mLeft,rect->mBottom,rect->mRight);\
}                                                  \


#ifdef CRY_USEMFC

#define CXGETGEOMETRIES(a)    \
int a ::GetTop()  { RECT windowRect; GetWindowRect(&windowRect); return ( windowRect.top );}\
int a ::GetLeft() { RECT windowRect; GetWindowRect(&windowRect); return ( windowRect.left );}\
int a ::GetWidth() { CRect windowRect; GetWindowRect(&windowRect); return ( windowRect.Width());}\
int a ::GetHeight(){ CRect windowRect; GetWindowRect(&windowRect); return ( windowRect.Height());}

#define CXSETGEOMETRY(a)   \
void a ::SetGeometry(int t,int l,int b,int r){MoveWindow(l,t,r-l,b-t,true);}

#define CXONCHAR(a)  \
void a ::OnChar(UINT nChar,UINT nRepCnt,UINT nFlags){  \
NOTUSED(nRepCnt);NOTUSED(nFlags);   \
if(nChar==9){ptr_to_crObject->NextFocus( ( HIWORD(GetKeyState(VK_SHIFT))) ? true:false);return;}  \
else {ptr_to_crObject->FocusToInput((char)nChar);}}

#else

#define CXGETGEOMETRIES(a)    \
int a ::GetTop()  { return ( GetScreenRect().y );}\
int a ::GetLeft() { return ( GetScreenRect().x );}\
int a ::GetWidth() { return ( GetSize().GetWidth());}\
int a ::GetHeight(){ return ( GetSize().GetHeight());}

#define CXSETGEOMETRY(a)   \
void a ::SetGeometry(int t,int l,int b,int r){SetSize(l,t,r-l,b-t);}

#define CXONCHAR(a)  \
void a ::OnChar(wxKeyEvent &event){ \
if(event.GetKeyCode()==9){ptr_to_crObject->NextFocus(event.m_shiftDown);return;}  \
else if (event.IsKeyInCategory(WXK_CATEGORY_ARROW|WXK_CATEGORY_PAGING )) event.Skip();  \
else {ptr_to_crObject->FocusToInput((char)event.GetKeyCode());}}
//else {(CcController::theController)->LogError(#a,0);ptr_to_crObject->FocusToInput((char)event.GetKeyCode());}}

#endif



#endif
