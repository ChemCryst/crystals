
////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWindow.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.47  2012/05/03 16:00:10  rich
//   Oops.
//
//   Revision 1.46  2012/05/03 15:41:08  rich
//   Mostly commented out debugging for future reference. Trying to track down flicker on dialog closure. May now be fixed...
//
//   Revision 1.45  2012/03/26 11:38:37  rich
//   Deprecated crweb control for now.
//
//   Revision 1.44  2011/05/16 10:56:32  rich
//   Added pane support to WX version. Added coloured bonds to model.
//
//   Revision 1.43  2011/04/21 11:21:28  rich
//   Various WXS improvements.
//
//   Revision 1.42  2011/03/04 05:55:20  rich
//   Make windows and dialogs on WX version more like the GID version.
//
//   Revision 1.41  2008/09/22 12:31:37  rich
//   Upgrade GUI code to work with latest wxWindows 2.8.8
//   Fix startup crash in OpenGL (cxmodel)
//   Fix atom selection infinite recursion in cxmodlist
//
//   Revision 1.40  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.2  2005/01/12 16:11:31  rich
//   Use system metrics if available under WX. (Probably still not on MAC).
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.38  2004/11/11 14:39:18  stefan
//   1. Mac application files
//
//   Revision 1.37  2004/11/08 16:48:36  stefan
//   1. Replaces some #ifdef (__WXGTK__) with #if defined(__WXGTK__) || defined(__WXMAC) to make the code compile correctly on the mac version.
//
//   Revision 1.36  2004/10/08 09:02:22  rich
//   Fix window sizing bug. Now uses system metrics.
//
//   Revision 1.35  2004/10/06 13:57:26  rich
//   Fixes for WXS version.
//
//   Revision 1.34  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.33  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.32  2003/09/16 14:48:17  rich
//   Changes for linux.
//
//   Revision 1.31  2003/09/03 20:55:38  rich
//   Fix border of non-modal windows under Linux.
//
//   Revision 1.30  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.29  2003/01/14 10:27:19  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.28  2002/12/16 18:26:40  rich
//   Fix breaking Cameron menus. Add some debugging for debug version.
//
//   Revision 1.27  2002/07/03 14:23:21  richard
//   Replace as many old-style stream class header references with new style
//   e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
//   Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
//   stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
//   Removed some bits from Steve's Plot classes that were generating (harmless) compiler
//   warning messages.
//
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
#include    "crweb.h"
#include    <string>
#include    <sstream>

#ifndef CRY_OSWIN32
  #include "wincrys.xpm"
#endif

int CxWindow::mWindowCount = kWindowBase;


CxWindow * CxWindow::CreateCxWindow( CrWindow * container, void * parentWindow, int attributes )
{

  ostringstream strm;
  strm << "CxWindow created. Parent = " << (uintptr_t)parentWindow;
  LOGSTAT ( strm.str() );

  CxWindow *theWindow = new CxWindow( container, attributes);

  #ifdef CRY_USEMFC
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

  #ifdef CRY_USEWX
      wxString a = wxT("Window");
      theWindow->mParentWnd = (wxWindow*) parentWindow;
      theWindow->Create( 
        theWindow->mParentWnd, -1, a,
        wxPoint(0, 0), wxSize(-1,-1),
        wxSYSTEM_MENU |         
        ((attributes & kSize) ? wxDEFAULT_FRAME_STYLE   : wxDEFAULT_DIALOG_STYLE|wxFRAME_NO_TASKBAR) |
        ( parentWindow        ? wxFRAME_FLOAT_ON_PARENT : 0) |
		(( attributes & kModal )? 0 : wxFRAME_TOOL_WINDOW )
      );
      theWindow->SetIcon( wxICON (IDI_ICON1) );
	  
	  if ( attributes & kFrame ) theWindow->SetIsFrame();
  #endif

  //if the window is modal, disable the parent:

  if ( attributes & kModal )
  {
    if ( theWindow->mParentWnd )
    {
      #ifdef CRY_USEMFC
        theWindow->mParentWnd->EnableWindow(false);
        theWindow->EnableWindow(true);  //All child windows have been disabled by the last call, so re-enable this one.
        theWindow->ModifyStyle(WS_MINIMIZEBOX,NULL,SWP_NOZORDER); //No Minimize box for modal windows with parents.
      #endif
      #ifdef CRY_USEWX
        theWindow->m_wxWinDisabler = new wxWindowDisabler(theWindow);
		theWindow->SetFocus();
//        theWindow->mParentWnd->Enable(false);
//        theWindow->Enable(true);  //All child windows have been disabled, so re-enable this one.
      #endif
    }
  }
  else
  {
    #ifdef CRY_USEMFC
      theWindow->ModifyStyleEx(NULL,WS_EX_TOOLWINDOW,NULL); //Small title bar effect.
    #endif
  }

  #ifdef CRY_USEMFC
    if ( attributes & kSize ) theWindow->ModifyStyle(NULL,WS_BORDER|WS_THICKFRAME,SWP_NOZORDER);
  #endif

  
  
  return (theWindow);
}


