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
//      char * defaultName = (char *)"Group";
	CxGroupBox	*theGrid = new CxGroupBox( container );
#ifdef __WINDOWS__
	theGrid->Create("GroupBox",WS_CHILD|WS_VISIBLE|BS_GROUPBOX,CRect(0,0,10,10),guiParent,mGroupBoxCount++);
	theGrid->SetFont(CxGrid::mp_font);
#endif
#ifdef __LINUX__
      theGrid->Create(guiParent,-1,"GroupBox",wxPoint(0,0),wxSize(0,0));
#endif
      return theGrid;
}

CxGroupBox::CxGroupBox( CrGrid * container )
:BASEGROUPBOX()
{
	NOTUSED(container);
}

CxGroupBox::~CxGroupBox()
{
	RemoveGroupBox();
}

void	CxGroupBox::SetText( char * text )
{
#ifdef __WINDOWS__
	SetWindowText(text);
#endif
#ifdef __LINUX__
      SetLabel(text);
#endif
}

void	CxGroupBox::SetGeometry( const int top, const int left, const int bottom, const int right )
{
#ifdef __WINDOWS__
      MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif
}

