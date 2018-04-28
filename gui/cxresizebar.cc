////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CxResizeBar.cc
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $
//   Revision 1.17  2011/05/04 12:22:04  rich
//   Use NullCursor, not NULL.
//
//   Revision 1.16  2011/03/16 17:37:30  rich
//   Fix drawing of resizebar and cursor setting on mouse exit.
//
//   Revision 1.15  2011/03/04 05:57:27  rich
//   Fix SHIFT and CTRL down flags.
//
//   Revision 1.14  2009/07/23 14:15:42  rich
//   Removed all uses of OpenGL feedback buffer - was dreadful slow on some new graphics cards.
//
//   Revision 1.13  2008/09/22 12:31:37  rich
//   Upgrade GUI code to work with latest wxWindows 2.8.8
//   Fix startup crash in OpenGL (cxmodel)
//   Fix atom selection infinite recursion in cxmodlist
//
//   Revision 1.12  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.10  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.9  2003/02/20 14:07:25  rich
//   Neater resize bars.
//
//   Revision 1.8  2003/01/14 13:35:02  rich
//   Error crept in during linux editing. Fixed.
//
//   Revision 1.7  2003/01/14 10:27:19  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.6  2001/11/15 10:44:15  ckp2
//   Yesterday's changes resulted in the resizebar not showing up over it's
//   children as you dragged to resize - fixed by temporarily turning CLIPCHILDREN
//   style off for the duration of the drag. (CLIPCHILDREN prevents flicker when repainting
//   windows underneath other child windows.)
//
//   Revision 1.5  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.4  2001/08/14 10:20:35  ckp2
//   Quirky new feature: Hold down CTRL and click on a resize-bar and the panes
//   will swap sides. Hold down SHIFT and click, and the panes will rotate by 90
//   degrees. Gives more control over screen layout, but is not intuitive as the
//   user can't SEE which panes belong to a given resize bar. Try it and see.
//   The new layout is not stored and will revert to original layout when window
//   is reopened (for the time being).
//
//   Revision 1.3  2001/07/16 07:34:58  ckp2
//   Process ON_CHAR messages. Only ever capture and release the mouse once under wx or
//   it gets upset.
//
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
#include    <string>
using namespace std;
#include    "cccontroller.h"
#include    "ccpoint.h"

#include    "crconstants.h" //for kSvertical and kShorizontal
#include    "cxresizebar.h"
#include    "cxgrid.h"
#include    "crresizebar.h"
#include    "crgrid.h"

#ifdef CRY_USEWX
 #include <ctype.h>
 #include <wx/settings.h>
 #include <wx/cmndata.h>
 #include <wx/fontdlg.h>
#endif

#ifndef CRY_OSWIN32
 #define MK_CONTROL 1
 #define MK_SHIFT 2
#endif

int CxResizeBar::mResizeBarCount = kResizeBarBase;

CxResizeBar * CxResizeBar::CreateCxResizeBar( CrResizeBar * container, CxGrid * guiParent )
{
    CxResizeBar *control = new CxResizeBar (container);
#ifdef CRY_USEMFC
    control->Create(NULL, "Resize", WS_VISIBLE|WS_CHILD|WS_CLIPCHILDREN, CRect(0,0,10,10), guiParent, mResizeBarCount++);
#else
    control->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10), wxWANTS_CHARS);
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
#ifdef CRY_USEWX
    m_MouseCaught = false;
#endif
}

CxResizeBar::~CxResizeBar()
{
    RemoveResizeBar();
}

void CxResizeBar::CxDestroyWindow()
{
  #ifdef CRY_USEMFC
DestroyWindow();
#endif
#ifdef CRY_USEWX
Destroy();
#endif
}

CXSETGEOMETRY(CxResizeBar)

CXGETGEOMETRIES(CxResizeBar)



#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxResizeBar, CWnd)
    ON_WM_LBUTTONDOWN()
    ON_WM_LBUTTONUP()
    ON_WM_MOUSEMOVE()
    ON_WM_PAINT()
    ON_WM_CHAR()
    ON_WM_ERASEBKGND()
END_MESSAGE_MAP()
#else
//wx Message Table
BEGIN_EVENT_TABLE(CxResizeBar, wxWindow)
      EVT_LEFT_DOWN(CxResizeBar::OnLButtonDown)
      EVT_LEFT_UP(CxResizeBar::OnLButtonUp)
      EVT_MOTION(CxResizeBar::OnMouseMove)
      EVT_PAINT( CxResizeBar::OnPaint )
      EVT_CHAR( CxResizeBar::OnChar )
	  EVT_LEAVE_WINDOW( CxResizeBar::OnMouseLeave )
END_EVENT_TABLE()
#endif

CXONCHAR(CxResizeBar)


