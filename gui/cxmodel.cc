////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

#include	"crystalsinterface.h"
#ifdef __WINDOWS__
#include    <GL\gl.h>
#include    <GL\glu.h>
#include	<afxwin.h>
#endif
#ifdef __LINUX__
#include    <GL/gl.h>
#include    <GL/glu.h>
#endif

#include	<math.h>
#include	"cxmodel.h"
#include	"cxgrid.h"
#include	"cxwindow.h"
#include	"crmodel.h"
#include	"ccmodelatom.h"
#include	"creditbox.h"
#include	"cccontroller.h"

int CxModel::mModelCount = kModelBase;

CxModel * CxModel::CreateCxModel( CrModel * container, CxGrid * guiParent )
{
        const char* wndClass = AfxRegisterWndClass(   CS_HREDRAW|CS_VREDRAW,
                                                      NULL,
                                                      (HBRUSH)(COLOR_MENU+1),
                                                      NULL
                                                           );

	CxModel	*theStdModel = new CxModel(container);
	theStdModel->Create(wndClass,"Model",WS_CHILD|WS_VISIBLE,CRect(0,0,26,28),guiParent,mModelCount++);
	theStdModel->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theStdModel->SetFont(CxGrid::mp_font);

	CRect rect;

	theStdModel->hDC = ::GetDC(theStdModel->GetSafeHwnd());
	theStdModel->SetWindowPixelFormat(theStdModel->hDC);
	theStdModel->CreateViewGLContext(theStdModel->hDC);
	GLsizei oneList = 1;
	theStdModel->mNormal = glGenLists(oneList);
	theStdModel->mHighlights = glGenLists(oneList);
	theStdModel->mLitatom = glGenLists(oneList);
	theStdModel->Setup();

	return theStdModel;
}

CxModel::CxModel(CrModel* container)
	:CWnd()
{
	mWidget = container;
	m_radius = COVALENT;
	m_radscale = 1.0f;
	m_fastrotate = FALSE;
      m_moved = true;
	matrix = new float[16];
	m_hGLContext = NULL;
	m_GLPixelIndex = 0;
	matrix[0]=1.0f;  matrix[1]=0.0f;  matrix[2]=0.0f;  matrix[3]=0.0f;
	matrix[4]=0.0f;	 matrix[5]=1.0f;  matrix[6]=0.0f;  matrix[7]=0.0f;	
	matrix[8]=0.0f;  matrix[9]=0.0f;  matrix[10]=1.0f; matrix[11]=0.0f;
	matrix[12]=0.0f; matrix[13]=0.0f; matrix[14]=0.0f; matrix[15]=1.0f;
	m_LitAtom = nil;
	m_drawing = false;
        m_projratio = 1.0;

}

CxModel::~CxModel()
{
	mModelCount--;
	delete [] matrix;

        wglMakeCurrent(NULL,NULL);
        wglDeleteContext(m_hGLContext);

	HWND hWnd = GetSafeHwnd();
	::ReleaseDC(hWnd,hDC);

}

void	CxModel::SetText( char * text )
{
	SetWindowText(text);
}

void    CxModel::SetGeometry( int top, int left, int bottom, int right )
{
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
	}
}
int	CxModel::GetTop()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.top -= parentRect.top;
	}
	return ( windowRect.top );
}
int	CxModel::GetLeft()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.left -= parentRect.left;
	}
	return ( windowRect.left );
}
int	CxModel::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxModel::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

int	CxModel::GetIdealWidth()
{
	return mIdealWidth;
}
int	CxModel::GetIdealHeight()
{
	return mIdealHeight;
}

//Windows Message Map
BEGIN_MESSAGE_MAP(CxModel, CWnd)
	ON_WM_CHAR()
	ON_WM_PAINT()
	ON_WM_LBUTTONUP()
	ON_WM_LBUTTONDOWN()
	ON_WM_RBUTTONUP()
	ON_WM_MOUSEMOVE()
	ON_COMMAND_RANGE(kMenuBase, kMenuBase+1000, OnMenuSelected)
END_MESSAGE_MAP()

void CxModel::Focus()
{
	SetFocus();
}

void CxModel::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	NOTUSED(nRepCnt);
	NOTUSED(nFlags);
	switch(nChar)
	{
		case 9:
		{
			Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
			mWidget->FocusToInput((char)nChar);
		}
	}
}


