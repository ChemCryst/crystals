////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxCheckBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 10:38 Uhr

#include	"CrystalsInterface.h"
#include	"CxCheckBox.h"
//Insert your own code here.
#include	"CxGrid.h"
#include	"CrCheckBox.h"
//#include	<TextUtils.h>
//#include	<LStdControl.h>
//End of user code.          

int	CxCheckBox::mCheckBoxCount = kCheckBoxBase;
// OPSignature: CxCheckBox * CxCheckBox:CreateCxCheckBox( CrCheckBox *:container  CxGrid *:guiParent ) 
CxCheckBox *	CxCheckBox::CreateCxCheckBox( CrCheckBox * container, CxGrid * guiParent )
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

	thePaneInfo.paneID = AddCheckBox();
	thePaneInfo.width = 80;
	thePaneInfo.height = 20;
	thePaneInfo.left = 10;
	thePaneInfo.top = 50;
	
	char * defaultName = (char *)"\pStdButton";
	CxCheckBox	*theStdButton = new CxCheckBox( container, thePaneInfo, defaultName );
*/

	char * defaultName = (char *)"StdButton" ;
	CxCheckBox	*theStdButton = new CxCheckBox(container);
	theStdButton->Create("CheckBox",WS_CHILD|WS_VISIBLE|BS_AUTOCHECKBOX,CRect(0,0,10,10),guiParent,mCheckBoxCount++);
	theStdButton->SetFont(CxGrid::mp_font);

	return theStdButton;
//End of user code.         
}
// OPSignature:  CxCheckBox:CxCheckBox( CrCheckBox *:container  SPaneInfo:&inPaneInfo char *:defaultName ) 
	CxCheckBox::CxCheckBox( CrCheckBox * container)
//Insert your own initialization here.
	:CButton( )
//End of user initialization.         
{
//Insert your own code here.
	mWidget = container;
//End of user code.         
}
// OPSignature:  CxCheckBox:~CxCheckBox() 
	CxCheckBox::~CxCheckBox()
{
//Insert your own code here.
//	RemoveCheckBox();
	mCheckBoxCount--;
//End of user code.         
}
// OPSignature: void CxCheckBox:BoxClicked() 
void	CxCheckBox::BoxClicked()
{
//Insert your own code here.
	Boolean state = GetBoxState() == 1 ? true : false;

	( (CrCheckBox *)mWidget)->BoxChanged( state );
//End of user code.         
}
// OPSignature: void CxCheckBox:SetText( char *:text ) 
void	CxCheckBox::SetText( char * text )
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
// OPSignature: void CxCheckBox:SetGeometry( int:top  int:left  int:bottom  int:right ) 
void	CxCheckBox::SetGeometry( int top, int left, int bottom, int right )
{
	MoveWindow(left,top,right-left,bottom-top,true);
}
int	CxCheckBox::GetTop()
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
int	CxCheckBox::GetLeft()
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
int	CxCheckBox::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxCheckBox::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

// OPSignature: int CxCheckBox:GetIdealWidth() 
int	CxCheckBox::GetIdealWidth()
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
// OPSignature: int CxCheckBox:GetIdealHeight() 
int	CxCheckBox::GetIdealHeight()
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
// OPSignature: int CxCheckBox:AddCheckBox() 
int	CxCheckBox::AddCheckBox()
{
//Insert your own code here.
	mCheckBoxCount++;
	return mCheckBoxCount;
//End of user code.         
}
// OPSignature: void CxCheckBox:RemoveCheckBox() 
void	CxCheckBox::RemoveCheckBox()
{
//Insert your own code here.
	mCheckBoxCount--;
//End of user code.         
}
// OPSignature: void CxCheckBox:BroadcastValueMessage() 
void	CxCheckBox::BroadcastValueMessage()
{
//Insert your own code here.
	// call the CxClass callback
	BoxClicked();
	
	// call the framework callback
//	LControl::BroadcastValueMessage();
//End of user code.         
}
// OPSignature: void CxCheckBox:SetBoxState( Boolean:inValue ) 
void	CxCheckBox::SetBoxState( Boolean inValue )
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
// OPSignature: Boolean CxCheckBox:GetBoxState() 
Boolean	CxCheckBox::GetBoxState()
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
BEGIN_MESSAGE_MAP(CxCheckBox, CButton)
	ON_CONTROL_REFLECT(BN_CLICKED, BoxClicked)
	ON_WM_CHAR()
END_MESSAGE_MAP()

void CxCheckBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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
			BoxClicked();
			break;
		}

		default:
		{
			mWidget->FocusToInput((char)nChar);
		}
	}
}

void CxCheckBox::Focus()
{
	SetFocus();
}

void CxCheckBox::Disable(Boolean disabled)
{
	if(disabled)
		EnableWindow(FALSE);
	else
		EnableWindow(TRUE);

}
