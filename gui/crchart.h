////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrChart

////////////////////////////////////////////////////////////////////////

//   Filename:  CrChart.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   10.6.1998 13:06 Uhr
//   Modified:  10.6.1998 13:06 Uhr

#ifndef		__CrChart_H__
#define		__CrChart_H__
#include	"crguielement.h"
//Insert your own code here.
class CcChartDoc;
class CcTokenList;
//End of user code.         
 
class	CrChart : public CrGUIElement
{
	public:
		void Highlight(Boolean highlight);
		void FitText(int x1, int y1, int x2, int y2, CcString theText, Boolean rotated = false);
		void PolygonClosed();
		void PolygonCancelled();
		void LMouseClick(int x, int y);
		void SetColour(int r, int g, int b);
		void DrawText(int x, int y, CcString text);
		void DrawRect(int x1, int y1, int x2, int y2, Boolean fill);
		void DrawPoly(int nVertices, int* vertices, Boolean fill);
		void DrawEllipse(int x, int y, int w, int h, Boolean fill);
		void Clear();
		int GetIdealWidth();
		int GetIdealHeight();
		void Attach(CcChartDoc* doc);
		CcChartDoc* attachedChartDoc;
		void ReDrawView();
		void Display();
		void DrawLine(int x1, int y1, int x2, int y2);
		void CrFocus();
	// methods
			CrChart( CrGUIElement * mParentPtr );
			~CrChart();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	SetText( CcString text );

	// attributes
};
#endif
