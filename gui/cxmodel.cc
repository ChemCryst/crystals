////////////////////////////////////////////////////////////////////////
//  CRYSTALS Interface      Class CxModel
////////////////////////////////////////////////////////////////////////

#include    "crystalsinterface.h"
#include    <math.h>
#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "ccrect.h"
#include    "cxmodel.h"
#include    "crmodel.h"
#include    "ccmodelatom.h"
#include    "creditbox.h"
#include    "cccontroller.h"
#include    "resource.h"
#include    <GL/glu.h>

int CxModel::mModelCount = kModelBase;

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

  theModel -> ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
  theModel -> SetFont(CcController::mp_font);

  CRect rect;
  CClientDC dc(theModel);

  HDC hdc = ::GetDC(theModel->GetSafeHwnd());

  if( ( theModel->SetWindowPixelFormat(hdc) ) == false )
  {
    delete theModel;
    return nil;
  }
  if ( ( theModel->CreateViewGLContext( hdc ) ) == false )
  {
    delete theModel;
    return nil;
  }


  theModel->Setup();

#endif
#ifdef __BOTHWX__

  CxModel *theModel = new CxModel((wxWindow*)guiParent,-1, wxPoint(0,0), wxSize(10,10), wxSUNKEN_BORDER);
  theModel->ptr_to_crObject = container;
  theModel->Setup();

#endif

  return theModel;
}

#ifdef __BOTHWX__

