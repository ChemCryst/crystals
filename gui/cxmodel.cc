////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

#include	"crystalsinterface.h"

#include	<math.h>
#include	"cxgrid.h"
#include	"cxmodel.h"
#include	"cxwindow.h"
#include	"crmodel.h"
#include	"ccmodelatom.h"
#include	"creditbox.h"
#include	"cccontroller.h"
#include        "resource.h"
#include        <GL/glu.h>

int CxModel::mModelCount = kModelBase;

CxModel * CxModel::CreateCxModel( CrModel * container, CxGrid * guiParent )
{

#ifdef __WINDOWS__
	CxModel	*theStdModel = new CxModel(container);

        const char* wndClass = AfxRegisterWndClass(   CS_HREDRAW|CS_VREDRAW,NULL,(HBRUSH)(COLOR_MENU+1),NULL);
	theStdModel->Create(wndClass,"Model",WS_CHILD|WS_VISIBLE,CRect(0,0,26,28),guiParent,mModelCount++);
	theStdModel->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theStdModel->SetFont(CxGrid::mp_font);
	CRect rect;
        HDC hdc = ::GetDC(theStdModel->GetSafeHwnd());
        if((theStdModel->SetWindowPixelFormat(hdc))==false) return nil;
        if((theStdModel->CreateViewGLContext(hdc))==false) return nil;

	theStdModel->Setup();
#endif
#ifdef __BOTHWX__

	CxModel	*theStdModel = new CxModel((wxWindow*)guiParent);
        theStdModel->mWidget = container;

//      wxGLContext* mycon = new wxGLContext(true, theStdModel);
//      theStdModel->m_glContext = mycon;

      theStdModel->Setup();

//       cerr << "Address of context: " << CcString((int) theStdModel->GetContext() ) << "\n";
//       cerr << "Address of canvas:  " << CcString((int) theStdModel ) << "\n";
//       cerr << "Address of canvas.m_glContext: " << CcString((int) theStdModel->m_glContext ) << "\n";
//       if ( theStdModel->m_glContext ) cerr << "Address of canvas.m_glContext.m_glContext: " << CcString((int) theStdModel->m_glContext->m_glContext ) << "\n";
//       cerr << "Address of canvas.m_sharedContext: " << CcString((int) theStdModel->m_sharedContext ) << "\n";
#endif
	return theStdModel;
}
#ifdef __BOTHWX__
CxModel::CxModel(wxWindow *parent, wxWindowID id, const wxPoint& pos, const wxSize& size,
                 long style, const wxString& name): wxGLCanvas(parent, id, pos, size, style, name)
{
#endif
#ifdef __WINDOWS__
CxModel::CxModel(CrModel* container)
      :BASEMODEL()
{
	mWidget = container;
#endif
      m_radius = COVALENT;
	m_radscale = 1.0f;
      m_fastrotate = false;
#ifdef __WINDOWS__
	m_GLPixelIndex = 0;
#endif
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

#ifdef __WINDOWS__
	m_hGLContext = NULL;
      m_bitmapok = true;
#endif
}


CxModel::~CxModel()
{
	mModelCount--;
      delete [] mat;

#ifdef __WINDOWS__
        wglMakeCurrent(NULL,NULL);
        wglDeleteContext(m_hGLContext);
#endif
#ifdef __BOTHWX__
      
#endif
}


#ifdef __WINDOWS__
//Windows Message Map
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
//wx Message Table
BEGIN_EVENT_TABLE(CxModel, wxGLCanvas)
      EVT_CHAR( CxModel::OnChar )
      EVT_PAINT( CxModel::OnPaint )
      EVT_LEFT_UP( CxModel::OnLButtonUp )
      EVT_LEFT_DOWN( CxModel::OnLButtonDown )
      EVT_RIGHT_UP( CxModel::OnRButtonUp )
      EVT_MOTION( CxModel::OnMouseMove )
      EVT_COMMAND_RANGE(kMenuBase, kMenuBase+1000, wxEVT_COMMAND_MENU_SELECTED, CxModel::OnMenuSelected )
END_EVENT_TABLE()
#endif


void CxModel::Focus()
{
	SetFocus();
}

#ifdef __WINDOWS__
void CxModel::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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
			mWidget->FocusToInput((char)nChar);
			break;
		}
	}
}
#endif
#ifdef __BOTHWX__
void CxModel::OnChar( wxKeyEvent & event )
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
                  mWidget->FocusToInput((char)event.KeyCode());
			break;
		}
	}
}
#endif


