////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGrid.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "crtoolbar.h"
#include    "crwindow.h"
#include    "crguielement.h"
#include    "cxgrid.h"
#include    "crgrid.h"

int     CxGrid::mGridCount = kGridBase;



CxGrid *    CxGrid::CreateCxGrid( CrGrid * container, CxGrid * guiParent )
{
  CxGrid  *theGrid = new CxGrid( container );
#ifdef __CR_WIN__
  theGrid->Create(NULL, "Window", WS_CHILD|WS_VISIBLE,
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


