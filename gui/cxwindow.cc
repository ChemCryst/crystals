////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWindow.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.26  2001/12/12 14:18:40  ckp2
//   RIC: Mousewheel support! (Guess who's just got a new mouse.)
//   RIC: Also PGUP and PGDOWN and Mousewheel allow the textoutput to be
//   scrolled *even* *if* there is a dialog blocking other input. V. useful
//   as some dialog questions can be better answered after reviewing what
//   has happened in the text output.
//
//   Revision 1.25  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.24  2001/07/16 07:38:38  ckp2
//   Some system metrics missing from wx implementation on Linux, work around these.
//   Also OnSize parameters are window size, not client size like MFC, so use a call to
//   GetClientSize to work out the equivalent size.
//
//   Revision 1.23  2001/06/18 12:57:39  richard
//   ? operator was returning a NULL for non-modal window styles, should be a 0 as it is
//   part of a bitwise OR operation.
//
//   Revision 1.22  2001/06/17 14:26:37  richard
//   Re-jig window creation.
//   New CxDestroyWindow function to ensure correct destruction sequence.
//   wx Support for toolbars.
//
//   Revision 1.21  2001/03/27 15:15:00  richard
//   Added a timer to the main window that is activated as the main window is
//   created.
//   The timer fires every half a second and causes any messages in the
//   CRYSTALS message queue to be processed. This is not the main way that messages
//   are found and processed, but sometimes the program just seemed to freeze and
//   would stay that way until you moved the mouse. This should (and in fact, does
//   seem to) remedy that problem.
//   Good good good.
//
//   Revision 1.20  2001/03/08 15:59:29  richard
//   Give non-modal windows a "toolbar-style" (thin) titlebar. Distinguishes them
//   from modal windows in users mind (eventually).
//

#include    "crystalsinterface.h"
#include    "cxwindow.h"
#include    "cxmenubar.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "crtoolbar.h"
#include    "cccontroller.h"
#include    "crtextout.h"

#ifdef __LINUX__
#include "wincrys.xpm"
#endif

int CxWindow::mWindowCount = kWindowBase;


CxWindow * CxWindow::CreateCxWindow( CrWindow * container, void * parentWindow, int attributes )
{

  LOGSTAT ( CcString("CxWindow created. Parent = ") + CcString ( (int)parentWindow ) );

  CxWindow *theWindow = new CxWindow( container, attributes & kSize );

  #ifdef __CR_WIN__
    HCURSOR hCursor = AfxGetApp()->LoadCursor(IDC_ARROW);

    const char* wndClass = AfxRegisterWndClass( CS_HREDRAW|CS_VREDRAW,
                                       hCursor, (HBRUSH)(COLOR_3DFACE+1),
                                      AfxGetApp()->LoadIcon(IDI_ICON1));
      
    theWindow->mParentWnd = (CWnd*) parentWindow;

    theWindow->Create(wndClass, "Window",
//    theWindow->Create(NULL, "Window",
        (attributes & kSize)? WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_MAXIMIZEBOX|WS_MINIMIZEBOX|WS_CLIPCHILDREN :
                              WS_POPUP|WS_CAPTION|WS_SYSMENU|WS_CLIPCHILDREN,
        CRect(0,0,1000,1000), theWindow->mParentWnd);

//    theWindow->SetIcon(AfxGetApp()->LoadIcon(IDI_ICON1),true);
  #endif
  #ifdef __BOTHWX__
      theWindow->mParentWnd = (wxWindow*) parentWindow;
      theWindow->Create( theWindow->mParentWnd, -1, "Window",
                         wxPoint(0, 0), wxSize(-1,-1),
                         (attributes & kSize)?wxDEFAULT_FRAME_STYLE|wxFRAME_FLOAT_ON_PARENT|((attributes & kModal)?0:wxFRAME_TOOL_WINDOW) :wxDEFAULT_DIALOG_STYLE|wxFRAME_FLOAT_ON_PARENT|((attributes & kModal)?0:wxFRAME_TOOL_WINDOW) );
      theWindow->SetIcon( wxICON (IDI_ICON1) );
  #endif

  //if the window is modal, disable the parent:

  if ( attributes & kModal )
  {
    if ( theWindow->mParentWnd )
    {
      #ifdef __CR_WIN__
        theWindow->mParentWnd->EnableWindow(false);
        theWindow->EnableWindow(true);  //All child windows have been disabled by the last call, so re-enable this one.
        theWindow->ModifyStyle(WS_MINIMIZEBOX,NULL,SWP_NOZORDER); //No Minimize box for modal windows with parents.
      #endif
      #ifdef __BOTHWX__
        theWindow->mParentWnd->Enable(false);
        theWindow->Enable(true);  //All child windows have been disabled, so re-enable this one.
      #endif
    }
  }
  else
  {
    #ifdef __CR_WIN__
      theWindow->ModifyStyleEx(NULL,WS_EX_TOOLWINDOW,NULL); //Small title bar effect.
    #endif
  }

  #ifdef __CR_WIN__
    if ( attributes & kSize ) theWindow->ModifyStyle(NULL,WS_BORDER|WS_THICKFRAME,SWP_NOZORDER);
  #endif

  return (theWindow);
}


