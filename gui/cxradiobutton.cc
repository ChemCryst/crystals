////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxRadioButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 10:38 Uhr

#include	"CrystalsInterface.h"
#include	"CxRadioButton.h"
//Insert your own code here.
#include	"CxGrid.h"
#include	"CrRadioButton.h"
//#include	<TextUtils.h>
//#include	<LStdControl.h>
//End of user code.          

int	CxRadioButton::mRadioButtonCount = kRadioButtonBase;
// OPSignature: CxRadioButton * CxRadioButton:CreateCxRadioButton( CrRadioButton *:container  CxGrid *:guiParent ) 
CxRadioButton *	CxRadioButton::CreateCxRadioButton( CrRadioButton * container, CxGrid * guiParent )
{
//Insert your own code here.
/*	SPaneInfo	thePaneInfo;	// Info for Pane
	
	thePaneInfo.visible = true;
	thePaneInfo.enabled = true;
	thePaneInfo.bindings.left = false;
	thePaneInfo.bindings.right = false;
	thePaneInfo.bindings.top = false;
	thePaneInfo.bindings.bottom = false;
	thePaneInfo.userCon = 0;
	thePaneInfo.superView = reinterpret_cast<LView *>(guiParent);

	thePaneInfo.paneID = AddRadioButton();
	thePaneInfo.width = 80;
	thePaneInfo.height = 20;
	thePaneInfo.left = 10;
	thePaneInfo.top = 50;
*/	
	char * defaultName = (char *)"StdButton";
	CxRadioButton	*theStdButton = new CxRadioButton( container );
	theStdButton->Create("RadioButton",WS_CHILD|WS_VISIBLE|BS_AUTORADIOBUTTON,CRect(0,0,10,10),guiParent,mRadioButtonCount++);
	theStdButton->SetFont(CxGrid::mp_font);
	return theStdButton;
//End of user code.         
}
// OPSignature:  CxRadioButton:CxRadioButton( CrRadioButton *:container  SPaneInfo:&inPaneInfo char *:defaultName ) 
	CxRadioButton::CxRadioButton( CrRadioButton * container)
//Insert your own initialization here.
	:CButton()
//End of user initialization.         
{
//Insert your own code here.
	mWidget = container;
//End of user code.         
}
// OPSignature:  CxRadioButton:~CxRadioButton() 
	CxRadioButton::~CxRadioButton()
{
//Insert your own code here.
	RemoveRadioButton();
//End of user code.         
}
// OPSignature: void CxRadioButton:ButtonChanged() 
void	CxRadioButton::ButtonChanged()
{
//Insert your own code here.
	Boolean state = ( GetRadioState() == 1 ) ? true : false;
	if (state)	
		((CrRadioButton*)mWidget)->ButtonOn();
//End of user code.         
}
// OPSignature: void CxRadioButton:SetText( char *:text ) 
void	CxRadioButton::SetText( char * text )
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
// OPSignature: void CxRadioButton:SetGeometry( int:top  int:left  int:bottom  int:right ) 
void	CxRadioButton::SetGeometry( int top, int left, int bottom, int right )
{
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
}
int	CxRadioButton::GetTop()
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
int	CxRadioButton::GetLeft()
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
int	CxRadioButton::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxRadioButton::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

// OPSignature: int CxRadioButton:GetIdealWidth() 
int	CxRadioButton::GetIdealWidth()
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
// OPSignature: int CxRadioButton:GetIdealHeight() 
int	CxRadioButton::GetIdealHeight()
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
// OPSignature: int CxRadioButton:AddRadioButton() 
int	CxRadioButton::AddRadioButton()
{
//Insert your own code here.
	mRadioButtonCount++;
	return mRadioButtonCount;
//End of user code.         
}
// OPSignature: void CxRadioButton:RemoveRadioButton() 
void	CxRadioButton::RemoveRadioButton()
{
//Insert your own code here.
	mRadioButtonCount--;
//End of user code.         
}
// OPSignature: void CxRadioButton:BroadcastValueMessage() 
void	CxRadioButton::BroadcastValueMessage()
{
//Insert your own code here.
	// call the CxClass callback
	ButtonChanged();
	
	// call the framework callback
//	LControl::BroadcastValueMessage();
//End of user code.         
}
// OPSignature: void CxRadioButton:SetRadioState( Boolean:inValue ) 
void	CxRadioButton::SetRadioState( Boolean inValue )
{
//Insert your own code here.
	int value;
	
	if ( inValue == true )
		value = 1;
	else
		value = 0;
	
	SetCheck( value );
//End of user code.         
}
// OPSignature: Boolean CxRadioButton:GetRadioState() 
Boolean	CxRadioButton::GetRadioState()
{
//Insert your own code here.
	int value = GetCheck();
	
	if ( value == 1 )
		return (true);
	else
		return (false);
//End of user code.         
}

//Windows Message Map
BEGIN_MESSAGE_MAP(CxRadioButton, CButton)
	ON_CONTROL_REFLECT(BN_CLICKED, ButtonChanged)
	ON_WM_CHAR()
END_MESSAGE_MAP()

void CxRadioButton::Focus()
{
	SetFocus();
}

void CxRadioButton::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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
		case 32:    //SPACE. Activate Button.
		{
			ButtonChanged();
			break;
		}

		default:
		{
			mWidget->FocusToInput((char)nChar);
		}
	}
}
