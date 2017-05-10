////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CxTextOut.cc
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include    <string>
using namespace std;
#include    "cccontroller.h"
#include    <string>
#include    <sstream>
using namespace std;


#include    "cxtextout.h"
#include    "cxgrid.h"
#include    "crtextout.h"
#include    "crgrid.h"

#ifdef CRY_USEWX
#include <ctype.h>
#include <wx/settings.h>
#include <wx/cmndata.h>
#include <wx/fontdlg.h>
#include <wx/event.h>

// These macros are being defined somewhere. They shouldn't be.

#ifdef GetCharWidth
 #undef GetCharWidth
#endif
#ifdef DrawText
 #undef DrawText
#endif

#endif
#ifdef CRY_USEWX
//#define RGB wxColour
#endif

int CxTextOut::mTextOutCount = kTextOutBase;

CxTextOut * CxTextOut::CreateCxTextOut( CrTextOut * container, CxGrid * guiParent )
{
    CxTextOut *theMEdit = new CxTextOut (container);
#ifdef CRY_USEMFC
    theMEdit->Create(NULL, NULL, WS_VSCROLL| WS_HSCROLL| WS_VISIBLE| WS_CHILD, CRect(0,0,10,10), guiParent, mTextOutCount++);
    theMEdit->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
    theMEdit->Init();
#endif
#ifdef CRY_USEWX
    theMEdit->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10), wxVSCROLL|wxHSCROLL|wxSUNKEN_BORDER);
    theMEdit->Show(true);
    theMEdit->Init();
#endif
    return theMEdit;
}

CxTextOut::CxTextOut( CrTextOut * container )
: BASETEXTOUT ()
{
    ptr_to_crObject = container;
    mIdealHeight = 30;
    mIdealWidth  = 70;
//      mHeight = 40;
        mbOkToDraw = false;
        m_bInLink = false;
//  TRACE0( "CONSTRUCTOR : CxTextOut()\n" );
    m_pFont = NULL;
#ifdef CRY_USEMFC
    m_BackCol = GetSysColor( COLOR_WINDOW );
#endif
#ifdef CRY_USEWX
    m_BackCol = wxSystemSettings::GetColour( wxSYS_COLOUR_WINDOW );
    m_pen     = new wxPen(m_BackCol,1,wxPENSTYLE_SOLID);
    m_brush   = new wxBrush(m_BackCol,wxBRUSHSTYLE_SOLID);
#endif
    m_nHead = -1;    //The line # currently at the BOTTOM of the output area.
    m_nLinesDone = 0;
    m_nDefTextCol = COLOUR_BLACK;
    m_nXOffset = 0;
    m_nMaxLines = 1900;     // Maximum of 500 entries ( default )
    m_nMaxWidth = 0;        // Greatest width done
    m_nFontHeight = 10;     // No Font Height
    m_zDelta = 0;

    // Temporary...

#ifdef CRY_USEMFC
    m_ColTable[ COLOUR_WHITE ]      = RGB( 255, 255, 255 );  //0
    m_ColTable[ COLOUR_BLACK ]      = RGB( 0, 0, 0 );
    m_ColTable[ COLOUR_BLUE ]       = RGB( 0, 0, 128 );      //2
    m_ColTable[ COLOUR_GREEN ]      = RGB( 0, 128, 0 );
    m_ColTable[ COLOUR_LIGHTRED ]   = RGB( 255, 0, 0 );
    m_ColTable[ COLOUR_BROWN ]      = RGB( 128, 0, 0 );      //5
    m_ColTable[ COLOUR_PURPLE ]     = RGB( 128, 0, 128 );
    m_ColTable[ COLOUR_ORANGE ]     = RGB( 128, 128, 0 );
    m_ColTable[ COLOUR_YELLOW ]     = RGB( 255, 255, 0 );
    m_ColTable[ COLOUR_LIGHTGREEN ] = RGB( 0, 255, 0 );
    m_ColTable[ COLOUR_CYAN ]       = RGB( 0, 128, 128 );    //10
    m_ColTable[ COLOUR_LIGHTCYAN ]  = RGB( 0, 255, 255 );
    m_ColTable[ COLOUR_LIGHTBLUE ]  = RGB( 0, 0, 255 );
    m_ColTable[ COLOUR_PINK ]       = RGB( 255, 0, 255 );
    m_ColTable[ COLOUR_GREY ]       = RGB( 128, 128, 128 );
    m_ColTable[ COLOUR_LIGHTGREY ]  = RGB( 192, 192, 192 );  //15
#endif
#ifdef CRY_USEWX
    m_ColTable[ COLOUR_WHITE ]      = wxColour( 255, 255, 255 );  //0
    m_ColTable[ COLOUR_BLACK ]      = wxColour( 0, 0, 0 );
    m_ColTable[ COLOUR_BLUE ]       = wxColour( 0, 0, 128 );      //2
    m_ColTable[ COLOUR_GREEN ]      = wxColour( 0, 128, 0 );
    m_ColTable[ COLOUR_LIGHTRED ]   = wxColour( 255, 0, 0 );
    m_ColTable[ COLOUR_BROWN ]      = wxColour( 128, 0, 0 );      //5
    m_ColTable[ COLOUR_PURPLE ]     = wxColour( 128, 0, 128 );
    m_ColTable[ COLOUR_ORANGE ]     = wxColour( 128, 128, 0 );
    m_ColTable[ COLOUR_YELLOW ]     = wxColour( 255, 255, 0 );
    m_ColTable[ COLOUR_LIGHTGREEN ] = wxColour( 0, 255, 0 );
    m_ColTable[ COLOUR_CYAN ]       = wxColour( 0, 128, 128 );    //10
    m_ColTable[ COLOUR_LIGHTCYAN ]  = wxColour( 0, 255, 255 );
    m_ColTable[ COLOUR_LIGHTBLUE ]  = wxColour( 0, 0, 255 );
    m_ColTable[ COLOUR_PINK ]       = wxColour( 255, 0, 255 );
    m_ColTable[ COLOUR_GREY ]       = wxColour( 128, 128, 128 );
    m_ColTable[ COLOUR_LIGHTGREY ]  = wxColour( 192, 192, 192 );  //15
#endif
#ifdef CRY_USEMFC
    m_hCursor = AfxGetApp()->LoadStandardCursor( IDC_IBEAM );
#endif
    m_Lines.reserve(m_nMaxLines);
}

