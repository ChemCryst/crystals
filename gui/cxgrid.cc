////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGrid.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
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
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "crtoolbar.h"
#include    "crwindow.h"
#include    "crguielement.h"
#include    "cxgrid.h"
#include    "crgrid.h"

#ifdef __BOTHWX__
#include <wx/settings.h>
#endif

int     CxGrid::mGridCount = kGridBase;



CxGrid *    CxGrid::CreateCxGrid( CrGrid * container, CxGrid * guiParent )
{
  CxGrid  *theGrid = new CxGrid( container );
#ifdef __CR_WIN__
    HCURSOR hCursor = AfxGetApp()->LoadCursor(IDC_ARROW);
    CBrush cBrush;
    cBrush.CreateSolidBrush(RGB(255,0,0));

    const char* wndClass = AfxRegisterWndClass( CS_HREDRAW|CS_VREDRAW,
                                       hCursor, cBrush,
                                      AfxGetApp()->LoadIcon(IDI_ICON1));

//  theGrid->Create(wndClass, "Window", WS_CHILD|WS_VISIBLE,
  theGrid->Create(wndClass, "Window", WS_CHILD|WS_VISIBLE|WS_CLIPCHILDREN,
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
#endif
#ifdef __BOTHWX__
  theGrid->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10));
  theGrid->Show(true);
  mGridCount++;


    wxFont* pFont = new wxFont(12,wxMODERN,wxNORMAL,wxNORMAL);

#ifndef _WINNT
    *pFont = wxSystemSettings::GetSystemFont( wxSYS_ANSI_FIXED_FONT );
#else
    *pFont = wxSystemSettings::GetSystemFont( wxDEVICE_DEFAULT_FONT );
#endif  // !_WINNT

    CcString temp;
    temp = (CcController::theController)->GetKey( "FontHeight" );
    if ( temp.Len() )
          pFont->SetPointSize( max( 2, atoi( temp.ToCString() ) ) );
    temp = (CcController::theController)->GetKey( "FontFace" );
          pFont->SetFaceName( temp.ToCString() );



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
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}

void    CxGrid::SetText( char * text )
{
    NOTUSED(text);
#ifdef __POWERPC__
    Str255 descriptor;
    strcpy( reinterpret_cast<char *>(descriptor), text );
    c2pstr( reinterpret_cast<char *>(descriptor) );
    SetDescriptor( descriptor );
#endif
}

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxGrid, CWnd)
    ON_WM_ERASEBKGND()
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Table
BEGIN_EVENT_TABLE(CxGrid, wxWindow)
      EVT_CHAR( CxGrid::OnChar )
END_EVENT_TABLE()
#endif

CXONCHAR(CxGrid) 

CXSETGEOMETRY(CxGrid)

CXGETGEOMETRIES(CxGrid)

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
#ifdef __CR_WIN__
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
#endif
#ifdef __BOTHWX__
      Show(state);
#endif
}


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
