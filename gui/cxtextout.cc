////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CxTextOut.cc
//   Authors:   Richard Cooper 

#include	"crystalsinterface.h"
#include    "cccontroller.h"
#include    "ccstring.h"
#include    "cclist.h"
#include    "cclink.h"


#include	"cxtextout.h"
#include	"cxgrid.h"
#include	"crtextout.h"
#include	"crgrid.h"

int CxTextOut::mTextOutCount = kTextOutBase;

CxTextOut * CxTextOut::CreateCxTextOut( CrTextOut * container, CxGrid * guiParent )
{
	CxTextOut *theMEdit = new CxTextOut (container);
#ifdef __WINDOWS__
        theMEdit->Create(NULL, NULL, WS_VSCROLL| WS_HSCROLL| WS_VISIBLE| WS_CHILD, CRect(0,0,10,10), guiParent, mTextOutCount++);
	theMEdit->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theMEdit->Init();
#endif
#ifdef __LINUX__
      theMEdit->Create(guiParent, -1, "EditBox", wxPoint(0,0), wxSize(10,10), wxTE_MULTILINE); 
#endif
	return theMEdit;
}

CxTextOut::CxTextOut( CrTextOut * container )
: BASETEXTOUT ()
{
	mWidget = container;
	mIdealHeight = 30;
	mIdealWidth  = 70;
      mHeight = 40;
        m_bInLink = false;
	TRACE0( "CONSTRUCTOR : CxTextOut()\n" );
	m_pFont = NULL;
	m_BackCol = GetSysColor( COLOR_WINDOW );
	m_nHead = -1;
	m_nLinesDone = 0;
	m_nDefTextCol = COLOUR_BLACK;
	m_bWordWrap = false;
	m_nXOffset = 0;
	m_nMaxLines = 1900;		// Maximum of 500 entries ( default )
	m_nMaxWidth = 0;		// Greatest width done
	m_nFontHeight = 10;		// No Font Height

	// Temporary...

	m_ColTable[ COLOUR_WHITE ]		= RGB( 255, 255, 255 );
	m_ColTable[ COLOUR_BLACK ]		= RGB( 0, 0, 0 );
	m_ColTable[ COLOUR_BLUE ]		= RGB( 0, 0, 128 );
	m_ColTable[ COLOUR_GREEN ]		= RGB( 0, 128, 0 );
	m_ColTable[ COLOUR_LIGHTRED ]	= RGB( 255, 0, 0 );
	m_ColTable[ COLOUR_BROWN ]		= RGB( 128, 0, 0 );
	m_ColTable[ COLOUR_PURPLE ]		= RGB( 128, 0, 128 );
	m_ColTable[ COLOUR_ORANGE ]		= RGB( 128, 128, 0 );
	m_ColTable[ COLOUR_YELLOW ]		= RGB( 255, 255, 0 );
	m_ColTable[ COLOUR_LIGHTGREEN ]	= RGB( 0, 255, 0 );
	m_ColTable[ COLOUR_CYAN ]		= RGB( 0, 128, 128 );
	m_ColTable[ COLOUR_LIGHTCYAN ]	= RGB( 0, 255, 255 );
	m_ColTable[ COLOUR_LIGHTBLUE ]	= RGB( 0, 0, 255 );
	m_ColTable[ COLOUR_PINK ]		= RGB( 255, 0, 255 );
	m_ColTable[ COLOUR_GREY ]		= RGB( 128, 128, 128 );
	m_ColTable[ COLOUR_LIGHTGREY ]	= RGB( 192, 192, 192 );

	m_hCursor = AfxGetApp()->LoadStandardCursor( IDC_IBEAM );

}

CxTextOut::~CxTextOut()
{
	RemoveTextOut();
	if( m_pFont != NULL )
	{
		m_pFont->DeleteObject();
		delete( m_pFont );
	}
}

