////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CxPlot.cc
//   Authors:   Steven Humphreys and Richard Cooper
//   Created:   09.11.2001 22:48
//
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cxplot.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "cxwindow.h"
#include    "crplot.h"
#include    "ccpoint.h"
#include    "ccrect.h"

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

void CxPlot::DrawLine(int x1, int y1, int x2, int y2)
{
    CcPoint cpoint1, cpoint2;
    cpoint1 = DeviceToLogical(x1,y1);
    cpoint2 = DeviceToLogical(x2,y2);

#ifdef __CR_WIN__
    CPen pen(PS_SOLID,1,mfgcolour), *oldpen;
    oldpen = m_memDC->SelectObject(&pen);
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);

    m_memDC->MoveTo(CPoint(cpoint1.x,cpoint1.y));
    m_memDC->LineTo(CPoint(cpoint2.x,cpoint2.y));
    m_memDC->SelectObject(m_oldMemDCBitmap);
    m_memDC->SelectObject(oldpen);
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
    CBrush      brush;
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    rgn.CreateEllipticRgn(topleft.x,topleft.y,bottomright.x,bottomright.y);
    brush.CreateSolidBrush(mfgcolour);
    if(fill)
        m_memDC->FillRgn(&rgn,&brush);
    else
        m_memDC->FrameRgn(&rgn,&brush,1,1);
    m_memDC->SelectObject(m_oldMemDCBitmap);
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

void CxPlot::DrawText(int x, int y, CcString text)
{
    CcPoint      coord = DeviceToLogical(x,y);
#ifdef __CR_WIN__
    CPen        pen(PS_SOLID,1,mfgcolour);
    m_oldMemDCBitmap = m_memDC->SelectObject(m_newMemDCBitmap);
    CPen        *oldpen = m_memDC->SelectObject(&pen);
    CFont       *oldFont = m_memDC->SelectObject(CcController::mp_font);
    m_memDC->SetBkMode(TRANSPARENT);
    m_memDC->TextOut(coord.x,coord.y,text.ToCString());
    m_memDC->SelectObject(oldpen);
    m_memDC->SelectObject(oldFont);
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
        m_memDC->SelectObject(oldpen);
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

