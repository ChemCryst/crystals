////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModel.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#include	"CrystalsInterface.h"
#include	<GL\gl.h>
#include	<GL\glu.h>
#include	<math.h>
#include	"CxModel.h"
//Insert your own code here.
#include	"CxGrid.h"
#include	"CxWindow.h"
#include	"CrModel.h"
#include	<afxwin.h>
#include	"CcModelAtom.h"
#include	"CrEditBox.h"
#include	"CcController.h"
//#include	<TextUtils.h>
//#include	<LStdControl.h>

int CxModel::mModelCount = kModelBase;
//End of user code.          

// OPSignature: CxModel * CxModel:CreateCxModel( CrModel *:container  CxGrid *:guiParent ) 
CxModel *	CxModel::CreateCxModel( CrModel * container, CxGrid * guiParent )
{
	const char* wndClass = AfxRegisterWndClass(
									CS_HREDRAW|CS_VREDRAW,
									NULL,
									(HBRUSH)(COLOR_MENU+1),
									NULL
									);

	CxModel	*theStdModel = new CxModel(container);
	theStdModel->Create(wndClass,"Model",WS_CHILD|WS_VISIBLE,CRect(0,0,26,28),guiParent,mModelCount++);
	theStdModel->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theStdModel->SetFont(CxGrid::mp_font);

	CClientDC	dc(theStdModel);
	theStdModel->memDC.CreateCompatibleDC(&dc);
	theStdModel->newMemDCBitmap = new CBitmap;
	CRect rect;
	theStdModel->GetClientRect (&rect);
	theStdModel->newMemDCBitmap->CreateCompatibleBitmap(&dc,rect.Width(),rect.Height());
	theStdModel->oldMemDCBitmap = theStdModel->memDC.SelectObject(theStdModel->newMemDCBitmap);
	theStdModel->memDC.PatBlt(0,0,rect.Width(),rect.Height(),WHITENESS);

	theStdModel->hDC = ::GetDC(theStdModel->GetSafeHwnd());
	theStdModel->SetWindowPixelFormat(theStdModel->hDC);
	theStdModel->CreateViewGLContext(theStdModel->hDC);
	GLsizei oneList = 1;
	theStdModel->mNormal = glGenLists(oneList);
	theStdModel->Setup();

	return theStdModel;
//End of user code.         
}

CxModel::CxModel(CrModel* container)
	:CWnd()
//Insert your own initialization here.
//End of user initialization.         
{
	mWidget = container;
	m_radius = COVALENT;
	m_radscale = 1.0f;
	m_fastrotate = FALSE;
	matrix = new float[16];
	m_hGLContext = NULL;
	m_GLPixelIndex = 0;
	matrix[0]=1.0f;  matrix[1]=0.0f;  matrix[2]=0.0f;  matrix[3]=0.0f;
	matrix[4]=0.0f;	 matrix[5]=1.0f;  matrix[6]=0.0f;  matrix[7]=0.0f;	
	matrix[8]=0.0f;  matrix[9]=0.0f;  matrix[10]=1.0f; matrix[11]=0.0f;
	matrix[12]=0.0f; matrix[13]=0.0f; matrix[14]=0.0f; matrix[15]=1.0f;
	m_LitAtom = nil;
	m_drawing = false;
	mBackBufferReady = 0;
}
// OPSignature:  CxModel:~CxModel() 
	CxModel::~CxModel()
{
//Insert your own code here.
	mModelCount--;
	delete [] matrix;

	HWND hWnd = GetSafeHwnd();
//	HDC hDC = ::GetDC(hWnd);
	::ReleaseDC(hWnd,hDC);

	delete newMemDCBitmap;	
	
/*	if ( mOutlineWidget != nil )
	{
		delete mOutlineWidget;
	}		*/
//End of user code.         
}
// OPSignature: void CxModel:SetText( char *:text ) 
void	CxModel::SetText( char * text )
{
//Insert your own code here.
#ifdef __POWERPC__
	Str255 descriptor;
	
	strcpy( reinterpret_cast<char *>(descriptor), text );
	c2pstr( reinterpret_cast<char *>(descriptor) );
	SetDescriptor( descriptor );
#endif
#ifdef __LINUX__
	setText(text);
#endif
#ifdef __WINDOWS__
	SetWindowText(text);
#endif
//End of user code.         
}
void	CxModel::SetGeometry( int top, int left, int bottom, int right )
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
		if(memDC != NULL)
		{
			memDC.SelectObject(oldMemDCBitmap);
			delete newMemDCBitmap;	

			CClientDC	dc(this);
			newMemDCBitmap = new CBitmap;
			CRect rect;
			newMemDCBitmap->CreateCompatibleBitmap(&dc, right-left, bottom-top);
			oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);
			memDC.PatBlt(0, 0, right-left, bottom-top, WHITENESS);
			mBackBufferReady = 0;
			((CrModel*)mWidget)->ReDrawHighlights();
		}

