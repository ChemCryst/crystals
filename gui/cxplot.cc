////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CxPlot.cc
//   Authors:   Steven Humphreys and Richard Cooper
//   Created:   09.11.2001 22:48
//
//   $Log: not supported by cvs2svn $
//   Revision 1.4  2001/11/22 15:33:21  ckpgroup
//   SH: Added different draw-styles (line / area / bar / scatter).
//   Changed graph layout. Changed second series to blue for better contrast.
//
//   Revision 1.3  2001/11/19 16:32:21  ckpgroup
//   SH: General update, bug-fixes, better text alignment. Removed a lot of duplicate code.
//
//   Revision 1.2  2001/11/12 16:24:31  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:51  ckp2
//   The PLOT classes!
//

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cxplot.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "cxwindow.h"
#include    "crplot.h"
#include    "ccpoint.h"
#include    "ccrect.h"
#include	<math.h>

#ifdef __CR_WIN__
 #include    <afxwin.h>
#endif
#ifdef __BOTHWX__
 #include <wx/font.h>
 #include <wx/thread.h>
#endif

int CxPlot::mPlotCount = kPlotBase;

CxPlot *   CxPlot::CreateCxPlot( CrPlot * container, CxGrid * guiParent )
{
#ifdef __CR_WIN__
    const char* wndClass = AfxRegisterWndClass(
                                    CS_HREDRAW|CS_VREDRAW,
                                    NULL,
                                    (HBRUSH)(COLOR_MENU+1),
                                    NULL
                                    );

    CxPlot *theStdPlot = new CxPlot(container);
    theStdPlot->Create(wndClass,"Plot",WS_CHILD| WS_VISIBLE, CRect(0,0,26,28), guiParent, mPlotCount++);
    theStdPlot->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
    theStdPlot->SetFont(CcController::mp_font);

    CClientDC   dc(theStdPlot);
    theStdPlot->m_memDC->CreateCompatibleDC(&dc);
    theStdPlot->m_newMemDCBitmap = new CBitmap;
    CRect rect;
    theStdPlot->GetClientRect (&rect);
    theStdPlot->m_newMemDCBitmap->CreateCompatibleBitmap(&dc,rect.Width(),rect.Height());
    theStdPlot->m_oldMemDCBitmap = theStdPlot->m_memDC->SelectObject(theStdPlot->m_newMemDCBitmap);
    theStdPlot->m_memDC->PatBlt(0,0,rect.Width(),rect.Height(),WHITENESS);
    theStdPlot->m_memDC->SelectObject(theStdPlot->m_oldMemDCBitmap);
#endif
#ifdef __BOTHWX__
    CxPlot  *theStdPlot = new CxPlot(container);
    theStdPlot->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10));
    theStdPlot->m_newMemDCBitmap = new wxBitmap(10,10);
    theStdPlot->m_memDC->SelectObject(*(theStdPlot->m_newMemDCBitmap));
    theStdPlot->m_memDC->SetBrush( *wxWHITE_BRUSH );
    theStdPlot->m_memDC->Clear();
#endif
    return theStdPlot;
}

CxPlot::CxPlot(CrPlot* container)
#ifdef __CR_WIN__
    :CWnd()
#endif
#ifdef __BOTHWX__
    :wxControl()
#endif
{
	m_TextPopup = 0;
    ptr_to_crObject = container;
#ifdef __CR_WIN__
    mfgcolour = PALETTERGB(0,0,0);
    m_memDC = new CDC();
#endif
#ifdef __BOTHWX__
    mfgcolour = wxColour(0,0,0);
    m_pen = new wxPen(mfgcolour,1,wxSOLID);
    m_brush = new wxBrush(mfgcolour,wxSOLID);
    m_memDC = new wxMemoryDC();
#endif
}

CxPlot::~CxPlot()
{
	DeletePopup();
	mPlotCount--;
    delete m_newMemDCBitmap;
#ifdef __CR_WIN__
    delete m_memDC;
#endif
#ifdef __BOTHWX__
    delete m_memDC;
    delete m_pen;
    delete m_brush;
#endif
}

