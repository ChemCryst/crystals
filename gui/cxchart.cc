////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxChart

////////////////////////////////////////////////////////////////////////

//   Filename:  CxChart.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#include	"crystalsinterface.h"
#include	"cxchart.h"
//insert your own code here.
#include	"cxgrid.h"
#include	"cxwindow.h"
#include	"crchart.h"
#include	<afxwin.h>
//#include	<TextUtils.h>
//#include	<LStdControl.h>

int CxChart::mChartCount = kChartBase;
//End of user code.          

// OPSignature: CxChart * CxChart:CreateCxChart( CrChart *:container  CxGrid *:guiParent ) 
CxChart *	CxChart::CreateCxChart( CrChart * container, CxGrid * guiParent )
{
	const char* wndClass = AfxRegisterWndClass(
									CS_HREDRAW|CS_VREDRAW,
									NULL,
									(HBRUSH)(COLOR_MENU+1),
									NULL
									);

	CxChart	*theStdChart = new CxChart(container);
	theStdChart->Create(wndClass,"Chart",WS_CHILD|WS_VISIBLE,CRect(0,0,26,28),guiParent,mChartCount++);
	theStdChart->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theStdChart->SetFont(CxGrid::mp_font);

	CClientDC	dc(theStdChart);
	theStdChart->memDC.CreateCompatibleDC(&dc);
	theStdChart->newMemDCBitmap = new CBitmap;
	CRect rect;
	theStdChart->GetClientRect (&rect);
	theStdChart->newMemDCBitmap->CreateCompatibleBitmap(&dc,rect.Width(),rect.Height());
	theStdChart->oldMemDCBitmap = theStdChart->memDC.SelectObject(theStdChart->newMemDCBitmap);
	theStdChart->memDC.PatBlt(0,0,rect.Width(),rect.Height(),WHITENESS);
	theStdChart->memDC.SelectObject(theStdChart->oldMemDCBitmap);

	return theStdChart;
//End of user code.         
}

CxChart::CxChart(CrChart* container)
	:CWnd()
//Insert your own initialization here.
//End of user initialization.         
{
	mWidget = container;
	mfgcolour = PALETTERGB(0,0,0);
	mPolyMode = 0;
	m_IsoCoords = true;
	m_inverted = false;
        m_SendCursorKeys = false;

}
// OPSignature:  CxChart:~CxChart() 
	CxChart::~CxChart()
{
//Insert your own code here.
	mChartCount--;
	delete newMemDCBitmap;	
/*	if ( mOutlineWidget != nil )
	{
		delete mOutlineWidget;
	}		*/
//End of user code.         
}
// OPSignature: void CxChart:SetText( char *:text ) 
void	CxChart::SetText( char * text )
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
void	CxChart::SetGeometry( int top, int left, int bottom, int right )
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
//x			memDC.SelectObject(oldMemDCBitmap);
			delete newMemDCBitmap;	

			CClientDC	dc(this);
			newMemDCBitmap = new CBitmap;
			CRect rect;
			newMemDCBitmap->CreateCompatibleBitmap(&dc, right-left, bottom-top);
			oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);
			memDC.PatBlt(0, 0, right-left, bottom-top, WHITENESS);
			memDC.SelectObject(oldMemDCBitmap);
		}
		((CrChart*)mWidget)->ReDrawView();

	}
}


int	CxChart::GetTop()
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
int	CxChart::GetLeft()
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
int	CxChart::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxChart::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

// OPSignature: int CxChart:GetIdealWidth() 
int	CxChart::GetIdealWidth()
{
	return mIdealWidth;
}
// OPSignature: int CxChart:GetIdealHeight() 
int	CxChart::GetIdealHeight()
{
	return mIdealHeight;
}
// OPSignature: void CxChart:BroadcastValueMessage() 

//Windows Message Map
BEGIN_MESSAGE_MAP(CxChart, CWnd)
	ON_WM_CHAR()
	ON_WM_PAINT()
	ON_WM_LBUTTONUP()
	ON_WM_RBUTTONUP()
	ON_WM_MOUSEMOVE()
      ON_WM_KEYDOWN()
END_MESSAGE_MAP()

void CxChart::Focus()
{
	SetFocus();
}

void CxChart::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
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

void CxChart::DrawLine(int x1, int y1, int x2, int y2)
{
	CPen pen(PS_SOLID,1,mfgcolour), *oldpen;
	oldpen = memDC.SelectObject(&pen);
	oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);
	memDC.MoveTo(DeviceToLogical(x1,y1));
	memDC.LineTo(DeviceToLogical(x2,y2));
	memDC.SelectObject(oldMemDCBitmap);
	memDC.SelectObject(oldpen);
}