CxWindow::CxWindow( CrWindow * container, int sizeable )
{

    ptr_to_crObject = container;
    mProgramResizing = true;
    mDefaultButton = nil;
    mSizeable = (sizeable==0) ? false : true;
    mWindowWantsKeys = false;
    m_PreDestroyed = false;
    m_TimerActive = 0;

}

void CxWindow::CxPreDestroy()
{
    if (mParentWnd)
#ifdef __CR_WIN__
    {
      mParentWnd->EnableWindow(true); //Re-enable the parent.
      mParentWnd->SetFocus(); //Focus the parent.
    }
    if ( m_TimerActive )
    {
      if ( KillTimer ( m_TimerActive ) == 0 )
      {
        LOGERR ( "Kill Timer failed to find timer." );
      }
    }
#endif
#ifdef __BOTHWX__
    mParentWnd->Enable(true); //Re-enable the parent.
#endif
    m_PreDestroyed = true;
}

CxWindow::~CxWindow()
{
    ((CrWindow*)ptr_to_crObject)->NotifyControl();
    mWindowCount--;
    if ( !m_PreDestroyed ) CxPreDestroy(); // Should really be called earlier.
}

void CxWindow::CxDestroyWindow()
{
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}

void    CxWindow::SetText( char * text )
{

#ifdef __CR_WIN__
    SetWindowText(text);
#endif
#ifdef __BOTHWX__
      SetTitle(text);
#endif
}

void    CxWindow::CxShowWindow()
{
#ifdef __CR_WIN__
      ShowWindow(SW_SHOW);
    UpdateWindow();
#endif
#ifdef __BOTHWX__
      Show(true);
#endif
}

void    CxWindow::SetGeometry( int top, int left, int bottom, int right )
{
  LOGSTAT( "CxWindow::SetGeom called " + CcString(top) + " " + CcString(left)+ " " + CcString(bottom) + " " + CcString(right) );

  if(mProgramResizing)  //Only move the window, if the program is resizing it.
  {
    LOGSTAT(" Progresizing is TRUE ");
#ifdef __CR_WIN__
    MoveWindow(left, top, (right-left), (bottom-top),true);
#endif
#ifdef __BOTHWX__
    SetSize(left,top,right-left,bottom-top);
    Refresh();
#endif
  }
  else // if the user is resizing, then the window is already the right size.
  {
    LOGSTAT(" Progresizing is FALSE ");
  }
}

CXGETGEOMETRIES(CxWindow)

int   CxWindow::GetScreenTop()
{
#ifdef __CR_WIN__
      RECT windowRect;
      GetWindowRect(&windowRect);
      return ( windowRect.top );
#endif
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
    if(parent != nil)
    {
            parentRect = parent->GetRect();
            windowRect.y -= parentRect.y;
    }
      return ( windowRect.y );
#endif
}
int   CxWindow::GetScreenLeft()
{
#ifdef __CR_WIN__
      RECT windowRect;
      GetWindowRect(&windowRect);
      return ( windowRect.left );
#endif
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
    if(parent != nil)
    {
            parentRect = parent->GetRect();
            windowRect.x -= parentRect.x;
    }
      return ( windowRect.x );
#endif

}


void    CxWindow::SetDefaultButton( CxButton * inButton )
{
    mDefaultButton = inButton;
}


void CxWindow::Hide()
{

#ifdef __CR_WIN__
    CFrameWnd::ShowWindow(SW_HIDE);
    if (mParentWnd)
            mParentWnd->EnableWindow(true); //Re-enable the parent.
#endif
#ifdef __BOTHWX__
      Show(false);
    if (mParentWnd)
            mParentWnd->Enable(true); //Re-enable the parent.
#endif
}