CcPoint CxModel::DeviceToLogical(int x, int y)
{
      CcPoint            newpoint;
	CRect		windowext;
	float		aspectratio, windowratio;

	GetClientRect(&windowext);
	aspectratio = 1;
	x = (int)(x * aspectratio);

	windowratio = (float)windowext.right / (float)windowext.bottom;

	if (aspectratio > windowratio)    //The x coords are okay, ycoords must be
	{								  //centered and scaled.
		newpoint.x = (int)((windowext.right * x)/(2400*aspectratio));
		newpoint.y = (int)((windowext.right * y)/(2400*aspectratio));
		newpoint.y = (int)(newpoint.y + ((windowext.bottom-windowext.right)/2*aspectratio));	
	}
	else if (aspectratio < windowratio)    //The y coords are okay, xcoords must be
	{									  //centered and scaled.
		newpoint.y = (windowext.bottom * y) / 2400;
		newpoint.x = (windowext.bottom * x) / 2400;
		newpoint.x = (int)(newpoint.x + ((windowext.right- aspectratio*windowext.bottom)/2));	
	}
	else
	{
		newpoint.x = (int)((windowext.right * x)/(2400*aspectratio));
		newpoint.y = (windowext.bottom * y)/2400;
	}


	return newpoint;
}

CcPoint CxModel::LogicalToDevice(CcPoint point)
{
      CcPoint            newpoint;
	CRect		windowext;
	float		aspectratio, windowratio;

	GetClientRect(&windowext);
	aspectratio = 1;
//	x = (int)(x * aspectratio);

	windowratio = (float)windowext.right / (float)windowext.bottom;

	if (aspectratio > windowratio)    //The x coords are okay, ycoords must be
	{								  //centered and scaled.
		newpoint.x = (int) ( (point.x*2400*aspectratio) / windowext.right );
		point.y -= (int)((windowext.bottom-windowext.right)/2*aspectratio);	
		newpoint.y = (int) ( (point.y*2400*aspectratio) / windowext.right );
	}
	else if (aspectratio < windowratio)    //The y coords are okay, xcoords must be
	{									  //centered and scaled.
		newpoint.y = (int) ( (point.y*2400) / windowext.bottom );
		point.x -= (int)((windowext.right- aspectratio*windowext.bottom)/2);	
		newpoint.x = (int) ( (point.x*2400) / windowext.bottom );
	}
	else
	{
		newpoint.x = (int) ( (point.x*2400*aspectratio) / windowext.right );
		newpoint.y = (int) ( (point.y*2400) / windowext.bottom );
	}

	return newpoint;
}

void CxModel::OnPaint() 
{

    wglMakeCurrent(hDC, m_hGLContext);

      CPaintDC dc(this); // device context for painting

      Setup();
      PaintBuffer();

    wglMakeCurrent(NULL,NULL);

}

void CxModel::SetIdealHeight(int nCharsHigh)
{
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealHeight = nCharsHigh * textMetric.tmHeight;
}

void CxModel::SetIdealWidth(int nCharsWide)
{
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;
}


void CxModel::OnLButtonUp( UINT nFlags, CPoint point )
{
	NOTUSED(nFlags);
      NOTUSED(point);
	if(m_fastrotate)
	{
		m_fastrotate = FALSE;
		((CrModel*)mWidget)->ReDrawHighlights();
		InvalidateRect(NULL,FALSE);
	}

}

void CxModel::OnLButtonDown( UINT nFlags, CPoint wpoint )
{	
      CcPoint point(wpoint.x,wpoint.y);
	CcString atomname;
	CcModelAtom* atom;
	if(IsAtomClicked(point.x, point.y, &atomname, &atom))
	{
		((CrModel*)mWidget)->SendAtom(atom);
            m_LitAtom=nil; //Get it to rehighlight properly.
            wglMakeCurrent(hDC, m_hGLContext);
              glNewList(mLitatom,GL_COMPILE);
              DrawAtom(atom,1);
              glEndList();
            wglMakeCurrent(NULL,NULL);
            InvalidateRect(NULL,FALSE);
	}
	//No atom is clicked, we are going to rotate from here
	m_ptLDown = point;
	m_fastrotate = TRUE;
}


