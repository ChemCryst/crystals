////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWindow.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 16:45 Uhr

#ifndef     __CxWindow_H__
#define     __CxWindow_H__
//Insert your own code here.
#include    "crguielement.h"
#include    "crwindow.h"
#include    "cxbutton.h"

#ifdef __BOTHWX__
#include <wx/frame.h>
#include <wx/window.h>
#include <wx/settings.h>
#include <wx/menu.h>
#include <wx/menuitem.h>
#define BASEWINDOW wxFrame
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEWINDOW CFrameWnd
#endif

class CxMenuBar;

class CxWindow : public BASEWINDOW
{
    public:
        void AdjustSize( CcRect * clientSize );
        void SetMainMenu(CxMenuBar* menu);
        void Focus();
        void Hide();
        // methods
        static CxWindow *   CreateCxWindow( CrWindow * container, void * parentWindow, int attributes );
            CxWindow( CrWindow * container, int sizeable );
        virtual ~CxWindow();
        void    SetText( char * text );
        void    CxShowWindow();
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
                int     GetScreenTop();
                int     GetScreenLeft();
        int GetWidth();
        int GetHeight();
//      LTabGroup * GetTabCommander();
//      Boolean HandleKeyPress( const EventRecord   &inKeyEvent );
        void    SetDefaultButton( CxButton * inButton );
        // attributes
        CrGUIElement *  ptr_to_crObject;
//      LTabGroup   * mTabGroup;
        CxButton * mDefaultButton;
            Boolean mWindowWantsKeys;

//PRIVATE MS WINDOWS SPECIFIC FUNCTIONS AND OVERRIDES
#ifdef __CR_WIN__
    BOOL PreCreateWindow(CREATESTRUCT& cs);
//Message handlers
    afx_msg void OnClose();
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnGetMinMaxInfo(MINMAXINFO FAR* lpMMI);
    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnUpdateMenuItem(CCmdUI* pCmdUI);
    afx_msg LRESULT OnMyNcPaint(WPARAM wparam, LPARAM lparam);
      afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
      afx_msg void OnKeyUp(UINT nChar, UINT nRepCnt, UINT nFlags);
      afx_msg void OnMenuSelected(int nID);

    DECLARE_MESSAGE_MAP()

protected:
    CWnd* mParentWnd;
#endif


#ifdef __BOTHWX__

      void OnClose( wxCloseEvent & event );
      void OnSize ( wxSizeEvent & event );
      void OnChar ( wxKeyEvent & event );
      void OnMenuSelected(wxCommandEvent &event );
      void OnUpdateMenuItem(wxUpdateUIEvent &event );
      void OnKeyDown( wxKeyEvent & event );
      void OnKeyUp( wxKeyEvent & event );

      DECLARE_EVENT_TABLE()


      protected:
      wxWindow* mParentWnd;
#endif

private:
    Boolean mSizeable;
    static int mWindowCount;
protected:
    Boolean mProgramResizing;
};
#endif
