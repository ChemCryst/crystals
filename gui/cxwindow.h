////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWindow.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.24  2012/05/03 15:41:08  rich
//   Mostly commented out debugging for future reference. Trying to track down flicker on dialog closure. May now be fixed...
//
//   Revision 1.23  2012/03/26 11:38:37  rich
//   Deprecated crweb control for now.
//
//   Revision 1.22  2011/05/16 10:56:32  rich
//   Added pane support to WX version. Added coloured bonds to model.
//
//   Revision 1.21  2011/04/21 11:21:28  rich
//   Various WXS improvements.
//
//   Revision 1.20  2011/03/04 05:56:04  rich
//   Event to catch unminimize (restore) event. Ensure all parent windows are unminimized.
//
//   Revision 1.19  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.18  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.17  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.16  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.15  2002/07/03 14:23:21  richard
//   Replace as many old-style stream class header references with new style
//   e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
//   Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
//   stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
//   Removed some bits from Steve's Plot classes that were generating (harmless) compiler
//   warning messages.
//
//   Revision 1.14  2001/12/12 14:18:41  ckp2
//   RIC: Mousewheel support! (Guess who's just got a new mouse.)
//   RIC: Also PGUP and PGDOWN and Mousewheel allow the textoutput to be
//   scrolled *even* *if* there is a dialog blocking other input. V. useful
//   as some dialog questions can be better answered after reviewing what
//   has happened in the text output.
//
//   Revision 1.13  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.12  2001/06/17 14:26:38  richard
//   Re-jig window creation.
//   New CxDestroyWindow function to ensure correct destruction sequence.
//   wx Support for toolbars.
//
//   Revision 1.11  2001/03/27 15:15:01  richard
//   Added a timer to the main window that is activated as the main window is
//   created.
//   The timer fires every half a second and causes any messages in the
//   CRYSTALS message queue to be processed. This is not the main way that messages
//   are found and processed, but sometimes the program just seemed to freeze and
//   would stay that way until you moved the mouse. This should (and in fact, does
//   seem to) remedy that problem.
//   Good good good.
//
//   Revision 1.10  2001/03/08 15:59:29  richard
//   Give non-modal windows a "toolbar-style" (thin) titlebar. Distinguishes them
//   from modal windows in users mind (eventually).
//

#ifndef     __CxWindow_H__
#define     __CxWindow_H__

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASEWINDOW CFrameWnd
#else
 #include <wx/frame.h>
 #include <wx/window.h>
 #include <wx/settings.h>
 #include <wx/menu.h>
 #include <wx/menuitem.h>
 //#include <wx/aui/aui.h>
 #define BASEWINDOW wxFrame
#endif

#include    "crguielement.h"
#include    "crwindow.h"
#include    "cxbutton.h"

class CxMenuBar;

class CxWindow : public BASEWINDOW
{
  public:
     static CxWindow *   CreateCxWindow( CrWindow * container, void * parentWindow, int attributes );
     CxWindow( CrWindow * container, int sizeable );
     ~CxWindow();
        void CxDestroyWindow();

     void SetGeometry( int top, int left, int bottom, int right );
     int GetTop();
     int GetLeft();
     int GetScreenTop();
     int GetScreenLeft();
     int GetWidth();
     int GetHeight();

     void AdjustSize( CcRect * clientSize );
     void SetMainMenu(CxMenuBar* menu);
     void SetText( const string &text );
     void SetDefaultButton( CxButton * inButton );

     void Focus();
     void Hide();
     void CxShowWindow();
     void CxEnable(bool state=true);
     void Redraw();
     void CxPreDestroy();
     void CxSetTimer();

// attributes
     CrGUIElement *  ptr_to_crObject;
     CxButton * mDefaultButton;
     bool mWindowWantsKeys;
  private:
     int m_attributes;
     bool mSizeable;
     static int mWindowCount;
     bool m_PreDestroyed;
     UINT m_TimerActive;
  protected:
     bool mProgramResizing;

  public:
//PRIVATE MS WINDOWS SPECIFIC FUNCTIONS AND OVERRIDES
#ifdef CRY_USEMFC
    BOOL PreCreateWindow(CREATESTRUCT& cs);
    afx_msg void OnClose();
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnGetMinMaxInfo(MINMAXINFO FAR* lpMMI);
    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnUpdateMenuItem(CCmdUI* pCmdUI);
    afx_msg void OnUpdateTools(CCmdUI* pCmdUI);
    afx_msg LRESULT OnMyNcPaint(WPARAM wparam, LPARAM lparam);
    afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnMenuSelected(UINT nID);
    afx_msg void OnToolSelected(UINT nID);
    afx_msg void OnTimer(UINT nID);
    afx_msg BOOL OnEraseBkgnd(CDC* pDC);

    DECLARE_MESSAGE_MAP()

  protected:
    CWnd* mParentWnd;
    BOOL CxWindow::PreTranslateMessage(MSG* pMsg);

#else

      void Activate( wxActivateEvent & event );
      void OnCloseWindow( wxCloseEvent & event );
      void OnSize ( wxSizeEvent & event );
      void OnChar ( wxKeyEvent & event );
      void OnMenuSelected(wxCommandEvent &event );
#ifdef DEPRECATEDCRY_USEWX
	  void OnHighlightMenuItem(wxMenuEvent & event);
#endif
      void OnToolSelected(wxCommandEvent &event );
      void OnUpdateMenuItem(wxUpdateUIEvent &event );
      void OnKeyDown( wxKeyEvent & event );
      void OnKeyUp( wxKeyEvent & event );
	  void OnIconize(wxIconizeEvent & event);
	  void OnSetFocus(wxFocusEvent& e);
	  //void TempKillFocus(wxFocusEvent& e);

      DECLARE_EVENT_TABLE()
		
	  void SetIsFrame();
//	  void SetFocus();

 protected:
    wxWindow* mParentWnd;
//     wxAuiManager m_mgr;
     wxWindowDisabler *m_wxWinDisabler;
	 public:
	 	  void AddPane(wxWindow* pane, unsigned int position, wxString text);
		  void SetPaneMin(wxWindow* pane, int w, int h);

#endif

};
#endif
