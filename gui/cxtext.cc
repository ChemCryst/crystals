////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 9:47 Uhr

#include	"CrystalsInterface.h"
#include	"CxText.h"
//Insert your own code here.
#include	"CxGrid.h"
#include	"CrText.h"
//#include	<TextUtils.h>
//#include	<LCaption.h>
//#include	<UTextTraits.h>

//End of user code.          

int	CxText::mTextCount = kTextBase;
// OPSignature: CxText * CxText:CreateCxText( CrText *:container  CxGrid *:guiParent ) 
CxText *	CxText::CreateCxText( CrText * container, CxGrid * guiParent )
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

	thePaneInfo.paneID = AddText();
	thePaneInfo.width = 80;
	thePaneInfo.height = 20;
	thePaneInfo.left = 10;
	thePaneInfo.top = 50;
*/	
	char * defaultName = (char *)"String";
	CxText	*theText = new CxText( container );
	theText->Create(defaultName, SS_LEFTNOWORDWRAP|WS_CHILD|WS_VISIBLE,CRect(0,0,20,20),guiParent);
	theText->SetFont(CxGrid::mp_font);
	return theText;
//End of user code.         
}
// OPSignature:  CxText:CxText( CrText *:container  SPaneInfo:&inPaneInfo char *:defaultName ) 
	CxText::CxText( CrText * container )
//Insert your own initialization here.
	:CStatic()
//End of user initialization.         
{
//Insert your own code here.
	mWidget = container;
	mCharsWidth = 0;
//End of user code.         
}
// OPSignature:  CxText:~CxText() 
	CxText::~CxText()
{
//Insert your own code here.
	RemoveText();
//End of user code.         
}
// OPSignature: void CxText:SetText( char *:text ) 
void	CxText::SetText( char * text )
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
// OPSignature: void CxText:SetGeometry( int:top  int:left  int:bottom  int:right ) 
void	CxText::SetGeometry( int top, int left, int bottom, int right )
{
	MoveWindow(left,top,right-left,bottom-top,true);
}
int	CxText::GetTop()
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
int	CxText::GetLeft()
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
int	CxText::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxText::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}


// OPSignature: int CxText:GetIdealWidth() 
int	CxText::GetIdealWidth()
{
//Insert your own code here.
/*	Str255 descriptor, str, dummy = "\p0";
	Int16 strSize, requestSize;
	
	GetDescriptor( descriptor );
	GetDescriptor( str );
	p2cstr( str );
	
	// take a dummy size
	requestSize = ::StringWidth(dummy) * mCharsWidth + 5;
	
	// Check for empty strings
	if ( strlen( (char *)str ) == 0 )
		strSize = 30;
	else
		strSize = ::StringWidth(descriptor) + 5;	// 5 pixels slop on the sides

	if ( requestSize > strSize )
		strSize = requestSize;
*/		
	CString text;
	SIZE size;
//	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	CClientDC dc(this);
	CFont* oldFont = dc.SelectObject(CxGrid::mp_font);
	GetWindowText(text);
	size = dc.GetOutputTextExtent(text);
//	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
	dc.SelectObject(oldFont);
	return ( size.cx );
//End of user code.         
}
// OPSignature: int CxText:GetIdealHeight() 
int	CxText::GetIdealHeight()
{
//Insert your own code here.
//	Int16 just = UTextTraits::SetPortTextTraits(mTxtrID);
//
//	FontInfo fInfo;
//	::GetFontInfo(&fInfo);
	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	GetWindowText(text);
	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
	return ( size.cy );
//End of user code.         
}
// OPSignature: int CxText:AddText() 
int	CxText::AddText()
{
//Insert your own code here.
	mTextCount++;
	return mTextCount;
//End of user code.         
}
// OPSignature: void CxText:RemoveText() 
void	CxText::RemoveText()
{
//Insert your own code here.
	mTextCount--;
//End of user code.         
}
// OPSignature: void CxText:SetVisibleChars( int:count ) 
void	CxText::SetVisibleChars( int count )
{
//Insert your own code here.
	mCharsWidth = count;
//End of user code.         
}
