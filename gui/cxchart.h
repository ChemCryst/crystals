////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxChart

////////////////////////////////////////////////////////////////////////

//   Filename:  CxChart.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#ifndef     __CxChart_H__
#define     __CxChart_H__
//Insert your own code here.
#include    "crguielement.h"
#include    "ccpoint.h"

#ifdef __POWERPC__
class LStdChart;
#endif

#ifdef __MOTO__
#include    <LStdControl.h>
#endif

#ifdef __BOTHWX__
#include <wx/control.h>
#include <wx/colour.h>
#include <wx/bitmap.h>
#include <wx/dcmemory.h>
#define BASECHART wxControl
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASECHART CWnd
#endif

class CrChart;
class CxGrid;
class CcPoint;
//End of user code.

class CxChart : public BASECHART
{
// Public interface exposed to the CrClass:
    public:
        void NoEdge();
        void Invert(Boolean inverted);
        void FitText(int x1, int y1, int x2, int y2, CcString theText, Boolean rotated);
        void UseIsotropicCoords(Boolean iso);
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
            CcPoint DeviceToLogical(int x, int y);
            CcPoint LogicalToDevice(CcPoint point);
        void DrawLine (int x1, int y1, int x2, int y2);
        void Focus();
        static CxChart *    CreateCxChart( CrChart * container, CxGrid * guiParent );
        CxChart(CrChart* container);
        ~CxChart();
        void    SetText( char * text );
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int AddChart( void ) { mChartCount++; return mChartCount; };
        static void RemoveChart( void ) { mChartCount--; };
        void    BroadcastValueMessage( void );

        CrGUIElement *  ptr_to_crObject;
        static int mChartCount;
        int mPolyMode;

private:
            Boolean m_inverted;
            Boolean m_IsoCoords;
            Boolean m_SendCursorKeys;
            CcPoint mLastPolyModePoint;
            CcPoint mStartPolyModePoint;
            CcPoint mCurrentPolyModeLineEndPoint;

// Private machine specific parts:
#ifdef __CR_WIN__
      public:

        COLORREF mfgcolour;
        CBitmap *oldMemDCBitmap, *newMemDCBitmap;
        CDC memDC;

        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        afx_msg void OnPaint();
        afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
        afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
        afx_msg void OnMouseMove( UINT nFlags, CPoint point );
        afx_msg void OnKeyDown( UINT nChar, UINT nRepCnt, UINT nFlags );
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
      public:

            wxColour mfgcolour;
            wxBitmap *oldMemDCBitmap, *newMemDCBitmap;
            wxMemoryDC memDC;

            void OnLButtonUp(wxMouseEvent & event);
            void OnRButtonUp(wxMouseEvent & event);
            void OnMouseMove(wxMouseEvent & event);
            void OnChar(wxKeyEvent & event );
            void OnKeyDown( wxKeyEvent & event );
            void OnPaint(wxPaintEvent & event );
            DECLARE_EVENT_TABLE()
#endif
};
#endif