void CxModel::OnMouseMove( UINT nFlags, CPoint wpoint )
{

      CcPoint point;
      point.Set(wpoint.x,wpoint.y);

      CRect rect;
	GetWindowRect(&rect);

	if(nFlags & MK_LBUTTON) 
	{
		if(m_fastrotate) //LBUTTONDOWN and already rotating.
		{
			float *oldmatrix;
			oldmatrix = new float[16];

                  int xrotate = m_ptLDown.x - point.x;
                  int yrotate = m_ptLDown.y - point.y;

			m_ptLDown = point;

// 5.236 is 300 * PI / 180. The 300 part is to balance the divide by rect.Width() or Height().

                  float m_angle1 = 5.236f * (float)xrotate / (float)rect.Width();
                  float m_angle2 = 5.236f * (float)yrotate / (float)rect.Height();
	
//            (CcController::theController)->SetProgressText(
//                                           CcString(m_ptLDown.x) + " " 
//                                         + CcString(m_ptLDown.y)   + " " +
//                                           CcString(xrotate)   + " " 
//                                         +  CcString(yrotate)   + " " +
//                                           CcString(point.x)   + " "  
//                                         +  CcString(point.y)
//                                           CcString(m_angle1)   + " "  
//                                         +  CcString(m_angle2)
//                                       );

            if(yrotate != 0)
			{
				for (int i = 0; i < 16; i++)
					oldmatrix[i]=matrix[i];
	
				matrix[1] = (float)cos(m_angle2)  * oldmatrix[1] + (float)sin(m_angle2) * oldmatrix [2];
				matrix[5] = (float)cos(m_angle2)  * oldmatrix[5] + (float)sin(m_angle2) * oldmatrix [6];
				matrix[9] = (float)cos(m_angle2)  * oldmatrix[9] + (float)sin(m_angle2) * oldmatrix [10];
				matrix[2] = (float)-sin(m_angle2) * oldmatrix[1] + (float)cos(m_angle2) * oldmatrix [2];
				matrix[6] = (float)-sin(m_angle2) * oldmatrix[5] + (float)cos(m_angle2) * oldmatrix [6];
				matrix[10] =(float)-sin(m_angle2) * oldmatrix[9] + (float)cos(m_angle2) * oldmatrix [10];
			}
                  if(xrotate != 0)
			{
				for (int i = 0; i < 16; i++)
					oldmatrix[i]=matrix[i];
	
				matrix[0] = (float)cos(m_angle1) * oldmatrix[0] - (float)sin(m_angle1) * oldmatrix [2];
				matrix[4] = (float)cos(m_angle1) * oldmatrix[4] - (float)sin(m_angle1) * oldmatrix [6];
				matrix[8] = (float)cos(m_angle1) * oldmatrix[8] - (float)sin(m_angle1) * oldmatrix [10];
				matrix[2] = (float)sin(m_angle1) * oldmatrix[0] + (float)cos(m_angle1) * oldmatrix [2];
				matrix[6] = (float)sin(m_angle1) * oldmatrix[4] + (float)cos(m_angle1) * oldmatrix [6];
				matrix[10] =(float)sin(m_angle1) * oldmatrix[8] + (float)cos(m_angle1) * oldmatrix [10];
			}
	
			delete oldmatrix;
                  m_moved = true;
                  InvalidateRect(NULL,FALSE);
		}
		else   //LBUTTONDOWN, but not rotating yet.
		{
			//We shouldn't really get here, but we might (say the user
			//holds down the LBUTTON and drags onto the window. ie.
			//we are dragging but have missed the LBUTTONDOWN for some
			//unknown reason. Start dragging from here.
			m_ptLDown = point;
			m_fastrotate = TRUE;
		}
	}
	else
	{
		if(m_fastrotate) //Was rotating, but now LBUTTON is up. Redraw. (MISSED LBUTTONUP message)
		{
			m_fastrotate = FALSE;
			((CrModel*)mWidget)->ReDrawHighlights();
                  m_moved = true;
                  InvalidateRect(NULL,FALSE);
		}

		CcString atomname;
		CcModelAtom* atom;
		if(IsAtomClicked(point.x, point.y, &atomname, &atom))
		{
			if(m_LitAtom != atom) //avoid excesive redrawing, it flickers.
			{
				m_LitAtom = atom;
                        (CcController::theController)->SetProgressText(atomname);
				if (!m_drawing) // handy though this feature is, we can't really draw two lists at once.
				{       
					wglMakeCurrent(hDC, m_hGLContext);
                                         glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
                                         glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
                                         glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
                                         glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);
                                         glNewList(mLitatom,GL_COMPILE);
                                         DrawAtom(atom,1);
                                         glEndList();
                                        wglMakeCurrent(NULL,NULL);
                                        InvalidateRect(NULL,FALSE);
				}
			}
		}
		else if (m_LitAtom != nil) //Not over an atom, but one is still lit. Redraw.
		{
			m_LitAtom = nil;
                  (CcController::theController)->SetProgressText("Ready");
			if (!m_drawing) // handy though this feature is, we can't really draw two lists at once.
			{       
				wglMakeCurrent(hDC, m_hGLContext);
                        glNewList(mLitatom,GL_COMPILE);
                        glEndList();
                        wglMakeCurrent(NULL,NULL);
                        InvalidateRect(NULL,FALSE);
			}
		}
	}
}

