////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:19
//   $Log: not supported by cvs2svn $
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
        void Clear();
        Boolean ParseInput( CcTokenList * tokenList );
        CcPlotBar();
        virtual ~CcPlotBar();
};

class CcSeriesBar : public CcSeries
{
	public:
		Boolean ParseInput( CcTokenList * tokenList );
		CcSeriesBar();
		virtual ~CcSeriesBar();

		void AllocateMemory(int length);
		void CreateSeries(int sernum);

		CcString*	m_Labels;						// one label per data item
		float **	m_Data;							// one number per data item, per series
};

class CcPlotAxesBar : public CcPlotAxes
{
	public:
		CcPlotAxesBar();
		virtual ~CcPlotAxesBar();

		Boolean CalculateDivisions();
		void CheckData(int axis, float data);
};


#endif
