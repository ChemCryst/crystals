////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxModel
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

  if ( theModel -> memDC.CreateCompatibleDC(&dc) == 0 )
  {
    ::MessageBox ( NULL, "CreateCompatibleDC in modelwindow failed", "Error", MB_OK) ;
    delete theModel;
    return nil;
  }
  theModel -> newMemDCBitmap = new CBitmap;
  theModel -> GetClientRect ( &rect );

  if ( theModel -> newMemDCBitmap -> CreateCompatibleBitmap(&dc,rect.Width(),rect.Height()) == 0 )
  {
    ::MessageBox ( NULL, "CreateCompatibleDC in modelwindow failed", "Error", MB_OK) ;
    delete theModel;
    return nil;
  }

  theModel -> oldMemDCBitmap = theModel -> memDC.SelectObject ( theModel -> newMemDCBitmap );
  if ( theModel -> memDC.PatBlt(0,0,rect.Width(),rect.Height(),WHITENESS) == 0 )
  {
    ::MessageBox ( NULL, "PatBlt in modelwindow failed", "Error", MB_OK) ;
    delete theModel;
    return nil;
  }


///  HDC hdc = ::GetDC(theModel->GetSafeHwnd());

  if((theModel->SetWindowPixelFormat(&(theModel -> memDC) ))==false)
  {
    delete theModel;
    return nil;
  }
  if((theModel->CreateViewGLContext(theModel -> memDC.m_hDC)) ==false)
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

#endif
#ifdef __CR_WIN__