#ifdef CRY_USEWX
void CxResizeBar::OnMouseLeave(wxMouseEvent & event) {
	SetCursor(wxNullCursor);
}
#endif

#ifdef CRY_USEMFC
void CxResizeBar::OnMouseMove( UINT nFlags, CPoint wpoint )
{
 int x = wpoint.x;
 int y = wpoint.y;
 bool leftDown = ( (nFlags & MK_LBUTTON) != 0 );
 int xoff = 0;
 int yoff = 0;
#else
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
   x = CRMIN(x,GetWidth()-SIZE_BAR);
   x = CRMAX(x,0);
   y = CRMIN(y,GetHeight()-SIZE_BAR);
   y = CRMAX(y,0);


   CcRect newRect;
#ifdef CRY_USEMFC
   CDC* myDC;
   myDC = GetDC();
   CRgn rgn, rgn2;
   rgn.CreateRectRgn(m_oldrec.Left(), m_oldrec.Top(), m_oldrec.Right(), m_oldrec.Bottom());
   myDC -> InvertRgn( &rgn );
#else
   wxWindowDC myDC(this);
   myDC.SetBrush( wxBrush( wxColour(0,0,0), wxBRUSHSTYLE_SOLID ) );
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

#ifdef CRY_USEMFC
   rgn2.CreateRectRgn(newRect.Left(), newRect.Top(), newRect.Right(), newRect.Bottom());
// Draw over old Rectangle
   myDC -> InvertRgn( &rgn2 );
#else
   myDC.DrawRectangle(newRect.Left(), newRect.Top(), newRect.Width(), newRect.Height());
#endif

//   TEXTOUT ( newRect.AsString() );


#ifdef CRY_USEMFC
   ReleaseDC( myDC );
#endif

   m_oldrec = newRect;
 }
 else if ( !m_NonSizePresent )
 {
   if ( m_hotRect.Contains (x, y) )
   {
#ifdef CRY_USEMFC
    SetCursor( AfxGetApp()->LoadStandardCursor( (m_type==kTHorizontal)?IDC_SIZENS:IDC_SIZEWE));
#endif
#ifdef CRY_USEWX
    this->SetCursor( (m_type==kTHorizontal)?wxCURSOR_SIZENS:wxCURSOR_SIZEWE );
#endif
   }
   else
   {
#ifdef CRY_USEMFC
    SetCursor( AfxGetApp()->LoadStandardCursor(IDC_ARROW));
#endif
#ifdef CRY_USEWX
    this->SetCursor( wxNullCursor  );
#endif
   }
 }
 else if ( !m_BothNonSize )
 {
#ifdef CRY_USEMFC
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




#ifdef CRY_USEMFC
void CxResizeBar::OnLButtonDown( UINT nFlags, CPoint point )
{
        int x = point.x;
        int y = point.y;
#endif
#ifdef CRY_USEWX
void CxResizeBar::OnLButtonDown( wxMouseEvent & event )
{
        int x = event.m_x;
        int y = event.m_y;
        int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
        nFlags |= event.m_shiftDown ? MK_SHIFT : 0 ;
#endif

 if ( nFlags & MK_CONTROL )
 {
    ((CrResizeBar*)ptr_to_crObject)->SwapPanes();
    return;
 }
 if ( nFlags & MK_SHIFT )
 {
    ((CrResizeBar*)ptr_to_crObject)->SwapOrient();
    return;
 }

 if ( !m_NonSizePresent )
 {

   if ( m_hotRect.Contains ( x,y ) )
   {

      if ( m_type == kTHorizontal ) m_startDrag = y;
      else                          m_startDrag = x;

#ifdef CRY_USEMFC
// turn off WS_CLIPCHILDREN
      ModifyStyle(WS_CLIPCHILDREN, 0);

      SetCapture();
#endif
#ifdef CRY_USEWX
      if (!m_MouseCaught){CaptureMouse(); m_MouseCaught = true;}
#endif

   }
 }
 else if ( !m_BothNonSize )
 {
   if ( m_veryHotRect.Contains(x,y) )
   {
//Outline like a pressed button.
#ifdef CRY_USEMFC
     CDC* myDC;
     myDC = GetDC();
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DSHADOW), ::GetSysColor(COLOR_3DHILIGHT) );
#endif
     m_ButtonDrawn=true;
#ifdef CRY_USEMFC
     ReleaseDC( myDC );
#endif
   }
 }
}


