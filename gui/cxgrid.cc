////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGrid.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.19  2011/05/16 10:56:32  rich
//   Added pane support to WX version. Added coloured bonds to model.
//
//   Revision 1.18  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.2  2005/01/12 13:15:56  rich
//   Fix storage and retrieval of font name and size on WXS platform.
//   Get rid of warning messages about missing bitmaps and toolbar buttons on WXS version.
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.17  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.16  2004/05/13 14:51:47  rich
//   Removed debug print.
//
//   Revision 1.15  2004/05/13 09:18:19  rich
//   AfxRegisterWndClass was leaking resources. Use a predefined WNDCLASS instead.
//
//   Revision 1.14  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.13  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.12  2001/11/16 15:12:51  ckp2
//   Useful debugging tip.
//
//   Revision 1.11  2001/11/14 10:30:40  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.10  2001/07/16 07:31:44  ckp2
//   Process ON_CHAR messages - result in passing keypress to current input editbox. Now
//   whole interface is much easier to start typing from.
//
//   Revision 1.9  2001/06/17 14:41:59  richard
//   CxDestroyWindow function.
//
//   Revision 1.8  2001/03/08 16:44:08  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    <string>
using namespace std;
#include    "cccontroller.h"
#include    "crtoolbar.h"
#include    "crwindow.h"
#include    "crguielement.h"
#include    "cxgrid.h"
#include    "crgrid.h"

#ifdef CRY_USEWX
#include <wx/settings.h>
#endif

int     CxGrid::mGridCount = kGridBase;



CxGrid *    CxGrid::CreateCxGrid( CrGrid * container, CxGrid * guiParent )
{
  CxGrid  *theGrid = new CxGrid( container );
#ifdef CRY_USEMFC
    HCURSOR hCursor = AfxGetApp()->LoadCursor(IDC_ARROW);
    CBrush cBrush;
    cBrush.CreateSolidBrush(RGB(255,0,0));

    const char* wndClass = AfxRegisterWndClass( CS_HREDRAW|CS_VREDRAW,
                                       hCursor, cBrush,
                                      AfxGetApp()->LoadIcon(IDI_ICON1));

//  theGrid->Create(wndClass, "Window", WS_CHILD|WS_VISIBLE,
//  theGrid->Create(wndClass, "Window", WS_CHILD|WS_VISIBLE|WS_CLIPCHILDREN,
  theGrid->Create(_T("STATIC"), _T(""), WS_CHILD|WS_VISIBLE|WS_CLIPCHILDREN,
                  CRect(0,0,200,200), guiParent,mGridCount++,NULL);

  if (CcController::mp_font == nil)
  {
    LOGFONT lf;
    ::GetObject(GetStockObject(DEFAULT_GUI_FONT), sizeof(LOGFONT), &lf);
    CcController::mp_font = new CFont();
    if (CcController::mp_font->CreateFontIndirect(&lf)) theGrid->SetFont(CcController::mp_font);
    else                                  ASSERT(0);
  }
  else
  {
        theGrid->SetFont(CcController::mp_font);
  }
#else
  theGrid->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10),wxWANTS_CHARS); //wxTRANSPARENT_WINDOW);
//  theGrid->Show(true);
  mGridCount++;
#endif
  return theGrid;
}

CxGrid::CxGrid( CrGrid * container )
      : BASEGRID( )
{
    ptr_to_crObject = container;
}

CxGrid::~CxGrid()
{
    mGridCount--;
}

void CxGrid::CxDestroyWindow()
{
  #ifdef CRY_USEMFC
DestroyWindow();
#else
Destroy();
#endif
}

void    CxGrid::SetText( const string & text )
{
    NOTUSED(text);
}

#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxGrid, CWnd)
    ON_WM_ERASEBKGND()
    ON_WM_CHAR()
END_MESSAGE_MAP()
#else
//wx Message Table
BEGIN_EVENT_TABLE(CxGrid, wxWindow)
      EVT_CHAR( CxGrid::OnChar )
      EVT_SIZE( CxGrid::OnSize )
END_EVENT_TABLE()
#endif

CXONCHAR(CxGrid) 

CXSETGEOMETRY(CxGrid)

CXGETGEOMETRIES(CxGrid)


#ifdef CRY_USEWX
void CxGrid::OnSize(wxSizeEvent & event)
{
      ostringstream strm;
      strm << "OnSize called " << event.GetSize().x <<  " " << event.GetSize().y;
      LOGSTAT( strm.str() );
      wxSize si = GetClientSize(); //Onsize is whole window - we only want this bit.
      ((CrGrid*)ptr_to_crObject)->ResizeGrid( si.GetWidth(), si.GetHeight() );
}
#endif



int CxGrid::GetIdealWidth()
{
    return (100);
}

int CxGrid::GetIdealHeight()
{
    return (100);
}

void CxGrid::CxShowWindow(bool state)
{
#ifdef CRY_USEMFC
  if (state)
  {
     ShowWindow(SW_SHOW);
     UpdateWindow();
  }
  else
  {
     ShowWindow(SW_HIDE);
     UpdateWindow();
  }
#else
      Show(state);
#endif
}

#ifdef CRY_USEMFC
BOOL CxGrid::OnEraseBkgnd(CDC* pDC)
{

  CRect rect;

// GetClipBox Retrieves the dimensions of the view area and
// copies to the buffer pointed to by rect.
  pDC->GetClipBox( &rect);

  COLORREF fillColor = GetSysColor(COLOR_3DFACE);
// Use this to color unused space red: (for debugging)  COLORREF fillColor = RGB(255,0,0);

// Create the bursh and select into DC
  CBrush brush ( fillColor );
  CBrush* pOldBrush = pDC->SelectObject( &brush );

// PatBlt Creates a bit pattern on the device.
  pDC->PatBlt( rect.left, rect.top, rect.Width(), rect.Height(), PATCOPY );

  pDC->SelectObject( pOldBrush ) ;

  return TRUE;
}
#endif
