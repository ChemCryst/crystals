////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:19
//   $Log: not supported by cvs2svn $
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

class CcTokenList;
class CcList;
class CrPlot;
class CcSeriesBar;
class CcPlotAxes;
class CcString;
class PlotDataPopup;

class CcPlotBar : public CcPlotData
{
    public:
        void DrawView(bool print);
        Boolean ParseInput( CcTokenList * tokenList );
        CcPlotBar();
        virtual ~CcPlotBar();

		PlotDataPopup GetDataFromPoint(CcPoint *point);	
		void CreateSeries(int numser, int* type);		// creates all data series (type is a block of numser series types)
		void AllocateMemory(int length);				// calls AllocateMemory for each series.
		void AddSeries(int type);						// add a series to the graph
		void ExtendSeriesLength();

		int m_NumberOfBarSeries;						// bar-series are drawn next to one another, others overlap.
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
