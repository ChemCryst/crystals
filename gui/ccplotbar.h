////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:19
//   $Log: not supported by cvs2svn $
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

class CcTokenList;
class CcList;
class CrPlot;
class CcSeriesBar;
class CcPlotAxes;
class CcString;

class CcPlotBar : public CcPlotData
{
    public:
        void DrawView();
        Boolean ParseInput( CcTokenList * tokenList );
        CcPlotBar();
        virtual ~CcPlotBar();

		CcString GetDataFromPoint(CcPoint point);	
		void CreateSeries(int numser, int* type);		// creates all data series (type is a block of numser series types)
		void AllocateMemory(int length);				// calls AllocateMemory for each series.
};

class CcSeriesBar : public CcSeries
{
	public:
		Boolean ParseInput( CcTokenList * tokenList );
		CcSeriesBar();
		virtual ~CcSeriesBar();

		void AllocateMemory(int length);

		float *		m_Data;							// one number per data item
};

#endif
