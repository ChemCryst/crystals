////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.5  2003/01/14 10:27:19  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.4  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.3  2001/07/16 07:35:32  ckp2
//   Process ON_CHAR messages.
//
//   Revision 1.2  2001/06/17 14:31:08  richard
//   CxDestroyWindow function. wx support.
//
//   Revision 1.1  2001/02/26 12:07:05  richard
//   New stretch class. Probably the simplest class ever written, it has no functionality
//   except that it can be put in a grid of non-resizing items, and it will make that
//   row, column or both appear to be able to resize, thus spreading out fixed size items.
//

#include    "crystalsinterface.h"
#include    "cccontroller.h"
#include    "cxstretch.h"
#include    "cxgrid.h"
//#include    "cccontroller.h"
#include    "crstretch.h"

int CxStretch::mStretchCount = kStretchBase;
CxStretch *    CxStretch::CreateCxStretch( CrStretch * container, CxGrid * guiParent )
{
    CxStretch  *theStretch = new CxStretch( container );
#ifdef CRY_USEMFC
    theStretch->Create(NULL,"Stretch", WS_CHILD| WS_VISIBLE, CRect(0,0,20,20), guiParent, mStretchCount++, NULL);
#endif
#ifdef CRY_USEWX
    theStretch->Create(guiParent,-1,wxPoint(0,0),wxSize(20,20));
#endif
    return theStretch;
}

CxStretch::CxStretch( CrStretch * container )
  :BASESTRETCH()
{
    ptr_to_crObject = container;
}

CxStretch::~CxStretch() { }

void CxStretch::CxDestroyWindow()
{
  #ifdef CRY_USEMFC
DestroyWindow();
#endif
#ifdef CRY_USEWX
Destroy();
#endif
}

#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxStretch, CWnd)
    ON_WM_CHAR()
    ON_WM_ERASEBKGND()
END_MESSAGE_MAP()
#endif
#ifdef CRY_USEWX
//wx Message Table
BEGIN_EVENT_TABLE(CxStretch, wxWindow)
      EVT_CHAR( CxStretch::OnChar )
END_EVENT_TABLE()  
#endif

CXONCHAR(CxStretch)

CXSETGEOMETRY(CxStretch)

CXGETGEOMETRIES(CxStretch)

int CxStretch::GetIdealWidth()  { return EMPTY_CELL; }

int CxStretch::GetIdealHeight() { return EMPTY_CELL; }

#ifdef CRY_USEMFC
BOOL CxStretch::OnEraseBkgnd(CDC* pDC)
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