CPoint CxChart::DeviceToLogical(int x, int y)
{
	CPoint		newpoint;
	CRect		windowext;
	float		aspectratio, windowratio;
//	CString		mychar;

	GetClientRect(&windowext);
	aspectratio = 1;
	x = (int)(x * aspectratio);

	windowratio = (float)windowext.right / (float)windowext.bottom;

	if(m_IsoCoords)
	{
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
	}
	else
	{
			newpoint.x = (int)((windowext.right * x)/2400);
			newpoint.y = (windowext.bottom * y)/2400;
	}



	return newpoint;
}

CPoint CxChart::LogicalToDevice(CPoint point)
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

void CxChart::Display()
{
	InvalidateRect(NULL,FALSE);
	OnPaint();
}

void CxChart::OnPaint() 
{
	CPaintDC dc(this); // device context for painting
	
	CRect rect;
	GetClientRect (&rect);

	oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);

	dc.BitBlt(0,0,rect.Width(),rect.Height(),&memDC,0,0,SRCCOPY);

	memDC.SelectObject(oldMemDCBitmap);

	if(m_inverted)
	{
		CRect rect;
		GetClientRect(&rect);
		dc.InvertRect(rect);
	}
// Do not call CFrameWnd::OnPaint() for painting messages
}

void CxChart::SetIdealHeight(int nCharsHigh)
{
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealHeight = nCharsHigh * textMetric.tmHeight;
}

void CxChart::SetIdealWidth(int nCharsWide)
{
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;
}





void CxChart::Clear()
{
	CRect rect;
	GetClientRect (&rect);
	oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);
	memDC.PatBlt(0, 0, rect.Width(), rect.Height(), WHITENESS);
	memDC.SelectObject(oldMemDCBitmap);
}

void CxChart::DrawEllipse(int x, int y, int w, int h, Boolean fill)
{

	//NB w and h are half diameters.
	
	CRgn		rgn;	
	CBrush		brush;
	oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);



	int x1 = x - w;
	int y1 = y - h;
	int x2 = x + w;
	int y2 = y + h;
	
	CPoint topleft = DeviceToLogical(x1,y1);
	CPoint bottomright = DeviceToLogical(x2,y2);

	rgn.CreateEllipticRgn(topleft.x,topleft.y,bottomright.x,bottomright.y);
	brush.CreateSolidBrush(mfgcolour);
	if(fill)
		memDC.FillRgn(&rgn,&brush);
	else
		memDC.FrameRgn(&rgn,&brush,1,1);

	memDC.SelectObject(oldMemDCBitmap);
}


void CxChart::DrawText(int x, int y, CcString text)
{
	CPen		pen(PS_SOLID,1,mfgcolour);
	oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);

	CPen		*oldpen	= memDC.SelectObject(&pen);
	CFont		*oldFont = memDC.SelectObject(CxGrid::mp_font);
	CPoint      coord = DeviceToLogical(x,y);
	memDC.SetBkMode(TRANSPARENT);
	memDC.TextOut(coord.x,coord.y,text.ToCString());
	memDC.SelectObject(oldpen);
	memDC.SelectObject(oldFont);
	memDC.SelectObject(oldMemDCBitmap);
}

void CxChart::DrawPoly(int nVertices, int * vertices, Boolean fill)
{
	oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);
	if(fill)
	{
		CRgn		rgn;	
		CBrush		brush;
		CPoint*		points = new CPoint[nVertices];
		for ( int j = 0; j < nVertices*2 ; j+=2 )
		{
			points[j/2] = DeviceToLogical( *(vertices+j), *(vertices+j+1) );
		}
		rgn.CreatePolygonRgn((LPPOINT)points,nVertices,WINDING);
		brush.CreateSolidBrush(mfgcolour);
		memDC.FillRgn(&rgn,&brush);
		delete points;
	}
	else
	{
		CPen		pen(PS_SOLID,1,mfgcolour);
		CPen		*oldpen = memDC.SelectObject(&pen);
		memDC.MoveTo( DeviceToLogical( vertices[0], vertices[1] ) );
		for ( int j = 2; j < nVertices*2; j+=2 )
				memDC.LineTo(DeviceToLogical( vertices[j], vertices[j+1] ) );
		memDC.SelectObject(oldpen);
	}
	memDC.SelectObject(oldMemDCBitmap);

}