#ifdef __WINDOWS__
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
    SetCurrent();
       //cerr << "P Address of context: " << CcString((int) GetContext() ) << "\n";
       //cerr << "P Address of canvas:  " << CcString((int) this ) << "\n";
       //cerr << "P Address of canvas.m_glContext: " << CcString((int) m_glContext ) << "\n";
       //cerr << "P Address of canvas.m_sharedContext: " << CcString((int) m_sharedContext ) << "\n";
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


    Boolean haveRendered = ((CrModel*)mWidget)->RenderModel(!m_fastrotate);


    glPopMatrix();


#ifdef __WINDOWS__
    if ( haveRendered )
    {

      SwapBuffers(hdc);       

    }
    else
    {
      PaintBannerInstead( &dc );
    }
#endif
#ifdef __BOTHWX__
    glFlush();

//    if ( haveRendered )
        SwapBuffers();
#endif

}


#ifdef __WINDOWS__
void CxModel::OnLButtonUp( UINT nFlags, CPoint wpoint )
{
#endif
#ifdef __BOTHWX__
void CxModel::OnLButtonUp( wxMouseEvent & event )
{
#endif
	if(m_fastrotate)
	{
            m_fastrotate = false;
            NeedRedraw();
	}

}

#ifdef __WINDOWS__
void CxModel::OnLButtonDown( UINT nFlags, CPoint wpoint )
{
      CcPoint point(wpoint.x,wpoint.y);
#endif
#ifdef __BOTHWX__
void CxModel::OnLButtonDown( wxMouseEvent & event )
{
      CcPoint point ( event.m_x, event.m_y );
#define MK_CONTROL 1
#define MK_SHIFT 2
      int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
      nFlags = event.m_shiftDown ? MK_SHIFT : 0 ;
#endif

	CcString atomname;
	CcModelAtom* atom;

      if ( nFlags & MK_CONTROL )    //Zoom out
      {
         if ( m_xScale > 1.0 )
         {
            int winx = GetWidth();
            int winy = GetHeight();
            m_xScale /= 1.2f;
            m_xTrans -= m_xTrans / m_xScale ;  //Head back towards the centre
            m_yTrans -= m_yTrans / m_xScale ;
            NewSize(winx,winy);
            m_Autosize = false;
            NeedRedraw();
         }
      }
      else if ( nFlags & MK_SHIFT  )  //Zoom in
      {
            int winx = GetWidth();
            int winy = GetHeight();
            m_xScale *= 1.2f;
// NB y axis is upside down for OpenGL.
            m_xTrans -= 8000.0f * ( (float)point.x / (float)winx ) - 4000.0f;
            m_yTrans += 8000.0f * ( (float)point.y / (float)winy ) - 4000.0f;
            NewSize(winx,winy);
            m_Autosize = false;
            NeedRedraw();
      }
      else
      {
         if(IsAtomClicked(point.x, point.y, &atomname, &atom))
         {
		((CrModel*)mWidget)->SendAtom(atom);
            NeedRedraw();
         }
         else
         {
         //We could rotate from here, but don't set m_fastrotate, in case,
         //we don't. Otherwise the picture will flick to low detail and
         //back every time we click an atom.
           m_ptLDown = point;
         }
      }
}


#ifdef __WINDOWS__
void CxModel::OnMouseMove( UINT nFlags, CPoint wpoint )
{
      CcPoint point(wpoint.x,wpoint.y);


        if(nFlags & MK_LBUTTON)
	{
#endif

#ifdef __BOTHWX__
void CxModel::OnMouseMove( wxMouseEvent & event )
{
      CcPoint point ( event.m_x, event.m_y );
      int nFlags = event.m_controlDown ? MK_CONTROL : 0 ;
      nFlags = event.m_shiftDown ? MK_SHIFT : 0 ;
      if(event.m_leftDown) 
      {
#endif
		if(m_fastrotate) //LBUTTONDOWN and already rotating.
		{
#ifdef __WINDOWS__
                  SetCursor(AfxGetApp()->LoadCursor(IDC_CURSOR1) );
#endif
                  if ( m_ptLDown.x - point.x )
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
			//We shouldn't really get here, but we might (say the user
			//holds down the LBUTTON and drags onto the window. ie.
			//we are dragging but have missed the LBUTTONDOWN for some
			//unknown reason. Start dragging from here.
                    m_ptLDown = point;
                    m_fastrotate = true;
		}
	}
//skip if the shift or ctrl is pressed or if Hover is turned off.
      else if ( !( nFlags & MK_CONTROL) && !( nFlags & MK_SHIFT ) )
      {

            if( m_fastrotate ) //Was rotating, but now LBUTTON is up. Redraw. (MISSED LBUTTONUP message)
		{
#ifdef __WINDOWS__
                  SetCursor(AfxGetApp()->LoadCursor(IDC_CURSOR1) );
#endif
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
                        (CcController::theController)->SetProgressText(&atomname);
#ifdef __WINDOWS__
                        SetCursor( AfxGetApp()->LoadCursor(IDC_POINTER_COPY) );
#endif
                        if ( m_Hover )
                              NeedRedraw();
                     }
                  }
                  else if (m_LitAtom != nil) //Not over an atom, but one is still lit. Redraw.
                  {
                     m_LitAtom = nil;
                     (CcController::theController)->SetProgressText(NULL);
#ifdef __WINDOWS__
                   SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR1) );
#endif
                     if ( m_Hover )
                        NeedRedraw();
                  }
                  else
                  {
#ifdef __WINDOWS__
                        SetCursor( AfxGetApp()->LoadCursor(IDC_CURSOR1) );
#endif
                  }
                  m_ptMMove = point;
            }
        }
}

