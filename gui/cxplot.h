////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CxPlot.h
//   Authors:   Steve Humphreys and Richard Cooper
//   Created:   09.11.2001 23:09
//
//   $Log: not supported by cvs2svn $
//

#ifndef     __CxPlot_H__
#define     __CxPlot_H__
#include    "crguielement.h"
#include    "ccpoint.h"

#ifdef __BOTHWX__
#include <wx/control.h>
#include <wx/colour.h>
#include <wx/bitmap.h>
#include <wx/dcmemory.h>
#define BASEPlot wxControl
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEPlot CWnd
#endif

class CrPlot;
class CxGrid;
class CcPoint;

class CxPlot : public BASEPlot
{
// Public interface exposed to the CrClass:
    public:

        void DrawLine (int x1, int y1, int x2, int y2);
        void DrawPoly(int nVertices, int* vertices, Boolean fill);
        void DrawText(int x, int y, CcString text);
        void DrawEllipse(int x, int y, int w, int h, Boolean fill);
        void Clear();

        static CxPlot *    CreateCxPlot( CrPlot * container, CxGrid * guiParent );
        CxPlot(CrPlot* container);
        ~CxPlot();
        void CxDestroyWindow();

        void    SetText( char * text );
        void SetIdealWidth(int nCharsWide);
        void SetIdealHeight(int nCharsHigh);
        CcPoint DeviceToLogical(int x, int y);
        void SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        void Focus();
        void Display();


        CrGUIElement *  ptr_to_crObject;
        int mIdealHeight;
        int mIdealWidth;
        static int mPlotCount;
        int mPolyMode;

//Machine specific parts:
#ifdef __CR_WIN__
      public:

        COLORREF mfgcolour;
        CBitmap *m_oldMemDCBitmap, *m_newMemDCBitmap;
        CDC * m_memDC;

        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        afx_msg void OnPaint();
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
      public:

        wxColour mfgcolour;
        wxBitmap *oldMemDCBitmap, *newMemDCBitmap;
        wxMemoryDC *memDC;
        wxPen      * m_pen;
        wxBrush    * m_brush;

        void OnChar(wxKeyEvent & event );
        void OnPaint(wxPaintEvent & event );
        DECLARE_EVENT_TABLE()
#endif
};
#endif
