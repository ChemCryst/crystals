////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxDropDown

////////////////////////////////////////////////////////////////////////

//   Filename:  CxDropDown.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  6.3.1998 10:10 Uhr

#include	"CrystalsInterface.h"
#include	"CxDropDown.h"
//Insert your own code here.
#include	"CxGrid.h"
#include	"CrDropDown.h"

//#include	<LStdControl.h>
//End of user code.          

int	CxDropDown::mDropDownCount = kDropDownBase;
// OPSignature: CxDropDown * CxDropDown:CreateCxDropDown( CrDropDown *:container  CxGrid *:guiParent  int:boxType ) 
CxDropDown *	CxDropDown::CreateCxDropDown( CrDropDown * container, CxGrid * guiParent )
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

	thePaneInfo.paneID = AddDropDown();		// Push Button Pane - do this dynamically
	thePaneInfo.width = 80;
	thePaneInfo.height = 20;
	thePaneInfo.left = 10;
	thePaneInfo.top = 50;
	
	char * defaultTitle = (char *)"\p";
	CxDropDown	*theDropDown = new CxDropDown( container, thePaneInfo, defaultTitle );
*/
	CxDropDown* theDropDown = new CxDropDown ( container);
	theDropDown->Create(CBS_DROPDOWNLIST|WS_CHILD|WS_VISIBLE,CRect(0,0,10,10),guiParent,mDropDownCount++);
//	theDropDown->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theDropDown->SetFont(CxGrid::mp_font);

	return theDropDown;
//End of user code.         
}
// OPSignature:  CxDropDown:CxDropDown( CrDropDown *:container  SPaneInfo:&inPaneInfo char *:defaultTitle ) 
	CxDropDown::CxDropDown( CrDropDown * container)
		:CComboBox()
//Insert your own initialization here.

//End of user initialization.         
{
//Insert your own code here.
	mWidget = container;
	mItems = 0;

//End of user code.         
}
// OPSignature:  CxDropDown:~CxDropDown() 
	CxDropDown::~CxDropDown()
{
//Insert your own code here.
//	RemoveDropDown();
	mDropDownCount--;
//End of user code.         
}
// OPSignature: void CxDropDown:Selected( int:itemIndex ) 
void	CxDropDown::Selected()
{
//Insert your own code here.
	((CrDropDown *)mWidget)->Selected( GetCurSel() + 1 );
//End of user code.         
}
// OPSignature: void CxDropDown:AddItem( char *:text ) 
void	CxDropDown::AddItem( char * text )
{
//Insert your own code here.
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
#endif
#ifdef __WINDOWS__
	AddString(text);
	if( !mItems ) SetCurSel(0);
	mItems++;
#endif
//End of user code.         
}
// OPSignature: void CxDropDown:SetGeometry( int:top  int:left  int:bottom  int:right ) 
void	CxDropDown::SetGeometry( const int top, const int left, const int bottom, const int right )
{
//Insert your own code here.
//	PlaceInSuperFrameAt( left, top, false );
//	ResizeFrameTo( right - left, bottom - top, true );
	//If top or left are negative, this is a call from CalcLayout,
	//therefore don't repaint the window.
	RECT windowRect;
	GetWindowRect(&windowRect);
	SetItemHeight(-1, bottom-top); //The closed up height is set by this call, MoveWindow sets the dropped height.
	if((top<0) || (left<0))
	{
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

//End of user code.         
}
// OPSignature: int CxDropDown:GetTop() 
int	CxDropDown::GetTop()
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
//End of user code.         
}
// OPSignature: int CxDropDown:GetLeft() 
int	CxDropDown::GetLeft()
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
//End of user code.         
}
// OPSignature: int CxDropDown:GetWidth() 
int	CxDropDown::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
//End of user code.         
}
// OPSignature: int CxDropDown:GetHeight() 
int	CxDropDown::GetHeight()
{
//	CRect windowRect;
//	GetWindowRect(&windowRect);
//	return ( windowRect.Height() );
	return GetItemHeight(-1);
//End of user code.         
}
// OPSignature: int CxDropDown:GetIdealWidth() 
int	CxDropDown::GetIdealWidth()
{
	CString text;
	int maxSiz = 10; //At least you can see it if it's empty!
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);

	for ( int i=0;i<mItems;i++ )
	{
		GetLBText(i, text);
		GetTextExtentPoint32(hdc, text, text.GetLength(), &size);

		if ( maxSiz < size.cx )
				maxSiz = size.cx;
	}

	return ( maxSiz + 10 ); //10 pixels spare
}

// OPSignature: int CxDropDown:GetIdealHeight() 
int	CxDropDown::GetIdealHeight()
{
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	return 5 * ( textMetric.tmHeight + 2 );
}


// OPSignature: int CxDropDown:GetDropDownValue() 
int	CxDropDown::GetDropDownValue()
{
//Insert your own code here.
//	return ( GetValue() );
	return ( GetCurSel() + 1 );
//End of user code.         
}

BEGIN_MESSAGE_MAP(CxDropDown, CComboBox)
	ON_WM_CHAR()
	ON_CONTROL_REFLECT(CBN_SELCHANGE, Selected)
END_MESSAGE_MAP()

void CxDropDown::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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


void CxDropDown::Focus()
{
	SetFocus();
}

CcString CxDropDown::GetDropDownText(int index)
{
	CString temp;
	GetLBText(index,temp);
	CcString result = temp.GetBuffer(temp.GetLength());
	return result;
}
