////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CrPlot.h
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:28
//
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.10  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.9  2002/03/07 10:46:44  DJWgroup
//   SH: Change to fix reversed y axes; realign text labels.
//
//   Revision 1.8  2002/02/20 12:05:20  DJWgroup
//   SH: Added class to allow easier passing of mouseover information from plot classes.
//
//   Revision 1.7  2002/02/19 16:34:52  ckp2
//   Menus for plots.
//
//   Revision 1.6  2002/02/18 11:21:13  DJWgroup
//   SH: Update to plot code.
//
//   Revision 1.5  2001/12/13 16:20:33  ckpgroup
//   SH: Cleaned up the key code. Now redraws correctly, although far too often.
//   Some problems with mouse-move when key is enabled. Fine when disabled.
//
//   Revision 1.4  2001/12/12 16:02:26  ckpgroup
//   SH: Reorganised script to allow right-hand y axes.
//   Added floating key if required, some redraw problems.
//
//   Revision 1.3  2001/11/26 14:02:50  ckpgroup
//   SH: Added mouse-over message support - display label and data value for the bar
//   under the pointer.
//
//   Revision 1.2  2001/11/12 16:24:31  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//
//

#ifndef     __CrPlot_H__
#define     __CrPlot_H__
#include    "crguielement.h"
#include    <string>
using namespace std;


#ifndef CRY_USEMFC
// These macros are being defined somewhere. They shouldn't be.

#ifdef GetCharWidth
 #undef GetCharWidth
#endif
#ifdef DrawText
 #undef DrawText
#endif

#endif


class CcPoint;
class CrMenu;
class CcPlotData;

#define TEXT_VCENTRE        1
#define TEXT_HCENTRE        2
#define TEXT_RIGHT          4
#define TEXT_TOP            8
#define TEXT_VERTICAL       16
#define TEXT_BOLD           32
#define TEXT_ANGLE          64
#define TEXT_BOTTOM         128
#define TEXT_VERTICALDOWN   256

class PlotDataPopup
{
public:
    PlotDataPopup() {m_Valid = false;};
    ~PlotDataPopup(){};

    string    m_PopupText;        // all the popup text
    string    m_SeriesName;       // series name only
    string    m_XValue;           // x value (or the x label for bargraphs)
    string    m_YValue;           // y value
    string    m_Label;            // point label

    bool     m_Valid;            // is this a valid point?
};

class CrPlot : public CrGUIElement
{
    public:
//Functions for drawing on the window:
        void DrawLine(int thickness, int x1, int y1, int x2, int y2); // STEVE added thickness parameter
        void DrawText(int x, int y, string text, int param, int fontsize);// STEVE added justification parameter
        void DrawRect(int x1, int y1, int x2, int y2, bool fill);
        void DrawPoly(int nVertices, int* vertices, bool fill);
		void DrawCross(int x, int y, int w);
        void DrawEllipse(int x, int y, int w, int h, bool fill);
        void SetColour(int r, int g, int b);                            // STEVE added this - set colour in cxplot class
        void Clear();
        CcPoint GetTextArea(int size, string text, int param);
        PlotDataPopup GetDataFromPoint(CcPoint *point);                 // get a description of the data under the mouse
        void CreateKey(int numser, string* names, int** col);

//Creation and adding data:
        void Attach(CcPlotData* doc);
        CrPlot( CrGUIElement * mParentPtr );
        ~CrPlot();

        void ContextMenu(CcPoint * xy, int x1, int y1);
        void ReDrawView(bool print);
        void Display();
        void CrFocus();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetGeometry( const CcRect * rect );
        void    MenuSelected(int id);
        CcRect  GetGeometry();
        CcRect  CalcLayout(bool recalculate=false);
        void    SetText( const string &text );
        int GetIdealWidth();
        int GetIdealHeight();
        void FlipGraph(bool flip);

//attributes
        CcPlotData* attachedPlotData;
        CrMenu* m_cmenu;
        
};


#endif