void CxTextOut::Init() 
{

#ifndef _WINNT
//	HFONT hSysFont = ( HFONT )GetStockObject( DEFAULT_GUI_FONT );
	HFONT hSysFont = ( HFONT )GetStockObject( ANSI_FIXED_FONT );
#else
	HFONT hSysFont = ( HFONT )GetStockObject( DEVICE_DEFAULT_FONT );
#endif	// !_WINNT


	LOGFONT lf;
	CFont* pFont = CFont::FromHandle( hSysFont );
	pFont->GetLogFont( &lf );
        CcString temp;
        temp = (CcController::theController)->GetKey( "FontHeight" );
        if ( temp.Len() )
          lf.lfHeight = min( 2, atoi( temp.ToCString() ) );
        temp = (CcController::theController)->GetKey( "FontWidth" );
        if ( temp.Len() )
          lf.lfWidth = min( 2, atoi( temp.ToCString() ) );
        temp = (CcController::theController)->GetKey( "FontFace" );
 	    for (int i=0;i<32;i++)
		{
              if ( i < temp.Len() )
    			  lf.lfFaceName[i] = temp[i];
			  else 
				  lf.lfFaceName[i] = 0;
		}
        SetFont( lf );

	// Initialize the scroll bars:

	SetScrollRange( SB_VERT, 0, 0 );
	SetScrollPos( SB_VERT, 0 );
	SetScrollRange( SB_HORZ, 0, 0 );
	SetScrollPos( SB_HORZ, 0 );

}



void  CxTextOut::SetText( CcString cText )
{
	AddLine( CString((char*)cText.ToCString()) );
}

void  CxTextOut::Empty( )
{
        m_Lines.RemoveAll();
        m_nHead=-1;
	UpdateVScroll();
        Invalidate();
}

int	CxTextOut::GetIdealWidth()
{
	return mIdealWidth;
}
int	CxTextOut::GetIdealHeight()
{
	return mIdealHeight;
}

void CxTextOut::SetIdealHeight(int nCharsHigh)
{
#ifdef __WINDOWS__
//      CClientDC cdc(this);
//      TEXTMETRIC textMetric;
//      cdc.GetTextMetrics(&textMetric);
//      mIdealHeight = nCharsHigh * textMetric.tmHeight;
      mIdealHeight = nCharsHigh * mHeight;
#endif
#ifdef __LINUX__
      mIdealHeight = nCharsHigh * GetCharHeight();
#endif      
}

void CxTextOut::SetIdealWidth(int nCharsWide)
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
      int owidth = textMetric.tmAveCharWidth;
//      int oheight= textMetric.tmHeight;
//      mIdealWidth = (int)(nCharsWide * owidth * mHeight / (float)oheight);
      mIdealWidth = nCharsWide * owidth;
#endif
#ifdef __LINUX__
      mIdealWidth = nCharsWide * GetCharWidth();
#endif      
}


void  CxTextOut::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
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
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}

int   CxTextOut::GetTop()
{
#ifdef __WINDOWS__
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
#ifdef __LINUX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
	if(parent != nil)
	{
            parentRect = parent->GetRect();
            windowRect.y -= parentRect.y;
	}
      return ( windowRect.y );
#endif
}
int   CxTextOut::GetLeft()
{
#ifdef __WINDOWS__
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
#ifdef __LINUX__
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
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxTextOut::GetHeight()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


void CxTextOut::Focus()
{
	SetFocus();
}

#ifdef __WINDOWS__
BEGIN_MESSAGE_MAP(CxTextOut, CWnd)
	ON_WM_CHAR()
	ON_WM_PAINT()
	ON_WM_ERASEBKGND()
	ON_WM_VSCROLL()
	ON_WM_SIZE()
	ON_WM_HSCROLL()
	ON_WM_SETCURSOR()
	ON_WM_LBUTTONUP()
	ON_WM_RBUTTONDOWN()
        ON_WM_MOUSEMOVE()
END_MESSAGE_MAP()
#endif
#ifdef __LINUX__
//wx Message Table
BEGIN_EVENT_TABLE(CxTextOut, wxTextCtrl)
      EVT_CHAR( CxTextOut::OnChar )
END_EVENT_TABLE()
#endif

#ifdef __WINDOWS__
void CxTextOut::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	NOTUSED(nRepCnt);
	NOTUSED(nFlags);
	switch(nChar)
	{
		case 9:     //TAB. Shift focus back or forwards.
		{
			Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
			if(mWidget->mDisabled)
				mWidget->FocusToInput((char)nChar);
			else
				CWnd::OnChar( nChar, nRepCnt, nFlags );
		}
	}
}
#endif

