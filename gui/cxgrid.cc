////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGrid.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 16:18 Uhr

#include	"CrystalsInterface.h"
#include	"CxGrid.h"
//Insert your own code here.
#include	"CrGrid.h"
//#include	<LView.h>
//#include	<LRadioGroup.h>
//End of user code.          

int		CxGrid::mGridCount = kGridBase;
CFont*	CxGrid::mp_font = nil;

// OPSignature: CxGrid * CxGrid:CreateCxGrid( CrGrid *:container  CxGrid *:guiParent ) 
CxGrid *	CxGrid::CreateCxGrid( CrGrid * container, CxGrid * guiParent )
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

	thePaneInfo.paneID = AddGrid();		// Grid Pane - do this dynamically
	thePaneInfo.width = 1000;
	thePaneInfo.height = 1000;
	thePaneInfo.left = 0;
	thePaneInfo.top = 0;
	
	SViewInfo	theViewInfo;		// Set up common View parameters
	theViewInfo.imageSize.width = 0;
	theViewInfo.imageSize.height = 0;
	theViewInfo.scrollPos.h = 0;
	theViewInfo.scrollPos.v = 0;
	theViewInfo.scrollUnit.h = 1;
	theViewInfo.scrollUnit.v = 1;
	theViewInfo.reconcileOverhang = false;

	CxGrid	*theGrid = new CxGrid( container, thePaneInfo, theViewInfo );
*/
	CxGrid  *theGrid = new CxGrid( container );
	theGrid->Create(NULL, "Window", WS_CHILD|WS_VISIBLE, 
				    CRect(0,0,200,200), guiParent,mGridCount++,NULL);
	
	if (mp_font == nil)
	{
		LOGFONT lf;
		::GetObject(GetStockObject(DEFAULT_GUI_FONT), sizeof(LOGFONT), &lf);
		mp_font = new CFont();
		if (mp_font->CreateFontIndirect(&lf))
			theGrid->SetFont(mp_font);
		else
			ASSERT(0);
	}
	else
	{
		theGrid->SetFont(mp_font);
	}	

	return theGrid;
//End of user code.         
}
// OPSignature:  CxGrid:CxGrid( CrGrid *:container  SPaneInfo:&inPaneInfo ) 
	CxGrid::CxGrid( CrGrid * container )
//Insert your own initialization here.
	: CWnd( ) // **** Place a default string
//	: LGroupBox( inPaneInfo, "\pGroup", 0 ) // **** Place a default string
//End of user initialization.         
{
//Insert your own code here.
	mWidget = container;
//	mRadioGroup = new CrRadioGroup;
//End of user code.         
}
// OPSignature:  CxGrid:~CxGrid() 
	CxGrid::~CxGrid()
{
//Insert your own code here.
	mGridCount--;
//	delete mp_font;
//	if ( mRadioGroup != nil )
//		delete mRadioGroup;
//End of user code.         
}
// OPSignature: void CxGrid:SetText( char *:text ) 
void	CxGrid::SetText( char * text )
{
//Insert your own code here.
	NOTUSED(text);
#ifdef __POWERPC__
	Str255 descriptor;
	
	strcpy( reinterpret_cast<char *>(descriptor), text );
	c2pstr( reinterpret_cast<char *>(descriptor) );
	SetDescriptor( descriptor );
#endif
#ifdef __LINUX__
#endif
//End of user code.         
}

void	CxGrid::SetGeometry( int top, int left, int bottom, int right )
{
	MoveWindow(left,top,right-left,bottom-top,true);
}
int	CxGrid::GetTop()
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
int	CxGrid::GetLeft()
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
int	CxGrid::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxGrid::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}
int	CxGrid::GetIdealWidth()
{
//Insert your own code here.
	return (100);
//End of user code.         
}
// OPSignature: int CxGrid:GetIdealHeight() 
int	CxGrid::GetIdealHeight()
{
//Insert your own code here.
	return (100);
//End of user code.         
}
// OPSignature: void CxGrid:AddRadioButton() 
void	CxGrid::AddRadioButton( CxRadioButton * theRadio )
{
NOTUSED(theRadio);
	//Insert your own code here.
//	if ( mRadioGroup != nil )
//		mRadioGroup->AddRadio( theRadio );
//End of user code.         
}