CxTextOut::~CxTextOut()
{
    RemoveTextOut();
	m_Lines.clear();
#ifdef CRY_USEMFC
    if( m_pFont != NULL )
    {
        m_pFont->DeleteObject();
        delete( m_pFont );
    }
#endif
#ifdef CRY_USEWX
    delete m_pen;
    delete m_brush;
#endif
}

void CxTextOut::CxDestroyWindow()
{
#ifdef CRY_USEMFC
  DestroyWindow();
#endif
#ifdef CRY_USEWX
  Destroy();
#endif
}


void CxTextOut::Init()
{

#ifdef CRY_USEMFC
#ifndef _WINNT
//  HFONT hSysFont = ( HFONT )GetStockObject( DEFAULT_GUI_FONT );
    HFONT hSysFont = ( HFONT )GetStockObject( ANSI_FIXED_FONT );
#else
    HFONT hSysFont = ( HFONT )GetStockObject( DEVICE_DEFAULT_FONT );
#endif  // !_WINNT

    LOGFONT lf;
    CFont* pFont = CFont::FromHandle( hSysFont );
    pFont->GetLogFont( &lf );
        string temp;
        temp = (CcController::theController)->GetKey( "FontHeight" );
        if ( temp.length() )
          lf.lfHeight = atoi( temp.c_str() ) ;
        temp = (CcController::theController)->GetKey( "FontWidth" );
        if ( temp.length() )
          lf.lfWidth = atoi( temp.c_str() ) ;
        temp = (CcController::theController)->GetKey( "FontFace" );
        for (string::size_type i=0;i<32;i++)
        {
              if ( i < temp.length() )
                  lf.lfFaceName[i] = temp[i];
              else
                  lf.lfFaceName[i] = 0;
        }
        CxSetFont( lf );
#endif


#ifdef CRY_USEWX
    wxFont* pFont = new wxFont(12,wxFONTFAMILY_MODERN,wxFONTSTYLE_NORMAL,wxFONTWEIGHT_NORMAL);

#ifndef _WINNT
    *pFont = wxSystemSettings::GetFont( wxSYS_ANSI_FIXED_FONT );
#else
    *pFont = wxSystemSettings::GetFont( wxDEVICE_DEFAULT_FONT );
#endif  // !_WINNT

    string temp;
//    temp = (CcController::theController)->GetKey( "FontHeight" );
//    if ( temp.length() ) pFont->SetPointSize( CRMAX( 2, atoi( temp.c_str() ) ) );
    temp = (CcController::theController)->GetKey( "FontInfo" );
    if ( temp.length() ) pFont->SetNativeFontInfo( temp.c_str() );
    CxSetFont( pFont );
#endif

    // Initialize the scroll bars:

#ifdef CRY_USEMFC
    SetScrollRange( SB_VERT, 0, 0 );
    SetScrollPos( SB_VERT, 0 );
    SetScrollRange( SB_HORZ, 0, 0 );
    SetScrollPos( SB_HORZ, 0 );
#endif
#ifdef CRY_USEWX
    SetScrollbar( wxVERTICAL, 0, 0, 0 );
    SetScrollbar( wxHORIZONTAL, 0, 0, 0 );
#endif
    mbOkToDraw = true;

#ifdef CRY_USEWX
    SetCursor( wxCursor(wxCURSOR_IBEAM) );
#endif

}



void  CxTextOut::SetText( const string &cText )
{
    AddLine( cText );
}

void  CxTextOut::ViewTop()
{
// Scrolls to the top of the text.
        SetHead(GetMaxViewableLines()-2);
#ifdef CRY_USEMFC
        Invalidate();
#endif
#ifdef CRY_USEWX
        if ( mbOkToDraw )  Refresh();
#endif
}

void  CxTextOut::Empty( )
{
    m_Lines.clear();
        SetHead(-1);
#ifdef CRY_USEMFC
//        m_Lines.RemoveAll();
//        SetHead(-1);
//        UpdateVScroll();
        Invalidate();
#endif
#ifdef CRY_USEWX
//        m_Lines.Clear();
//        SetHead(-1);
//        UpdateVScroll();
        if ( mbOkToDraw )  Refresh();
#endif
}

int CxTextOut::GetIdealWidth()
{
    return mIdealWidth;
}
int CxTextOut::GetIdealHeight()
{
    return mIdealHeight;
}

void CxTextOut::SetIdealHeight(int nCharsHigh)
{
#ifdef CRY_USEWX
      m_nFontHeight = GetCharHeight();
#endif
      mIdealHeight = nCharsHigh * m_nFontHeight;
}

void CxTextOut::SetIdealWidth(int nCharsWide)
{
#ifdef CRY_USEMFC
    CClientDC cdc(this);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
        int owidth = textMetric.tmAveCharWidth;
        mIdealWidth = nCharsWide * owidth;
#endif
#ifdef CRY_USEWX
        mIdealWidth = nCharsWide * this->GetCharWidth();
#endif
}

CXSETGEOMETRY(CxTextOut)

CXGETGEOMETRIES(CxTextOut)

void CxTextOut::Focus()
{
    SetFocus();
}

#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxTextOut, CWnd)
    ON_WM_CHAR()
    ON_WM_PAINT()
    ON_WM_ERASEBKGND()
    ON_WM_VSCROLL()
    ON_WM_SIZE()
    ON_WM_HSCROLL()
    ON_WM_SETCURSOR()
    ON_WM_LBUTTONUP()
    ON_WM_MOUSEMOVE()
    ON_WM_KEYDOWN()
    ON_WM_MOUSEWHEEL()
END_MESSAGE_MAP()
#endif
#ifdef CRY_USEWX
//wx Message Table
BEGIN_EVENT_TABLE(CxTextOut, wxWindow)
      EVT_PAINT ( CxTextOut::OnPaint )
      EVT_SCROLLWIN(CxTextOut::OnScroll)
      EVT_SIZE(CxTextOut::OnSize)
      EVT_LEFT_UP(CxTextOut::OnLButtonUp)
      EVT_MOTION(CxTextOut::OnMouseMove)
      EVT_CHAR( CxTextOut::OnChar )
      EVT_ERASE_BACKGROUND ( CxTextOut::OnEraseBackground )
