////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:19
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.13  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.12  2003/05/07 12:18:56  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.11  2002/02/21 15:23:11  DJWgroup
//   SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
//   Revision 1.10  2002/02/20 12:05:18  DJWgroup
//   SH: Added class to allow easier passing of mouseover information from plot classes.
//
//   Revision 1.9  2002/02/18 11:21:11  DJWgroup
//   SH: Update to plot code.
//
//   Revision 1.8  2002/01/16 10:28:38  ckpgroup
//   SH: Updated memory reallocation for large plots. Added optional labels to scatter points.
//
//   Revision 1.7  2001/12/12 16:02:24  ckpgroup
//   SH: Reorganised script to allow right-hand y axes.
//   Added floating key if required, some redraw problems.
//
//   Revision 1.6  2001/11/29 15:46:08  ckpgroup
//   SH: Update of script commands to support second y axis, general update.
//
//   Revision 1.5  2001/11/26 16:47:35  ckpgroup
//   SH: More MouseOver changes. Scatterplots display the graph coordinates of the mouse pointer.
//   Remove labels when mouse leaves window.
//
//   Revision 1.4  2001/11/26 14:02:48  ckpgroup
//   SH: Added mouse-over message support - display label and data value for the bar
//   under the pointer.
//
//   Revision 1.3  2001/11/19 16:32:19  ckpgroup
//   SH: General update, bug-fixes, better text alignment. Removed a lot of duplicate code.
//
//   Revision 1.2  2001/11/12 16:24:28  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:49  ckp2
//   The PLOT classes!
//

#ifndef     __CcPlotBar_H__
#define     __CcPlotBar_H__
#include <string>
#include <vector>
using namespace std;

class CrPlot;
class CcPlotAxes;
class PlotDataPopup;

class CcPlotBar : public CcPlotData
{
    public:
        void DrawView(bool print);
        bool ParseInput( deque<string> &  tokenList );
        CcPlotBar();
        virtual ~CcPlotBar();

        PlotDataPopup GetDataFromPoint(CcPoint *point); 
        void CreateSeries(int numser, vector<int> & type);       // creates all data series (type is a block of numser series types)
        void AddSeries(int type, int length);           // add a series to the graph
        void SaveToFile(string filename);       // output data to file
        int m_NumberOfBarSeries;                        // bar-series are drawn next to one another, others overlap.
};

#endif
