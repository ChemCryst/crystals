////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotData is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
// Revision 1.31  2009/07/24 06:41:59  djw
// Change colours in charts
//
// Revision 1.30  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.1.1.1  2004/12/13 11:16:17  rich
// New CRYSTALS repository
//
// Revision 1.29  2004/11/12 11:22:18  rich
// Fix unreadable x-axis values.
//
// Revision 1.28  2004/06/24 09:12:01  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.27  2004/06/03 14:41:20  rich
// Don't crash if no range on second y axis.
//
// Revision 1.26  2003/12/09 09:51:54  rich
// Fix colours of data series in plots if > 6 series.
//
// Revision 1.25  2003/09/16 19:15:36  rich
// Code to thin out labels on the x-axis of graphs to prevent overcrowding.
// Seems to slow down the linux version - will investigate on Windows.
//
// Revision 1.24  2003/07/08 09:59:08  rich
//
// Fixed bug where x and y axis scales went
// slightly wrong for graphs with data scaled
// on a second y-axis.
//
// Revision 1.23  2003/05/07 12:18:56  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.22  2002/07/18 16:47:29  richard
// Prevent crash if program attempts to plot graph and graph window doesn't exist.
//
// Revision 1.21  2002/07/03 14:23:21  richard
// Replace as many old-style stream class header references with new style
// e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
// Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
// stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
// Removed some bits from Steve's Plot classes that were generating (harmless) compiler
// warning messages.
//
// Revision 1.20  2002/04/30 21:57:33  richard
// Spelling correction.
//
// Revision 1.19  2002/04/11 11:08:07  DJWgroup
// SH: Quick fix for dynamic graph scaling.
//
// Revision 1.18  2002/03/07 10:55:12  DJWgroup
// SH: Change text label alignment again.
//
// Revision 1.17  2002/03/07 10:46:43  DJWgroup
// SH: Change to fix reversed y axes; realign text labels.
//
// Revision 1.16  2002/02/21 15:23:11  DJWgroup
// SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
// Revision 1.15  2002/02/20 12:05:19  DJWgroup
// SH: Added class to allow easier passing of mouseover information from plot classes.
//
// Revision 1.14  2002/02/18 15:16:42  DJWgroup
// SH: Added ADDSERIES command, and allowed series to have different lengths.
//
// Revision 1.13  2002/02/18 11:21:11  DJWgroup
// SH: Update to plot code.
//
// Revision 1.12  2002/01/22 16:12:24  ckpgroup
// Small change to allow inverted axes (eg for Wilson plots). Use 'ZOOM 4 0'.
//
// Revision 1.11  2002/01/14 12:19:53  ckpgroup
// SH: Various changes. Fixed scatter graph memory allocation.
// Fixed mouse-over for scatter graphs. Updated graph key.
//
// Revision 1.10  2002/01/08 12:40:34  ckpgroup
// SH: Fixed memory leaks, fiddled with key text alignment.
//
// Revision 1.9  2001/12/12 16:02:24  ckpgroup
// SH: Reorganised script to allow right-hand y axes.
// Added floating key if required, some redraw problems.
//
// Revision 1.8  2001/11/29 15:46:09  ckpgroup
// SH: Update of script commands to support second y axis, general update.
//
// Revision 1.7  2001/11/26 14:02:48  ckpgroup
// SH: Added mouse-over message support - display label and data value for the bar
// under the pointer.
//
// Revision 1.6  2001/11/22 15:33:19  ckpgroup
// SH: Added different draw-styles (line / area / bar / scatter).
// Changed graph layout. Changed second series to blue for better contrast.
//
// Revision 1.5  2001/11/19 16:32:20  ckpgroup
// SH: General update, bug-fixes, better text alignment. Removed a lot of duplicate code.
//
// Revision 1.4  2001/11/14 12:43:20  ckp2
// RC: Don't assume that x-axis will be at least as long as the LENGTH given.
// It could be shorter.
//
// Revision 1.3  2001/11/13 10:54:28  ckpgroup
// SH: Log Axis Scaling fixed.
//
// Revision 1.2  2001/11/12 16:24:28  ckpgroup
// SH: Graphical agreement analysis
//
// Revision 1.1  2001/10/10 12:44:49  ckp2
// The PLOT classes!
//
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccplotdata.h"
#include    "ccplotbar.h"
#include    "ccplotscatter.h"
#include    "crplot.h"
#include    "cccontroller.h"
#include    "ccpoint.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    <math.h>

#ifdef CRY_USEWX
#include <wx/thread.h>
// These macros are being defined somewhere. They shouldn't be.

 #ifdef GetCharWidth
  #undef GetCharWidth
 #endif
 #ifdef DrawText
  #undef DrawText
 #endif
#endif

list<CcPlotData*> CcPlotData::sm_PlotList;
CcPlotData* CcPlotData::sm_CurrentPlotData = nil;

CcPlotData::CcPlotData( )
{
    attachedPlot = nil;
    mSelfInitialised = false;
    sm_PlotList.push_back(this);

    m_DrawKey = false;
    m_AxesOK = false;

    m_CompleteSeries = 0;   // no data present
    m_CurrentSeries = -1;   // all series selected
    m_CurrentAxis = -1;     // also all axes selected
    
    m_XGapRight = 160;      // horizontal gap between graph and edge of window
    m_XGapLeft = 200;       //      nb: leave enough space for labels
    m_YGapTop = 200;        // and the vertical gap
    m_YGapBottom = 300;     //      nb: lots of space for labels

    // initialise the colours
   // nb only for 7 series currently
   for(int i=0; i<NCOLS; i++)
   {
       m_Colour[0][i] = 0;
       m_Colour[1][i] = 0;
       m_Colour[2][i] = 0;   //All black
   }

   m_Colour[0][0] = 240; //Red

   m_Colour[1][1] = 176; //Green
   m_Colour[2][1] =   0; //Green

   m_Colour[1][2] =  64; //Blue
   m_Colour[2][2] = 240; //Blue

   m_Colour[0][3] =   0;
   m_Colour[1][3] = 192; //Cyan
   m_Colour[2][3] = 240; 

   m_Colour[0][4] = 240;
   m_Colour[1][4] = 176; //Orange

   m_Colour[0][5] = 192;
   m_Colour[2][5] = 240; //Purple



   m_NumberOfSeries = 0;
}