CxModel::CxModel(CrModel* container)
      :BASEMODEL()
{
  ptr_to_crObject = container;
  m_hGLContext = NULL;
  m_bitmapok = true;

#endif

  m_bNeedUpdate = true;
  m_bOkToDraw = false;
  m_radius = COVALENT;
  m_radscale = 1.0f;
  m_fastrotate = false;
  m_LitAtom = nil;
  m_xTrans = 0.0f ;
  m_yTrans = 0.0f ;
  m_zTrans = 0.0f ;

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
  delete newMemDCBitmap;
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

#endif

#ifdef __BOTHWX__

void CxModel::OnPaint(wxPaintEvent &event)
{
    wxPaintDC dc (this);
#endif

    if (m_bNeedUpdate)
    {
//      TEXTOUT ( "Redrawing" );
      DoDrawingInMemory();
      m_bNeedUpdate = false;
    }

//    TEXTOUT ( "Bliting" );

    CRect rect;
    GetClientRect(&rect);

    if ( m_bOkToDraw ) dc.BitBlt(0,0,rect.Width(),rect.Height(),&memDC,0,0,SRCCOPY);
    else               PaintBannerInstead ( &dc );
}


void CxModel::DoDrawingInMemory()
{
#ifdef __CR_WIN__
    wglMakeCurrent(memDC.m_hDC, m_hGLContext);
#endif
#ifdef __BOTHWX__
    SetCurrent();
#endif

    glClearColor( 1.0f,1.0f,1.0f,0.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

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
    glLightModelf( GL_LIGHT_MODEL_TWO_SIDE, 1.0);

    if ( m_Autosize )
    {
           AutoScale();
    }

    glPushMatrix();

    // translate and scale here if needed.
    float degToRad = 3.1415926535f / 180.0f;

    glTranslated ( m_xTrans, m_yTrans, m_zTrans );
    glMultMatrixf ( mat );
    glScalef     ( m_xScale, m_xScale, m_xScale );


    m_bOkToDraw = ((CrModel*)ptr_to_crObject)->RenderModel(!m_fastrotate);


    glPopMatrix();
    glFinish();

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
      ReleaseCapture();
      if(m_fastrotate)
      {
        m_fastrotate = false;
        NeedRedraw();
      }
      break;
    }
    case CXRECTSEL:
    {
      ReleaseCapture();
      SelectBoxedAtoms(m_selectRect, true);
      NeedRedraw();
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
      ReleaseCapture();
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
      SetCapture();
      CcString atomname;
      CcModelAtom* atom;
      if(IsAtomClicked(point.x, point.y, &atomname, &atom))
      {
         ((CrModel*)ptr_to_crObject)->SendAtom(atom);
      }
      m_ptLDown = point;  //maybe start rotating from here.
      break;
    }
    case CXRECTSEL:
    {
      SetCapture();
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
      SetCapture();
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
            NeedRedraw();
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
          NeedRedraw();
        }
// This bit involves checking the atom list. We should avoid calling
// it if the mouse really hasn't moved. (I think this routine is called
// repeatedly when the ProgressBar is updated, for example.)
        if ( ( m_ptMMove.x - point.x ) || ( m_ptMMove.y - point.y ) )
        {
          CcString atomname;
          CcModelAtom* atom;
          if(IsAtomClicked(point.x, point.y, &atomname, &atom))
          {
            if(m_LitAtom != atom) //avoid excesive redrawing, it flickers.
            {
              m_LitAtom = atom;
              if ( atomname.Length() && ( atomname.Sub(1,1) == "Q" ) )
              {
                atomname = atomname + "  " + CcString ((float)atom->sparerad/1000.0);
              }
              CreatePopup(atomname, point);
              ChooseCursor(CURSORCOPY);
              (CcController::theController)->SetProgressText(&atomname);
              if ( m_Hover ) NeedRedraw();
            }
          }
          else if (m_LitAtom) //Not over an atom anymore.
          {
            m_LitAtom = nil;
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
        CClientDC dc(this);
        CcRect newRect = m_selectRect;
        newRect.mBottom = point.y;
        newRect.mRight  = point.x;
        dc.DrawDragRect(&newRect.Sort().Native(), CSize(1,1), &m_selectRect.Sort().Native(), CSize(1,1),NULL,NULL);
        m_selectRect = newRect;
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
  CcModelAtom* atom;
  CrModel* crModel = (CrModel*)ptr_to_crObject;

//decide which menu to show

  if(IsAtomClicked(point.x, point.y, &atomname, &atom))
  {
#ifdef __CR_WIN__

    ClientToScreen(&wpoint); // change the coordinates of the click from window to screen coords so that the menu appears in the right place
    point = CcPoint(wpoint.x,wpoint.y);

#endif

    if (atom->IsSelected()) // If it's selected pass the atom-clicked, and all the selected atoms.
    {
      int nSelected;
      CcModelAtomPtr* atoms = crModel->GetSelectedAtoms(&nSelected);
      CcString* atomNames = new CcString[nSelected];
      for (int i = 0; i < nSelected; i++) atomNames[i] = atoms[i].atom->Label();
      ((CrModel*)ptr_to_crObject)->ContextMenu(point.x,point.y, atomname, nSelected, atomNames);
      delete [] atomNames;
      delete [] atoms;
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
            glLightModelf( GL_LIGHT_MODEL_TWO_SIDE, 1.0);

            glEnable(GL_LIGHT0);
            glEnable(GL_LIGHTING);


// This is for the PaintBannerInstead() function.
#ifdef __CR_WIN__

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


#ifdef __BOTHWX__
      SetCurrent();
#endif
    int icx = 5000;
    int icy = 5000;
    glViewport(0,0,cx,cy);
    if (cx > cy) icx = (int) ( ( 5000.0 * cx ) / cy );
    else         icy = (int) ( ( 5000.0 * cy ) / cx );

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-icx,icx,-icy,icy,-5000*m_xScale,5000*m_xScale);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glEnable(GL_LIGHTING);
    glEnable(GL_DEPTH_TEST);

}

#ifdef __CR_WIN__

BOOL CxModel::SetWindowPixelFormat(CDC* cDC)
{

    CBitmap* pBitmap = cDC->GetCurrentBitmap() ;
    BITMAP bmInfo ;
    pBitmap->GetObject(sizeof(BITMAP), &bmInfo) ;

    PIXELFORMATDESCRIPTOR pixelDesc;
    memset(&pixelDesc, 0, sizeof(pixelDesc));

    pixelDesc.nSize = sizeof(PIXELFORMATDESCRIPTOR);
    pixelDesc.nVersion = 1;

    pixelDesc.dwFlags = PFD_DRAW_TO_BITMAP |
                        PFD_SUPPORT_OPENGL |
                        PFD_STEREO_DONTCARE;

    pixelDesc.iPixelType = PFD_TYPE_RGBA;
    pixelDesc.cColorBits = (BYTE)bmInfo.bmBitsPixel ;
    pixelDesc.cDepthBits = 32;
    pixelDesc.iLayerType = PFD_MAIN_PLANE;

    int GLPixelIndex = ChoosePixelFormat (cDC->m_hDC, &pixelDesc);

    if (GLPixelIndex == 0 )
    {
      CHAR sz[80];
      DWORD dw = GetLastError();
      sprintf (sz, "ChoosePixelFormat failed: Get LastError returned %u\n", dw);
      MessageBox ( sz, "ERROR", MB_OK);
      return false;
    }

    if ( SetPixelFormat(cDC->m_hDC, GLPixelIndex, &pixelDesc) == FALSE)
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

void CxModel::SetRadiusType( int radtype )
{
    m_radius = radtype;
    NeedRedraw();
}

void CxModel::SetRadiusScale(int scale)
{
    m_radscale = (float)scale / 1000.0f;
      NeedRedraw();
}





bool CxModel::IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelAtom **outAtom)
{

//This is called every time the mouse moves. It is important that it is very fast, since
//it loops through *all* the atoms!

//    TEXTOUT("IsAtomClicked?");
    //Quicker algorithm ideas:
    //
    // 1. Use a square instead of circular radius for hit testing. (Since the atom
    // lights up indicating when the mouse is near it, the user won't care about this).
    //
    // 2. Get coords for a box which projects through the model coordinates and
    // hit test this box. (Need a good algorithm, also need to know which way up
    // it is).

// Account for difference between Windows (GDI) coordinates
// and OpenGL coordinates

#ifdef __CR_WIN__

  CRect       wwindowext;
  GetClientRect(&wwindowext);
  CcRect rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);

#endif
#ifdef __BOTHWX__

  wxRect wwindowext = GetRect();
  CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());

#endif

  yPos = rect.Height() - yPos;

//Need scale between model and window in order to do radius calculation

  float scale = (float) min ( rect.Width(), rect.Height() ) / 10000.0f ;

// NB This doesn't include the m_xScale part!

  CcModelAtom* topAtom = nil;
  CcModelAtom* topAtomB = nil;
  float topAtomZ = 0;
  float topAtomBd = 0;
  int centwx = rect.Width() / 2;
  int centwy = rect.Height() / 2;

  CcModelAtom* atom;
  CrModel* crModel = (CrModel*)ptr_to_crObject;

  crModel->PrepareToGetAtoms();

// Loop through the atoms...
// find any that are within radius of (xPos,yPos)
// store the one with the *lowest* z coord.
// Top atomB stores atoms found in a wider search radius,
// if one is not found within the normal search radius.

  while ( (atom = crModel->GetModelAtom()))
  {
    if (atom->m_excluded) continue; //(Jumps to end of loop)

    int radius = (int)(atom->R() * max(m_radscale,0.25) * scale * m_xScale ); //NB m_radscale doesn't go below 0.5 or it gets all fiddly trying to find atoms with the mouse.
    int radsq = (int) (radius * radius);

//Process the co-ordinates in the same way that OpenGL does:
// 1. Rotate the scaled co-ordinates. ( ==eqv== Scale the rotated co-ordinates )
// 2. Translate the rotated and scaled co-ords.
// 3. Scale from -5000->5000 coords to pixel scale.
// 4. Translate so that centred at centre of window.

    int prjX = (int)( (
                           ( (
                                 mat[0] * atom->X()
                               + mat[4] * atom->Y()
                               + mat[8] * atom->Z()
                              ) * m_xScale  ) + m_xTrans
                         ) * scale ) + centwx ;

    int prjY = (int)( (
                           ( (
                                 mat[1] * atom->X()
                               + mat[5] * atom->Y()
                               + mat[9] * atom->Z()
                              ) * m_xScale ) + m_yTrans
                         ) * scale  ) + centwy ;

    int distsq = (int) ((xPos-prjX)*(xPos-prjX)
                      + (yPos-prjY)*(yPos-prjY));

    if ( distsq < radsq)
    {
// If there is more than one atom under the cursor,
// we need the top one.

      float prjZ = ( mat[2] * atom->X()
                   + mat[6] * atom->Y()
                   + mat[10]* atom->Z() );

      if ( (topAtom == nil) || (topAtomZ < prjZ) )
      {
        topAtom = atom;
        topAtomZ = prjZ;
      }
    }
    else if ( ( topAtom == nil ) && ( distsq < ( radsq * 6 ) ) )
    {
// If there is no atom under the cursor,
// we need the closest one ( within radsq*6 ).

      if   ( (topAtomB == nil) || ( distsq < topAtomBd ) )
      {
        topAtomB = atom;
        topAtomBd = (float)distsq;
      }
    }
  } //end atom getting loop

  if ( topAtom )
  {
    *atomname = topAtom->Label();
    *outAtom = topAtom;
    return true;
  }
  else if(topAtomB != nil)
  {
    *atomname = topAtomB->Label();
    *outAtom = topAtomB;

/*
    crModel->PrepareToGetBonds();

// Loop through the bonds...

    while ( (bond = crModel->GetModelBond()) )
    {

//Process the co-ordinates in the same way that OpenGL does:
// 1. Rotate the scaled co-ordinates. ( ==eqv== Scale the rotated co-ordinates )
// 2. Translate the rotated and scaled co-ords.
// 3. Scale from -5000->5000 coords to pixel scale.
// 4. Translate so that centred at centre of window.

      int prjX1 = (int)( (
                           ( (
                                 mat[0] * atom->X1()
                               + mat[4] * atom->Y1()
                               + mat[8] * atom->Z1()
                              ) * m_xScale  ) + m_xTrans
                         ) * scale ) + centwx ;

      int prjY1 = (int)( (
                           ( (
                                 mat[1] * atom->X1()
                               + mat[5] * atom->Y1()
                               + mat[9] * atom->Z1()
                              ) * m_xScale ) + m_yTrans
                         ) * scale  ) + centwy ;
      int prjX2 = (int)( (
                           ( (
                                 mat[0] * atom->X2()
                               + mat[4] * atom->Y2()
                               + mat[8] * atom->Z2()
                              ) * m_xScale  ) + m_xTrans
                         ) * scale ) + centwx ;

      int prjY2 = (int)( (
                           ( (
                                 mat[1] * atom->X2()
                               + mat[5] * atom->Y2()
                               + mat[9] * atom->Z2()
                              ) * m_xScale ) + m_yTrans
                         ) * scale  ) + centwy ;


// subtract x1,y1 from x2,y2 and from the cursor posn.
      
      int vecX = prjX2 - prjX1;
      int vecY = prjY2 - prjY1;

      int pX = xPos - prjX1;
      int pY = yPos - prjY1;


      int distsq = (int) ((xPos-prjX)*(xPos-prjX)
                        + (yPos-prjY)*(yPos-prjY));

      if ( distsq < radsq)
      {
// If there is more than one atom under the cursor,
// we need the top one.

        float prjZ = ( mat[2] * atom->X()
                     + mat[6] * atom->Y()
                     + mat[10]* atom->Z() );
  
        if ( (topAtom == nil) || (topAtomZ < prjZ) )
        {
          topAtom = atom;
          topAtomZ = prjZ;
        }
      }
    } //end atom getting loop



*/



    return true;
  }
  return false;
}



void CxModel::SelectBoxedAtoms(CcRect rectangle, bool select)
{
// Account for difference between Windows (GDI) coordinates
// and OpenGL coordinates

#ifdef __CR_WIN__

    CRect       wwindowext;
    GetClientRect(&wwindowext);
    CcRect       rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);

#endif
#ifdef __BOTHWX__

    wxRect wwindowext = GetRect();
    CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());

#endif

    rectangle.mBottom = rect.Height() - rectangle.mBottom;
    rectangle.mTop    = rect.Height() - rectangle.mTop;

    int winsc = min ( rect.Width(), rect.Height() );

//Need scale between model and window in order to do radius calculation

    float scale = (float) winsc / 10000.0f ;

// NB This doesn't include the m_xScale part!

    int centwx = rect.Width() / 2;
    int centwy = rect.Height() / 2;

    CcModelAtom* atom;
    CrModel* crModel = (CrModel*)ptr_to_crObject;

    crModel->PrepareToGetAtoms();

// Loop through the atoms...
// find any that are within the rectangl

    while ( (atom = crModel->GetModelAtom()) != nil )
    {

//Process the co-ordinates in the same way that OpenGL does:
// 1. Rotate the scaled co-ordinates. ( ==eqv== Scale the rotated co-ordinates )
// 2. Translate the rotated and scaled co-ords.
// 3. Scale from -5000->5000 coords to pixel scale.
// 4. Translate so that centred at centre of window.

       int prjX = (int)((((
                            mat[0] * atom->X()
                          + mat[4] * atom->Y()
                          + mat[8] * atom->Z()
                       ) * m_xScale ) + m_xTrans
                       ) * scale    ) + centwx ;

       int prjY = (int)((((
                            mat[1] * atom->X()
                          + mat[5] * atom->Y()
                          + mat[9] * atom->Z()
                       ) * m_xScale ) + m_yTrans
                         ) * scale  ) + centwy ;

       if ( rectangle.Contains(prjX,prjY) ) atom->Select(); //invert selection state.
    }
}