#ifdef __LINUX__
void CxTextOut::OnChar( wxKeyEvent & event )
{
      switch(event.KeyCode())
	{
		case 9:     //TAB. Shift focus back or forwards.
		{
                  Boolean shifted = event.m_shiftDown;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
			if(mWidget->mDisabled)
                        mWidget->FocusToInput((char)event.KeyCode());
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

void CxTextOut::AddLine( CString& strLine )
{
	// Add to the buffer, cutting off the first ( top ) line if
	// necessary.


	m_Lines.Add( strLine );
	if( GetLineCount() > m_nMaxLines )
	{
		m_Lines.RemoveAt( 0 );
		m_nHead--;
	};

        // Automatically jump to the
	// bottom...

        m_nHead = max(GetLineCount(),GetMaxViewableLines());

	// Update the vertical scroll bar:

	UpdateVScroll();

        SetHead( m_nHead );
};



void CxTextOut::SetFont( LOGFONT& rFont )
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
		UpdateHScroll();	// Page size depends on average char width
		Invalidate();
	};
};

void CxTextOut::SetBackColour( COLORREF col )
{
	m_BackCol = col;


	// Force a repaint if we are displayed.


	if( GetSafeHwnd() )
		Invalidate();
};



void CxTextOut::SetHead( int nPos )
{
	if( nPos < -1 ) nPos = -1;
        if( nPos > GetLineCount() - 1 ) nPos = max( GetLineCount() - 1, GetMaxViewableLines() -1 );
	m_nHead = nPos;
	if( GetSafeHwnd() )
	{
		SetScrollPos( SB_VERT, m_nHead );
		Invalidate();
	};
};

void CxTextOut::OnPaint() 
{
	CPaintDC dc( this );
	CRect clientRc; GetClientRect( &clientRc );

	// Initialize the draw:

	UINT nMaxLines = GetMaxViewableLines();					// Max number of lines in view
	m_nLinesDone = 0;										// No Lines drawn

	// Initialize colours and font:
	
	CFont* pOldFont = dc.SelectObject( m_pFont );

	// Now draw the lines, one by one:

	UINT nUBound = m_Lines.GetUpperBound();
	if( m_nHead != -1 )
	{
		int nRunner = m_nHead;
		int nX = clientRc.left - m_nXOffset;
		int nMasterY = clientRc.bottom;
//                if ( nRunner < nMaxLines )
//                {
//                   nRunner = max (nRunner,GetLineCount()-1);
//                   nMasterY -= ( m_nFontHeight * ( nMaxLines - nRunner ) );
//                   dc.FillSolidRect( CRect(clientRc.left,nMasterY,clientRc.right,clientRc.bottom), m_BackCol );
//                }
                int nPos = -1;
		CString strTemp;
		do
		{
			dc.SetBkColor( m_BackCol );
			dc.SetTextColor( m_ColTable[ m_nDefTextCol ] );

                        if ( nRunner >= GetLineCount()  )
                        {
                           dc.FillSolidRect( CRect(clientRc.left,nMasterY,clientRc.right,nMasterY+m_nFontHeight), m_BackCol );
                        }
                        else
                        {
                           strTemp = m_Lines[ nRunner ];
                        }
                        nMasterY -= m_nFontHeight;
                        RenderSingleLine( strTemp, &dc, nX, nMasterY );

			nRunner--;

		}while( nRunner > -1 && nMasterY >= 0 );

		// Pad out any remaining area...

		if( nMasterY >= 0 )
		{
			CRect solidRc = clientRc;
			solidRc.bottom = nMasterY;
			dc.FillSolidRect( &solidRc, m_BackCol );
		};
	}
	else
		dc.FillSolidRect( &clientRc, m_BackCol );

	// Clean up:

	dc.SelectObject( pOldFont );
}


BOOL CxTextOut::OnEraseBkgnd( CDC* pDC ) 
{
	return( TRUE ); //Reduces flickering.
}


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

void CxTextOut::OnHScroll( UINT nSBCode, 
						    UINT nPos, 
							CScrollBar* pScrollBar ) 
{
	CRect clientRc; GetClientRect( &clientRc );
	UINT nMax = m_nMaxWidth - clientRc.Width();
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

void CxTextOut::OnSize(UINT nType, int cx, int cy) 
{
	CWnd ::OnSize(nType, cx, cy);
	if( GetSafeHwnd() )
	{
		UpdateHScroll();
		UpdateVScroll();
	};
}

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


void CxTextOut::OnMouseMove( UINT nFlags, CPoint wpoint )
{

      CString dummy;
      if ( IsAHit ( dummy, wpoint ) )
      {
          SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR4) );
      }
      else
      {
          SetCursor( AfxGetApp()->LoadStandardCursor( IDC_IBEAM ) );
      }

}