/* OLD CODE FROM ANOTHER PROJECT FOR REFERENCE
void CGraphWnd::drawpolygon(int i)
{
//	CClientDC	graphDC(this);
	CRgn		rgn;	
	CBrush		brush;
	CPoint		points[1000];
	int j;

	for ( j = 0; j < wgraphcommands[i+1] - 2 ; j=j+2)
			points[j/2] = deviceToLogical(wgraphcommands[i+j+2],wgraphcommands[i+j+3]);
	rgn.CreatePolygonRgn((LPPOINT) &points,(wgraphcommands[i+1]-2)/2,WINDING);
	brush.CreateSolidBrush(fgcolour);
	memDC.FillRgn(&rgn,&brush);

	//or	graphDC.Polygon(points, wgrap....);
}

void CGraphWnd::drawemptypolygon(int i) //NB Empty polygon is not closed (should be calld POLYLINE)
{
//	CClientDC	graphDC(this);
	CPen		pen(PS_SOLID,1,fgcolour);
	CPen		*oldpen;

	oldpen = memDC.SelectObject(&pen);
	memDC.MoveTo(deviceToLogical(wgraphcommands[i+2],wgraphcommands[i+3]));

	for (int j = 2; j < wgraphcommands[i+1] - 2 ; j=j+2)
		memDC.LineTo(deviceToLogical(wgraphcommands[i+j+2],wgraphcommands[i+j+3]));

	memDC.SelectObject(oldpen);

}

*/

void CxChart::SetColour(int r, int g, int b)
{
	mfgcolour = PALETTERGB(r,g,b);
//	TRACE("CxChart SetColour to: %d, %d, %d \n",r,g,b);

}

void CxChart::OnLButtonUp( UINT nFlags, CPoint point )
{
	NOTUSED(nFlags);
	CPoint devPoint = LogicalToDevice(point);
	((CrChart*)mWidget)->LMouseClick(devPoint.x, devPoint.y);
	
	if (mPolyMode == 2)
	{
	//Add a point, set new last point coords
		mLastPolyModePoint = point;
	}
	else if (mPolyMode == 1)
	{
	//Add first point, set mode to 2, set last point coords.
		mLastPolyModePoint = point;
		mCurrentPolyModeLineEndPoint = point;
		mStartPolyModePoint = point;
		mPolyMode = 2;
	}
	else if (mPolyMode == 3)
	{
	//Add last point, set mode to 0, restore cursor.
		mLastPolyModePoint = point;
		mPolyMode = 0;
		HCURSOR arrow = LoadCursor(NULL,IDC_ARROW);
		SetCursor(arrow);
		((CrChart*)mWidget)->PolygonClosed();
		OnPaint();
	}

}


void CxChart::SetPolygonDrawMode(Boolean on)
{
	//If the user closes the polygon, the area is returned as an array
	//with the first element as the number of vertices, followed by all
	//the vertices.

	//If the user types a key, or clicks the right mouse button before the
	//polygon is closed, then NULL is returned.

	if(on)
	{
		mPolyMode = 1;
		HCURSOR cross = LoadCursor(AfxGetApp()->m_hInstance,MAKEINTRESOURCE( IDC_CURSOR1 ));
		SetCursor(cross);
	}
	else
	{
		mPolyMode = 0;
		HCURSOR arrow = LoadCursor(NULL,IDC_ARROW);
		SetCursor(arrow);
	}
}

void CxChart::OnMouseMove( UINT nFlags, CPoint point )
{
NOTUSED (nFlags);
	//If mode is 2 then change to 3 if closing.
	//If not closing and mode is 3, then change to 2.
	if (mPolyMode >= 2)
	{
		if( ( abs(point.x - mStartPolyModePoint.x) < 10) && ( abs(point.y - mStartPolyModePoint.y) < 10) )
		{
			HCURSOR cross = LoadCursor(AfxGetApp()->m_hInstance,MAKEINTRESOURCE( IDC_CURSOR2 ));
			SetCursor(cross);
			mPolyMode = 3;
		}
		else 
		{
			HCURSOR cross = LoadCursor(AfxGetApp()->m_hInstance,MAKEINTRESOURCE( IDC_CURSOR1));
			SetCursor(cross);
			mPolyMode = 2;
		}

		//Erase the old line.
		CClientDC dc(this); // device context for painting
/*		int temp = dc.SetROP2(R2_XORPEN);
		dc.MoveTo(mLastPolyModePoint);
		dc.LineTo(mCurrentPolyModeLineEndPoint);
		//Draw the new line.
		dc.MoveTo(mLastPolyModePoint);
		dc.LineTo(mCurrentPolyModeLineEndPoint = point);
		dc.SetROP2(temp);*/
		CRgn oldrgn, newrgn;
		CPoint points[4];
		points[0] = mLastPolyModePoint;
		points[1] = mCurrentPolyModeLineEndPoint;
		points[2].x = mCurrentPolyModeLineEndPoint.x + 2;
		points[2].y = mCurrentPolyModeLineEndPoint.y + 2;
		points[3].x = mLastPolyModePoint.x + 2;
		points[3].y = mLastPolyModePoint.y + 2;
		oldrgn.CreatePolygonRgn((LPPOINT) points, 4, ALTERNATE);
		dc.InvertRgn(&oldrgn);
		mCurrentPolyModeLineEndPoint = point;
		points[0] = mLastPolyModePoint;
		points[1] = mCurrentPolyModeLineEndPoint;
		points[2].x = mCurrentPolyModeLineEndPoint.x + 2;
		points[2].y = mCurrentPolyModeLineEndPoint.y + 2;
		points[3].x = mLastPolyModePoint.x + 2;
		points[3].y = mLastPolyModePoint.y + 2;
		newrgn.CreatePolygonRgn((LPPOINT) points, 4, ALTERNATE);
		dc.InvertRgn(&newrgn);

	}
	else if(mPolyMode == 1)
	{
		HCURSOR cross = LoadCursor(AfxGetApp()->m_hInstance,MAKEINTRESOURCE( IDC_CURSOR1));
		SetCursor(cross);
	}
	else
	{
		HCURSOR cross = LoadCursor(NULL, IDC_ARROW);
		SetCursor(cross);
	}
}

