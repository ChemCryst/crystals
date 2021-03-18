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
#ifdef CRY_OSMAC
#include    <OpenGL/glu.h>
#else
#include    <GL/glu.h>
#endif

#ifndef PFD_SUPPORT_COMPOSITION
#define PFD_SUPPORT_COMPOSITION 0x00008000
#endif


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





int CxModel::mModelCount = kModelBase;


CxModel * CxModel::CreateCxModel( CrModel * container, CxGrid * guiParent )
{

  int args[] = {WX_GL_RGBA, WX_GL_DOUBLEBUFFER, WX_GL_DEPTH_SIZE, 16, 0};

  if (! CxModel::IsDisplaySupported(args)) {
	LOGERR( "One or more display attributes not supported ( RGBA, DOUBLEBUFFER, DEPTH 4). Checking individually:");
	int arga[] = {WX_GL_RGBA, 0};
	if (CxModel::IsDisplaySupported(arga)) {
		LOGERR( "RGBA ok");
	} else {
		LOGERR( "RGBA not supported");
	}
	int argb[] = {WX_GL_DOUBLEBUFFER, 0};
	if (CxModel::IsDisplaySupported(argb)) {
		LOGERR( "DOUBLEBUFFER ok");
	} else {
		LOGERR( "DOUBLEBUFFER not supported");
	}
	int argc[] = {WX_GL_DEPTH_SIZE, 32, 0};
	if (CxModel::IsDisplaySupported(argc)) {
		LOGERR( "DEPTHSIZE 32 ok");
	} else {
		LOGERR( "DEPTHSIZE 32 not supported");
	}
	int argd[] = {WX_GL_DEPTH_SIZE, 16, 0};
	if (CxModel::IsDisplaySupported(argd)) {
		LOGERR( "DEPTHSIZE 16 ok");
	} else {
		LOGERR( "DEPTHSIZE 16 not supported");
	}
	int arge[] = {WX_GL_DEPTH_SIZE, 4, 0};
	if (CxModel::IsDisplaySupported(arge)) {
		LOGERR( "DEPTHSIZE 4 ok");
	} else {
		LOGERR( "DEPTHSIZE 4 not supported");
	}
	 LOGERR( "Continuing, some functionality may not work. Send Script.log to Richard Cooper for help.");
  }
  
  //  int args[] = {WX_GL_RGBA, WX_GL_DOUBLEBUFFER, 0};
  CxModel *theModel = new CxModel((wxWindow*)guiParent, args);
  theModel->ptr_to_crObject = container;
  theModel->Show();
//  theModel->Setup();

  return theModel;
}


//CxModel::CxModel(wxWindow *parent, wxWindowID id, int* args, long style, const wxString& name): wxGLCanvas(parent, wxID_ANY, wxDefaultPosition, wxDefaultSize, style|wxFULL_REPAINT_ON_RESIZE)
CxModel::CxModel(wxWindow *parent, int * args): wxGLCanvas(parent, wxID_ANY, args, wxDefaultPosition, wxDefaultSize, wxFULL_REPAINT_ON_RESIZE)
{
	m_context = new wxGLContext(this);
    m_DoNotPaint = false;
    m_NotSetupYet = true;
    m_MouseCaught = false;
// This is for the PaintBannerInstead() function.
//    wxBitmap newbit = wxBitmap(wxBITMAP(IDB_SPLASH));
//    m_bitmap = newbit;
//    m_bitmap = newbit.GetSubBitmap(wxRect(0, 0, newbit.GetWidth(), newbit.GetHeight()));
//    m_bitmapok = m_bitmap.Ok();

    string crysdir ( getenv("CRYSDIR") );
    if ( crysdir.length() == 0 )
    {
#ifndef CRY_OSWIN32
		std::cerr << "You must set CRYSDIR before running crystals.\n";
#endif
	} else {
		int nEnv = (CcController::theController)->EnvVarCount( crysdir );
		for ( int i = 0; i < nEnv; ++i )
		{
			string dir = (CcController::theController)->EnvVarExtract( crysdir, i );
#ifndef CRY_OSWIN32
	        string file = dir + "script/arrowcop.cur";
#else	
	        string file = dir + "script\\arrowcop.cur";
#endif
			m_selectcursor = wxCursor(file, wxBITMAP_TYPE_CUR);
			if (m_selectcursor.IsOk()) break;
		}
	}

	if (! m_selectcursor.IsOk()){
		m_selectcursor = wxCursor(wxCURSOR_CROSS);
	}


  m_bMouseLeaveInitialised = false;
//  m_bitmapok = false;
  m_bNeedReScale = true;
  m_bPickListOK = false;
  m_bPixelsOK = false;
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
  m_pixels = nil;
  m_pixels_w = 0;
  m_pixels_h = 0;

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
  m_MessagePopup = nil;
  m_selectRect.Set(0,0,0,0);
  m_mouseMode = CXROTATE;
  m_initcolourindex = false;

}