#ifdef __WINDOWS__
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
	CrModel* crModel = (CrModel*)mWidget;

	

	//decide which menu to show
	if(IsAtomClicked(point.x, point.y, &atomname, &atom))
	{
#ifdef __WINDOWS__
            ClientToScreen(&wpoint); // change the coordinates of the click from window to screen coords so that the menu appears in the right place
            point = CcPoint(wpoint.x,wpoint.y);
#endif
		if (atom->IsSelected()) // If it's selected pass the atom-clicked, and all the selected atoms.
		{
			int nSelected;
			CcModelAtom* atoms = crModel->GetSelectedAtoms(&nSelected);
			CcString* atomNames = new CcString[nSelected];
			for (int i = 0; i < nSelected; i++)
				atomNames[i] = atoms[i].Label();
			((CrModel*)mWidget)->ContextMenu(point.x,point.y, atomname, nSelected, atomNames);
			delete [] atomNames;
		}
		else //the atom is not selected show a menu applicable to a single atom.
		{
			((CrModel*)mWidget)->ContextMenu(point.x,point.y, atomname);
		}
	}
	else
	{
#ifdef __WINDOWS__
            ClientToScreen(&wpoint); // change the coordinates of the click from window to screen coords so that the menu appears in the right place
            point = CcPoint(wpoint.x,wpoint.y);
#endif
		((CrModel*)mWidget)->ContextMenu(point.x,point.y);
	}
}


