////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CxResizeBar.cc
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "ccpoint.h"

#include    "crconstants.h" //for kSvertical and kShorizontal
#include    "cxresizebar.h"
#include    "cxgrid.h"
#include    "crresizebar.h"
#include    "crgrid.h"

#ifdef __BOTHWX__
#include <ctype.h>
#include <wx/settings.h>
#include <wx/cmndata.h>
#include <wx/fontdlg.h>
#endif

int CxResizeBar::mResizeBarCount = kResizeBarBase;

CxResizeBar * CxResizeBar::CreateCxResizeBar( CrResizeBar * container, CxGrid * guiParent )
{
    CxResizeBar *control = new CxResizeBar (container);
#ifdef __CR_WIN__
    control->Create(NULL, "Resize", WS_VISIBLE| WS_CHILD, CRect(0,0,10,10), guiParent, mResizeBarCount++);
#endif
#ifdef __BOTHWX__
    control->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10), wxVSCROLL|wxHSCROLL|wxSUNKEN_BORDER);
#endif
    return control;
}

CxResizeBar::CxResizeBar( CrResizeBar * container )
: BASERESIZEBAR ()
{
    ptr_to_crObject = container;
    m_oldrec.Set(0,0,0,0);
    m_hotRect.Set(0,0,0,0);
    m_veryHotRect.Set(0,0,0,0);
    m_type = kTVertical;
    m_startDrag = -1;
    m_firstNonSize = false;
    m_secondNonSize = false;
    m_NonSizePresent = false;
    m_BothNonSize = false;
    m_ButtonDrawn = false;
    m_Collapsed = false;
}

CxResizeBar::~CxResizeBar()
{
    RemoveResizeBar();
}

CXSETGEOMETRY(CxResizeBar)

CXGETGEOMETRIES(CxResizeBar)



#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxResizeBar, CWnd)
    ON_WM_LBUTTONDOWN()
    ON_WM_LBUTTONUP()
    ON_WM_MOUSEMOVE()
    ON_WM_PAINT()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Table
BEGIN_EVENT_TABLE(CxResizeBar, wxWindow)
      EVT_LEFT_DOWN(CxResizeBar::OnLButtonDown)
      EVT_LEFT_UP(CxResizeBar::OnLButtonUp)
      EVT_MOTION(CxResizeBar::OnMouseMove)
END_EVENT_TABLE()
#endif


#ifdef __CR_WIN__
void CxResizeBar::OnMouseMove( UINT nFlags, CPoint wpoint )
{
 if( (nFlags & MK_LBUTTON) && (m_startDrag >= 0) )
 {
   wpoint.x = min(wpoint.x,GetWidth()-SIZE_BAR);
   wpoint.x = max(wpoint.x,0);
   wpoint.y = min(wpoint.y,GetHeight()-SIZE_BAR);
   wpoint.y = max(wpoint.y,0);

   CDC* myDC;
   myDC = GetDC();

   CcRect newRect;
   CRgn rgn, rgn2;
   rgn.CreateRectRgn(m_oldrec.Left(), m_oldrec.Top(), m_oldrec.Right(), m_oldrec.Bottom());

// Draw over old Rectangle
   myDC -> InvertRgn( &rgn );

// Get new coordinates.

   if ( m_type == kTHorizontal )
   {
      newRect.mLeft= 0;
      newRect.mRight = GetWidth();
      newRect.mTop = wpoint.y ;
      newRect.mBottom = wpoint.y + SIZE_BAR;
   }
   else
   {
      newRect.mTop = 0;
      newRect.mBottom = GetHeight();
      newRect.mLeft  = wpoint.x ;
      newRect.mRight = wpoint.x + SIZE_BAR;
   }

   rgn2.CreateRectRgn(newRect.Left(), newRect.Top(), newRect.Right(), newRect.Bottom());

// Draw over old Rectangle
   myDC -> InvertRgn( &rgn2 );

   ReleaseDC( myDC );

   m_oldrec = newRect;
 }
 else if ( !m_NonSizePresent )
 {
   if ( m_hotRect.Contains (wpoint.x, wpoint.y) )
   {
    SetCursor( AfxGetApp()->LoadStandardCursor( (m_type==kTHorizontal)?IDC_SIZENS:IDC_SIZEWE));
   }
   else
   {
    SetCursor( AfxGetApp()->LoadStandardCursor(IDC_ARROW));
   }
 }
 else if ( !m_BothNonSize )
 {
   CDC* myDC;
   myDC = GetDC();

   if ( m_veryHotRect.Contains(wpoint.x, wpoint.y))
   {
//Outline like a button.
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
     m_ButtonDrawn=true;
   }
   else if ( m_ButtonDrawn )
   {
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DFACE), ::GetSysColor(COLOR_3DFACE) );
     m_ButtonDrawn=false;
   }
   ReleaseDC( myDC );

 }

}
#endif

#ifdef __BOTHWX__
void CxResizeBar::OnMouseMove( wxMouseEvent & evt )
{
          SetCursor( wxCursor(wxCURSOR_HAND) );
}
#endif




