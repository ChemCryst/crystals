////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CxTextOut.cc
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "ccstring.h"
#include    "cclist.h"


#include    "cxtextout.h"
#include    "cxgrid.h"
#include    "crtextout.h"
#include    "crgrid.h"

#ifdef __BOTHWX__
#include <ctype.h>
#include <wx/settings.h>
#include <wx/cmndata.h>
#include <wx/fontdlg.h>
#define RGB wxColour
#endif

int CxTextOut::mTextOutCount = kTextOutBase;

CxTextOut * CxTextOut::CreateCxTextOut( CrTextOut * container, CxGrid * guiParent )
{
    CxTextOut *theMEdit = new CxTextOut (container);
#ifdef __CR_WIN__
    theMEdit->Create(NULL, NULL, WS_VSCROLL| WS_HSCROLL| WS_VISIBLE| WS_CHILD, CRect(0,0,10,10), guiParent, mTextOutCount++);
    theMEdit->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
    theMEdit->Init();
#endif
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
    m_BackCol = GetSysColor( COLOR_WINDOW );
#endif
#ifdef __BOTHWX__
    m_BackCol = wxSystemSettings::GetSystemColour( wxSYS_COLOUR_WINDOW );
#endif
    m_nHead = -1;
    m_nLinesDone = 0;
    m_nDefTextCol = COLOUR_BLACK;
    m_nXOffset = 0;
    m_nMaxLines = 1900;     // Maximum of 500 entries ( default )
    m_nMaxWidth = 0;        // Greatest width done
    m_nFontHeight = 10;     // No Font Height

    // Temporary...

    m_ColTable[ COLOUR_WHITE ]      = RGB( 255, 255, 255 );
    m_ColTable[ COLOUR_BLACK ]      = RGB( 0, 0, 0 );
    m_ColTable[ COLOUR_BLUE ]       = RGB( 0, 0, 128 );
    m_ColTable[ COLOUR_GREEN ]      = RGB( 0, 128, 0 );
    m_ColTable[ COLOUR_LIGHTRED ]   = RGB( 255, 0, 0 );
    m_ColTable[ COLOUR_BROWN ]      = RGB( 128, 0, 0 );
    m_ColTable[ COLOUR_PURPLE ]     = RGB( 128, 0, 128 );
    m_ColTable[ COLOUR_ORANGE ]     = RGB( 128, 128, 0 );
    m_ColTable[ COLOUR_YELLOW ]     = RGB( 255, 255, 0 );
    m_ColTable[ COLOUR_LIGHTGREEN ] = RGB( 0, 255, 0 );
    m_ColTable[ COLOUR_CYAN ]       = RGB( 0, 128, 128 );
    m_ColTable[ COLOUR_LIGHTCYAN ]  = RGB( 0, 255, 255 );
    m_ColTable[ COLOUR_LIGHTBLUE ]  = RGB( 0, 0, 255 );
    m_ColTable[ COLOUR_PINK ]       = RGB( 255, 0, 255 );
    m_ColTable[ COLOUR_GREY ]       = RGB( 128, 128, 128 );
    m_ColTable[ COLOUR_LIGHTGREY ]  = RGB( 192, 192, 192 );
#ifdef __CR_WIN__
    m_hCursor = AfxGetApp()->LoadStandardCursor( IDC_IBEAM );
#endif
#ifdef __BOTHWX__
          SetCursor( wxCursor(wxCURSOR_IBEAM) );
#endif
}

CxTextOut::~CxTextOut()
{
    RemoveTextOut();
#ifdef __CR_WIN__
    if( m_pFont != NULL )
    {
        m_pFont->DeleteObject();
        delete( m_pFont );
    }
#endif
}