void CxChart::OnRButtonUp( UINT nFlags, CPoint point )
{
NOTUSED(point);
NOTUSED(nFlags);

	if (mPolyMode != 0)
	{
		mPolyMode = 0;
		HCURSOR arrow = LoadCursor(NULL,IDC_ARROW);
		SetCursor(arrow);
		((CrChart*)mWidget)->PolygonCancelled();
	}

}

void CxChart::UseIsotropicCoords(Boolean iso)
{
	m_IsoCoords = iso;
}

void CxChart::FitText(int x1, int y1, int x2, int y2, CcString theText, Boolean rotated)
{
	CPen		pen(PS_SOLID,1,mfgcolour);
	CPen*       oldpen = memDC.SelectObject(&pen);
	oldMemDCBitmap = memDC.SelectObject(newMemDCBitmap);

	LOGFONT     theLogfont;
	(CxGrid::mp_font)->GetLogFont(&theLogfont);
	theLogfont.lfHeight = 180;
	theLogfont.lfWidth = 0;
	theLogfont.lfWeight = 0;
	if(rotated)
		theLogfont.lfOrientation = 900;
	char face[32] = "Times New Roman";
	*(theLogfont.lfFaceName) = *face;

	CPoint      coord = DeviceToLogical(x1,y1);
	CPoint		coord2 =DeviceToLogical(x2,y2);
	Boolean fontIsTooBig = true;
	CSize size;
//	int sign = theLogfont.lfHeight / abs(theLogfont.lfHeight);
	while (fontIsTooBig)
	{
		CFont  theFont;
		theFont.CreatePointFontIndirect(&theLogfont, &memDC);
		CFont* oldFont = memDC.SelectObject(&theFont);

		size = memDC.GetOutputTextExtent(theText.ToCString(), theText.Len());

		if (((size.cx < coord2.x - coord.x)&&(size.cy < coord2.y - coord.y))||(theLogfont.lfHeight<=10))
		{
			//Output the text, and exit.
			fontIsTooBig = false;
			int xcrd = ( coord2.x + coord.x - size.cx ) / 2;
			int ycrd = ( coord2.y + coord.y - size.cy ) / 2;
			memDC.SetBkMode(TRANSPARENT);
			memDC.TextOut(xcrd,ycrd,theText.ToCString(),theText.Len());
			memDC.SelectObject(oldpen);
			memDC.SelectObject(oldFont);
		}
		else
		{
			//Reduced the logfont height, put the oldfont back into the DC and repeat.
			theLogfont.lfHeight -= 10;
			memDC.SelectObject(oldFont); //Our CFont goes out of scope, and is deleted automatically
		}
	}
	memDC.SelectObject(oldMemDCBitmap);
}

void CxChart::Invert(Boolean inverted)
{
	m_inverted = inverted;
}

void CxChart::NoEdge()
{
	ModifyStyleEx(WS_EX_CLIENTEDGE,NULL,0);
}

void CxChart::OnKeyDown ( UINT nChar, UINT nRepCnt, UINT nFlags )
{
            switch (nChar) {
                  case VK_LEFT:
                  case VK_RIGHT:
                  case VK_UP:
                  case VK_DOWN:
                  case VK_INSERT:
                  case VK_DELETE:
                  case VK_END:
                  case VK_ESCAPE:

                        ((CrChart*)mWidget)->SysKey( nChar );

                        break;
                  default:
                  //Do nothing
                        break;
            }

      CWnd::OnKeyDown( nChar, nRepCnt, nFlags );
}
