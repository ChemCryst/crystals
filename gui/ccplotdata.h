////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:47
//   $Log: not supported by cvs2svn $
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
class CcPlotAxes;

class CcPlotData
{
    public:
        virtual void DrawView() = 0;
        virtual void Clear() = 0;
        virtual Boolean ParseInput( CcTokenList * tokenList );
        CcPlotData();
        virtual ~CcPlotData();
        CcPlotData * FindObject( CcString Name );
        static CcPlotData* CreatePlotData( CcTokenList * tokenList );

        static CcList  sm_PlotList;
        static CcPlotData* sm_CurrentPlotData;

        CcSeries* m_Series;			// needs to be a pointer, since although only one it is derived to be ie CcSeriesBar
		CcPlotAxes * m_Axes;
		Boolean m_AxesOK;
		CcString m_PlotTitle;		// graph title
		CcString m_XTitle;			// and the x and y labels
		CcString m_YTitle;

    protected:
        CcString mName;				// internal name
        CrPlot* attachedPlot;
    private:
        Boolean mSelfInitialised;
};

enum
{
	Plot_SeriesBar,
	Plot_SeriesScatter
};

class CcSeries
{
    public:
        CcSeries();
		virtual ~CcSeries();
        virtual Boolean ParseInput( CcTokenList * tokenList );
        CcString mName;
		int	m_NumberOfSeries;
		int m_Length;
        int m_Next;

		int m_Colour[3][6];		// sequence for colours
		CcString*	m_SeriesName;					// one name per series

		virtual void CreateSeries(int numseries)=0;		// create data series
		virtual void AllocateMemory(int length)=0;		// allocate space for 'length' bits of data per

    private:
		int m_Type;	// type of series - bar / scatter (defined above)

};


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

enum
{
	Axis_X = 0,
	Axis_Y
};

enum 
{
	Plot_AxisAuto,
	Plot_AxisSpan,
	Plot_AxisZoom
};

enum
{
	Plot_AxisLinear,
	Plot_AxisLog
};

class CcPlotAxes
{
public:
	CcPlotAxes();
	virtual ~CcPlotAxes();

	virtual Boolean CalculateDivisions() = 0;

	virtual Boolean CalculateLinearDivisions(int axis);
	virtual Boolean CalculateLogDivisions(int axis);

	virtual	void CheckData(int axis, float data) = 0;

	float m_Max[2];				// maximum and minimum of the DATA
	float m_Min[2];

	float m_AxisMax[2];			// max and min of the axes (default to same as data range)
	float m_AxisMin[2];		

	float m_Delta[2];			// distance between divisions

	int m_NumDiv[2];			// number of divisions per axis

	float *m_AxisDivisions[2];	// storage for the division markers

	int m_AxisScaleType;		// either auto, span or zoom
	bool m_AxisLog[2];			// log if true, linear if false

};


#endif