void CxTextOut::Init()
{

#ifdef __CR_WIN__
#ifndef _WINNT
//  HFONT hSysFont = ( HFONT )GetStockObject( DEFAULT_GUI_FONT );
    HFONT hSysFont = ( HFONT )GetStockObject( ANSI_FIXED_FONT );
#else
    HFONT hSysFont = ( HFONT )GetStockObject( DEVICE_DEFAULT_FONT );
#endif  // !_WINNT

    LOGFONT lf;
    CFont* pFont = CFont::FromHandle( hSysFont );
    pFont->GetLogFont( &lf );
        CcString temp;
        temp = (CcController::theController)->GetKey( "FontHeight" );
        if ( temp.Len() )
          lf.lfHeight = atoi( temp.ToCString() ) ;
        temp = (CcController::theController)->GetKey( "FontWidth" );
        if ( temp.Len() )
          lf.lfWidth = atoi( temp.ToCString() ) ;
        temp = (CcController::theController)->GetKey( "FontFace" );
        for (int i=0;i<32;i++)
        {
              if ( i < temp.Len() )
                  lf.lfFaceName[i] = temp[i];
              else
                  lf.lfFaceName[i] = 0;
        }
        CxSetFont( lf );
#endif


#ifdef __BOTHWX__
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
    CxSetFont( pFont );
#endif

    // Initialize the scroll bars:

#ifdef __CR_WIN__
    SetScrollRange( SB_VERT, 0, 0 );
    SetScrollPos( SB_VERT, 0 );
    SetScrollRange( SB_HORZ, 0, 0 );
    SetScrollPos( SB_HORZ, 0 );
#endif
#ifdef __BOTHWX__
    SetScrollbar( wxVERTICAL, 0, 0, 0 );
    SetScrollbar( wxHORIZONTAL, 0, 0, 0 );
#endif

}



void  CxTextOut::SetText( CcString cText )
{
    AddLine( cText );
}

void  CxTextOut::Empty( )
{
#ifdef __CR_WIN__
        m_Lines.RemoveAll();
        m_nHead=-1;
    UpdateVScroll();
        Invalidate();
#endif
#ifdef __BOTHWX__
        m_Lines.Clear();
        m_nHead=-1;
    UpdateVScroll();
        if ( mbOkToDraw )
            Refresh();
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
#ifdef __BOTHWX__
      m_nFontHeight = GetCharHeight();
#endif
      mIdealHeight = nCharsHigh * m_nFontHeight;
}

void CxTextOut::SetIdealWidth(int nCharsWide)
{
#ifdef __CR_WIN__
    CClientDC cdc(this);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
        int owidth = textMetric.tmAveCharWidth;
        mIdealWidth = nCharsWide * owidth;
#endif
#ifdef __BOTHWX__
        mIdealWidth = nCharsWide * GetCharWidth();
#endif
}


void  CxTextOut::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
    if((top<0) || (left<0))
    {
        RECT windowRect;
        RECT parentRect;
        GetWindowRect(&windowRect);
        CWnd* parent = GetParent();
        if(parent != nil)
        {
            parent->GetWindowRect(&parentRect);
            windowRect.top -= parentRect.top;
            windowRect.left -= parentRect.left;
        }
        MoveWindow(windowRect.left,windowRect.top,right-left,bottom-top,false);
    }
    else
    {
        MoveWindow(left,top,right-left,bottom-top,true);
    }
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
      mbOkToDraw = true;
#endif

}