//		Setup();
//		PaintBuffer();
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

// OPSignature: int CxModel:GetIdealWidth() 
int	CxModel::GetIdealWidth()
{
	return mIdealWidth;
}
// OPSignature: int CxModel:GetIdealHeight() 
int	CxModel::GetIdealHeight()
{
	return mIdealHeight;
}
// OPSignature: void CxModel:BroadcastValueMessage() 

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


CPoint CxModel::DeviceToLogical(int x, int y)
{
	CPoint		newpoint;
	CRect		windowext;
	float		aspectratio, windowratio;
//	CString		mychar;

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

CPoint CxModel::LogicalToDevice(CPoint point)
{
	CPoint		newpoint;
	CRect		windowext;
	float		aspectratio, windowratio;
//	CString		mychar;

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
	HGLRC currentHGLRC = wglGetCurrentContext(); 
	if(m_hGLContext != currentHGLRC)
	{
//		CClientDC dc(this);
		if(!wglMakeCurrent(hDC, m_hGLContext))
		{
			LPVOID lpMsgBuf;

			FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL );
// Display the string.
			MessageBox( (const char*)lpMsgBuf, "OnPaint() Error", MB_OK|MB_ICONINFORMATION );

// Free the buffer.
			LocalFree( lpMsgBuf );
		}

	}

	CPaintDC dc(this); // device context for painting
	Setup();
	PaintBuffer();

	CRect rect;
	GetClientRect (&rect);
	dc.BitBlt(0,0,rect.Width(),rect.Height(),&memDC,0,0,SRCAND);

	if(m_LitAtom != nil)
		HighlightAtom(m_LitAtom,FALSE);

// Do not call CFrameWnd::OnPaint() for painting messages
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


void CxModel::Clear()
{
	CRect rect;
	GetClientRect (&rect);
	memDC.PatBlt(0, 0, rect.Width(), rect.Height(), WHITENESS);
}


void CxModel::OnLButtonUp( UINT nFlags, CPoint point )
{
	NOTUSED(nFlags);
	if(m_fastrotate)
	{
		m_fastrotate = FALSE;
		((CrModel*)mWidget)->ReDrawHighlights();
		InvalidateRect(NULL,FALSE);
	}

//	CPoint devPoint = LogicalToDevice(point);
//	((CrModel*)mWidget)->LMouseClick(devPoint.x, devPoint.y);
	
}

void CxModel::OnLButtonDown( UINT nFlags, CPoint point )
{	
	CcString atomname;
	CcModelAtom* atom;
	if(IsAtomClicked(point.x, point.y, &atomname, &atom))
	{
		((CrModel*)mWidget)->SendAtom(atom);
	}
	//No atom is clicked, we are going to rotate from here
	m_ptLDown = point;
	m_fastrotate = TRUE;
}


void CxModel::OnMouseMove( UINT nFlags, CPoint point )
{
	float degToRad = 3.1415926535f / 180.0f;
	CRect rect;
	GetWindowRect(&rect);
	float xFactor = 300.0f / (float)rect.Width();
	float yFactor = 300.0f / (float)rect.Height();

	if(nFlags & MK_LBUTTON) 
	{
		if(m_fastrotate) //LBUTTONDOWN and already rotating.
		{
			float *oldmatrix;
			oldmatrix = new float[16];
			CSize rotate = m_ptLDown - point;
			m_ptLDown = point;
			float m_angle1 = degToRad*rotate.cx*xFactor;
			float m_angle2 = degToRad*rotate.cy*yFactor;
	
			if(rotate.cy != 0)
			{
				mBackBufferReady = 0;
				for (int i = 0; i < 16; i++)
					oldmatrix[i]=matrix[i];
	
				matrix[1] = (float)cos(m_angle2)  * oldmatrix[1] + (float)sin(m_angle2) * oldmatrix [2];
				matrix[5] = (float)cos(m_angle2)  * oldmatrix[5] + (float)sin(m_angle2) * oldmatrix [6];
				matrix[9] = (float)cos(m_angle2)  * oldmatrix[9] + (float)sin(m_angle2) * oldmatrix [10];
				matrix[2] = (float)-sin(m_angle2) * oldmatrix[1] + (float)cos(m_angle2) * oldmatrix [2];
				matrix[6] = (float)-sin(m_angle2) * oldmatrix[5] + (float)cos(m_angle2) * oldmatrix [6];
				matrix[10] =(float)-sin(m_angle2) * oldmatrix[9] + (float)cos(m_angle2) * oldmatrix [10];
			}
			if(rotate.cx != 0)
			{
				mBackBufferReady = 0;
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
			Setup();
			PaintBuffer();
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
			InvalidateRect(NULL,FALSE);
		}

		CcString atomname;
		CcModelAtom* atom;
		if(IsAtomClicked(point.x, point.y, &atomname, &atom))
		{
			if(m_LitAtom != atom) //avoid excesive redrawing, it flickers.
			{
//				TRACE("Re-drawing highlights. The Lit atom has changed.");
//				((CrModel*)mWidget)->ReDrawHighlights();
				m_LitAtom = atom;
				InvalidateRect(NULL,FALSE);
//				HighlightAtom(atom,FALSE); //Draw pointed to atom on top of the DC afterwards
			}
		}
		else if (m_LitAtom != nil) //Not over an atom, but one is still lit. Redraw.
		{
			TRACE("No atom lit. Re drawing highlights.");
			m_LitAtom = nil;
//			((CrModel*)mWidget)->ReDrawHighlights();
			InvalidateRect(NULL,FALSE);
		}
	}
}

void CxModel::OnRButtonUp( UINT nFlags, CPoint point )
{
	CcString atomname;
	CcModelAtom* atom;
	CrModel* crModel = (CrModel*)mWidget;

	

	//decide which menu to show
	if(IsAtomClicked(point.x, point.y, &atomname, &atom))
	{
		ClientToScreen(&point); // change the coordinates of the click from window to screen coords so that the menu appears in the right place

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
		ClientToScreen(&point); // change the coordinates of the click from window to screen coords so that the menu appears in the right place
		((CrModel*)mWidget)->ContextMenu(point.x,point.y);
	}
}




void CxModel::Start()
{
	HGLRC currentHGLRC = wglGetCurrentContext(); 
	if(m_hGLContext != currentHGLRC)
	{
//		CClientDC dc(this);
	if(!wglMakeCurrent(hDC, m_hGLContext))
		{
			LPVOID lpMsgBuf;

			FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL );
// Display the string.
			MessageBox( (const char*)lpMsgBuf, "Start() Error", MB_OK|MB_ICONINFORMATION );

// Free the buffer.
			LocalFree( lpMsgBuf );
		}

	}


	glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
	glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);

	glNewList(mNormal,GL_COMPILE);

	m_drawing = true;
}

