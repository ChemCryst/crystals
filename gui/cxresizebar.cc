////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CxResizeBar.cc
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $
//   Revision 1.2  2001/06/17 14:32:25  richard
//   wx support. CxDestroyWindow function.
//
//   Revision 1.1  2001/02/26 12:04:49  richard
//   New resizebar class. A resize control has two panes and the bar between them
//   can be dragged to change their relative sizes. If one of the panes is of fixed
//   width or height in the relevant direction, then the resize-bar contains a button
//   which will show or hide the fixed size item.
//

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
    control->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10));
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
#ifdef __BOTHWX__
    m_MouseCaught = false;
#endif
}

CxResizeBar::~CxResizeBar()
{
    RemoveResizeBar();
}

void CxResizeBar::CxDestroyWindow()
{
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}

CXSETGEOMETRY(CxResizeBar)

CXGETGEOMETRIES(CxResizeBar)



#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxResizeBar, CWnd)
    ON_WM_LBUTTONDOWN()
    ON_WM_LBUTTONUP()
    ON_WM_MOUSEMOVE()
    ON_WM_PAINT()
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Table
BEGIN_EVENT_TABLE(CxResizeBar, wxWindow)
      EVT_LEFT_DOWN(CxResizeBar::OnLButtonDown)
      EVT_LEFT_UP(CxResizeBar::OnLButtonUp)
      EVT_MOTION(CxResizeBar::OnMouseMove)
      EVT_PAINT( CxResizeBar::OnPaint )
      EVT_CHAR( CxResizeBar::OnChar )
END_EVENT_TABLE()
#endif

CXONCHAR(CxResizeBar)

#ifdef __CR_WIN__
void CxResizeBar::OnMouseMove( UINT nFlags, CPoint wpoint )
{
 int x = wpoint.x;
 int y = wpoint.y;
 bool leftDown = ( (nFlags & MK_LBUTTON) != 0 );
 int xoff = 0;
 int yoff = 0;
#endif
#ifdef __BOTHWX__
void CxResizeBar::OnMouseMove( wxMouseEvent & evt )
{
 int x = evt.m_x;
 int y = evt.m_y;
 bool leftDown = evt.m_leftDown;

// CcRect mainR = ((CrResizeBar*)ptr_to_crObject)->GetRootWidget()->GetGeometry();
 int xoff = 0; //mainR.Left();
 int yoff = 0; //mainR.Top();
#endif

 if( leftDown && (m_startDrag >= 0) )
 {
   x = min(x,GetWidth()-SIZE_BAR);
   x = max(x,0);
   y = min(y,GetHeight()-SIZE_BAR);
   y = max(y,0);


   CcRect newRect;
#ifdef __CR_WIN__
   CDC* myDC;
   myDC = GetDC();
   CRgn rgn, rgn2;
   rgn.CreateRectRgn(m_oldrec.Left(), m_oldrec.Top(), m_oldrec.Right(), m_oldrec.Bottom());
   myDC -> InvertRgn( &rgn );
#endif
#ifdef __BOTHWX__
   wxClientDC myDC(this);
   myDC.SetBrush( wxBrush( wxColour(0,0,0), wxSOLID ) );
   myDC.SetLogicalFunction ( wxINVERT );
   myDC.DrawRectangle(m_oldrec.Left(), m_oldrec.Top(), m_oldrec.Width(), m_oldrec.Height());
#endif


// Get new coordinates.

   if ( m_type == kTHorizontal )
   {
      newRect.mLeft= xoff;
      newRect.mRight = xoff + GetWidth();
      newRect.mTop = yoff + y ;
      newRect.mBottom = yoff + y + SIZE_BAR;
   }
   else
   {
      newRect.mTop = yoff;
      newRect.mBottom = yoff + GetHeight();
      newRect.mLeft  = xoff + x ;
      newRect.mRight = xoff + x + SIZE_BAR;
   }

#ifdef __CR_WIN__
   rgn2.CreateRectRgn(newRect.Left(), newRect.Top(), newRect.Right(), newRect.Bottom());
// Draw over old Rectangle
   myDC -> InvertRgn( &rgn2 );
#endif
#ifdef __BOTHWX__
   myDC.DrawRectangle(newRect.Left(), newRect.Top(), newRect.Width(), newRect.Height());
#endif

//   TEXTOUT ( newRect.AsString() );


#ifdef __CR_WIN__
   ReleaseDC( myDC );
#endif

   m_oldrec = newRect;
 }
 else if ( !m_NonSizePresent )
 {
   if ( m_hotRect.Contains (x, y) )
   {
#ifdef __CR_WIN__
    SetCursor( AfxGetApp()->LoadStandardCursor( (m_type==kTHorizontal)?IDC_SIZENS:IDC_SIZEWE));
#endif
#ifdef __BOTHWX__
    SetCursor( wxCursor ( (m_type==kTHorizontal)?wxCURSOR_SIZENS:wxCURSOR_SIZEWE) );
#endif
   }
   else
   {
#ifdef __CR_WIN__
    SetCursor( AfxGetApp()->LoadStandardCursor(IDC_ARROW));
#endif
#ifdef __BOTHWX__
    SetCursor( wxCursor ( wxCURSOR_ARROW ) );
#endif
   }
 }
 else if ( !m_BothNonSize )
 {
#ifdef __CR_WIN__
   CDC* myDC;
   myDC = GetDC();

   if ( m_veryHotRect.Contains(x, y))
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
#endif
 }

}




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

#ifdef __CR_WIN__
      SetCapture();
#endif
#ifdef __BOTHWX__
      if (!m_MouseCaught){CaptureMouse(); m_MouseCaught = true;}
#endif

   }
 }
 else if ( !m_BothNonSize )
 {
   if ( m_veryHotRect.Contains(x,y) )
   {
//Outline like a pressed button.
#ifdef __CR_WIN__
     CDC* myDC;
     myDC = GetDC();
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DSHADOW), ::GetSysColor(COLOR_3DHILIGHT) );
#endif
     m_ButtonDrawn=true;
