////////////////////////////////////////////////////////////////////////
// CRYSTALS Interface      Class CxModel
////////////////////////////////////////////////////////////////////////

#include    "crystalsinterface.h"
#include    <math.h>
#include    <string>
#include    <sstream>
#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "ccrect.h"
#include    "cxmodel.h"
#include    "crmodel.h"
#include    "ccmodelatom.h"
#include    "ccmodeldoc.h"
#include    "creditbox.h"
#include    "cccontroller.h"
#include    "resource.h"
#include    <GL/glu.h>
#if defined(__WXGTK__) || defined(__WXMAC__) || defined(__BOTHWX__)
#include "idb_splash.xpm"
#endif

#ifndef PFD_SUPPORT_COMPOSITION
#define PFD_SUPPORT_COMPOSITION 0x00008000
#endif


#ifdef __BOTHWX__
BEGIN_EVENT_TABLE( mywxStaticText, wxStaticText)
     EVT_LEFT_UP( mywxStaticText::OnLButtonUp )
     EVT_LEFT_DOWN( mywxStaticText::OnLButtonDown )
     EVT_RIGHT_UP( mywxStaticText::OnRButtonUp )
END_EVENT_TABLE()

mywxStaticText::mywxStaticText(wxWindow* w, int i, wxString s, wxPoint p, wxSize ss, int f):
                  wxStaticText(w,i,s,p,ss,f)
{
    m_parent = w; 
}
void mywxStaticText::OnLButtonUp( wxMouseEvent & event ) { event.m_x += GetRect().x; event.m_y += GetRect().y; m_parent->GetEventHandler()->ProcessEvent(event); }
void mywxStaticText::OnLButtonDown( wxMouseEvent & event){ event.m_x += GetRect().x; event.m_y += GetRect().y; m_parent->GetEventHandler()->ProcessEvent(event); }
void mywxStaticText::OnRButtonUp( wxMouseEvent & event ) { event.m_x += GetRect().x; event.m_y += GetRect().y; m_parent->GetEventHandler()->ProcessEvent(event); }
#endif





int CxModel::mModelCount = kModelBase;
#ifdef __CR_WIN__
HDC CxModel::last_hdc = NULL;
#endif

CxModel * CxModel::CreateCxModel( CrModel * container, CxGrid * guiParent )
{

#ifdef __CR_WIN__

  CxModel *theModel = new CxModel(container);
  const char* wndClass = AfxRegisterWndClass( CS_HREDRAW|CS_VREDRAW,NULL,(HBRUSH)(COLOR_MENU+1),NULL);

  if ( theModel -> Create(wndClass,"Model",WS_CHILD|WS_VISIBLE|WS_CLIPCHILDREN|WS_CLIPSIBLINGS,CRect(0,0,26,28),guiParent,mModelCount++) == 0 )
  {
    ::MessageBox (  NULL, "Create modelwindow failed", "Error", MB_OK) ;
    delete theModel;
    return nil;
  }

//  theModel -> ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
  theModel -> SetFont(CcController::mp_font);

  CRect rect;
//  CClientDC dc(theModel);

  theModel->m_hdc = ::GetDC(theModel->GetSafeHwnd());

  if( ( theModel->SetWindowPixelFormat() ) == false )
  {
    delete theModel;
    return nil;
  }
  if ( ( theModel->CreateViewGLContext() ) == false )
  {
    delete theModel;
    return nil;
  }


  theModel->Setup();

#endif
#ifdef __BOTHWX__

  int args[] = {WX_GL_RGBA, WX_GL_DOUBLEBUFFER, 0};
  CxModel *theModel = new CxModel((wxWindow*)guiParent, args);
  theModel->ptr_to_crObject = container;
  theModel->Show();
//  theModel->Setup();

#endif

  return theModel;
}

#ifdef __BOTHWX__

//CxModel::CxModel(wxWindow *parent, wxWindowID id, int* args, long style, const wxString& name): wxGLCanvas(parent, wxID_ANY, wxDefaultPosition, wxDefaultSize, style|wxFULL_REPAINT_ON_RESIZE)
CxModel::CxModel(wxWindow *parent, int * args): wxGLCanvas(parent, wxID_ANY, args, wxDefaultPosition, wxDefaultSize, wxFULL_REPAINT_ON_RESIZE)
{
	m_context = new wxGLContext(this);
    m_DoNotPaint = false;
    m_NotSetupYet = true;
    m_MouseCaught = false;
// This is for the PaintBannerInstead() function.
    wxBitmap newbit = wxBitmap(wxBITMAP(IDB_SPLASH));
//    m_bitmap = newbit;
    m_bitmap = newbit.GetSubBitmap(wxRect(0, 0, newbit.GetWidth(), newbit.GetHeight()));
    m_bitmapok = m_bitmap.Ok();

    string crysdir ( getenv("CRYSDIR") );
    if ( crysdir.length() == 0 )
    {
#if defined(__WXGTK__) || defined(__WXMAC__)
		std::cerr << "You must set CRYSDIR before running crystals.\n";
#endif
	} else {
		int nEnv = (CcController::theController)->EnvVarCount( crysdir );
		for ( int i = 0; i < nEnv; ++i )
		{
			string dir = (CcController::theController)->EnvVarExtract( crysdir, i );
#if defined(__WXGTK__) || defined(__WXMAC__)
	        string file = dir + "script/arrowcop.cur";
#endif
#ifdef __BOTHWIN__
	        string file = dir + "script\\arrowcop.cur";
#endif
			m_selectcursor = wxCursor(file, wxBITMAP_TYPE_CUR);
			if (m_selectcursor.IsOk()) break;
		}
	}

	if (! m_selectcursor.IsOk()){
		m_selectcursor = wxCursor(wxCURSOR_CROSS);
	}


#endif
#ifdef __CR_WIN__

CxModel::CxModel(CrModel* container)
      :BASEMODEL()
{
  ptr_to_crObject = container;
  m_hGLContext = NULL;
  m_hPalette = 0;
  m_bitmapbits = NULL;
  m_bitmapinfo = NULL;
#endif
  m_bMouseLeaveInitialised = false;
  m_bitmapok = false;
  m_bNeedReScale = true;
  m_bPickListOK = false;
  m_bFullListOK = false;
  m_bOkToDraw = false;
  m_fastrotate = false;
  m_LitObject = nil;
  m_xTrans = 0.0f ;
  m_yTrans = 0.0f ;
  m_zTrans = 0.0f ;
  m_stretchX = 1.0f ;
  m_stretchY = 1.0f ;
  m_fbsize = 2048;
  m_sbsize = 256;

  m_movingPoint.Set(-1,-1);

  mat = new float[16];

  mat[0] = mat[5] = mat[10] = mat[15] = 1.0f;

           mat[1] = mat[2] = mat[3] = 0.0f;
  mat[4] =          mat[6] = mat[7] = 0.0f;
  mat[8] = mat[9] =          mat[11]= 0.0f;
  mat[12]= mat[13]= mat[14]=          0.0f;

  m_xScale = 1.0f ;

  m_DrawStyle = MODELSMOOTH;
  m_Autosize  = true;
  m_Hover     = false;
  m_Shading   = true;
  m_TextPopup = nil;
  m_selectRect.Set(0,0,0,0);
  m_mouseMode = CXROTATE;
  m_initcolourindex = false;

}


CxModel::~CxModel()
{
  mModelCount--;
  delete [] mat;
  DeletePopup();
#ifdef __BOTHWX__
  delete m_context;
#endif

#ifdef __CR_WIN__
  wglMakeCurrent(NULL,NULL);
  CxModel::last_hdc = NULL;
  wglDeleteContext(m_hGLContext);
  ::ReleaseDC(GetSafeHwnd(), m_hdc);
  if ( m_hPalette ) DeleteObject(m_hPalette);
#endif
}

void CxModel::CxDestroyWindow()
{
#ifdef __CR_WIN__
  DestroyWindow();
#endif
#ifdef __BOTHWX__
  Destroy();
#endif
}

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxModel, CWnd)
   ON_WM_CHAR()
   ON_WM_PAINT()
   ON_WM_LBUTTONUP()
   ON_WM_LBUTTONDOWN()
   ON_WM_RBUTTONUP()
   ON_WM_MOUSEMOVE()
   ON_WM_ERASEBKGND()
   ON_COMMAND_RANGE(kMenuBase, kMenuBase+1000, OnMenuSelected)
   ON_MESSAGE(WM_MOUSELEAVE,   OnMouseLeave)