void CxModel::AutoScale()
{
    //Quicker algorithm ideas:
      // Work out enclosing ellipse for the atomic co-ordinates, and scale
      // using these.

#ifdef __CR_WIN__

      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);

#endif
#ifdef __BOTHWX__

      wxRect wwindowext = GetRect();
      CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());

#endif

//Need scale between model and window in order to do radius calculation

      float scale = (float) min ( rect.Width(), rect.Height() ) / 10000.0f ;

// NB This doesn't include the m_xScale part!

      CcModelAtom* atom;
      CrModel* crModel = (CrModel*)ptr_to_crObject;

      int highest  = -999999;
      int widest   = -999999;
      int lowest   =  999999;
      int leftmost =  999999;
      
      int prjX, prjY, radius;

      crModel->PrepareToGetAtoms();

// Loop through the atoms...

      while ( (atom = crModel->GetModelAtom()) )
      {
         if ( ! atom->m_excluded )
         {
            radius = (int)( m_radscale * scale * (float)atom->R() );

            prjX = (int)(
                           (
                                 mat[0] * (float)atom->X()
                               + mat[4] * (float)atom->Y()
                               + mat[8] * (float)atom->Z()
                           ) * scale
                   );

            widest   = max ( ( prjX  + radius) , widest );
            leftmost = min ( ( prjX  - radius) , leftmost );

            prjY = (int) (
                           (
                                 mat[1] * (float)atom->X()
                               + mat[5] * (float)atom->Y()
                               + mat[9] * (float)atom->Z()
                           ) * scale
                   );

            highest = max ( ( prjY + radius) , highest );
            lowest  = min ( ( prjY - radius) , lowest );
         }
      } //end atom getting loop

      // widest etc. values are in PIXELS, centred in centre of window.

      float wscale = (float)rect.Width() / (float)( widest - leftmost ) ;
      float hscale = (float)rect.Height() / (float)( highest - lowest ) ;

      m_xScale = min ( hscale , wscale );
      m_xTrans = -m_xScale * ( widest + leftmost ) / (2.0f * scale);
      m_yTrans = -m_xScale * ( highest + lowest ) / (2.0f * scale);
      NewSize(rect.Width(),rect.Height());

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
      NeedRedraw();
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
  memDC.SelectObject(oldMemDCBitmap);
  delete newMemDCBitmap;
  CClientDC dc (this);
  newMemDCBitmap = new CBitmap;
  newMemDCBitmap -> CreateCompatibleBitmap(&dc, right-left, bottom-top);
  oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);
  memDC.PatBlt(0,0,right-left,bottom-top, WHITENESS);
  NewSize(right-left, bottom-top);
  NeedRedraw();
