////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CrWindow.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:26 Uhr
//   $Log: not supported by cvs2svn $
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
#include    "cctokenlist.h"
#include    "crgrid.h"
#include "ccstring.h"   // added by classview

class CxApp;
class CrMenuBar;

class   CrWindow : public CrGUIElement
{
  public:
    CrWindow( );
    ~CrWindow();

    CcParse ParseInput( CcTokenList * tokenList );
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry();
    CcRect  GetScreenGeometry();
    CcRect  CalcLayout(bool recalculate=false);
    void    ResizeWindow(int newWidth, int newHeight);
    void    SetText( CcString item );
    void    Show( Boolean show );
    void    Align();
    void    CrFocus();
    CrGUIElement *  FindObject( CcString Name );
    CrGUIElement *  GetRootWidget();

    void  AddToTabGroup(CrGUIElement* tElement);
    void* GetPrevTabItem(void* pElement);
    void* GetNextTabItem(void* pElement);
    void* FindTabItem(void* pElement);
    void  SendMeSysKeys( CrGUIElement* interestedWindow );
    void  SetCommandText(CcString theText);
    void  SetCancelText(CcString text);
    void  FocusToInput(char theChar);
    void  SetCommitText( CcString text);
    void  SetMainMenu(CrMenuBar* menu);
    void  Redraw();
    void  Enable ( bool enable );
    void  SetTimer();


//Callbacks (i.e. called from CxWindow)
    void CloseWindow();
    void Committed();
    void Cancelled();
    void NotifyControl();
    void SysKeyPressed ( UINT nChar );
    void SysKeyReleased ( UINT nChar );
    void MenuSelected(int id);
    void ToolSelected(int id);
    void SendCommand(CcString theText, Boolean jumpQueue = false);
    void TimerFired();

// attributes
    CrGrid *    mGridPtr;
    CcList *    mTabGroup;
    int mSafeClose;
    int m_relativePosition;
    Boolean m_Keep;
    Boolean mIsSizeable;
    Boolean mIsModal;
    Boolean mStayOpen;
    CrMenuBar* mMenuPtr;
    CcList mWindowsWantingSysKeys;
    int    wEnableFlags, wDisableFlags;

    static CcList mModalWindowStack;

private:
    CrGUIElement* m_relativeWinPtr;
    Boolean mCommitSet;
    Boolean mCancelSet;
    Boolean mCommandSet;
    CcString mCommitText;
    CcString mCancelText;
    CcString mCommandText;
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
#define kSClose         "CLOSE"
#define kSPosition  "POSITION"
#define kSRightOf   "RIGHTOF"
#define kSLeftOf    "LEFTOF"
#define kSAbove     "ABOVE"
#define kSBelow     "BELOW"
#define kSCascade   "CASCADE"
#define kSCentred   "CENTRED"
#define kSKeep      "KEEP"
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
 kTStayOpen,
 kTCreatePlotData
};


#endif