void CxModel::OnRButtonUp( UINT nFlags, CPoint wpoint )
{
      CcPoint point(wpoint.x,wpoint.y);
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


///////////// Start the normal atom list

void CxModel::Start()
{
      wglMakeCurrent(hDC, m_hGLContext);

	glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
	glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);

// This is a new list. Remove the old lit atom.
	m_LitAtom = nil;
      glNewList(mLitatom,GL_COMPILE);
      glEndList();

// Start the normal atom list. It is closed in Display().
	glNewList(mNormal,GL_COMPILE);
	m_drawing = true;
}

// You can call DrawAtom, DrawBond or DrawTri in between
// Start() and Display().

///////////// End the normal atom list

void CxModel::Display()
{
      glEndList();
      wglMakeCurrent(NULL,NULL);
      m_moved = true;
      InvalidateRect(NULL,FALSE);
      m_drawing = false;
}

///////////// Start the highlight atom list

void CxModel::StartHighlights()
{
	if (!m_drawing) // handy though this feature is, we can't really draw two lists at once.
	{       
		m_drawing = true;
		wglMakeCurrent(hDC, m_hGLContext);
		glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
		glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
		glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
		glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);
            glNewList(mHighlights,GL_COMPILE);
	}
}

///////////// Add the highlit atoms to the list.
// You can call HighlightAtom in between
// StartHighlights() and FinishHighlights().

void CxModel::HighlightAtom(CcModelAtom * theAtom, Boolean selected)
{
      DrawAtom(theAtom,2);
      return;
}


///////////// End the highlight atom list

void CxModel::FinishHighlights()
{
	glEndList();
	wglMakeCurrent(NULL,NULL);

	InvalidateRect(NULL,FALSE);
	m_drawing = false;
}