CcPlotData::~CcPlotData()
{
// Remove from list of plotdata objects:
    sm_PlotList.remove(this);
}

//This static function reads the name of the plotdata and
//creates the correct derived type of plotdata.
CcPlotData * CcPlotData::CreatePlotData( deque<string> &  tokenList )
{
    CcPlotData* retval = nil;
    string dataname = string(tokenList.front());
    tokenList.pop_front();
    switch ( CcController::GetDescriptor( tokenList.front(), kPlotClass ) )
    {
       case kTPlotBarGraph:
       {
           tokenList.pop_front(); // Remove that token!
           retval = new CcPlotBar();
           retval->mName = dataname;
           break;
       }
       case kTPlotScatter:
       {
           tokenList.pop_front(); // Remove that token!
           retval = new CcPlotScatter();
           retval->mName = dataname;
           break;
       }
       default:
       {
           break; 
       }
    }
    return retval;
}

// gets input from script or fortran code, does plot set-up, and stores data in the series classes.
bool CcPlotData::ParseInput( deque<string> &  tokenList )
{
    bool hasTokenForMe = true;
    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kPlotClass ) )
        {
            // get the window name to attach this plot to.
            case kTPlotAttach:
            {
                tokenList.pop_front(); // Remove that token!
                attachedPlot = (CrPlot*)(CcController::theController)->FindObject(tokenList.front());
                tokenList.pop_front();
                if(attachedPlot != nil)
                    attachedPlot->Attach(this);
                break;
            }

            // display this graph
            case kTPlotShow:
            {
                tokenList.pop_front(); // Remove that token!
                this->Clear();
                this->DrawView(false);
                break;
            }
            
            // use linear axis scaling
            case kTPlotLinear:
            {
                tokenList.pop_front();  // "LINEAR"
                if(m_CurrentAxis != -1)
                    m_Axes.m_AxisData[m_CurrentAxis].m_AxisLog = false;
                else
                {
                    for(int i=0; i<3; i++)
                        m_Axes.m_AxisData[i].m_AxisLog = false;
                }
                break;
            }

            // use log axis scaling (for y axis only...)
            case kTPlotLog:
            {
                tokenList.pop_front();  // "LOG"
                if(m_CurrentAxis != -1)
                    m_Axes.m_AxisData[m_CurrentAxis].m_AxisLog = true;  
                else
                {
                    for(int i=0; i<3; i++)
                        m_Axes.m_AxisData[i].m_AxisLog = true;
                }
                break;
            }

            // set the graph title
            case kTPlotTitle:
            {
                tokenList.pop_front();  // "TITLE"
                m_Axes.m_PlotTitle = string(tokenList.front());
                tokenList.pop_front();
                break;
            }

            // use automatic axis scaling: 0 -> max if all +ve, min -> max if not.
            case kTPlotAuto:        // this mode sets y axis range to 0 < y < ymax
            {
                tokenList.pop_front();  // "AUTO"
                if(m_CurrentAxis != -1)
                    m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisAuto;
                else
                {
                    for(int i=0; i<3; i++)
                        m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisAuto;
                }
                break;
                                m_AxesOK = false;
            }

            // uses axis scaling of min->max always.
            case kTPlotSpan:        // this mode sets y axis range to ymin < y < ymax
            {
                tokenList.pop_front();  // "SPAN"
        
                if(m_CurrentAxis != -1)
                    m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisSpan;
                else
                {
                    for(int i=0; i<3; i++)
                        m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisSpan;
                }
                break;
                m_AxesOK = false;
            }

            // lets the user specify an axis range.
            case kTPlotZoom:
            {
                tokenList.pop_front();  //"ZOOM"

                // next two tokens should be: min, max
                float min = (float)atof(tokenList.front().c_str());
                tokenList.pop_front();
                float max = (float)atof(tokenList.front().c_str());
                tokenList.pop_front();

                // check if graph needs flipping
                if(max < min)
                {
                    float temp = min;
                    min = max;
                    max = temp;
                    m_Axes.m_Flipped = true;
                    attachedPlot->FlipGraph(true);
                }

                if(m_CurrentAxis != -1)
                {
                    m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisZoom;

                    m_Axes.m_AxisData[m_CurrentAxis].m_AxisMin = min;
                    m_Axes.m_AxisData[m_CurrentAxis].m_AxisMax = max;
                }
                else
                {
                    for(int i=0; i<3; i++)
                    {
                        m_Axes.m_AxisData[i].m_AxisScaleType = Plot_AxisZoom;

                        m_Axes.m_AxisData[i].m_AxisMin = min;
                        m_Axes.m_AxisData[i].m_AxisMax = max;
                    }
                }
                // specify that axes need rescaling
                m_AxesOK = false;
                
                break;
            }

            // set the number of data series
            case kTPlotNSeries:             // number of series specified
            {
                tokenList.pop_front();      // "NSERIES"
                int num = atoi(tokenList.front().c_str());
                tokenList.pop_front();

                // now use PeekToken to look at the next token in the list. If it is a valid type,
                //      then grab it, and set the series types
                vector<int> types;
                types.reserve(num);      // Reduce memory thrash.
                for(int i=0; i<num; i++)
                {
                    if(FindSeriesType(tokenList.front()) != -1)
                    {
                        types.push_back(FindSeriesType(tokenList.front()));
                        tokenList.pop_front();
                    }
                    else 
                        types.push_back(Plot_SeriesBar);
                }

                CreateSeries(num, types); // create series here


                break;
            }

            // set the series names, for the key
            case kTPlotSeriesName:
            {
                tokenList.pop_front();  // "NAME"
                if(m_CurrentSeries != -1)
                    m_Series[m_CurrentSeries].m_SeriesName = string(tokenList.front());
                else 
                    LOGWARN("Can't apply the same name to all series...");
                tokenList.pop_front();  // theseriesname
                break;
            }

            // set the title of this axis (drawn next to it)
            case kTPlotAxisTitle:
            {
                tokenList.pop_front();  // "TITLE"  

                if(m_CurrentAxis != -1)
                    m_Axes.m_AxisData[m_CurrentAxis].m_Title = string(tokenList.front());
                else 
                    LOGSTAT("Same title applied to all axes...");
                tokenList.pop_front();  // theplotaxistitle
                break;
            }
                
            // set the drawing style for a series
            case kTPlotSeriesType:
            {
                string textstyle;                 // the drawing style, in text
                int style = Plot_SeriesBar;         // the style in Plot_SeriesX form
                int series = 0;
        
                tokenList.pop_front();              // 'TYPE'

                style = FindSeriesType(tokenList.front().c_str());
                tokenList.pop_front();

                // if current series is -1, apply to all series
                if(m_CurrentSeries == -1)
                {
                    for(int i=0; i<m_NumberOfSeries; i++)
                        m_Series[i].m_DrawStyle = style;
                }
                else
                {
                    m_Series[m_CurrentSeries].m_DrawStyle = style;
                }
                break;
            }

            // select a series
            case kTPlotSeries:
            {
                tokenList.pop_front();  // "SERIES"

                string sname = string(tokenList.front());
                tokenList.pop_front();

                if(sname == "ALL") m_CurrentSeries = -1;
        
                bool seriesfound = false;

                // now search series names for the token sname
                for(int i=0; i<m_NumberOfSeries; i++)
                {
                    if((sname == m_Series[i].m_SeriesName) && !(m_Series[i].m_SeriesName == ""))
                    {
                        m_CurrentSeries = i;
                        seriesfound = true;
                    }
                }
                
                // if name doesn't match, try getting a number
                if(!seriesfound)
                {
                    m_CurrentSeries = atoi(sname.c_str()) - 1;              
                    // nb - the -1 means that series 0 in the array is series 1 to the user
                }

                // if still not found, select all...
                if((m_CurrentSeries > m_NumberOfSeries) || (m_CurrentSeries < 0))
                    m_CurrentSeries = -1;

                break;
            }

            // select an axis
            case kTPlotXAxis:
            {
                tokenList.pop_front();  // "XAXIS"
                m_CurrentAxis = Axis_X;
                break;
            }
            case kTPlotYAxis:
            {
                tokenList.pop_front();  // "YAXIS"
                m_CurrentAxis = Axis_YL;
                break;
            }
            case kTPlotYAxisRight:
            {
                tokenList.pop_front();  // "YAXISRIGHT"
                m_CurrentAxis = Axis_YR;
                break;
            }

            // add a series to the graph
            case kTPlotAddSeries:
            {
                tokenList.pop_front();  // "ADDSERIES"

                string sname;

                // next token should be the name of the series (but is optional so scan for type instead

                if(tokenList.front() != "TYPE") 
                {
                    sname = string(tokenList.front());
                    tokenList.pop_front();
                }

                tokenList.pop_front();   // "TYPE"
                // followed by the type itself

                string next = string(tokenList.front());
                tokenList.pop_front();   // The type

                // set all previous series as complete
                m_CompleteSeries = m_NumberOfSeries;

                // now add the series. Start with 10 items.
                AddSeries(FindSeriesType(next), 10);

                m_Series[m_NumberOfSeries-1].m_SeriesName = sname;
                
                break;
            }

            // set the current series to use the right-hand y axis
            case kTPlotUseRightAxis:
            {
                tokenList.pop_front();  // "USERIGHTAXIS"

                if(m_CurrentSeries == (-1))
                {
                    for(int i=0; i<m_NumberOfSeries; i++)
                    {
                        m_Series[i].m_YAxis = Axis_YR;
                    }
                }
                else m_Series[m_CurrentSeries].m_YAxis = Axis_YR;
                
                m_Axes.m_NumberOfYAxes = 2;
                break;
            }

            // tells this graph to draw a key
            case kTPlotKey:
            {
                tokenList.pop_front();  // "KEY"

                m_DrawKey = true;
                break;
            }

            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }
    return true;
}