void CxModel::DrawAtom(int x, int y, int z, int r, int g, int b, int cov, int vdw)
{
	if( m_hGLContext != wglGetCurrentContext() )
	{
		if(!wglMakeCurrent(hDC, m_hGLContext))
		{
			LPVOID lpMsgBuf;

			FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL );
// Display the string.
			MessageBox( (const char*)lpMsgBuf, "DrawAtom() Error", MB_OK|MB_ICONINFORMATION );

// Free the buffer.
			LocalFree( lpMsgBuf );
		}
	}	
	glPushMatrix();
		GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
		GLfloat Diffuse[] = { 0.4f,0.4f,0.4f,1.0f };
		GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
		GLfloat Shinine[] = {89.6f};
		glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
		glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
		glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
		glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
		glTranslated(x,y,z);
		GLUquadricObj* sphere = gluNewQuadric();
		gluQuadricDrawStyle(sphere,GLU_FILL);
		if(m_radius == COVALENT)
			gluSphere(sphere, (float)cov * m_radscale,16,16);
		else if(m_radius == VDW)
			gluSphere(sphere, (float)vdw * m_radscale,16,16);
		glPopMatrix();
}

void CxModel::Display()
{
	if( m_hGLContext != wglGetCurrentContext() )
	{
//		CClientDC dc(this);
		if(!wglMakeCurrent(hDC, m_hGLContext))
		{
			LPVOID lpMsgBuf;

			FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL );
// Display the string.
			MessageBox(  (const char*)lpMsgBuf, "Display() Error", MB_OK|MB_ICONINFORMATION );

// Free the buffer.
			LocalFree( lpMsgBuf );
		}
	}	
	glEndList();
	mBackBufferReady = 0;
	InvalidateRect(NULL,FALSE);
	m_drawing = false;
}