END_EVENT_TABLE()
#endif

CXONCHAR(CxTextOut)


void CxTextOut::AddLine( const string& strLine )
{
    // Add to the buffer, cutting off the first ( top ) line if
    // necessary.


    if( GetLineCount() >= m_nMaxLines )
               m_Lines.erase(m_Lines.begin());

    m_Lines.push_back ("-"+strLine);

        // Automatically jump to the bottom...
    m_nHead = (int) CRMAX(GetLineCount(),GetMaxViewableLines());

        // Automatically jump to the left...
    m_nXOffset = 0;

    // Update the horizontal scroll bar:
    UpdateHScroll();

    SetHead( m_nHead );
};


#ifdef CRY_USEMFC
void CxTextOut::CxSetFont( LOGFONT& rFont )
{

// Destroy the old font if necessary:

    if( m_pFont != NULL )
    {
        delete( m_pFont );
        m_pFont = NULL;
    };


// Create the new one:


    m_pFont = new CFont;
    m_pFont->CreateFontIndirect( &rFont );
    memcpy( &m_lfFont, &rFont, sizeof( LOGFONT ) );

// Get the Average Char Width:

    TEXTMETRIC tm;
    CDC* pDC = GetDC();
    CFont* pOldFont = pDC->SelectObject( m_pFont );
    pDC->GetTextMetrics( &tm );
    pDC->SelectObject( pOldFont );
    ReleaseDC( pDC );
    m_nAvgCharWidth = tm.tmAveCharWidth;
    m_nFontHeight = tm.tmHeight;


// Redraw the display if necessary:

    m_nMaxWidth = 0;                // Reset greatest width done

    if( GetSafeHwnd() )
    {
        UpdateHScroll();    // Page size depends on average char width
        Invalidate();
    };
};
#endif


#ifdef CRY_USEWX
void CxTextOut::CxSetFont( wxFont* rFont )
{

// Destroy the old font if necessary:

    if( m_pFont != NULL )
    {
        delete( m_pFont );
        m_pFont = NULL;
    };

    m_pFont = rFont;

// Get the Average Char Width:

    SetFont ( *m_pFont );

    m_nAvgCharWidth = this->GetCharWidth();
    m_nFontHeight = this->GetCharHeight();


// Redraw the display if necessary:

    m_nMaxWidth = 0;                // Reset greatest width done

    if ( mbOkToDraw )
    {
       UpdateHScroll();    // Page size depends on average char width
       Refresh();
    }
};
#endif


void CxTextOut::SetBackColour( COLORREF col )
{
    m_BackCol = col;

    // Force a repaint if we are displayed.

#ifdef CRY_USEMFC
    if( GetSafeHwnd() )
        Invalidate();
#endif
#ifdef CRY_USEWX
        if ( mbOkToDraw )
        Refresh();
#endif
};


void CxTextOut::SetHead( int nPos )
{
    if( nPos < -1 ) nPos = -1;
    if( nPos > (int) GetLineCount() - 1 ) nPos = (int) CRMAX( GetLineCount() - 1, GetMaxViewableLines() -1 );
    m_nHead = nPos;
#ifdef CRY_USEMFC
    if( GetSafeHwnd() )
    {
        SetScrollRange( SB_VERT, GetMaxViewableLines()-1, CRMAX(GetMaxViewableLines()-1,GetLineCount()-1));
        SetScrollPos( SB_VERT, m_nHead );
        Invalidate();
    };
#endif
#ifdef CRY_USEWX
    if ( mbOkToDraw )
    {
        SetScrollbar( wxVERTICAL, CRMAX(0,m_nHead+1-GetMaxViewableLines()), GetMaxViewableLines(), 
GetLineCount() );
        Refresh();
    }
#endif
};