CxModel::~CxModel()
{
  mModelCount--;
  delete [] mat;
  delete m_pixels;
  DeletePopup();
  DeleteMessagePopup(0);
  delete m_context;

}

void CxModel::CxDestroyWindow()
{
  Destroy();
}

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


void CxModel::Focus()
{
    SetFocus();
}

CXONCHAR(CxModel)


void CxModel::OnPaint(wxPaintEvent &event)
{

	GLenum glerr ;
	
	glerr = glGetError();
	if ( glerr != GL_NO_ERROR ) {
		ostringstream o;
		o << "GL error at start of OnPaint: " << glerr;
		LOGERR(o.str());
	}


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

	glerr = glGetError();
	if ( glerr != GL_NO_ERROR ) {
		ostringstream o;
		o << "GL error at MODELLIST creation OnPaint: " << glerr;
		LOGERR(o.str());
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

      wxColour col = wxSystemSettings::GetColour( wxSYS_COLOUR_3DFACE );
      glClearColor( col.Red()/255.0f, col.Green()/255.0f, col.Blue()/255.0f,  0.0f);

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
	  
	  glFlush();
  
      SwapBuffers();

      glerr = glGetError();
      if ( glerr != GL_NO_ERROR ) {
		ostringstream o;
		o << "GL error at SwapBuffers in OnPaint: " << glerr;
		LOGERR(o.str());
	  }

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
      wxColour col = wxSystemSettings::GetColour( wxSYS_COLOUR_3DFACE );
      glClearColor( col.Red()/255.0f,
                    col.Green()/255.0f,
                    col.Blue()/255.0f,  0.0f);
      glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
      glMatrixMode ( GL_PROJECTION );
      glLoadIdentity();
//      ModelBackground();
      glMatrixMode ( GL_PROJECTION );
//      glPopMatrix();
      glMatrixMode ( GL_MODELVIEW );

      SwapBuffers();

      glerr = glGetError();
      if ( glerr != GL_NO_ERROR ) {
		ostringstream o;
		o << "GL error at no model SwapBuffers in OnPaint: " << glerr;
		LOGERR(o.str());
	  }
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



void CxModel::OnLButtonUp( wxMouseEvent & event )
{


  switch ( m_mouseMode )
  {
    case CXROTATE:
    {
      if ( m_MouseCaught ){ ReleaseMouse(); m_MouseCaught = false; }
      if(m_fastrotate)
      {
        m_fastrotate = false;
        m_bFullListOK = false;  //Redraw double bonds perpendicular to viewer
        m_bPickListOK = false;  //Redraw double bonds perpendicular to viewer
	    m_bPixelsOK = false;
        NeedRedraw();
      }
      break;
    }
    case CXRECTSEL:
    {
      if ( m_MouseCaught ) { ReleaseMouse(); m_MouseCaught = false; }
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
      if ( m_MouseCaught ) { ReleaseMouse(); m_MouseCaught = false; }
      NeedRedraw();
      break;
    }
  }

}


  #ifndef CRY_OSWIN32

    #define MK_CONTROL 1
    #define MK_SHIFT 2

  #endif


void CxModel::OnLButtonDown( wxMouseEvent & event )
{
  CcPoint point ( event.m_x, event.m_y );
  int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
  nFlags |= event.m_shiftDown ? MK_SHIFT : 0 ;


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
      if ( !m_MouseCaught ) { CaptureMouse(); m_MouseCaught = true; }
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
      if ( !m_MouseCaught ) { CaptureMouse(); m_MouseCaught = true; }
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
      if ( !m_MouseCaught ) { CaptureMouse(); m_MouseCaught = true; }
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



void CxModel::OnMouseLeave(wxMouseEvent & event)
{
	if ( m_TextPopup ) {
//Don't delete popup if we are over it - mouseleave event is
//generated.
		if ( m_TextPopup->GetRect().Contains( event.GetPosition() ) ) return; 
	}
    DeletePopup();
    m_bMouseLeaveInitialised = false;
    return;
}

void CxModel::OnMouseMove( wxMouseEvent & event )
{
  CcPoint point ( event.m_x, event.m_y );
  int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
  nFlags = event.m_shiftDown ? MK_SHIFT : 0 ;
  bool leftDown = event.m_leftDown;
  bool ctrlDown = event.m_controlDown;


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
                if ( ((CcModelAtom*)object)->m_isflg )
                   labelstrm << " " << ((CcModelAtom*)object)->m_sflags;
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


void CxModel::OnRButtonUp( wxMouseEvent & event )
{
  CcPoint point ( event.m_x, event.m_y );



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



//   if( !GetContext() ) return;
   m_NotSetupYet = false;


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




//        m_bitmapinfo = NULL;
//        LoadDIBitmap("test.bmp");


}


void CxModel::NewSize(int cx, int cy)
{
    setCurrentGL();
    m_stretchX = 1.0f;
    m_stretchY = 1.0f;

    if ( !m_NotSetupYet ) glViewport(0,0,cx,cy);

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
	  if (!IsShownOnScreen()) return false;
	  SetCurrent(*m_context);
      return true;
}


int CxModel::IsAtomClicked(int xPos, int yPos, string *atomname, CcModelObject **outObject, bool atomsOnly)
{

	GLenum glerr;
	bool ok_to_draw = true;
	int rgbHit = 0;


	if ( ! m_bPickListOK ) {
		setCurrentGL();
		glerr = glGetError();
		if ( glerr != GL_NO_ERROR ) {
			ostringstream o;
			o << "GL error after setCurrentGL (pick list): " << glerr;
			LOGERR(o.str());
		}

		glDeleteLists(PICKLIST,1);

		glerr = glGetError();
		if ( glerr != GL_NO_ERROR ) {
			ostringstream o;
			o << "GL error after glDeleteLists (pick list): " << glerr;
			LOGERR(o.str());
		}

		glNewList( PICKLIST, GL_COMPILE);
		
		glerr = glGetError();
		if ( glerr != GL_NO_ERROR ) {
			ostringstream o;
			o << "GL error after glNewList (pick list): " << glerr;
			LOGERR(o.str());
		}
		
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


		if ( ok_to_draw ) m_bPickListOK = true;

		if ( tex2DIsEnabled ) glEnable(GL_TEXTURE_2D);
		if ( fogIsEnabled )  glEnable(GL_FOG);
		if ( lightIsEnabled ) glEnable(GL_LIGHTING);
		
		glEndList();
		
		glerr = glGetError();
		if ( glerr != GL_NO_ERROR ) {
			ostringstream o;
			o << "GL error after glEndList (pick list): " << glerr;
			LOGERR(o.str());
		}

		
	} 

	if ( m_pixels_w != GetWidth() ||	m_pixels_h != GetHeight() ) {  //sneaky resize
		m_bPixelsOK = false;
	}

	if ( (! m_bPixelsOK) && ok_to_draw ) {
		
		delete m_pixels;
    	m_pixels = new unsigned char[4 * GetWidth() * GetHeight()];
		m_pixels_w = GetWidth();
		m_pixels_h = GetHeight();

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
//		unsigned char pixel[4];
		glReadBuffer(GL_BACK);
//		glReadPixels(xPos, viewport[3] - yPos, 1, 1, GL_RGB, GL_UNSIGNED_BYTE, pixel);
		glReadPixels(0, 0, m_pixels_w, m_pixels_h, GL_RGBA, GL_UNSIGNED_BYTE, m_pixels);
		glerr = glGetError();
		if ( glerr != GL_NO_ERROR ) {
			ostringstream o;
			o << "GL error after glReadPixels: " << glerr;
			LOGERR(o.str());
		}
		
		m_bPixelsOK = true;
	}

	if ( m_bPixelsOK ) {

  // Avoid testing over the edges by moving the tested pixel a bit
		int xAdj = max(xPos,3);
		int yAdj = max(yPos,3);
		xAdj = min(xAdj, m_pixels_w - 4);
		yAdj = min(yAdj, m_pixels_h - 4);

  //Coordinates of pixels to test (starting a centre and going out in shells)
        int testx[49] = {0,  
                         -1, -1, -1,   0,  0,   1,  1,  1,  
                         -2, -2, -2,  -2, -2,  -1, -1,  0, 0,  1, 1,  2,  2, 2, 2, 2  
                         -3, -3, -3, -3, -3, -3, -3, -2, -2, -1, -1, 0, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 3};
		
        int testy[49] = {0,  
                         -1,  0,  1,  -1,  1,  -1,  0,  1,  
                         -2, -1,  0,   1,  2,  -2,  2, -2, 2, -2, 2, -2, -1, 0, 1, 2
                         -3, -2,  -1, 0, 1, 2, 3, -3, 3, -3, 3, -3, 3, -3, 3, -3, 3, -3, -2,  -1, 0, 1, 2, 3 };

		for ( int i = 0; i < 49; ++i ){
            rgbHit = DecodeColour ( & m_pixels[4* (xAdj + testx[i] + ( m_pixels_h - yAdj - 1 - testy[i] ) * m_pixels_w )] );
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
		ostringstream o;
		o << "Mouse over object id: " << rgbHit;
		LOGERR(o.str());

		*outObject = ((CrModel*)ptr_to_crObject)->FindObjectByGLName ( rgbHit );
		if ( *outObject )
		{
			*atomname = (*outObject)->Label();
			return (*outObject)->Type();
		}
		
		ostringstream o2;
		o2 << "Mouse over object id: " << rgbHit << " no object with that id found";
		LOGERR(o2.str());
		
   }
   
	LOGERR("rgbHit is zero at mouse position");
   
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



void CxModel::OnMenuSelected(wxCommandEvent & event)
{
      int nID = event.GetId();

    ((CrModel*)ptr_to_crObject)->MenuSelected( nID );
}


void CxModel::CxUpdate(bool rescale)
{
   ModelChanged(rescale);
}


void CxModel::SetIdealHeight(int nCharsHigh)
{

      mIdealHeight = nCharsHigh * GetCharHeight();

}

void CxModel::SetIdealWidth(int nCharsWide)
{

      mIdealWidth = nCharsWide * 6; //Fix this ! GetCharWidth();

}

void  CxModel::SetGeometry( int top, int left, int bottom, int right )
{
  SetSize(left,top,right-left,bottom-top);
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
  m_DoNotPaint = false;
  Refresh();
//   Update();
}

void CxModel::ModelChanged(bool needrescale) 
{

  m_bFullListOK = false;
  m_bPickListOK = false;
  m_bPixelsOK = false;

  NeedRedraw(needrescale);
}

void CxModel::ChooseCursor( int cursor )
{
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



/*void CxModel::PaintBannerInstead( wxPaintDC * dc )
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
*/

void CxModel::OnEraseBackground( wxEraseEvent& evt )
{
    return;  //Reduces flickering. (Window is not erased).
}

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
    m_TextPopup->Destroy();
//    m_DoNotPaint = false;
	NeedRedraw(false);
    m_TextPopup=nil;
  }
}

void CxModel::OrganizeMessagePopups() 
{
    map<int,mywxStaticText*>::iterator mi;
    int offset = 2;
    for ( mi=messages.begin(); mi != messages.end(); ++mi) {
          mywxStaticText* mst = (*mi).second;
         mst->Move(2,offset);

         offset += mst->GetSize().GetHeight() + 2;
    }
    
}

void CxModel::DeleteMessagePopup(int id)   // default remove all messages
{
  map<int,mywxStaticText*>::iterator mi = messages.find(id);
  if ( mi != messages.end() ){
      (*mi).second->Destroy();
      messages.erase(mi);
//      m_MessagePopup->Destroy();
      OrganizeMessagePopups();
      NeedRedraw(false);
  }
//      m_MessagePopup=nil;

}

void CxModel::CreatePopup(string atomname, CcPoint point)
{
  DeletePopup();

  int cx,cy;
  GetTextExtent( atomname.c_str(), &cx, &cy ); //using cxmodel's DC to work out text extent before creation.
                                                   //then can create in one step.
  m_TextPopup = new mywxStaticText(this, -1, atomname.c_str(),
                                 wxPoint(CRMAX(0,point.x-cx-9),CRMAX(0,point.y-cy-9)),
                                 wxSize(cx+4,cy+4),
                                 wxALIGN_CENTER|wxSIMPLE_BORDER) ;

}

//Popup a status / info / warning message at top left corner. Message replaces previous message.
void CxModel::CreateMessagePopup(string message, int id)
{
  DeleteMessagePopup(id);

  int cx,cy;
  GetTextExtent( message.c_str(), &cx, &cy ); //using cxmodel's DC to work out text extent before creation.
                                                   //then can create in one step.
  mywxStaticText* messagePopup = new mywxStaticText(this, -1, message.c_str(),
                                 wxPoint(2,2),
                                 wxSize(cx+4,cy+4),
                                 wxALIGN_CENTER|wxSIMPLE_BORDER) ;
  messages.insert(make_pair(id, messagePopup));
  OrganizeMessagePopups();
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
