////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CxPlot.h
//   Authors:   Steve Humphreys and Richard Cooper
//   Created:   09.11.2001 23:09
//
//   $Log: not supported by cvs2svn $
//   Revision 1.9  2002/02/18 11:21:14  DJWgroup
//   SH: Update to plot code.
//
//   Revision 1.8  2002/01/14 12:19:56  ckpgroup
//   SH: Various changes. Fixed scatter graph memory allocation.
//   Fixed mouse-over for scatter graphs. Updated graph key.
//
//   Revision 1.7  2001/12/13 16:20:34  ckpgroup
//   SH: Cleaned up the key code. Now redraws correctly, although far too often.
//   Some problems with mouse-move when key is enabled. Fine when disabled.
//
//   Revision 1.6  2001/12/12 16:02:27  ckpgroup
//   SH: Reorganised script to allow right-hand y axes.
//   Added floating key if required, some redraw problems.
//
//   Revision 1.5  2001/12/03 14:25:50  ckp2
//   RIC: Bug fixes. Release version no longer crashes on mouse leave.
//
//   Revision 1.4  2001/11/26 16:47:36  ckpgroup
//   SH: More MouseOver changes. Scatterplots display the graph coordinates of the mouse pointer.
//   Remove labels when mouse leaves window.
//
//   Revision 1.3  2001/11/26 14:02:50  ckpgroup
//   SH: Added mouse-over message support - display label and data value for the bar
//   under the pointer.
//
//   Revision 1.2  2001/11/12 16:24:31  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:51  ckp2
//   The PLOT classes!
//
//

#ifndef     __CxPlot_H__
#define     __CxPlot_H__
#include    "crguielement.h"
#include    "ccpoint.h"
#include	"ccrect.h"

#ifdef __BOTHWX__
#include <wx/control.h>
#include <wx/colour.h>
#include <wx/bitmap.h>
#include <wx/dcmemory.h>
#define BASEPlot wxControl
#endif

#ifdef __BOTHWX__
class mywxStaticText : public wxStaticText
{
  public:
    mywxStaticText(wxWindow* s,int i,wxString s,wxPoint p,wxSize ss,int f);
    wxWindow * m_parent;
    void OnLButtonUp(wxMouseEvent & event);
    void OnLButtonDown(wxMouseEvent & event);
    void OnRButtonUp(wxMouseEvent & event);
    DECLARE_EVENT_TABLE()
};
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEPlot CWnd
#endif

class CxPlot;

#ifdef __CR_WIN__
class CxPlotKey : public BASEPlot
{
public:
		CxPlotKey(CxPlot* parent, int numser, CcString* names, int** col);
		~CxPlotKey();

		afx_msg void OnPaint();
		DECLARE_MESSAGE_MAP()

		CDC * m_memDC;

		CxPlot* m_Parent;
		bool mDragging;
		CcPoint mDragPos;

		CRect m_WinPosAndSize;

		int m_NumberOfSeries;
		CcString* m_Names;
		int** m_Colours;
};
#endif

class CrPlot;
class CxGrid;
class CcPoint;

class CxPlot : public BASEPlot
{
// Public interface exposed to the CrClass:
    public:

        void DrawLine (int thickness, int x1, int y1, int x2, int y2); // STEVE added a line thickness parameter
        void DrawPoly(int nVertices, int* vertices, Boolean fill);
        void DrawText(int x, int y, CcString text, int param, int fontsize);// STEVE added a parameter (justification of text)
        void DrawEllipse(int x, int y, int w, int h, Boolean fill);
		void SetColour(int r, int g, int b);							// STEVE added this function
        void Clear();

        static CxPlot *    CreateCxPlot( CrPlot * container, CxGrid * guiParent );
        CxPlot(CrPlot* container);
        ~CxPlot();
        void CxDestroyWindow();

        void SetText( char * text );
        void SetIdealWidth(int nCharsWide);
        void SetIdealHeight(int nCharsHigh);
        CcPoint DeviceToLogical(int x, int y);
		CcPoint LogicalToDevice(int x, int y);
        void SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
		int GetMaxFontSize(int width, int height, CcString text, int param);
		CcPoint GetTextArea(int size, CcString text, int param);
        void Focus();
        void Display();
		
		void DeletePopup();
		void CreatePopup(CcString atomname, CcPoint point);
		void DeleteKey();
		void CreateKey(int numser, CcString* names, int** col);
		void CreateKeyWindow(int x, int y);


		CcRect m_client;
        CrGUIElement *  ptr_to_crObject;

private:
		int mIdealHeight;
        int mIdealWidth;
        static int mPlotCount;
        int mPolyMode;
		CcPoint		moldMPos;	// mouse pointer position in last frame
		CcPoint		moldPPos;	// popup position in last frame
		CcString	moldText;	// popup text in the last frame
		bool		mMouseCaptured;

//Machine specific parts:
#ifdef __CR_WIN__
      public:
		CStatic* m_TextPopup;
		CxPlotKey*	m_Key;

        COLORREF mfgcolour;
        CBitmap *m_oldMemDCBitmap, *m_newMemDCBitmap;
        CDC * m_memDC;
	
		void MakeMetaFile(int w, int h);
		void PrintPicture();

        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		afx_msg void OnSize(UINT nType, int cx, int cy);
        afx_msg void OnPaint();
		afx_msg void OnMouseMove( UINT nFlags, CPoint point );
		afx_msg LRESULT OnMouseLeave(WPARAM wParam, LPARAM lParam);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
      public:
    
		mywxStaticText * m_TextPopup;
        wxColour mfgcolour;
        wxBitmap *oldMemDCBitmap, *newMemDCBitmap;
        wxMemoryDC *memDC;
        wxPen      * m_pen;
        wxBrush    * m_brush;

        void OnChar(wxKeyEvent & event );
        void OnPaint(wxPaintEvent & event );
		void OnMouseMove(wxMouseEvent & event);
		void OnMouseLeave();
        DECLARE_EVENT_TABLE()
#endif
};
#endif
