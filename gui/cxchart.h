////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxChart

////////////////////////////////////////////////////////////////////////

//   Filename:  CxChart.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#ifndef		__CxChart_H__
#define		__CxChart_H__
//Insert your own code here.
#include	"CrGUIElement.h"

#ifdef __POWERPC__
class LStdChart;
#endif

#ifdef __MOTO__
#include	<LStdControl.h>
#endif

#ifdef __LINUX__
#include <qpushbt.h>
#include <qobject.h>
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#endif

class CrChart;
class CxGrid;
//End of user code.         
 
class	CxChart : public CWnd
{
	public:
		void NoEdge();
		void Invert(Boolean inverted);
		void FitText(int x1, int y1, int x2, int y2, CcString theText, Boolean rotated);
		void UseIsotropicCoords(Boolean iso);
		int mPolyMode;
		void SetPolygonDrawMode(Boolean on);
		void SetColour(int r, int g, int b);
		void DrawPoly(int nVertices, int* vertices, Boolean fill);
		void DrawText(int x, int y, CcString text);
		void DrawEllipse(int x, int y, int w, int h, Boolean fill);
		void Clear();
		int mIdealHeight;
		int mIdealWidth;
		void SetIdealWidth(int nCharsWide);
		void SetIdealHeight(int nCharsHigh);
		void Display();
		CPoint DeviceToLogical(int x, int y);
		CPoint LogicalToDevice(CPoint point);
		COLORREF mfgcolour;
		CBitmap *oldMemDCBitmap, *newMemDCBitmap;
		CDC memDC;
		void DrawLine (int x1, int y1, int x2, int y2);
		void Focus();
		// methods
		static CxChart *	CreateCxChart( CrChart * container, CxGrid * guiParent );
		CxChart(CrChart* container);
		~CxChart();
		void	SetText( char * text );
		void	SetGeometry( int top, int left, int bottom, int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int AddChart( void ) { mChartCount++; return mChartCount; };
		static void RemoveChart( void ) { mChartCount--; };
		void	BroadcastValueMessage( void );
		
		// attributes
		CrGUIElement *	mWidget;
		static int mChartCount;
//		LDefaultOutline * mOutlineWidget;

//		afx_msg void ChartClicked();
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		afx_msg void OnPaint();
		afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
		afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
		afx_msg void OnMouseMove( UINT nFlags, CPoint point );
	



		DECLARE_MESSAGE_MAP()

private:
	Boolean m_inverted;
	Boolean m_IsoCoords;
	CPoint mLastPolyModePoint;
	CPoint mStartPolyModePoint;
	CPoint mCurrentPolyModeLineEndPoint;
};
#endif