void CxModel::Setup()
{	

#ifdef __BOTHWX__


   if( !GetContext() )
   {
      m_glContext = new wxGLContext( true, this, 
                                    wxNullPalette, m_sharedContext );
   }
    
    SetCurrent();

 //  cerr << "S Address of context: " << CcString((int) GetContext() ) << "\n";
   //    cerr << "S Address of canvas:  " << CcString((int) this ) << "\n";
     //  cerr << "S Address of canvas.m_glContext: " << CcString((int) m_glContext ) << "\n";
       //cerr << "S Address of canvas.m_sharedContext: " << CcString((int) m_sharedContext ) << "\n";

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
#ifdef __WINDOWS__
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
        if( nColors > 256 )
                m_pal.CreateHalftonePalette( &dc );
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
//       cerr << "N Address of context: " << CcString((int) GetContext() ) << "\n";
//       cerr << "N Address of canvas:  " << CcString((int) this ) << "\n";
//       cerr << "N Address of canvas.m_glContext: " << CcString((int) m_glContext ) << "\n";
//       cerr << "N Address of canvas.m_sharedContext: " << CcString((int) m_sharedContext ) << "\n";
#endif
      int icx = 5000;
      int icy = 5000;
      glViewport(0,0,cx,cy);
      if (cx > cy)
            icx = (int) ( ( 5000.0 * cx ) / cy );
      else
            icy = (int) ( ( 5000.0 * cy ) / cx );

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
      glOrtho(-icx,icx,-icy,icy,-5000*m_xScale,5000*m_xScale);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST);
//	glDrawBuffer(GL_BACK);
}

#ifdef __WINDOWS__
BOOL CxModel::SetWindowPixelFormat(HDC hDC)
{
	PIXELFORMATDESCRIPTOR pixelDesc;
	memset(&pixelDesc, 0, sizeof(pixelDesc));

	pixelDesc.nSize = sizeof(PIXELFORMATDESCRIPTOR);
	pixelDesc.nVersion = 1;

	pixelDesc.dwFlags = PFD_DRAW_TO_WINDOW |
//                        PFD_DRAW_TO_BITMAP |
                          PFD_SUPPORT_OPENGL |
                            PFD_DOUBLEBUFFER |
                          PFD_STEREO_DONTCARE;

	pixelDesc.iPixelType = PFD_TYPE_RGBA;
	pixelDesc.cColorBits = 32;
	pixelDesc.cRedBits = 8;
	pixelDesc.cRedShift = 16;
	pixelDesc.cGreenBits = 8;
	pixelDesc.cGreenShift = 8;
	pixelDesc.cBlueBits = 8;
	pixelDesc.cBlueShift = 0;
	pixelDesc.cAlphaBits = 0;
	pixelDesc.cAlphaShift = 0;
	pixelDesc.cAccumBits = 64;
	pixelDesc.cAccumRedBits = 16;
	pixelDesc.cAccumGreenBits = 16;
	pixelDesc.cAccumBlueBits = 16;
	pixelDesc.cAccumAlphaBits = 0;
	pixelDesc.cDepthBits = 32;
	pixelDesc.cAuxBuffers = 0;
	pixelDesc.iLayerType = PFD_MAIN_PLANE;
	pixelDesc.bReserved = 0;
	pixelDesc.dwLayerMask = 0;
	pixelDesc.dwVisibleMask = 0;
	pixelDesc.dwDamageMask = 0;

	m_GLPixelIndex = ChoosePixelFormat (hDC, &pixelDesc);
	if (m_GLPixelIndex ==0 ) //Choose a default index
	{
		m_GLPixelIndex = 1;
		if (DescribePixelFormat (hDC, m_GLPixelIndex, sizeof(PIXELFORMATDESCRIPTOR), &pixelDesc) == 0)
                  return false;
	}
      if (SetPixelFormat(hDC, m_GLPixelIndex, &pixelDesc) == false)
            return false;

      return true;
}