#endif
#ifdef __BOTHWX__
  SetSize(left,top,right-left,bottom-top);
  NewSize(right-left, bottom-top);
  NeedRedraw();
#endif
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

void CxModel::NeedRedraw()
{
//  TEXTOUT ( "NeedRedraw" );

  m_bNeedUpdate = true;

#ifdef __CR_WIN__

  InvalidateRect(NULL,false);

#endif
#ifdef __BOTHWX__

  Refresh();

#endif

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
      NeedRedraw();
}
void CxModel::SetAutoSize( bool size )
{
      m_Autosize = size;
      (CcController::theController)->status.SetZoomedFlag ( !m_Autosize );
      NeedRedraw();
}
void CxModel::SetHover( bool hover )
{
      m_Hover = hover;
}
void CxModel::SetShading( bool shade )
{
      m_Shading = shade;
      NeedRedraw();
}


#ifdef __CR_WIN__

void CxModel::PaintBannerInstead( CPaintDC * dc )
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

BOOL CxModel::OnEraseBkgnd( CDC* pDC )
{
    return ( TRUE ) ; //prevent flicker
}

#endif

#ifdef __BOTHWX__

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
    m_TextPopup->DestroyWindow();
    delete m_TextPopup;
    m_TextPopup=nil;
  }
}

