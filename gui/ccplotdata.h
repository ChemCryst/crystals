////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:47
//   $Log: not supported by cvs2svn $
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

#include "ccstring.h"
#include "ccpoint.h"
class CcTokenList;
class CcList;
class CrPlot;
class CcPlotdata;
class CcSeries;

class CcAxisData
{
public:
	CcAxisData();
	~CcAxisData();
	bool CalculateLinearDivisions();
	bool CalculateLogDivisions();

	float m_Min;					// the lowest data value associated with this axis
	float m_Max;					// and the highest

	float m_AxisMin;				// the axis limits
	float m_AxisMax;

	float m_Delta;					// the division spacing for this axis
	int	  m_NumDiv;					// number of divisions

	float* m_AxisDivisions;			// and the divisions themselves

	int   m_AxisScaleType;			// auto / span / zoom
	bool  m_AxisLog;				// log if true, linear if false

	CcString m_Title;			// the title of this axis
};	

class CcPlotAxes
{
public:
	CcPlotAxes();
	virtual ~CcPlotAxes();

	Boolean CalculateDivisions();

	void CheckData(int axis, float data);
	void DrawAxes(CrPlot* attachedPlot);	// draw lines, markers and text

	CcString*		m_Labels;		// one label per data item (only for bar graphs)
	CcString		m_PlotTitle;	// graph title

	CcAxisData		m_AxisData[3];	// the axes themselves

	int		m_NumberOfYAxes;		// graph can have either one or two y axes (left and right sides)
	int		m_GraphType;			//  bargraphs - only calculate axis divisions for y axis
									//  scatter / line - calculate axis divisions for both axes
};

class CcPlotData
{
public:
    virtual void DrawView() =0;
    void Clear();
    virtual Boolean ParseInput( CcTokenList * tokenList );
    CcPlotData();
    virtual ~CcPlotData();
    CcPlotData * FindObject( CcString Name );
    static CcPlotData* CreatePlotData( CcTokenList * tokenList );

    static CcList  sm_PlotList;
    static CcPlotData* sm_CurrentPlotData;

	virtual CcString GetDataFromPoint(CcPoint* point) = 0;

	virtual void CreateSeries(int numser, int* type) = 0;
	virtual void AllocateMemory(int length) = 0;
	virtual void AddSeries(int type) = 0;
	virtual void ExtendSeriesLength() = 0;

	void DrawKey();
	int FindSeriesType(CcString textstyle);

    CcSeries**		m_Series;		// array of series
	int				m_SeriesLength; // length of the data series (NB all the same)
	int				m_NextItem;		// number of data items added so far to each series
	CcPlotAxes		m_Axes;
	Boolean			m_AxesOK;

	Boolean			m_DrawKey;		// draw a key of the series names / colours?

	int				m_CurrentSeries;// currently selected series (init as -1 = all)
	int				m_CurrentAxis;	// currently selected axis (init as -1 = all)

	int				m_NumberOfSeries;// number of series in the list
	int				m_Colour[3][6];	// sequence for colours
	int				m_XGapLeft;		// the margins around the graph
	int				m_XGapRight;
	int				m_YGapTop;
	int				m_YGapBottom;

	int				m_CompleteSeries;// number of series with all data present (eg to let ADDSERIES work...)
	int				m_NewSeriesNextItem;// number of data items given to the new series
	bool			m_NewSeries;	// true if there is an incomplete series present

protected:
    CcString mName;					// internal name
    CrPlot* attachedPlot;
private:
    Boolean mSelfInitialised;
};

// each series holds ONE data set.
class CcSeries
{
public:
    CcSeries();
	virtual ~CcSeries();
    virtual Boolean ParseInput( CcTokenList * tokenList );
 
	CcString		mName;			// internal name
	CcString		m_SeriesName;	// one name per series
	int				m_DrawStyle;	// how to draw this series (scatter / bar / line / etc)
	int				m_YAxis;		// which y axis is this series attached to (left or right)

	virtual void AllocateMemory(int length)=0;		// allocate space for 'length' bits of data per

private:
	int				m_Type;			// type of series - bar / scatter (defined above)
};


// These are the script commands handled by the plot classes.
// Any change here must also be made to cctokenlist.cpp
#define kSPlotAttach       "ATTACH"
#define kSPlotShow         "SHOW"
#define kSPlotBarGraph     "BARGRAPH"
#define kSPlotScatter      "SCATTER"
#define kSPlotSeries       "SERIES"
#define kSPlotNSeries	   "NSERIES"
#define kSPlotLength	   "LENGTH"
#define kSPlotLabel		   "LABEL"
#define kSPlotData		   "DATA"
#define kSPlotAuto		   "AUTO"
#define kSPlotSpan		   "SPAN"
#define kSPlotZoom		   "ZOOM"
#define kSPlotLinear	   "LINEAR"
#define kSPlotLog		   "LOG"
#define kSPlotTitle		   "PLOTTITLE"
#define kSPlotSeriesName   "SERIESNAME"
#define kSPlotAxisTitle	   "TITLE"
#define kSPlotSeriesType   "TYPE"
#define kSPlotAddSeries	   "ADDSERIES"
#define kSPlotXAxis		   "XAXIS"
#define kSPlotYAxis		   "YAXIS"
#define kSPlotYAxisRight   "YAXISRIGHT"
#define kSPlotUseRightAxis "USERIGHTAXIS"
#define kSPlotKey		   "KEY"
enum
{
 kTPlotAttach = 300,
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
 kTPlotKey
};


// series types (controls how series is drawn)
enum
{
	Plot_SeriesBar,
	Plot_SeriesLine,
	Plot_SeriesScatter,
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