void CxModel::DrawAtom(CcModelAtom* anAtom, int style)
{
//x,y,z, r,g,b,cov,vdw,x11,x12,x13,x21,x22,x23,x31,x32,x33 
      glPushMatrix();

            float extra = 0.0;
            if (style == 1 ) // hover over
		{
                  if ( anAtom->m_selected )  // hover over a selected atom
                  {
                        GLfloat Surface[] = { 1.0-(float)anAtom->r/255.0f, 1.0-(float)anAtom->g/255.0f, 1.0-(float)anAtom->b/255.0f, 1.0f };
                        GLfloat Diffuse[] = { 0.9f,0.9f,0.9f,1.0f };
                        GLfloat Specula[] = { 0.2f,0.2f,0.2f,1.0f };
                        GLfloat Shinine[] = {0.0f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                        extra = 20.0;
                  }
                  else //hover over a normal atom
                  {
                        GLfloat Surface[] = { 1.0-(float)anAtom->r/255.0f, 1.0-(float)anAtom->g/255.0f, 1.0-(float)anAtom->b/255.0f, 1.0f };
                        GLfloat Diffuse[] = { 0.4f,0.4f,0.4f,1.0f };
                        GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
                        GLfloat Shinine[] = {89.6f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                        extra = 20.0;
                  }
		}
		else if (style == 2) // highlighted
		{
			GLfloat Surface[] = { (float)anAtom->r/255.0f,(float)anAtom->g/255.0f,(float)anAtom->b/255.0f, 1.0f };
			GLfloat Diffuse[] = { 0.9f,0.9f,0.9f,1.0f };
			GLfloat Specula[] = { 0.2f,0.2f,0.2f,1.0f };
			GLfloat Shinine[] = {0.0f};
			glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
			glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
			glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
			glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                  extra = 10.0;
		}
		else  // normal
		{
			GLfloat Surface[] = { (float)anAtom->r/255.0f,(float)anAtom->g/255.0f,(float)anAtom->b/255.0f, 1.0f };
			GLfloat Diffuse[] = { 0.4f,0.4f,0.4f,1.0f };
			GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
			GLfloat Shinine[] = {89.6f};
			glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
			glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
			glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
			glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
		}
		glTranslated(anAtom->x,anAtom->y,anAtom->z);
		GLUquadricObj* sphere = gluNewQuadric();
		gluQuadricDrawStyle(sphere,GLU_FILL);
            if(m_radius == COVALENT)
                gluSphere(sphere, ((float)anAtom->covrad + extra ) * m_radscale,16,16);
            else if(m_radius == VDW)
                gluSphere(sphere, ((float)anAtom->vdwrad + extra ) * m_radscale,16,16);
            else if(m_radius == THERMAL)
            {
                  float* localmatrix = new float[16];
                  localmatrix[0]=(float)anAtom->x11;
                  localmatrix[1]=(float)anAtom->x12;
                  localmatrix[2]=(float)anAtom->x13;
                  localmatrix[3]=(float)0;
                  localmatrix[4]=(float)anAtom->x21;
                  localmatrix[5]=(float)anAtom->x22;
                  localmatrix[6]=(float)anAtom->x23;
                  localmatrix[7]=(float)0;
                  localmatrix[8]=(float)anAtom->x31;
                  localmatrix[9]=(float)anAtom->x32;
                  localmatrix[10]=(float)anAtom->x33;
                  localmatrix[11]=(float)0;
                  localmatrix[12]=(float)0;
                  localmatrix[13]=(float)0;
                  localmatrix[14]=(float)0;
                  localmatrix[15]=(float)1;
                  glMultMatrixf(localmatrix);
                  gluSphere(sphere, 1000.0*m_radscale,16,16);
                  delete [] localmatrix;
            }
      glPopMatrix();
}


void CxModel::Setup()
{	
      CRect rect;
	GetClientRect(&rect);

        GLsizei width  = min (rect.Width(),rect.Height());
        GLsizei height = width;


	glViewport(0,0,width,height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

      if (m_moved)
      {
        m_moved = false;
        float ratio = ScaleToWindow();
        m_projratio = ratio;
      }

      int diff = (int)( 10000 -  ( 10000 * m_projratio ) ) / 2.0;

      glOrtho(diff,10000-diff,diff,10000-diff,-10000,0);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST);
	glDrawBuffer(GL_BACK);

}

void CxModel::PaintBuffer() 
{

            glLoadIdentity();
            glClearColor( 1.0f,1.0f,1.0f,0.0f); 
 
            glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	
            GLfloat LightAmbient[] = { 0.1f, 0.1f, 0.1f, 0.1f };
            GLfloat LightDiffuse[] = { 0.7f, 0.7f, 0.7f, 0.7f };
//           GLfloat LightSpecular[] ={ 0.0f, 0.0f, 0.0f, 0.1f };
            GLfloat LightSpecular[] ={ 1.0f, 1.0f, 1.0f, 1.0f };

            GLfloat LightPosition[] = {10000.0f, 10000.0f, 10000.0f, 0.0f};
            glLightfv(GL_LIGHT0, GL_AMBIENT, LightAmbient); 
            glLightfv(GL_LIGHT0, GL_DIFFUSE, LightDiffuse); 
            glLightfv(GL_LIGHT0, GL_SPECULAR, LightSpecular); 
            glLightfv(GL_LIGHT0, GL_POSITION, LightPosition); 
            glEnable(GL_LIGHT0);

            GLfloat LightPosition1[] = {-10000.0f, -10000.0f, 10000.0f, 0.0f};
            glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient); 
            glLightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse); 
            glLightfv(GL_LIGHT1, GL_SPECULAR, LightSpecular); 
            glLightfv(GL_LIGHT1, GL_POSITION, LightPosition1); 
            glEnable(GL_LIGHT1);

            GLfloat LightPosition2[] = {0.0f, 0.0f, -10000.0f, 0.0f};
            glLightfv(GL_LIGHT2, GL_AMBIENT, LightAmbient); 
            glLightfv(GL_LIGHT2, GL_DIFFUSE, LightDiffuse); 
            glLightfv(GL_LIGHT2, GL_SPECULAR, LightSpecular); 
            glLightfv(GL_LIGHT2, GL_POSITION, LightPosition1); 
            glEnable(GL_LIGHT2);
	
		matrix[12] = 0.0;
		matrix[13] = 0.0;
		matrix[14] = 0.0;
		matrix[15] = 1.0;

		glTranslated (5000, 5000,5000);     //The object coordinates are centered at 5000,5000,5000 by center model.
                glMultMatrixf(matrix);                          //However rotations are about (0,0,0)
		glTranslated (-5000, -5000,-5000);  //And then translate them back
	
		if(!m_fastrotate)
		{
			glCallList(mNormal);
			glCallList(mHighlights);
			glCallList(mLitatom);
			glFlush();
			SwapBuffers(hDC);		//the slight disadvantgae of this method is that mouse movements become 'buffered' and the molecule may continue to move after
	
		}
		else
		{
			glCallList(mNormal);	//		glCallList(mFast);  //doesn't exist yet...
			glCallList(mHighlights);
			glCallList(mLitatom);
			glFlush();
			SwapBuffers(hDC);		//the slight disadvantgae of this method is that mouse movements become 'buffered' and the molecule may continue to move after
		}							//the mouse is released.

//Need this later, to translate mouse clicks into 3D space.
		GLdouble modelMatrix[16];	// Storage for modelview matrix
		glGetDoublev(GL_MODELVIEW_MATRIX,modelMatrix);
		for ( int i = 12; i<16; i++ )  matrix[i] = (float)modelMatrix[i];

}



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
		{
			return FALSE;
		}
	}
	if (SetPixelFormat(hDC, m_GLPixelIndex, &pixelDesc) == FALSE)
	{
		return FALSE;
	}

	return TRUE;
}