void CxModel::CreatePopup(CcString atomname, CcPoint point)
{
  DeletePopup();
#ifdef __CR_WIN__
  m_TextPopup = new CStatic();
  m_TextPopup->Create(atomname.ToCString(), SS_CENTER|WS_BORDER, CRect(0,0,20,20), this);
  m_TextPopup->ModifyStyleEx(NULL,WS_EX_TOPMOST,0);
  m_TextPopup->SetFont(CcController::mp_font);
  CClientDC dc(m_TextPopup);
  CFont* oldFont = dc.SelectObject(CcController::mp_font);
  SIZE size = dc.GetOutputTextExtent(atomname.ToCString());
  dc.SelectObject(oldFont);
  m_TextPopup->MoveWindow(max(0,point.x-size.cx-4),max(0,point.y-size.cy-4),size.cx+4,size.cy+2,false);
  m_TextPopup->ShowWindow(SW_SHOW);
#endif
#ifdef __BOTHWX__
  m_TextPopup = new wxStaticText();
  m_TextPopup->Create(this, -1, atomname.ToCString(), wxPoint(0,0), wxSize(0,0), wxALIGN_CENTER|wxSIMPLE_BORDER);
  m_TextPopup->Show(false);
  int cx,cy;
  m_TextPopup->GetTextExtent( m_TextPopup->GetLabel(), &cx, &cy );
  m_TextPopup->SetSize(max(0,point.x-cx-4),max(0,point.y-cy-4),cx+4,cy+4);
  m_TextPopup->Show(true);
#endif

}