int   CxTextOut::GetTop()
{
#ifdef __CR_WIN__
      RECT windowRect, parentRect;
    GetWindowRect(&windowRect);
    CWnd* parent = GetParent();
    if(parent != nil)
    {
        parent->GetWindowRect(&parentRect);
        windowRect.top -= parentRect.top;
    }
    return ( windowRect.top );
#endif
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
//  if(parent != nil)
//  {
  //          parentRect = parent->GetRect();
  //          windowRect.y -= parentRect.y;
//  }
      return ( windowRect.y );
#endif
}
int   CxTextOut::GetLeft()
{
#ifdef __CR_WIN__
      RECT windowRect, parentRect;
    GetWindowRect(&windowRect);
    CWnd* parent = GetParent();
    if(parent != nil)
    {
        parent->GetWindowRect(&parentRect);
        windowRect.left -= parentRect.left;
    }
    return ( windowRect.left );
#endif
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
    if(parent != nil)
    {
            parentRect = parent->GetRect();
            windowRect.x -= parentRect.x;
    }
      return ( windowRect.x );
#endif

}
int   CxTextOut::GetWidth()
{
#ifdef __CR_WIN__
    CRect windowRect;
    GetWindowRect(&windowRect);
    return ( windowRect.Width() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxTextOut::GetHeight()
{
#ifdef __CR_WIN__
    CRect windowRect;
    GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


void CxTextOut::Focus()
{
    SetFocus();
}

#ifdef __CR_WIN__
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
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
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

#ifdef __CR_WIN__
void CxTextOut::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
    NOTUSED(nRepCnt);
    NOTUSED(nFlags);
    switch(nChar)
    {
        case 9:     //TAB. Shift focus back or forwards.
        {
            Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
            ptr_to_crObject->NextFocus(shifted);
            break;
        }
        default:
        {
            if(ptr_to_crObject->mDisabled)
                ptr_to_crObject->FocusToInput((char)nChar);
            else
                CWnd::OnChar( nChar, nRepCnt, nFlags );
        }
    }
}
#endif

#ifdef __BOTHWX__
void CxTextOut::OnChar( wxKeyEvent & event )
{
      switch(event.KeyCode())
    {
        case 9:     //TAB. Shift focus back or forwards.
        {
                  Boolean shifted = event.m_shiftDown;
            ptr_to_crObject->NextFocus(shifted);
            break;
        }
        default:
        {
            if(ptr_to_crObject->mDisabled)
                        ptr_to_crObject->FocusToInput((char)event.KeyCode());
            else
                        event.Skip();
                  break;
        }
    }
}
#endif





void CxTextOut::SetOriginalSizes()
{
      mIdealHeight = GetHeight();
      mIdealWidth  = GetWidth();
      return;
}

void CxTextOut::AddLine( CcString& strLine )
{
    // Add to the buffer, cutting off the first ( top ) line if
    // necessary.

    m_Lines.Add( strLine.ToCString() );
    if( GetLineCount() > m_nMaxLines )
    {

#ifdef __CR_WIN__
        m_Lines.RemoveAt( 0 );
#endif
#ifdef __BOTHWX__
                m_Lines.DeleteNode(m_Lines.GetFirst());
#endif

        m_nHead--;
    };

        // Automatically jump to the
    // bottom...
    m_nHead = max(GetLineCount(),GetMaxViewableLines());
    // Update the vertical scroll bar:

    UpdateVScroll();
    SetHead( m_nHead );
};


#ifdef __CR_WIN__
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


#ifdef __BOTHWX__
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

    m_nAvgCharWidth = GetCharWidth();
    m_nFontHeight = GetCharHeight();


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

#ifdef __CR_WIN__
    if( GetSafeHwnd() )
        Invalidate();
#endif
#ifdef __BOTHWX__
        if ( mbOkToDraw )
        Refresh();
#endif
};


void CxTextOut::SetHead( int nPos )
{
    if( nPos < -1 ) nPos = -1;
        if( nPos > GetLineCount() - 1 ) nPos = max( GetLineCount() - 1, GetMaxViewableLines() -1 );
    m_nHead = nPos;
#ifdef __CR_WIN__
    if( GetSafeHwnd() )
    {
        SetScrollPos( SB_VERT, m_nHead );
        Invalidate();
    };
#endif
#ifdef __BOTHWX__
        if ( mbOkToDraw )
    {
        SetScrollbar( wxVERTICAL, m_nHead, GetMaxViewableLines(), GetLineCount() );
        Refresh();
    }
#endif
};

#ifdef __CR_WIN__
void CxTextOut::OnPaint()
{
    CPaintDC dc( this );
    CRect clientRc; GetClientRect( &clientRc );
#endif
#ifdef __BOTHWX__
void CxTextOut::OnPaint(wxPaintEvent & event)
{
        LOGSTAT("CxTextOut::OnPaint");
    wxPaintDC dc( this );
    wxSize clientRc = GetClientSize( );
#endif

    // Initialize the draw:

    int nMaxLines = GetMaxViewableLines();                  // Max number of lines in view
    m_nLinesDone = 0;                                       // No Lines drawn

    // Initialize colours and font:

#ifdef __CR_WIN__
    CFont* pOldFont = dc.SelectObject( m_pFont );
//    int nUBound = m_Lines.GetUpperBound();
#endif
#ifdef __BOTHWX__
    dc.SetFont( *m_pFont );
    m_nFontHeight = dc.GetCharHeight();
//    int nUBound = m_Lines.GetCount();
#endif

    // Now draw the lines, one by one:
    if( m_nHead != -1 )
    {
        int nRunner = m_nHead;
#ifdef __CR_WIN__
        int nX = clientRc.left - m_nXOffset;
        int nMasterY = clientRc.bottom;
#endif
#ifdef __BOTHWX__
        int nX = - m_nXOffset;
        int nMasterY = clientRc.GetHeight();
#endif
        CcString strTemp;
        int nPos = -1;
        do
        {

#ifdef __CR_WIN__
            dc.SetBkColor( m_BackCol );
            dc.SetTextColor( m_ColTable[ m_nDefTextCol ] );
#endif
#ifdef __BOTHWX__
            dc.SetBackgroundMode( wxSOLID );
            wxBrush tBrush(m_BackCol,wxSOLID);
            wxPen   tPen  (m_BackCol,1,wxSOLID);
            dc.SetTextBackground( m_BackCol );
            dc.SetTextForeground( m_ColTable[ m_nDefTextCol ] );
            dc.SetBrush( tBrush );
            dc.SetPen  ( tPen   );
#endif

            if ( nRunner >= GetLineCount()  )
            {

#ifdef __CR_WIN__
                dc.FillSolidRect( CRect(clientRc.left,nMasterY,clientRc.right,nMasterY+m_nFontHeight), m_BackCol );
#endif
#ifdef __BOTHWX__
//                dc.DrawRectangle( clientRc.x,nMasterY,clientRc.width,nMasterY+m_nFontHeight );
                dc.DrawRectangle( 0,nMasterY,clientRc.GetWidth(),nMasterY+m_nFontHeight );
#endif

            }
            else
            {

#ifdef __CR_WIN__
                           strTemp = CcString(m_Lines[ nRunner ]);
#endif
#ifdef __BOTHWX__
                           strTemp = CcString(m_Lines.ListToArray()[nRunner] );
#endif

            }
            nMasterY -= m_nFontHeight;
            RenderSingleLine( strTemp, &dc, nX, nMasterY );
            nRunner--;
        }while( nRunner > -1 && nMasterY >= 0 );

        // Pad out any remaining area...

        if( nMasterY >= 0 )
        {
#ifdef __CR_WIN__
            CRect solidRc = clientRc;
            solidRc.bottom = nMasterY;
            dc.FillSolidRect( &solidRc, m_BackCol );
#endif
#ifdef __BOTHWX__
            wxRect solidRc = wxRect( wxPoint(0,0), clientRc );
            solidRc.height = nMasterY;
            dc.DrawRectangle( solidRc.x, solidRc.y, solidRc.width, solidRc.height );
#endif
        }
    }

#ifdef __CR_WIN__
    else
        dc.FillSolidRect( &clientRc, m_BackCol );

    dc.SelectObject( pOldFont );      // Clean up:
#endif
#ifdef __BOTHWX__
    else
        dc.DrawRectangle( 0, 0, clientRc.GetWidth(), clientRc.GetHeight() );

    dc.SetFont(wxNullFont);
#endif

}

#ifdef __CR_WIN__
BOOL CxTextOut::OnEraseBkgnd( CDC* pDC )
{
    return( TRUE ); //Reduces flickering.
}
#endif

#ifdef __BOTHWX__
void CxTextOut::OnEraseBackground( wxEraseEvent& evt )
{
    return;  //Reduces flickering. (Window is not erased).
}
#endif

#ifdef __CR_WIN__
void CxTextOut::OnVScroll( UINT nSBCode,
                            UINT nPos,
                            CScrollBar* pScrollBar )
{
        int nUBound = max(GetLineCount() - 1, GetMaxViewableLines() - 1);
    switch( nSBCode )
    {
    case SB_TOP:
                SetHead( GetMaxViewableLines() - 1 );
        break;

    case SB_BOTTOM:
        SetHead( nUBound );
        break;

    case SB_PAGEUP:
    case SB_LINEUP:
                if( m_nHead > GetMaxViewableLines() - 1 )
        {
            m_nHead--;
            SetHead( m_nHead );
        }
        break;

    case SB_PAGEDOWN:
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

#ifdef __BOTHWX__
void CxTextOut::OnScroll(wxScrollWinEvent & evt )
{
        if ( !mbOkToDraw ) return;

        int nUBound = max(GetLineCount() - 1, GetMaxViewableLines() - 1);
        if ( evt.GetOrientation() == wxVERTICAL )
        {
          switch( evt.m_eventType )
          {
              case wxEVT_SCROLLWIN_TOP:
                 SetHead( GetMaxViewableLines() - 1 );
                 break;
             case wxEVT_SCROLLWIN_BOTTOM:
                 SetHead( nUBound );
                 break;
             case wxEVT_SCROLLWIN_PAGEUP:
             case wxEVT_SCROLLWIN_LINEUP:
                 if( m_nHead > GetMaxViewableLines() - 1 )
                 { 
                   m_nHead--;
                   SetHead( m_nHead );
                 }
                 break;

             case wxEVT_SCROLLWIN_PAGEDOWN:
             case wxEVT_SCROLLWIN_LINEDOWN:
                 if( m_nHead < nUBound )
                 {
                   m_nHead++;
                   SetHead( m_nHead );
                 };
                 break;

             case wxEVT_SCROLLWIN_THUMBRELEASE:
             case wxEVT_SCROLLWIN_THUMBTRACK:
                 SetHead( evt.GetPosition() + GetMaxViewableLines() - 1 );
                 break;
           };
        }
        else
        {
        wxRect clientRc = GetRect( );
            int nMax = m_nMaxWidth - clientRc.width;
        switch( evt.m_eventType )
            {
          case wxEVT_SCROLLWIN_TOP:
        m_nXOffset = 0;
        break;

          case wxEVT_SCROLLWIN_BOTTOM:
        m_nXOffset = nMax;
        break;

          case wxEVT_SCROLLWIN_PAGEUP:
          case wxEVT_SCROLLWIN_LINEUP:
        {
            m_nXOffset -= m_nAvgCharWidth;
            if( m_nXOffset < 0 ) m_nXOffset = 0;
            break;
        };

          case wxEVT_SCROLLWIN_PAGEDOWN:
          case wxEVT_SCROLLWIN_LINEDOWN:
        {
            m_nXOffset += m_nAvgCharWidth;
            if( m_nXOffset > nMax ) m_nXOffset = nMax;
            break;
        };

        case wxEVT_SCROLLWIN_THUMBRELEASE:
        case wxEVT_SCROLLWIN_THUMBTRACK:
        m_nXOffset = evt.GetPosition();
        break;
        };
        SetScrollbar( wxHORIZONTAL, m_nXOffset, (int)m_nMaxWidth/clientRc.width , m_nMaxWidth );
        Refresh();
        }
        LOGSTAT("CxTextOut::OnScroll ends");
}
#endif

#ifdef __CR_WIN__
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

    case SB_LINEUP:
    case SB_PAGEUP:
        {
            m_nXOffset -= m_nAvgCharWidth;
            if( m_nXOffset < 0 ) m_nXOffset = 0;
            break;
        };

    case SB_LINEDOWN:
    case SB_PAGEDOWN:
        {
            m_nXOffset += m_nAvgCharWidth;
            if( m_nXOffset > nMax ) m_nXOffset = nMax;
            break;
        };

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

#ifdef __CR_WIN__
void CxTextOut::OnSize(UINT nType, int cx, int cy)
{
    CWnd ::OnSize(nType, cx, cy);
    if( GetSafeHwnd() )
    {
        UpdateHScroll();
        UpdateVScroll();
    };
}
#endif
#ifdef __BOTHWX__
void CxTextOut::OnSize(wxSizeEvent & event)
{
    UpdateHScroll();
    UpdateVScroll();
}
#endif

#ifdef __CR_WIN__
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

#ifdef __CR_WIN__
void CxTextOut::OnMouseMove( UINT nFlags, CPoint wpoint )
{

      CcString dummy;
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

#ifdef __BOTHWX__
void CxTextOut::OnMouseMove( wxMouseEvent & evt )
{

      CcString dummy;
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


Boolean CxTextOut::IsAHit( CcString & commandString, int x, int y )
{

#ifdef __CR_WIN__
    CRect clientRc; GetClientRect( &clientRc );
        int line = m_nHead - ( ( clientRc.Height() - y ) / m_nFontHeight );
#endif
#ifdef __BOTHWX__
    wxRect clientRc = GetRect( );
        int line = m_nHead - ( ( clientRc.height - y ) / m_nFontHeight );
#endif

        CcString strToRender;
        CcString strTemp;
        if ( line < 0 ) line = 0;
        if ( line < GetLineCount() )
        {
#ifdef __CR_WIN__
            strTemp = CcString(m_Lines[ line ]);
#endif
#ifdef __BOTHWX__
            strTemp = CcString(m_Lines.ListToArray()[line] );
#endif
        }
        int nPos;
        int cx=0, nX=0, nWidth=0, oldnX=0;

        m_bInLink = false; //Beginning new line.
        bool wasInLink = false;
        CcString commandText;

        do
        {
            nPos = strTemp.Match( CONTROL_BYTE );
            if( nPos > 1 )
            {
                strToRender = strTemp.Sub( 1, nPos-1 );
                commandText = strToRender;
                if( strToRender.Length() > 0 )
                {
                    cx = strToRender.Length() * m_nAvgCharWidth;
                    nX += cx;
                    nWidth += cx;
                };
                COLOURCODE code;
                strTemp = strTemp.Sub( nPos,-1 );
                GetColourCodes( strTemp, &code );
            }
            else
            {
                commandText = strTemp;
                cx = strTemp.Length() * m_nAvgCharWidth;
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


#ifdef __CR_WIN__
void CxTextOut::OnLButtonUp( UINT nFlags, CPoint point )
{
        int x = point.x;
        int y = point.y;
#endif
#ifdef __BOTHWX__
void CxTextOut::OnLButtonUp( wxMouseEvent & event )
{
        int x = event.m_x;
        int y = event.m_y;
#endif
        CcString temp;
        if ( IsAHit ( temp, x, y ) )
        {
          TEXTOUT ( CcString ( "The link is: " + temp ) );
          ((CrTextOut*)ptr_to_crObject)->ProcessLink( temp );
        }

#ifdef __CR_WIN__
    CWnd::OnLButtonUp( nFlags, point );
#endif
}



int CxTextOut::GetMaxViewableLines()
{
#ifdef __CR_WIN__
    ASSERT( GetSafeHwnd() != NULL );    // Must have been created
    CRect clientRc; GetClientRect( &clientRc );
    return( clientRc.Height() / m_nFontHeight );
#endif
#ifdef __BOTHWX__
    wxRect clientRc = GetRect();
    return( clientRc.height / m_nFontHeight );
#endif
};


void CxTextOut::UpdateHScroll()
{
#ifdef __CR_WIN__
    CRect clientRc; GetClientRect( &clientRc );
        int nMax = m_nMaxWidth - clientRc.Width();
    if( nMax <= 0 )
        m_nXOffset = 0;
    SetScrollRange( SB_HORZ, 0, nMax );
#endif
#ifdef __BOTHWX__
    wxRect clientRc = GetRect();
        int nMax = m_nMaxWidth - clientRc.width;
    if( nMax <= 0 )
        m_nXOffset = 0;
    SetScrollbar( wxHORIZONTAL, 0, (int)m_nMaxWidth/clientRc.width , m_nMaxWidth );
#endif

};


void CxTextOut::UpdateVScroll()
{
#ifdef __CR_WIN__
        SetScrollRange( SB_VERT, GetMaxViewableLines()-1, max(GetMaxViewableLines()-1,GetLineCount()-1));
#endif
#ifdef __BOTHWX__
        SetScrollbar( wxVERTICAL, GetMaxViewableLines()-1, 16, max(GetMaxViewableLines()-1,GetLineCount()-1));
#endif
};


void CxTextOut::RenderSingleLine( CcString& strLine, PlatformDC* pDC, int nX, int nY )
{
#ifdef __CR_WIN__
    CRect clientRc; GetClientRect( &clientRc );
    SIZE sz;
#endif
#ifdef __BOTHWX__
    wxRect clientRc = GetRect( );
    m_nAvgCharWidth = pDC->GetCharWidth();
#endif

    CcString strTemp = strLine;
    CcString strToRender;

    int cx;
    int nPos;
    int nWidth = 0;
    Boolean bUnderline = false;
    m_bInLink = false; //Beginning new line.

    do
    {
        nPos = strTemp.Match( CONTROL_BYTE );
        if( nPos > 0 )
        {
            if ( nPos > 1 ) strToRender = strTemp.Sub( 1, nPos-1 );    //String up to the CONTROL BYTE
            if( strToRender.Length() > 0 )
            {
#ifdef __CR_WIN__
                if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
                {
                    ::GetTextExtentPoint32( pDC->GetSafeHdc(), strToRender.ToCString(), strToRender.Length(), &sz );
                    cx = sz.cx;
                }
                else
#endif
                cx = strToRender.Length() * m_nAvgCharWidth;

#ifdef __CR_WIN__
                pDC->TextOut( nX, nY, strToRender.ToCString() );
#endif
#ifdef __BOTHWX__
                pDC->DrawText( strToRender.ToCString(), nX, nY );
#endif

                if (bUnderline)
                {

#ifdef __CR_WIN__
                                    pDC->MoveTo(nX,nY+m_nFontHeight);
                                    pDC->LineTo(nX+cx,nY+m_nFontHeight);
#endif
#ifdef __BOTHWX__
                                    pDC->DrawLine(nX,nY+m_nFontHeight,nX+cx,nY+m_nFontHeight);
#endif
                }
                nX += cx;
                nWidth += cx;
            };
            COLOURCODE code;
            strTemp = strTemp.Sub(nPos,-1);        // Rest of string, including CONTROL BYTE
            GetColourCodes( strTemp, &code );
#ifdef __CR_WIN__
            if( code.nFore != -1 ) pDC->SetTextColor( m_ColTable[ code.nFore ] );
            if( code.nBack != -1 ) pDC->SetBkColor( m_ColTable[ code.nBack ] );
#endif
#ifdef __BOTHWX__
            if( code.nFore != -1 ) pDC->SetTextForeground( m_ColTable[ code.nFore ] );
            if( code.nBack != -1 ) {
              pDC->SetTextBackground( m_ColTable[ code.nBack ] ) ;
              wxBrush tBrush(m_ColTable[ code.nBack ],wxSOLID);
              pDC->SetBrush( tBrush );
            }
#endif

            bUnderline = code.nUnder;
        }
        else
        {
#ifdef __CR_WIN__
            if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
            {
                                ::GetTextExtentPoint32( pDC->GetSafeHdc(), strTemp.ToCString(), strTemp.Length(), &sz );
                cx = sz.cx;
            }
            else
#endif
                cx = strTemp.Length() * m_nAvgCharWidth;
            nWidth += cx;
#ifdef __CR_WIN__
            pDC->TextOut( nX, nY, strTemp.ToCString() );
#endif
#ifdef __BOTHWX__
            pDC->DrawText( strTemp.ToCString(), nX, nY );
#endif
            nX += cx;

            // Pad out rest of line with solid colour:


#ifdef __CR_WIN__
            CRect solidRc( nX, nY, clientRc.right, nY + m_nFontHeight );
            pDC->FillSolidRect( &solidRc, m_BackCol );
#endif
#ifdef __BOTHWX__
                        pDC->DrawRectangle( nX,nY, clientRc.width, m_nFontHeight );
#endif
            break;
        }
    }while( 1 );

    nY += m_nFontHeight;



    if( nWidth > m_nMaxWidth )
    {
        m_nMaxWidth = nWidth;
        UpdateHScroll();
    }
}


int CxTextOut::GetColourCodes( CcString& strData, COLOURCODE* pColourCode )
{

#ifdef __CR_WIN__
    ASSERT( pColourCode != NULL );
    ASSERT( strData.Sub( 1,1 ) == CONTROL_BYTE );
#endif

        if   (strData.Length() > 1 ) strData = strData.Sub( 2,-1 ); // Truncate control byte
        else                         strData = "";

        int nBytesToSkip = 1;
        pColourCode->nUnder = false;

 // Jump out if strData is now empty...

        if( strData.Length() == 0 )
        {
                pColourCode->nFore = -1;    // No foreground colour
                pColourCode->nBack = -1;    // No background colour
                m_bInLink = false;
        }
        else if ( strData.Match( LINK_BYTE ) == 1 )
        {

// A link code {& - if in a link go back to normal, otherwise start a link.

                if ( m_bInLink )
                {
                   pColourCode->nFore = 1;
                   pColourCode->nBack = 0;
                   m_bInLink = false;
                }
                else
                {
                   pColourCode->nFore = 2;
                   pColourCode->nBack = 0;
                   pColourCode->nUnder = true;
                   m_bInLink = true;
                }
                nBytesToSkip = 2;                 // Skip the &
                strData = strData.Sub( 2,-1 );    // Remove the &
        }
        else
        {

// A colour code {xx,yy - if in a link end link because colour is not allowed in links.

            m_bInLink = false;

// Handle foreground and background colours:

            int nComma = strData.Match( ',' );   // Position of comma.  Only present if background colour present

// Proceed if the comma is at pos 2,                      i.e. {x,yy
//         OR the comma is at pos 3 and pos 2 is a digit, i.e. {xx,yy

        if ( ( nComma == 2 ) || ( nComma == 3 && isdigit(strData[1]) ) )
        {
            CcString strFore = strData.Sub( 1,nComma-1 );           // Get the foreground string xx or x
            nBytesToSkip += strFore.Length() + 1;                   // Skip fore code and comma
            pColourCode->nFore = atoi( strFore.ToCString() );       // Get Foreground Code
            strData = strData.Sub( nComma+1 ,-1 );                  // Truncate string

            // Now look for backcolour:

            CcString strBack;
            int nCodeLength = 1;             //  assume one digit background code
            if ( strData.Length() >= 2 )
            {
                if( isdigit( strData[1] ) )  nCodeLength++;  // no, two digit background code.
            }

            nBytesToSkip+= nCodeLength;
            strBack = strData.Sub( 1,nCodeLength );          // Get the background string yy or y
            strData = strData.Sub( min(strData.Length(),nCodeLength+1),-1 );       // Leave the rest of the string in strData.
            pColourCode->nBack = atoi( strBack.ToCString() ); // Get the colour code.
        }
        else
        {
            // No background colour present, the delimiter for this code
            // is the next non-numeric character...

            CcString strFore;
            int nCodeLength = 1;          // assume one digit foreground code
            if( strData.Length() >= 2 )
            {
                                if( isdigit( strData[ 1 ] ) ) nCodeLength++;  // no, two digit code.
            }

            nBytesToSkip += nCodeLength;
            strFore = strData.Sub( 1,nCodeLength );
            strData = strData.Sub( min(nCodeLength+1,strData.Length()),-1 ); // Leave rest of text in strData,
                                                                             // but avoid calling Sub with out of bound positions.
            pColourCode->nFore = atoi( strFore.ToCString() );                // Get colourcode
            pColourCode->nBack = -1;                                         // Default background colour
        }
    }


    // Return number of bytes processed:

    return( nBytesToSkip );
};



void CxTextOut::ChooseFont()
{
#ifdef __CR_WIN__
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
           (CcController::theController)->StoreKey( "FontHeight", CcString(lf.lfHeight) );
           (CcController::theController)->StoreKey( "FontWidth", CcString(lf.lfWidth) );
           (CcController::theController)->StoreKey( "FontFace", CcString(lf.lfFaceName) );
        }
#endif

#ifdef __BOTHWX__

    wxFontData data;

    wxFont* pFont = new wxFont(12,wxMODERN,wxNORMAL,wxNORMAL);

    if ( m_pFont == NULL )
    {
#ifndef _WINNT
        *pFont = wxSystemSettings::GetSystemFont( wxSYS_ANSI_FIXED_FONT );
#else
        *pFont = wxSystemSettings::GetSystemFont( wxDEVICE_DEFAULT_FONT );
#endif  // !_WINNT
     }
	 else
	 {
		*pFont = *m_pFont;
	 }

     data.SetInitialFont(*pFont);


     wxFontDialog fd( this, &data );

     if ( fd.ShowModal() == wxID_OK )
     {
            wxFontData newdata = fd.GetFontData();

            *pFont = newdata.GetChosenFont();
            CxSetFont( pFont );

           (CcController::theController)->StoreKey( "FontHeight", CcString(m_pFont->GetPointSize()) );
           (CcController::theController)->StoreKey( "FontFace", CcString(m_pFont->GetFaceName()) );

     }

#endif

}