END_MESSAGE_MAP()
#endif

#ifdef __BOTHWX__

BEGIN_EVENT_TABLE(CxModel, wxGLCanvas)
     EVT_CHAR( CxModel::OnChar )
     EVT_PAINT( CxModel::OnPaint )
     EVT_LEFT_UP( CxModel::OnLButtonUp )
     EVT_LEFT_DOWN( CxModel::OnLButtonDown )
     EVT_RIGHT_UP( CxModel::OnRButtonUp )
     EVT_MOTION( CxModel::OnMouseMove )
     EVT_COMMAND_RANGE(kMenuBase, kMenuBase+1000, wxEVT_COMMAND_MENU_SELECTED, CxModel::OnMenuSelected )
     EVT_ERASE_BACKGROUND ( CxModel::OnEraseBackground )
	 EVT_LEAVE_WINDOW( CxModel::OnMouseLeave )
END_EVENT_TABLE()

#endif


void CxModel::Focus()
{
    SetFocus();
}

CXONCHAR(CxModel)

#ifdef __CR_WIN__

void CxModel::OnPaint()
{
    CPaintDC dc(this); // device context for painting
    setCurrentGL();

#endif

#ifdef __BOTHWX__

void CxModel::OnPaint(wxPaintEvent &event)
{

    if ( ! IsShown() ) return;
    SetCurrent(*m_context);
    wxPaintDC(this);

    if ( m_NotSetupYet ) Setup();

    if ( m_NotSetupYet ) return;

    if ( m_DoNotPaint )
    {
      m_DoNotPaint = false;
      return;
    }
#endif

	bool ok_to_draw = true;
	
	if ( ! m_bFullListOK ) {
        glDeleteLists(MODELLIST,1);
        glNewList( MODELLIST, GL_COMPILE);
        glEnable(GL_LIGHTING);
	    glEnable (GL_BLEND); 
		glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	    glEnable (GL_DITHER);  
        glEnable (GL_COLOR_MATERIAL ) ;
        glEnable(GL_LIGHT0);
	    glShadeModel (GL_SMOOTH);
		ok_to_draw = ((CrModel*)ptr_to_crObject)->RenderModel();
		glEndList();
	}

    if ( ok_to_draw )
    {
        m_bFullListOK = true;
        if ( m_Autosize && m_bNeedReScale )
        {
          AutoScale();
          m_bNeedReScale = false;
        }

        glRenderMode ( GL_RENDER ); //Switching to render mode.
        glViewport(0,0,GetWidth(),GetHeight());

#ifdef __CR_WIN__
      int col = GetSysColor(COLOR_3DFACE);
      glClearColor( GetRValue(col)/255.0f,
                    GetGValue(col)/255.0f,
                    GetBValue(col)/255.0f,  0.0f);
#endif
#ifdef __BOTHWX__
      wxColour col = wxSystemSettings::GetColour( wxSYS_COLOUR_3DFACE );
      glClearColor( col.Red()/255.0f, col.Green()/255.0f, col.Blue()/255.0f,  0.0f);
//      glClearColor( 0.0f,1.0f,0.0f,0.0f);
#endif

      glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

      glMatrixMode ( GL_PROJECTION );

      glLoadIdentity();
      CameraSetup();
	  glPushMatrix();
      GLDrawStyle();
      ModelSetup();
	  
      glCallList( MODELLIST );

      glMatrixMode ( GL_PROJECTION );
      glPopMatrix();
      glMatrixMode ( GL_MODELVIEW );
	  
      glLoadIdentity();
	  
	  
#ifdef __CR_WIN__
      SwapBuffers(m_hdc);
#endif
#ifdef __BOTHWX__
      SwapBuffers();
#endif


      if ( ! m_selectionPoints.empty() )
      {
//Draw in polygon so far:

		glMatrixMode (GL_PROJECTION);
		glLoadIdentity();
		glOrtho(0, GetWidth(), 0, GetHeight(), 1, -1);
		glMatrixMode (GL_MODELVIEW);
		glLoadIdentity();
		glDisable(GL_LIGHTING); //turn off lighting effects
	    glEnable(GL_COLOR_LOGIC_OP);
        glLogicOp(GL_XOR);
		glDisable(GL_DEPTH_TEST);
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

		glBegin(GL_LINES);
        list<CcPoint>::iterator ccpi = m_selectionPoints.begin();
        while ( ccpi != m_selectionPoints.end() ) {
			glVertex2i((*ccpi).x,GetHeight() - (*ccpi).y);
		}
    	glEnd();

        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		glEnable(GL_DEPTH_TEST);
        glDisable(GL_COLOR_LOGIC_OP);
	  }
    }
    else
    {
//      TEXTOUT ( "No model. Displaying banner instead" );
//      PaintBannerInstead ( &dc );
      glRenderMode ( GL_RENDER ); //Switching to render mode.
      glViewport(0,0,GetWidth(),GetHeight());
#ifdef __CR_WIN__
      int col = GetSysColor(COLOR_3DFACE);
      glClearColor( GetRValue(col)/255.0f,
                    GetGValue(col)/255.0f,
                    GetBValue(col)/255.0f,  0.0f);
#endif
#ifdef __BOTHWX__
      wxColour col = wxSystemSettings::GetColour( wxSYS_COLOUR_3DFACE );
      glClearColor( col.Red()/255.0f,
                    col.Green()/255.0f,
                    col.Blue()/255.0f,  0.0f);
#endif
      glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
      glMatrixMode ( GL_PROJECTION );
      glLoadIdentity();
      ModelBackground();
      glMatrixMode ( GL_PROJECTION );
      glPopMatrix();
      glMatrixMode ( GL_MODELVIEW );

#ifdef __CR_WIN__
      SwapBuffers(m_hdc);
#endif
#ifdef __BOTHWX__
      SwapBuffers();
#endif


    }

}


void CxModel::GLDrawStyle()
{
    if ( m_DrawStyle == MODELSMOOTH )
    {
          glPolygonMode(GL_FRONT, GL_FILL);
          glPolygonMode(GL_BACK, GL_FILL);
    }
    if ( m_DrawStyle == MODELLINE )
    {
          glPolygonMode(GL_FRONT, GL_LINE);
          glPolygonMode(GL_BACK, GL_LINE);
    }
    if ( m_DrawStyle == MODELPOINT )
    {
          glPolygonMode(GL_FRONT, GL_POINT);
          glPolygonMode(GL_BACK, GL_POINT);
    }

    glEnable(GL_DEPTH_TEST);
}


#ifdef __CR_WIN__

void CxModel::OnLButtonUp( UINT nFlags, CPoint wpoint )
{

#endif
#ifdef __BOTHWX__

void CxModel::OnLButtonUp( wxMouseEvent & event )
{

#endif

  switch ( m_mouseMode )
  {
    case CXROTATE:
    {
#ifdef __CR_WIN__
      ReleaseCapture();
#endif
#ifdef __BOTHWX__
      if ( m_MouseCaught ){ ReleaseMouse(); m_MouseCaught = false; }
#endif
      if(m_fastrotate)
      {
        m_fastrotate = false;
        m_bFullListOK = false;  //Redraw double bonds perpendicular to viewer
        m_bPickListOK = false;  //Redraw double bonds perpendicular to viewer
        NeedRedraw();
      }
      break;
    }
    case CXRECTSEL:
    {
#ifdef __CR_WIN__
      ReleaseCapture();
#endif
#ifdef __BOTHWX__
      if ( m_MouseCaught ) { ReleaseMouse(); m_MouseCaught = false; }
#endif
      SelectBoxedAtoms(m_selectRect, true);
      ModelChanged(false);
      break;
    }
    case CXPOLYSEL:
    {
//Do nothing
      break;
    }
    case CXZOOM:
    {
      m_mouseMode = CXROTATE;
#ifdef __CR_WIN__
      ReleaseCapture();
#endif
#ifdef __BOTHWX__
      if ( m_MouseCaught ) { ReleaseMouse(); m_MouseCaught = false; }
#endif
      NeedRedraw();
      break;
    }
  }

}

#ifdef __CR_WIN__

void CxModel::OnLButtonDown( UINT nFlags, CPoint wpoint )
{
  CcPoint point(wpoint.x,wpoint.y);

#endif

#if defined(__WXGTK__) || defined(__WXMAC__)

#define MK_CONTROL 1
#define MK_SHIFT 2

#endif

#ifdef __BOTHWX__

void CxModel::OnLButtonDown( wxMouseEvent & event )
{
  CcPoint point ( event.m_x, event.m_y );
  int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
  nFlags |= event.m_shiftDown ? MK_SHIFT : 0 ;

#endif

  if ( nFlags & MK_CONTROL )
  {
    m_mouseMode = CXZOOM; //switch into zoom mode.
    SetAutoSize(false);
    ChooseCursor (CURSORZOOMIN);
  }

  switch ( m_mouseMode )
  {
    case CXROTATE:
    {
#ifdef __CR_WIN__
      SetCapture();
#endif
#ifdef __BOTHWX__
      if ( !m_MouseCaught ) { CaptureMouse(); m_MouseCaught = true; }
#endif
      string atomname;
      CcModelObject* object;
      int type = 0;
      if( type = IsAtomClicked(point.x, point.y, &atomname, &object, false))
      {
//        LOGERR( string(point.x) + ", " + string(point.y) + " " + atomname);
        if ( type == CC_ATOM )
         ((CcModelAtom*)object)->SendAtom( ((CrModel*)ptr_to_crObject)->GetSelectionAction() );
        else if ( type == CC_SPHERE )
         ((CcModelSphere*)object)->SendAtom( ((CrModel*)ptr_to_crObject)->GetSelectionAction() );
        else if ( type == CC_DONUT )
         ((CcModelDonut*)object)->SendAtom( ((CrModel*)ptr_to_crObject)->GetSelectionAction() );
        else if ( type == CC_BOND )
         ((CcModelBond*)object)->SendAtom( ((CrModel*)ptr_to_crObject)->GetSelectionAction() );
      }
      m_ptLDown = point;  //maybe start rotating from here.
      break;
    }
    case CXRECTSEL:
    {
#ifdef __CR_WIN__
      SetCapture();
#endif
#ifdef __BOTHWX__
      if ( !m_MouseCaught ) { CaptureMouse(); m_MouseCaught = true; }
#endif
      m_selectRect.Set(point.y,point.x,point.y,point.x); //start dragging box from here.
      break;
    }
    case CXPOLYSEL:
    {
      m_movingPoint.Set(point.x,point.y);

      if ( !m_selectionPoints.empty() )
      {

        if ( (  ( abs ( m_selectionPoints.front().x - point.x ) < 4  )  &&
                ( abs ( m_selectionPoints.front().y - point.y ) < 4  ) ) ||
             (  ( m_selectionPoints.back().x   == point.x )  &&
                ( m_selectionPoints.back().y   == point.y )     )     )
        {
// Click within 4 pixels of first point to close, or
// Click same point twice to auto-close.
          m_selectionPoints.push_back(m_selectionPoints.front()); // close loop
          CxModel::PolyCheck();   //Do selection
          ModelChanged(false);
          m_selectionPoints.clear();   // Empty container
        }
        else
        {
//Add point to list of selected points.
          m_selectionPoints.push_back(point);
        }
      }
      else
      {
//First point: Add point to list of selected points.
        m_selectionPoints.push_back(point);
      }
      break;
    }
    case CXZOOM:
    {
#ifdef __CR_WIN__
      SetCapture();
#endif
#ifdef __BOTHWX__
      if ( !m_MouseCaught ) { CaptureMouse(); m_MouseCaught = true; }
#endif
      m_ptLDown = point;  //zoom from here.
      break;
    }
  }

/*
      if ( nFlags & MK_CONTROL )    //Zoom out
      {
         if ( m_xScale > 1.0 )
         {
            int winx = GetWidth();
            int winy = GetHeight();
            m_xScale /= 1.2f;
            NewSize(winx,winy);
//            m_Autosize = false;
            NeedRedraw();
         }
      }
      else if ( nFlags & MK_SHIFT  )  //Zoom in
      {
      }
      else
      {

*/

}


#ifdef __BOTHWX__ 
void CxModel::OnMouseLeave(wxMouseEvent & event)
{
    DeletePopup();
    m_bMouseLeaveInitialised = false;
    return;
}
#endif

#ifdef __CR_WIN__
LRESULT CxModel::OnMouseLeave(WPARAM wParam, LPARAM lParam)
{
    DeletePopup();
    m_bMouseLeaveInitialised = false;
        return TRUE;
}

void CxModel::OnMouseMove( UINT nFlags, CPoint wpoint )
{
  bool leftDown = ( (nFlags & MK_LBUTTON) != 0 );
  bool ctrlDown = ( (nFlags & MK_CONTROL) != 0 );
  CcPoint point(wpoint.x,wpoint.y);

#endif

#ifdef __BOTHWX__

void CxModel::OnMouseMove( wxMouseEvent & event )
{
  CcPoint point ( event.m_x, event.m_y );
  int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
  nFlags = event.m_shiftDown ? MK_SHIFT : 0 ;
  bool leftDown = event.m_leftDown;
  bool ctrlDown = event.m_controlDown;
#endif

#ifdef __CR_WIN__
    // now some stuff to find out when the mouse leaves the window (causes a WM_MOUSE_LEAVE message (?))
  if(!m_bMouseLeaveInitialised)
  {
    TRACKMOUSEEVENT tme;
    tme.cbSize = sizeof(tme);
    tme.hwndTrack = m_hWnd;
    tme.dwFlags = TME_LEAVE;
    _TrackMouseEvent(&tme);
    m_bMouseLeaveInitialised = true;
  }
#endif

  switch ( m_mouseMode )
  {
    case CXROTATE:
    {
      if ( leftDown )
      {
        if(m_fastrotate) // already rotating.
        {
          DeletePopup();
          ChooseCursor(CURSORNORMAL);
          if ( m_ptLDown.x - point.x )             // if non-zero
          {
            float rot = (float)(m_ptLDown.x - point.x ) * 0.5f * 3.14f / 180.0f;
            float * cMat = new float[16];
            for ( int i=0; i < 16; i++) cMat[i]=mat[i];
            float cosr = (float)cos(rot);
            float sinr = (float)sin(rot);
            mat[0] = cosr * cMat[0] - sinr * cMat[2]  ;
            mat[4] = cosr * cMat[4] - sinr * cMat[6]  ;
            mat[8] = cosr * cMat[8] - sinr * cMat[10] ;
            mat[2] = sinr * cMat[0] + cosr * cMat[2]  ;
            mat[6] = sinr * cMat[4] + cosr * cMat[6]  ;
            mat[10]= sinr * cMat[8] + cosr * cMat[10] ;
            delete [] cMat;
          }
          if ( m_ptLDown.y - point.y )
          {
            float rot = (float)(m_ptLDown.y - point.y ) * 0.5f * 3.14f / 180.0f;
            float * cMat = new float[16];
            for ( int i=0; i < 16; i++) cMat[i]=mat[i];
            float cosr = (float)cos(rot);
            float sinr = (float)sin(rot);
            mat[1] =  cosr * cMat[1] + sinr * cMat[2] ;
            mat[5] =  cosr * cMat[5] + sinr * cMat[6] ;
            mat[9] =  cosr * cMat[9] + sinr * cMat[10];
            mat[2] = -sinr * cMat[1] + cosr * cMat[2] ;
            mat[6] = -sinr * cMat[5] + cosr * cMat[6] ;
            mat[10]= -sinr * cMat[9] + cosr * cMat[10];
            delete [] cMat;
          }
          if ( ( m_ptLDown.x - point.x ) || ( m_ptLDown.y - point.y ) )
          {
            m_ptLDown = point;
            NeedRedraw(true);
          }
        }
        else   //LBUTTONDOWN, but not rotating yet.
        {
// Start rotating if the mouse moves after the l button goes down.
            if ( point != m_ptLDown ) m_fastrotate = true;
        }
      }
      else    //Lbutton not down, just mouse moving around.
      {
//        ChooseCursor(CURSORNORMAL);
        if( m_fastrotate ) //Was rotating, but now LBUTTON is up. Redraw. (MISSED LBUTTONUP message)
        {
          m_fastrotate = false;
          NeedRedraw(true);
        }
// This bit involves checking the atom list. We should avoid calling
// it if the mouse really hasn't moved. (I think OnMouseMove is called
// repeatedly when the ProgressBar is updated, for example.)
        if ( ( m_ptMMove.x - point.x ) || ( m_ptMMove.y - point.y ) )
        {
          string labelstring;
          ostringstream labelstrm;
          CcModelObject* object;
          int objectType = IsAtomClicked(point.x, point.y, &labelstring, &object);
          if(objectType)
          {
            if(m_LitObject != object) //avoid excesive redrawing, it flickers.
            {
              m_LitObject = object;
              if ( objectType == CC_ATOM && labelstring.length() && ( labelstring[0] == 'Q' ) )
              {
                labelstrm << " " << (float)((CcModelAtom*)object)->sparerad/1000.0;
              }
              if ( objectType == CC_ATOM )
              {
                if ( ((CcModelAtom*)object)->occ != 1000 )
                   labelstrm << " occ:" << (float)((CcModelAtom*)object)->occ/1000.0;
              }
              else if ( objectType == CC_SPHERE )
              {
                labelstrm << " shell occ:" << (float)((CcModelSphere*)object)->occ/1000.0;
              }
              else if ( objectType == CC_DONUT )
              {
                labelstrm << " annulus occ:" << (float)((CcModelDonut*)object)->occ/1000.0;
              }


              CreatePopup(labelstring + string(labelstrm.str()), point);
              if ( objectType != CC_BOND )
                 ChooseCursor(CURSORCOPY);
              else
                 ChooseCursor(CURSORNORMAL);

              (CcController::theController)->SetProgressText(labelstring);
              if ( m_Hover ) NeedRedraw();
            }
          }
          else if (m_LitObject) //Not over an atom anymore.
          {
            m_LitObject = nil;
            (CcController::theController)->SetProgressText("");
            ChooseCursor(CURSORNORMAL);
            DeletePopup();
            if ( m_Hover ) NeedRedraw();
          }
          else
          {
            DeletePopup();
            ChooseCursor(CURSORNORMAL);
          }
        }
      }
      break;
    }
    case CXRECTSEL:
    {
      ChooseCursor(CURSORCROSS);
      if (leftDown)
      {
        CcRect newRect = m_selectRect;
        newRect.mBottom = point.y;
        newRect.mRight  = point.x;

        glRenderMode ( GL_RENDER ); //Switching to render mode.
		glViewport(0, 0, GetWidth(), GetHeight());
		glMatrixMode (GL_PROJECTION);
		glLoadIdentity();
		glOrtho(0, GetWidth(), 0, GetHeight(), 1, -1);
		glMatrixMode (GL_MODELVIEW);
		glLoadIdentity();
		glDisable(GL_LIGHTING); //turn off lighting effects
		glDrawBuffer(GL_FRONT);
	    glEnable(GL_COLOR_LOGIC_OP);
        glLogicOp(GL_XOR);
		glDisable(GL_DEPTH_TEST);
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        glRecti(newRect.mLeft, GetHeight() - newRect.mTop, newRect.mRight,GetHeight() - newRect.mBottom);
        glRecti(m_selectRect.mLeft, GetHeight() - m_selectRect.mTop, m_selectRect.mRight,GetHeight() - m_selectRect.mBottom);
        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		glEnable(GL_DEPTH_TEST);
        glDisable(GL_COLOR_LOGIC_OP);
		glDrawBuffer(GL_BACK);
		glFlush();

        m_selectRect = newRect;
      }
      break;
    }
    case CXPOLYSEL:
    {
      if ( !m_selectionPoints.empty() && ( abs ( m_selectionPoints.front().x - point.x ) < 4  )  &&
            ( abs ( m_selectionPoints.front().y - point.y ) < 4  ) )
      {
          ChooseCursor(CURSORCROSS);
      }
      else
      {
          ChooseCursor(CURSORCOPY);
      }

      if ( !m_selectionPoints.empty() )
      {
	  
        glRenderMode ( GL_RENDER ); //Switching to render mode.
		glViewport(0, 0, GetWidth(), GetHeight());
		glMatrixMode (GL_PROJECTION);
		glLoadIdentity();
		glOrtho(0, GetWidth(), 0, GetHeight(), 1, -1);
		glMatrixMode (GL_MODELVIEW);
		glLoadIdentity();
		glDisable(GL_LIGHTING); //turn off lighting effects
		glDrawBuffer(GL_FRONT);
	    glEnable(GL_COLOR_LOGIC_OP);
        glLogicOp(GL_XOR);
		glDisable(GL_DEPTH_TEST);
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);

		glBegin(GL_LINES);
		glVertex2i(m_selectionPoints.back().x,GetHeight() - m_selectionPoints.back().y);
		glVertex2i(m_movingPoint.x,GetHeight() - m_movingPoint.y);
    	glEnd();
		glBegin(GL_LINES);
		glVertex2i(m_selectionPoints.back().x,GetHeight() - m_selectionPoints.back().y);
		glVertex2i(point.x,GetHeight() - point.y);
    	glEnd();

        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		glEnable(GL_DEPTH_TEST);
        glDisable(GL_COLOR_LOGIC_OP);
		glDrawBuffer(GL_BACK);
		glFlush();

        m_movingPoint.Set(point.x,point.y);
      }
      break;
    }
    case CXZOOM:
    {
      ChooseCursor(CURSORZOOMIN);
      int winx = GetWidth();
      int winy = GetHeight();
      float hDrag = (m_ptMMove.y - point.y)/(float)winy;
      m_xScale += 4.0 * hDrag;
      m_xScale = CRMAX(0.01f,m_xScale);
      m_xScale = CRMIN(100.0f,m_xScale);

	  m_xTrans = 8000.0f * ( (float)m_ptLDown.x / (float)winx ) - 4000.0f; // NB y axis is upside down for OpenGL.
      m_yTrans = 8000.0f * ( (float)m_ptLDown.y / (float)winy ) - 4000.0f;

//      m_xTrans -= m_xTrans / m_xScale ;  //Head back towards the centre
      //m_yTrans -= m_yTrans / m_xScale ;

      NewSize(winx,winy);
//      m_Autosize = false;
      NeedRedraw();
      break;
    }
  }
  m_ptMMove = point;
}

#ifdef __CR_WIN__

void CxModel::OnRButtonUp( UINT nFlags, CPoint wpoint )
{
      CcPoint point(wpoint.x,wpoint.y);

#endif
#ifdef __BOTHWX__

void CxModel::OnRButtonUp( wxMouseEvent & event )
{
  CcPoint point ( event.m_x, event.m_y );

#endif


  if ( m_mouseMode == CXPOLYSEL )
  {
// Cancel polygon selection: Remove points, redraw model, reset mousemode.
     m_selectionPoints.clear();
     NeedRedraw();
     m_mouseMode = CXROTATE;
     return;
  }

  string atomname;

//Some pointers:
  CcModelObject* object;
  CcModelAtom* atom;
  CcModelBond* bond;
//  CrModel* crModel = (CrModel*)ptr_to_crObject;

//decide which menu to show
  int obtype;

  obtype = IsAtomClicked(point.x, point.y, &atomname, &object);

#ifdef __CR_WIN__
    ClientToScreen(&wpoint); // change the coordinates of the click from window to screen coords so that the menu appears in the right place
    point = CcPoint(wpoint.x,wpoint.y);
#endif

  if ( obtype == CC_ATOM || obtype == CC_SPHERE || obtype == CC_DONUT )
  {
    atom = (CcModelAtom*)object;
    if (atom->IsSelected()) // If it's selected pass the atom-clicked, and all the selected atoms.
    {
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y, atomname, 2);
    }
    else //the atom is not selected show a menu applicable to a single atom.
    {
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y, atomname, 3);
    }
  }
  else if ( obtype == CC_BOND )
  {
    bond = (CcModelBond*)object;
    if (bond->m_bondtype == 101) //Aromatic ring:
    {
       atomname = "";
       for (int i = 0; i < bond->m_np; i++ ) {
         atomname += bond->m_patms[i]->Label() + " ";
       }
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y,atomname,6);
    }
    else if (bond->m_bsym) //the bond crosses a symmetry element:
    {
      atomname = bond->m_patms[0]->Label() + " " + bond->m_slabel;
      string atom2 = bond->m_slabel;
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y, atomname, 5, atom2);
    }
    else //a normal bond:
    {
      atomname = bond->m_patms[0]->Label() + " " + bond->m_patms[1]->Label();
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y, atomname, 4);
    }
  }
  else
  {
    ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y,"",1);
  }
}