CxWindow::CxWindow( CrWindow * container, int attributes )
{

    ptr_to_crObject = container;
    mProgramResizing = true;
    mDefaultButton = nil;
    mSizeable = (attributes & kSize)!=0;
    m_attributes = attributes;
    mWindowWantsKeys = false;
    m_PreDestroyed = false;
    m_TimerActive = 0;
#ifdef CRY_USEWX
    m_wxWinDisabler = NULL;
#endif

}

void CxWindow::CxPreDestroy()
{
//    LOGERR("Predestroy - focusing parent");

//    wxWindowList & children = myframe->GetChildren();
//    for ( wxWindowList::Node *node = children.GetFirst(); node; node = node->GetNext() )
//    {
//       wxWindow *current = (wxWindow *)node->GetData();
//    }


#ifdef CRY_USEMFC
    if (mParentWnd)
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
#ifdef CRY_USEWX
      wxDELETE( m_wxWinDisabler );
//    if (mParentWnd) {
//      mParentWnd->Enable(true); //Re-enable the parent.
//      mParentWnd->SetFocus(); //Focus the parent.
//    }
#endif

    m_PreDestroyed = true;
}

CxWindow::~CxWindow()
{
#ifdef CRY_USEWX
    //m_mgr.UnInit();
#endif
    mWindowCount--;
    if ( !m_PreDestroyed ) {
      CxPreDestroy(); // Should really be called earlier.
      ((CrWindow*)ptr_to_crObject)->NotifyControl();
    }
}


#ifdef CRY_USEWX
void CxWindow::SetIsFrame() {
	//m_mgr.SetManagedWindow(this);
}
void CxWindow::AddPane(wxWindow* pane, unsigned int position, wxString text) {
//	m_mgr.AddPane(pane, position, text);
//	m_mgr.Update();
//	m_mgr.GetPane(pane).Float();
//	m_mgr.Update();
}

void CxWindow::SetPaneMin(wxWindow* pane, int w, int h) {
//	wxAuiPaneInfo &pi = m_mgr.GetPane(pane);
//	if (pi.IsOk()) {
//		pi.MinSize(w,h);
//	}
//	m_mgr.Update();
}
#endif

void CxWindow::CxDestroyWindow()
{
  #ifdef CRY_USEMFC
DestroyWindow();
#endif
#ifdef CRY_USEWX
	Destroy();
//    wxDELETE( m_wxWinDisabler );

#endif
}

void    CxWindow::SetText( const string & text )
{
#ifdef CRY_USEMFC
    SetWindowText(text.c_str());
#endif
#ifdef CRY_USEWX
      SetTitle(text.c_str());
#endif
}

void    CxWindow::CxShowWindow()
{
#ifdef CRY_USEMFC
      ShowWindow(SW_SHOW);
    UpdateWindow();
#endif
#ifdef CRY_USEWX
      Show(true);
#endif
  if ( m_attributes & kModal )
  {
    if ( mParentWnd )
    {
      #ifdef CRY_USEMFC
        mParentWnd->EnableWindow(false);
        EnableWindow(true);  //All child windows have been disabled by the last call, so re-enable this one.
      #endif
      #ifdef CRY_USEWX
        if ( ! m_wxWinDisabler )
        {
           m_wxWinDisabler = new wxWindowDisabler(this);
        }
      #endif
    }
  }
#ifdef CRY_USEWX
      SetFocus();
//	  Raise();
//	  ostringstream a;
//	  a << (int) this << " show/raised " << GetLabel();
//	  LOGERR(a.str());
#endif

}