CxModel::CxModel(wxWindow *parent, wxWindowID id, const wxPoint& pos, const wxSize& size,
                 long style, const wxString& name): wxGLCanvas(parent, id, pos, size, style, name)
{

    m_DoNotPaint = false;

#endif
#ifdef __CR_WIN__

CxModel::CxModel(CrModel* container)
      :BASEMODEL()
{
  ptr_to_crObject = container;
  m_hGLContext = NULL;
#endif

  m_bitmapok = false;
  m_bNeedReScale = true;
  m_bModelChanged = true;
  m_bFullListOk = false;
  m_bQuickListOk = false;
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
  m_selectionPoints = nil;
  m_nSelectionPoints = 0;
  m_selectRect.Set(0,0,0,0);
  m_mouseMode = CXROTATE;
}


CxModel::~CxModel()
{
  mModelCount--;
  delete [] mat;
  DeletePopup();

#ifdef __CR_WIN__
  wglMakeCurrent(NULL,NULL);
  wglDeleteContext(m_hGLContext);
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
    HDC hdc = ::GetDC ( GetSafeHwnd() );
    wglMakeCurrent(hdc, m_hGLContext);
#endif

#ifdef __BOTHWX__

void CxModel::OnPaint(wxPaintEvent &event)
{
    wxPaintDC dc (this);
    dc.SetUserScale( 1.0,1.0 );
    SetCurrent();
    if ( m_DoNotPaint )
    {
      TEXTOUT ( "OnPaint: Not painting" );
      m_DoNotPaint = false;
      return;
    }
#endif

    TEXTOUT ( "OnPaint" );
    Boolean ok_to_draw = true;

    if (m_bModelChanged)
    {
// re-render the full detail model.
      TEXTOUT ( "Redrawing model from scratch" );
      DoDrawingLists();
      ok_to_draw = ((CrModel*)ptr_to_crObject)->RenderModel(true);
      m_bFullListOk = true;
    }

    if ( ok_to_draw )
    {
      TEXTOUT ( "Displaying model" );
      if ( m_Autosize && m_bNeedReScale )
      {
        AutoScale();
        m_bNeedReScale = false;
      }

      glClearColor( 1.0f,1.0f,1.0f,0.0f);
      glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

      glMatrixMode ( GL_PROJECTION );
      glLoadIdentity();
      CameraSetup();
      ModelSetup();
      if ( m_fastrotate && !m_bModelChanged ) //If the model has changed, the QLISTS aren't ready yet.
      {
        glCallList( STYLIST );
        glCallList( QATOMLIST );
        glCallList( QBONDLIST );
      }
      else
      {
        glCallList( STYLIST );
        glCallList( ATOMLIST );
        glCallList( BONDLIST );
        glCallList( XOBJECTLIST );
      }
      glMatrixMode ( GL_PROJECTION );
      glPopMatrix();
      glMatrixMode ( GL_MODELVIEW );

//This is only needed while we draw directly onto the GDI
      glFinish();
// if we changed to GLUT fonts instead, we could just call glFlush(), which doesn't block.

#ifdef __CR_WIN__
      SwapBuffers(hdc);
#endif
#ifdef __BOTHWX__
      SwapBuffers();
#endif

      if (m_bModelChanged)
      {
// Now that the display is out of the way, render the quick
// model to the quick display lists.
        TEXTOUT ( "Redrawing quick model from scratch" );
        ok_to_draw = ((CrModel*)ptr_to_crObject)->RenderModel(false);
        m_bModelChanged = false;
        m_bQuickListOk = true;
      }


    }
    else
    {
      TEXTOUT ( "No model. Displaying banner instead" );
      PaintBannerInstead ( &dc );
    }
}


void CxModel::DoDrawingLists()
{
    glNewList( STYLIST, GL_COMPILE);

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

    if ( m_Shading )
    {
            GLfloat LightAmbient[] = { 0.1f, 0.1f, 0.1f, 0.1f };
            GLfloat LightDiffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
            GLfloat LightSpecular[] ={ 1.0f, 1.0f, 1.0f, 1.0f };
            glLightfv(GL_LIGHT0, GL_AMBIENT, LightAmbient);
            glLightfv(GL_LIGHT0, GL_DIFFUSE, LightDiffuse);
            glLightfv(GL_LIGHT0, GL_SPECULAR, LightSpecular);
    }
    else
    {
            GLfloat LightDiffuse[] = { 0.7f, 0.7f, 0.7f, 0.7f };
            glLightfv(GL_LIGHT0, GL_DIFFUSE, LightDiffuse);
    }
    glEnable(GL_LIGHT0);
    glEnable(GL_LIGHTING);
    glEnable(GL_DEPTH_TEST);

    glEndList();

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
      ReleaseMouse();
#endif
      if(m_fastrotate)
      {
        m_fastrotate = false;
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
      ReleaseMouse();
#endif
      SelectBoxedAtoms(m_selectRect, true);
      ModelChanged();
      break;
    }
    case CXPOLYSEL:
    {
      LOGERR ("Polygon select not implemented");
      m_mouseMode = CXROTATE;
      break;
    }
    case CXZOOM:
    {
      m_mouseMode = CXROTATE;
#ifdef __CR_WIN__
      ReleaseCapture();
#endif
#ifdef __BOTHWX__
      ReleaseMouse();
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

#ifdef __LINUX__

#define MK_CONTROL 1
#define MK_SHIFT 2

#endif

#ifdef __BOTHWX__

void CxModel::OnLButtonDown( wxMouseEvent & event )
{
  CcPoint point ( event.m_x, event.m_y );
  int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
  nFlags = event.m_shiftDown ? MK_SHIFT : 0 ;

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
      CaptureMouse();
#endif
      CcString atomname;
      CcModelObject* object;
      if( IsAtomClicked(point.x, point.y, &atomname, &object, true))
      {
         ((CcModelAtom*)object)->SendAtom( ((CrModel*)ptr_to_crObject)->GetSelectionAction() );
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
      CaptureMouse();
#endif
      m_selectRect.Set(point.y,point.x,point.y,point.x); //start dragging box from here.
      break;
    }
    case CXPOLYSEL:
    {
      LOGERR ("Polygon select not implemented");
      break;
    }
    case CXZOOM:
    {
#ifdef __CR_WIN__
      SetCapture();
#endif
#ifdef __BOTHWX__
      CaptureMouse();
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



#ifdef __CR_WIN__

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
            float rot = (float)(m_ptLDown.x - point.x ) * 3.14f / 180.0f;
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
            float rot = (float)(m_ptLDown.y - point.y ) * 3.14f / 180.0f;
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
          CcString labelstring;
          CcModelObject* object;
          int objectType = IsAtomClicked(point.x, point.y, &labelstring, &object);
          if(objectType)
          {
            if(m_LitObject != object) //avoid excesive redrawing, it flickers.
            {
              m_LitObject = object;
              if ( objectType == CC_ATOM && labelstring.Length() && ( labelstring.Sub(1,1) == "Q" ) )
              {
                labelstring += "  " + CcString ((float)((CcModelAtom*)object)->sparerad/1000.0);
              }
              CreatePopup(labelstring, point);
              ChooseCursor(CURSORCOPY);
              (CcController::theController)->SetProgressText(&labelstring);
              if ( m_Hover ) NeedRedraw();
            }
          }
          else if (m_LitObject) //Not over an atom anymore.
          {
            m_LitObject = nil;
            (CcController::theController)->SetProgressText(NULL);
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
#ifdef __CR_WIN__
        CClientDC dc(this);
        CcRect newRect = m_selectRect;
        newRect.mBottom = point.y;
        newRect.mRight  = point.x;
        dc.DrawDragRect(&newRect.Sort().Native(), CSize(1,1), &m_selectRect.Sort().Native(), CSize(1,1),NULL,NULL);
        m_selectRect = newRect;
#endif
#ifdef __BOTHWX__
        wxClientDC dc(this);
        CcRect newRect = m_selectRect;
        newRect.mBottom = point.y;
        newRect.mRight  = point.x;
        dc.SetLogicalFunction( wxINVERT );
        dc.DrawRectangle(newRect.mLeft, newRect.mTop, newRect.Width(), newRect.Height() );
        dc.DrawRectangle(m_selectRect.mLeft, m_selectRect.mTop, m_selectRect.Width(), m_selectRect.Height() );
        m_selectRect = newRect;
#endif
      }
      break;
    }
    case CXPOLYSEL:
    {
      LOGERR ("Polygon select not implemented");
      break;
    }
    case CXZOOM:
    {
      ChooseCursor(CURSORZOOMIN);
      int winx = GetWidth();
      int winy = GetHeight();
      float hDrag = (m_ptMMove.y - point.y)/(float)winy;
      m_xScale += hDrag;
      m_xScale = max(0.01f,m_xScale);
      m_xScale = min(100.0f,m_xScale);
//      m_xTrans = 8000.0f * ( (float)m_ptLDown.x / (float)winx ) - 4000.0f; // NB y axis is upside down for OpenGL.
//      m_yTrans = 8000.0f * ( (float)m_ptLDown.y / (float)winy ) - 4000.0f;

//      m_xTrans -= m_xTrans / m_xScale ;  //Head back towards the centre
//      m_yTrans -= m_yTrans / m_xScale ;

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

  CcString atomname;
  CcModelObject* object;
  CcModelAtom* atom;
  CrModel* crModel = (CrModel*)ptr_to_crObject;

//decide which menu to show

  if( IsAtomClicked(point.x, point.y, &atomname, &object, true) )
  {
    atom = (CcModelAtom*)object;
    
#ifdef __CR_WIN__

    ClientToScreen(&wpoint); // change the coordinates of the click from window to screen coords so that the menu appears in the right place
    point = CcPoint(wpoint.x,wpoint.y);

#endif

    if (atom->IsSelected()) // If it's selected pass the atom-clicked, and all the selected atoms.
    {
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y, atomname, true);
    }
    else //the atom is not selected show a menu applicable to a single atom.
    {
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y, atomname);
    }
  }
  else
  {
#ifdef __CR_WIN__

    ClientToScreen(&wpoint); // change the coordinates of the click from window to screen coords so that the menu appears in the right place
    point = CcPoint(wpoint.x,wpoint.y);

#endif
    ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y);
  }
}


void CxModel::Setup()
{

#ifdef __BOTHWX__

   if( !GetContext() )
   {
      m_glContext = new wxGLContext( true, this,
                                    wxNullPalette, NULL ); //m_sharedContext );
   }
   SetCurrent();

#endif
            glEnable(GL_NORMALIZE);

            glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
            glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
            glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
            glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);


            GLfloat LightAmbient[] = { 0.1f, 0.1f, 0.1f, 0.1f };
            GLfloat LightDiffuse[] = { 0.7f, 0.7f, 0.7f, 0.7f };
            GLfloat LightSpecular[] ={ 1.0f, 1.0f, 1.0f, 1.0f };

            glLightfv(GL_LIGHT0, GL_AMBIENT, LightAmbient);
            glLightfv(GL_LIGHT0, GL_DIFFUSE, LightDiffuse);
            glLightfv(GL_LIGHT0, GL_SPECULAR, LightSpecular);
//            glLightModelf( GL_LIGHT_MODEL_TWO_SIDE, 1.0);

            glEnable(GL_LIGHT0);
            glEnable(GL_LIGHTING);


// This is for the PaintBannerInstead() function.
#ifdef __BOTHWX__
        wxBitmap newbit(wxBITMAP(IDB_SPLASH));
        m_bitmap = newbit;
        m_bitmapok = m_bitmap.Ok();
#endif

#ifdef __CR_WIN__

        m_bitmapok = true;

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

#endif
}


void CxModel::NewSize(int cx, int cy)
{
#ifdef __CR_WIN__
    HDC hdc = ::GetDC ( GetSafeHwnd() );
    wglMakeCurrent(hdc, m_hGLContext);
#endif
#ifdef __BOTHWX__
      SetCurrent();
#endif
    m_stretchX = 1.0f;
    m_stretchY = 1.0f;

    glViewport(0,0,cx,cy);

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

#ifdef __CR_WIN__

BOOL CxModel::SetWindowPixelFormat(HDC hdc)
{
    PIXELFORMATDESCRIPTOR pixelDesc;
    memset(&pixelDesc, 0, sizeof(pixelDesc));

    pixelDesc.nSize = sizeof(PIXELFORMATDESCRIPTOR);
    pixelDesc.nVersion = 1;

    pixelDesc.dwFlags = PFD_DRAW_TO_WINDOW |
                        PFD_SUPPORT_OPENGL |
                        PFD_STEREO_DONTCARE|
                        PFD_DOUBLEBUFFER;

    pixelDesc.iPixelType = PFD_TYPE_RGBA;
    pixelDesc.cColorBits = 32;
    pixelDesc.cDepthBits = 32;
    pixelDesc.iLayerType = PFD_MAIN_PLANE;

    int GLPixelIndex = ChoosePixelFormat (hdc, &pixelDesc);

    if (GLPixelIndex == 0 )
    {
      CHAR sz[80];
      DWORD dw = GetLastError();
      sprintf (sz, "ChoosePixelFormat failed: Get LastError returned %u\n", dw);
      MessageBox ( sz, "ERROR", MB_OK);
      return false;
    }

    if ( SetPixelFormat(hdc, GLPixelIndex, &pixelDesc) == FALSE)
    {
      CHAR sz[80];
      DWORD dw = GetLastError();
      sprintf (sz, "SetPixelFormat failed: Get LastError returned %u\n",
        dw);
      MessageBox ( sz, "ERROR", MB_OK);
      return false;
    }

    return true;
}

BOOL CxModel::CreateViewGLContext(HDC hDC)
{
  m_hGLContext = wglCreateContext(hDC);
  if(m_hGLContext ==NULL)
  {
    CHAR sz[80];
    DWORD dw = GetLastError();
    sprintf (sz, "SetPixelFormat failed: Get LastError returned %u\n",
      dw);
    MessageBox ( sz, "ERROR", MB_OK);
    return false;
  }

  if(wglMakeCurrent(hDC, m_hGLContext) == false)
  {
    CHAR sz[80];
    DWORD dw = GetLastError();
    sprintf (sz, "SetPixelFormat failed: Get LastError returned %u\n",
      dw);
    MessageBox ( sz, "ERROR", MB_OK);
    return false;
  }

  return true;
}
#endif

int CxModel::IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelObject **outObject, Boolean atomsOnly)
{
   GLint viewport[4];
   glGetIntegerv ( GL_VIEWPORT, viewport ); //Get the current viewport.

   GLuint selectbuf[400]; //space for 100 hits.
   glSelectBuffer ( 400, selectbuf ); //Allocate space for 100 hit objects

   bool repeat = true;
   int tolerance = 0;
   int hits = 0;
  
   while ( repeat )
   {
       
//For debugging comment out next line and uncomment the SwapBuffers line below.
     glRenderMode ( GL_SELECT ); //Instead of rendering, tell OpenGL to put stuff in the SelectBuffer.

     glInitNames();  //Initialise names stack (names are just INTs, but will be unique for each atom and bond.)
     glPushName( 0 ); //Push a value onto the stack, it is replaced by each LoadName call during rendering.


     glMatrixMode ( GL_PROJECTION );
     glPushMatrix();
     glLoadIdentity();
     gluPickMatrix ( xPos, viewport[3] - yPos, tolerance+1, tolerance+1, viewport );
     CameraSetup();
     ModelSetup();
     glCallList( QATOMLIST );
     if ( tolerance == 0 && !atomsOnly ) glCallList( BONDLIST ); // Only select bonds if right over them.
     glMatrixMode ( GL_PROJECTION );
     glPopMatrix();
     glMatrixMode ( GL_MODELVIEW );

#ifdef __CR_WIN__
//For debug uncomment next line and comment the glRenderMode line above.
//    HDC hdc = ::GetDC ( GetSafeHwnd() ); wglMakeCurrent(hdc, m_hGLContext); SwapBuffers (hdc);
#endif

     hits = glRenderMode ( GL_RENDER ); //Switching back to render mode, return value is number of objects hit.

     if ( hits || tolerance )  repeat = false;
     tolerance = 19; // If nothing under the mouse select things close by.
   }

   if ( hits < 0 )
   {
     hits = -hits;
     LOGERR ( "Hit test buffer overflow - contact richard.cooper@chem.ox.ac.uk");
   }

//Hit records in selectbuf have the form:
// uint Number of names (this will always be 1, because we are careful only to call PushName once.)
// uint Min depth of hit primitive
// uint Max depth of hit primitive
// uint Name

   if ( hits )
   {
//     TEXTOUT ( CcString ( hits ) + " hits" );
     GLuint highest_point = selectbuf[1];
     GLuint highest_name = selectbuf[3];
     for ( int i = 1; i<hits; i++ )
     {
       if ( selectbuf[ (i*4) + 2 ] < highest_point )
       {
         highest_point = selectbuf[ (i*4) + 1 ];
         highest_name  = selectbuf[ (i*4) + 3 ];
       }
     }

     *outObject = ((CrModel*)ptr_to_crObject)->FindObjectByGLName ( highest_name );



     if ( *outObject )
     {
       *atomname = (*outObject)->Label();
       return (*outObject)->Type();
     }

   }
   return 0;
}


void CxModel::SelectBoxedAtoms(CcRect rectangle, bool select)
{
   GLint viewport[4];
   glGetIntegerv ( GL_VIEWPORT, viewport ); //Get the current viewport.

   GLuint * selectbuf;

   bool repeat = true;
   int hits = 0;
  
   while ( repeat )
   {
     selectbuf = new GLuint[m_sbsize];
     glSelectBuffer ( m_sbsize, selectbuf );
       
     glRenderMode ( GL_SELECT ); //Instead of rendering, tell OpenGL to put stuff in the SelectBuffer.

     glInitNames();  //Initialise names stack (names are just INTs, but will be unique for each atom and bond.)
     glPushName( 0 ); //Push a value onto the stack, it is replaced by each LoadName call during rendering.

     glMatrixMode ( GL_PROJECTION );
     glPushMatrix();
     glLoadIdentity();
     gluPickMatrix ( rectangle.MidX(), viewport[3] - rectangle.MidY(), rectangle.Sort().Width(), rectangle.Sort().Height(), viewport );
     CameraSetup();
     ModelSetup();
     glCallList( ATOMLIST );
     glMatrixMode ( GL_PROJECTION );
     glPopMatrix();
     glMatrixMode ( GL_MODELVIEW );

     hits = glRenderMode ( GL_RENDER ); //Switching back to render mode, return value is number of objects hit.

     if ( hits >= 0 )
     {
       repeat = false;
     }
     else
     {
       repeat = true;
       delete [] selectbuf;
       m_sbsize = m_sbsize * 2;
       LOGSTAT ( "Select buffer overflows, doubling size to " + CcString (m_sbsize) );
     }
   }

//Hit records in selectbuf have the form:
// uint Number of names (this will always be 1, because we are careful only to call PushName once.)
// uint Min depth of hit primitive
// uint Max depth of hit primitive
// uint Name

   CcModelAtom* atom;
   for ( int i = 0; i<hits; i++ )
   {
     atom = (CcModelAtom*)((CrModel*)ptr_to_crObject)->FindObjectByGLName(selectbuf[(i*4)+3]);
     if ( atom ) atom->Select();
   }
   delete [] selectbuf;
}

void CxModel::AutoScale()
{

//   TEXTOUT ( "Autoscale" );
   GLint viewport[4];
   glGetIntegerv ( GL_VIEWPORT, viewport ); //Get the current viewport.

   GLfloat *feedbuf;

   Boolean bigger_buf_needed = true;
   int hits = 0;

   while ( bigger_buf_needed )
   {

     feedbuf = new GLfloat[m_fbsize];

     glFeedbackBuffer ( m_fbsize, GL_2D, feedbuf ); 
  
     glRenderMode ( GL_FEEDBACK ); //Instead of rendering, tell OpenGL to put stuff in the FeedBackBuffer.

//     glClearColor( 1.0f,1.0f,1.0f,0.0f);
//     glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
     glMatrixMode ( GL_PROJECTION );
     glLoadIdentity();
     CameraSetup();
//Can't use ModelSetup() as it translates & scales the molecule!
     glMatrixMode ( GL_MODELVIEW );
     glLoadIdentity();
     glMultMatrixf ( mat );
     if ( m_bQuickListOk )
     {
       glCallList( QATOMLIST );
       glCallList( QBONDLIST );
     }
     else
     {
       glCallList( ATOMLIST );
       glCallList( BONDLIST );
     }
     glMatrixMode ( GL_PROJECTION );
     glMatrixMode ( GL_MODELVIEW );

     hits = glRenderMode ( GL_RENDER ); //Switching back to render mode, return value is number of objects hit.

     if ( hits < 0 )
     {
       delete [] feedbuf;
       m_fbsize = m_fbsize * 2;
       LOGSTAT ( "Feedback buffer overflows, doubling size to " + CcString (m_fbsize) );
       bigger_buf_needed = true;
     }
     else
     {
       bigger_buf_needed = false;
     }        
   }

   CcRect enclosed;
   enclosed.Set( viewport[3], viewport[2],
                 viewport[1], viewport[0] );

   int point = hits, nVert, token;
   while ( point > 0 )
   {
     token = (int)feedbuf [ hits - point ];
     switch ( token ) {
     case GL_PASS_THROUGH_TOKEN:
       point--;
       break;
     case GL_POINT_TOKEN:
     case GL_BITMAP_TOKEN:
     case GL_DRAW_PIXEL_TOKEN:
     case GL_COPY_PIXEL_TOKEN:
       point--;
       point -= AdjustEnclose( &enclosed, feedbuf, hits-point );
       break;
     case GL_LINE_TOKEN:
     case GL_LINE_RESET_TOKEN:
       point--;
       point -= AdjustEnclose( &enclosed, feedbuf, hits-point );
       point -= AdjustEnclose( &enclosed, feedbuf, hits-point );
       break;
     case GL_POLYGON_TOKEN:
       point--;
       nVert = (int)feedbuf[hits-point];
       point--;
       for (; nVert > 0; nVert--)
         point -= AdjustEnclose( &enclosed, feedbuf, hits-point );
       break;
     default:
       LOGERR ( "Unknown GL feedback token - contact richard.cooper@chem.ox.ac.uk");
       point--;
     }
   }


   float wscale = (float)viewport[2] / (float)enclosed.Width() ;
   float hscale = (float)viewport[3] / (float)enclosed.Height() ;

   m_xScale = min ( hscale , wscale ) * 0.9f; //Allow a margin.

   float xpoffset = ((float)viewport[2]/2.0f)-(float)enclosed.MidX();
   float ypoffset = ((float)viewport[3]/2.0f)-(float)enclosed.MidY();

   float xmoffset = xpoffset * 10000.0f / (float) min ( viewport[2], viewport[3] );
   float ymoffset = ypoffset * 10000.0f / (float) min ( viewport[2], viewport[3] );

   m_xTrans = xmoffset * m_xScale;
   m_yTrans = ymoffset * m_xScale;

   delete [] feedbuf;
}



int CxModel::AdjustEnclose( CcRect* enc, GLfloat* buf, int point )
{
  enc->mLeft   = min( (int)buf[point],   enc->mLeft );
  enc->mRight  = max( (int)buf[point],   enc->mRight );
  enc->mTop    = min( (int)buf[point+1], enc->mTop );
  enc->mBottom = max( (int)buf[point+1], enc->mBottom );
  return 2;
}

#ifdef __CR_WIN__
void CxModel::OnMenuSelected(int nID)
{

#endif
#ifdef __BOTHWX__
void CxModel::OnMenuSelected(wxCommandEvent & event)
{
      int nID = event.m_id;
#endif

    ((CrModel*)ptr_to_crObject)->MenuSelected( nID );
}


void CxModel::Update()
{
   ModelChanged();
}


void CxModel::SetIdealHeight(int nCharsHigh)
{
#ifdef __CR_WIN__

    CClientDC cdc(this);
      cdc.SetBkColor ( RGB ( 255,255,255 ) );
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
    cdc.SetBkColor ( RGB ( 255,255,255 ) );
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
  if ( needrescale) TEXTOUT ( "Need Redraw with Rescale" );
  else TEXTOUT ( "Need Redraw without Rescale" );
#ifdef __CR_WIN__
  InvalidateRect(NULL,false);
#endif
#ifdef __BOTHWX__
  Refresh();
#endif
}

void CxModel::ModelChanged()
{
//  TEXTOUT ( "Model changed" );
  m_bModelChanged = true;
  m_bFullListOk = false;
  m_bQuickListOk = false;
  NeedRedraw(true);
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
}

void CxModel::SetDrawStyle( int drawStyle )
{
      m_DrawStyle = drawStyle;
      ModelChanged();
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
      ModelChanged();
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
    dc->SetUserScale( (double)GetWidth() / (double)m_bitmap.GetWidth(),
                      (double)GetHeight()/ (double)m_bitmap.GetHeight()  );
    dc->DrawBitmap(m_bitmap, 0, 0);
  }
}


void CxModel::OnEraseBackground( wxEraseEvent& evt )
{
    return;  //Reduces flickering. (Window is not erased).
}
#endif

void CxModel::SelectTool ( int toolType )
{
  m_mouseMode = toolType;
}


void CxModel::DeletePopup()
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

void CxModel::CreatePopup(CcString atomname, CcPoint point)
{
#ifdef __BOTHWX__
  m_DoNotPaint = true;
#endif

  DeletePopup();

#ifdef __CR_WIN__
  CClientDC dc(this);
  CFont* oldFont = dc.SelectObject(CcController::mp_font);
  SIZE size = dc.GetOutputTextExtent(atomname.ToCString());
  dc.SelectObject(oldFont);

  m_TextPopup = new CStatic();
  m_TextPopup->Create(atomname.ToCString(), SS_CENTER|WS_BORDER, CRect(CPoint(-size.cx-10,-size.cy-10),CSize(size.cx+4,size.cy+2)), this);
  m_TextPopup->SetFont(CcController::mp_font);
  m_TextPopup->ModifyStyleEx(NULL,WS_EX_TOPMOST,0);
  m_TextPopup->ShowWindow(SW_SHOW);
  m_TextPopup->MoveWindow(max(0,point.x-size.cx-4),max(0,point.y-size.cy-4),size.cx+4,size.cy+2, FALSE);
  m_TextPopup->InvalidateRect(NULL,false);
#endif
#ifdef __BOTHWX__
  int cx,cy;
  GetTextExtent( atomname.ToCString(), &cx, &cy ); //using cxmodel's DC to work out text extent before creation.
                                                   //then can create in one step.
  m_TextPopup = new wxStaticText(this, -1, atomname.ToCString(),
                                 wxPoint(max(0,point.x-cx-4),max(0,point.y-cy-4)),
                                 wxSize(cx+4,cy+4),
                                 wxALIGN_CENTER|wxSIMPLE_BORDER) ;
#endif
}