void CxModel::Setup()
{


#ifdef __BOTHWX__

//   if( !GetContext() ) return;
   m_NotSetupYet = false;

#else

   setCurrentGL();
   
#endif

   glEnable(GL_NORMALIZE);

   glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
   glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
   glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);
   glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);

   GLfloat matDiffuse[] = { 0.8f, 0.8f, 0.8f, 1.0f };
   GLfloat matSpecular[] ={ 0.8f, 0.8f, 0.8f, 1.0f };
   GLfloat matShine[] = { 70.0f };
   glMaterialfv(GL_FRONT, GL_DIFFUSE, matDiffuse);
   glMaterialfv(GL_FRONT, GL_SPECULAR, matSpecular);
   glMaterialfv(GL_FRONT, GL_SHININESS, matShine);

   GLfloat lightDiffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
   GLfloat lightAmbient[] ={ 0.0f, 0.0f, 0.0f, 1.0f };
   GLfloat lightPos[] = { 5000.0f, 5000.0f, 20000.0f, 1.0f };
   glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
   glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
   glLightfv(GL_LIGHT0, GL_POSITION, lightPos);

   glColorMaterial ( GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE ) ;
   glEnable ( GL_COLOR_MATERIAL ) ;
   glEnable(GL_LIGHT0);
   glEnable(GL_LIGHTING);



