////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CrWindow.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:26 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.21  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.20  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.19  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.18  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.17  2003/02/25 15:36:48  rich
//   New WINDOW modifer "LARGE" makes the given window take up 64% of the area
//   of the Main CRYSTALS window, provided the window doesn't already have a
//   stored size from a previous "KEEP" modifier. This means that the first time
//   windows appear (e.g. Cameron) they don't have to be ridiculously small.
//
//   Revision 1.16  2003/01/15 14:06:29  rich
//   Some fail-safe code in the GUI. In the event of a creation of a window failing don't
//   allow the rest of the windows to be corrupted.
//
//   Revision 1.15  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//
//   Revision 1.14  2001/06/17 14:51:29  richard
//   New stayopen property for windows.
//
//   Revision 1.13  2001/03/27 15:15:00  richard
//   Added a timer to the main window that is activated as the main window is
//   created.
//   The timer fires every half a second and causes any messages in the
//   CRYSTALS message queue to be processed. This is not the main way that messages
//   are found and processed, but sometimes the program just seemed to freeze and
//   would stay that way until you moved the mouse. This should (and in fact, does
//   seem to) remedy that problem.
//   Good good good.
//
//   Revision 1.12  2001/03/08 15:46:00  richard
//   Re-written sizing and resizing code. DISABLEIF= and ENABLEIF= flags let
//   you disable a whole non-modal window based on current status.
//

#ifndef     __CrWindow_H__
#define     __CrWindow_H__
#include    "crguielement.h"
#include    "crgrid.h"
#include <string>
#include <list>
using namespace std;
   // added by classview

class CxApp;
class CrMenuBar;

class   CrWindow : public CrGUIElement
{
  public:
    CrWindow( );
    ~CrWindow();

    CcParse ParseInput( deque<string> &  tokenList );
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry();
    CcRect  GetScreenGeometry();
    CcRect  CalcLayout(bool recalculate=false);
    void    ResizeWindow(int newWidth, int newHeight);
    void    SetText( const string &item );
    void    Show( bool show );
    void    Align();
    void    CrFocus();
    CrGUIElement *  FindObject( const string & Name );
    CrGUIElement *  GetRootWidget();

    void  AddToTabGroup(CrGUIElement* tElement);
    void* GetPrevTabItem(void* pElement);
    void* GetNextTabItem(void* pElement);
    void* FindTabItem(void* pElement);
    void  SendMeSysKeys( CrGUIElement* interestedWindow );
    void  SetCommandText(const string & theText);
    void  SetCancelText(const string & text);
    void  FocusToInput(char theChar);
    void  SetCommitText(const string & text);
    void  SetMainMenu(CrMenuBar* menu);
    void  Redraw();
    void  Enable ( bool enable );
    void  SetTimer();

	void  SetPane(void* ptr, unsigned int position, string text);
    void  SetPaneMin(void* ptr,int totWidth,int totHeight);


//Callbacks (i.e. called from CxWindow)
    void CloseWindow();
    void Committed();
    void Cancelled();
    void NotifyControl();
    void SysKeyPressed ( UINT nChar );
    void SysKeyReleased ( UINT nChar );
    void MenuSelected(int id);
    void ToolSelected(int id);
    void SendCommand(const string & theText, bool jumpQueue = false);
    void TimerFired();
	void CheckFocus();
	
// attributes
    CrGrid *    mGridPtr;
    list<CrGUIElement*>    mTabGroup;
    int mSafeClose;
    int m_relativePosition;
    bool m_Keep;
    bool m_Large;
    bool m_Shown;
    bool mIsSizeable;
    bool mIsModal;
    bool mIsFrame;
    bool mStayOpen;
    CrMenuBar* mMenuPtr;
    list<CrGUIElement*> mWindowsWantingSysKeys;
    int    wEnableFlags, wDisableFlags;

    static list<CrWindow*> mModalWindowStack;

private:

    CcRect GetScreenArea();

    CrGUIElement* m_relativeWinPtr;
    bool mCommitSet;
    bool mCancelSet;
    bool mCommandSet;
    string mCommitText;
    string mCancelText;
    string mCommandText;
    bool m_AddedToDisableAbleWindowList;
};

#define kSCreateModelDoc    "MODEL"
#define kSCreateChartDoc    "CHART"
#define kSCreatePlotData    "PLOTDATA"
#define kSShowWindow        "SHOW"
#define kSHideWindow        "HIDE"
#define kSDefineMenu        "DEFINEMENU"
#define kSModal         "MODAL"
#define kSZoom          "ZOOM"
#define kSSize          "SIZE"
#define kSFrame  		"FRAME"
#define kSClose         "CLOSE"
#define kSPosition  "POSITION"
#define kSRightOf   "RIGHTOF"
#define kSLeftOf    "LEFTOF"
#define kSAbove     "ABOVE"
#define kSBelow     "BELOW"
#define kSCascade   "CASCADE"
#define kSCentred   "CENTRED"
#define kSKeep      "KEEP"
#define kSLarge      "LARGE"
#define kSStayOpen  "STAYOPEN"

enum
{
 kTCreateModelDoc = 1600,
 kTCreateChartDoc,
 kTShowWindow,
 kTHideWindow,
 kTDefineMenu,
 kTModal,
 kTZoom,
 kTSize,
 kTClose,
 kTPosition,
 kTRightOf,
 kTLeftOf,
 kTAbove,
 kTBelow,
 kTCascade,
 kTCentred,
 kTKeep,
 kTLarge,
 kTStayOpen,
 kTCreatePlotData,
 kTFrame
};


#endif
