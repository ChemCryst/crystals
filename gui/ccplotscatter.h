////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:15
//   $Log: not supported by cvs2svn $
//   Revision 1.3  2001/11/19 16:32:21  ckpgroup
//   SH: General update, bug-fixes, better text alignment. Removed a lot of duplicate code.
//
//   Revision 1.2  2001/11/12 16:24:29  ckpgroup
//   SH: Graphical agreement analysis
//
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
        Boolean ParseInput( CcTokenList * tokenList );
        CcPlotScatter();
        virtual ~CcPlotScatter();

		CcString GetDataFromPoint(CcPoint point);
		void CreateSeries(int numser, int* type);
		void AllocateMemory(int length);
};

class CcSeriesScatter : public CcSeries
{
public:
	Boolean ParseInput(CcTokenList * tokenList);
	CcSeriesScatter();
	virtual ~CcSeriesScatter();

	void AllocateMemory(int length);

	float *		m_Data[2];					// pointer to a this series' data (x and y)
};

#endif