#ifdef __CR_WIN__

/*        m_bitmapok = true;

        LPCTSTR lpszResourceName = (LPCTSTR)IDB_SPLASH;
        HBITMAP hBmp = (HBITMAP)::LoadImage( AfxGetInstanceHandle(),
                 lpszResourceName, IMAGE_BITMAP, 0,0, LR_CREATEDIBSECTION );

        if( hBmp == NULL )
        {
                m_bitmapok = false;
                return;
        }
        m_bitmap.Attach( hBmp );

        // Create a logical palette for the bitmap
        DIBSECTION ds;
        BITMAPINFOHEADER &bmInfo = ds.dsBmih;
        m_bitmap.GetObject( sizeof(ds), &ds );

        int nColors = bmInfo.biClrUsed ? bmInfo.biClrUsed : 1 << bmInfo.biBitCount;

        // Create a halftone palette if colors > 256.
        CClientDC dc(NULL);                     // Desktop DC
        if( nColors > 256 ) m_pal.CreateHalftonePalette( &dc );
        else
        {
                // Create the palette

                RGBQUAD *pRGB = new RGBQUAD[nColors];
                CDC memDC;
                memDC.CreateCompatibleDC(&dc);

                memDC.SelectObject( &m_bitmap );
                ::GetDIBColorTable( memDC, 0, nColors, pRGB );

                UINT nSize = sizeof(LOGPALETTE) + (sizeof(PALETTEENTRY) * nColors);
                LOGPALETTE *pLP = (LOGPALETTE *) new BYTE[nSize];

                pLP->palVersion = 0x300;
                pLP->palNumEntries = nColors;

                for( int i=0; i < nColors; i++)
                {
                        pLP->palPalEntry[i].peRed = pRGB[i].rgbRed;
                        pLP->palPalEntry[i].peGreen = pRGB[i].rgbGreen;
                        pLP->palPalEntry[i].peBlue = pRGB[i].rgbBlue;
                        pLP->palPalEntry[i].peFlags = 0;
                }

                m_pal.CreatePalette( pLP );

                delete[] pLP;
                delete[] pRGB;
        }
  */
