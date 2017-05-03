////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CcPlotBar
////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:28

// $Log: not supported by cvs2svn $
// Revision 1.30  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.1.1.1  2004/12/13 11:16:17  rich
// New CRYSTALS repository
//
// Revision 1.29  2004/06/24 09:12:01  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.28  2003/12/09 09:51:54  rich
// Fix colours of data series in plots if > 6 series.
//
// Revision 1.27  2003/09/11 14:06:29  rich
// Rearrange expression that gcc didn't like.
//
// Revision 1.26  2003/07/08 09:59:08  rich
//
// Fixed bug where x and y axis scales went
// slightly wrong for graphs with data scaled
// on a second y-axis.
//
// Revision 1.25  2003/05/07 12:18:56  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.24  2002/10/16 09:07:31  rich
// Make the graphs a bit trendier.
//
// Revision 1.23  2002/07/22 14:24:48  richard
// Bug fix - attempt to allocate and then delete zero length array when
// plot contains no bars.
//
// Revision 1.22  2002/07/18 16:45:53  richard
// Bugfix: Crash on mouse over, if there were no data points in the graph.
//
// Revision 1.21  2002/07/15 12:19:13  richard
// Reorder headers to improve ease of linking.
// Update program to use new standard C++ io libraries.
// Update to use new version of MFC (5.0 with .NET.)
//
// Revision 1.20  2002/07/03 14:23:21  richard
// Replace as many old-style stream class header references with new style
// e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
// Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
// stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
// Removed some bits from Steve's Plot classes that were generating (harmless) compiler
// warning messages.
//
// Revision 1.19  2002/04/30 20:14:45  richard
// Thicken line used for line graphs.
//
// Revision 1.18  2002/03/07 10:46:43  DJWgroup
// SH: Change to fix reversed y axes; realign text labels.
//
// Revision 1.17  2002/02/21 15:23:11  DJWgroup
// SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
// Revision 1.16  2002/02/20 12:05:18  DJWgroup
// SH: Added class to allow easier passing of mouseover information from plot classes.
//
// Revision 1.15  2002/02/18 15:16:41  DJWgroup
// SH: Added ADDSERIES command, and allowed series to have different lengths.
//
// Revision 1.14  2002/02/18 11:21:11  DJWgroup
// SH: Update to plot code.
//
// Revision 1.13  2002/01/16 10:28:37  ckpgroup
// SH: Updated memory reallocation for large plots. Added optional labels to scatter points.
//
// Revision 1.12  2002/01/14 12:19:52  ckpgroup
// SH: Various changes. Fixed scatter graph memory allocation.
// Fixed mouse-over for scatter graphs. Updated graph key.
//
// Revision 1.11  2002/01/08 12:40:33  ckpgroup
// SH: Fixed memory leaks, fiddled with key text alignment.
//
// Revision 1.10  2001/12/12 16:02:23  ckpgroup
// SH: Reorganised script to allow right-hand y axes.
// Added floating key if required, some redraw problems.
//
// Revision 1.9  2001/11/29 15:46:08  ckpgroup
// SH: Update of script commands to support second y axis, general update.
//
// Revision 1.8  2001/11/26 16:47:34  ckpgroup
// SH: More MouseOver changes. Scatterplots display the graph coordinates of the mouse pointer.
// Remove labels when mouse leaves window.
//
// Revision 1.7  2001/11/26 14:02:47  ckpgroup
// SH: Added mouse-over message support - display label and data value for the bar
// under the pointer.
//
// Revision 1.6  2001/11/22 15:33:19  ckpgroup
// SH: Added different draw-styles (line / area / bar / scatter).
// Changed graph layout. Changed second series to blue for better contrast.
//
// Revision 1.5  2001/11/19 16:32:19  ckpgroup
// SH: General update, bug-fixes, better text alignment. Removed a lot of duplicate code.
//
// Revision 1.4  2001/11/13 13:54:30  ckp2
// Catch fontsize spiralling infinitely downwards...
//
// Revision 1.3  2001/11/13 10:54:27  ckpgroup
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
#include    <math.h>
#include    "crconstants.h"
#include    "ccplotdata.h"
#include    "ccplotbar.h"
#include    "crplot.h"
#include    "cccontroller.h"
#include    "ccpoint.h"
#include    <string>
#include    <sstream>