#ifdef CRY_USEMFC
void CxTextOut::OnPaint()
{
    CPaintDC dc( this );
    CRect clientRc; GetClientRect( &clientRc );
#endif

#ifdef CRY_USEWX
void CxTextOut::OnPaint(wxPaintEvent & event)
{
    LOGSTAT("CxTextOut::OnPaint");
    wxPaintDC dc( this );
    wxSize clientRc = GetClientSize( );
#endif

    // Initialize the draw:

    unsigned int nMaxLines = GetMaxViewableLines();         // Max number of lines in view
    m_nLinesDone = 0;                                       // No Lines drawn

    // Initialize colours and font:

#ifdef CRY_USEMFC
    CFont* pOldFont = dc.SelectObject( m_pFont );
#endif
#ifdef CRY_USEWX
    dc.SetFont( *m_pFont );
    m_nFontHeight = dc.GetCharHeight();
#endif

    // Now draw the lines, one by one:
    if( m_nHead != -1 )
    {
        unsigned int nRunner = (unsigned int) m_nHead;
#ifdef CRY_USEMFC
        int nX = clientRc.left - m_nXOffset;
        int nMasterY = clientRc.bottom;
#endif
#ifdef CRY_USEWX
        int nX = - m_nXOffset;
        int nMasterY = clientRc.GetHeight();
#endif
        string strTemp;
        int nPos = -1;
        do
        {

#ifdef CRY_USEMFC
            dc.SetBkColor( m_BackCol );
            dc.SetTextColor( m_ColTable[ m_nDefTextCol ] );
#endif
#ifdef CRY_USEWX
            dc.SetBackgroundMode( wxSOLID );
            m_brush->SetColour( m_BackCol );
            m_pen->SetColour( m_BackCol );
            dc.SetTextBackground( m_BackCol );
            dc.SetTextForeground( m_ColTable[ m_nDefTextCol ] );
            dc.SetBrush( *m_brush );
            dc.SetPen  ( *m_pen   );
#endif

            if ( nRunner >= GetLineCount()  )
            {

#ifdef CRY_USEMFC
                dc.FillSolidRect( CRect(clientRc.left,nMasterY,clientRc.right,nMasterY+m_nFontHeight), m_BackCol );
#endif
#ifdef CRY_USEWX
//                dc.DrawRectangle( clientRc.x,nMasterY,clientRc.width,nMasterY+m_nFontHeight );
                dc.DrawRectangle( 0,nMasterY,clientRc.GetWidth(),nMasterY+m_nFontHeight );
#endif

            }
            else
            {
               strTemp = m_Lines[ nRunner ];
            }
            nMasterY -= m_nFontHeight;
            if ( RenderSingleLine( strTemp, &dc, nX, nMasterY ) )
            {
               m_Lines[ nRunner ] = strTemp;
            }
            if ( nRunner == 0 ) break;
            nRunner--;
        }while( nMasterY >= 0 );

        // Pad out any remaining area...

        if( nMasterY >= 0 )
        {
#ifdef CRY_USEMFC
            CRect solidRc = clientRc;
            solidRc.bottom = nMasterY;
            dc.FillSolidRect( &solidRc, m_BackCol );
#endif
#ifdef CRY_USEWX
            wxRect solidRc = wxRect( wxPoint(0,0), clientRc );
            solidRc.height = nMasterY;
            dc.DrawRectangle( solidRc.x, solidRc.y, solidRc.width, solidRc.height );
#endif
        }
    }

#ifdef CRY_USEMFC
    else
        dc.FillSolidRect( &clientRc, m_BackCol );

    dc.SelectObject( pOldFont );      // Clean up:
#endif
#ifdef CRY_USEWX
    else
        dc.DrawRectangle( 0, 0, clientRc.GetWidth(), clientRc.GetHeight() );

    dc.SetFont(wxNullFont);
    dc.SetBrush( wxNullBrush );
    dc.SetPen  ( wxNullPen );
#endif

}

#ifdef CRY_USEMFC
BOOL CxTextOut::OnEraseBkgnd( CDC* pDC )
{
    return( TRUE ); //Reduces flickering.
}
#endif

#ifdef CRY_USEWX
void CxTextOut::OnEraseBackground( wxEraseEvent& evt )
{
    return;  //Reduces flickering. (Window is not erased).
}
#endif

#ifdef CRY_USEMFC
void CxTextOut::OnVScroll( UINT nSBCode,
                            UINT nPos,
                            CScrollBar* pScrollBar )
{
    int nUBound = (int) CRMAX(GetLineCount() - 1, GetMaxViewableLines() - 1);
    switch( nSBCode )
    {
    case SB_TOP:
        SetHead( GetMaxViewableLines() - 1 );
        break;
    case SB_BOTTOM:
        SetHead( nUBound );
        break;
    case SB_PAGEUP:
        if( m_nHead > (int) GetMaxViewableLines() - 1 )
        {
            m_nHead -= GetMaxViewableLines()/2;
            m_nHead = CRMAX(0,m_nHead);
            SetHead( m_nHead );
        }
        break;
    case SB_LINEUP:
        if( m_nHead > (int) GetMaxViewableLines() - 1 )
        {
            m_nHead--;
            SetHead( m_nHead );
        }
        break;
    case SB_PAGEDOWN:
        if( m_nHead < nUBound )
        {
            m_nHead += (int) GetMaxViewableLines()/2;
            m_nHead = CRMIN (m_nHead, nUBound);
            SetHead( m_nHead );
         };
         break;
    case SB_LINEDOWN:
         if( m_nHead < nUBound )
         {
            m_nHead++;
            SetHead( m_nHead );
         };
         break;
    case SB_THUMBPOSITION:
    case SB_THUMBTRACK:
         SetHead( ( int )nPos );
         break;
    };
    CWnd::OnVScroll( nSBCode, nPos, pScrollBar );
}
#endif

#ifdef CRY_USEWX
void CxTextOut::OnScroll(wxScrollWinEvent & evt )
{
        if ( !mbOkToDraw ) return;

        int nUBound = CRMAX(GetLineCount() - 1, GetMaxViewableLines() - 1);
        if ( evt.GetOrientation() == wxVERTICAL )
        {
          if ( evt.GetEventType() == wxEVT_SCROLLWIN_TOP ) {
                 SetHead( GetMaxViewableLines() - 1 );
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_BOTTOM ) {
                 SetHead( nUBound );
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_PAGEUP ) {
                 if( m_nHead > GetMaxViewableLines() - 1 )
                 {
                   m_nHead -= GetMaxViewableLines()/2;
                   m_nHead = CRMAX(0,m_nHead);
                   SetHead( m_nHead );
                 }
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_LINEUP ) {
                 if( m_nHead > GetMaxViewableLines() - 1 )
                 {
                   m_nHead--;
                   SetHead( m_nHead );
                 }
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_PAGEDOWN ) {
                 if( m_nHead < nUBound )
                 {
                   m_nHead += (int) GetMaxViewableLines()/2;
                   m_nHead = CRMIN (m_nHead, nUBound);
                   SetHead( m_nHead );
                 };
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_LINEDOWN ) {
                 if( m_nHead < nUBound )
                 {
                   m_nHead++;
                   SetHead( m_nHead );
                 };
          }

          else if (( evt.GetEventType() == wxEVT_SCROLLWIN_THUMBRELEASE )|| ( evt.GetEventType() == wxEVT_SCROLLWIN_THUMBTRACK )) {
                 SetHead( evt.GetPosition() + GetMaxViewableLines() - 1 );
          }
        }
        else
        {
          wxSize clientRc = GetClientSize( );
          int nMax = m_nMaxWidth - clientRc.GetWidth();

          if ( evt.GetEventType() == wxEVT_SCROLLWIN_TOP ) {
                 m_nXOffset = 0;
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_BOTTOM ) {
                 m_nXOffset = nMax;
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_PAGEUP ) {
                 m_nXOffset -= clientRc.GetWidth()/2;
                 if( m_nXOffset < 0 ) m_nXOffset = 0;
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_LINEUP ) {
                 m_nXOffset -= m_nAvgCharWidth;
                 if( m_nXOffset < 0 ) m_nXOffset = 0;
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_PAGEDOWN ) {
                 m_nXOffset += clientRc.GetWidth()/2;
                 if( m_nXOffset > nMax ) m_nXOffset = nMax;
          }
          else if ( evt.GetEventType() == wxEVT_SCROLLWIN_LINEDOWN ) {
                 m_nXOffset += m_nAvgCharWidth;
                 if( m_nXOffset > nMax ) m_nXOffset = nMax;
          }
          else if (( evt.GetEventType() == wxEVT_SCROLLWIN_THUMBRELEASE ) || (evt.GetEventType() == wxEVT_SCROLLWIN_THUMBTRACK )) {
                 m_nXOffset = evt.GetPosition();
          }
          SetScrollbar( wxHORIZONTAL, m_nXOffset, CRMIN(clientRc.GetWidth(),m_nMaxWidth) , m_nMaxWidth );
          Refresh();
        }
        LOGSTAT("CxTextOut::OnScroll ends");
}
#endif

#ifdef CRY_USEMFC
void CxTextOut::OnHScroll( UINT nSBCode,
                            UINT nPos,
                            CScrollBar* pScrollBar )
{
    CRect clientRc; GetClientRect( &clientRc );
        int nMax = m_nMaxWidth - clientRc.Width();
    switch( nSBCode )
    {
    case SB_TOP:
        m_nXOffset = 0;
        break;
    case SB_BOTTOM:
        m_nXOffset = nMax;
        break;
    case SB_PAGEUP:
        m_nXOffset -= clientRc.Width()/2;
        if( m_nXOffset < 0 ) m_nXOffset = 0;
        break;
    case SB_LINEUP:
        m_nXOffset -= m_nAvgCharWidth;
        if( m_nXOffset < 0 ) m_nXOffset = 0;
        break;
    case SB_PAGEDOWN:
        m_nXOffset += clientRc.Width()/2;
        if( m_nXOffset > nMax ) m_nXOffset = nMax;
        break;
    case SB_LINEDOWN:
        m_nXOffset += m_nAvgCharWidth;
        if( m_nXOffset > nMax) m_nXOffset = nMax;
        break;
    case SB_THUMBPOSITION:
    case SB_THUMBTRACK:
        m_nXOffset = ( int )nPos;
        break;
    };
    SetScrollPos( SB_HORZ, m_nXOffset );
    Invalidate();
    CWnd::OnHScroll( nSBCode, nPos, pScrollBar );
}
#endif

#ifdef CRY_USEMFC
void CxTextOut::OnSize(UINT nType, int cx, int cy)
{
    CWnd ::OnSize(nType, cx, cy);
    if( GetSafeHwnd() )
    {
        UpdateHScroll();
        SetHead ( m_nHead );
//        UpdateVScroll();
    };
}
#endif
#ifdef CRY_USEWX
void CxTextOut::OnSize(wxSizeEvent & event)
{
    UpdateHScroll();
//    UpdateVScroll();
    SetHead ( m_nHead );
}
#endif

#ifdef CRY_USEMFC
BOOL CxTextOut::OnSetCursor( CWnd* pWnd,
                              UINT nHitTest,
                              UINT message )
{
    if( nHitTest != HTVSCROLL &&
        nHitTest != HTHSCROLL )
    {
        SetCursor( m_hCursor );
        return( TRUE );
    }
    else
        return( CWnd::OnSetCursor( pWnd, nHitTest, message ) );
}
#endif

#ifdef CRY_USEMFC
void CxTextOut::OnMouseMove( UINT nFlags, CPoint wpoint )
{

      string dummy;
      if ( IsAHit ( dummy, wpoint.x, wpoint.y ) )
      {
          SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR4) );
      }
      else
      {
          SetCursor( AfxGetApp()->LoadStandardCursor( IDC_IBEAM ) );
      }

}
#endif