#ifdef __CR_WIN__
void CxResizeBar::OnLButtonDown( UINT nFlags, CPoint point )
{
        int x = point.x;
        int y = point.y;
#endif
#ifdef __BOTHWX__
void CxResizeBar::OnLButtonDown( wxMouseEvent & event )
{
        int x = event.m_x;
        int y = event.m_y;
#endif

 if ( !m_NonSizePresent )
 {

   if ( m_hotRect.Contains ( x,y ) )
   {

      if ( m_type == kTHorizontal ) m_startDrag = y;
      else                          m_startDrag = x;

      SetCapture();
   }
 }
 else if ( !m_BothNonSize )
 {
   if ( m_veryHotRect.Contains(x,y) )
   {
//Outline like a pressed button.
     CDC* myDC;
     myDC = GetDC();
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DSHADOW), ::GetSysColor(COLOR_3DHILIGHT) );
     m_ButtonDrawn=true;
     ReleaseDC( myDC );
   }
 }
}


#ifdef __CR_WIN__
void CxResizeBar::OnLButtonUp( UINT nFlags, CPoint point )
{
        int x = point.x;
        int y = point.y;
#endif
#ifdef __BOTHWX__
void CxResizeBar::OnLButtonUp( wxMouseEvent & event )
{
        int x = event.m_x;
        int y = event.m_y;
#endif

 x = min(x,GetWidth()-SIZE_BAR);
 x = max(x,0);
 y = min(y,GetHeight()-SIZE_BAR);
 y = max(y,0);

 CDC* myDC;
 myDC =  GetDC() ;

 if ( ! m_NonSizePresent )
 {
   ReleaseCapture();
   CRgn rgn;
   rgn.CreateRectRgn(m_oldrec.Left(), m_oldrec.Top(), m_oldrec.Right(), m_oldrec.Bottom());
   myDC -> InvertRgn( &rgn );


   if ( m_type == kTHorizontal ) ptr_to_crObject->MoveResizeBar ( (int)(1000.0f * (float)y / (float)GetHeight())  );
   if ( m_type == kTVertical   ) ptr_to_crObject->MoveResizeBar ( (int)(1000.0f * (float)x / (float)GetWidth())  );

   m_startDrag = -1;
   m_oldrec.Set(0,0,0,0);
 }
 else if ( !m_BothNonSize )
 {

   if ( m_veryHotRect.Contains(x,y) )
   {
//Erase outline
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DFACE), ::GetSysColor(COLOR_3DFACE) );
     m_ButtonDrawn=false;
     m_Collapsed = !m_Collapsed;
     ptr_to_crObject->Collapse ( m_Collapsed );
   }
 }

 ReleaseDC( myDC );


}

void CxResizeBar::SetType( int type )
{
  m_type = type;
}

int CxResizeBar::GetIdealWidth()
{
  return EMPTY_CELL;
}
int CxResizeBar::GetIdealHeight()
{
  return EMPTY_CELL;
}


void CxResizeBar::SetHotRect(CcRect * hotRect)
{
 m_hotRect = *hotRect;
 if ( m_type == kTHorizontal )
 {
   m_veryHotRect.Set(m_hotRect.Top(),
                   ((m_hotRect.Left()+m_hotRect.Right())/2)-(2*EMPTY_CELL),
                   m_hotRect.Bottom(),
                   ((m_hotRect.Left()+m_hotRect.Right())/2)+(2*EMPTY_CELL));
 }
 else
 {
   m_veryHotRect.Set(((m_hotRect.Top()+m_hotRect.Bottom())/2)-(2*EMPTY_CELL),
                       m_hotRect.Left(),
                       ((m_hotRect.Top()+m_hotRect.Bottom())/2)+(2*EMPTY_CELL),
                       m_hotRect.Right());
 }

}

