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
        theGrid->Create("GroupBox",WS_CHILD| WS_CLIPCHILDREN|WS_VISIBLE| BS_GROUPBOX, CRect(0,0,10,10), guiParent, mGroupBoxCount++);
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


#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxGroupBox, CWnd)
    ON_WM_ERASEBKGND()
END_MESSAGE_MAP()
#endif


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

#ifdef __CR_WIN__
BOOL CxGroupBox::OnEraseBkgnd(CDC* pDC)
{

  CRect rect;

// GetClipBox Retrieves the dimensions of the view area and
// copies to the buffer pointed to by rect.
  pDC->GetClipBox( &rect);

  COLORREF fillColor = GetSysColor(COLOR_3DFACE);

// Create the bursh and select into DC
  CBrush brush ( fillColor );
  CBrush* pOldBrush = pDC->SelectObject( &brush );

// PatBlt Creates a bit pattern on the device.
  pDC->PatBlt( rect.left, rect.top, rect.Width(), rect.Height(), PATCOPY );

  pDC->SelectObject( pOldBrush ) ;

  return TRUE;
}
#endif
