////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:15
//   $Log: not supported by cvs2svn $
//   Revision 1.12  2002/02/21 15:23:12  DJWgroup
//   SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
//   Revision 1.11  2002/02/20 12:05:19  DJWgroup
//   SH: Added class to allow easier passing of mouseover information from plot classes.
//
//   Revision 1.10  2002/02/18 15:16:42  DJWgroup
//   SH: Added ADDSERIES command, and allowed series to have different lengths.
//
//   Revision 1.9  2002/02/18 11:21:12  DJWgroup
//   SH: Update to plot code.
//
//   Revision 1.8  2002/01/22 16:12:27  ckpgroup
//   Small change to allow inverted axes (eg for Wilson plots). Use 'ZOOM 4 0'.
//
//   Revision 1.7  2002/01/16 10:28:39  ckpgroup
//   SH: Updated memory reallocation for large plots. Added optional labels to scatter points.
//
//   Revision 1.6  2001/12/12 16:02:25  ckpgroup
//   SH: Reorganised script to allow right-hand y axes.
//   Added floating key if required, some redraw problems.
//
//   Revision 1.5  2001/11/29 15:46:10  ckpgroup
//   SH: Update of script commands to support second y axis, general update.
//
//   Revision 1.4  2001/11/26 14:02:49  ckpgroup
//   SH: Added mouse-over message support - display label and data value for the bar
//   under the pointer.
//
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
class PlotDataPopup;

class CcPlotScatter : public CcPlotData
{
    public:
        void DrawView(bool print);
        bool ParseInput( CcTokenList * tokenList );
        CcPlotScatter();
        virtual ~CcPlotScatter();

        PlotDataPopup GetDataFromPoint(CcPoint *point);
        void CreateSeries(int numser, int* type);
        void AllocateMemory();
        void AddSeries(int type, int length);
        void ExtendSeriesLength(int ser);
};

class CcSeriesScatter : public CcSeries
{
public:
    bool ParseInput(CcTokenList * tokenList);
    CcSeriesScatter();
    virtual ~CcSeriesScatter();

    void AllocateMemory();

    float *     m_Data[2];                  // pointer to a this series' data (x and y)
    CcString*   m_Label;                    // pointer to the label for each data point
};

#endif
