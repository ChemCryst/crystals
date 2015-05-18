////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxChart

////////////////////////////////////////////////////////////////////////

//   Filename:  CxChart.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.2  2005/01/17 09:41:34  rich
//   Fixed printing in WX version of Cameron.
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.15  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.14  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.13  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.12  2002/05/08 08:56:13  richard
//   Added support for wmf AND emf file output to Chart objects (Cameron). Reason:
//   emf doesn't work on Windows 95. Bah.
//
//   Revision 1.11  2002/01/30 10:58:43  ckp2
//   RIC: Printing and WMF capability for CxChart object. - NB. Steve, this can easily
//   be copied to CxPlot to do same thing.
//
//   Revision 1.10  2001/10/10 12:44:51  ckp2
//   The PLOT classes!
//
//   Revision 1.9  2001/07/16 07:29:29  ckp2
//   Really messed around with the creation of the memory device context in the wx version.
//   Now it is deleted and recreated (along with it's bitmap) every time the window is
//   resized. This seems the best way to stop it randomly crashing with an invalid wxPen warning.
//
//   Revision 1.8  2001/06/17 14:46:04  richard
//   CxDestroyWindow function.
//   wx bug fixes.
//
//   Revision 1.7  2001/03/08 16:44:08  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxChart_H__
#define     __CxChart_H__
#include    "crguielement.h"
#include    "ccpoint.h"

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASECHART CWnd
#else
 #include <wx/control.h>
 #include <wx/colour.h>
 #include <wx/bitmap.h>
 #include <wx/dcmemory.h>
 #define BASECHART wxControl
// These macros are being defined somewhere. They shouldn't be.

 #ifdef GetCharWidth
  #undef GetCharWidth
 #endif
 #ifdef DrawText
  #undef DrawText
 #endif

#endif


#include "ccrect.h"

class CrChart;
class CxGrid;
class CcPoint;
//End of user code.

class CxChart : public BASECHART
{
// Public interface exposed to the CrClass:
    public:
        void NoEdge();
        void Invert(bool inverted);
        void FitText(int x1, int y1, int x2, int y2, string theText, bool rotated);
        void UseIsotropicCoords(bool iso);
        void SetPolygonDrawMode(bool on);
        void SetColour(int r, int g, int b);
        void CxDestroyWindow();
        void DrawPoly(int nVertices, int* vertices, bool fill);
        void DrawText(int x, int y, string text);
        void DrawEllipse(int x, int y, int w, int h, bool fill);
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
        void    SetText( const string & text );
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
        void MakeMetaFile(int w, int h, bool enhanced);
        void PrintPicture();

        CrGUIElement *  ptr_to_crObject;
        static int mChartCount;
        int mPolyMode;

private:
        bool m_inverted;
        bool m_IsoCoords;
        bool m_SendCursorKeys;
        CcPoint mLastPolyModePoint;
        CcPoint mStartPolyModePoint;
        CcPoint mCurrentPolyModeLineEndPoint;
        CcRect m_client;

// Private machine specific parts:
#ifdef CRY_USEMFC
      public:
        COLORREF mfgcolour;
        CBitmap *oldMemDCBitmap, *newMemDCBitmap;
        CDC * memDC;

        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        afx_msg void OnPaint();
        afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
        afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
        afx_msg void OnMouseMove( UINT nFlags, CPoint point );
        afx_msg void OnKeyDown( UINT nChar, UINT nRepCnt, UINT nFlags );
        DECLARE_MESSAGE_MAP()
#else
      public:
            wxColour mfgcolour;
            wxBitmap *oldMemDCBitmap, *newMemDCBitmap;
//            wxMemoryDC *memDC;
            wxDC *memDC;
            wxPen      * m_pen;
            wxBrush    * m_brush;
            void PrintPic(wxDC * dc); // Call back from wxPrintout derived class


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