#endif

//        m_bitmapinfo = NULL;
//        LoadDIBitmap("test.bmp");


}


void CxModel::NewSize(int cx, int cy)
{
    setCurrentGL();
    m_stretchX = 1.0f;
    m_stretchY = 1.0f;

#ifdef __CR_WIN__
    glViewport(0,0,cx,cy);
#endif
#ifdef __BOTHWX__
    if ( !m_NotSetupYet ) glViewport(0,0,cx,cy);
#endif

    if ( cy > cx ) m_stretchY = (float)cy / (float)cx;
    else           m_stretchX = (float)cx / (float)cy;


}

void CxModel::CameraSetup()
{
  int ic = 5000;
  glOrtho(-ic * m_stretchX ,ic * m_stretchX ,
          -ic * m_stretchY ,ic * m_stretchY ,
          -ic * m_xScale   ,ic * m_xScale );
}


void CxModel::ModelSetup()
{
   glMatrixMode ( GL_MODELVIEW );
   glLoadIdentity();
   glTranslated ( m_xTrans, m_yTrans, m_zTrans );
   glMultMatrixf ( mat );
   glScalef     ( m_xScale, m_xScale, m_xScale );
}


bool CxModel::setCurrentGL() {
#ifdef __CR_WIN__
      if ( m_hdc == NULL ) return false;
      if ( CxModel::last_hdc == m_hdc ) return true;
      CxModel::last_hdc = m_hdc;
      return wglMakeCurrent(m_hdc, m_hGLContext);
#endif
#ifdef __BOTHWX__
	  if (!IsShownOnScreen()) return false;
	  SetCurrent(*m_context);
      return true;
#endif
}

void CxModel::ModelBackground()
{
#ifdef __CR_WIN__
   int ic = 5000;
   if (m_bitmapinfo)
   {
     float xscale  = (float)GetWidth() / m_bitmapinfo->bmiHeader.biWidth;
     float yscale  = (float)GetHeight() / m_bitmapinfo->bmiHeader.biHeight;
     glRasterPos3f(-ic * m_stretchX, -ic*m_stretchY, ( -ic + 10 ) * m_xScale);
     glPixelZoom(xscale, yscale);
     glDrawPixels(m_bitmapinfo->bmiHeader.biWidth,
                  m_bitmapinfo->bmiHeader.biHeight,
                  GL_BGR_EXT, GL_UNSIGNED_BYTE, m_bitmapbits);
   }
#endif
}