#ifdef CRY_USEMFC
void CxResizeBar::OnLButtonUp( UINT nFlags, CPoint point )
{
  int x = point.x;
  int y = point.y;
  int xoff = 0;
  int yoff = 0;
// turn on WS_CLIPCHILDREN
  ModifyStyle(0, WS_CLIPCHILDREN);
#endif
#ifdef CRY_USEWX
void CxResizeBar::OnLButtonUp( wxMouseEvent & event )
{
  int x = event.m_x;
  int y = event.m_y;
//  CcRect mainR = ((CrResizeBar*)ptr_to_crObject)->GetRootWidget()->GetGeometry();
  int xoff = 0; //mainR.Left();
  int yoff = 0; //mainR.Top();
#endif


 x = CRMIN(x,GetWidth()-SIZE_BAR);
 x = CRMAX(x,0);
 y = CRMIN(y,GetHeight()-SIZE_BAR);
 y = CRMAX(y,0);

#ifdef CRY_USEMFC
 CDC* myDC;
 myDC =  GetDC() ;
#endif
#ifdef CRY_USEWX
 wxClientDC myDC(this);
#endif


 if ( ! m_NonSizePresent )
 {
#ifdef CRY_USEMFC
      ReleaseCapture();
#endif
#ifdef CRY_USEWX
      if(m_MouseCaught){ReleaseMouse();m_MouseCaught=false;}
#endif


#ifdef CRY_USEMFC
   CRgn rgn;
   rgn.CreateRectRgn(m_oldrec.Left(), m_oldrec.Top(), m_oldrec.Right(), m_oldrec.Bottom());
   myDC -> InvertRgn( &rgn );
#endif
#ifdef CRY_USEWX
   myDC.SetBrush( wxBrush( wxColour(0,0,0), wxBRUSHSTYLE_SOLID ) );
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
#ifdef CRY_USEMFC
//Erase outline
     myDC->Draw3dRect(&m_veryHotRect.Native(), ::GetSysColor(COLOR_3DFACE), ::GetSysColor(COLOR_3DFACE) );
#endif
     m_ButtonDrawn=false;
     m_Collapsed = !m_Collapsed;
     ptr_to_crObject->Collapse ( m_Collapsed );
   }
 }

#ifdef CRY_USEMFC
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

#ifdef CRY_USEMFC
void CxResizeBar::OnPaint()
{
    CPaintDC dc(this); // device context for painting
    CPen penHigh(PS_SOLID,1,::GetSysColor(COLOR_3DHILIGHT));
    CPen penMid(PS_SOLID,1,::GetSysColor(COLOR_3DLIGHT));
    CPen penLow(PS_SOLID,1,::GetSysColor(COLOR_3DSHADOW));
#endif
#ifdef CRY_USEWX
void CxResizeBar::OnPaint(wxPaintEvent & event)
{
    wxPaintDC dc(this); // device context for painting
    wxPen penHigh(wxSystemSettings::GetColour(wxSYS_COLOUR_3DHIGHLIGHT ),1,wxPENSTYLE_SOLID);
    wxPen penMid (wxSystemSettings::GetColour(wxSYS_COLOUR_3DLIGHT ),1,wxPENSTYLE_SOLID);
    wxPen penLow (wxSystemSettings::GetColour(wxSYS_COLOUR_3DSHADOW),1,wxPENSTYLE_SOLID);
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
#ifdef CRY_USEMFC
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
#ifdef CRY_USEWX
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
        rect1.Set(m_hotRect.Top() + 3, m_hotRect.Left() + EMPTY_CELL,
                  m_hotRect.Top() + 5, m_hotRect.Right()- EMPTY_CELL );
//        rect2.Set(m_hotRect.Top() + 5, m_hotRect.Left() + EMPTY_CELL,
//                  m_hotRect.Top() + 7, m_hotRect.Right()- EMPTY_CELL );
      }
      else
      {
        rect1.Set(m_hotRect.Top() + 3, m_hotRect.Left() + EMPTY_CELL,
                  m_hotRect.Top() + 5, midPointX        - ((arrow==CXARROWUP)?(2*EMPTY_CELL):(3*EMPTY_CELL)));
        rect2.Set(m_hotRect.Top() + 3, midPointX        + ((arrow==CXARROWUP)?(2*EMPTY_CELL):(3*EMPTY_CELL)),
                  m_hotRect.Top() + 5, m_hotRect.Right()- EMPTY_CELL );
//        rect3.Set(m_hotRect.Top() + 5, m_hotRect.Left() + EMPTY_CELL,
//                  m_hotRect.Top() + 7, midPointX        - ((arrow==CXARROWDOWN)?(2*EMPTY_CELL):(3*EMPTY_CELL)));
//        rect4.Set(m_hotRect.Top() + 5, midPointX        + ((arrow==CXARROWDOWN)?(2*EMPTY_CELL):(3*EMPTY_CELL)),
//                  m_hotRect.Top() + 7, m_hotRect.Right()- EMPTY_CELL );
      }
    }
    else
    {
      if ( arrow == 0 )
      {
        rect1.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+3,
                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+5 );
//        rect2.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+5,
//                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+7 );
      }
      else
      {
        rect1.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+3,
                   midPointY          - ((arrow==CXARROWLEFT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+5 );
        rect2.Set( midPointY          + ((arrow==CXARROWLEFT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+3,
                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+5 );
//        rect3.Set( m_hotRect.Top()    + EMPTY_CELL, m_hotRect.Left()+5,
//                   midPointY          - ((arrow==CXARROWRIGHT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+7 );
//        rect4.Set( midPointY          + ((arrow==CXARROWRIGHT)?(2*EMPTY_CELL):(3*EMPTY_CELL)), m_hotRect.Left()+5,
//                   m_hotRect.Bottom() - EMPTY_CELL, m_hotRect.Left()+7 );
      }
    }


#ifdef CRY_USEMFC
    if (arrow == 0)
    {
      dc.Draw3dRect(&rect1.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
//      dc.Draw3dRect(&rect2.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
    }
    else
    {
      dc.Draw3dRect(&rect1.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
      dc.Draw3dRect(&rect2.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
//      dc.Draw3dRect(&rect3.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
//      dc.Draw3dRect(&rect4.Native(), ::GetSysColor(COLOR_3DHILIGHT), ::GetSysColor(COLOR_3DSHADOW) );
    }
#endif
#ifdef CRY_USEWX
    if (arrow == 0)
    {
      dc.SetPen ( penHigh );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Left(),  rect1.Bottom()-1 );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Right()-1, rect1.Top() );
//      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Left(),  rect2.Bottom() );
//      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Right(), rect2.Top() );
      dc.SetPen ( penLow );
      dc.DrawLine ( rect1.Right()-1, rect1.Bottom()-1, rect1.Right()-1, rect1.Top() );
      dc.DrawLine ( rect1.Right()-1, rect1.Bottom()-1, rect1.Left(),  rect1.Bottom()-1 );
//      dc.DrawLine ( rect2.Right(), rect2.Bottom(), rect2.Right(), rect2.Top() );
//      dc.DrawLine ( rect2.Right(), rect2.Bottom(), rect2.Left(),  rect2.Bottom() );
      dc.SetPen ( wxNullPen );
    }
    else
    {
      dc.SetPen ( penHigh );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Left(),  rect1.Bottom()-1 );
      dc.DrawLine ( rect1.Left(),  rect1.Top(),    rect1.Right()-1, rect1.Top() );
      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Left(),  rect2.Bottom()-1 );
      dc.DrawLine ( rect2.Left(),  rect2.Top(),    rect2.Right()-1, rect2.Top() );
//      dc.DrawLine ( rect3.Left(),  rect3.Top(),    rect3.Left(),  rect3.Bottom() );
//      dc.DrawLine ( rect3.Left(),  rect3.Top(),    rect3.Right(), rect3.Top() );
//      dc.DrawLine ( rect4.Left(),  rect4.Top(),    rect4.Left(),  rect4.Bottom() );
//      dc.DrawLine ( rect4.Left(),  rect4.Top(),    rect4.Right(), rect4.Top() );
      dc.SetPen ( penLow );
      dc.DrawLine ( rect1.Right()-1, rect1.Bottom()-1, rect1.Right()-1, rect1.Top() );
      dc.DrawLine ( rect1.Right()-1, rect1.Bottom()-1, rect1.Left(),  rect1.Bottom()-1 );
      dc.DrawLine ( rect2.Right()-1, rect2.Bottom()-1, rect2.Right()-1, rect2.Top() );
      dc.DrawLine ( rect2.Right()-1, rect2.Bottom()-1, rect2.Left(),  rect2.Bottom()-1 );
//      dc.DrawLine ( rect3.Right(), rect3.Bottom(), rect3.Right(), rect3.Top() );
//      dc.DrawLine ( rect3.Right(), rect3.Bottom(), rect3.Left(),  rect3.Bottom() );
//      dc.DrawLine ( rect4.Right(), rect4.Bottom(), rect4.Right(), rect4.Top() );
//      dc.DrawLine ( rect4.Right(), rect4.Bottom(), rect4.Left(),  rect4.Bottom() );
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

#ifdef CRY_USEMFC
BOOL CxResizeBar::OnEraseBkgnd(CDC* pDC)
{

  CRect rect;

// GetClipBox Retrieves the dimensions of the view area and
// copies to the buffer pointed to by rect.
  pDC->GetClipBox( &rect);

  COLORREF fillColor = GetSysColor(COLOR_3DFACE);

// Create the bursh and select into DC
  CBrush brush ( fillColor );
  CBrush* pOldBrush = pDC->SelectObject( &brush );

// PatBlt Creates a bit pattern on the device.
  pDC->PatBlt( rect.left, rect.top, rect.Width(), rect.Height(), PATCOPY );

  pDC->SelectObject( pOldBrush ) ;

  return TRUE;
}
#endif