void CxModel::Setup()
{	
	HGLRC currentHGLRC = wglGetCurrentContext(); 
	if(m_hGLContext != currentHGLRC)
	{
//		CClientDC dc(this);
		if(!wglMakeCurrent(hDC, m_hGLContext))
		{
			LPVOID lpMsgBuf;

			FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL );
// Display the string.
			MessageBox( (const char*)lpMsgBuf, "Setup() Error", MB_OK|MB_ICONINFORMATION );

// Free the buffer.
			LocalFree( lpMsgBuf );
		}
	}
	CRect rect;
	GetClientRect(&rect);

	GLsizei width  = min (rect.Width(),rect.Height());
	GLsizei	height = width;
//	int length;

	glViewport(0,0,width,height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	glOrtho(0,10000,0,10000,-10000,0);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST);
	glDrawBuffer(GL_BACK);

}

void CxModel::PaintBuffer() 
{
	HGLRC currentHGLRC = wglGetCurrentContext(); 
	if(m_hGLContext != currentHGLRC)
	{
//		CClientDC dc(this);
		if(!wglMakeCurrent(hDC, m_hGLContext))
		{
			LPVOID lpMsgBuf;

			FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL );
// Display the string.
			MessageBox( (const char*)lpMsgBuf, "PaintBuffer() Error", MB_OK|MB_ICONINFORMATION );

// Free the buffer.
			LocalFree( lpMsgBuf );
		}
	}



	if(	mBackBufferReady >= 2)
		SwapBuffers(hDC);
	else
	{
		mBackBufferReady++;
		glLoadIdentity();
		glClearColor( 1.0f,1.0f,1.0f,0.0f); 
	
		glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	
		GLfloat LightAmbient[] = { 0.1f, 0.1f, 0.1f, 0.1f };
		GLfloat LightDiffuse[] = { 0.7f, 0.7f, 0.7f, 0.7f };
//		GLfloat LightSpecular[] ={ 0.0f, 0.0f, 0.0f, 0.1f };
		GLfloat LightSpecular[] ={ 1.0f, 1.0f, 1.0f, 1.0f };
		GLfloat LightPosition[] = {10000.0f, 10000.0f, 10000.0f, 0.0f};
		glLightfv(GL_LIGHT0, GL_AMBIENT, LightAmbient);	
		glLightfv(GL_LIGHT0, GL_DIFFUSE, LightDiffuse);	
		glLightfv(GL_LIGHT0, GL_SPECULAR, LightSpecular);	
		glLightfv(GL_LIGHT0, GL_POSITION, LightPosition);	
		glEnable(GL_LIGHT0);
	
		matrix[12] = 0.0;
		matrix[13] = 0.0;
		matrix[14] = 0.0;
		matrix[15] = 1.0;

		glTranslated (5000, 5000,5000);     //The object coordinates are centered at 5000,5000,5000 by center model.
		glMultMatrixf(matrix);				//However rotations are about (0,0,0)
		glTranslated (-5000, -5000,-5000);  //And then translate them back
	
		if(!m_fastrotate)
		{
			glCallList(mNormal);
			glFlush();
			SwapBuffers(hDC);		//the slight disadvantgae of this method is that mouse movements become 'buffered' and the molecule may continue to move after
	
		}
		else
		{
			glCallList(mNormal);	//		glCallList(mFast);  //doesn't exist yet...
			glFlush();
			SwapBuffers(hDC);		//the slight disadvantgae of this method is that mouse movements become 'buffered' and the molecule may continue to move after
		}							//the mouse is released.

//Need this later, to translate mouse clicks into 3D space.
		GLdouble modelMatrix[16];	// Storage for modelview matrix
		glGetDoublev(GL_MODELVIEW_MATRIX,modelMatrix);
		for ( int i = 12; i<16; i++ )  matrix[i] = (float)modelMatrix[i];
	}


}