// creates the data, and draws a key
void CcPlotData::DrawKey()
{
    string * names = new string[m_NumberOfSeries];
    int ** col;
    col = new int*[3];

    col[0] = new int[m_NumberOfSeries];
    col[1] = new int[m_NumberOfSeries];
    col[2] = new int[m_NumberOfSeries];

    // copy series names and colours for each data series
    for(int i=0; i<m_NumberOfSeries; i++)
    {
        names[i] = m_Series[i].m_SeriesName;
        col[0][i] = m_Colour[0][i%NCOLS];
        col[1][i] = m_Colour[1][i%NCOLS];
        col[2][i] = m_Colour[2][i%NCOLS];
    }

    // pass these through the CrPlot to CxPlot, and create a key window.
    attachedPlot->CreateKey(m_NumberOfSeries, names, col);

    // free up memory.
    delete [] names;
    delete [] col[0];
    delete [] col[1];
    delete [] col[2];
    delete [] col;
}

// returns the series type identifier corresponding to the text string supplied
int CcPlotData::FindSeriesType(string textstyle)
{
    int style = -1;

    if(textstyle == "BAR")
        style = Plot_SeriesBar;
    else if(textstyle == "SCATTER")
        style = Plot_SeriesScatter;
    else if(textstyle == "SCATTERX")
        style = Plot_SeriesScatterX;
    else if(textstyle == "LINE")
        style = Plot_SeriesLine;
    else if(textstyle == "AREA")
        style = Plot_SeriesArea;
    else style = -1;    // no style selected    

    return style;
}

