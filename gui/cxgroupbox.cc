////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGroupBox

////////////////////////////////////////////////////////////////////////

//This is probably the only Cx class without a Cr equivalent. It is
//always contained in a grid. It draws a box around controls (groups),
//and therefore doesn't fit into the heirachy properly. 

#include	"crystalsinterface.h"
#include	"cxgroupbox.h"
#include	"crgrid.h"
#include	"cxgrid.h"

int CxGroupBox::mGroupBoxCount = kGroupBoxBase;

CxGroupBox *	CxGroupBox::CreateCxGroupBox( CrGrid * container, CxGrid * guiParent )
{
	char * defaultName = (char *)"Group";
	CxGroupBox	*theGrid = new CxGroupBox( container );
	theGrid->Create("GroupBox",WS_CHILD|WS_VISIBLE|BS_GROUPBOX,CRect(0,0,10,10),guiParent,mGroupBoxCount++);
	theGrid->SetFont(CxGrid::mp_font);
	return theGrid;
}

CxGroupBox::CxGroupBox( CrGrid * container )
:CButton()
{
	NOTUSED(container);
}

CxGroupBox::~CxGroupBox()
{
	RemoveGroupBox();
}

void	CxGroupBox::SetText( char * text )
{
	SetWindowText(text);
}

void	CxGroupBox::SetGeometry( const int top, const int left, const int bottom, const int right )
{
	MoveWindow(left,top,right-left,bottom-top,true);
}