BOOL CxModel::CreateViewGLContext(HDC hDC)
{
	m_hGLContext = wglCreateContext(hDC);
	if(m_hGLContext ==NULL)
	{
		return FALSE;
	}

	if(wglMakeCurrent(hDC, m_hGLContext) == FALSE)
	{
		return FALSE;
	}

	return TRUE;
}


void CxModel::SetRadiusType( int radtype )
{
	m_radius = radtype;
	((CrModel*)mWidget)->ReDrawView();
}

void CxModel::SetRadiusScale(int scale)
{
	m_radscale = (float)scale / 1000.0f;
	((CrModel*)mWidget)->ReDrawView();
}

void CxModel::DrawTri(int x1, int y1, int z1, int x2, int y2, int z2, int x3, int y3, int z3, int r, int g, int b, Boolean fill)
{
	glPushMatrix();
		GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
		glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
		glMaterialfv(GL_FRONT, GL_DIFFUSE,  Surface);

		if( fill ) 
		{
			glBegin(GL_TRIANGLES);
				glVertex3i(x1, y1, z1);
				glVertex3i(x2, y2, z2);
				glVertex3i(x3, y3, z3);
			glEnd();
			GLfloat Surface[] = { (float)0.0f,(float)0.0f,(float)0.0f, 1.0f };
			glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
			glMaterialfv(GL_FRONT, GL_DIFFUSE,  Surface);
		}
		
		glBegin(GL_LINE_LOOP);
			glVertex3i(x1, y1, z1);
			glVertex3i(x2, y2, z2);
			glVertex3i(x3, y3, z3);
		glEnd();

	glPopMatrix();
}



void CxModel::DrawBond(int x1, int y1, int z1, int x2, int y2, int z2, int r, int g, int b, int rad)
{
	double degToRad = 3.1415926535 / 180.0;
	glPushMatrix();
		GLUquadricObj* cylinder;
		int bondrad = (int)((float)rad*m_radscale);
		float xlen = (float)(x2-x1), ylen = (float)(y2-y1), zlen = (float)(z2-z1);
		float length = (float)sqrt ( xlen*xlen + ylen*ylen + zlen*zlen );
		float centerX = (x1 + x2)/2.0f , centerY = (y1 + y2)/2.0f, centerZ = (z1 + z2)/2.0f;
		float xrot = (float)asin ( -ylen / length );
		float yrot = (float)acos ( zlen / (length*cos(xrot)) );
		if ( (length*cos(xrot)*sin(yrot))/xlen < 0 )
			yrot = -yrot;
		xrot = xrot/(float)degToRad;
		yrot = yrot/(float)degToRad;
		glTranslated(centerX, centerY, centerZ);   //Translate view origin to the center of the bond
		glRotatef(yrot,0,1,0);
		glRotatef(xrot,1,0,0);
		glTranslated(0, 0, -length / 2);           //shift the cylinder so it is centered at 0,0,0;
		GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
		glMaterialfv(GL_FRONT, GL_AMBIENT, Surface);
		GLfloat Diffuse[] = { 0.2f,0.2f,0.2f,1.0f };
		GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
		GLfloat Shinine[] = {89.6f};
		glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
		glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
		glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);

		cylinder = gluNewQuadric();
		gluQuadricDrawStyle(cylinder,GLU_FILL);
		gluCylinder(cylinder,(float)bondrad,(float)bondrad,length, 20, 1);
	glPopMatrix();	
}