CcPlotData *  CcPlotData::FindObject( const string & Name )
{
    if ( Name == mName )
        return this;
    else
        return nil;
}

void CcPlotData::Clear()
{
    if(attachedPlot)attachedPlot->Clear();
}

///////////////////////////////////////////
//
// The CcSeries stuff:                   
//
///////////////////////////////////////////


CcSeries::CcSeries()
{
    m_YAxis = Axis_YL;
    m_DrawStyle = -1;
// Create floats.
    vector<float> f;
    m_DataXY.push_back(f);
    m_DataXY.push_back(f);
}

CcSeries::~CcSeries()
{
}

// parse any input for this series
bool CcSeries::ParseInput( deque<string> &  tokenList )
{
    // nb: series class doesn't handle any messages
//          switch ( CcController::GetDescriptor( tokenList.front(), kPlotClass ) )
//          {
//                default:
//                {  
//                        return true; // Failed to initialise. Some sort of error.
//                        break; 
//                }
//          }
      
    return true;
}


///////////////////////////////////////////////////////////////////////////////////////////
//
//  The AxesData stuff
//
///////////////////////////////////////////////////////////////////////////////////////////

// set all values to default
CcAxisData::CcAxisData()
{
    // set min and max the wrong way round so they are corrected when data is added
    m_Max = 0;
    m_Min = 10000;

    m_AxisMax = 0;
    m_AxisMin = 0;

    m_Delta = 0;

    m_NumDiv = 1;

    m_AxisDivisions = 0;

    m_AxisScaleType = Plot_AxisAuto; 
    m_AxisLog = false;
}

CcAxisData::~CcAxisData()
{
}

// calculate a linear set of axis divisions, make them fall on 'nice' numbers with sensible delta
bool CcAxisData::CalculateLinearDivisions()
{
    // initial delta value - too high? Can be reduced if any lower is needed, but use either ...1, ...2 or ...5
    m_Delta = 0.001f;

    // support for reversed axes (eg 4 -> 0)
//  if(m_AxisMax < m_AxisMin) m_Delta = -m_Delta;

    m_NumDiv = (int)((m_AxisMax - m_AxisMin) / m_Delta);    // initial number of divisions based on delta

    int numinc = 0;                         // number of increments of delta

    // increment the delta, so reducing the number of divisions needed.
    // x2, x2.5, x2, x2, x2.5, x2, x2 etc
    // this gives 'nice' delta values - 0.1, 0.2, 0.5, 1,2,5,10,20,50,100,200,500,1000 etc.
    while(m_NumDiv > 15)                // max 15 divisions
    {
        if((numinc+2)%3 == 0)               // every third increment is x2.5
        {
            m_Delta *= 2.5f;
        }
        else m_Delta *= 2;          // others are x2

        numinc++;
        m_NumDiv = (int)((m_AxisMax - m_AxisMin) / m_Delta);// find new number of divisions
    }

    // move all divisions such that they are multiples of the delta
    bool smallerthan = false;
    float absdelta = m_Delta;
    float absmin = m_AxisMin;
    if(absmin < 0) absmin = -absmin;

    while((!smallerthan) && (m_Delta > 0))
    {
        if(absdelta < absmin)
            absdelta += m_Delta;
        else smallerthan = true;
    }

    if(m_AxisMin < 0) 
        m_AxisMin = -absdelta;

    // make sure there are enough divisions
    if(m_AxisScaleType != Plot_AxisZoom)
        while (m_AxisMin + (m_NumDiv * m_Delta) < m_Max) 
            (m_NumDiv)++;
    else m_NumDiv++;

    // allocate space for data 
    m_AxisDivisions = new float[m_NumDiv+1];

    // loop through points, fill with data
    for(int i=0; i<(m_NumDiv+1); i++)
    {
        m_AxisDivisions[i] = m_AxisMin + m_Delta*i;

        if(m_AxisDivisions[i] > -0.0001 && m_AxisDivisions[i] < 0.0001)
            m_AxisDivisions[i] = 0;
    }

    m_AxisMin = m_AxisDivisions[0];
    m_AxisMax = m_AxisDivisions[m_NumDiv];

    return true;
}