//////PRIVATE WINDOWS SPECIFIC FUNCTIONS AND OVERRIDES


/////////////////////////////////////////////////////////////////////////////
// CxWindow

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxWindow, CFrameWnd)
    ON_WM_CLOSE()
    ON_WM_SIZE()
    ON_WM_GETMINMAXINFO()
    ON_MESSAGE(WM_NCPAINT, OnMyNcPaint)
    ON_WM_CHAR()
    ON_COMMAND_RANGE(kToolButtonBase, kToolButtonBase+5000, OnToolSelected)
    ON_COMMAND_RANGE(kMenuBase, kMenuBase+5000, OnMenuSelected)
    ON_UPDATE_COMMAND_UI_RANGE(kToolButtonBase,kToolButtonBase+5000,OnUpdateTools)
    ON_UPDATE_COMMAND_UI_RANGE(kMenuBase,kMenuBase+5000,OnUpdateMenuItem)
    ON_WM_KEYDOWN()
    ON_WM_KEYUP()
    ON_WM_TIMER()
    ON_WM_ERASEBKGND()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Map
BEGIN_EVENT_TABLE(CxWindow, wxFrame)
      EVT_CLOSE( CxWindow::OnClose )
      EVT_SIZE( CxWindow::OnSize )
      EVT_CHAR( CxWindow::OnChar )
      EVT_COMMAND_RANGE(kMenuBase, kMenuBase+1000,
                        wxEVT_COMMAND_MENU_SELECTED,
                        CxWindow::OnMenuSelected )
      EVT_COMMAND_RANGE(kMenuBase, kMenuBase+1000,
                        wxEVT_UPDATE_UI,
                        CxWindow::OnUpdateMenuItem )
      EVT_COMMAND_RANGE(kToolButtonBase, kToolButtonBase+5000,
                        wxEVT_COMMAND_MENU_SELECTED,
                        CxWindow::OnToolSelected)
      EVT_KEY_DOWN( CxWindow::OnKeyDown )
END_EVENT_TABLE()
#endif


#ifdef __CR_WIN__
void CxWindow::OnUpdateMenuItem(CCmdUI* pCmdUI)
{
    CcMenuItem* theItem = (CcController::theController)->FindMenuItem(pCmdUI->m_nID);
    if(theItem == nil) return;

    if ( (CcController::theController)->status.ShouldBeEnabled( theItem->enable, theItem->disable ) )
            pCmdUI->Enable(true);
    else
            pCmdUI->Enable(false);
}
void CxWindow::OnUpdateTools(CCmdUI* pCmdUI)
{
    CcTool* theItem = (CcController::theController)->FindTool(pCmdUI->m_nID);
    if(theItem == nil) return;

    if ( (CcController::theController)->status.ShouldBeEnabled( theItem->tEnableFlags, theItem->tDisableFlags ) )
            pCmdUI->Enable(true);
    else
            pCmdUI->Enable(false);
}
#endif
#ifdef __BOTHWX__
void CxWindow::OnUpdateMenuItem(wxUpdateUIEvent & pCmdUI)
{
    CcMenuItem* theItem = (CcController::theController)->FindMenuItem(pCmdUI.m_id);
    if(theItem == nil) return;

    if ( (CcController::theController)->status.ShouldBeEnabled( theItem->enable, theItem->disable ) )
            pCmdUI.Enable(true);
    else
            pCmdUI.Enable(false);
}
#endif



/////////////////////////////////////////////////////////////////////////////
// CxWindow message handlers

#ifdef __CR_WIN__
void CxWindow::OnClose()
{
    ((CrWindow*)ptr_to_crObject)->CloseWindow();

// Don't close the Window via the framework. On close should indicate to the controller that
// ESC / CANCEL / CLOSE event has occured. The Controller will destroy the window, if it sees fit.
//  CFrameWnd::OnClose();
}
#endif
#ifdef __BOTHWX__
void CxWindow::OnClose(wxCloseEvent & event)
{
    ((CrWindow*)ptr_to_crObject)->CloseWindow();
}
#endif