#ifdef CRY_USEWX
void CxTextOut::OnMouseMove( wxMouseEvent & evt )
{

      string dummy;
      if ( IsAHit ( dummy, evt.GetX(), evt.GetY() ) )
      {
          SetCursor( wxCursor(wxCURSOR_HAND) );
      }
      else
      {
          SetCursor( wxCursor(wxCURSOR_IBEAM) );
      }

}
#endif


bool CxTextOut::IsAHit( string & commandString, int x, int y )
{

#ifdef CRY_USEMFC
    CRect clientRc; GetClientRect( &clientRc );
        int line = m_nHead - ( ( clientRc.Height() - y ) / m_nFontHeight );
#endif
#ifdef CRY_USEWX
    wxSize clientRc = GetClientSize( );
     int line = m_nHead - ( ( clientRc.GetHeight() - y ) / m_nFontHeight );
#endif

        string strToRender;
        string strTemp;
        if ( line < 0 ) line = 0;
        if ( line < (int)GetLineCount() )
        {
            strTemp = m_Lines[ line ];
        }
        string::size_type nPos;
        int cx=0, nWidth=0, oldnX=0, cy=0;
        int nX = - m_nXOffset;

        m_bInLink = false; //Beginning new line.
        bool wasInLink = false;
        string commandText;

        do
        {
            nPos = strTemp.find( CONTROL_BYTE );
            if( nPos != string::npos )
            {
                strToRender = strTemp.substr( 0, nPos );
                commandText = strToRender;
                if( strToRender.length() > 0 )
                {
#ifdef CRY_USEMFC
                    cx = strToRender.length() * m_nAvgCharWidth;
#endif
#ifdef CRY_USEWX
                    GetTextExtent( strToRender.c_str(), &cx, &cy );
#endif
                    nX += cx;
                    nWidth += cx;
                };
                COLOURCODE code;
                strTemp.erase( 0, nPos );
                GetColourCodes( strTemp, &code );
            }
            else
            { 
                commandText = strTemp;
#ifdef CRY_USEMFC
                cx = strTemp.length() * m_nAvgCharWidth;
#endif
#ifdef CRY_USEWX
                GetTextExtent( strTemp.c_str(), &cx, &cy );
#endif
                nWidth += cx;
                nX += cx;
                break;
            }

            if (( x < nX ) && ( x > oldnX )) break;
            oldnX = nX;
            wasInLink = m_bInLink;
        }while( 1 );

        commandString = commandText;
        return (wasInLink);
}