#ifdef __CR_WIN__
BOOL CxModel::SetWindowPixelFormat()
{
    PIXELFORMATDESCRIPTOR pixelDesc;
    int n, GLPixelIndex;
    LOGPALETTE* lpPal;


    memset(&pixelDesc, 0, sizeof(pixelDesc));

    pixelDesc.nSize = sizeof(PIXELFORMATDESCRIPTOR);
    pixelDesc.nVersion = 1;

    pixelDesc.dwFlags = PFD_DRAW_TO_WINDOW |
                        PFD_SUPPORT_OPENGL |
                        PFD_STEREO_DONTCARE|
//						PFD_SUPPORT_COMPOSITION|
                        PFD_DOUBLEBUFFER;

    pixelDesc.iPixelType = PFD_TYPE_RGBA;
    pixelDesc.cColorBits = 32;
    pixelDesc.cDepthBits = 32;
    pixelDesc.iLayerType = PFD_MAIN_PLANE;

    GLPixelIndex = ChoosePixelFormat (m_hdc, &pixelDesc);

    if (GLPixelIndex == 0 )
    {
      CHAR sz[80];
      DWORD dw = GetLastError();
      sprintf (sz, "ChoosePixelFormat failed: Get LastError returned %u\n", dw);
      MessageBox ( sz, "ERROR", MB_OK);
      return false;
    }

    if ( SetPixelFormat(m_hdc, GLPixelIndex, &pixelDesc) == FALSE)
    {
      CHAR sz[80];
      DWORD dw = GetLastError();
      sprintf (sz, "SetPixelFormat failed: Get LastError returned %u\n",
        dw);
      MessageBox ( sz, "ERROR", MB_OK);
      return false;
    }


    DescribePixelFormat(m_hdc, GLPixelIndex, sizeof(PIXELFORMATDESCRIPTOR), &pixelDesc);

    if (pixelDesc.dwFlags & PFD_NEED_PALETTE) {
    n = 1 << pixelDesc.cColorBits;
    if (n > 256) n = 256;

    lpPal = (LOGPALETTE*)malloc(sizeof(LOGPALETTE) +
                    sizeof(PALETTEENTRY) * n);
    memset(lpPal, 0, sizeof(LOGPALETTE) + sizeof(PALETTEENTRY) * n);
    lpPal->palVersion = 0x300;
    lpPal->palNumEntries = n;

    GetSystemPaletteEntries(m_hdc, 0, n, &lpPal->palPalEntry[0]);
    
    /* The pixel type is RGBA, so we want to make an RGB ramp */
        int redMask = (1 << pixelDesc.cRedBits) - 1;
    int greenMask = (1 << pixelDesc.cGreenBits) - 1;
    int blueMask = (1 << pixelDesc.cBlueBits) - 1;
    int i;

        /* fill in the entries with an RGB color ramp. */
    for (i = 0; i < n; ++i) {
      lpPal->palPalEntry[i].peRed = 
        (((i >> pixelDesc.cRedShift)   & redMask)   * 255) / redMask;
      lpPal->palPalEntry[i].peGreen = 
        (((i >> pixelDesc.cGreenShift) & greenMask) * 255) / greenMask;
      lpPal->palPalEntry[i].peBlue = 
        (((i >> pixelDesc.cBlueShift)  & blueMask)  * 255) / blueMask;
      lpPal->palPalEntry[i].peFlags = 0;
    }

    m_hPalette = CreatePalette(lpPal);
    if (m_hPalette) {
        SelectPalette(m_hdc, m_hPalette, FALSE);
        RealizePalette(m_hdc);
    }

    free(lpPal);
    }

    return true;
}

BOOL CxModel::CreateViewGLContext()
{
  m_hGLContext = wglCreateContext(m_hdc);
  if(m_hGLContext ==NULL)
  {
    CHAR sz[80];
    DWORD dw = GetLastError();
    sprintf (sz, "wglCreateContext failed: Get LastError returned %u\n",
      dw);
    MessageBox ( sz, "ERROR", MB_OK);
    return false;
  }

  if(setCurrentGL() == false)
  {
    CHAR sz[80];
    DWORD dw = GetLastError();
    sprintf (sz, "wglMakeCurrent failed: Get LastError returned %u\n",
      dw);
    MessageBox ( sz, "ERROR", MB_OK);
    return false;
  }

  return true;
}
#endif

int CxModel::IsAtomClicked(int xPos, int yPos, string *atomname, CcModelObject **outObject, bool atomsOnly)
{

	bool ok_to_draw = true;

	if ( ! m_bPickListOK ) {
		setCurrentGL();
		glDeleteLists(PICKLIST,1);
		glNewList( PICKLIST, GL_COMPILE);
		bool tex2DIsEnabled = glIsEnabled(GL_TEXTURE_2D);
		glDisable(GL_TEXTURE_2D);
		bool fogIsEnabled = glIsEnabled(GL_FOG);
		glDisable(GL_FOG);
		bool lightIsEnabled = glIsEnabled(GL_LIGHTING);
		glDisable(GL_LIGHTING);
		 
		glDisable (GL_BLEND); 
		glDisable (GL_DITHER);  
		glDisable (GL_TEXTURE_1D); 
		glShadeModel (GL_FLAT);
		glDisable ( GL_COLOR_MATERIAL ) ;

		glDisable(GL_LIGHT0);
	  
		 
                ok_to_draw = ((CrModel*)ptr_to_crObject)->RenderAtoms(true);
		ok_to_draw |= ((CrModel*)ptr_to_crObject)->RenderBonds(true);

		if ( tex2DIsEnabled ) glEnable(GL_TEXTURE_2D);
		if ( fogIsEnabled )  glEnable(GL_FOG);
		if ( lightIsEnabled ) glEnable(GL_LIGHTING);
		
		glEndList();
    }


	
	if ( ok_to_draw ) {

		m_bPickListOK = true;
	
		setCurrentGL();
		glRenderMode ( GL_RENDER ); //Switching to render mode.

		GLint viewport[4];
		glGetIntegerv ( GL_VIEWPORT, viewport ); //Get the current viewport.

		
	  
		glMatrixMode ( GL_PROJECTION );
		glLoadIdentity();
		CameraSetup();
		ModelSetup();
		 
		glClearColor( 0.0f, 0.0f, 0.0f, 0.0f);
		glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

		glCallList( PICKLIST );
		 
		
	//Read back test pixel
		unsigned char pixel[3];
		int rgbHit;
		glReadBuffer(GL_BACK);
		glReadPixels(xPos, viewport[3] - yPos, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, pixel);

                rgbHit = DecodeColour ( pixel );

//                rgbHit= ((pixel[0]&0xff)<<16) | ((pixel[1]&0xff)<<8) | (pixel[2]&0xff);

		if ( rgbHit == 0 ) {
			for ( int range = 1; range < 4; range++ ) {
				for ( int x1 = -range; x1 <= range; ++x1 ) {
					glReadPixels(xPos + x1, viewport[3] - range - yPos, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, pixel);
                                        rgbHit = DecodeColour ( pixel );
					if ( rgbHit ) break;
				}
				if ( rgbHit ) break;
				for ( int x1 = -range; x1 <= range; ++x1 ) {
					glReadPixels(xPos + x1, viewport[3] + range - yPos, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, pixel);
                                        rgbHit = DecodeColour ( pixel );
					if ( rgbHit ) break;
				}
				if ( rgbHit ) break;
				for ( int y1 = -range+1; y1 <= range-1; ++y1 ) {
					glReadPixels(xPos - range, viewport[3] + y1 - yPos, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, pixel);
                                        rgbHit = DecodeColour ( pixel );
					if ( rgbHit ) break;
				}
				if ( rgbHit ) break;
				for ( int y1 = -range; y1 <= range; ++y1 ) {
					glReadPixels(xPos + range, viewport[3] + y1 - yPos, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, pixel);
                                        rgbHit = DecodeColour ( pixel );
					if ( rgbHit ) break;
				}
				if ( rgbHit ) break;
			}
		}
		



		
//		ostringstream o;
//		o << xPos << " " << viewport[3] << " " << yPos << " " << pixel[2];
//		LOGERR(o.str());

	

	/*	ostringstream rrr;
		rrr << (pixel[0]&0xffffff) << " " << (pixel[1]&0xffffff) << " "  << (pixel[2]&0xffffff);
		LOGERR(rrr.str());*/
		 
		if ( rgbHit != 0 ) {

			*outObject = ((CrModel*)ptr_to_crObject)->FindObjectByGLName ( rgbHit );
			if ( *outObject )
			{
				*atomname = (*outObject)->Label();
				return (*outObject)->Type();
			}
	   }
	}
   return 0;
}


void CxModel::AutoScale()
{

   CcRect extentOf2DProjection = ((CrModel*)ptr_to_crObject)->FindModel2DExtent(mat);

   float wscale = 10000.0f  * m_stretchX / (float)(extentOf2DProjection.Width());
   float hscale = 10000.0f  * m_stretchY / (float)(extentOf2DProjection.Height());

   m_xScale = CRMIN ( hscale , wscale ) * 0.95f; //Allow a margin.
   m_xTrans = -(float)(extentOf2DProjection.MidX()) * m_xScale;
   m_yTrans = -(float)(extentOf2DProjection.MidY()) * m_xScale;

}