// now the division calculations for a log axis.
// Does linear scaling of the log values, then logs all the labels.
bool CcAxisData::CalculateLogDivisions()
{
    // now do log y axis
    m_Delta = 1;
    if(m_AxisMin <= 0) m_AxisMin = 1;

    m_NumDiv = (int)((log10(m_AxisMax) - log10(m_AxisMin)) / m_Delta);// initial number of divisions based on delta

    int numinc = 0;                                 // number of increments of delta

    // increment the delta, so reducing the number of divisions needed.
    // x2, x2.5, x2, x2, x2.5, x2, x2 etc
    // this gives 'nice' delta values - 1,2,5,10,20,50,100,200,500,1000 etc.
    while(m_NumDiv > 15)                // max 15 divisions
    {
        if((numinc+2)%3 == 0)                       // ever third increment is x2.5
        {
            m_Delta *= 2.5f;
        }
        else m_Delta *= 2;                      // others are x2

        numinc++;
        m_NumDiv = (int)((log10(m_AxisMax) - log10(m_AxisMin)) / m_Delta);// find new number of divisions
    }

    // move all divisions such that they are multiples of the delta
    bool smallerthan = false;
    float absdelta = m_Delta;
    float absmin = m_AxisMin;
    if(absmin < 0) absmin = -absmin;

    while(!smallerthan)
    {
        if(absdelta < absmin)
            absdelta += m_Delta;
        else smallerthan = true;
    }

    if(m_AxisMin < 0)   m_AxisMin = -absdelta;

    // make sure there are enough divisions
    while((log10(m_AxisMin) + (m_NumDiv * m_Delta) < log10(m_Max)))
        m_NumDiv++;

    // allocate space for data (changed to new)
    m_AxisDivisions = new float[m_NumDiv+1];

    // loop through points, fill with data
    for(int i=0; i<(m_NumDiv+1); i++)
    {
        m_AxisDivisions[i] = (float)(pow(10,(log10(m_AxisMin) + m_Delta*i)));

        if(m_AxisDivisions[i] > -0.000001 && m_AxisDivisions[i] < 0.000001)
            m_AxisDivisions[i] = 0;
    }

    m_AxisMin = (float)log10(m_AxisDivisions[0]);
    m_AxisMax = (float)log10(m_AxisDivisions[m_NumDiv]);

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////////
//
//  The CcPlotAxes stuff
//
///////////////////////////////////////////////////////////////////////////////////////////

// set all variables to initial default values
CcPlotAxes::CcPlotAxes()
{
    m_NumberOfYAxes = 1;    // only one y axis (left) is default
    m_NumberOfLabels = 0;
    m_Flipped = false;
}

// free any allocated memory
CcPlotAxes::~CcPlotAxes()
{
    if(m_AxisData[Axis_X].m_AxisDivisions)
    {
        delete [] m_AxisData[Axis_X].m_AxisDivisions;
        m_AxisData[Axis_X].m_AxisDivisions = 0;
    }
    if(m_AxisData[Axis_YL].m_AxisDivisions)
    {
        delete [] m_AxisData[Axis_YL].m_AxisDivisions;
        m_AxisData[Axis_YL].m_AxisDivisions = 0;
    }
    if(m_AxisData[Axis_YR].m_AxisDivisions)
    {
        delete [] m_AxisData[Axis_YR].m_AxisDivisions;
        m_AxisData[Axis_YR].m_AxisDivisions = 0;
    }
}


// work out the division markers for the axes
bool CcPlotAxes::CalculateDivisions()
{
    bool tempx = false;
    bool tempyl = false;
    bool tempyr = false;

    // change axis limits for axes if required
    for(int i=0; i< 3; i++)
    {
        if(m_AxisData[i].m_AxisScaleType == Plot_AxisAuto)
        {
            if(m_AxisData[i].m_Min == m_AxisData[i].m_Max)
                m_AxisData[i].m_Max = m_AxisData[i].m_Min + 10;

            if((m_AxisData[i].m_Min > 0) && !m_AxisData[i].m_AxisLog)
                m_AxisData[i].m_AxisMin = 0;
            else m_AxisData[i].m_AxisMin = m_AxisData[i].m_Min;

            m_AxisData[i].m_AxisMax = m_AxisData[i].m_Max;
        }
    }

    // for bar graphs, the x axis is different from the y's. One division per data item.
    if(m_GraphType == Plot_GraphBar)
    {
        // do the x axis first - one division per data item
        // x axis always linear so can do it here...
        m_AxisData[Axis_X].m_Delta = 1;
        m_AxisData[Axis_X].m_NumDiv = (int)m_AxisData[Axis_X].m_Max;

        // allocate space for data
        m_AxisData[Axis_X].m_AxisDivisions = new float[m_AxisData[Axis_X].m_NumDiv];

        for(int i=0; i<m_AxisData[Axis_X].m_NumDiv; i++)
        {
            m_AxisData[Axis_X].m_AxisDivisions[i] = (float)i;
        }

        tempx = true;
    }
    // for scatter graphs calculate divisions for both axes
    else if(m_GraphType == Plot_GraphScatter)
    {
        if(m_AxisData[Axis_X].m_AxisScaleType == Plot_AxisAuto)
        {
            if(m_AxisData[Axis_X].m_Min > 0)
                m_AxisData[Axis_X].m_AxisMin = 0;
            else m_AxisData[Axis_X].m_AxisMin = m_AxisData[Axis_X].m_Min;

            m_AxisData[Axis_X].m_AxisMax = m_AxisData[Axis_X].m_Max;
        }

        if(m_AxisData[Axis_X].m_AxisLog) tempx = m_AxisData[Axis_X].CalculateLogDivisions();
        else tempx = m_AxisData[Axis_X].CalculateLinearDivisions();
    }

    // now the y axis
    if(m_AxisData[Axis_YL].m_AxisLog) tempyl = m_AxisData[Axis_YL].CalculateLogDivisions();
    else tempyl = m_AxisData[Axis_YL].CalculateLinearDivisions();
    if(m_NumberOfYAxes == 2)
        if(m_AxisData[Axis_YR].m_AxisLog) tempyr = m_AxisData[Axis_YR].CalculateLogDivisions();
        else tempyr = m_AxisData[Axis_YR].CalculateLinearDivisions();

    if(m_NumberOfYAxes == 2)
        return (tempx & tempyl & tempyr);
    else return (tempx & tempyl);
}

// check a data item, change axis range if necessary
void CcPlotAxes::CheckData(int axis, float data)
{
    if(data > m_AxisData[axis].m_Max) m_AxisData[axis].m_Max = data;
    if(data < m_AxisData[axis].m_Min) m_AxisData[axis].m_Min = data;

    switch(m_AxisData[axis].m_AxisScaleType)
    {
        case Plot_AxisAuto:
        {
            if(data > m_AxisData[axis].m_AxisMax) m_AxisData[axis].m_AxisMax = data;
            break;
        }
        case Plot_AxisSpan:
        {
            if(data > m_AxisData[axis].m_AxisMax)
                m_AxisData[axis].m_AxisMax = data;
            if(data < m_AxisData[axis].m_AxisMin)
                m_AxisData[axis].m_AxisMin = data;
            break;
        }
        case Plot_AxisZoom:
        {
            // dont change the axis limits (already set)
            break;
        }
    }
}

// draw the bits of the graph common to all graph types
void CcPlotAxes::DrawAxes(CrPlot* attachedPlot)
{

    if(attachedPlot)
    {
        // setup variables for scaling / positioning of graphs
        int xgapright = 160;        // horizontal gap between graph and edge of window
        int xgapleft = 200;         //      nb: leave enough space for labels
        int ygaptop = 200;          // and the vertical gap
        int ygapbottom = 300;       //      nb: lots of space for labels

        // if graph has a title, make top gap bigger
        if(!(m_PlotTitle == ""))
            ygaptop = 300;

        // if x axis has a title make the bottom gap bigger
        if(!(m_AxisData[Axis_X].m_Title == ""))
            ygapbottom = 500;

        // if y axis has a title make the lhs gap bigger
        if(!(m_AxisData[Axis_YL].m_Title == ""))
            xgapleft = 300;
// next two lines commented out by someone. If re-introduced, plot area overflows the right labels
// re-introduced by DJW - see also ccplotbar, ccplotscatter, ccplotdata
        if(!(m_AxisData[Axis_YR].m_Title == ""))
            xgapright = 300;

        // variables used for loops
        int i=0;
        int j=0;

        // temp string for text label
        ostringstream ylabel;
        
        // gap between division markers on x and y axes
        int xdivoffset = (2400-xgapleft-xgapright) / (m_AxisData[Axis_X].m_NumDiv);
        int ydivoffset = (2400-ygaptop-ygapbottom) / (m_AxisData[Axis_YL].m_NumDiv);

        int yroffset   = 0;
        
        if(m_NumberOfYAxes == 2) yroffset = (2400 - ygaptop - ygapbottom)/(CRMAX(1,m_AxisData[Axis_YR].m_NumDiv));

        // axis dimensions after rounding
        int axisheight = ydivoffset * (m_AxisData[Axis_YL].m_NumDiv);               
        int axiswidth = xdivoffset * (m_AxisData[Axis_X].m_NumDiv);
        
		
		// take the axis height, work out where zero is...
        int xorigin = (int)(xgapleft - ((axiswidth * m_AxisData[Axis_X].m_AxisMin) / (m_AxisData[Axis_X].m_AxisMax - m_AxisData[Axis_X].m_AxisMin)));

		int yorigin = (int)(2400 - ygapbottom + (axisheight * (m_AxisData[Axis_YL].m_AxisMin/ (m_AxisData[Axis_YL].m_AxisMax - m_AxisData[Axis_YL].m_AxisMin))));
        int yorigright = (int)(2400 - ygapbottom + (axisheight * (m_AxisData[Axis_YR].m_AxisMin / (m_AxisData[Axis_YR].m_AxisMax - m_AxisData[Axis_YR].m_AxisMin))));

        //this is the value of y at the origin <left> (may be non-zero for span-graphs)
        float yoriginvalue = 0;
        if(m_AxisData[Axis_YL].m_AxisScaleType == Plot_AxisSpan && m_AxisData[Axis_YL].m_AxisMin > 0) 
        {
            yorigin = 2400 - ygapbottom;
            yoriginvalue = m_AxisData[Axis_YL].m_AxisDivisions[0];
        }
        float yoriginvaluer = 0;
        if(m_AxisData[Axis_YR].m_AxisScaleType == Plot_AxisSpan && m_AxisData[Axis_YR].m_AxisMin > 0)
        {
            yorigright = 2400 - ygapbottom;
            yoriginvaluer = m_AxisData[Axis_YR].m_AxisDivisions[0];
        }

        // now draw the axes in black: overwrite bars
        attachedPlot->SetColour(0,0,0);

		if(m_GraphType == Plot_GraphScatter) {

			attachedPlot->DrawLine(3, xorigin, 2400-ygapbottom-axisheight, xorigin, 2400-ygapbottom);
		    attachedPlot->DrawLine(3, xgapleft, yorigin, 2400-xgapright, yorigin);

		} else {
		
			attachedPlot->DrawLine(3, xgapleft, 2400-ygapbottom-axisheight, xgapleft, 2400-ygapbottom);
		    attachedPlot->DrawLine(3, xgapleft, yorigin, 2400-xgapright, yorigin);

			if(m_NumberOfYAxes == 2)
				attachedPlot->DrawLine(3, 2400-xgapright, 2400-ygapbottom-axisheight, 2400-xgapright, 2400-ygapbottom);
		}
        // the following tries to find an optimal font size
        int fontsize = 16;          // 14 is the max Note by DJW. 16 seems to work OK
        int largest_label_index = -1;
        CcPoint maxangletextextent;
        CcPoint maxhorizontaltextextent;
        CcPoint textextent;
        bool textOK = false;
        bool smalltext = false;  // true if text gets too small


        // draw marker lines in grey
        attachedPlot->SetColour(150,150,150);

        // now loop through the divisions on each axis, drawing each one
        // first x axis
        for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i++)
        {
            attachedPlot->DrawLine(1, xgapleft+i*xdivoffset, ygaptop, xgapleft + i*xdivoffset, 2400-ygapbottom );
        }
    
        // and the y axis
        for(i=0; i<m_AxisData[Axis_YL].m_NumDiv+1; i++)
        {
            attachedPlot->DrawLine(1, xgapleft, (2400-ygapbottom)-i*ydivoffset, 2400-xgapright, (2400-ygapbottom)-i*ydivoffset);
        }

        // if there is a 2nd y axis (right) draw that too...
        if(m_NumberOfYAxes == 2)
        {
            for(i=0; i<m_AxisData[Axis_YR].m_NumDiv+1; i++)
            {
                attachedPlot->DrawLine(1, 2400-xgapright, (2400-ygapbottom)-i*yroffset, 2400-xgapright+10, (2400-ygapbottom)-i*yroffset);
            }
        }
        
        // write the labels for each axis, and the graph title
        attachedPlot->FlipGraph(false);
        attachedPlot->DrawText(1200, ygaptop/2, m_PlotTitle.c_str(), TEXT_VCENTRE|TEXT_HCENTRE|TEXT_BOLD, 40);
        attachedPlot->FlipGraph(m_Flipped);

        if(!m_Flipped)
            attachedPlot->DrawText(1200, 2300-ygapbottom/150, m_AxisData[Axis_X].m_Title.c_str(), TEXT_HCENTRE|TEXT_BOTTOM, 30);
        else
            attachedPlot->DrawText(1200, 2400-ygapbottom/5, m_AxisData[Axis_X].m_Title.c_str(), TEXT_HCENTRE|TEXT_TOP, 30);

        attachedPlot->DrawText(xgapleft/5, 1200, m_AxisData[Axis_YL].m_Title.c_str(), TEXT_VERTICAL, 30);
        if(m_NumberOfYAxes == 2)
            attachedPlot->DrawText(2400-xgapright/5, 1200, m_AxisData[Axis_YR].m_Title.c_str(), TEXT_VERTICALDOWN, 30);



        if(m_GraphType == Plot_GraphBar)
        {
// First try reducing font size to make fit:
          while(!textOK && !smalltext)
          {
            if ( largest_label_index < 0 )
            {
              for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i+=1)  // find the maximum screen area occupied by a label at this font size
              {
                textextent = attachedPlot->GetTextArea(fontsize, m_Labels[i], 0);
                if(textextent.x > maxhorizontaltextextent.x) 
                {
                  largest_label_index = i;
                  maxhorizontaltextextent.x = textextent.x;
                }
                if(textextent.y > maxhorizontaltextextent.y) maxhorizontaltextextent.y = textextent.y;
              }
            }
            else
            {
              textextent = attachedPlot->GetTextArea(fontsize, m_Labels[largest_label_index], 0);
              maxhorizontaltextextent.x = textextent.x;
              maxhorizontaltextextent.y = textextent.y;
            } 
            if((maxhorizontaltextextent.x < 0.9*xdivoffset))     // if the text fits at this size, draw normally
            {
              textOK = true;
              for(i=0; i<m_AxisData[Axis_X].m_NumDiv;i+=1)
              {
                if (m_Flipped)
                  attachedPlot->DrawText((int)(xgapleft+(i+0.5)*xdivoffset),2400-ygapbottom, m_Labels[i].c_str(), TEXT_HCENTRE|TEXT_BOTTOM, fontsize);
                else
                  attachedPlot->DrawText((int)(xgapleft+(i+0.5)*xdivoffset),2400-ygapbottom, m_Labels[i].c_str(), TEXT_HCENTRE|TEXT_TOP, fontsize);
              }
            }

            if ( --fontsize <= 8)  // if the text didn't fit, try again with smaller font
            {
              smalltext = true;
              fontsize = 16;
            }
          }
      
          int step = 1;
// if the above method couldn't fit the text without making it too small, plot vertically
          if(!textOK && smalltext)
          {
            smalltext=false;
            while(!textOK && !smalltext)
            {
              if ( largest_label_index < 0 )
              {
                for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i+=step)  // find the maximum screen area occupied by a label at this font size
                {
                  textextent = attachedPlot->GetTextArea(fontsize, m_Labels[i], 0);
                  if(textextent.x > maxhorizontaltextextent.x) 
                  {
                    largest_label_index = i;
                    maxhorizontaltextextent.x = textextent.x;
                  }
                  if(textextent.y > maxhorizontaltextextent.y) maxhorizontaltextextent.y = textextent.y;
                }
              }
              else
              {
                textextent = attachedPlot->GetTextArea(fontsize, m_Labels[largest_label_index], 0);
                maxhorizontaltextextent.x = textextent.x;
                maxhorizontaltextextent.y = textextent.y;
              }

              if((maxhorizontaltextextent.x < 0.9*xdivoffset*step))                  // if the text fits at this size, draw normally
              {
                textOK = true;
                for(i=0; i<m_AxisData[Axis_X].m_NumDiv;i+=step)
                {
                  attachedPlot->DrawText((int)(xgapleft+(i+0.5)*xdivoffset), (int)(2400-ygapbottom+textextent.y/2+ygapbottom/6), m_Labels[i].c_str(), TEXT_VERTICAL, fontsize);
                }
              }

              // if the text didn't fit, try again with smaller font.
              fontsize--;
              if (fontsize <= 8) // try skipping labels
              {
                step++;
                largest_label_index = -1;
                fontsize = 16;
              }
              if(step >= 9) smalltext = true;
            }
            
            if ( ! textOK )    //Just draw anyway.
            {
              fontsize = 8;
              for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i+=step)
              {
                textextent = attachedPlot->GetTextArea(fontsize, m_Labels[i], TEXT_VERTICAL);              
                attachedPlot->DrawText((int)(xgapleft+(i+0.5)*xdivoffset), (int)(2400-ygapbottom+textextent.y/2+ygapbottom/6), m_Labels[i].c_str(), TEXT_VERTICAL, fontsize);
              }
            }
          }
        }

        else if(m_GraphType == Plot_GraphScatter)
        {
// First try reducing font size to make fit:
          while(!textOK && !smalltext)
          {
            if ( largest_label_index < 0 )
            {
              for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i+=1)  // find the maximum screen area occupied by a label at this font size
              {
                ylabel.str("");
                ylabel << m_AxisData[Axis_X].m_AxisDivisions[i];
                textextent = attachedPlot->GetTextArea(fontsize, ylabel.str(), 0);
                if(textextent.x > maxhorizontaltextextent.x) 
                {
                  largest_label_index = i;
                  maxhorizontaltextextent.x = textextent.x;
                }
                if(textextent.y > maxhorizontaltextextent.y) maxhorizontaltextextent.y = textextent.y;
              }
            }
            else
            {
              ylabel.str("");
              ylabel << m_AxisData[Axis_X].m_AxisDivisions[largest_label_index];
              textextent = attachedPlot->GetTextArea(fontsize, ylabel.str(), 0);
              maxhorizontaltextextent.x = textextent.x;
              maxhorizontaltextextent.y = textextent.y;
            }

            if((maxhorizontaltextextent.x < 0.9*xdivoffset))        // if the text fits at this size, draw normally
            {
              textOK=true;
              for(i=0; i<m_AxisData[Axis_X].m_NumDiv+1; i++)
              {
                ylabel.str("");
                ylabel << m_AxisData[Axis_X].m_AxisDivisions[i];
                if(m_Flipped)
                  attachedPlot->DrawText((int)(xgapleft+i*xdivoffset), 2400-ygapbottom, ylabel.str(), TEXT_BOTTOM|TEXT_HCENTRE, fontsize);
                else
                  attachedPlot->DrawText((int)(xgapleft+i*xdivoffset), 2400-ygapbottom, ylabel.str(), TEXT_TOP|TEXT_HCENTRE, fontsize);
              }
            }

            // if the text didn't fit, try again with smaller font
            fontsize--;
            if (fontsize <= 8) 
            {
                smalltext = true;
                fontsize = 16;
            }
          }
      
          int step = 1;
