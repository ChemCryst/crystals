////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:47
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.18  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.17  2003/12/15 11:10:52  rich
//   Fix an array size following last weeks fixes to the plot colour schemes.
//
//   Revision 1.16  2003/12/09 09:51:54  rich
//   Fix colours of data series in plots if > 6 series.
//
//   Revision 1.15  2003/05/07 12:18:56  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.14  2002/03/07 10:46:43  DJWgroup
//   SH: Change to fix reversed y axes; realign text labels.
//
//   Revision 1.13  2002/02/21 15:23:11  DJWgroup
//   SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
//   Revision 1.12  2002/02/20 12:05:19  DJWgroup
//   SH: Added class to allow easier passing of mouseover information from plot classes.
//
//   Revision 1.11  2002/02/18 15:16:42  DJWgroup
//   SH: Added ADDSERIES command, and allowed series to have different lengths.
//
//   Revision 1.10  2002/02/18 11:21:12  DJWgroup
//   SH: Update to plot code.
//
//   Revision 1.9  2002/01/22 16:12:26  ckpgroup
//   Small change to allow inverted axes (eg for Wilson plots). Use 'ZOOM 4 0'.
//
//   Revision 1.8  2002/01/16 10:28:38  ckpgroup
//   SH: Updated memory reallocation for large plots. Added optional labels to scatter points.
//
//   Revision 1.7  2001/12/12 16:02:24  ckpgroup
//   SH: Reorganised script to allow right-hand y axes.
//   Added floating key if required, some redraw problems.
//
//   Revision 1.6  2001/11/29 15:46:09  ckpgroup
//   SH: Update of script commands to support second y axis, general update.
//
//   Revision 1.5  2001/11/26 14:02:48  ckpgroup
//   SH: Added mouse-over message support - display label and data value for the bar
//   under the pointer.
//
//   Revision 1.4  2001/11/22 15:33:20  ckpgroup
//   SH: Added different draw-styles (line / area / bar / scatter).
//   Changed graph layout. Changed second series to blue for better contrast.
//
//   Revision 1.3  2001/11/19 16:32:20  ckpgroup
//   SH: General update, bug-fixes, better text alignment. Removed a lot of duplicate code.
//
//   Revision 1.2  2001/11/12 16:24:29  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:49  ckp2
//   The PLOT classes!
//

#ifndef     __CcPlotData_H__
#define     __CcPlotData_H__


#define NCOLS 7

#include <string>
#include <vector>
#include <deque>
#include <list>
using namespace std;

#include "ccpoint.h"
#include "crplot.h"

// each series holds ONE data set.
class CcSeries
{
public:
    CcSeries();
    virtual ~CcSeries();
    virtual bool ParseInput( deque<string> & tokenList );
 
    string        mName;          // internal name
    string        m_SeriesName;   // one name per series
    int           m_DrawStyle;    // how to draw this series (scatter / bar / line / etc)
    int           m_YAxis;        // which y axis is this series attached to (left or right)
    vector<float> m_Data;
    vector< vector<float> > m_DataXY;
    vector<string> m_Label;
};



class CrPlot;
class CcPlotdata;

class CcAxisData
{
public:
    CcAxisData();
    ~CcAxisData();
    bool CalculateLinearDivisions();
    bool CalculateLogDivisions();

    float m_Min;                    // the lowest data value associated with this axis
    float m_Max;                    // and the highest

    float m_AxisMin;                // the axis limits (not the same as m_M**. Rounded to multiples of m_Delta).
    float m_AxisMax;

    float m_Delta;                  // the division spacing for this axis
    int   m_NumDiv;                 // number of divisions

    float* m_AxisDivisions;         // and the divisions themselves

    int   m_AxisScaleType;          // auto / span / zoom
    bool  m_AxisLog;                // log if true, linear if false

    string m_Title;               // the title of this axis
};  

class CcPlotAxes
{
public:
    CcPlotAxes();
    virtual ~CcPlotAxes();

    bool CalculateDivisions();

    void CheckData(int axis, float data);   // check data against min/max, alter graph bounds if necessary
    void DrawAxes(CrPlot* attachedPlot);    // draw lines, markers and text

    vector<string> m_Labels;               // one label per data item (only for bar graphs)
    int            m_NumberOfLabels;       // amount of memory allocated for the labels
    string         m_PlotTitle;            // graph title

    CcAxisData     m_AxisData[3];          // the axes themselves

    bool           m_Flipped;      // draw graph upsidedown?

    int     m_NumberOfYAxes;                // graph can have either one or two y axes (left and right sides)
    int     m_GraphType;                    //  bargraphs - only calculate axis divisions for y axis
                                            //  scatter / line - calculate axis divisions for both axes
};