#ifdef __CR_WIN__
void CxModel::OnMenuSelected(UINT nID)
{

#endif
#ifdef __BOTHWX__
void CxModel::OnMenuSelected(wxCommandEvent & event)
{
      int nID = event.GetId();
#endif

    ((CrModel*)ptr_to_crObject)->MenuSelected( nID );
}


void CxModel::Update(bool rescale)
{
   ModelChanged(rescale);
}


void CxModel::SetIdealHeight(int nCharsHigh)
{
#ifdef __CR_WIN__

    CClientDC cdc(this);
//      cdc.SetBkColor ( RGB ( 255,255,255 ) );
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

void CxModel::SetIdealWidth(int nCharsWide)
{
#ifdef __CR_WIN__

    CClientDC cdc(this);
//    cdc.SetBkColor ( RGB ( 255,255,255 ) );
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;

#endif
#ifdef __BOTHWX__

      mIdealWidth = nCharsWide * 6; //Fix this ! GetCharWidth();

#endif
}

void  CxModel::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
  MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __BOTHWX__
  SetSize(left,top,right-left,bottom-top);
#endif
  NewSize(right-left, bottom-top);
  NeedRedraw(true);
}

CXGETGEOMETRIES(CxModel)


int   CxModel::GetIdealWidth()
{
    return mIdealWidth;
}
int   CxModel::GetIdealHeight()
{
    return mIdealHeight;
}

void CxModel::NeedRedraw(bool needrescale)
{
  m_bNeedReScale = m_bNeedReScale || needrescale;
//  if ( needrescale) TEXTOUT ( "Need Redraw with Rescale" );
//  else TEXTOUT ( "Need Redraw without Rescale" );
#ifdef __CR_WIN__
  InvalidateRect(NULL,false);
#endif
#ifdef __BOTHWX__
  m_DoNotPaint = false;
  Refresh();
#endif
}

void CxModel::ModelChanged(bool needrescale) 
{

  m_bFullListOK = false;
  m_bPickListOK = false;

  NeedRedraw(needrescale);
}

void CxModel::ChooseCursor( int cursor )
{
#ifdef __CR_WIN__

        switch ( cursor )
        {
                case CURSORZOOMIN:
                        SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR2) );
                        break;
                case CURSORZOOMOUT:
                        SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR3) );
                        break;
                case CURSORNORMAL:
                        SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR1) );
                        break;
                case CURSORCROSS:
                        SetCursor( AfxGetApp()->LoadStandardCursor(IDC_CROSS) );
                        break;
                case CURSORCOPY:
                        SetCursor( AfxGetApp()->LoadCursor(IDC_POINTER_COPY) );
                        break;
                default:
                        SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR1) );
                        break;
        }
#endif
#ifdef __BOTHWX__

        switch ( cursor )
        {
                case CURSORZOOMIN:
                        SetCursor( wxCURSOR_MAGNIFIER );
                        break;
                case CURSORZOOMOUT:
                        SetCursor( wxCURSOR_MAGNIFIER );
                        break;
                case CURSORNORMAL:
                        SetCursor( wxCURSOR_ARROW );
                        break;
                case CURSORCROSS:
                        SetCursor( wxCURSOR_CROSS );
                        break;
                case CURSORCOPY:
                        SetCursor( m_selectcursor );
                        break;
                default:
                        SetCursor( wxCURSOR_ARROW );
                        break;
        }
#endif
}

void CxModel::SetDrawStyle( int drawStyle )
{
      m_DrawStyle = drawStyle;
      ModelChanged(false);
}
void CxModel::SetAutoSize( bool size )
{
      m_Autosize = size;
      (CcController::theController)->status.SetZoomedFlag ( !m_Autosize );
      NeedRedraw(size);
}
void CxModel::SetHover( bool hover )
{
      m_Hover = hover;
}
void CxModel::SetShading( bool shade )
{
      m_Shading = shade;
      ModelChanged(false);
}


#ifdef __CR_WIN__

void CxModel::PaintBannerInstead( CPaintDC * dc )
{
  if ( m_bitmapok )
  {
        // Create a memory DC compatible with the paint DC
        CDC banDC;
        banDC.CreateCompatibleDC( dc );

        CBitmap *pBmpOld = banDC.SelectObject( &m_bitmap );

        // Select and realize the palette
        if( dc->GetDeviceCaps(RASTERCAPS) & RC_PALETTE && m_pal.m_hObject != NULL )
        {
                dc->SelectPalette( &m_pal, FALSE );
                dc->RealizePalette();
        }

        CRect rcWnd;
        GetWindowRect( &rcWnd );

        BITMAP bm;
        m_bitmap.GetBitmap(&bm);

        int w = bm.bmWidth;
        int h = bm.bmHeight;

        dc->SetStretchBltMode(COLORONCOLOR);

        dc->StretchBlt(0,0,rcWnd.Width(),rcWnd.Height(),
                   &banDC,
                   0, 0, bm.bmWidth, bm.bmHeight,
                   SRCCOPY);

        // Restore bitmap in banDC
        banDC.SelectObject( pBmpOld );
  }
}

BOOL CxModel::OnEraseBkgnd( CDC* pDC )
{
    return ( TRUE ) ; //prevent flicker
}

#endif

#ifdef __BOTHWX__

void CxModel::PaintBannerInstead( wxPaintDC * dc )
{
  if ( m_bitmapok )
  {
    double x,y;
    dc->GetUserScale(&x,&y);
    dc->SetUserScale( (double)GetWidth() / (double)m_bitmap.GetWidth(),
                      (double)GetHeight()/ (double)m_bitmap.GetHeight()  );
    dc->DrawBitmap(m_bitmap, 0, 0);
    dc->SetUserScale(x,y);
  }
}


void CxModel::OnEraseBackground( wxEraseEvent& evt )
{
    return;  //Reduces flickering. (Window is not erased).
}
#endif

void CxModel::SelectTool ( int toolType )
{
  if (m_mouseMode == CXPOLYSEL)
  {
     ModelChanged(false);
     m_selectionPoints.clear();
  }

  m_mouseMode = toolType;
}


void CxModel::DeletePopup()
{
  if ( m_TextPopup )
  {
#ifdef __CR_WIN__
//    m_TextPopup->DestroyWindow();
    delete m_TextPopup;
#endif
#ifdef __BOTHWX__
    m_TextPopup->Destroy();
    m_DoNotPaint = false;
#endif
    m_TextPopup=nil;
  }
}

void CxModel::CreatePopup(string atomname, CcPoint point)
{
#ifdef __BOTHWX__
  m_DoNotPaint = true;
#endif

  DeletePopup();

#ifdef __CR_WIN__
  string n = string(" ") + atomname + string(" ");

  m_TextPopup = new CStatic();
  m_TextPopup->Create(n.c_str(), SS_SIMPLE|SS_CENTER|WS_BORDER, CRect(0,0,0,0), this);
  m_TextPopup->SetFont(CcController::mp_font);

  CClientDC dc(m_TextPopup);
  CFont* oldFont = dc.SelectObject(CcController::mp_font);

  SIZE size = dc.GetOutputTextExtent(n.c_str(),n.length());
  size.cx += 3;
  size.cy += 2;

  m_TextPopup->ModifyStyleEx(NULL,WS_EX_TOPMOST,0);
  int x = CRMIN(GetWidth() - size.cx, point.x + 20) ;
  x = CRMAX(0,x);
  int y = CRMIN(GetHeight() - size.cy,point.y);
  y = CRMAX(0,y);
  m_TextPopup->MoveWindow(x,y,size.cx,size.cy, FALSE);
  m_TextPopup->ShowWindow(SW_SHOW);
  RedrawWindow();
  dc.SelectObject(oldFont);
#endif
#ifdef __BOTHWX__
  int cx,cy;
  GetTextExtent( atomname.c_str(), &cx, &cy ); //using cxmodel's DC to work out text extent before creation.
                                                   //then can create in one step.
  m_TextPopup = new mywxStaticText(this, -1, atomname.c_str(),
                                 wxPoint(CRMAX(0,point.x-cx-4),CRMAX(0,point.y-cy-4)),
                                 wxSize(cx+4,cy+4),
                                 wxALIGN_CENTER|wxSIMPLE_BORDER) ;
//  m_TextPopup->SetEvtHandlerEnabled(true);

#endif
}