#ifdef __CR_WIN__
void CxWindow::OnSize(UINT nType, int cx, int cy)
{
    LOGSTAT( "OnSize called " + CcString(cx) + " " + CcString(cy) );
    CFrameWnd::OnSize(nType, cx, cy);
    mProgramResizing = false;
    if ( nType == SIZE_MINIMIZED ) return;
#endif

#ifdef __BOTHWX__
void CxWindow::OnSize(wxSizeEvent & event)
{
      LOGSTAT( "OnSize called " + CcString(event.GetSize().x) + " " + CcString(event.GetSize().y) );
      int cx,cy;
      mProgramResizing = false;
      GetClientSize(&cx,&cy); //Onsize is whole window - we only want this bit.
#endif

    ((CrWindow*)ptr_to_crObject)->ResizeWindow( cx ,cy );
    mProgramResizing = true;
}

#ifdef __CR_WIN__
void CxWindow::OnGetMinMaxInfo(MINMAXINFO FAR* lpMMI)
{
    int mN = ( GetMenu() != NULL ) ? GetSystemMetrics(SM_CYMENU) : 0; //Height of the menu, if there is one. Otherwise zero.
    int cH = GetSystemMetrics(SM_CYCAPTION);
    int bT = GetSystemMetrics(SM_CXSIZEFRAME); //I think this is the maximum from SM_CXBORDER, SM_CXEDGE, SM_CXDLGFRAME...

        int minHeight = 15+( mN + cH + 2*bT );
        int minWidth  = 30+(2*bT);

    lpMMI->ptMinTrackSize.x = minWidth;
    lpMMI->ptMinTrackSize.y = minHeight;

    CFrameWnd::OnGetMinMaxInfo(lpMMI);
}
#endif

CXONCHAR(CxWindow)


void CxWindow::Focus()
{
    SetFocus();
}

void CxWindow::SetMainMenu(CxMenuBar * menu)
{
#ifdef __CR_WIN__
      int i = (int)SetMenu(menu);
#endif
#ifdef __BOTHWX__
      SetMenuBar( menu );
#endif
}


#ifdef __CR_WIN__
void CxWindow::OnMenuSelected(UINT nID)
{
    TRACE("Menu ID %d\n", nID);
#endif
#ifdef __BOTHWX__
void CxWindow::OnMenuSelected(wxCommandEvent & event)
{
      int nID = event.m_id;
#endif
    ((CrWindow*)ptr_to_crObject)->MenuSelected( nID );

}


#ifdef __CR_WIN__
void CxWindow::OnToolSelected(UINT nID)
{
    TRACE("Tool ID %d\n", nID);
#endif
#ifdef __BOTHWX__
void CxWindow::OnToolSelected(wxCommandEvent & event)
{
      int nID = event.m_id;
#endif
    ((CrWindow*)ptr_to_crObject)->ToolSelected( nID );
}




#ifdef __CR_WIN__
BOOL CxWindow::PreCreateWindow(CREATESTRUCT& cs)
{
//  cs.style |= (WS_CLIPCHILDREN | WS_CLIPSIBLINGS);
/*  if( (cs.style & WS_BORDER ) == WS_BORDER) TRACE("BORDER\n");
    if( (cs.style & WS_CAPTION ) == WS_CAPTION) TRACE("CAPTION\n");
    if( (cs.style & WS_DLGFRAME ) == WS_DLGFRAME) TRACE("DLGFRAME\n");
    if( (cs.style & WS_OVERLAPPED ) == WS_OVERLAPPED) TRACE("OVERLAPPED\n");
    if( (cs.style & WS_OVERLAPPEDWINDOW ) == WS_OVERLAPPEDWINDOW) TRACE("OVERLAPPEDWINDOW\n");
    if( (cs.style & WS_THICKFRAME ) == WS_THICKFRAME) TRACE("THICKFRAME\n");
    if( (cs.dwExStyle & WS_EX_CLIENTEDGE ) == WS_EX_CLIENTEDGE)  TRACE("EX_CLIENTEDGE\n");
    if( (cs.dwExStyle & WS_EX_DLGMODALFRAME   ) == WS_EX_DLGMODALFRAME )  TRACE("EX_DLGMODALFRAME\n");
    if( (cs.dwExStyle & WS_EX_OVERLAPPEDWINDOW ) == WS_EX_OVERLAPPEDWINDOW)  TRACE("EX_OVERLAPPEDWINDOW\n");
    if( (cs.dwExStyle & WS_EX_WINDOWEDGE ) == WS_EX_WINDOWEDGE)  TRACE("EX_WINDOWEDGE\n");
*/
    cs.style &= (~WS_THICKFRAME);
    cs.style &= (~WS_DLGFRAME);
    cs.style &= (~WS_BORDER);
    cs.style |= (WS_CAPTION);
    cs.dwExStyle |= WS_EX_WINDOWEDGE;

    return CFrameWnd::PreCreateWindow(cs);
}

LRESULT CxWindow::OnMyNcPaint(WPARAM wParam, LPARAM lParam)
{
//The sole purpose of this routine is to paint out the internal
//border of the window, thus giving the window a much nicer (and more
//standard look)
//Call the default procedure for painting the non-client area.
    DefWindowProc( WM_NCPAINT, wParam, lParam );

    if(!mSizeable)
    {
//Paint over the bits that we want to.
        CWindowDC dc(this);
        CRect windowRect, clientRect;
        GetWindowRect( &windowRect );
        GetClientRect( &clientRect );
        clientRect.bottom += 3;
        int xframe = GetSystemMetrics( SM_CXFRAME ) + 1;
        int yframe = GetSystemMetrics( SM_CYFRAME ) + 1;

        CPen pen(PS_SOLID,1,GetSysColor(COLOR_3DFACE)), *oldpen;
//      CPen pen(PS_SOLID,1,RGB(0,255,0)), *oldpen; //Use this line for debugging!
        oldpen = dc.SelectObject(&pen);

        int top = windowRect.Height() - clientRect.Height() - yframe;
        int bottom = windowRect.Height() - yframe;
        int left = xframe;
        int right = windowRect.Width() - xframe;

// Spiral from left to left - 2.
//        from bottom -1 to bottom + 1.
//        from right to right + 2
//        from top +2 to top

// This draws over enough of the border to account for the two
// different types of window - sizeable, and fixed size.


        dc.MoveTo( right     , top + 2    );
        dc.LineTo( left      , top + 2    );
        dc.LineTo( left      , bottom - 1 );
        dc.LineTo( right     , bottom - 1 );
        dc.LineTo( right     , top + 1    );
        dc.LineTo( left - 1  , top + 1    );
        dc.LineTo( left - 1  , bottom     );
        dc.LineTo( right + 1 , bottom     );
        dc.LineTo( right + 1 , top        );
        dc.LineTo( left - 2  , top        );
        dc.LineTo( left - 2  , bottom + 1 );
        dc.LineTo( right + 2 , bottom + 1 );

// Do not call CFrameWnd::OnNcPaint() for painting messages

        dc.SelectObject(oldpen);
    }

    return 0; //Indicate that the nc area has been painted.

}
#endif


void CxWindow::AdjustSize(CcRect * size)
{
#ifdef __CR_WIN__
    int cH = GetSystemMetrics(SM_CYCAPTION);
    int bT = GetSystemMetrics(SM_CXSIZEFRAME); //I think this is the maximum from SM_CXBORDER, SM_CXEDGE, SM_CXDLGFRAME...
    int mN = ( GetMenu() != NULL ) ? GetSystemMetrics(SM_CYMENU) : 0; //Height of the menu, if there is one. Otherwise zero.
//              This the test      ?       value if test is true : value if false
#endif
#ifdef __BOTHWX__
// The system metrics aren't implemented yet!
       int mN = ( GetMenuBar() ) ? 20 : 0;
       int cH = 15;
       int bT = 4;
//      int mN = ( GetMenuBar() != NULL ) ? wxSystemSettings::GetSystemMetric(wxSYS_MENU_Y) : 0;
//      int cH = wxSystemSettings::GetSystemMetric(wxSYS_CAPTION_Y);
//      int bT = wxSystemSettings::GetSystemMetric(wxSYS_FRAMESIZE_X);
#endif
 
    size->mRight  = size->Right()  + (2*bT);
    size->mBottom = size->Bottom() + ((2*bT)+cH+mN);

    return;
}

#ifdef __CR_WIN__
void CxWindow::OnKeyDown ( UINT nChar, UINT nRepCnt, UINT nFlags )
{
      int key = -1;
      CrGUIElement * theElement;
      switch (nChar) {
           case VK_LEFT:
                  key = CRLEFT;
                  break;
           case VK_RIGHT:
                  key = CRRIGHT;
                  break;
           case VK_UP:
                  key = CRUP;
                  break;
           case VK_DOWN:
                  key = CRDOWN;
                  break;
           case VK_INSERT:
                  key = CRINSERT;
                  break;
           case VK_DELETE:
                  key = CRDELETE;
                  break;
           case VK_END:
                  key = CREND;
                  break;
           case VK_ESCAPE:
                  key = CRESCAPE;
                  break;
           case VK_CONTROL:
                  key = CRCONTROL;
                  break;
           case VK_SHIFT:
                  key = CRSHIFT;
                  break;
           case VK_PRIOR:
                  theElement = (CcController::theController)->GetTextOutputPlace();
                  if (theElement)
                    ((CrTextOut*)theElement)->ScrollPage(true);
                  break;
           case VK_NEXT:
                  theElement = (CcController::theController)->GetTextOutputPlace();
                  if (theElement)
                    ((CrTextOut*)theElement)->ScrollPage(false);
                  break;

           default:
                  //Do nothing
                  break;
      }

      if (key >= 0)
            ((CrWindow*)ptr_to_crObject)->SysKeyPressed( key );

      CWnd::OnKeyDown( nChar, nRepCnt, nFlags );
}
#endif
#ifdef __CR_WIN__
void CxWindow::OnKeyUp ( UINT nChar, UINT nRepCnt, UINT nFlags )
{
      int key = -1;
      switch (nChar) {
           case VK_LEFT:
                  key = CRLEFT;
                  break;
           case VK_RIGHT:
                  key = CRRIGHT;
                  break;
           case VK_UP:
                  key = CRUP;
                  break;
           case VK_DOWN:
                  key = CRDOWN;
                  break;
           case VK_INSERT:
                  key = CRINSERT;
                  break;
           case VK_DELETE:
                  key = CRDELETE;
                  break;
           case VK_END:
                  key = CREND;
                  break;
           case VK_ESCAPE:
                  key = CRESCAPE;
                  break;
           case VK_CONTROL:
                  key = CRCONTROL;
                  break;
           case VK_SHIFT:
                  key = CRSHIFT;
                  break;
           default:
                  //Do nothing
                  break;
      }

      if (key >= 0)
            ((CrWindow*)ptr_to_crObject)->SysKeyReleased( key );

      CWnd::OnKeyDown( nChar, nRepCnt, nFlags );
}
#endif

#ifdef __BOTHWX__
void CxWindow::OnKeyDown( wxKeyEvent & event )
{
      int key = -1;

      switch(event.KeyCode())
    {
           case WXK_LEFT:
                  key = CRLEFT;
                  break;
           case WXK_RIGHT:
                  key = CRRIGHT;
                  break;
           case WXK_UP:
                  key = CRUP;
                  break;
           case WXK_DOWN:
                  key = CRDOWN;
                  break;
           case WXK_INSERT:
                  key = CRINSERT;
                  break;
           case WXK_DELETE:
                  key = CRDELETE;
                  break;
           case WXK_END:
                  key = CREND;
                  break;
           case WXK_ESCAPE:
                  key = CRESCAPE;
                  break;
           default:
                  //Do nothing
                  break;
      }

      if (key >= 0)
            ((CrWindow*)ptr_to_crObject)->SysKeyPressed( key );


// Carry on processing this event.
      event.Skip();

}
#endif


void CxWindow::Redraw()
{
#ifdef __CR_WIN__
  Invalidate();
#endif
#ifdef __BOTHWX__
  Refresh();
#endif
}

void CxWindow::CxEnable(bool enable)
{
#ifdef __CR_WIN__
  EnableWindow(enable);
#endif
#ifdef __BOTHWX__
  Enable(enable);
#endif
}


void CxWindow::CxSetTimer()
{
#ifdef __CR_WIN__
  if ( m_TimerActive )
  {
    LOGERR ( "Timer called more than once." );
    return; //only to be called once.
  }
  m_TimerActive = SetTimer ( 1007, 500, NULL ); // 500ms updates.
#endif
}

#ifdef __CR_WIN__
void CxWindow::OnTimer(UINT nID)
{
  ((CrWindow*)ptr_to_crObject)->TimerFired();
}
#endif




BOOL CxWindow::OnEraseBkgnd(CDC* pDC)
{
  return TRUE;
}


BOOL CxWindow::PreTranslateMessage(MSG* pMsg)
{
 // TODO: Add your specialized code here and/or call the base class
  if (pMsg->message == WM_MOUSEWHEEL)
  {
    CrGUIElement* theElement = (CcController::theController)->GetTextOutputPlace();
    if (theElement)
      ((CWnd*)theElement->ptr_to_cxObject)->SendMessage(WM_MOUSEWHEEL, pMsg->wParam, pMsg->lParam);
    return TRUE;
  }
  return CWnd::PreTranslateMessage(pMsg);
  // call the base class here
}