BOOL CxTextOut::IsAHit( CString & commandString, CPoint wpoint )
{
	CRect clientRc; GetClientRect( &clientRc );
        int line = m_nHead - ( ( clientRc.Height() - wpoint.y ) / m_nFontHeight ); 
        
        CString strToRender;
        CString strTemp;
        if ( line < 0 ) line = 0;
        if ( line < GetLineCount() )
        {
            strTemp = m_Lines[ line ];
        }
        int nPos;
        int cx=0, nX=0, nWidth=0, oldnX=0;

        m_bInLink = false; //Beginning new line.
        BOOL wasInLink = false;
        CString oldText;

	do
	{
		nPos = strTemp.Find( CONTROL_BYTE );
		if( nPos > -1 )
		{
			strToRender = strTemp.Left( nPos );
                        oldText = strToRender;
                        if( strToRender != "" )
			{
                                cx = strToRender.GetLength() * m_nAvgCharWidth;
                                nX += cx;
                                nWidth += cx;
			};
			COLOURCODE code;
			strTemp = strTemp.Mid( nPos );
			GetColourCodes( strTemp, &code );
		}
		else
		{
                        oldText = strTemp;
                        cx = strTemp.GetLength() * m_nAvgCharWidth;
                        nWidth += cx;
                        nX += cx;
                        break;
		}

                if (( wpoint.x < nX ) && ( wpoint.x > oldnX )) break;
                oldnX = nX;
                wasInLink = m_bInLink;

	}while( 1 );

        commandString = oldText;

        return (wasInLink);
 
}


void CxTextOut::OnLButtonUp( UINT nFlags, CPoint point )
{
	// *** Put code for notifying owner about button up ***
        CString temp;
        if ( IsAHit ( temp, point ) )
        {
          TEXTOUT ( CcString ( "The link is: " + temp ) );
          ((CrTextOut*)mWidget)->ProcessLink( CcString ( temp ) );
        }
	CWnd::OnLButtonUp( nFlags, point );
}


void CxTextOut::OnRButtonDown( UINT nFlags, CPoint point ) 
{
	// *** Put code for notifying owner about Rbutton down ***
	CWnd::OnRButtonDown( nFlags, point );
}

UINT CxTextOut::GetMaxViewableLines()
{
	ASSERT( GetSafeHwnd() != NULL );	// Must have been created
	CRect clientRc; GetClientRect( &clientRc );
	return( clientRc.Height() / m_nFontHeight );
};


void CxTextOut::UpdateHScroll()
{
	CRect clientRc; GetClientRect( &clientRc );
        int nMax = m_nMaxWidth - clientRc.Width();
	if( nMax <= 0 )
		m_nXOffset = 0;
	SetScrollRange( SB_HORZ, 0, nMax );
};