void CxResizeBar::OnPaint()
{
    CPaintDC dc(this); // device context for painting

    CcRect rect1, rect2, rect3, rect4;
    int midPointX = (m_hotRect.Left() + m_hotRect.Right()) / 2;
    int midPointY = (m_hotRect.Top() + m_hotRect.Bottom()) / 2;

    CPen penHigh(PS_SOLID,1,::GetSysColor(COLOR_3DHILIGHT));
    CPen penMid(PS_SOLID,1,::GetSysColor(COLOR_3DLIGHT));
    CPen penLow(PS_SOLID,1,::GetSysColor(COLOR_3DSHADOW));

#define CXARROWUP    1
#define CXARROWDOWN  2
#define CXARROWLEFT  3
#define CXARROWRIGHT 4

    int arrow = 0;

    if (( m_BothNonSize ) || ( !m_NonSizePresent ) )
    {
      arrow = 0;
    }
    else if ( m_type == kTHorizontal )
    {
      if (( m_firstNonSize && !m_Collapsed ) ||
          ( m_secondNonSize && m_Collapsed )) arrow = CXARROWUP;
      else                                    arrow = CXARROWDOWN;

    }
    else
    {
      if (( m_firstNonSize && !m_Collapsed ) ||
          ( m_secondNonSize && m_Collapsed )) arrow = CXARROWLEFT;
      else                                    arrow = CXARROWRIGHT;

    }

    CcPoint points[3];

    switch ( arrow )
    {
      case CXARROWUP:
      {
        points[0].Set( midPointX,   midPointY-4 ); //top
        points[1].Set( midPointX-7, midPointY+2 ); //bottom left
        points[2].Set( midPointX+7, midPointY+2 ); //bottom right
        break;
      }
      case CXARROWDOWN:
      {
        points[0].Set( midPointX-7, midPointY-3 ); //top left
        points[1].Set( midPointX+7, midPointY-3 ); //top right
        points[2].Set( midPointX,   midPointY+3 ); //bottom
        break;
      }
      case CXARROWLEFT:
      {
        points[0].Set( midPointX-4, midPointY   ); //left
        points[1].Set( midPointX+2, midPointY-7 ); //top right
        points[2].Set( midPointX+2, midPointY+7 ); //bottom right
        break;
      }
      case CXARROWRIGHT:
      {
        points[0].Set( midPointX-3, midPointY-7 ); //top left
        points[1].Set( midPointX-3, midPointY+7 ); //bottom left
        points[2].Set( midPointX+3, midPointY   ); //right
        break;
      }
      default:
      {
        break;
      }
    }


    if (arrow)
    {
      CRgn blackRgn;
      CBrush blackBrush;
      blackRgn.CreatePolygonRgn((LPPOINT) &points, 3, WINDING);
      blackBrush.CreateSolidBrush(RGB(0,0,0));
      dc.FillRgn(&blackRgn,&blackBrush);

      dc.MoveTo(points[0].x,points[0].y);  //Point between high and mid sides
      CPen * oldpen = dc.SelectObject(&penHigh);
      dc.LineTo(points[1].x,points[1].y);  //Point between high and low sides
      dc.SelectObject(&penLow);
      dc.LineTo(points[2].x,points[2].y);  //Point between mid and low sides
      dc.SelectObject(&penMid);
      dc.LineTo(points[0].x,points[0].y);  //Point between mid and high sides
      dc.SelectObject(oldpen);
    }

    if ( m_type == kTHorizontal )
    {
      if ( arrow == 0 )
      {
        rect1.Set(m_hotRect.Top() + 1, m_hotRect.Left() + EMPTY_CELL,
                  m_hotRect.Top() + 3, m_hotRect.Right()- EMPTY_CELL );
        rect2.Set(m_hotRect.Top() + 5, m_hotRect.Left() + EMPTY_CELL,
                  m_hotRect.Top() + 7, m_hotRect.Right()- EMPTY_CELL );
      }
      else
      {
        rect1.Set(m_hotRect.Top() + 1, m_hotRect.Left() + EMPTY_CELL,
                  m_hotRect.Top() + 3, midPointX        - ((arrow==CXARROWUP)?(2*EMPTY_CELL):(3*EMPTY_CELL)));
        rect2.Set(m_hotRect.Top() + 1, midPointX        + ((arrow==CXARROWUP)?(2*EMPTY_CELL):(3*EMPTY_CELL)),
                  m_hotRect.Top() + 3, m_hotRect.Right()- EMPTY_CELL );
        rect3.Set(m_hotRect.Top() + 5, m_hotRect.Left() + EMPTY_CELL,
                  m_hotRect.Top() + 7, midPointX        - ((arrow==CXARROWDOWN)?(2*EMPTY_CELL):(3*EMPTY_CELL)));
        rect4.Set(m_hotRect.Top() + 5, midPointX        + ((arrow==CXARROWDOWN)?(2*EMPTY_CELL):(3*EMPTY_CELL)),
                  m_hotRect.Top() + 7, m_hotRect.Right()- EMPTY_CELL );
      }
    }
    else
    {
      if ( arrow == 0 )
      {
        rect1.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+1,
                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+3 );
        rect2.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+5,
                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+7 );
      }
      else
      {
        rect1.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+1,
                   midPointY          - ((arrow==CXARROWLEFT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+3 );
        rect2.Set( midPointY          + ((arrow==CXARROWLEFT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+1,
                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+3 );
        rect3.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+5,
                   midPointY          - ((arrow==CXARROWRIGHT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+7 );
        rect4.Set( midPointY          + ((arrow==CXARROWRIGHT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+5,
                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+7 );
      }
    }


    if (arrow == 0)
    {
    dc.Draw3dRect(&rect1.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
    dc.Draw3dRect(&rect2.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
    }
    else
    {
      dc.Draw3dRect(&rect1.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
      dc.Draw3dRect(&rect2.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
      dc.Draw3dRect(&rect3.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
      dc.Draw3dRect(&rect4.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
    }
}


void CxResizeBar::WillNotResize(bool item1, bool item2)
{
  m_firstNonSize = item1;
  m_secondNonSize = item2;
  m_BothNonSize    = m_firstNonSize && m_secondNonSize;
  m_NonSizePresent = m_firstNonSize || m_secondNonSize;

  if (m_BothNonSize ) LOGERR ( "Both items in resizebar will not resize");
}


void CxResizeBar::AlreadyCollapsed()
{
  m_Collapsed = true;
}
