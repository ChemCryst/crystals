////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxGroupBox
////////////////////////////////////////////////////////////////////////
//This is probably the only Cx class without a Cr equivalent. It is
//always contained in a grid. It draws a box around controls (groups),
//and therefore doesn't fit into the heirachy properly.

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cxgroupbox.h"
#include    "crgrid.h"
#include    "cxgrid.h"
#include    "cccontroller.h"

int CxGroupBox::mGroupBoxCount = kGroupBoxBase;

CxGroupBox *    CxGroupBox::CreateCxGroupBox( CrGrid * container, CxGrid * guiParent )
{
//      char * defaultName = (char *)"Group";
    CxGroupBox  *theGrid = new CxGroupBox( container );
#ifdef __CR_WIN__
        theGrid->Create("GroupBox",WS_CHILD| WS_VISIBLE| BS_GROUPBOX, CRect(0,0,10,10), guiParent, mGroupBoxCount++);
    theGrid->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
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

void    CxGroupBox::SetText( char * text )
{
#ifdef __CR_WIN__
    SetWindowText(text);
#endif
#ifdef __BOTHWX__
      SetLabel(text);
#endif
}

CXSETGEOMETRY(CxGroupBox)