void CxTextOut::UpdateVScroll()
{
        SetScrollRange( SB_VERT, GetMaxViewableLines()-1, max(GetMaxViewableLines()-1,GetLineCount()-1));
};

	
void CxTextOut::RenderSingleLine( CString& strLine,
								   CDC* pDC,
								   int nX,
								   int nY )
{
	CRect clientRc; GetClientRect( &clientRc );
	CString strTemp = strLine;
	CString strToRender;
	SIZE sz;
	int nPos;
	UINT nWidth = 0;
        BOOL bUnderline = false;
        m_bInLink = false; //Beginning new line.

	do
	{
		nPos = strTemp.Find( CONTROL_BYTE );
		if( nPos > -1 )
		{
			strToRender = strTemp.Left( nPos );
			if( strToRender != "" )
			{
				if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
					::GetTextExtentPoint32( pDC->GetSafeHdc(), strToRender, strToRender.GetLength(), &sz );
				else
					sz.cx = strToRender.GetLength() * m_nAvgCharWidth;

				pDC->TextOut( nX, nY, strToRender );
                                if (bUnderline)
                                {
                                    pDC->MoveTo(nX,nY+m_nFontHeight);
                                    pDC->LineTo(nX+sz.cx,nY+m_nFontHeight);
                                }
                                nX += sz.cx;
				nWidth += sz.cx;
			};
			COLOURCODE code;
			strTemp = strTemp.Mid( nPos );
			GetColourCodes( strTemp, &code );
			if( code.nFore != -1 ) pDC->SetTextColor( m_ColTable[ code.nFore ] );
			if( code.nBack != -1 ) pDC->SetBkColor( m_ColTable[ code.nBack ] );
                        bUnderline = code.nUnder;
		}
		else
		{
			if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
				::GetTextExtentPoint32( pDC->GetSafeHdc(), strTemp, strTemp.GetLength(), &sz );
			else
				sz.cx = strTemp.GetLength() * m_nAvgCharWidth;
			nWidth += sz.cx;
			pDC->TextOut( nX, nY, strTemp );
			nX += sz.cx;


			// Pad out rest of line with solid colour:


			CRect solidRc( nX, nY, clientRc.right, nY + m_nFontHeight );
			pDC->FillSolidRect( &solidRc, m_BackCol );
			break;
		}
	}while( 1 );

	nY += m_nFontHeight;


	// -------------------------------------------------------------
	// Update Horizontal scroll bar for width ( for times when the
	// word wrap is OFF )
	// -------------------------------------------------------------


        if( nWidth > m_nMaxWidth )
	{
		m_nMaxWidth = nWidth;
		UpdateHScroll();
	};
};


int CxTextOut::GetLineInfo( CString& strLine,
							 CDC* pDC,
							 int nRight )
{
	int nLines = 1;				// Start of with 1 line


	// ---------------------------------------------------------
	// We can very quickly handle empty lines:
	// ---------------------------------------------------------


	if( strLine == "" )
		return( nLines );		// See, I told u it was easy.


	// And lets do the rest properly:


	int nLen = strLine.GetLength();
	int nOriginalLength = nLen;
	char* pTmp = new char[ nOriginalLength + 1 ];
	char ch = 0;
	SIZE sz;
	memset( pTmp, 0, nOriginalLength );
	int nCurrWidth = 0;			// Width of current line
	int nPosInTemp = 0;			// Current Position in temp buffer
	int nPosInString = 0;		// Current Position in string
	int nSpc = 0;
	HDC hDC = pDC->GetSafeHdc();// Handle to the device context
	CString strLeftPart;		// Left Part
	CString strRightPart;		// Right Part
	int nLastWrap = -1;			// Where we put the last wrap point
	COLOURCODE code;
	do
	{
		ch = strLine[ nPosInString ];
                if( ch != '{' )
		{
			pTmp[ nPosInTemp ] = ch;
			if( !FLAG( m_lfFont.lfPitchAndFamily, FIXED_PITCH ) )
				::GetTextExtentPoint32( hDC, pTmp, nPosInTemp + 1, &sz );
			else
				sz.cx = ( nPosInTemp + 1 ) * m_nAvgCharWidth;

			if( sz.cx >= nRight )
			{
				// Find the previous space


				for( int nSpc = nPosInString - 1; nSpc >= 0; nSpc -- )
					if( strLine[ nSpc ] == ' ' ) break;

				if( nSpc == 0 )
					nSpc = nPosInString;

				if( nSpc > nLastWrap )
				{
					strLeftPart = strLine.Left( nSpc );
					strRightPart = strLine.Mid( nSpc + 1 );
					strLine = strLine.Left( nSpc );
					nLastWrap = nSpc;
					strLine += WRAP_BYTE;
					strLine += strRightPart;
					nPosInString = nSpc + 1;
					nLen = strLine.GetLength();
					nLines++;		// And another line
				};

				memset( pTmp, 0, nOriginalLength );
				nPosInTemp = 0;
			}
			else
			{
				nPosInTemp++;
				nPosInString++;
			};
		}
		else
		{
			CString strTemp = strLine.Mid( nPosInString );	// Make temp copy. dont want to modify original
			nPosInString += GetColourCodes( strTemp, &code );// skips correct number of bytes
		};

	}while( nPosInString < nLen );
	delete [] pTmp;
	return( nLines );
};