class CcPlotData
{
public:
    virtual void DrawView(bool print) =0;       // draw the actual graphical data
    void Clear();
    virtual bool ParseInput( deque<string> & tokenList );
    CcPlotData();
    virtual ~CcPlotData();
    CcPlotData * FindObject( const string & Name );
    static CcPlotData* CreatePlotData( deque<string> & tokenList );

    static list<CcPlotData*>  sm_PlotList;
    static CcPlotData* sm_CurrentPlotData;

    virtual PlotDataPopup GetDataFromPoint(CcPoint* point) = 0; // returns data from a point, for mouse-over messages.
                                                                // NB: PlotDataPopup defined in CrPlot.h

    virtual void CreateSeries(int numser, vector<int> & type) = 0;   // controls memory allocation for a series
    virtual void AddSeries(int type, int length) = 0;       // add a series (after data transfer for previous ones complete)
    virtual void SaveToFile(string filename) = 0;       // output data to file

    void DrawKey();                                         // get the key redrawn.
    int FindSeriesType(string textstyle);

protected:
//    CcSeries**      m_Series;       // array of series
    deque<CcSeries>  m_Series;
    CcPlotAxes      m_Axes;         // the graph axes
    bool         m_AxesOK;       // do graph axes need recalculating? (only if changed)

    bool         m_DrawKey;      // draw a key of the series names / colours?

    int             m_CurrentSeries;// currently selected series (init as -1 = all)
    int             m_CurrentAxis;  // currently selected axis (init as -1 = all)

    int             m_NumberOfSeries;// number of series in the list
    int             m_Colour[3][NCOLS]; // sequence for colours
    int             m_XGapLeft;     // the margins around the graph
    int             m_XGapRight;
    int             m_YGapTop;
    int             m_YGapBottom;

    int             m_CompleteSeries;// number of series with all data present (eg to let ADDSERIES work...)


protected:
    string mName;                 // internal name
    CrPlot* attachedPlot;
private:
    bool mSelfInitialised;
};



// These are the script commands handled by the plot classes.
// Any change here must also be made to cctokenlist.cpp
#define kSPlotAttach       "ATTACH"
#define kSPlotShow         "SHOW"
#define kSPlotBarGraph     "BARGRAPH"
#define kSPlotScatter      "SCATTER"
#define kSPlotSeries       "SERIES"
#define kSPlotNSeries      "NSERIES"
#define kSPlotLength       "LENGTH"
#define kSPlotLabel        "LABEL"
#define kSPlotData         "DATA"
#define kSPlotAuto         "AUTO"
#define kSPlotSpan         "SPAN"
#define kSPlotZoom         "ZOOM"
#define kSPlotLinear       "LINEAR"
#define kSPlotLog          "LOG"
#define kSPlotTitle        "PLOTTITLE"
#define kSPlotSeriesName   "SERIESNAME"
#define kSPlotAxisTitle    "TITLE"
#define kSPlotSeriesType   "TYPE"
#define kSPlotAddSeries    "ADDSERIES"
#define kSPlotXAxis        "XAXIS"
#define kSPlotYAxis        "YAXIS"
#define kSPlotYAxisRight   "YAXISRIGHT"
#define kSPlotUseRightAxis "USERIGHTAXIS"
#define kSPlotKey          "KEY"
#define kSPlotSave         "SAVE"
#define kSPlotExport       "EXPORT"
#define kSPlotPrint        "PLOTPRINT"

enum
{
 kTPlotAttach = 350,
 kTPlotShow,
 kTPlotBarGraph,
 kTPlotScatter,
 kTPlotSeries,
 kTPlotNSeries,
 kTPlotLength,
 kTPlotLabel,
 kTPlotData,
 kTPlotAuto,
 kTPlotSpan,
 kTPlotZoom,
 kTPlotLinear,
 kTPlotLog,
 kTPlotTitle,
 kTPlotSeriesName,
 kTPlotAxisTitle,
 kTPlotSeriesType,
 kTPlotAddSeries,
 kTPlotXAxis,
 kTPlotYAxis,
 kTPlotYAxisRight,
 kTPlotUseRightAxis,
 kTPlotKey,
 kTPlotSave,
 kTPlotPrint,
 kTPlotExport
};


// series types (controls how series is drawn)
enum
{
    Plot_SeriesBar,
    Plot_SeriesLine,
    Plot_SeriesScatter,
    Plot_SeriesScatterX,
    Plot_SeriesArea
};

// graph type
enum 
{
    Plot_GraphBar,
    Plot_GraphScatter
};

// axis identifiers
enum
{
    Axis_X = 0,
    Axis_YL,
    Axis_YR
};

// how the axis is scaled
enum 
{
    Plot_AxisAuto,
    Plot_AxisSpan,
    Plot_AxisZoom
};

// axis scale type
enum
{
    Plot_AxisLinear,
    Plot_AxisLog
};

#endif