#ifdef CRY_USEWX
#include <wx/thread.h>
#endif

// set the graph type
CcPlotBar::CcPlotBar( )
{
    m_Axes.m_GraphType = Plot_GraphBar;
    m_NumberOfBarSeries = 0;
    m_AxesOK = false;
}

CcPlotBar::~CcPlotBar()
{
}

// parse input destined for bar-graphs
bool CcPlotBar::ParseInput( deque<string> &  tokenList )
{
    // first see if the command is for the parent class
    CcPlotData::ParseInput( tokenList );

    bool hasTokenForMe = true;
    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kPlotClass ) )
        {
            // set the number of data items in each series (semi-optional, since series is extended if necessary)
            case kTPlotLength:
            {
                tokenList.pop_front();
                int length = atoi(tokenList.front().c_str());
                tokenList.pop_front();

                m_Axes.m_Labels.reserve(length);
                for(int i=0; i<m_NumberOfSeries; i++)
                      m_Series[i].m_Data.reserve(length);

                break;
            }
            // a bar-graph label
            case kTPlotLabel:
            {
                tokenList.pop_front();  // 'LABEL'
                
                // next is the label for the nth data item
                string nlabel = string(tokenList.front());
                tokenList.pop_front();

                // copy this label to m_Label[n]
                m_Axes.m_Labels.push_back(nlabel);

                break;
            }
            // a set of data items to match a previously-given label
            case kTPlotData:
            {
                // again ditch the DATA token
                tokenList.pop_front();

                // now record the data itself
                for(int i=m_CompleteSeries; i < (m_NumberOfSeries); i++)
                {
                    float tempdata = (float)atof(tokenList.front().c_str());
					if ( isnan(tempdata) ) tempdata = 0.0;
                    tokenList.pop_front();

                    // changes axis range if necessary
                    m_Axes.CheckData(m_Series[i].m_YAxis, tempdata);
                
                    if(m_Axes.m_AxisData[m_Series[i].m_YAxis].m_AxisLog)
                    {
                        if(tempdata <= 0)
                        {
//                            LOGERR("Negative data passed to a LOG plot...");
                        }
                        else tempdata = (float)log10(tempdata);
                    }

                    // and copy this to m_Series[i].m_Data[n]
                    m_Series[i].m_Data.push_back(tempdata);
                    m_Axes.m_AxisData[Axis_X].m_Max = max((float)m_Series[i].m_Data.size() ,m_Axes.m_AxisData[Axis_X].m_Max);
                }
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


// draw all the bar-graph specific stuff
void CcPlotBar::DrawView(bool print)
{
    if(attachedPlot)
    {
        // if a key has been requested, create a block of names and colours...
        if(m_DrawKey)
        {
            DrawKey();
        }
        
        // setup variables for scaling / positioning of graphs
        // if graph has a title, make top gap bigger
        if(!(m_Axes.m_PlotTitle == ""))
            m_YGapTop = 300;

        // if x axis has a title make the bottom gap bigger
        if(!(m_Axes.m_AxisData[Axis_X].m_Title == ""))
            m_YGapBottom = 500;

        // if y axis has a title make the lhs gap bigger
        if(!(m_Axes.m_AxisData[Axis_YL].m_Title == ""))
            m_XGapLeft = 300;
// re-introduced by DJW - see also ccplotbar, ccplotscatter, ccplotdata
        if(!(m_Axes.m_AxisData[Axis_YR].m_Title == ""))
            m_XGapRight = 300;

        // variables used for loops
        int i=0;
        int j=0;

        // check the axis divisions have been calculated
        if(!m_AxesOK) m_AxesOK = m_Axes.CalculateDivisions();

        // don't draw graph if no data present
        if(m_Series[0].m_Data.empty())      return;

        // gap between division markers on x and y axes
        int xdivoffset = (2400-m_XGapLeft-m_XGapRight) / (m_Axes.m_AxisData[Axis_X].m_NumDiv);          
        int ydivoffset = (2400-m_YGapTop-m_YGapBottom) / (m_Axes.m_AxisData[Axis_YL].m_NumDiv);         
        int yroffset   = 0;
        if(m_Axes.m_NumberOfYAxes == 2) yroffset = (2400 - m_YGapTop - m_YGapBottom)/(m_Axes.m_AxisData[Axis_YR].m_NumDiv);

        // axis dimensions after rounding
        int axisheight = ydivoffset * (m_Axes.m_AxisData[Axis_YL].m_NumDiv);
        int axiswidth = xdivoffset * (m_Axes.m_AxisData[Axis_X].m_NumDiv);
        
        int xseroffset=0;

        // take the axis height, work out where zero is...
        int xorigin    = (int)(2400 - m_XGapLeft   + ((axiswidth *  m_Axes.m_AxisData[Axis_X].m_Min)     / (m_Axes.m_AxisData[Axis_X].m_Max      - m_Axes.m_AxisData[Axis_X].m_Min)));
        int yorigin    = (int)(2400 - m_YGapBottom + (axisheight * (m_Axes.m_AxisData[Axis_YL].m_AxisMin / (m_Axes.m_AxisData[Axis_YL].m_AxisMax - m_Axes.m_AxisData[Axis_YL].m_AxisMin))));
        int yorigright = (int)(2400 - m_YGapBottom + (axisheight * (m_Axes.m_AxisData[Axis_YR].m_AxisMin / (m_Axes.m_AxisData[Axis_YR].m_AxisMax - m_Axes.m_AxisData[Axis_YR].m_AxisMin))));

        //this is the value of y at the origin (may be non-zero for span-graphs)
        float yoriginvalue = 0;
        if(m_Axes.m_AxisData[Axis_YL].m_AxisScaleType == Plot_AxisSpan && m_Axes.m_AxisData[Axis_YL].m_AxisMin > 0) 
        {
            yorigin = 2400 - m_YGapBottom;
            yoriginvalue = m_Axes.m_AxisData[Axis_YL].m_AxisDivisions[0];
        }
        float yoriginvaluer = 0;
        if(m_Axes.m_AxisData[Axis_YR].m_AxisScaleType == Plot_AxisSpan && m_Axes.m_AxisData[Axis_YR].m_AxisMin > 0)
        {
            yorigright = 2400 - m_YGapBottom;
            yoriginvaluer = m_Axes.m_AxisData[Axis_YR].m_AxisDivisions[0];
        }

                // draw a white background (not if printing)
        if(!print)
        {
                        attachedPlot->SetColour(255,255,255);
            attachedPlot->DrawRect(m_XGapLeft, m_YGapTop, 2400-m_XGapRight, 2400-m_YGapBottom, true);
        }
        
        // now loop through the data items, drawing each one
        // if there are 'm_Next' data items, each will use axiswidth/m_Next as an offset
        // NB draw data bars FIRST, so axes / markers are always visible
        int offset = (2400-m_XGapLeft-m_XGapRight) / m_Series[0].m_Data.size();

        // now work out the number of *bar* graphs
        m_NumberOfBarSeries = 0;
        for(i=0; i<m_NumberOfSeries; i++)
            if(m_Series[i].m_DrawStyle == Plot_SeriesBar)
                m_NumberOfBarSeries++;

        if(m_NumberOfBarSeries > 0) xseroffset = offset / m_NumberOfBarSeries;
        else xseroffset = 0;

        int x1 = 0;
        int y1 = 0;
        int x2 = 0;
        int y2 = 0;
        int ysorig = 0;
        float ysorigval = 0;

        // call the axis drawing code (draw on top of data bars)
        m_Axes.DrawAxes(attachedPlot);      

        // loop first through the series
        for(j=0; j<m_NumberOfSeries; j++)
        {
            // set to series colour
            attachedPlot->SetColour(m_Colour[0][j%NCOLS],m_Colour[1][j%NCOLS],m_Colour[2][j%NCOLS]);  
            
            int justify = m_Series[j].m_YAxis;

            if(justify == Axis_YR)
            {
                ysorig = yorigright;
                ysorigval = yoriginvaluer;
            }
            else
            {
                ysorig = yorigin;
                ysorigval = yoriginvalue;
            }

            switch(m_Series[j].m_DrawStyle)
            {               
                // draw this series as a set of vertical bars
                case Plot_SeriesBar:
                {
                    vector<float>::iterator ity = m_Series[j].m_Data.begin();
                    for( i = 0; ity != m_Series[j].m_Data.end(); ity++ )
                    {
                        x1 = m_XGapLeft +  i + j*xseroffset + 5;
                        x2 = x1 + xseroffset - 5;
                        y1 = ysorig;
                        y2 = ysorig - (int)((axisheight * ((*ity - ysorigval) / (m_Axes.m_AxisData[justify].m_AxisMax - m_Axes.m_AxisData[justify].m_AxisMin))));
                        attachedPlot->DrawRect(x1,y1,x2,y2, true);
                        i += offset;
                    }
                    break;
                }

                // draw this series as a set of straight lines connecting the points
                case Plot_SeriesLine:
                {
                    vector<float>::iterator ity = m_Series[j].m_Data.begin();
                    float fy = *ity;
                    ity++;
                    for( i = 0; ity != m_Series[j].m_Data.end(); ity++ )
                    {
                        x1 = m_XGapLeft + (int)((i+0.5)*offset);
                        x2 = x1 + offset;
                        y1 = ysorig - (int) ( (axisheight * m_Series[j].m_Data[i] - ysorigval) / (m_Axes.m_AxisData[justify].m_AxisMax- m_Axes.m_AxisData[justify].m_AxisMin));
                        y2 = ysorig - (int) ( (axisheight * m_Series[j].m_Data[i+1] - ysorigval) / (m_Axes.m_AxisData[justify].m_AxisMax - m_Axes.m_AxisData[justify].m_AxisMin));
                        attachedPlot->DrawLine(2, x1,y1,x2,y2);
                        i++;
                    }
                    break;
                }
            }
        }


        // display all the above
        attachedPlot->Display();
    }
}

// create a text string describing the data point at a certain coordinate
PlotDataPopup CcPlotBar::GetDataFromPoint(CcPoint *point)
{
    PlotDataPopup ret;

// don't draw graph if no data present
    if(m_Series[0].m_Data.empty())   return ret;


    // point has not yet been found
    bool pointfound = false;

    // only calculate mouse-over when pointer is inside the graph itself
    if((point->x < (2400 - m_XGapRight)) && (point->x > m_XGapLeft) && (point->y > m_YGapTop) && (point->y < (2400 - m_YGapBottom)))
    {
        ostringstream popup;
        // if there are non-bar data series (scatter or line), calculate for them first...
        if(m_NumberOfBarSeries > 0)
        {
            int x = point->x - m_XGapLeft;
           // need to : interpolate between xmin,xmax to get the label at that point,
            int axiswidth = 2400 - m_XGapLeft - m_XGapRight;
            int axisheight = 2400 - m_YGapTop - m_YGapBottom;
            int bar = axiswidth / m_Series[0].m_Data.size();

            // search through all data points to find the one the pointer is over
            for(int i=0; i<m_NumberOfSeries; i++)
            {
                if(m_Series[i].m_DrawStyle != Plot_SeriesBar)
                {
                    int axis = m_Series[i].m_YAxis;
                    float y = m_Axes.m_AxisData[axis].m_AxisMax + (m_Axes.m_AxisData[axis].m_AxisMin-m_Axes.m_AxisData[axis].m_AxisMax)*(point->y - m_YGapTop) / axisheight;

                    int j = 0;
                    vector<float>::iterator ity = m_Series[i].m_Data.begin();
                    vector<string>::iterator its = m_Axes.m_Labels.begin();
                    for( ; ity != m_Series[i].m_Data.end(); ity++ )
                    {
                        if((y > *ity - 0.1) && (y < *ity +0.1 ))
                        {
                            ostringstream yval;
                            if((x > (j+0.5)*bar-20) && (x < (j+0.5)*bar+20))
                            {
                                if(!(m_Series[i].m_SeriesName == ""))
                                {
                                    popup << m_Series[i].m_SeriesName << "; ";
                                    ret.m_SeriesName = m_Series[i].m_SeriesName;
                                }
 
                                popup << *its << "; " << *ity;
                                ret.m_XValue = *its;
                                yval << *ity;
                                ret.m_YValue = yval.str();
                                pointfound = true;
                                ret.m_Valid = true;
                                ret.m_PopupText = popup.str();

                                point->y = m_YGapTop;
                                point->x = (int)(m_XGapLeft + (j+0.5)*bar);
                            }
                        }
                        j++; its++;
                    }
                }
            }
        }
        // if only bar-series present (or if point not found...) return the bar the pointer is over.
        if(pointfound == false)
        {
            // need to : interpolate between xmin,xmax to get the label at that point,
            int axiswidth = 2400 - m_XGapLeft - m_XGapRight;
            
            // work out the width of each label...
            int width = axiswidth / (m_Series[0].m_Data.size());

            // now work out the label which contains point.x
            int num = (point->x - m_XGapLeft)/width;

            // now work out the specific bar...
            // this is the lhs of the label...
            int lowerlimit = num*width; 
            int bar = m_NumberOfBarSeries*(point->x - m_XGapLeft - lowerlimit)/width;

            if(num < (int)m_Axes.m_Labels.size() )
            {
                // put together a text string to describe the data under the mouse pointer
                if(!(m_Series[bar].m_SeriesName == ""))
                {
                    popup << m_Series[bar].m_SeriesName << "; ";
                }
                else popup.str("");

                popup << m_Axes.m_Labels[num] << "; ";
                ret.m_XValue = m_Axes.m_Labels[num];

                if(m_Axes.m_AxisData[Axis_YL].m_AxisLog)
                {
                    popup << pow(10,m_Series[bar].m_Data[num]);
                    ostringstream yval;
                    yval << pow(10,m_Series[bar].m_Data[num]);
                    ret.m_YValue = yval.str();
                }
                else
                {
                    popup << m_Series[bar].m_Data[num];
                    ostringstream yval;
                    yval << m_Series[bar].m_Data[num];
                    ret.m_YValue = yval.str();
                }

                // change the popup position to better align with bars
                point->x = m_XGapLeft + (num+1)*width;
                point->y = m_YGapTop;
                ret.m_PopupText = popup.str();
                ret.m_Valid = true;
            }
        }
    }

    return ret;
}

// add a series (note: can be called after the rest of the graph is initialised)
void CcPlotBar::AddSeries(int type, int length)
{
    CcSeries b;
    b.m_DrawStyle = type;
    m_Series.push_back(b);
    m_CompleteSeries = m_NumberOfSeries;
    m_NumberOfSeries++;
}

// create the data series
void CcPlotBar::CreateSeries(int numser, vector<int> & type)
{
    m_Series.clear();
    m_NumberOfSeries = numser;

    // fill this array
    for(int i=0; i<numser; i++)
    {
        CcSeries sb;
        sb.m_DrawStyle = type[i];
        m_Series.push_back( sb );
    }
}

void CcPlotBar::SaveToFile(string filename) 
{
        FILE* output = fopen( filename.c_str(), "w+" );

		if ( output == NULL ) {
             LOGERR("Could not open file to save plot data");
			 return;
		}			
	
       // check if data is present
		if(m_Series[0].m_Data.empty())   return;
        
        for(int j=0; j<m_NumberOfSeries; j++)
        {
			fprintf( output, "\nSeries %d: %s\n", j+1, m_Series[j].m_SeriesName.c_str());
			vector<string>::iterator its = m_Axes.m_Labels.begin();
			vector<float>::iterator ity = m_Series[j].m_Data.begin();
			for( int i = 0; ity != m_Series[j].m_Data.end(); ity++ )
			{
				fprintf( output, "%s,%f,%d\n", (*its).c_str(), *ity, j+1 );
				its++;
			}
		}
		fclose(output);
}