BOOL CxModel::CreateViewGLContext(HDC hDC)
{
	m_hGLContext = wglCreateContext(hDC);
	if(m_hGLContext ==NULL)
            return false;

      if(wglMakeCurrent(hDC, m_hGLContext) == false)
            return false;

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

              



Boolean CxModel::IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelAtom **outAtom)
{
	
//This is called every time the mouse moves. It is important that it is very fast, since
//it loops through *all* the atoms!


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

#ifdef __WINDOWS__
      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __BOTHWX__
      wxRect wwindowext = GetRect();
      CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif
	yPos = rect.Height() - yPos;

      int winsc = min ( rect.Width(), rect.Height() );

//    glTranslated ( m_xTrans, m_yTrans, m_zTrans );
//    glMultMatrixf ( mat );
//    glScalef     ( m_xScale, m_xScale, m_xScale );

//Need scale between model and window in order to do radius calculation

      float scale = (float) winsc / 10000.0f ;

// NB This doesn't include the m_xScale part!


      CcModelAtom* topAtom = nil;
      CcModelAtom* topAtomB = nil;
      float topAtomZ = 0;
      float topAtomBd = 0;
      int centwx = rect.Width() / 2;
      int centwy = rect.Height() / 2;

      CcModelAtom* atom;
      CrModel* crModel = (CrModel*)mWidget;

      crModel->PrepareToGetAtoms();

// Loop through the atoms...
// find any that are within radius of (xPos,yPos)
// store the one with the *lowest* z coord. 
// Top atomB stores atoms found in a wider search radius,
// if one is not found within the normal search radius.

      while ( (atom = crModel->GetModelAtom()) != nil )
      {
            int radius = (int)(atom->R() * max(m_radscale,0.25) * scale * m_xScale ); //NB m_radscale doesn't go below 0.5 or it gets all fiddly trying to find atoms with the mouse.
            int radsq = (int) (radius * radius);

//Process the co-ordinates in the same way that OpenGL does:
// 1. Rotate the scaled co-ordinates. ( ==eqv== Scale the rotated co-ordinates )
// 2. Translate the rotated and scaled co-ords.
// 3. Scale from -5000->5000 coords to pixel scale.
// 4. Translate so that centred at centre of window.

            int prjX = (int)(
                         (
                           (
                             (
                                 mat[0] * atom->X()
                               + mat[4] * atom->Y()
                               + mat[8] * atom->Z()
                              ) * m_xScale
                           ) + m_xTrans
                         ) * scale
                       ) + centwx ;

            int prjY = (int)(
                         (
                           (
                             (
                                 mat[1] * atom->X()
                               + mat[5] * atom->Y()
                               + mat[9] * atom->Z()
                              ) * m_xScale
                           ) + m_yTrans
                         ) * scale
                       ) + centwy ;

            int distsq = (int) ((xPos-prjX)*(xPos-prjX)
                              + (yPos-prjY)*(yPos-prjY));

            if ( distsq < radsq)
            {
// If there is more than one
// atom under the cursor,
// we need the top one.

                  float prjZ = ( mat[2] * atom->X()
                               + mat[6] * atom->Y()
                               + mat[10]* atom->Z()
                             );

                  if ( (topAtom == nil) || (topAtomZ < prjZ) )
                  {
                        topAtom = atom;
                        topAtomZ = prjZ;
                  }
            }
            else if ( ( topAtom == nil ) && ( distsq < ( radsq * 6 ) ) )
            {
// If there is no atom
// under the cursor,
// we need the closest
// one ( within radsq*6 ).
                  if   ( (topAtomB == nil) || ( distsq < topAtomBd ) )
                  {
                        topAtomB = atom;
                        topAtomBd = distsq;
                  }
            }
      } //end atom getting loop

      if(topAtom != nil)
      {
            *atomname = topAtom->Label();
            *outAtom = topAtom;
            return true;
      }
      else if(topAtomB != nil)
      {
            *atomname = topAtomB->Label();
            *outAtom = topAtomB;
            return true;
      }
      return false;
}