#ifdef __CR_WIN__
     ReleaseDC( myDC );
#endif
   }
 }
}


#ifdef __CR_WIN__
void CxResizeBar::OnLButtonUp( UINT nFlags, CPoint point )
{
  int x = point.x;
  int y = point.y;
  int xoff = 0;
  int yoff = 0;
#endif
#ifdef __BOTHWX__
void CxResizeBar::OnLButtonUp( wxMouseEvent & event )
{
  int x = event.m_x;
  int y = event.m_y;
//  CcRect mainR = ((CrResizeBar*)ptr_to_crObject)->GetRootWidget()->GetGeometry();
  int xoff = 0; //mainR.Left();
  int yoff = 0; //mainR.Top();
#endif

 x = min(x,GetWidth()-SIZE_BAR);
 x = max(x,0);
 y = min(y,GetHeight()-SIZE_BAR);
 y = max(y,0);

#ifdef __CR_WIN__
 CDC* myDC;
 myDC =  GetDC() ;
#endif
#ifdef __BOTHWX__
 wxClientDC myDC(this);
#endif


 if ( ! m_NonSizePresent )
 {
#ifdef __CR_WIN__
      ReleaseCapture();
#endif
#ifdef __BOTHWX__
      if(m_MouseCaught){ReleaseMouse();m_MouseCaught=false;}
#endif


#ifdef __CR_WIN__
   CRgn rgn;
   rgn.CreateRectRgn(m_oldrec.Left(), m_oldrec.Top(), m_oldrec.Right(), m_oldrec.Bottom());
   myDC -> InvertRgn( &rgn );
#endif
#ifdef __BOTHWX__
   myDC.SetBrush( wxBrush( wxColour(0,0,0), wxSOLID ) );
   myDC.SetLogicalFunction ( wxINVERT );
   myDC.DrawRectangle(xoff + m_oldrec.Left(), yoff + m_oldrec.Top(), xoff + m_oldrec.Width(), yoff + m_oldrec.Height());
#endif


   if ( m_type == kTHorizontal ) ptr_to_crObject->MoveResizeBar ( (int)(1000.0f * (float)y / (float)GetHeight())  );
   if ( m_type == kTVertical   ) ptr_to_crObject->MoveResizeBar ( (int)(1000.0f * (float)x / (float)GetWidth())  );

   m_startDrag = -1;
   m_oldrec.Set(0,0,0,0);
 }
 else if ( !m_BothNonSize )
 {

   if ( m_veryHotRect.Contains(x,y) )
   {
#ifdef __CR_WIN__
//Erase outline
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DFACE), ::GetSysColor(COLOR_3DFACE) );
#endif
     m_ButtonDrawn=false;
     m_Collapsed = !m_Collapsed;
     ptr_to_crObject->Collapse ( m_Collapsed );
   }
 }

#ifdef __CR_WIN__
 ReleaseDC( myDC );
#endif


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

