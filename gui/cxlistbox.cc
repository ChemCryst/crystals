////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxListBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  6.3.1998 10:10 Uhr

#include	"CrystalsInterface.h"
#include	"CxListBox.h"
//Insert your own code here.
#include	"CxGrid.h"
#include	"CxWindow.h"
#include	"CrListBox.h"

//#include	<LWindow.h>
//#include	<LStdControl.h>
//#include	<LTabGroup.h>

//End of user code.          

int	CxListBox::mListBoxCount = kListBoxBase;

// OPSignature: CxListBox * CxListBox:CreateCxListBox( CrListBox *:container  CxGrid *:guiParent ) 
CxListBox *	CxListBox::CreateCxListBox( CrListBox * container, CxGrid * guiParent )
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

	thePaneInfo.paneID = AddListBox();		// Push Button Pane - do this dynamically
	thePaneInfo.width = 80;
	thePaneInfo.height = 20;
	thePaneInfo.left = 10;
	thePaneInfo.top = 50;
*/	
	CxListBox	*theListBox = new CxListBox( container );
//		theListBox->Create(WS_CHILD|WS_VISIBLE|LBS_NOTIFY|LBS_MULTIPLESEL|LBS_HASSTRINGS|WS_VSCROLL, CRect(0,0,5,5), guiParent, mListBoxCount++);
	theListBox->Create(WS_CHILD|WS_VISIBLE|LBS_NOTIFY|LBS_HASSTRINGS|WS_VSCROLL, CRect(0,0,5,5), guiParent, mListBoxCount++);
	theListBox->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theListBox->SetFont(CxGrid::mp_font);

	return theListBox;
//End of user code.         
}
// OPSignature:  CxListBox:CxListBox( CrListBox *:container  SPaneInfo:&inPaneInfo ) 
	CxListBox::CxListBox( CrListBox * container )
//Insert your own initialization here.
	: CListBox()
//End of user initialization.         
{
//Insert your own code here.
	mWidget = container;

//	ListHandle	macListH = GetMacListH();
//	LAddColumn(1, 0, macListH);
	
	mItems = 0;
	mVisibleLines = 0;
}

CxListBox::~CxListBox()
{
	RemoveListBox();
}

void	CxListBox::DoubleClicked()
{
		int itemIndex = GetCurSel();
		((CrListBox *)mWidget)->Committed( itemIndex + 1 );
}

void	CxListBox::Selected()
{
		int itemIndex = GetCurSel();
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
#endif
#ifdef __WINDOWS__
	AddString(text);
	if( !mItems ) SetCurSel(0);
	mItems++;
#endif
//End of user code.         
}
// OPSignature: void CxListBox:SetVisibleLines( int:lines ) 
void	CxListBox::SetVisibleLines( int lines )
{
//Insert your own code here.
	mVisibleLines = lines;
//End of user code.         
}
// OPSignature: void CxListBox:SetGeometry( int:top  int:left  int:bottom  int:right ) 
void	CxListBox::SetGeometry( int top, int left, int bottom, int right )
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
int	CxListBox::GetTop()
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
int	CxListBox::GetLeft()
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
int	CxListBox::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxListBox::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

// OPSignature: int CxListBox:GetIdealWidth() 
int	CxListBox::GetIdealWidth()
{
//Insert your own code here.
//	ListHandle	macListH;
	CString text;
//	Str255 descriptor;
//	Cell	theCell = {0, 0};
	int maxSiz = 10; //At least you can see it if it's empty!
//	Int16 strSize;
//	
//	macListH = GetMacListH();					// Get control handle
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);

	for ( int i=0;i<mItems;i++ )
	{
//		theCell.v = i;							// Set cell and get text
		GetText(i, text);
		GetTextExtentPoint32(hdc, text, text.GetLength(), &size);

//		LGetCell( buffer, &len, theCell, macListH);
//		buffer[len]='\0';
//	
//		strcpy( reinterpret_cast<char *>(descriptor), buffer );
//		c2pstr( reinterpret_cast<char *>(descriptor) );
//
//		// Check for empty strings
//		if ( strlen( buffer ) == 0 )
//			strSize = 26;
//		else
//			strSize = ::StringWidth(descriptor) + 26;	// 26 pixels slop on either side
//
		if ( maxSiz < size.cx )
				maxSiz = size.cx;
	}

	if(mItems > mVisibleLines)
		maxSiz += GetSystemMetrics(SM_CXVSCROLL);


	return ( maxSiz + 10 ); //10 pixels spare
//End of user code.         
}
// OPSignature: int CxListBox:GetIdealHeight() 
int	CxListBox::GetIdealHeight()
{
//Insert your own code here.
	int lines = mVisibleLines;

	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	return lines * ( textMetric.tmHeight + 2 );

//	FontInfo fInfo;
//	::GetFontInfo(&fInfo);
//	if ( mVisibleLines != 0 )
//		lines = mVisibleLines;
		
//	return ( lines * (fInfo.ascent + fInfo.descent + fInfo.leading) + 2 );
					// slop of 2 pixels
//End of user code.         
}
// OPSignature: int CxListBox:GetBoxValue() 
int	CxListBox::GetBoxValue()
{
//Insert your own code here.
//	Cell	theCell = {0, 0};	
//	::LGetSelect ( true, &theCell, mMacListH );
	return ( GetCurSel() + 1 );
//End of user code.         
}


// ---------------------------------------------------------------------------
//		€ ClickSelf
// ---------------------------------------------------------------------------
//	Respond to Click inside an ListBox

/*//void
//CxListBox::ClickSelf(
//	const SMouseDownEvent	&inMouseDown)
//{
//	if (SwitchTarget(this)) {
		FocusDraw();
		
		Cell	theCell = {0, 0};	
		::LGetSelect ( true, &theCell, mMacListH );
		int theItem = theCell.v;
                            
		if (::LClick(inMouseDown.whereLocal, inMouseDown.macEvent.modifiers,
					mMacListH)) {
					
			BroadcastMessage(mDoubleClickMessage, this);
		}
		else
		{
			theCell.v = 0;
			::LGetSelect ( true, &theCell, mMacListH );
			if ( theItem != theCell.v )
				Selected( theCell.v );
		}
	}
}
*/

BEGIN_MESSAGE_MAP(CxListBox, CListBox)
	ON_CONTROL_REFLECT(LBN_DBLCLK, DoubleClicked)
	ON_CONTROL_REFLECT(LBN_SELCHANGE, Selected)
	ON_WM_CHAR()
END_MESSAGE_MAP()

void CxListBox::Focus()
{
	SetFocus();
}

void CxListBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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

