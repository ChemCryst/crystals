////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWindow.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 16:45 Uhr

#include	"crystalsinterface.h"
#include	"cxwindow.h"
#include	"cxapp.h"
#include	"cxmenu.h"
#include	"crmenu.h"
#include    "ccmenuitem.h"
#include	"cccontroller.h"


int	CxWindow::mWindowCount = kWindowBase;


CxWindow *	CxWindow::CreateCxWindow( CrWindow * container, void * parentWindow, int attributes )
{

	const char* wndClass = AfxRegisterWndClass(
									CS_HREDRAW|CS_VREDRAW,
									NULL,
									(HBRUSH)(COLOR_MENU+1),
									NULL
									);


	CxWindow	*theWindow = new CxWindow( container, attributes & kSize );

	theWindow->mParentWnd = (CWnd*) parentWindow;

	theWindow->Create(	
						wndClass,
						"Window",
						WS_CAPTION|/*WS_POPUP|*/WS_SYSMENU,
						CRect(0,0,10,10),
						theWindow->mParentWnd);

	//if the window is modal, disable the parent:
	
	if (theWindow->mParentWnd)
	{
		theWindow->mParentWnd->EnableWindow(FALSE);
		theWindow->EnableWindow(TRUE);  //All child windows have been disabled, so re-enable this one.
	}
/*	theWindow->Create(	
						IDD_DIALOG1,
						NULL
						);
*/

	if ( attributes & kSize )
		theWindow->ModifyStyle(NULL,WS_BORDER|WS_THICKFRAME,SWP_NOZORDER);

	theWindow->ShowWindow(SW_SHOW);
	theWindow->UpdateWindow();

	
	return (theWindow);

}

CxWindow::CxWindow( CrWindow * container, int sizeable )
{

	mWidget = container;
	mProgramResizing = true;
	mDefaultButton = nil;
	mSizeable = (sizeable==0) ? false : true;
      mWindowWantsKeys = false;

}

CxWindow::~CxWindow()
{

	mWindowCount--;
	if (mParentWnd)
		mParentWnd->EnableWindow(TRUE); //Re-enable the parent.

}

void	CxWindow::SetText( char * text )
{

#ifdef __POWERPC__
	Str255 descriptor;
	
	strcpy( reinterpret_cast<char *>(descriptor), text );
	c2pstr( reinterpret_cast<char *>(descriptor) );
	SetDescriptor( descriptor );
#endif
#ifdef __WINDOWS__
	SetWindowText(text);
#endif
//End of user code.         
}
// OPSignature: void CxWindow:ShowWindow() 
void	CxWindow::CxShowWindow()
{
//Insert your own code here.
//	FinishCreate();
	ShowWindow(SW_SHOW);
	UpdateWindow();
//End of user code.         
}

void	CxWindow::SetGeometry( int top, int left, int bottom, int right )
{
	if(mProgramResizing)  //Only move the window, if the program is resizing it.
	{
		MoveWindow(left, top, (right-left), (bottom-top),true);
	}
	else // if the user is resizing, then the window is already the right size.
	{
		UpdateWindow();
	}
}