Boolean CxModel::IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelAtom **atom)
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

	GLdouble modelMatrix[16];	// Storage for modelview matrix
	GLdouble projMatrix[16];	// Storage for projection matrix
	GLdouble x,y,z,x1,y1,z1;	// Storage for object coordinates
	GLint viewport[4];			// Storage for viewport coordinates

                  
// Account for difference between Windows (GDI) coordinates
// and OpenGL coordinates

	CRect rect;
	GetClientRect(&rect);
	yPos = rect.Height() - yPos;

                          
	for ( int i = 0; i<16; i++ )
	{
		modelMatrix[i] = matrix[i];
	}
	viewport[0] = 0;
	viewport[1] = 0;
	viewport[2] = min(rect.Width(), rect.Height());
	viewport[3] = viewport[2];


// Account for m_projratio scaling of the model.
// Need to scale about the centre point of the window.


        int diff = (int)( viewport[2] - ( viewport[2] * m_projratio ) ) / 2.0;

        xPos = ( xPos * m_projratio ) + diff;
        yPos = ( yPos * m_projratio ) + diff;




        projMatrix[0]  = 1.0 / ( 5000.0 );
	projMatrix[1]  = 0.0;
        projMatrix[2]  = 0.0;
	projMatrix[3]  = 0.0;
	projMatrix[4]  = 0.0;
        projMatrix[5]  = 1.0 / ( 5000.0 );
	projMatrix[6]  = 0.0;
	projMatrix[7]  = 0.0;
	projMatrix[8]  = 0.0;
	projMatrix[9]  = 0.0;
        projMatrix[10] = 1.0 / ( 5000.0 );
	projMatrix[11]  = 0.0;
	projMatrix[12]  = -1.0;
	projMatrix[13]  = -1.0;
	projMatrix[14]  = 1.0;
	projMatrix[15]  = 1.0;

//Need scale between model and window in order to do radius calculation
	gluUnProject(0, 0, 0, modelMatrix, projMatrix, viewport, &x1, &y1, &z1);
	gluUnProject(1, 1, 0, modelMatrix, projMatrix, viewport, &x, &y, &z);
	double scale = sqrt(2.0) / sqrt( (x1-x)*(x1-x) + (y1-y)*(y1-y) + (z1-z)*(z1-z) );
//loop through the atoms.
//find any that are within radius of (xPos,yPos)
//store the one with the *lowest* z coord. 
//Top atomB stores atoms found in a wider search radius, in case one is found within the search radius.

		CcModelAtom* topAtom = nil;
		CcModelAtom* topAtomB = nil;
		double topAtomZ = 0;
		double topAtomBZ = 0;

		CcModelAtom* atomCoord;
		CrModel* crModel = (CrModel*)mWidget;

		crModel->PrepareToGetAtoms();
		while ( (atomCoord = crModel->GetModelAtom()) != nil )
		{
			int radius = (int)(atomCoord->R() * max(m_radscale,0.25) * scale); //NB m_radscale doesn't go below 0.5 or it gets all fiddly trying to find atoms with the mouse.
            int radsq = radius * radius / m_projratio;


            gluProject((double)atomCoord->X(), (double)atomCoord->Y(), (double)atomCoord->Z(), 
							   modelMatrix, projMatrix, viewport, 
						       &x, &y, &z);
			int distsq = (int) ((xPos-x)*(xPos-x) + (yPos - y)*(yPos - y));

			if ( ( (topAtom == nil)||(topAtomZ < z) ) && ( distsq < radsq ) )
			{
				topAtom = atomCoord;
				topAtomZ = z;
			}

// If we haven't found an atom yet look for others in a wider radius. This
// will be used if we don't find an atom within the radsq.

// If  (1) the topAtom  has not been found
// AND (2) the topAtomB has not been found OR the current atom is higher
// AND (3) the distance is in the B range.
                  if   ( (topAtom == nil) && ( (topAtomB == nil)||(topAtomBZ < z )) && (distsq < (radsq*6) ) )
			{
				topAtomB = atomCoord;
				topAtomBZ = z;
			}

		} //end atom getting loop

		if(topAtom != nil)
		{
			*atomname = topAtom->Label();
			*atom = topAtom;
			return TRUE;
		}
		else if(topAtomB != nil)
		{
			*atomname = topAtomB->Label();
			*atom = topAtomB;
			return TRUE;
		}
		return FALSE;
}