void CxModel::LoadDIBitmap(string filename)
{
#ifdef __CR_WIN__
    if ( m_bitmapbits ) delete [] m_bitmapbits;
    if ( m_bitmapinfo ) delete [] m_bitmapinfo;
    m_bitmapbits = NULL;
    m_bitmapinfo = NULL;

    NeedRedraw(false);

    HANDLE hFileHandle;
    unsigned long lInfoSize = 0;
    unsigned long lBitSize = 0;
    int nTextureWidth;
    int nTextureHeight;

// Open the Bitmap file
    hFileHandle = CreateFile(filename.c_str(),GENERIC_READ,FILE_SHARE_READ,NULL,OPEN_EXISTING,FILE_FLAG_SEQUENTIAL_SCAN,NULL);

// Check for open failure (most likely file does not exist).
    if(hFileHandle == INVALID_HANDLE_VALUE) return;

// File is Open. Read in bitmap header information
    BITMAPFILEHEADER        bitmapHeader;
    DWORD dwBytes;
    ReadFile(hFileHandle,&bitmapHeader,sizeof(BITMAPFILEHEADER), &dwBytes,NULL);

    if(dwBytes != sizeof(BITMAPFILEHEADER)) 
    {
        CloseHandle(hFileHandle);
        MessageBox ( "File is corrupt or not a device-independent bitmap", "ERROR", MB_OK);
        return;
    }

// Check format of bitmap file
    if(bitmapHeader.bfType != 'MB') 
    {
        CloseHandle(hFileHandle);
        MessageBox ( "File is not a 24-bit device-independent bitmap", "ERROR", MB_OK);
        return;
    }

// Read in bitmap information structure
    lInfoSize = bitmapHeader.bfOffBits - sizeof(BITMAPFILEHEADER);
    m_bitmapinfo = (BITMAPINFO *) new BYTE[lInfoSize];
    ReadFile(hFileHandle,m_bitmapinfo,lInfoSize,&dwBytes,NULL);

    if(dwBytes != lInfoSize) 
    {
        if(m_bitmapinfo) delete [] m_bitmapinfo;
        m_bitmapinfo = NULL;
        CloseHandle(hFileHandle);
        MessageBox ( "While reading bitmap header - file is corrupt", "ERROR", MB_OK);
        return;
    }

    if ( m_bitmapinfo->bmiHeader.biBitCount != 24 )
    {
        if(m_bitmapinfo) delete [] m_bitmapinfo;
        m_bitmapinfo = NULL;
        CloseHandle(hFileHandle);
        MessageBox ( "Bitmap is not 24-bit DIB.", "ERROR", MB_OK);
        return;
    }



    nTextureWidth = m_bitmapinfo->bmiHeader.biWidth;
    nTextureHeight = m_bitmapinfo->bmiHeader.biHeight;
    lBitSize = m_bitmapinfo->bmiHeader.biSizeImage;
    if(lBitSize == 0) lBitSize = (nTextureWidth * m_bitmapinfo->bmiHeader.biBitCount + 7) / 8 * abs(nTextureHeight);
    
// Allocate space for the actual bitmap
    m_bitmapbits = new BYTE[lBitSize];

// Read in the bitmap bits
    ReadFile(hFileHandle,m_bitmapbits,lBitSize,&dwBytes,NULL);

    if(lBitSize != dwBytes)
    {
        if(m_bitmapbits) delete [] (BYTE *) m_bitmapbits;
        m_bitmapbits = NULL;
        if(m_bitmapinfo) delete [] m_bitmapinfo;
        m_bitmapinfo = NULL;
        CloseHandle(hFileHandle);
        MessageBox ( "While reading bitmap data - file is corrupt", "ERROR", MB_OK);
        return;
    }

    CloseHandle(hFileHandle);

// This is specific to the binary format of the data read in.
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1); 
    glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
    glPixelStorei(GL_UNPACK_SKIP_ROWS, 0);
    glPixelStorei(GL_UNPACK_SKIP_PIXELS, 0);

#endif
    return;
}

void CxModel::PolyCheck()
{
    if ( m_selectionPoints.size() < 3 ) return;

    std::list<Cc2DAtom> atoms = ((CrModel*)ptr_to_crObject)->AtomCoords2D(mat);
	for ( std::list<Cc2DAtom>::iterator atom=atoms.begin(); atom != atoms.end(); ++atom) {
		CcPoint atomxy = AtomCoordsToScreenCoords((*atom).p);
// Imagine a horizontal line drawn from the current atom 
// to the right. If it cuts the polygon an odd number
// of times, then it is inside.
// Check each atom in turn and add up the number of crossings.
// A crossing occurs iff:
//   1. The y-coord of the atom lies inbetween the y-coords of
//      the ends of the line.
//   2. The point of intersection of our imaginary horizonatal line and
//      the extrapolated polygon line lies on the polygon line.
//   3. The x-coord of our atom is less than the x-coord of intersection.
		int crossings = 0;
		list<CcPoint>::iterator line_start, line_end;
		line_start = line_end = m_selectionPoints.begin();
		line_end++;
		while ( line_end != m_selectionPoints.end() ) {
            if (  ( ( (*line_start).y < atomxy.y ) && ( (*line_end).y > atomxy.y ) ) ||
               ( ( (*line_start).y > atomxy.y ) && ( (*line_end).y < atomxy.y ) )    )  { // line ends y range includes this atom	
			    float invgrad = 1000000.0f; // Avoid divide by zero:
                if ( (*line_end).y - (*line_start).y != 0 )  {
			      invgrad = (float)((*line_end).x - (*line_start).x) / (float)((*line_end).y - (*line_start).y);
			    }
                float xCut = ( (*line_start).x + ( (atomxy.y - (*line_start).y) * invgrad ) );

                if ( ( ( ( (*line_start).x < xCut ) && ( (*line_end).x > xCut ) ) ||
                   ( ( (*line_start).x > xCut ) && ( (*line_end).x < xCut ) )    ) &&
                 ( atomxy.x < xCut ) ) {
                    crossings++;
                }
            }
            line_start++;
            line_end++;
        }
        if ( crossings % 2 != 0 ) {
  		    CcModelObject* atomp = ((CrModel*)ptr_to_crObject)->FindObjectByGLName((*atom).id);
			if ( atomp ) atomp->SendAtom( ((CrModel*)ptr_to_crObject)->GetSelectionAction() );
        }
	}
}


CcPoint CxModel::AtomCoordsToScreenCoords(CcPoint atomCoords) {
// normal display procedure:
// take objects (atomcoords)
// scale   (m_xscale)
// rotate (mat)
// translate a bit (m_xtrans)
// display on 10000 x 10000-ish ortho projection.


/*   float wscale = 10000.0f  * m_stretchX / (float)(extentOf2DProjection.Width());
   float hscale = 10000.0f  * m_stretchY / (float)(extentOf2DProjection.Height());

   m_xScale = CRMIN ( hscale , wscale ) * 0.95f; //Allow a margin.
   m_xTrans = -(float)(extentOf2DProjection.MidX()) * m_xScale;
   m_yTrans = -(float)(extentOf2DProjection.MidY()) * m_xScale;
*/

    CcPoint ret( (int)(atomCoords.x*m_xScale), -(int)(atomCoords.y*m_xScale));
	ret += CcPoint((int)m_xTrans,-(int)m_yTrans);

    setCurrentGL();
    GLint viewport[4];
    glGetIntegerv ( GL_VIEWPORT, viewport ); //Get the current viewport.

    ret.x = (int)(( ret.x * viewport[2] )/ (10000.0f  * m_stretchX ));
    ret.y = (int)(( ret.y * viewport[3] )/ (10000.0f  * m_stretchY ));
	
	ret.x += ( viewport[2] / 2 );
	ret.y += ( viewport[3] / 2 );
	
	return ret;
}

void CxModel::SelectBoxedAtoms(CcRect rectangle, bool select)
{
    std::list<Cc2DAtom> atoms = ((CrModel*)ptr_to_crObject)->AtomCoords2D(mat);

	for ( std::list<Cc2DAtom>::iterator atom=atoms.begin(); atom != atoms.end(); ++atom) {

		CcPoint c = AtomCoordsToScreenCoords((*atom).p);

		if ( rectangle.Contains( c.x, c.y ) ) {
     		CcModelAtom* atomp = (CcModelAtom*)((CrModel*)ptr_to_crObject)->FindObjectByGLName((*atom).id);
//			if ( atomp ) atomp->Select();
			if ( atomp ) atomp->SendAtom( ((CrModel*)ptr_to_crObject)->GetSelectionAction() );
		}
		
	}

}