void    CxWindow::SetGeometry( int top, int left, int bottom, int right )
{
  ostringstream strm;
  strm << "CxWindow::SetGeom called "  << top << " " << left << " " << bottom << " " << right;
  LOGSTAT( strm.str() );

  if(mProgramResizing)  //Only move the window, if the program is resizing it.
  {
    LOGSTAT(" Progresizing is TRUE ");
#ifdef CRY_USEMFC
    MoveWindow(left, top, (right-left), (bottom-top),true);
#endif
#ifdef CRY_USEWX
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
#ifdef CRY_USEMFC
      RECT windowRect;
      GetWindowRect(&windowRect);
      return ( windowRect.top );
#endif
#ifdef CRY_USEWX
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
#ifdef CRY_USEMFC
      RECT windowRect;
      GetWindowRect(&windowRect);
      return ( windowRect.left );
#endif
#ifdef CRY_USEWX
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

#ifdef CRY_USEMFC
    CFrameWnd::ShowWindow(SW_HIDE);
    if (mParentWnd)
            mParentWnd->EnableWindow(true); //Re-enable the parent.
#endif
#ifdef CRY_USEWX
   wxDELETE( m_wxWinDisabler );
   Show(false);
//    if (mParentWnd)
//            mParentWnd->Enable(true); //Re-enable the parent.
#endif
}


//////PRIVATE WINDOWS SPECIFIC FUNCTIONS AND OVERRIDES


/////////////////////////////////////////////////////////////////////////////
// CxWindow


//void CxWindow::SetFocus() {
//	ostringstream a;
//	a << (int) this << " setFocus called on "  << GetLabel();
//	LOGERR(a.str());
//	wxWindow::SetFocus();
//}

#ifdef CRY_USEWX	
void CxWindow::OnSetFocus(wxFocusEvent& e) {

    if ( m_PreDestroyed ) return;
//    ostringstream a;
//	a << (int) this << " getting focus from "  << (int) e.GetWindow() << " " << e.GetWindow()->GetLabel();
//	LOGERR(a.str());
	e.Skip();
   ((CrWindow*)ptr_to_crObject)->CheckFocus();  //Sometimes focus goes to root window instead of modal dialog. Catch and fix.
	return;
}
#endif

//void CxWindow::TempKillFocus(wxFocusEvent& e) {
//    ostringstream a;
//	a << (int) this << " losing focus to " << (int) e.GetWindow() << " " << e.GetWindow()->GetLabel();
//	LOGERR(a.str());
//	e.Skip();
//	return;
//}


#ifdef CRY_USEMFC
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
#ifdef CRY_USEWX
//wx Message Map
BEGIN_EVENT_TABLE(CxWindow, wxFrame)
      EVT_CLOSE( CxWindow::OnCloseWindow )
      EVT_SIZE( CxWindow::OnSize )
      EVT_ICONIZE( CxWindow::OnIconize )
      EVT_CHAR( CxWindow::OnChar )
      EVT_COMMAND_RANGE(kMenuBase, kMenuBase+1000,
                        wxEVT_COMMAND_MENU_SELECTED,
                        CxWindow::OnMenuSelected )
      EVT_UPDATE_UI_RANGE(kMenuBase, kMenuBase+1000,
                        CxWindow::OnUpdateMenuItem )
      EVT_COMMAND_RANGE(kToolButtonBase, kToolButtonBase+5000,
                        wxEVT_COMMAND_MENU_SELECTED,
                        CxWindow::OnToolSelected)
#ifdef DEPRECATEDCRY_USEWX
	  EVT_MENU_HIGHLIGHT_ALL(CxWindow::OnHighlightMenuItem)
#endif
	  EVT_KEY_DOWN( CxWindow::OnKeyDown )
	  EVT_SET_FOCUS( CxWindow::OnSetFocus)
//	  EVT_KILL_FOCUS( CxWindow::TempKillFocus)
END_EVENT_TABLE()
#endif



#ifdef CRY_USEMFC
void CxWindow::OnUpdateMenuItem(CCmdUI* pCmdUI)
{
    CcMenuItem* theItem = CrMenu::FindMenuItem(pCmdUI->m_nID);
    if(theItem == nil) return;

    if ( (CcController::theController)->status.ShouldBeEnabled( theItem->enable, theItem->disable ) )
            pCmdUI->Enable(true);
    else
            pCmdUI->Enable(false);
}
void CxWindow::OnUpdateTools(CCmdUI* pCmdUI)
{
    CcTool* theItem = CrToolBar::FindAnyTool(pCmdUI->m_nID);
    if(theItem == nil) return;

    if ( (CcController::theController)->status.ShouldBeEnabled( theItem->tEnableFlags, theItem->tDisableFlags ) )
            pCmdUI->Enable(true);
    else
            pCmdUI->Enable(false);
}
#endif
#ifdef CRY_USEWX
void CxWindow::OnUpdateMenuItem(wxUpdateUIEvent & pCmdUI)
{
    CcMenuItem* theItem = CrMenu::FindMenuItem(pCmdUI.GetId());
    if(theItem == nil) return;

    if ( (CcController::theController)->status.ShouldBeEnabled( theItem->enable, theItem->disable ) )
            pCmdUI.Enable(true);
    else
            pCmdUI.Enable(false);
}
#endif
#ifdef DEPRECATEDCRY_USEWX
void CxWindow::OnHighlightMenuItem(wxMenuEvent & event)
{
	if ( event.GetMenuId() == -1 ) return;
    CcMenuItem* theItem = CrMenu::FindMenuItem(event.GetMenuId());
	if(theItem == nil) {
		ostringstream os;
		os << "No menu item found " << event.GetMenuId();
		LOGERR(os.str());	
		return;
	} else {
		CrWeb* webHelpWindow = (CrWeb*)(CcController::theController)->FindObject( "HT" );
		if ( webHelpWindow  != nil ) {
			//Find an html file matching the menu label in the script folder.
			string crysdir ( getenv("CRYSDIR") );
			if ( crysdir.length() == 0 )
			{
#ifndef CRY_OSWIN32
				std::cerr << "You must set CRYSDIR before running crystals.\n";
#endif
				return;
		    }
		    int nEnv = (CcController::theController)->EnvVarCount( crysdir );
			int i = 0;
		    bool noLuck = true;
			while ( noLuck )
			{
				string dir = (CcController::theController)->EnvVarExtract( crysdir, i );
				i++;
#ifdef CRY_OSWIN32
				string file = dir + "script\\" + theItem->name + ".html";
#else
				string file = dir + "script/" + theItem->name + ".html";
#endif
				struct stat buf;
				if ( stat(file.c_str(),&buf)==0 )
				{
					webHelpWindow->SetText(file.c_str());
					break;
				}
				if ( i >= nEnv )
		        {
					noLuck = false;
					break;
				}
		    }
			LOGERR("Menu item " + theItem->name + " hovered over");	
		}
	}


}

#endif



/////////////////////////////////////////////////////////////////////////////
// CxWindow message handlers

#ifdef CRY_USEMFC
void CxWindow::OnClose()
{
    ((CrWindow*)ptr_to_crObject)->CloseWindow();

// Don't close the Window via the framework. On close should indicate to the controller that
// ESC / CANCEL / CLOSE event has occured. The Controller will destroy the window, if it sees fit.
//  CFrameWnd::OnClose();
}
#endif
#ifdef CRY_USEWX
void CxWindow::OnCloseWindow(wxCloseEvent & event)
{

    if ( m_PreDestroyed ) return;

//  ostringstream strm;
//  strm << "CxWindow OnCloseWindow - not predestroyed... Addr = " << (long)this;
//  LOGERR ( strm.str() );

    ((CrWindow*)ptr_to_crObject)->CloseWindow();
    event.Veto(); // Indicate that we did not close the window 
                  // just yet.
}
#endif



#ifdef CRY_USEMFC
void CxWindow::OnSize(UINT nType, int cx, int cy)
{
    ostringstream strm;
    strm << "OnSize called " << cx << " " << cy;
    LOGSTAT( strm.str() );
    CFrameWnd::OnSize(nType, cx, cy);
    mProgramResizing = false;
    if ( nType == SIZE_MINIMIZED ) return;
    ((CrWindow*)ptr_to_crObject)->ResizeWindow( cx, cy );
#endif

#ifdef CRY_USEWX
void CxWindow::OnSize(wxSizeEvent & event)
{
      ostringstream strm;
      strm << "OnSize called " << event.GetSize().x <<  " " << event.GetSize().y;
      LOGSTAT( strm.str() );
      mProgramResizing = false;
      wxSize si = GetClientSize(); //Onsize is whole window - we only want this bit.
      ((CrWindow*)ptr_to_crObject)->ResizeWindow( si.GetWidth(), si.GetHeight() );
#endif

    mProgramResizing = true;
}

#ifdef CRY_USEWX
void CxWindow::OnIconize(wxIconizeEvent & event) 
{
	if ( ! event.IsIconized() ) {
		if ( mParentWnd ) {
			((wxFrame*)mParentWnd)->Iconize(false);
		}
	}
}
#endif

#ifdef CRY_USEMFC
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
//  ostringstream strm;
//  strm << "CxWindow Focussed. Addr = " << (long)this <<" " << GetLabel();
//  LOGERR ( strm.str() );
  SetFocus();
}

void CxWindow::SetMainMenu(CxMenuBar * menu)
{
#ifdef CRY_USEMFC
      int i = (int)SetMenu(menu);
#endif
#ifdef CRY_USEWX
      SetMenuBar( menu );
#endif
}


#ifdef CRY_USEMFC
void CxWindow::OnMenuSelected(UINT nID)
{
 //   LOGSTAT("Menu Selected: ID: " + string((int) nID ));
#endif
#ifdef CRY_USEWX
void CxWindow::OnMenuSelected(wxCommandEvent & event)
{
      int nID = event.GetId();
#endif
    ((CrWindow*)ptr_to_crObject)->MenuSelected( nID );

}


#ifdef CRY_USEMFC
void CxWindow::OnToolSelected(UINT nID)
{
    TRACE("Tool ID %d\n", nID);
#endif
#ifdef CRY_USEWX
void CxWindow::OnToolSelected(wxCommandEvent & event)
{
      int nID = event.GetId();
#endif
    ((CrWindow*)ptr_to_crObject)->ToolSelected( nID );
}




#ifdef CRY_USEMFC
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
#ifdef CRY_USEMFC
    int cH = GetSystemMetrics(SM_CYCAPTION);
    int bT = GetSystemMetrics(SM_CXSIZEFRAME); //I think this is the maximum from SM_CXBORDER, SM_CXEDGE, SM_CXDLGFRAME...
    int mN = ( GetMenu() != NULL ) ? GetSystemMetrics(SM_CYMENU) : 0; //Height of the menu, if there is one. Otherwise zero.
//              This the test      ?       value if test is true : value if false
    size->mRight  = size->Right()  + (2*bT);
    size->mBottom = size->Bottom() + ((2*bT)+cH+mN);
#endif
#ifdef CRY_USEWX
// The system metrics aren't implemented yet!
//       int mN = ( GetMenuBar() ) ? 20 : 0;
//       int cH = 15;
//       int bT = 4;
// They are now:

//      int mN = wxSystemSettings::GetMetric(wxSYS_MENU_Y,this);
//      int cH = wxSystemSettings::GetMetric(wxSYS_CAPTION_Y,this);
//      int bT = wxSystemSettings::GetMetric(wxSYS_FRAMESIZE_X,this);

//      cH = cH ? cH : 15;  // If cH not found, use 15 instead.
//      bT = bT ? bT : 4;   // If bT not found, use 4.
//      mN = mN ? mN : 20;  // If mN not foumd, use 20.

//      mN = GetMenuBar() ? mN : 0; // If no menubar, set to zero.

    wxSize adj = GetSize() - GetClientSize();
    size->mRight  = size->Right()  + adj.GetWidth();
    size->mBottom = size->Bottom() + adj.GetHeight();

#endif
 

    return;
}

#ifdef CRY_USEMFC
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
#ifdef CRY_USEMFC
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

#ifdef CRY_USEWX
void CxWindow::OnKeyDown( wxKeyEvent & event )
{
      int key = -1;

      switch(event.GetKeyCode())
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
#ifdef CRY_USEMFC
  Invalidate();
#endif
#ifdef CRY_USEWX
  Refresh();
#endif
}

void CxWindow::CxEnable(bool enable)
{
#ifdef CRY_USEMFC
  EnableWindow(enable);
#endif
#ifdef CRY_USEWX
  Enable(enable);
#endif
}


void CxWindow::CxSetTimer()
{
#ifdef CRY_USEMFC
  if ( m_TimerActive )
  {
    LOGERR ( "Timer called more than once." );
    return; //only to be called once.
  }
  m_TimerActive = SetTimer ( 1007, 500, NULL ); // 500ms updates.
#endif
}

#ifdef CRY_USEMFC
void CxWindow::OnTimer(UINT nID)
{
  ((CrWindow*)ptr_to_crObject)->TimerFired();
}


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
#endif