float CxModel::ScaleToWindow()
{
//This is called every time as the molecule rotates.
//It is important that it is very fast, since
//it loops through *all* the atoms!


        GLdouble modelMatrix[16];       // Storage for modelview matrix
	GLdouble projMatrix[16];	// Storage for projection matrix
	GLdouble x,y,z,x1,y1,z1;	// Storage for object coordinates
	GLint viewport[4];			// Storage for viewport coordinates


// Store min and max x and y
        int xMax = -10000;
        int yMax = -10000;
        int xMin =  10000;
        int yMin =  10000;


	CRect rect;
	GetClientRect(&rect);

	for ( int i = 0; i<16; i++ )
	{
		modelMatrix[i] = matrix[i];
	}
	viewport[0] = 0;
	viewport[1] = 0;
        viewport[2] = min ( rect.Width(), rect.Height() );
        viewport[3] = viewport[2];

	projMatrix[0]  = 1.0 / 5000.0;
	projMatrix[1]  = 0.0;
	projMatrix[2]  = 0.0;
	projMatrix[3]  = 0.0;
	projMatrix[4]  = 0.0;
	projMatrix[5]  = 1.0 / 5000.0;
	projMatrix[6]  = 0.0;
	projMatrix[7]  = 0.0;
	projMatrix[8]  = 0.0;
	projMatrix[9]  = 0.0;
	projMatrix[10] = 1.0 / 5000.0;
	projMatrix[11]  = 0.0;
	projMatrix[12]  = -1.0;
	projMatrix[13]  = -1.0;
	projMatrix[14]  = 1.0;
	projMatrix[15]  = 1.0;

//Need scale between model and window in order to do radius calculation
       gluUnProject(0, 0, 0, modelMatrix, projMatrix, viewport, &x1, &y1, &z1);
       gluUnProject(1, 1, 0, modelMatrix, projMatrix, viewport, &x, &y, &z);
       double scale = sqrt(2.0) / sqrt( (x1-x)*(x1-x) + (y1-y)*(y1-y) + (z1-z)*(z1-z) );

//loop through the atoms.

       CcModelAtom* atomCoord;
       CrModel* crModel = (CrModel*)mWidget;

       crModel->PrepareToGetAtoms();
       while ( (atomCoord = crModel->GetModelAtom()) != nil )
       {
             int radius = (int)(atomCoord->R() * m_radscale * scale); 
             gluProject((double)atomCoord->X(), (double)atomCoord->Y(), (double)atomCoord->Z(),
                        modelMatrix, projMatrix, viewport, 
                        &x, &y, &z);

             xMax = max ( xMax, x + 2 * radius + 20 );
             xMin = min ( xMin, x - 2 * radius - 20);
             yMax = max ( yMax, y + 2 * radius + 20);
             yMin = min ( yMin, y - 2 * radius - 20);


       } //end atom getting loop

// Now, lets see. Do we want to scale against x or y?
       float xratio = (float)(xMax-xMin) / (float)(viewport[2]);
       float yratio = (float)(yMax-yMin) / (float)(viewport[2]);
       float scaletowin;

       if ( xratio > yratio )
       {
// We're scaling to x
                scaletowin = xratio;
       }
       else
       {
                scaletowin = yratio;
       }

       return scaletowin;


}




void CxModel::OnMenuSelected(int nID)
{
	((CrModel*)mWidget)->MenuSelected( nID );
}

void CxModel::UpdateHighlights()
{
	InvalidateRect(NULL,FALSE);
}


void CxModel::Reset()
{
	m_LitAtom = nil;
}
