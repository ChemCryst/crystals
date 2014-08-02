////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CxPlot.h
//   Authors:   Steve Humphreys and Richard Cooper
//   Created:   09.11.2001 23:09
//
//   $Log: not supported by cvs2svn $
//   Revision 1.22  2012/05/11 11:00:18  rich
//   Double thickness axes for wx version. Fix build bug.
//
//   Revision 1.21  2012/05/11 10:13:31  rich
//   Various patches to wxWidget version to catch up to MFc version.
//
//   Revision 1.20  2011/03/04 05:59:28  rich
//   Don't use 's' as a variable in function signature - it interferes with something in a library somewhere.
//
//   Revision 1.19  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.18  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.17  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.16  2003/01/14 10:27:19  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.15  2002/07/03 14:23:21  richard
//   Replace as many old-style stream class header references with new style
//   e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
//   Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
//   stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
//   Removed some bits from Steve's Plot classes that were generating (harmless) compiler
//   warning messages.
//
//   Revision 1.14  2002/03/07 10:46:45  DJWgroup
//   SH: Change to fix reversed y axes; realign text labels.
//
//   Revision 1.13  2002/02/21 15:23:14  DJWgroup
//   SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
//   Revision 1.12  2002/02/20 12:05:21  DJWgroup
//   SH: Added class to allow easier passing of mouseover information from plot classes.
//
//   Revision 1.11  2002/02/19 16:34:52  ckp2
//   Menus for plots.
//
//   Revision 1.10  2002/02/18 15:16:44  DJWgroup
//   SH: Added ADDSERIES command, and allowed series to have different lengths.
//
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
#include    "ccrect.h"

#ifdef __BOTHWX__
#include <wx/control.h>
#include <wx/colour.h>
#include <wx/bitmap.h>
#include <wx/dcmemory.h>
#include <wx/stattext.h>
#define BASEPlot wxControl
#define BASEPlotKey wxWindow

// These macros are being defined somewhere. They shouldn't be.

#ifdef GetCharWidth
 #undef GetCharWidth
#endif
#ifdef DrawText
 #undef DrawText
#endif
#endif

#ifdef __BOTHWX__
class mywxStaticText : public wxStaticText
{
  public:
    mywxStaticText(wxWindow* wins,int i,wxString s,wxPoint p,wxSize ss,int f);
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
#define BASEPlotKey CWnd
#endif

class CxPlot;

class CxPlotKey : public BASEPlotKey
{
public:
        CxPlotKey(CxPlot* parent, int numser, string* names, int** col);
        ~CxPlotKey();
        int GetNumberOfSeries() {return m_NumberOfSeries;};
#ifdef __CR_WIN__
        afx_msg void OnPaint();
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
                void OnPaint(wxPaintEvent & event );
                DECLARE_EVENT_TABLE()
#endif

        CxPlot* m_Parent;
        bool mDragging;
        CcPoint mDragPos;

        CcRect m_WinPosAndSize;

        int m_NumberOfSeries;
        string* m_Names;
        int** m_Colours;

#ifdef __CR_WIN__
        CDC * m_memDC;
#endif

};

class CrPlot;
class CxGrid;
class CcPoint;

class CxPlot : public BASEPlot
{
// Public interface exposed to the CrClass:
    public:

        void DrawLine (int thickness, int x1, int y1, int x2, int y2); // STEVE added a line thickness parameter
        void DrawPoly(int nVertices, int* vertices, bool fill);
        void DrawText(int x, int y, string text, int param, int fontsize);// STEVE added a parameter (justification of text)
        void DrawEllipse(int x, int y, int w, int h, bool fill);
		void DrawCross(int x, int y, int w);
        void SetColour(int r, int g, int b);                            // STEVE added this function
        void Clear();

        static CxPlot *    CreateCxPlot( CrPlot * container, CxGrid * guiParent );
        CxPlot(CrPlot* container);
        ~CxPlot();
        void CxDestroyWindow();

        void SetText( const string & text );
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

        CcPoint GetTextArea(int size, string text, int param);
        void Focus();
        void Display();
        
        void DeletePopup();
        void CreatePopup(string atomname, CcPoint point);
        void DeleteKey();
        void CreateKey(int numser, string* names, int** col);
        void CreateKeyWindow(int x, int y);
        void FlipGraph(bool flipped);
        void MakeMetaFile(int w, int h, string s);
        void PrintPicture();

        CcRect m_client;
        CrGUIElement *  ptr_to_crObject;

private:
        int mIdealHeight;
        int mIdealWidth;
        static int mPlotCount;
        int mPolyMode;
        CcPoint     moldMPos;   // mouse pointer position in last frame
        CcPoint     moldPPos;   // popup position in last frame
        string    moldText;   // popup text in the last frame
        bool        mMouseCaptured;
        bool     m_FlippedPlot;  // if the plot is flipped upside down (eg by ZOOM 4 0), change the LogicalToDevice() and vv. functions

        CxPlotKey*  m_Key;

//Machine specific parts:
#ifdef __CR_WIN__
      public:
        CStatic* m_TextPopup;

        COLORREF mfgcolour;
        CBitmap *m_oldMemDCBitmap, *m_newMemDCBitmap;
        CDC * m_memDC;
    

        afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        afx_msg void OnPaint();
    afx_msg void OnMouseMove( UINT nFlags, CPoint point );
    afx_msg LRESULT OnMouseLeave(WPARAM wParam, LPARAM lParam);
        afx_msg void OnMenuSelected (UINT nID);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
      public:
    
    mywxStaticText * m_TextPopup;
        wxColour mfgcolour;
        wxBitmap *m_oldMemDCBitmap, *m_newMemDCBitmap;
        wxMemoryDC *m_memDC;
//        wxDC *m_memDC;
//        wxPen      * m_pen;
        wxBrush    * m_brush;

        void OnChar(wxKeyEvent & event );
        void OnPaint(wxPaintEvent & event );
    void OnMouseMove(wxMouseEvent & event);
    void OnMouseLeave();
        void OnMenuSelected(wxCommandEvent &event );
        void OnRButtonUp(wxMouseEvent & event);
        DECLARE_EVENT_TABLE()
#endif
};
#endif