BOOL CxModel::SetWindowPixelFormat(HDC hDC)
{
	PIXELFORMATDESCRIPTOR pixelDesc;
	memset(&pixelDesc, 0, sizeof(pixelDesc));

	pixelDesc.nSize = sizeof(PIXELFORMATDESCRIPTOR);
	pixelDesc.nVersion = 1;

	pixelDesc.dwFlags = PFD_DRAW_TO_WINDOW |
//						PFD_DRAW_TO_BITMAP |
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
	if( m_hGLContext != wglGetCurrentContext() )
	{
		wglMakeCurrent(hDC, m_hGLContext);
	}	
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
	if( m_hGLContext != wglGetCurrentContext() )
	{
		wglMakeCurrent(hDC, m_hGLContext);
	}	
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

	if(matrix[15] == 0) //Bad Matrix. Recalculate. (This rarely happens).
	{
		Setup();
		mBackBufferReady = 0; //Otherwise it won't recalculate
		PaintBuffer();
	}

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
			int radius = (int)(atomCoord->R() * m_radscale * scale);
			int radsq = radius * radius;
			gluProject((double)atomCoord->X(), (double)atomCoord->Y(), (double)atomCoord->Z(), 
						modelMatrix, projMatrix, viewport, 
						&x, &y, &z);
//			double dist = sqrt ( (xPos - x)*(xPos - x) + (yPos - y)*(yPos - y) ); 
			int distsq = (int) ((xPos-x)*(xPos-x) + (yPos - y)*(yPos - y));

			if ( ( (topAtom == nil)||(topAtomZ < z) ) && ( distsq < radsq ) )
			{
				topAtom = atomCoord;
				topAtomZ = z;
			}

// If the topAtom has not been found
// AND the topAtomB has not been found OR the current atom is higher
// AND the distance is in the B range.
			if   ( (topAtom == nil) && ( (topAtomB == nil)||(topAtomBZ < z )) && (distsq < (radsq*3) ) )
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




void CxModel::ClearHighlights()
{
	CRect rect;
	GetClientRect (&rect);
	memDC.PatBlt(0, 0, rect.Width(), rect.Height(), WHITENESS);
}

void CxModel::HighlightAtom(CcModelAtom * theAtom, Boolean selected)
{
	if( m_hGLContext != wglGetCurrentContext() )
	{
//		CClientDC dc(this);
		if(!wglMakeCurrent(hDC, m_hGLContext))
		{
			LPVOID lpMsgBuf;

			FormatMessage( 
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &lpMsgBuf,
				0,
				NULL );
// Display the string.
			MessageBox( (const char*)lpMsgBuf, "HiLite Atom Error", MB_OK|MB_ICONINFORMATION );

// Free the buffer.
			LocalFree( lpMsgBuf );
		}

	}	
	GLdouble modelMatrix[16];	// Storage for modelview matrix
	GLdouble projMatrix[16];	// Storage for projection matrix
	GLdouble x,y,z,x1,y1,z1;	// Storeage for object coordinates
	GLint viewport[4];			// Storage for viewport coordinates

// Get the various transforms
	for ( int i = 0; i<16; i++ )
	{
		modelMatrix[i] = matrix[i];
	}
//	glGetDoublev(GL_MODELVIEW_MATRIX,modelMatrix);
	glGetDoublev(GL_PROJECTION_MATRIX,projMatrix);
	glGetIntegerv(GL_VIEWPORT,viewport);

//Need scale between model and window in order to do radius calculation
	gluUnProject(0, 0, 0,	modelMatrix, projMatrix, viewport, &x1, &y1, &z1);
	gluUnProject(1, 1, 0, modelMatrix, projMatrix, viewport, &x, &y, &z);
	double scale = sqrt(2.0) / sqrt( (x1-x)*(x1-x) + (y1-y)*(y1-y) + (z1-z)*(z1-z) );

	CRect rect;
	GetClientRect(&rect);

	CRgn		rgn;	
	CBrush		brush;
	int radius;
	if(m_radius == COVALENT)
		radius = (int) (theAtom->R() * m_radscale * scale);
	else if(m_radius == VDW)
		radius = (int) (theAtom->Vdw() * m_radscale * scale);
	gluProject	((double)theAtom->X(),(double)theAtom->Y(),(double)theAtom->Z(),
				 modelMatrix, projMatrix, viewport, 
				 &x, &y, &z);
	y = rect.Height() - y;
	rgn.CreateEllipticRgn((int)x-radius,(int)y-radius,(int)x+radius+1,(int)y+radius+1);
	if (selected)
	{
		brush.CreateSolidBrush(PALETTERGB(192,192,192));
		memDC.FrameRgn(&rgn,&brush,2,2);
		CBrush brush2;
		brush2.CreateSolidBrush(PALETTERGB(0,0,0));
		memDC.FrameRgn(&rgn,&brush2,1,1);
	}
	else
	{
		brush.CreateSolidBrush(PALETTERGB(128,0,0));
		FrameRgn(hDC,(HRGN)rgn,(HBRUSH)brush,2,2);
		TEXTMETRIC tm;
		GetTextMetrics(hDC,&tm);
		SetTextColor(hDC,PALETTERGB(0,0,0));
		SetBkMode(hDC,TRANSPARENT);
		TextOut(hDC,(int)x+radius/2,(int)y-radius/2-tm.tmHeight,theAtom->Label().ToCString(),theAtom->Label().Length());
	}

}


void CxModel::OnMenuSelected(int nID)
{
	((CrModel*)mWidget)->MenuSelected( nID );
}

void CxModel::UpdateHighlights()
{
	InvalidateRect(NULL,FALSE);
}
