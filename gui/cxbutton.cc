////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#include	"crystalsinterface.h"
#include	"cxbutton.h"
//insert your own code here.
#include	"cxgrid.h"
#include	"cxwindow.h"
#include	"crbutton.h"
#include	<afxwin.h>
//#include	<TextUtils.h>
//#include	<LStdControl.h>

int CxButton::mButtonCount = kButtonBase;
//End of user code.          

// OPSignature: CxButton * CxButton:CreateCxButton( CrButton *:container  CxGrid *:guiParent ) 
CxButton *	CxButton::CreateCxButton( CrButton * container, CxGrid * guiParent )
{
	CxButton	*theStdButton = new CxButton(container);
	theStdButton->Create("Button",WS_CHILD|WS_VISIBLE|BS_PUSHBUTTON,CRect(0,0,10,10),guiParent,mButtonCount++);
	theStdButton->SetFont(CxGrid::mp_font);

	return theStdButton;
//End of user code.         
}

CxButton::CxButton(CrButton* container)
	:CButton()
//Insert your own initialization here.
//End of user initialization.         
{
	mWidget = container;
//Insert your own code here.
//End of user code.         

}
// OPSignature:  CxButton:~CxButton() 
	CxButton::~CxButton()
{
//Insert your own code here.
	mButtonCount--;
/*	if ( mOutlineWidget != nil )
	{
		delete mOutlineWidget;
	}		*/
//End of user code.         
}
// OPSignature: void CxButton:ButtonClicked() 
void	CxButton::ButtonClicked()
{
//Insert your own code here.
	( (CrButton *)mWidget)->ButtonClicked();
//End of user code.         
}
// OPSignature: void CxButton:SetText( char *:text ) 
void	CxButton::SetText( char * text )
{
//Insert your own code here.
#ifdef __POWERPC__
	Str255 descriptor;
	
	strcpy( reinterpret_cast<char *>(descriptor), text );
	c2pstr( reinterpret_cast<char *>(descriptor) );
	SetDescriptor( descriptor );
#endif
#ifdef __LINUX__
	setText(text);
#endif
#ifdef __WINDOWS__
	SetWindowText(text);
#endif
//End of user code.         
}
void	CxButton::SetGeometry( int top, int left, int bottom, int right )
{
	MoveWindow(left,top,right-left,bottom-top,true);
}
int	CxButton::GetTop()
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
int	CxButton::GetLeft()
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
int	CxButton::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxButton::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

// OPSignature: int CxButton:GetIdealWidth() 
int	CxButton::GetIdealWidth()
{
//Insert your own code here.
//	Str255 descriptor, str;
//	Int16 strSize;
	
//	GetDescriptor( descriptor );
//	GetDescriptor( str );
//	p2cstr( str );
	
	// Check for empty strings
//	if ( strlen( (char *)str ) == 0 )
//		strSize = 18;
//	else
//		strSize = ::StringWidth(descriptor) + 18;	// 9 pixels slop on either side
//
//	return ( strSize );
	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	GetWindowText(text);
	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
	return (size.cx+20); //*** optimum width for Windows buttons (only joking)
//End of user code.         
}
// OPSignature: int CxButton:GetIdealHeight() 
int	CxButton::GetIdealHeight()
{
//Insert your own code here.
	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	GetWindowText(text);
	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
	return (size.cy+5); // *** optimum height for MacOS Buttons (depends on users font size?)
//End of user code.         
}
// OPSignature: void CxButton:BroadcastValueMessage() 
void CxButton::BroadcastValueMessage()
{
//Insert your own code here.
	// call the CxClass callback
	ButtonClicked();
	
	// call the framework callback
//	LControl::BroadcastValueMessage();
//End of user code.         
}
// OPSignature: void CxButton:SetDefault() 
void CxButton::SetDefault()
{
//Insert your own code here.
	// create the default outline
//	mOutlineWidget = new LDefaultOutline( this );
//	mValueMessage = msg_OK;
	ModifyStyle(NULL,BS_DEFPUSHBUTTON,0);

// Store the default button in the responsible window
	CxWindow * window = (CxWindow *) (mWidget->GetRootWidget()->GetWidget());
	
	if ( window != nil )
		window->SetDefaultButton( this );
//End of user code.         
}

//Windows Message Map
BEGIN_MESSAGE_MAP(CxButton, CButton)
	ON_CONTROL_REFLECT(BN_CLICKED, ButtonClicked)
	ON_WM_CHAR()
END_MESSAGE_MAP()

void CxButton::Focus()
{
	SetFocus();
}

void CxButton::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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

void CxButton::Disable(Boolean disabled)
{
	if(disabled)
		EnableWindow(FALSE);
	else
		EnableWindow(TRUE);

}
