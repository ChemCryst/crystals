////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:47
//   $Log: not supported by cvs2svn $

#ifndef     __CcPlotData_H__
#define     __CcPlotData_H__

#include "ccstring.h"
class CcTokenList;
class CcList;
class CrPlot;
class CcPlotdata;


class CcPlotData
{
    public:
        virtual void DrawView() = 0;
        virtual void Clear() = 0;
        virtual Boolean ParseInput( CcTokenList * tokenList );
        CcPlotData();
        ~CcPlotData();
        CcPlotData * FindObject( CcString Name );
        static CcPlotData* CreatePlotData( CcTokenList * tokenList );

        static CcList  sm_PlotList;
        static CcPlotData* sm_CurrentPlotData;

    protected:
        CcString mName;
        CrPlot* attachedPlot;
        CcList* m_seriesList;

    private:
        Boolean mSelfInitialised;
};


#define SERIES_LABEL  1
#define SERIES_XVALUE 2
#define SERIES_YVALUE 3

class CcSeries
{
    public:
        CcSeries();
        Boolean ParseInput( CcTokenList * tokenList );
        CcString mName;
    private:
        int m_type;
        int r,g,b;
        float * xdata;
        float * ydata;
        CcString* xlabel;
        int m_Length;
        int m_Next;
};


#define kSPlotAttach       "ATTACH"
#define kSPlotShow         "SHOW"
#define kSPlotBarGraph     "BARGRAPH"
#define kSPlotScatter      "SCATTER"
#define kSPlotSeries       "SERIES"
#define kSPlotLabel        "LABEL"
#define kSPlotXValue       "XVALUE"
#define kSPlotYValue       "YVALUE"
#define kSPlotData         "DATA"

enum
{
 kTPlotAttach = 300,
 kTPlotShow,
 kTPlotBarGraph,
 kTPlotScatter,
 kTPlotSeries,
 kTPlotLabel,
 kTPlotXValue,
 kTPlotYValue,
 kTPlotData
};


#endif
