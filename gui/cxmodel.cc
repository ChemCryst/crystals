////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

#include	"crystalsinterface.h"

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
	CxModel	*theStdModel = new CxModel(container);

#ifdef __WINDOWS__
        const char* wndClass = AfxRegisterWndClass(   CS_HREDRAW|CS_VREDRAW,
                                                      NULL,
                                                      (HBRUSH)(COLOR_MENU+1),
                                                      NULL
                                                           );

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
#endif
#ifdef __LINUX__
      theStdModel->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10));
#endif
	return theStdModel;
}

CxModel::CxModel(CrModel* container)
      :BASEMODEL()
{
	mWidget = container;
	m_radius = COVALENT;
	m_radscale = 1.0f;
      m_fastrotate = false;
      m_moved = true;
	matrix = new float[16];
	m_GLPixelIndex = 0;
	matrix[0]=1.0f;  matrix[1]=0.0f;  matrix[2]=0.0f;  matrix[3]=0.0f;
	matrix[4]=0.0f;	 matrix[5]=1.0f;  matrix[6]=0.0f;  matrix[7]=0.0f;	
	matrix[8]=0.0f;  matrix[9]=0.0f;  matrix[10]=1.0f; matrix[11]=0.0f;
	matrix[12]=0.0f; matrix[13]=0.0f; matrix[14]=0.0f; matrix[15]=1.0f;
	m_LitAtom = nil;
	m_drawing = false;
      m_projratio = 1.0;
#ifdef __WINDOWS__
	m_hGLContext = NULL;
#endif
}


CxModel::~CxModel()
{
	mModelCount--;
	delete [] matrix;

#ifdef __WINDOWS__
        wglMakeCurrent(NULL,NULL);
        wglDeleteContext(m_hGLContext);
	HWND hWnd = GetSafeHwnd();
	::ReleaseDC(hWnd,hDC);
#endif
#ifdef __LINUX__
      
#endif
}

void	CxModel::SetText( char * text )
{
#ifdef __WINDOWS__
	SetWindowText(text);
#endif
#ifdef __LINUX__
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
	}
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
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
#ifdef __LINUX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
	if(parent != nil)
	{
            parentRect = parent->GetRect();
            windowRect.y -= parentRect.y;
	}
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
#ifdef __LINUX__
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
#ifdef __LINUX__
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
#ifdef __LINUX__
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

#ifdef __WINDOWS__
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
#endif

#ifdef __LINUX__
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
#ifdef __LINUX__
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

