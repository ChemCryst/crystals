////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxListBox
////////////////////////////////////////////////////////////////////////

//   Filename:  CxListBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  6.3.1998 10:10 Uhr

// $Log: not supported by cvs2svn $
// Revision 1.5  1999/05/28 18:00:29  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.4  1999/04/26 13:14:32  dosuser
// RIC: Added void SetSelection ( int select ) function.
//

#include	"crystalsinterface.h"
#include	"cxlistbox.h"

#include	"cxgrid.h"
#include	"cxwindow.h"
#include	"crlistbox.h"

#ifdef __LINUX__
#include <wx/settings.h>
#endif

int	CxListBox::mListBoxCount = kListBoxBase;


CxListBox *	CxListBox::CreateCxListBox( CrListBox * container, CxGrid * guiParent )
{
	CxListBox	*theListBox = new CxListBox( container );
#ifdef __WINDOWS__
        theListBox->Create(WS_CHILD| WS_VISIBLE| LBS_NOTIFY| LBS_HASSTRINGS| WS_VSCROLL, CRect(0,0,5,5), guiParent, mListBoxCount++);
	theListBox->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theListBox->SetFont(CxGrid::mp_font);
#endif
#ifdef __LINUX__
      theListBox->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10),0,NULL,wxLB_SINGLE|wxLB_NEEDED_SB);
#endif
	return theListBox;

}

CxListBox::CxListBox( CrListBox * container )
      : BASELISTBOX()
{
	mWidget = container;
	mItems = 0;
	mVisibleLines = 0;
}

CxListBox::~CxListBox()
{
	RemoveListBox();
}

void	CxListBox::DoubleClicked()
{
#ifdef __WINDOWS__
            int itemIndex = GetCurSel();
#endif
#ifdef __LINUX__
            int itemIndex = GetSelection();
#endif
            ((CrListBox *)mWidget)->Committed( itemIndex + 1 );
}

void	CxListBox::Selected()
{
#ifdef __WINDOWS__
            int itemIndex = GetCurSel();
#endif
#ifdef __LINUX__
            int itemIndex = GetSelection();
#endif
		((CrListBox *)mWidget)->Selected( itemIndex + 1 );
}

void	CxListBox::AddItem( char * text )
{
#ifdef __POWERPC__
	ListHandle	macListH;
	Cell	theCell = {0, 0};
	macListH = GetMacListH();					// Get control handle	
	LAddRow(1, mItems, macListH);				// Add a row
	mItems++;
	theCell.v = mItems -1;						// Set cell
	LSetCell( text, strlen( text ), theCell, macListH);
#endif
#ifdef __LINUX__
      Append (text);
      if( !mItems ) SetSelection(0);
	mItems++;
#endif
#ifdef __WINDOWS__
	AddString(text);
	if( !mItems ) SetCurSel(0);
	mItems++;
#endif

}

void	CxListBox::SetVisibleLines( int lines )
{
	mVisibleLines = lines;
}

void	CxListBox::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
	//If top or left are negative, this is a call from CalcLayout,
	//therefore don't repaint the window.
	if((top<0) || (left<0))
	{
		RECT windowRect;
		RECT parentRect;
		GetWindowRect(&windowRect);
		CWnd* parent = GetParent();
		if(parent != nil)
		{
			parent->GetWindowRect(&parentRect);
			windowRect.top -= parentRect.top;
			windowRect.left -= parentRect.left;
		}
		MoveWindow(windowRect.left,windowRect.top,right-left,bottom-top,false);
	}
	else
		MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}

int   CxListBox::GetTop()
{
#ifdef __WINDOWS__
      RECT windowRect, parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.top -= parentRect.top;
	}
	return ( windowRect.top );
#endif
#ifdef __LINUX__
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
int   CxListBox::GetLeft()
{
#ifdef __WINDOWS__
      RECT windowRect, parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.left -= parentRect.left;
	}
	return ( windowRect.left );
#endif
#ifdef __LINUX__
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
int   CxListBox::GetWidth()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxListBox::GetHeight()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


int	CxListBox::GetIdealWidth()
{
	int maxSiz = 10; //At least you can see it if it's empty!
#ifdef __WINDOWS__
	CString text;
      SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	for ( int i=0;i<mItems;i++ )
	{
		GetText(i, text);
		GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
		if ( maxSiz < size.cx )
				maxSiz = size.cx;
	}
	if(mItems > mVisibleLines)
		maxSiz += GetSystemMetrics(SM_CXVSCROLL);
#endif
#ifdef __LINUX__
      wxString text;
	for ( int i=0;i<mItems;i++ )
	{
            text = GetString(i);
            int cx,cy;
            GetTextExtent( GetLabel(), &cx, &cy );
            if ( maxSiz < cx )
                    maxSiz = cx;
	}

	if(mItems > mVisibleLines)
      {
            wxSystemSettings ss;
            maxSiz += ss.GetSystemMetric(wxSYS_VSCROLL_X);
      }

#endif

	return ( maxSiz + 10 ); //10 pixels spare

}

int	CxListBox::GetIdealHeight()
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
      return mVisibleLines * ( textMetric.tmHeight + 2 );
#endif
#ifdef __LINUX__
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return mVisibleLines * ( cy + 2 );
#endif

}

int	CxListBox::GetBoxValue()
{

#ifdef __WINDOWS__
      return ( GetCurSel() + 1 );
#endif
#ifdef __LINUX__
      return ( GetSelection() + 1 );
#endif

}

#ifdef __WINDOWS__
BEGIN_MESSAGE_MAP(CxListBox, CListBox)
	ON_CONTROL_REFLECT(LBN_DBLCLK, DoubleClicked)
	ON_CONTROL_REFLECT(LBN_SELCHANGE, Selected)
	ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef __LINUX__
//wx Message Map
BEGIN_EVENT_TABLE(CxListBox, BASELISTBOX)
      EVT_LISTBOX_DCLICK(-1, CxListBox::DoubleClicked )
      EVT_LISTBOX(-1, CxListBox::Selected )
      EVT_CHAR( CxListBox::OnChar )
END_EVENT_TABLE()
#endif

void CxListBox::Focus()
{
	SetFocus();
}

#ifdef __WINDOWS__
void CxListBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	NOTUSED(nRepCnt);
	NOTUSED(nFlags);
	switch(nChar)
	{
		case 9:     //TAB. Shift focus back or forwards.
		{
			Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
			mWidget->FocusToInput((char)nChar);
			break;
		}
	}
}
#endif
#ifdef __LINUX__
void CxListBox::OnChar( wxKeyEvent & event )
{
      switch(event.KeyCode())
	{
		case 9:     //TAB. Shift focus back or forwards.
		{
                  Boolean shifted = event.m_shiftDown;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
                  mWidget->FocusToInput((char)event.KeyCode());
			break;
		}
	}
}
#endif



void CxListBox::SetSelection( int select )
{
#ifdef __WINDOWS__
    SetCurSel ( select - 1 );
#endif
#ifdef __LINUX__
    SetSelection ( select - 1 );
#endif

}

CcString CxListBox::GetListBoxText(int index)
{
#ifdef __WINDOWS__
	CString temp;
      GetText(index-1, temp);
	CcString result = temp.GetBuffer(temp.GetLength());
	return result;
#endif
#ifdef __LINUX__
      wxString temp = GetString( index -1 );
      CcString result ( temp.c_str() );
	return result;
#endif

}