// if the above method couldn't fit the text without making it too small, plot vertically
          if(!textOK && smalltext)
          {
            smalltext=false;
            while(!textOK && !smalltext)
            {
              if ( largest_label_index < 0 )
              {
                for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i+=step)  // find the maximum screen area occupied by a label at this font size
                {
                  ylabel.str("");
                  ylabel << m_AxisData[Axis_X].m_AxisDivisions[i];
                  textextent = attachedPlot->GetTextArea(fontsize, ylabel.str(), 0);
                  if(textextent.x > maxhorizontaltextextent.x) 
                  {
                    largest_label_index = i;
                    maxhorizontaltextextent.x = textextent.x;
                  }
                  if(textextent.y > maxhorizontaltextextent.y) maxhorizontaltextextent.y = textextent.y;
                }
              }
              else
              {
                ylabel.str("");
                ylabel << m_AxisData[Axis_X].m_AxisDivisions[largest_label_index];
                textextent = attachedPlot->GetTextArea(fontsize, ylabel.str(), 0);
                maxhorizontaltextextent.x = textextent.x;
                maxhorizontaltextextent.y = textextent.y;
              }

              if((maxhorizontaltextextent.x < 0.9*xdivoffset*step))                   // if the text fits at this size, draw normally
              {
                textOK=true;
                for(i=0; i<m_AxisData[Axis_X].m_NumDiv+1; i+=step)
                {
                  ylabel.str("");
                  ylabel << m_AxisData[Axis_X].m_AxisDivisions[i];
                  if(!m_Flipped)
                    attachedPlot->DrawText((int)(xgapleft+i*xdivoffset), 2400-ygapbottom, ylabel.str(), TEXT_BOTTOM|TEXT_HCENTRE, fontsize);
                  else
                    attachedPlot->DrawText((int)(xgapleft+i*xdivoffset), 2400-ygapbottom, ylabel.str(), TEXT_TOP|TEXT_HCENTRE, fontsize);
                }
              }
              fontsize--;                   // if the text didn't fit, try again with smaller font
              if (fontsize <= 8)            // try skipping labels
              {
                step++ ; 
                fontsize = 16;
              }
              if(step >= 9)  smalltext = true;
            }
            
            if ( ! textOK )    //Just draw anyway.
            {
              fontsize = 8;
              textOK=true;
              for(i=0; i<m_AxisData[Axis_X].m_NumDiv+1; i+=step)
              {
                ylabel.str("");
                ylabel << m_AxisData[Axis_X].m_AxisDivisions[i];
                if(m_Flipped)
                  attachedPlot->DrawText((int)(xgapleft+i*xdivoffset), 2400-ygapbottom, ylabel.str(), TEXT_BOTTOM|TEXT_HCENTRE, fontsize);
                else
                  attachedPlot->DrawText((int)(xgapleft+i*xdivoffset), 2400-ygapbottom, ylabel.str(), TEXT_TOP|TEXT_HCENTRE, fontsize);
              }
            }
          }
        }




        fontsize = 16;

        // now draw the y axis labels, again without worrying about overlap
        for(i=0; i<m_AxisData[Axis_YL].m_NumDiv+1; i++)
        {
            ylabel.str("");
            ylabel << m_AxisData[Axis_YL].m_AxisDivisions[i];
            attachedPlot->DrawText(xgapleft-10, (2400-ygapbottom)-i*ydivoffset, ylabel.str(), TEXT_VCENTRE|TEXT_RIGHT, fontsize);
        }       

        if(m_NumberOfYAxes == 2)
        {
            // if there is a right-hand y axis, draw labels here...
            for(i=0; i<m_AxisData[Axis_YR].m_NumDiv+1; i++)
            {
                ylabel.str("");
                ylabel << m_AxisData[Axis_YR].m_AxisDivisions[i];
                attachedPlot->DrawText(2400-xgapright+15, (2400-ygapbottom)-i*yroffset, ylabel.str(), TEXT_VCENTRE, fontsize);
            }
        }
        
    }
}
