////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxDropDown

////////////////////////////////////////////////////////////////////////

//   Filename:  CxDropDown.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  6.3.1998 10:10 Uhr

// $Log: not supported by cvs2svn $
// Revision 1.4  1999/05/28 17:59:56  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.3  1999/04/28 13:59:06  dosuser
// RIC: Added support for SetSelection to DropDown so that the SCRIPT
//      writer can choose which item is selected.
//

#include	"crystalsinterface.h"
#include	"cxdropdown.h"

#include	"cxgrid.h"
#include	"crdropdown.h"


int	CxDropDown::mDropDownCount = kDropDownBase;
CxDropDown *	CxDropDown::CreateCxDropDown( CrDropDown * container, CxGrid * guiParent )
{
	CxDropDown* theDropDown = new CxDropDown ( container);
#ifdef __WINDOWS__
	theDropDown->Create(CBS_DROPDOWNLIST|WS_CHILD|WS_VISIBLE,CRect(0,0,10,10),guiParent,mDropDownCount++);
	theDropDown->SetFont(CxGrid::mp_font);
#endif
#ifdef __LINUX__
      theDropDown->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10),0,NULL);
#endif
	return theDropDown;
}

CxDropDown::CxDropDown( CrDropDown * container)
            :BASEDROPDOWN()
{
	mWidget = container;
	mItems = 0;

}

CxDropDown::~CxDropDown()
{
	mDropDownCount--;
}

void CxDropDown::SetSelection(int select)
{
#ifdef __WINDOWS__
      SetCurSel ( select - 1 );
#endif
#ifdef __LINUX__
      SetSelection ( select -1 );
#endif
}

void	CxDropDown::Selected()
{
#ifdef __WINDOWS__
	((CrDropDown *)mWidget)->Selected( GetCurSel() + 1 );
#endif
#ifdef __LINUX__
      ((CrDropDown *)mWidget)->Selected( GetSelection() + 1 );
#endif
}

void	CxDropDown::AddItem( char * text )
{
#ifdef __POWERPC__
	Str255 itemText;
	MenuHandle mh;
	
	strcpy( reinterpret_cast<char *>(itemText), text );
	c2pstr( reinterpret_cast<char *>(itemText) );
	mh =  GetMacMenuH();
	::AppendMenu( mh, itemText );
	SetMaxValue( GetMaxValue() +1 );
	SetValue( 1 );
#endif
#ifdef __LINUX__
      Append ( text );      
      if( !mItems ) SetSelection(0);
	mItems++;
#endif
#ifdef __WINDOWS__
	AddString(text);
	if( !mItems ) SetCurSel(0);
	mItems++;
#endif
}

void	CxDropDown::SetGeometry( const int top, const int left, const int bottom, const int right )
{
#ifdef __WINDOWS__
	//If top or left are negative, this is a call from CalcLayout,
	//therefore don't repaint the window.
      SetItemHeight(-1, bottom-top); //The closed up height is set by this call, MoveWindow sets the dropped height.
	if((top<0) || (left<0))
	{
            RECT windowRect;
            GetWindowRect(&windowRect);
		RECT parentRect;
		CWnd* parent = GetParent();
		if(parent != nil)
		{
			parent->GetWindowRect(&parentRect);
			windowRect.top -= parentRect.top;
			windowRect.left -= parentRect.left;
		}
		MoveWindow(windowRect.left,windowRect.top,right-left,GetIdealHeight(),false);
	}
	else
		MoveWindow(left,top,right-left,GetIdealHeight(),true);
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif
//End of user code.         
}


int   CxDropDown::GetTop()
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
int   CxDropDown::GetLeft()
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

int   CxDropDown::GetWidth()
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

int   CxDropDown::GetHeight()
{
#ifdef __WINDOWS__
	return GetItemHeight(-1);
#endif
#ifdef __LINUX__
// May need to base this on font size if it returns the dropped
// list height rather than the closed list height.
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}

int	CxDropDown::GetIdealWidth()
{
	int maxSiz = 10; //At least you can see it if it's empty!

#ifdef __WINDOWS__
	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);

	for ( int i=0;i<mItems;i++ )
	{
		GetLBText(i, text);
		GetTextExtentPoint32(hdc, text, text.GetLength(), &size);

		if ( maxSiz < size.cx )
				maxSiz = size.cx;
	}
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
#endif

	return ( maxSiz + 10 ); //10 pixels spare
}



int	CxDropDown::GetIdealHeight()
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	return 5 * ( textMetric.tmHeight + 2 );
#endif
#ifdef __LINUX__
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return (cy+5); // nice height for closed list boxes.
#endif

}

int	CxDropDown::GetDropDownValue()
{
#ifdef __WINDOWS__
	return ( GetCurSel() + 1 );
#endif
#ifdef __LINUX__
      return ( GetSelection() + 1 );
#endif
}

#ifdef __WINDOWS__
BEGIN_MESSAGE_MAP(CxDropDown, BASEDROPDOWN)
	ON_WM_CHAR()
	ON_CONTROL_REFLECT(CBN_SELCHANGE, Selected)
END_MESSAGE_MAP()
#endif

#ifdef __LINUX__
//wx Message Map
BEGIN_EVENT_TABLE(CxDropDown, BASEDROPDOWN)
      EVT_CHOICE( -1, CxDropDown::Selected ) 
      EVT_CHAR( CxDropDown::OnChar )
END_EVENT_TABLE()
#endif


#ifdef __WINDOWS__
void CxDropDown::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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
		case 32:    //SPACE. Activates button. Don't focus to the input line.
		{
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
void CxDropDown::OnChar( wxKeyEvent & event )
{
      switch(event.KeyCode())
	{
		case 9:     //TAB. Shift focus back or forwards.
		{
                  Boolean shifted = event.m_shiftDown;
			mWidget->NextFocus(shifted);
			break;
		}
		case 32:    //SPACE. Activates button. Don't focus to the input line.
		{
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


void CxDropDown::Focus()
{
	SetFocus();
}

CcString CxDropDown::GetDropDownText(int index)
{
#ifdef __WINDOWS__
	CString temp;
	GetLBText(index,temp);
	CcString result = temp.GetBuffer(temp.GetLength());
	return result;
#endif
#ifdef __LINUX__
      wxString temp = GetString( index );
      CcString result ( temp.c_str() );
	return result;
#endif
}
