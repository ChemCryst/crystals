////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:47
//   $Log: not supported by cvs2svn $
//   Revision 1.2  2001/11/12 16:24:29  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:49  ckp2
//   The PLOT classes!
//

#ifndef     __CcPlotData_H__
#define     __CcPlotData_H__

#include "ccstring.h"
class CcTokenList;
class CcList;
class CrPlot;
class CcPlotdata;
class CcSeries;

class CcPlotAxes
{
public:
	CcPlotAxes();
	virtual ~CcPlotAxes();

	Boolean CalculateDivisions();

	Boolean CalculateLinearDivisions(int axis);
	Boolean CalculateLogDivisions(int axis);

	void CheckData(int axis, float data);
	void DrawAxes(CrPlot* attachedPlot);	// draw lines, markers and text

	CcString*		m_Labels;		// one label per data item (only for bar graphs)
	CcString		m_PlotTitle;	// graph title
	CcString		m_XTitle;		// and the x and y labels
	CcString		m_YTitle;

	float	m_Max[2];				// maximum and minimum of the DATA
	float	m_Min[2];

	float	m_AxisMax[2];			// max and min of the axes (default to same as data range)
	float	m_AxisMin[2];		

	float	m_Delta[2];				// distance between divisions

	int		m_NumDiv[2];			// number of divisions per axis

	float *	m_AxisDivisions[2];		// storage for the division markers

	int		m_AxisScaleType;		// either auto, span or zoom
	bool	m_AxisLog[2];			// log if true, linear if false

	int		m_GraphType;			//  bargraphs - only calculate axis divisions for y axis
									//  scatter / line - calculate axis divisions for both axes
};

class CcPlotData
{
public:
    virtual void DrawView() = 0;
    void Clear();
    virtual Boolean ParseInput( CcTokenList * tokenList );
    CcPlotData();
    virtual ~CcPlotData();
    CcPlotData * FindObject( CcString Name );
    static CcPlotData* CreatePlotData( CcTokenList * tokenList );

    static CcList  sm_PlotList;
    static CcPlotData* sm_CurrentPlotData;

	virtual void CreateSeries(int numser, int* type) = 0;
	virtual void AllocateMemory(int length) = 0;

    CcSeries**		m_Series;		// array of series
	int				m_SeriesLength; // length of the data series (NB all the same)
	int				m_NextItem;		// number of data items added so far to each series
	CcPlotAxes		m_Axes;
	Boolean			m_AxesOK;

	int				m_NumberOfSeries;// number of series in the list
	int				m_Colour[3][6];	// sequence for colours

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
        CcString mName;

		CcString	m_SeriesName;					// one name per series

		virtual void AllocateMemory(int length)=0;		// allocate space for 'length' bits of data per

    private:
		int m_Type;	// type of series - bar / scatter (defined above)
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
#define kSPlotXTitle	   "XTITLE"
#define kSPlotYTitle	   "YTITLE"

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
 kTPlotXTitle,
 kTPlotYTitle
};


// series types (controls how series is drawn)
enum
{
	Plot_SeriesBar,
	Plot_SeriesScatter
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
	Axis_Y
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