CcPoint CxModel::DeviceToLogical(int x, int y)
{
      CcPoint            newpoint;
	float		aspectratio, windowratio;

#ifdef __WINDOWS__
      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       windowext( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __LINUX__
      wxRect wwindowext = GetRect();
      CcRect windowext( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif

	aspectratio = 1;
	x = (int)(x * aspectratio);

      windowratio = (float)windowext.mRight / (float)windowext.mBottom;

	if (aspectratio > windowratio)    //The x coords are okay, ycoords must be
	{								  //centered and scaled.
            newpoint.x = (int)((windowext.mRight * x)/(2400*aspectratio));
            newpoint.y = (int)((windowext.mRight * y)/(2400*aspectratio));
            newpoint.y = (int)(newpoint.y + ((windowext.mBottom-windowext.mRight)/2*aspectratio)); 
	}
	else if (aspectratio < windowratio)    //The y coords are okay, xcoords must be
	{									  //centered and scaled.
            newpoint.y = (windowext.mBottom * y) / 2400;
            newpoint.x = (windowext.mBottom * x) / 2400;
            newpoint.x = (int)(newpoint.x + ((windowext.mRight- aspectratio*windowext.mBottom)/2)); 
	}
	else
	{
            newpoint.x = (int)((windowext.mRight * x)/(2400*aspectratio));
            newpoint.y = (windowext.mBottom * y)/2400;
	}


	return newpoint;
}

CcPoint CxModel::LogicalToDevice(CcPoint point)
{
      CcPoint            newpoint;
	float		aspectratio, windowratio;

#ifdef __WINDOWS__
      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       windowext( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __LINUX__
      wxRect wwindowext = GetRect();
      CcRect windowext( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif

	aspectratio = 1;
//	x = (int)(x * aspectratio);

      windowratio = (float)windowext.mRight / (float)windowext.mBottom;

	if (aspectratio > windowratio)    //The x coords are okay, ycoords must be
	{								  //centered and scaled.
            newpoint.x = (int) ( (point.x*2400*aspectratio) / windowext.mRight );
            point.y -= (int)((windowext.mBottom-windowext.mRight)/2*aspectratio); 
            newpoint.y = (int) ( (point.y*2400*aspectratio) / windowext.mRight );
	}
	else if (aspectratio < windowratio)    //The y coords are okay, xcoords must be
	{									  //centered and scaled.
            newpoint.y = (int) ( (point.y*2400) / windowext.mBottom );
            point.x -= (int)((windowext.mRight- aspectratio*windowext.mBottom)/2); 
            newpoint.x = (int) ( (point.x*2400) / windowext.mBottom );
	}
	else
	{
            newpoint.x = (int) ( (point.x*2400*aspectratio) / windowext.mRight );
            newpoint.y = (int) ( (point.y*2400) / windowext.mBottom );
	}

	return newpoint;
}


#ifdef __LINUX__
void CxModel::OnPaint(wxPaintEvent & event)
{
      wxPaintDC dc(this); // device context for painting
      SetCurrent();
      Setup();
      PaintBuffer();
}
#endif
#ifdef __WINDOWS__
void CxModel::OnPaint()
{

    wglMakeCurrent(hDC, m_hGLContext);
      CPaintDC dc(this); // device context for painting

      Setup();
      PaintBuffer();
    wglMakeCurrent(NULL,NULL);
}
#endif


void CxModel::SetIdealHeight(int nCharsHigh)
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealHeight = nCharsHigh * textMetric.tmHeight;
#endif
#ifdef __LINUX__
      mIdealHeight = nCharsHigh * GetCharHeight();
#endif      
}

void CxModel::SetIdealWidth(int nCharsWide)
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;
#endif
#ifdef __LINUX__
      mIdealWidth = nCharsWide * GetCharWidth();
#endif      
}

#ifdef __WINDOWS__
void CxModel::OnLButtonUp( UINT nFlags, CPoint wpoint )
{
#endif
#ifdef __LINUX__
void CxModel::OnLButtonUp( wxMouseEvent & event )
{
#endif
	if(m_fastrotate)
	{
            m_fastrotate = false;
		((CrModel*)mWidget)->ReDrawHighlights();
#ifdef __WINDOWS__
            InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
      Refresh();
#endif
	}

}

#ifdef __WINDOWS__
void CxModel::OnLButtonDown( UINT nFlags, CPoint wpoint )
{
      CcPoint point(wpoint.x,wpoint.y);
#endif
#ifdef __LINUX__
void CxModel::OnLButtonDown( wxMouseEvent & event )
{
      CcPoint point ( event.m_x, event.m_y );
#endif
	CcString atomname;
	CcModelAtom* atom;
	if(IsAtomClicked(point.x, point.y, &atomname, &atom))
	{
		((CrModel*)mWidget)->SendAtom(atom);
            m_LitAtom=nil; //Get it to rehighlight properly.
#ifdef __WINDOWS__
            wglMakeCurrent(hDC, m_hGLContext);
#endif
#ifdef __LINUX__
            SetCurrent();
#endif
              glNewList(mLitatom,GL_COMPILE);
              DrawAtom(atom,1);
              glEndList();
#ifdef __WINDOWS__
            wglMakeCurrent(NULL,NULL);
            InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
            Refresh();
#endif
	}
	//No atom is clicked, we are going to rotate from here
	m_ptLDown = point;
	m_fastrotate = TRUE;
}


#ifdef __WINDOWS__
void CxModel::OnMouseMove( UINT nFlags, CPoint wpoint )
{
      CcPoint point(wpoint.x,wpoint.y);
//      CcPoint point;
//      point.Set(wpoint.x,wpoint.y);
      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
	if(nFlags & MK_LBUTTON) 
	{
#endif
#ifdef __LINUX__
void CxModel::OnMouseMove( wxMouseEvent & event )
{
      CcPoint point ( event.m_x, event.m_y );
      wxRect wwindowext = GetRect();
      CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
      if(event.m_leftDown) 
	{
#endif
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
#ifdef __WINDOWS__
                  InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
                  Refresh();
#endif
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
                  m_fastrotate = false;
			((CrModel*)mWidget)->ReDrawHighlights();
                  m_moved = true;
#ifdef __WINDOWS__
                  InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
                  Refresh();
#endif
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
#ifdef __WINDOWS__
					wglMakeCurrent(hDC, m_hGLContext);
#endif
#ifdef __LINUX__
                              SetCurrent();
#endif
                                         glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
                                         glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_FASTEST);
                                         glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
                                         glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);
                                         glNewList(mLitatom,GL_COMPILE);
                                         DrawAtom(atom,1);
                                         glEndList();
#ifdef __WINDOWS__
                                        wglMakeCurrent(NULL,NULL);
                                        InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
                                        Refresh();
#endif
                        }
			}
		}
		else if (m_LitAtom != nil) //Not over an atom, but one is still lit. Redraw.
		{
			m_LitAtom = nil;
                  (CcController::theController)->SetProgressText("Ready");
			if (!m_drawing) // handy though this feature is, we can't really draw two lists at once.
			{       
#ifdef __WINDOWS__
				wglMakeCurrent(hDC, m_hGLContext);
#endif
#ifdef __LINUX__
                        SetCurrent();
#endif
                        glNewList(mLitatom,GL_COMPILE);
                        glEndList();
#ifdef __WINDOWS__
                        wglMakeCurrent(NULL,NULL);
                        InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
                        Refresh();
#endif
			}
		}
	}
}

#ifdef __WINDOWS__
void CxModel::OnRButtonUp( UINT nFlags, CPoint wpoint )
{
      CcPoint point(wpoint.x,wpoint.y);
#endif
#ifdef __LINUX__
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


///////////// Start the normal atom list

void CxModel::Start()
{
#ifdef __WINDOWS__
      wglMakeCurrent(hDC, m_hGLContext);
#endif
#ifdef __LINUX__
      SetCurrent();
#endif

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
      m_moved = true;
      m_drawing = false;
#ifdef __WINDOWS__
      wglMakeCurrent(NULL,NULL);
      InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
      Refresh();
#endif
}

///////////// Start the highlight atom list

void CxModel::StartHighlights()
{
	if (!m_drawing) // handy though this feature is, we can't really draw two lists at once.
	{       
		m_drawing = true;
#ifdef __WINDOWS__
		wglMakeCurrent(hDC, m_hGLContext);
#endif
#ifdef __LINUX__
            SetCurrent();
#endif
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
#ifdef __WINDOWS__
	wglMakeCurrent(NULL,NULL);
      InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
      Refresh();
#endif
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
#ifdef __WINDOWS__
      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __LINUX__
      wxRect wwindowext = GetRect();
      CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif

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

      int diff = (int)( ( 10000 -  ( 10000 * m_projratio ) ) / 2.0 ) ;

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
#ifdef __WINDOWS__
			SwapBuffers(hDC);		//the slight disadvantgae of this method is that mouse movements become 'buffered' and the molecule may continue to move after
#endif
#ifdef __LINUX__
                  SwapBuffers();
#endif
		}
		else
		{
			glCallList(mNormal);	//		glCallList(mFast);  //doesn't exist yet...
			glCallList(mHighlights);
			glCallList(mLitatom);
			glFlush();
#ifdef __WINDOWS__
			SwapBuffers(hDC);		//the slight disadvantgae of this method is that mouse movements become 'buffered' and the molecule may continue to move after
#endif
#ifdef __LINUX__
                  SwapBuffers();
#endif
		}							//the mouse is released.

//Need this later, to translate mouse clicks into 3D space.
		GLdouble modelMatrix[16];	// Storage for modelview matrix
		glGetDoublev(GL_MODELVIEW_MATRIX,modelMatrix);
		for ( int i = 12; i<16; i++ )  matrix[i] = (float)modelMatrix[i];

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
		{
                  return false;
		}
	}
      if (SetPixelFormat(hDC, m_GLPixelIndex, &pixelDesc) == false)
	{
            return false;
	}

	return TRUE;
}

BOOL CxModel::CreateViewGLContext(HDC hDC)
{
	m_hGLContext = wglCreateContext(hDC);
	if(m_hGLContext ==NULL)
	{
            return false;
	}

      if(wglMakeCurrent(hDC, m_hGLContext) == false)
	{
            return false;
	}

	return TRUE;
}
#endif

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

#ifdef __WINDOWS__
      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __LINUX__
      wxRect wwindowext = GetRect();
      CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif
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

        int diff = (int)(( viewport[2] - ( viewport[2] * m_projratio ) ) / 2.0);

        xPos = (int) ( xPos * m_projratio ) + diff;
        yPos = (int) ( yPos * m_projratio ) + diff;

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
            int radsq = (int) (radius * radius / m_projratio);


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
            return false;
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

#ifdef __WINDOWS__
      CRect       wwindowext;
      GetClientRect(&wwindowext);
      CcRect       rect( wwindowext.top, wwindowext.left, wwindowext.bottom, wwindowext.right);
#endif
#ifdef __LINUX__
      wxRect wwindowext = GetRect();
      CcRect rect( wwindowext.y, wwindowext.x, wwindowext.GetBottom(), wwindowext.GetRight());
#endif

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

             xMax = (int) max ( xMax, x + 2 * radius + 20 );
             xMin = (int) min ( xMin, x - 2 * radius - 20);
             yMax = (int) max ( yMax, y + 2 * radius + 20);
             yMin = (int) min ( yMin, y - 2 * radius - 20);


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




#ifdef __WINDOWS__
void CxModel::OnMenuSelected(int nID)
{
#endif
#ifdef __LINUX__
void CxModel::OnMenuSelected(wxCommandEvent & event)
{
      int nID = event.m_id;
#endif

	((CrModel*)mWidget)->MenuSelected( nID );
}


void CxModel::UpdateHighlights()
{
#ifdef __WINDOWS__
      InvalidateRect(NULL,false);
#endif
#ifdef __LINUX__
      Refresh();
#endif
}


void CxModel::Reset()
{
	m_LitAtom = nil;
}