void CxPlot::CxDestroyWindow()
{
#ifdef __CR_WIN__
  DestroyWindow();
#endif
#ifdef __BOTHWX__
  Destroy();
#endif
}

void CxPlot::SetText( char * text )
{

#ifdef __BOTHWX__
      SetLabel(text);
#endif
#ifdef __CR_WIN__
    SetWindowText(text);
#endif

}


CcPoint CxPlot::DeviceToLogical(int x, int y)
{
     CcPoint      newpoint;

#ifdef __CR_WIN__
     CRect       wwindowext;
     GetClientRect(&wwindowext);
     CcRect       windowext( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __BOTHWX__
     wxRect wwindowext = GetRect();
     CcRect windowext( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif

     newpoint.x = (int)((windowext.mRight * x)/2400);
     newpoint.y = (windowext.mBottom * y)/2400;

     return newpoint;
}

CcPoint CxPlot::LogicalToDevice(int x, int y)
{
	CcPoint newpoint;

#ifdef __CR_WIN__
	CRect		wwindowext;
	GetClientRect(&wwindowext);
	CcRect		windowext(wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __BOTHWX__
	wxRect wwindowext = GetRect();
	CcRect windowext(wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif

	newpoint.x = (int)(2400*x / windowext.mRight);
	newpoint.y = (int)(2400*y / windowext.mBottom);
	return newpoint;
}

void CxPlot::Display()
{
#ifdef __CR_WIN__
      InvalidateRect(NULL,false);
#endif
#ifdef __BOTHWX__
      Refresh();
#endif
}

#ifdef __CR_WIN__
void CxPlot::OnPaint()
{
    CPaintDC dc(this); // device context for painting
    CRect rect;
    GetClientRect (&rect);
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    dc.BitBlt(0,0,rect.Width(),rect.Height(),m_memDC,0,0,SRCCOPY);
    m_memDC->SelectObject(m_oldMemDCBitmap);
}
#endif

#ifdef __BOTHWX__
void CxPlot::OnPaint(wxPaintEvent & event)
{
      wxPaintDC dc(this); // device context for painting
      wxRect rect = GetRect();
      dc.Blit( 0,0,rect.GetWidth(),rect.GetHeight(),m_memDC,0,0,wxCOPY,false);

}
#endif


void CxPlot::Clear()
{
#ifdef __CR_WIN__
    CRect rect;
    GetClientRect (&rect);
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    m_memDC->PatBlt(0, 0, rect.Width(), rect.Height(), WHITENESS);
    m_memDC->SelectObject(m_oldMemDCBitmap);
#endif
#ifdef __BOTHWX__
      m_memDC->SetBrush( *wxWHITE_BRUSH );
      m_memDC->Clear();
#endif
}

// STEVE added this function
void CxPlot::SetColour(int r, int g, int b)
{
#ifdef __CR_WIN__
    mfgcolour = PALETTERGB(r,g,b);
#endif
#ifdef __BOTHWX__
    mfgcolour = wxColour(r,g,b);
#endif
}

// STEVE added a line thickness parameter
void CxPlot::DrawLine(int thickness, int x1, int y1, int x2, int y2)
{
    CcPoint cpoint1, cpoint2;
    cpoint1 = DeviceToLogical(x1,y1);
    cpoint2 = DeviceToLogical(x2,y2);

#ifdef __CR_WIN__
    CPen pen(PS_SOLID,thickness,mfgcolour), *oldpen;		// changed 1 to thickness
    oldpen = m_memDC->SelectObject(&pen);
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);

    m_memDC->MoveTo(CPoint(cpoint1.x,cpoint1.y));
    m_memDC->LineTo(CPoint(cpoint2.x,cpoint2.y));
    m_memDC->SelectObject(m_oldMemDCBitmap);
    m_memDC->SelectObject(oldpen);
	pen.DeleteObject();										// added by steve - clean up resources
#endif
#ifdef __BOTHWX__
    m_memDC->SetPen( *m_pen );
    m_memDC->DrawLine(cpoint1.x,cpoint1.y,cpoint2.x,cpoint2.y);
#endif

}

void CxPlot::DrawEllipse(int x, int y, int w, int h, Boolean fill)
{
    //NB w and h are half diameters. (i.e. radii).

    int x1 = x - w;
    int y1 = y - h;
    int x2 = x + w;
    int y2 = y + h;

    CcPoint topleft = DeviceToLogical(x1,y1);
    CcPoint bottomright = DeviceToLogical(x2,y2);

#ifdef __CR_WIN__
    CRgn        rgn;
    CBrush      brush, *oldbrush;
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    rgn.CreateEllipticRgn(topleft.x,topleft.y,bottomright.x,bottomright.y);
    brush.CreateSolidBrush(mfgcolour);
	oldbrush = (CBrush*)m_memDC->SelectObject(brush);
    if(fill)
        m_memDC->FillRgn(&rgn,&brush);
    else
        m_memDC->FrameRgn(&rgn,&brush,1,1);
    m_memDC->SelectObject(m_oldMemDCBitmap);
	m_memDC->SelectObject(oldbrush);
	brush.DeleteObject();			
#endif
#ifdef __BOTHWX__
      m_memDC->SetPen( *m_pen );
      if ( fill )
            m_memDC->SetBrush( *m_brush );
      else
            m_memDC->SetBrush( *wxTRANSPARENT_BRUSH );
      m_memDC->DrawEllipse(topleft.x,topleft.y,bottomright.x-topleft.x,bottomright.y-topleft.y);
      m_memDC->SetBrush( wxNullBrush );
#endif
}

// STEVE added the fourth parameter, to allow for justification of text
// param can be:	TEXT_VCENTRE	y is the coordinate of the CENTRE of the text
//					TEXT_HCENTRE	x is the centre coordinate
//					TEXT_RIGHT		y is the right hand side (RH justified)
//					TEXT_TOP		x is the top of the text
//					TEXT_BOTTOM		x is the bottom of the text
//					TEXT_VERTICAL   string is written one character above the next (for y axis label)
//					TEXT_BOLD		text drawn in black (else grey)
//					TEXT_ANGLE		text is drawn at an angle (for crowded axes...)
//	All coordinates in the range 0 - 2400
void CxPlot::DrawText(int x, int y, CcString text, int param, int fontsize)
{
	CcPoint      coord = DeviceToLogical(x,y);

#ifdef __CR_WIN__
   CPen        pen(PS_SOLID,1,mfgcolour);
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    CPen        *oldpen = m_memDC->SelectObject(&pen);

    CFont  theFont;
	CFont* oldFont;
	int thickness = 400;

    char face[32] = "Times New Roman";

	if(param & TEXT_BOLD) thickness = 600;

	if(param & TEXT_ANGLE)
	{
		theFont.CreateFont(fontsize, 0, 450, 450, thickness, false, false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS,CLIP_LH_ANGLES, PROOF_QUALITY, DEFAULT_PITCH, face);
		oldFont = m_memDC->SelectObject(&theFont);
		CSize temp = m_memDC->GetTextExtent(text.ToCString(), text.Len());
		CSize move;

		move.cx = temp.cx/sqrt(2);			// must calculate effect of rotation manually. 45 deg -> 1/sqrt(2)
		move.cy = temp.cx/sqrt(2);			//		for both sin and cos.

		coord.x -= move.cx + temp.cy/2;
		coord.y += move.cy + temp.cy/2; 
	}
	else
	{
		if(param & TEXT_VERTICAL)
		{
			theFont.CreateFont(fontsize, 0, 900,900, thickness, false, false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS,CLIP_LH_ANGLES, PROOF_QUALITY, DEFAULT_PITCH, face);
			oldFont = m_memDC->SelectObject(&theFont);
			int len = text.Len();
			CSize temp = m_memDC->GetTextExtent(text.ToCString(), len);
			coord.y = coord.y + temp.cx/2;		// nb swapping of cx and cy - GetTextEntent doesn't handle rotations
		//	coord.x = coord.x + temp.cy;		//		90 degree so swap axes.
		}
		else
		{
			theFont.CreateFont(fontsize, 0, 0,0, thickness, false, false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS,CLIP_LH_ANGLES, PROOF_QUALITY, DEFAULT_PITCH, face);
			oldFont = m_memDC->SelectObject(&theFont);
		}
	}

    CSize size = m_memDC->GetTextExtent(text.ToCString(), strlen(text.ToCString()));

	if(param & TEXT_VCENTRE)
	{
		  coord.y -= size.cy/2;                                                   // centre the text
	}
	if(param & TEXT_HCENTRE)
	{
		  coord.x -= size.cx/2;    
	}
	if(param & TEXT_RIGHT)
	{ 
			coord.x -= size.cx;
	}
	if(param & TEXT_TOP)
	{
			coord.y += size.cy/2;
	}
	if(param & TEXT_BOTTOM)
	{
		coord.y -= size.cy/2;
	}

	m_memDC->SetBkMode(TRANSPARENT);
	m_memDC->TextOut(coord.x,coord.y,text.ToCString());

    m_memDC->SelectObject(oldpen);
	pen.DeleteObject();
    m_memDC->SelectObject(oldFont);
	theFont.DeleteObject();
    m_memDC->SelectObject(m_oldMemDCBitmap);

#endif
#ifdef __BOTHWX__
      wxString wtext = wxString(text.ToCString());
      m_memDC->SetBrush( *m_brush );
      m_memDC->SetPen( *m_pen );
      m_memDC->SetBackgroundMode( wxTRANSPARENT );
      m_memDC->DrawText(wtext, coord.x, coord.y );
      m_memDC->SetBrush( wxNullBrush );
#endif
}

// get the size of a text string on screen
// NB param is same as above - only TEXT_ANGLE, TEXT_VERTICAL currently dealt with / needed
CcPoint CxPlot::GetTextArea(int fontsize, CcString text, int param)
{
	CcPoint tsize;
	CSize size;
	CFont theFont;
	CFont* oldFont;
    char face[32] = "Times New Roman";

	if(param & TEXT_ANGLE)
	{
		theFont.CreateFont(fontsize,0,450,450, 400,false,false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_LH_ANGLES,	PROOF_QUALITY, DEFAULT_PITCH, face);
		oldFont = m_memDC->SelectObject(&theFont);

		size = m_memDC->GetOutputTextExtent(text.ToCString(), text.Len());

		tsize.x = size.cx/sqrt(2);
		tsize.y = size.cx/sqrt(2);
	}
	else if(param & TEXT_VERTICAL)
	{
		theFont.CreateFont(fontsize,0,900,900, 400,false,false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_LH_ANGLES,	PROOF_QUALITY, DEFAULT_PITCH, face);
		oldFont = m_memDC->SelectObject(&theFont);

		size = m_memDC->GetOutputTextExtent(text.ToCString(), text.Len());
		tsize.x = size.cy;			// swap axes cos of the 90 degree rotation
		tsize.y = size.cx;
	}
	else
	{
		theFont.CreateFont(fontsize,0,0,0, 400,false,false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_LH_ANGLES,	PROOF_QUALITY, DEFAULT_PITCH, face);
		oldFont = m_memDC->SelectObject(&theFont);

		size = m_memDC->GetOutputTextExtent(text.ToCString(), text.Len());
		tsize.x = size.cx;
		tsize.y = size.cy;
	}

	m_memDC->SelectObject(oldFont);
	theFont.DeleteObject();

	return (LogicalToDevice(tsize.x, tsize.y));
}

int CxPlot::GetMaxFontSize(int width, int height, CcString text, int param)
{
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    CFont  theFont;
    char face[32] = "Times New Roman";
    CcPoint coord = DeviceToLogical(width,height);
    CSize size;

    int fontsize = 14; //our maximum possible fontsize...

	if(param & TEXT_ANGLE)
	{
		while (fontsize > 40)
		{
	//		theFont.CreatePointFont(fontsize, face, m_memDC);
			theFont.CreateFont(fontsize, 0, 450, 450, 400, false, false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS,CLIP_LH_ANGLES, PROOF_QUALITY, DEFAULT_PITCH, face);
			CFont* oldFont = m_memDC->SelectObject(&theFont);

			size = m_memDC->GetOutputTextExtent(text.ToCString(), text.Len());

			size.cx = size.cx/sqrt(2);//cos(size.cx*3.1415/180);
			size.cy = size.cx/sqrt(2);//sin(size.cy*3.1415/180);

			if ((size.cy < coord.y ))//&&(size.cx < coord.x))
			{
				m_memDC->SelectObject(oldFont);
				theFont.DeleteObject(); //Free memory associated with font.
				break;
			}
			else
			{
				//Reduce the logfont height, put the oldfont back into the DC and repeat.
				fontsize -= 1;
				m_memDC->SelectObject(oldFont); //Our CFont goes out of scope, and is deleted automatically
				theFont.DeleteObject(); //Free memory associated with font.
			}
		}
	
	}
	else
	{
		if(param & TEXT_VERTICAL)
		{
			while (fontsize > 4)
			{
		//		theFont.CreatePointFont(fontsize, face, m_memDC);
				theFont.CreateFont(fontsize, 0, 900, 900, 400, false, false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS,CLIP_LH_ANGLES, PROOF_QUALITY, DEFAULT_PITCH, face);
				CFont* oldFont = m_memDC->SelectObject(&theFont);

				size = m_memDC->GetOutputTextExtent(text.ToCString(), text.Len());

				if (size.cy < coord.y)		// only worried about vertical dimension here
				{
					m_memDC->SelectObject(oldFont);
					theFont.DeleteObject(); //Free memory associated with font.
					break;
				}
				else
				{
					//Reduce the logfont height, put the oldfont back into the DC and repeat.
					fontsize -= 1;
					m_memDC->SelectObject(oldFont); //Our CFont goes out of scope, and is deleted automatically
					theFont.DeleteObject(); //Free memory associated with font.
				}
			}
		}
		else
		{
			while (fontsize > 4)
			{
		//		theFont.CreatePointFont(fontsize, face, m_memDC);
				theFont.CreateFont(fontsize, 0, 0, 0, 400, false, false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS,CLIP_LH_ANGLES, PROOF_QUALITY, DEFAULT_PITCH, face);
		//		theFont.CreateFont(fontsize, 0, 450, 450, 400, false, false,false, ANSI_CHARSET, OUT_DEFAULT_PRECIS,CLIP_LH_ANGLES, PROOF_QUALITY, DEFAULT_PITCH, face);
				CFont* oldFont = m_memDC->SelectObject(&theFont);

				size = m_memDC->GetOutputTextExtent(text.ToCString(), text.Len());

				if ((size.cx < coord.x )) //&&(size.cy < coord.y))	// only need worry about horizontal
				{
					m_memDC->SelectObject(oldFont);
					theFont.DeleteObject(); //Free memory associated with font.
					break;
				}
				else
				{
					//Reduce the logfont height, put the oldfont back into the DC and repeat.
					fontsize -= 1;
					m_memDC->SelectObject(oldFont); //Our CFont goes out of scope, and is deleted automatically
					theFont.DeleteObject(); //Free memory associated with font.
				}
			}
		}
	}
    m_memDC->SelectObject(m_oldMemDCBitmap);

    return fontsize;
}

void CxPlot::DrawPoly(int nVertices, int * vertices, Boolean fill)
{
#ifdef __CR_WIN__
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    if(fill)
    {
        CBrush      brush;
        brush.CreateSolidBrush(mfgcolour);
        CPen   pen(PS_SOLID,1,mfgcolour);

        CBrush *oldBrush = m_memDC->SelectObject(&brush);
        CPen   *oldpen = m_memDC->SelectObject(&pen);

        CcPoint*           points = new CcPoint[nVertices];
        for ( int j = 0; j < nVertices*2 ; j+=2 )
        {
            points[j/2] = DeviceToLogical( *(vertices+j), *(vertices+j+1) );
        }
        m_memDC->Polygon( (LPPOINT) points, nVertices );
        m_memDC->SelectObject(oldBrush);
		brush.DeleteObject();
        m_memDC->SelectObject(oldpen);
		pen.DeleteObject();
        delete [] points;
    }
    else
    {
//NB: If the polygon isn't filled, then it shouldn't closed.
        CPen   pen(PS_SOLID,1,mfgcolour);
        CPen   *oldpen = m_memDC->SelectObject(&pen);
        CBrush *oldBrush = (CBrush*)m_memDC->SelectStockObject(NULL_BRUSH);

        CcPoint*           points = new CcPoint[nVertices];
        for ( int j = 0; j < nVertices*2 ; j+=2 )
        {
            points[j/2] = DeviceToLogical( *(vertices+j), *(vertices+j+1) );
        }

        m_memDC->Polyline( (LPPOINT) points, nVertices );

        m_memDC->SelectObject(oldBrush);
        m_memDC->SelectObject(oldpen);
		pen.DeleteObject();
        delete [] points;
    }

    m_memDC->SelectObject(m_oldMemDCBitmap);
#endif
#ifdef __BOTHWX__
    m_memDC->SetPen( *m_pen );
    if ( fill )
         m_memDC->SetBrush( *m_brush );
    else
         m_memDC->SetBrush( *wxTRANSPARENT_BRUSH );

    CcPoint*           points = new CcPoint[nVertices];
    for ( int j = 0; j < nVertices*2 ; j+=2 )
    {
        points[j/2] = DeviceToLogical( *(vertices+j), *(vertices+j+1) );
    }
    m_memDC->DrawPolygon(nVertices, (wxPoint*) points );
    delete [] points;
    m_memDC->SetBrush( wxNullBrush );
#endif

}


CXONCHAR(CxPlot)

void CxPlot::SetIdealHeight(int nCharsHigh)
{
#ifdef __CR_WIN__
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    mIdealHeight = nCharsHigh * textMetric.tmHeight;
#endif
#ifdef __BOTHWX__
    mIdealHeight = nCharsHigh * GetCharHeight();
#endif
}

void CxPlot::SetIdealWidth(int nCharsWide)
{
#ifdef __CR_WIN__
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;
#endif
#ifdef __BOTHWX__
    mIdealWidth = nCharsWide * GetCharWidth();
#endif
}

void    CxPlot::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
  MoveWindow(left,top,right-left,bottom-top,true);
  if(m_memDC)
  {
     delete m_newMemDCBitmap;
     CClientDC   dc(this);
     m_newMemDCBitmap = new CBitmap;
     m_newMemDCBitmap->CreateCompatibleBitmap(&dc, right-left, bottom-top);
     m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
     m_memDC->PatBlt(0, 0, right-left, bottom-top, WHITENESS);
     m_memDC->SelectObject(m_oldMemDCBitmap);
  }
  ((CrPlot*)ptr_to_crObject)->ReDrawView();
#endif
#ifdef __BOTHWX__

      wxClientDC   dc(this);
      
      m_memDC->SelectObject(wxNullBitmap);

      delete m_newMemDCBitmap;
      delete m_memDC;

      m_memDC = new wxMemoryDC();
      m_newMemDCBitmap = new wxBitmap(right-left, bottom-top);
      m_memDC->SelectObject(*m_newMemDCBitmap);

      m_memDC->SetBrush( *wxWHITE_BRUSH );
      m_memDC->SetPen( *wxBLACK_PEN );
      m_memDC->Clear();

      SetSize(left,top,right-left,bottom-top);

      ((CrPlot*)ptr_to_crObject)->ReDrawView();
#endif

}


CXGETGEOMETRIES(CxPlot)


int CxPlot::GetIdealWidth()
{
    return mIdealWidth;
}
int CxPlot::GetIdealHeight()
{
    return mIdealHeight;
}

#ifdef __CR_WIN__
//Windows Message Map
BEGIN_MESSAGE_MAP(CxPlot, CWnd)
    ON_WM_CHAR()
    ON_WM_PAINT()
    ON_WM_LBUTTONUP()
    ON_WM_RBUTTONUP()
    ON_WM_MOUSEMOVE()
      ON_WM_KEYDOWN()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Table
BEGIN_EVENT_TABLE(CxPlot, wxControl)
      EVT_CHAR( CxPlot::OnChar )
      EVT_KEY_DOWN( CxPlot::OnKeyDown )
      EVT_PAINT( CxPlot::OnPaint )
      EVT_LEFT_UP( CxPlot::OnLButtonUp )
      EVT_RIGHT_UP( CxPlot::OnRButtonUp )
      EVT_MOTION( CxPlot::OnMouseMove )
END_EVENT_TABLE()
#endif


void CxPlot::Focus()
{
    SetFocus();
}

// the mouse-movement code
#ifdef __CR_WIN__
// windows stuff goes here
void CxPlot::OnMouseMove( UINT nFlags, CPoint wpoint )
{
 // bool leftDown = ( (nFlags & MK_LBUTTON) != 0 );
 // bool ctrlDown = ( (nFlags & MK_CONTROL) != 0 );
  CcPoint point = LogicalToDevice(wpoint.x,wpoint.y);

#endif

#ifdef __BOTHWX__
// and now the Linux version
void CxPlot::OnMouseMove( wxMouseEvent & event )
{
  CcPoint point = LogicalToDevice( event.m_x, event.m_y );
 // int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
 // nFlags = event.m_shiftDown ? MK_SHIFT : 0 ;
 // bool leftDown = event.m_leftDown;
 // bool ctrlDown = event.m_controlDown;
#endif

// now we have the mouse position, get the details of any bar / scatter point below it...

  CcString text = ((CrPlot*)ptr_to_crObject)->GetDataFromPoint(point);
  point = DeviceToLogical(point.x, point.y);

  if(!(text == "error"))
  {
	  if(moldMPos.x != point.x)
	  {
		  CreatePopup(text, point);
		  moldMPos = point;
	  }
  }
  // if mouse message is not valid, remove the popup (ie catch mouse leaving window...)
  else DeletePopup();
}

// remove the previously created pop-up window
void CxPlot::DeletePopup()
{
  if ( m_TextPopup )
  {
#ifdef __CR_WIN__
    m_TextPopup->DestroyWindow();
    delete m_TextPopup;
#endif
#ifdef __BOTHWX__
    m_TextPopup->Destroy();
    m_DoNotPaint = false;
#endif
    m_TextPopup=nil;
  }
}

// create a pop-up window (contains details of the data-item the mouse is over)
void CxPlot::CreatePopup(CcString text, CcPoint point)
{
#ifdef __BOTHWX__
  m_DoNotPaint = true;
#endif
  if(m_TextPopup) //return;
	 DeletePopup();

#ifdef __CR_WIN__
  CClientDC dc(this);
  CFont* oldFont = dc.SelectObject(CcController::mp_font);
  SIZE size = dc.GetOutputTextExtent(text.ToCString());
  dc.SelectObject(oldFont);

  m_TextPopup = new CStatic();
  m_TextPopup->Create(text.ToCString(), SS_CENTER|WS_BORDER, CRect(CPoint(-size.cx-10,-size.cy-10),CSize(size.cx+4,size.cy+2)), this);
  m_TextPopup->SetFont(CcController::mp_font);
  m_TextPopup->ModifyStyleEx(NULL,WS_EX_TOPMOST,0);
  m_TextPopup->ShowWindow(SW_SHOW);
  m_TextPopup->MoveWindow(max(0,point.x-size.cx-4),max(0,point.y-size.cy-4),size.cx+4,size.cy+2, FALSE);
  m_TextPopup->InvalidateRect(NULL,false);
#endif
#ifdef __BOTHWX__
  int cx,cy;
  GetTextExtent( text.ToCString(), &cx, &cy ); //using cxmodel's DC to work out text extent before creation.
                                                   //then can create in one step.
  m_TextPopup = new mywxStaticText(this, -1, text.ToCString(),
                                 wxPoint(max(0,point.x-cx-4),max(0,point.y-cy-4)),
                                 wxSize(cx+4,cy+4),
                                 wxALIGN_CENTER|wxSIMPLE_BORDER) ;
//  m_TextPopup->SetEvtHandlerEnabled(true);

#endif

}
