////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:15
//   $Log: not supported by cvs2svn $
//   Revision 1.1  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//

#ifndef     __CcPlotScatter_H__
#define     __CcPlotScatter_H__

#include "ccstring.h"
class CcTokenList;
class CcList;
class CrPlot;
class CcSeriesScatter;
class CcString;
class CcPlotAxes;

class CcPlotScatter : public CcPlotData
{
    public:
        void DrawView();
        void Clear();
        Boolean ParseInput( CcTokenList * tokenList );
        CcPlotScatter();
        virtual ~CcPlotScatter();
};

class CcSeriesScatter : public CcSeries
{
public:
	Boolean ParseInput(CcTokenList * tokenList);
	CcSeriesScatter();
	virtual ~CcSeriesScatter();

	void AllocateMemory(int length);
	void CreateSeries(int sernum);

	float **	m_Data[2];
};

class CcPlotAxesScatter : public CcPlotAxes
{
public:
	CcPlotAxesScatter();
	virtual ~CcPlotAxesScatter();

	Boolean CalculateDivisions();
	void CheckData(int axis, float data);
};

#endif