int	CxWindow::GetTop()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.top -= parentRect.top;
	}
	return ( windowRect.top );
}
int	CxWindow::GetLeft()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.left -= parentRect.left;
	}
	return ( windowRect.left );
}
int	CxWindow::GetWidth()
{

	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxWindow::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

// OPSignature: LTabGroup * CxWindow:GetTabCommander() 
/*LTabGroup *	CxWindow::GetTabCommander()
{
//Insert your own code here.
	return (mTabGroup);
//End of user code.         
}*/
// OPSignature: void CxWindow:SetDefaultButton() 
void	CxWindow::SetDefaultButton( CxButton * inButton )
{
//Insert your own code here.
	mDefaultButton = inButton;
//End of user code.         
}


// ---------------------------------------------------------------------------
//		€ HandleKeyPress
// ---------------------------------------------------------------------------
//
//		Default Button: Enter, Return
/*
Boolean
CxWindow::HandleKeyPress(
	const EventRecord	&inKeyEvent)
{
	Boolean		keyHandled = false;
	LControl	*keyButton = nil;
	
	switch (inKeyEvent.message & charCodeMask) {
	
		case char_Enter:
		case char_Return:
			keyButton = dynamic_cast<LControl*>(mDefaultButton);
			break;
			
		default:
			break;
	}
			
	if (keyButton != nil) {
		keyButton->SimulateHotSpotClick(kControlButtonPart);
		keyHandled = true;
		
	} else {
		keyHandled = LWindow::HandleKeyPress(inKeyEvent);
	}
	
	return keyHandled;
}

*/

void CxWindow::Hide()
{

	CFrameWnd::ShowWindow(SW_HIDE);
	if (mParentWnd)
		mParentWnd->EnableWindow(TRUE); //Re-enable the parent.

//	CDialog::ShowWindow(SW_HIDE);
}


//////PRIVATE WINDOWS SPECIFIC FUNCTIONS AND OVERRIDES


/////////////////////////////////////////////////////////////////////////////
// CxWindow


BEGIN_MESSAGE_MAP(CxWindow, CFrameWnd)
	ON_WM_CLOSE()
	ON_WM_SIZE()
	ON_WM_GETMINMAXINFO()
	ON_MESSAGE(WM_NCPAINT, OnMyNcPaint)
	ON_WM_CHAR()
	ON_COMMAND_RANGE(kMenuBase, kMenuBase+1000, OnMenuSelected)
	ON_UPDATE_COMMAND_UI_RANGE(kMenuBase,kMenuBase+1000,OnUpdateMenuItem)
      ON_WM_KEYDOWN()
END_MESSAGE_MAP()


void CxWindow::OnUpdateMenuItem(CCmdUI* pCmdUI)
{
	CxMenu* theXMenu = (CxMenu*) pCmdUI->m_pMenu;
	if(theXMenu == nil) return;
	CrMenu* theRMenu = (CrMenu*) theXMenu->mWidget;
	if(theRMenu == nil) return;
	CcMenuItem* theItem = theRMenu->FindItembyID(pCmdUI->m_nID);
	if(theItem == nil) return;

	if ( (CcController::theController)->status.ShouldBeEnabled( theItem->enable, theItem->disable ) )
		pCmdUI->Enable(TRUE);
	else
		pCmdUI->Enable(FALSE);
}


/////////////////////////////////////////////////////////////////////////////
// CxWindow message handlers


void CxWindow::OnClose() 
{
	((CrWindow*)mWidget)->CloseWindow();

// Don't close the Window via the framework. On close should indicate to the controller that
// ESC / CANCEL / CLOSE event has occured. The Controller will destroy the window, if it sees fit.
//	CFrameWnd::OnClose();
}

void CxWindow::OnSize(UINT nType, int cx, int cy) 
{
	CFrameWnd::OnSize(nType, cx, cy);

	mProgramResizing = false;

        if ( nType == SIZE_MINIMIZED ) return;

	int mN = ( GetMenu() != NULL ) ? GetSystemMetrics(SM_CYMENU) : 0; //Height of the menu, if there is one. Otherwise zero.
	int cH = GetSystemMetrics(SM_CYCAPTION);
	int bT = GetSystemMetrics(SM_CXSIZEFRAME); //I think this is the maximum from SM_CXBORDER, SM_CXEDGE, SM_CXDLGFRAME...
        ((CrWindow*)mWidget)->ResizeWindow( cx + (2*bT),
                                            cy + ( mN + cH + 2*bT ) );

	mProgramResizing = true;
}

//Cosmetic: Stops the user being able to drag the frame smaller than the default window size.
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


void CxWindow::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	NOTUSED(nRepCnt);
	NOTUSED(nFlags);
	switch(nChar)
	{
		case 9:
		{
			Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
			mWidget->FocusToInput((char)nChar);
		}
	}
}

void CxWindow::Focus()
{
	SetFocus();
}

void CxWindow::SetMainMenu(CxMenu * menu)
{
	int i = (int)SetMenu(menu);
}


void CxWindow::OnMenuSelected(int nID)
{
	TRACE("Menu ID %d\n", nID);
	((CrWindow*)mWidget)->MenuSelected( nID );
	
}

BOOL CxWindow::PreCreateWindow(CREATESTRUCT& cs) 
{
//	cs.style |= (WS_CLIPCHILDREN | WS_CLIPSIBLINGS);
/*	if( (cs.style & WS_BORDER ) == WS_BORDER) TRACE("BORDER\n");
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
//		CPen pen(PS_SOLID,1,RGB(0,255,0)), *oldpen; //Use this line for debugging!
		oldpen = dc.SelectObject(&pen);
	
		int top = windowRect.Height() - clientRect.Height() - yframe;
		int bottom = windowRect.Height() - yframe;
		int left = xframe;
		int right = windowRect.Width() - xframe;
	
// Spiral from left to left - 2.
//        from bottom -1 to bottom + 1.
//        from right to right + 2
//		  from top +2 to top

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



void CxWindow::AdjustSize(CcRect * size)
{
	int cH = GetSystemMetrics(SM_CYCAPTION);
	int bT = GetSystemMetrics(SM_CXSIZEFRAME); //I think this is the maximum from SM_CXBORDER, SM_CXEDGE, SM_CXDLGFRAME...
	int mN = ( GetMenu() != NULL ) ? GetSystemMetrics(SM_CYMENU) : 0; //Height of the menu, if there is one. Otherwise zero.
//              This the test      ?       value if test is true : value if false
	size->mRight  = size->Right()  + (2*bT);
	size->mBottom = size->Bottom() + ((2*bT)+cH+mN);
	return;
}

#ifdef __WINDOWS__
void CxWindow::OnKeyDown ( UINT nChar, UINT nRepCnt, UINT nFlags )
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
           default:
                  //Do nothing
                  break;
      }

      if (key >= 0)
            ((CrWindow*)mWidget)->SysKeyPressed( key );

      CWnd::OnKeyDown( nChar, nRepCnt, nFlags );
}
#endif

#ifdef __LINUX__
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
            ((CrWindow*)mWidget)->SysKeyPressed( key );


// Carry on processing this event.
      event.Skip();

}
#endif