#ifdef CRY_USEMFC
void CxTextOut::OnLButtonUp( UINT nFlags, CPoint point )
{
        int x = point.x;
        int y = point.y;
#endif
#ifdef CRY_USEWX
void CxTextOut::OnLButtonUp( wxMouseEvent & event )
{
        int x = event.m_x;
        int y = event.m_y;
#endif
        string temp;
        if ( IsAHit ( temp, x, y ) )
        {
//          TEXTOUT ( string ( "Opening link: " + temp ) );
          ((CrTextOut*)ptr_to_crObject)->ProcessLink( temp );
        }

#ifdef CRY_USEMFC
    CWnd::OnLButtonUp( nFlags, point );
#endif
}



unsigned int CxTextOut::GetMaxViewableLines()
{
#ifdef CRY_USEMFC
    ASSERT( GetSafeHwnd() != NULL );    // Must have been created
    CRect clientRc; GetClientRect( &clientRc );
    return( clientRc.Height() / m_nFontHeight );
#endif
#ifdef CRY_USEWX
    wxSize clientRc = GetClientSize();
    return( clientRc.GetHeight() / m_nFontHeight );
#endif
};


void CxTextOut::UpdateHScroll()
{
#ifdef CRY_USEMFC
    CRect clientRc; GetClientRect( &clientRc );
        int nMax = m_nMaxWidth - clientRc.Width();
    if( nMax <= 0 )
    {
        m_nXOffset = 0;
        nMax = 0;
    }
    SetScrollRange( SB_HORZ, 0, nMax );
#endif
#ifdef CRY_USEWX
    wxSize clientRc = GetClientSize();
        int nMax = m_nMaxWidth - clientRc.GetWidth();
    if( nMax <= 0 )
        m_nXOffset = 0;
    SetScrollbar( wxHORIZONTAL, m_nXOffset, CRMIN(clientRc.GetWidth(),m_nMaxWidth) , m_nMaxWidth );
#endif

};


void CxTextOut::UpdateVScroll()
{
#ifdef CRY_USEMFC
//        SetScrollRange( SB_VERT, GetMaxViewableLines()-1, CRMAX(GetMaxViewableLines()-1,GetLineCount()-1));
#endif
#ifdef CRY_USEWX
//        SetScrollbar( wxVERTICAL, CRMIN(0,m_nHead-GetMaxViewableLines()), GetMaxViewableLines(), GetLineCount() );
//        SetScrollbar( wxVERTICAL, GetMaxViewableLines()-1, 16, CRMAX(GetMaxViewableLines()-1,GetLineCount()-1));
#endif
};


bool CxTextOut::RenderSingleLine( string& strLine, PlatformDC* pDC, int nX, int nY )
{
  COLORREF lastcol = m_BackCol;
  bool needMod = false;
  bool cbFound = false;
  unsigned int nWidth = 0;

#ifdef CRY_USEMFC
  CRect clientRc; GetClientRect( &clientRc );
  SIZE sz;
  unsigned int cx,cy;
#endif

#ifdef CRY_USEWX
  wxSize clientRc = GetClientSize( );
  m_nAvgCharWidth = pDC->GetCharWidth();
  int cx,cy;
#endif

  if ( strLine.size() > 0 ) {
    string strTemp = strLine.substr(1);
    string strToRender;


    if ( strLine.substr(0,1).compare("-") == 0 ) { // There may be some CONTROL_BYTES in this line.
 
      bool bUnderline = false;
      m_bInLink = false; //Beginning new line.
      string::size_type nPos;

      do
      {
        nPos = strTemp.find( CONTROL_BYTE );
        // check if the control byte is escaped
        if(nPos!= string::npos && nPos>(size_t)1) 
        {
          if(strTemp.substr(nPos-1, 1)=="\\")
          {
		    // remove \ and orint { as normal character
		    strTemp.erase(nPos-1, 1);
		    nPos=string::npos;
	      }
        }
        if( nPos != string::npos )
        {
            cbFound = true;
            strToRender = strTemp.substr( 0, nPos );  //String up to the CONTROL BYTE
            if( strToRender.length() > 0 )
            {
#ifdef CRY_USEMFC
                if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
                {
                    ::GetTextExtentPoint32( pDC->GetSafeHdc(), strToRender.c_str(), strToRender.length(), &sz );
                    cx = sz.cx;
                }
                else
                    cx = strToRender.length() * m_nAvgCharWidth;
                pDC->TextOut( nX, nY, strToRender.c_str() );
#endif
#ifdef CRY_USEWX
                GetTextExtent( strToRender.c_str(), &cx, &cy );
                pDC->DrawText( strToRender.c_str(), nX, nY );
#endif

                if (bUnderline)
                {

#ifdef CRY_USEMFC
                     CPen pen(PS_SOLID,1,m_ColTable[ COLOUR_BLUE ]), *oldpen;
                     oldpen = pDC->SelectObject(&pen);
                     pDC->MoveTo(nX,nY-1+m_nFontHeight);
                     pDC->LineTo(nX+cx,nY-1+m_nFontHeight);
                     pDC->SelectObject(oldpen);
#endif
#ifdef CRY_USEWX
                     pDC->DrawLine(nX,nY+m_nFontHeight,nX+cx,nY+m_nFontHeight);
#endif
                }
                nX += cx;
                nWidth += cx;
            };
            COLOURCODE code;
            strTemp.erase(0,nPos);        // Rest of string, including CONTROL BYTE
            GetColourCodes( strTemp, &code );
#ifdef CRY_USEMFC
            if( code.nFore != -1 ) pDC->SetTextColor( m_ColTable[ code.nFore ] );
            if( code.nBack != -1 )
            {
              pDC->SetBkColor( m_ColTable[ code.nBack ] );
              lastcol = m_ColTable[ code.nBack ];
            }
#endif
#ifdef CRY_USEWX
            if( code.nFore != -1 )
            {
              pDC->SetTextForeground( m_ColTable[ code.nFore ] );
              m_pen->SetColour( m_ColTable[ code.nFore ] );
              pDC->SetPen( *m_pen );
            }
            if( code.nBack != -1 ) {
              pDC->SetTextBackground( m_ColTable[ code.nBack ] ) ;
              m_brush->SetColour( m_ColTable[ code.nBack ] );
              lastcol = m_ColTable[ code.nBack ];
              pDC->SetBrush( *m_brush );
            }
#endif

            bUnderline = code.nUnder;
        }
        else
        {
#ifdef CRY_USEMFC
            if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
            {
               ::GetTextExtentPoint32( pDC->GetSafeHdc(), strTemp.c_str(), strTemp.length(), &sz );
               cx = sz.cx;
            }
            else
                cx = strTemp.length() * m_nAvgCharWidth;
            pDC->TextOut( nX, nY, strTemp.c_str() );
#endif
#ifdef CRY_USEWX
            GetTextExtent( strTemp.c_str(), &cx, &cy );
            pDC->DrawText( strTemp.c_str(), nX, nY );
#endif

            nWidth += cx;
            nX += cx;
            break;
        }
      }while( 1 );

    }
    else   // There are no CONTROL_BYTES in this line. Just render it.
    {
            cbFound = true;  // No need to mod more than once.
#ifdef CRY_USEMFC
            pDC->TextOut( nX, nY, strTemp.c_str() );
            if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
            {
                                ::GetTextExtentPoint32( pDC->GetSafeHdc(), strTemp.c_str(), strTemp.length(), &sz );
                cx = sz.cx;
            }
            else
                cx = strTemp.length() * m_nAvgCharWidth;
#endif
#ifdef CRY_USEWX
            pDC->DrawText( strTemp.c_str(), nX, nY );
            GetTextExtent( strTemp.c_str(), &cx, &cy );
#endif
            nX += nWidth = cx;
    }

    if ( ! cbFound )
    {
       needMod = true;
       strLine[0] = 'x';
    }

  }

// Pad out rest of line with solid colour:
#ifdef CRY_USEMFC
  CRect solidRc( nX, nY, clientRc.right, nY + m_nFontHeight );
  pDC->FillSolidRect( &solidRc, lastcol);
#endif
#ifdef CRY_USEWX
  m_brush->SetColour( lastcol );
  m_pen->SetColour(  lastcol  );
  pDC->SetTextForeground( lastcol  );
  pDC->SetTextBackground( lastcol  ) ;
  pDC->SetPen( *m_pen );
  pDC->SetBrush( *m_brush );
  pDC->DrawRectangle( nX,nY, clientRc.GetWidth()-nX, m_nFontHeight );
#endif

  nY += m_nFontHeight;

  if( nWidth > m_nMaxWidth )
  {
      m_nMaxWidth = nWidth;
      UpdateHScroll();
  }

  return needMod;

}


int CxTextOut::GetColourCodes( string& strData, COLOURCODE* pColourCode )
{

#ifdef CRY_USEMFC
    ASSERT( pColourCode != NULL );
    ASSERT( strData[0] == CONTROL_BYTE );
#endif

    if   (strData.length() > 1 )
    {
       strData.erase(0,1); // Truncate control byte
       strData += " ";     //Pad end of string with space for every removed byte.
    }
    else
       strData = "";

    int nBytesToSkip = 1;
    pColourCode->nUnder = false;

 // Jump out if strData is now empty...

    if( strData.length() == 0 )
    {
      pColourCode->nFore = -1;    // No foreground colour
      pColourCode->nBack = -1;    // No background colour
      m_bInLink = false;
    }
    else if ( strData[0] == LINK_BYTE )
    {

// A link code {& - if in a link go back to normal, otherwise start a link.

      if ( m_bInLink )
      {
        pColourCode->nFore = 1;
        pColourCode->nBack = -1;
        m_bInLink = false;
      }
      else
      {
        pColourCode->nFore = 2;
        pColourCode->nBack = -1;
        pColourCode->nUnder = true;
        m_bInLink = true;
      }
      nBytesToSkip = 2;                       // Skip the &
      strData.erase(0,1);
      strData += " ";                         // Remove the &
    }
    else if ( strData[0] == ERROR_BYTE )
    {
        m_bInLink = false;
        pColourCode->nFore = 0;                 //white on
        pColourCode->nBack = 4;                 //red
        nBytesToSkip = 2;                       // Skip the E
        strData.erase(0,1);
        strData += " ";                         // Remove the E
    }
    else if ( strData[0] == INFO_BYTE )
    {
        m_bInLink = false;
        pColourCode->nFore = 12;                // lblue on
        pColourCode->nBack = 15;                // lgrey
        nBytesToSkip = 2;                       // Skip the I
        strData.erase(0,1);
        strData += " ";                         // Remove the I
    }
    else if ( strData[0] == STATUS_BYTE )
    {
        m_bInLink = false;
        pColourCode->nFore = 0;                 // white on
        pColourCode->nBack = 6;                 // magenta
        nBytesToSkip = 2;                       // Skip the S
        strData.erase(0,1);
        strData += " ";                         // Remove the S
    }
    else if ( strData[0] == RESULT_BYTE )
    {
        m_bInLink = false;
        pColourCode->nFore = 5;                 // maroon on
        pColourCode->nBack = 15;                // lgrey
        nBytesToSkip = 2;                       // Skip the R
        strData.erase(0,1);
        strData += " ";                         // Remove the R
    }
    else if ( strData[0] == NORMAL_BYTE )
    {
        m_bInLink = false;
        pColourCode->nFore = 1;                 // black on
        pColourCode->nBack = 0;                 // white
        nBytesToSkip = 2;                       // Skip the N
        strData.erase(0,1);
        strData += " ";                         // Remove the N
    }
    else
    {

// A colour code {xx,yy - if in a link end link because colour is not allowed in links.

      m_bInLink = false;

// Handle foreground and background colours:

      string::size_type nComma = strData.find( ',' );   // Position of comma.  Only present if background colour present

// Proceed if the comma is at pos 1,                      i.e. {x,yy
//         OR the comma is at pos 2 and pos 1 is a digit, i.e. {xx,yy
//                                                              0123

      if ( ( nComma == 1 ) || ( nComma == 2 && isdigit(strData[1]) ) )
      {
        string strFore = strData.substr(0,nComma);    // Get the foreground string xx or x
        nBytesToSkip += strFore.length() + 1;         // Skip fore code and comma
        pColourCode->nFore = atoi( strFore.c_str() ); // Get Foreground Code
        strData.erase(0,nComma+1);                    // Truncate string

        // Now look for backcolour:

        string strBack;
        int nCodeLength = 1;             //  assume one digit background code
        if ( strData.length() >= 2 )
        {
          if( isdigit( strData[1] ) )  nCodeLength++;  // no, two digit background code.
        }

        nBytesToSkip+= nCodeLength;
        strBack = strData.substr( 0,nCodeLength );        // Get the background string yy or y
        strData.erase(0,nCodeLength) ;                    // Leave the rest of the string in strData.
        strData += string(nBytesToSkip,' ');
//        for(int j=1;j<nBytesToSkip;j++){strData += " ";}  // Pad end.
        pColourCode->nBack = atoi( strBack.c_str() );     // Get the colour code.
      }
      else
      {
         // No background colour present, the delimiter for this code
         // is the next non-numeric character...

        string strFore;
        int nCodeLength = 1;          // assume one digit foreground code
        if( strData.length() >= 2 )
        {
          if( isdigit( strData[ 1 ] ) ) nCodeLength++;  // no, two digit code.
        }

        nBytesToSkip += nCodeLength;
        strFore = strData.substr( 0,nCodeLength );
        strData.erase(0,nCodeLength);                    // Leave rest of text in strData,
        strData += string(nBytesToSkip,' ');
//        for(int j=1;j<nBytesToSkip;j++){strData += " ";} //Pad end.
                                                                            // but avoid calling Sub with out of bound positions.
        pColourCode->nFore = atoi( strFore.c_str() );                // Get colourcode
        pColourCode->nBack = -1;                                         // Default background colour
      }
  }


  // Return number of bytes processed:

  return( nBytesToSkip );
};



void CxTextOut::ChooseFont()
{
#ifdef CRY_USEMFC
    LOGFONT lf;
        if ( m_pFont != NULL )
        {
           m_pFont->GetLogFont( &lf );
        }
        else
        {
#ifndef _WINNT
    HFONT hSysFont = ( HFONT )GetStockObject( ANSI_FIXED_FONT );
#else
    HFONT hSysFont = ( HFONT )GetStockObject( DEVICE_DEFAULT_FONT );
#endif  // !_WINNT
           CFont* pFont = CFont::FromHandle( hSysFont );
           pFont->GetLogFont( &lf );
        }

        CFontDialog fd(&lf,CF_FIXEDPITCHONLY|CF_SCREENFONTS);

        if ( fd.DoModal() == IDOK )
        {
           CxSetFont( lf );
           ostringstream strm;
           strm << lf.lfHeight;
           (CcController::theController)->StoreKey( "FontHeight", strm.str() );
           strm.str("");
           strm << lf.lfWidth;
           (CcController::theController)->StoreKey( "FontWidth", strm.str() );
           strm.str("");
           strm << lf.lfFaceName;
           (CcController::theController)->StoreKey( "FontFace", strm.str() );
        }
#endif

#ifdef CRY_USEWX

    wxFontData data;

    wxFont* pFont = new wxFont(12,wxFONTFAMILY_MODERN,wxFONTSTYLE_NORMAL,wxFONTWEIGHT_NORMAL);

    if ( m_pFont == NULL )
    {
#ifndef _WINNT
        *pFont = wxSystemSettings::GetFont( wxSYS_ANSI_FIXED_FONT );
#else
        *pFont = wxSystemSettings::GetFont( wxDEVICE_DEFAULT_FONT );
#endif  // !_WINNT
     }
     else
     {
        *pFont = *m_pFont;
     }

     data.SetInitialFont(*pFont);
     data.EnableEffects(false);
     data.SetAllowSymbols(false);

     wxFontDialog fd( this, data );

     if ( fd.ShowModal() == wxID_OK )
     {
        wxFontData newdata = fd.GetFontData();
        *pFont = newdata.GetChosenFont();
        CxSetFont( pFont );
        ostringstream strstrm;
//        strstrm << m_pFont->GetPointSize();
//        (CcController::theController)->StoreKey( "FontHeight", strstrm.str() );
//        strstrm.str("");
        strstrm << m_pFont->GetNativeFontInfoDesc().c_str();
        (CcController::theController)->StoreKey( "FontInfo", strstrm.str() );
//        LOGERR( strstrm.str() );
	 }

#endif

}

#ifdef CRY_USEMFC
BOOL CxTextOut::OnMouseWheel(UINT nFlags, short zDelta, CPoint pt)
{
// Accumulate delta's until 120 is reached in either direction.
// Allows for finer grained mousewheels in "The Future".

  m_zDelta += zDelta;

  if (zDelta <= -120)
  {
    m_zDelta = 0;
    ScrollPage(false);
  }
  else if ( zDelta >= 120 )
  {
    m_zDelta = 0;
    ScrollPage(true);
  }
  return CWnd::OnMouseWheel(nFlags,zDelta,pt);


}
#endif

void CxTextOut::ScrollPage(bool up)
{
   if ( up )
   {
     if( m_nHead > (int) GetMaxViewableLines() - 1 )
     {
        m_nHead -= GetMaxViewableLines()/2;
        m_nHead = CRMAX(0,m_nHead);
        SetHead( m_nHead );
     }
   }
   else
   {
     int nUBound = CRMAX(GetLineCount() - 1, GetMaxViewableLines() - 1);
     if( m_nHead < nUBound )
     {
        m_nHead += GetMaxViewableLines()/2;
        m_nHead = CRMIN (m_nHead, nUBound);
        SetHead( m_nHead );
     }
   }
}


#ifdef CRY_USEMFC
void CxTextOut::OnKeyDown ( UINT nChar, UINT nRepCnt, UINT nFlags )
{
//      CrGUIElement * theElement;
      switch (nChar) {
           case VK_PRIOR:
                  ScrollPage(true);
                  break;
           case VK_NEXT:
                  ScrollPage(false);
                  break;
           default:
                  //Do nothing
                  break;
      }
      CWnd::OnKeyDown( nChar, nRepCnt, nFlags );
}
#endif

void CxTextOut::SetTransparent()
{
#ifdef CRY_USEMFC
    SetBackColour( GetSysColor(COLOR_3DFACE) );
    ModifyStyleEx(WS_EX_CLIENTEDGE,NULL,SWP_NOSIZE|SWP_NOMOVE);
#endif
}