int CxTextOut::GetColourCodes( CString& strData, 
							    COLOURCODE* pColourCode )
{
	ASSERT( pColourCode != NULL );
	ASSERT( strData.Left( 1 ) == CONTROL_BYTE );
	strData = strData.Mid( 1 );	// Truncate control byte
	int nBytesToSkip = 1;
        pColourCode->nUnder = false;


        // Jump out if strData is now empty...


	if( strData == "" )
	{
		pColourCode->nFore = -1;	// No foreground colour
		pColourCode->nBack = -1;	// No background colour
                m_bInLink = false;
	}
        else if ( strData.Find( LINK_BYTE ) == 0 ) 
        {
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

                nBytesToSkip = 2;
                strData = strData.Mid( 1 );
                
        }
	else
	{

                m_bInLink = false;
		// Now handle foreground and background colours:


		int nComma = strData.Find( "," );		// Position of comma.  Only present if background colour present
		if( ( nComma != -1 ) &&
			( ( nComma == 1 ) ||
			  ( nComma == 2 && isdigit( strData[ 1 ] ) ) 
			)
		  )
		{
			CString strFore = strData.Left( nComma );
			nBytesToSkip += strFore.GetLength() + 1;	// Includes code and comma
			pColourCode->nFore = atoi( strFore );		// Get Code
			strData = strData.Mid( nComma + 1 );		// Truncate string


			// Now look for backcolour:


			CString strBack;
			int nCodeLength = 1;
			if( strData.GetLength() >= 2 )
			{
				if( isdigit( strData[ 1 ] ) )
					nCodeLength++;
			};

			nBytesToSkip+= nCodeLength;
			strBack = strData.Left( nCodeLength );
			strData = strData.Mid( nCodeLength );
			pColourCode->nBack = atoi( strBack );
		}
		else
		{
			// No background colour present, the delimiter for this code
			// is the next non-numeric character...


			CString strFore;
			int nCodeLength = 1;
			if( strData.GetLength() >= 2 )
			{
				if( isdigit( strData[ 1 ] ) )
					nCodeLength++;
			};

			nBytesToSkip += nCodeLength;
			strFore = strData.Left( nCodeLength );
			strData = strData.Mid( nCodeLength );
			pColourCode->nFore = atoi( strFore );
			pColourCode->nBack = -1;
		};
	};


	// Return number of bytes processed:


	return( nBytesToSkip );
};



void CxTextOut::ChooseFont()
{
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
#endif	// !_WINNT
           CFont* pFont = CFont::FromHandle( hSysFont );
           pFont->GetLogFont( &lf );
        }

        CFontDialog fd(&lf,CF_FIXEDPITCHONLY|CF_SCREENFONTS);

        if ( fd.DoModal() == IDOK )
        {
            SetFont( lf );

           (CcController::theController)->StoreKey( "FontHeight", CcString(lf.lfHeight) );
           (CcController::theController)->StoreKey( "FontWidth", CcString(lf.lfWidth) );
           (CcController::theController)->StoreKey( "FontFace", CcString(lf.lfFaceName) );

        }


}