void CxModel::AutoScale()
{
	//Quicker algorithm ideas:
      // Work out enclosing ellipse for the atomic co-ordinates, and scale
      // using these.

#ifdef __WINDOWS__
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
      CrModel* crModel = (CrModel*)mWidget;

      int highest   =0;
      int widest   = 0;
      int prjX, prjY, radius;

      crModel->PrepareToGetAtoms();

// Loop through the atoms...

      while ( (atom = crModel->GetModelAtom()) != nil )
      {
            radius = (int)(atom->R() * m_radscale * scale ); 

            prjX = (int)(
                           (
                                 mat[0] * atom->X()
                               + mat[4] * atom->Y()
                               + mat[8] * atom->Z()
                           ) * scale
                   );

            widest = max ( (abs ( prjX ) + radius) * 2 , widest );

            prjY = (int) (
                           (
                                 mat[1] * atom->X()
                               + mat[5] * atom->Y()
                               + mat[9] * atom->Z()
                           ) * scale
                   );

            highest = max ( (abs ( prjY ) + radius) * 2 , highest );

      } //end atom getting loop

      float hscale = rect.Width() / (float)( widest ) ;
      float wscale = rect.Height() / (float)( highest ) ;

      m_xScale = min ( hscale , wscale );
      m_xTrans = 0;
      m_yTrans = 0;
      NewSize(rect.Width(),rect.Height());

}



#ifdef __WINDOWS__
void CxModel::OnMenuSelected(int nID)
{
#endif
#ifdef __BOTHWX__
void CxModel::OnMenuSelected(wxCommandEvent & event)
{
      int nID = event.m_id;
#endif

	((CrModel*)mWidget)->MenuSelected( nID );
}


void CxModel::Update()
{
      NeedRedraw();
}


void CxModel::SetIdealHeight(int nCharsHigh)
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
      cdc.SetBkColor ( RGB ( 255,255,255 ) );
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
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
#ifdef __WINDOWS__
	CClientDC cdc(this);
      cdc.SetBkColor ( RGB ( 255,255,255 ) );
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;
#endif
#ifdef __BOTHWX__
      mIdealWidth = nCharsWide * GetCharWidth();
#endif      
}

void	CxModel::SetText( char * text )
{
#ifdef __WINDOWS__
	SetWindowText(text);
#endif
#ifdef __BOTHWX__
//This is a pointless function for a graphics window.      
#endif

}



void  CxModel::SetGeometry( int top, int left, int bottom, int right )
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
            NewSize(right-left, bottom-top);
	}
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
      NewSize(right-left, bottom-top);
#endif

}

int   CxModel::GetTop()
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
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
//	if(parent != nil)
//	{
//            parentRect = parent->GetRect();
//            windowRect.y -= parentRect.y;
//	}
      return ( windowRect.y );
#endif
}
int   CxModel::GetLeft()
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
#ifdef __BOTHWX__
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
int   CxModel::GetWidth()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxModel::GetHeight()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


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

#ifdef __WINDOWS__
            InvalidateRect(NULL,false);
#endif
#ifdef __BOTHWX__
      Refresh();
#endif

}

void CxModel::ChooseCursor( int cursor )
{
#ifdef __WINDOWS__
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
                default:
                        break;
        }
#endif
}

void CxModel::SetDrawStyle( int drawStyle )
{
      m_DrawStyle = drawStyle;
      NeedRedraw();
}

void CxModel::SetAutoSize( Boolean size )
{
      m_Autosize = size;
      NeedRedraw();
}
void CxModel::SetHover( Boolean hover )
{
      m_Hover = hover;
}
void CxModel::SetShading( Boolean shade )
{
      m_Shading = shade;
      NeedRedraw();
}







#ifdef __WINDOWS__
void CxModel::PaintBannerInstead( CPaintDC * dc )
{
        // Create a memory DC compatible with the paint DC
        CDC memDC;
        memDC.CreateCompatibleDC( dc );

        CBitmap *pBmpOld = memDC.SelectObject( &m_bitmap );

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
                   &memDC,
                   0, 0, bm.bmWidth, bm.bmHeight,
                   SRCCOPY);

        // Restore bitmap in memDC
        memDC.SelectObject( pBmpOld );
}

BOOL CxModel::OnEraseBkgnd( CDC* pDC )
{
    return ( TRUE ) ; //prevent flicker
}

#endif
