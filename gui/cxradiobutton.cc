////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxRadioButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 10:38 Uhr


#include	"crystalsinterface.h"
#include	"cxradiobutton.h"
#include	"cxgrid.h"
#include	"crradiobutton.h"

int	CxRadioButton::mRadioButtonCount = kRadioButtonBase;

CxRadioButton *	CxRadioButton::CreateCxRadioButton( CrRadioButton * container, CxGrid * guiParent )
{
	CxRadioButton	*theStdButton = new CxRadioButton( container );
#ifdef __WINDOWS__
	theStdButton->Create("RadioButton",WS_CHILD|WS_VISIBLE|BS_AUTORADIOBUTTON,CRect(0,0,10,10),guiParent,mRadioButtonCount++);
	theStdButton->SetFont(CxGrid::mp_font);
#endif
#ifdef __LINUX__
      theStdButton->Create(guiParent,-1,"Radiobutton");
#endif
	return theStdButton;
}

CxRadioButton::CxRadioButton( CrRadioButton * container)
      :BASERADIOBUTTON()
{
	mWidget = container;
}

CxRadioButton::~CxRadioButton()
{
	RemoveRadioButton();
}

void	CxRadioButton::ButtonChanged()
{
#ifdef __WINDOWS__
	Boolean state = ( GetRadioState() == 1 ) ? true : false;
	if (state)	
		((CrRadioButton*)mWidget)->ButtonOn();
#endif
#ifdef __LINUX__
      if ( GetValue() )
		((CrRadioButton*)mWidget)->ButtonOn();
#endif            
}

void	CxRadioButton::SetText( char * text )
{
#ifdef __LINUX__
      SetLabel(text);
#endif
#ifdef __WINDOWS__
	SetWindowText(text);
#endif

}

void  CxRadioButton::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
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
	{
		MoveWindow(left,top,right-left,bottom-top,true);
	}
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}

int   CxRadioButton::GetTop()
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
int   CxRadioButton::GetLeft()
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
int   CxRadioButton::GetWidth()
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
int   CxRadioButton::GetHeight()
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


int   CxRadioButton::GetIdealWidth()
{
#ifdef __WINDOWS__
	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	GetWindowText(text);
	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
      return (size.cx+20); // optimum width for Windows buttons (only joking)
#endif
#ifdef __LINUX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cx+20); // nice width for buttons
#endif

}

int   CxRadioButton::GetIdealHeight()
{
#ifdef __WINDOWS__
	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	GetWindowText(text);
	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
	return (size.cy+5); // *** optimum height for MacOS Buttons (depends on users font size?)
#endif
#ifdef __LINUX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cy+5); // nice height for buttons
#endif

}

int	CxRadioButton::AddRadioButton()
{
	mRadioButtonCount++;
	return mRadioButtonCount;
}

void	CxRadioButton::RemoveRadioButton()
{
	mRadioButtonCount--;
}

void	CxRadioButton::SetRadioState( Boolean inValue )
{
#ifdef __WINDOWS__
	int value;
	if ( inValue == true )
		value = 1;
	else
		value = 0;
	SetCheck( value );
#endif
#ifdef __LINUX__
      SetValue ( inValue );
#endif
}

Boolean	CxRadioButton::GetRadioState()
{
#ifdef __WINDOWS__
      int value = GetCheck();
	if ( value == 1 )
		return (true);
	else
		return (false);
#endif
#ifdef __LINUX__
      return GetValue();
#endif
}

#ifdef __WINDOWS__
//Windows Message Map
BEGIN_MESSAGE_MAP(CxRadioButton, CButton)
	ON_CONTROL_REFLECT(BN_CLICKED, ButtonChanged)
	ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef __LINUX__
//wx Message Map
BEGIN_EVENT_TABLE(CxRadioButton, wxRadioButton)
      EVT_RADIOBUTTON( -1, CxRadioButton::ButtonChanged ) 
      EVT_CHAR( CxRadioButton::OnChar )
END_EVENT_TABLE()
#endif

void CxRadioButton::Focus()
{
	SetFocus();
}

#ifdef __WINDOWS__
void CxRadioButton::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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
void CxRadioButton::OnChar( wxKeyEvent & event )
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