#ifdef __CR_WIN__
void CxResizeBar::OnPaint()
{
    CPaintDC dc(this); // device context for painting
    CPen penHigh(PS_SOLID,1,::GetSysColor(COLOR_3DHILIGHT));
    CPen penMid(PS_SOLID,1,::GetSysColor(COLOR_3DLIGHT));
    CPen penLow(PS_SOLID,1,::GetSysColor(COLOR_3DSHADOW));
#endif
#ifdef __BOTHWX__
void CxResizeBar::OnPaint(wxPaintEvent & event)
{
    wxPaintDC dc(this); // device context for painting
    wxPen penHigh(wxSystemSettings::GetSystemColour(wxSYS_COLOUR_3DHIGHLIGHT ),1,wxSOLID);
    wxPen penMid (wxSystemSettings::GetSystemColour(wxSYS_COLOUR_3DLIGHT ),1,wxSOLID);
    wxPen penLow (wxSystemSettings::GetSystemColour(wxSYS_COLOUR_3DSHADOW),1,wxSOLID);
#endif

    CcRect rect1, rect2, rect3, rect4;
    int midPointX = (m_hotRect.Left() + m_hotRect.Right()) / 2;
    int midPointY = (m_hotRect.Top() + m_hotRect.Bottom()) / 2;


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
#ifdef __CR_WIN__
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
#endif
#ifdef __BOTHWX__
      dc.SetBrush ( *wxBLACK_BRUSH );
      dc.DrawPolygon(3, (wxPoint*) &points);
      dc.SetPen ( penHigh );
      dc.DrawLine ( points[0].x, points[0].y, points[1].x, points[1].y );
      dc.SetPen ( penLow );
      dc.DrawLine ( points[1].x, points[1].y, points[2].x, points[2].y );
      dc.SetPen ( penMid );
      dc.DrawLine ( points[2].x, points[2].y, points[0].x, points[0].y );
      dc.SetPen ( wxNullPen );
#endif


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


#ifdef __CR_WIN__
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
#endif
#ifdef __BOTHWX__
    if (arrow == 0)
    {
      dc.SetPen ( penHigh );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Left(),  rect1.Bottom() );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Right(), rect1.Top() );
      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Left(),  rect2.Bottom() );
      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Right(), rect2.Top() );
      dc.SetPen ( penLow );
      dc.DrawLine ( rect1.Right(), rect1.Bottom(), rect1.Right(), rect1.Top() );
      dc.DrawLine ( rect1.Right(), rect1.Bottom(), rect1.Left(),  rect1.Bottom() );
      dc.DrawLine ( rect2.Right(), rect2.Bottom(), rect2.Right(), rect2.Top() );
      dc.DrawLine ( rect2.Right(), rect2.Bottom(), rect2.Left(),  rect2.Bottom() );
      dc.SetPen ( wxNullPen );
    }
    else
    {
      dc.SetPen ( penHigh );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Left(),  rect1.Bottom() );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Right(), rect1.Top() );
      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Left(),  rect2.Bottom() );
      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Right(), rect2.Top() );
      dc.DrawLine ( rect3.Left(),  rect3.Top(),    rect3.Left(),  rect3.Bottom() );
      dc.DrawLine ( rect3.Left(),  rect3.Top(),    rect3.Right(), rect3.Top() );
      dc.DrawLine ( rect4.Left(),  rect4.Top(),    rect4.Left(),  rect4.Bottom() );
      dc.DrawLine ( rect4.Left(),  rect4.Top(),    rect4.Right(), rect4.Top() );
      dc.SetPen ( penLow );
      dc.DrawLine ( rect1.Right(), rect1.Bottom(), rect1.Right(), rect1.Top() );
      dc.DrawLine ( rect1.Right(), rect1.Bottom(), rect1.Left(),  rect1.Bottom() );
      dc.DrawLine ( rect2.Right(), rect2.Bottom(), rect2.Right(), rect2.Top() );
      dc.DrawLine ( rect2.Right(), rect2.Bottom(), rect2.Left(),  rect2.Bottom() );
      dc.DrawLine ( rect3.Right(), rect3.Bottom(), rect3.Right(), rect3.Top() );
      dc.DrawLine ( rect3.Right(), rect3.Bottom(), rect3.Left(),  rect3.Bottom() );
      dc.DrawLine ( rect4.Right(), rect4.Bottom(), rect4.Right(), rect4.Top() );
      dc.DrawLine ( rect4.Right(), rect4.Bottom(), rect4.Left(),  rect4.Bottom() );
      dc.SetPen ( wxNullPen );
    }
#endif
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
