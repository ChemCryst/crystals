////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cpp
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotScatter is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
// Revision 1.28  2012/01/04 14:32:06  rich
// Bigger, rounder, circles in plots.
//
// Revision 1.27  2011/09/21 09:31:13  rich
// Draw circles instead of ellipses.
//
// Revision 1.26  2008/03/12 14:10:00  djw
// Richards clever fix to stop the Fo-Fc plot falling over
//
// Revision 1.25  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.2  2005/01/14 12:10:58  rich
// Fixed reflection indices for omitted reflections in Fo vs Fc graph.
//
// Revision 1.1.1.1  2004/12/13 11:16:17  rich
// New CRYSTALS repository
//
// Revision 1.24  2004/06/24 09:12:01  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.23  2003/12/09 09:51:54  rich
// Fix colours of data series in plots if > 6 series.
//
// Revision 1.22  2003/09/11 14:06:29  rich
// Rearrange expression that gcc didn't like.
//
// Revision 1.21  2003/07/08 09:59:08  rich
//
// Fixed bug where x and y axis scales went
// slightly wrong for graphs with data scaled
// on a second y-axis.
//
// Revision 1.20  2003/05/07 12:18:56  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.19  2002/11/12 15:16:29  rich
// Make lines on xy graphs a little thicker.
// Allow series that are added later (using ADDSERIES) to an xy graph to have their
// own labels.
//
// Revision 1.18  2002/10/16 09:07:31  rich
// Make the graphs a bit trendier.
//
// Revision 1.17  2002/07/15 12:19:13  richard
// Reorder headers to improve ease of linking.
// Update program to use new standard C++ io libraries.
// Update to use new version of MFC (5.0 with .NET.)
//
// Revision 1.16  2002/07/03 14:23:21  richard
// Replace as many old-style stream class header references with new style
// e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
// Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
// stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
// Removed some bits from Steve's Plot classes that were generating (harmless) compiler
// warning messages.
//
// Revision 1.15  2002/02/21 15:23:12  DJWgroup
// SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
// Revision 1.14  2002/02/20 12:05:19  DJWgroup
// SH: Added class to allow easier passing of mouseover information from plot classes.
//
// Revision 1.13  2002/02/18 15:16:42  DJWgroup
// SH: Added ADDSERIES command, and allowed series to have different lengths.
//
// Revision 1.12  2002/02/18 11:21:12  DJWgroup
// SH: Update to plot code.
//
// Revision 1.11  2002/01/22 16:12:26  ckpgroup
// Small change to allow inverted axes (eg for Wilson plots). Use 'ZOOM 4 0'.
//
// Revision 1.10  2002/01/16 10:28:38  ckpgroup
// SH: Updated memory reallocation for large plots. Added optional labels to scatter points.
//
// Revision 1.9  2002/01/14 12:19:54  ckpgroup
// SH: Various changes. Fixed scatter graph memory allocation.
// Fixed mouse-over for scatter graphs. Updated graph key.
//
// Revision 1.8  2001/12/12 16:02:24  ckpgroup
// SH: Reorganised script to allow right-hand y axes.
// Added floating key if required, some redraw problems.
//
// Revision 1.7  2001/11/29 15:46:10  ckpgroup
// SH: Update of script commands to support second y axis, general update.
//
// Revision 1.6  2001/11/26 16:47:35  ckpgroup
// SH: More MouseOver changes. Scatterplots display the graph coordinates of the mouse pointer.
// Remove labels when mouse leaves window.
//
// Revision 1.5  2001/11/26 14:02:49  ckpgroup
// SH: Added mouse-over message support - display label and data value for the bar
// under the pointer.
//
// Revision 1.4  2001/11/22 15:33:20  ckpgroup
// SH: Added different draw-styles (line / area / bar / scatter).
// Changed graph layout. Changed second series to blue for better contrast.
//
// Revision 1.3  2001/11/19 16:32:20  ckpgroup
// SH: General update, bug-fixes, better text alignment. Removed a lot of duplicate code.
//
// Revision 1.2  2001/11/12 16:24:29  ckpgroup
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
#include    "ccplotscatter.h"
#include    "crplot.h"
#include    "cccontroller.h"
#include    "ccpoint.h"
#include    <string>
#include    <sstream>

#ifdef CRY_USEWX
 #include <wx/thread.h>
#endif

// set the graph type
CcPlotScatter::CcPlotScatter( )
{
    m_Axes.m_GraphType = Plot_GraphScatter;
    series_has_independent_labels = false;
}

CcPlotScatter::~CcPlotScatter()
{
}

// handle the data input for scatter graphs
bool CcPlotScatter::ParseInput( deque<string> &  tokenList )
{
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

                m_Series[0].m_Label.reserve(length);
                for(int i=0; i<m_NumberOfSeries; i++)
                {
                    m_Series[i].m_DataXY[0].reserve(length);
                    m_Series[i].m_DataXY[1].reserve(length);
                }

                break;
            }


            // get a label associated with this data item
            case kTPlotLabel:
            {
                tokenList.pop_front(); // "LABEL"

// For independent series (added separately using ADDSERIES), the labels should
// be stored independently:

                                int sernum = 0;
                if ( m_CompleteSeries > 0 ) {
                    sernum = m_CompleteSeries;
                    series_has_independent_labels = true;
                }


                string nlabel = (tokenList.front());
                tokenList.pop_front();
                (m_Series[sernum]).m_Label.push_back(nlabel);

                break;
            }

            // get a data item (x,y pair)
            case kTPlotData:
            {
                tokenList.pop_front(); // "DATA"

                // now save the data (x1 y1 x2 y2 ...)
                for(int i=m_CompleteSeries; i< m_NumberOfSeries; i++)
                {
                    for(int j=0; j<2; j++)
                    {
                        float tempdata = (float)atof(tokenList.front().c_str());
                        tokenList.pop_front();

                        // change axis range if necessary
                        m_Axes.CheckData(j, tempdata);
        
                        if(m_Axes.m_AxisData[j].m_AxisLog)
                        {
                            if(tempdata <= 0)
                            {
//                              LOGERR("Negative data passed to a LOG plot...");
                            }
                            else tempdata = (float)log10(tempdata);
                        }

                        // and copy this to m_Series[i].m_DataXY[j][n]
                        (m_Series[i]).m_DataXY[j].push_back(tempdata);
                    }
                    
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


// draw scatter-graph specific stuff
void CcPlotScatter::DrawView(bool print)
{
    if(attachedPlot)
    {
        // if a key has been requested, create a block of names and colours...
        if(attachedPlot && m_DrawKey)
        {
            DrawKey();
        }
        
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

        // used in loops
        int i=0;
        int j=0;

        // check the axis divisions have been calculated
        if(!m_AxesOK) m_AxesOK = m_Axes.CalculateDivisions();

        // don't draw the graph if no data is present
        if(m_Series[0].m_DataXY[0].empty())     return;
        
        // gap between division markers on x and y axes
        int xdivoffset = (2400-m_XGapLeft-m_XGapRight) / (m_Axes.m_AxisData[Axis_X].m_NumDiv);          
        int ydivoffset = (2400-m_YGapTop-m_YGapBottom) / (m_Axes.m_AxisData[Axis_YL].m_NumDiv);

        // axis dimensions after rounding
        int axisheight = ydivoffset * (m_Axes.m_AxisData[Axis_YL].m_NumDiv);
        int axiswidth = xdivoffset * (m_Axes.m_AxisData[Axis_X].m_NumDiv);
        
        // the offset along the x axis if more than one series
        int xseroffset = xdivoffset / m_NumberOfSeries;         

        // take the axis height, work out where zero is...
        int xorigin = (int)(m_XGapLeft - (axiswidth * (m_Axes.m_AxisData[Axis_X].m_AxisMin / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
        int yorigin = (int)(2400 - m_YGapBottom + (axisheight * (m_Axes.m_AxisData[Axis_YL].m_AxisMin / (m_Axes.m_AxisData[Axis_YL].m_AxisMax - m_Axes.m_AxisData[Axis_YL].m_AxisMin))));

        //this is the value of y at the origin (may be non-zero for span-graphs)
        float yoriginvalue = 0;
        if(m_Axes.m_AxisData[Axis_YL].m_AxisScaleType == Plot_AxisSpan && m_Axes.m_AxisData[Axis_YL].m_AxisMin > 0) 
        {
            yorigin = 2400 - m_YGapBottom;
            yoriginvalue = m_Axes.m_AxisData[Axis_YL].m_AxisDivisions[0];
        }
        
                // draw a white background (not if printing....)
        if(!print)
        {
                        attachedPlot->SetColour(255,255,255);
            attachedPlot->DrawRect(m_XGapLeft, m_YGapTop, 2400-m_XGapRight, 2400-m_YGapBottom, true);
        }
        // call the axis drawing code
        m_Axes.DrawAxes(attachedPlot);      

        // now loop through the data items, drawing each one
        // if there are 'm_Next' data items, each will use 2200/m_Next as an offset
        // NB draw data bars FIRST, so axes / markers are always visible
        int offset = (2400-m_XGapLeft-m_XGapRight) / m_Series[0].m_DataXY[0].size();

        int x1 = 0;
        int y1 = 0;
        int x2 = 0;
        int y2 = 0;

        // loop first through the series
        for(j=0; j<m_NumberOfSeries; j++)
        {
            // set to series colour
            attachedPlot->SetColour(m_Colour[0][j%NCOLS],m_Colour[1][j%NCOLS],m_Colour[2][j%NCOLS]);  

            int axis = m_Series[j].m_YAxis;
            yorigin = (int)(2400 - m_YGapBottom + (axisheight * (m_Axes.m_AxisData[axis].m_AxisMin / (m_Axes.m_AxisData[axis].m_AxisMax - m_Axes.m_AxisData[axis].m_AxisMin))));
            yoriginvalue = 0;
            if(m_Axes.m_AxisData[axis].m_AxisScaleType == Plot_AxisSpan && m_Axes.m_AxisData[axis].m_AxisMin > 0) 
            {
               yorigin = 2400 - m_YGapBottom;
               yoriginvalue = m_Axes.m_AxisData[axis].m_AxisDivisions[0];
            }
            switch(m_Series[j].m_DrawStyle)
            {
                // draw this data series as a scatter graph
                case Plot_SeriesScatter:
                default:
                {
                    // loop through the data members of this series
                    vector<float>::iterator itx = m_Series[j].m_DataXY[0].begin();
                    vector<float>::iterator ity = m_Series[j].m_DataXY[1].begin();
                    for( ; itx != m_Series[j].m_DataXY[0].end(); itx++ )
                    {
                        x1 = (int)(xorigin + (axiswidth  * ( *itx / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
                        y1 = (int)(yorigin - (axisheight * ( *ity - yoriginvalue) / (m_Axes.m_AxisData[axis].m_AxisMax- m_Axes.m_AxisData[axis].m_AxisMin)));
//                        attachedPlot->DrawLine(2, x1-10, y1-10, x1+10, y1+10);
//                        attachedPlot->DrawLine(2, x1-10, y1+10, x1+10, y1-10);
                        attachedPlot->DrawEllipse(x1, y1, 4, 4,false);
                        ity++;
                    }
                    break;

                }
                // draw this data series as a scatter graph of X's
                case Plot_SeriesScatterX:
                {
                    // loop through the data members of this series
                    vector<float>::iterator itx = m_Series[j].m_DataXY[0].begin();
                    vector<float>::iterator ity = m_Series[j].m_DataXY[1].begin();
                    for( ; itx != m_Series[j].m_DataXY[0].end(); itx++ )
                    {
                        x1 = (int)(xorigin + (axiswidth  * ( *itx / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
                        y1 = (int)(yorigin - (axisheight * ( *ity - yoriginvalue) / (m_Axes.m_AxisData[axis].m_AxisMax- m_Axes.m_AxisData[axis].m_AxisMin)));
//                        attachedPlot->DrawLine(2, x1-10, y1-10, x1+10, y1+10);
//                        attachedPlot->DrawLine(2, x1-10, y1+10, x1+10, y1-10);
                        attachedPlot->DrawCross(x1, y1, 4);
                        ity++;
                    }
                    break;

                }

                // draw this data series as a connected line of points
                case Plot_SeriesLine:
                {
                    vector<float>::iterator itx = m_Series[j].m_DataXY[0].begin();
                    vector<float>::iterator ity = m_Series[j].m_DataXY[1].begin();
                    x1 = (int)(xorigin + (axiswidth * ( *itx / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
                    y1 = (int)(yorigin - (axisheight * ( ( *ity - yoriginvalue) / (m_Axes.m_AxisData[axis].m_AxisMax- m_Axes.m_AxisData[axis].m_AxisMin))));
                    itx++; ity++;
                    for( ; itx != m_Series[j].m_DataXY[0].end(); itx++ )
                    {
                        x2 = (int)(xorigin + (axiswidth * ( *itx / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
                        y2 = (int)(yorigin - (axisheight * ( ( *ity - yoriginvalue) / (m_Axes.m_AxisData[axis].m_AxisMax- m_Axes.m_AxisData[axis].m_AxisMin))));
                        attachedPlot->DrawLine(2,x1,y1,x2,y2);
                        x1 = x2; y1 = y2;
                        ity++;
                    }
                    break;
                }

                // draw this series as an area graph: line graph with area underneath filled
                case Plot_SeriesArea:
                {
                    float fx1,fy1;
                    int vert[8] = {0,0,0,0,0,yorigin,0,yorigin};
                    vector<float>::iterator itx = m_Series[j].m_DataXY[0].begin();
                    vector<float>::iterator ity = m_Series[j].m_DataXY[1].begin();
                    fx1 = *itx;
                    fy1 = *ity;
                    itx++; ity++;
                    for( ; itx != m_Series[j].m_DataXY[0].end(); itx++ )
                    {
                        vert[6] = vert[0] = (int)(xorigin + (axiswidth * ( x1 / (m_Axes.m_AxisData[Axis_X].m_AxisMax- m_Axes.m_AxisData[Axis_X].m_AxisMin))));
                        vert[1] = (int)(yorigin - (axisheight * (( y1 - yoriginvalue) / (m_Axes.m_AxisData[axis].m_AxisMax- m_Axes.m_AxisData[axis].m_AxisMin))));
                        vert[4] = vert[2] = (int)(xorigin + (axiswidth * ( *itx / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
                        vert[3] = (int)(yorigin - (axisheight * (( *ity - yoriginvalue) / (m_Axes.m_AxisData[axis].m_AxisMax - m_Axes.m_AxisData[axis].m_AxisMin))));
                        attachedPlot->DrawPoly(4, &vert[0], true);
                        fx1 = *itx; fy1 = *ity;
                        ity++;
                    }
                    break;
                }
            }
        }

        // display all the above
        attachedPlot->Display();
    }
}

PlotDataPopup CcPlotScatter::GetDataFromPoint(CcPoint *point)
{
    PlotDataPopup ret;
    bool pointfound = false;

    if((point->x < (2400 - m_XGapRight)) && (point->x > m_XGapLeft) && (point->y > m_YGapTop) && (point->y < (2400 - m_YGapBottom)))
    {
        int axiswidth = 2400 - m_XGapLeft - m_XGapRight;
        int axisheight = 2400 - m_YGapTop - m_YGapBottom;
        float xrange = m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin;
        xrange /= 100;
        // search through all data points to find the one the pointer is over
        for(int i=0; (i<m_NumberOfSeries) && (pointfound == false); i++)
        {
            int axis = m_Series[i].m_YAxis;
            float yrange = m_Axes.m_AxisData[axis].m_AxisMax - m_Axes.m_AxisData[axis].m_AxisMin;
            yrange /= 100;
            // calculate x and y positions of the cursor
            float y = m_Axes.m_AxisData[axis].m_AxisMax   + (m_Axes.m_AxisData[axis].m_AxisMin   - m_Axes.m_AxisData[axis].m_AxisMax)  *(point->y - m_YGapTop) / axisheight;
            float x = m_Axes.m_AxisData[Axis_X].m_AxisMax + (m_Axes.m_AxisData[Axis_X].m_AxisMin - m_Axes.m_AxisData[Axis_X].m_AxisMax)*(2400-point->x - m_XGapRight) / axiswidth;

            vector<float>::iterator itx = m_Series[i].m_DataXY[0].begin();
            vector<float>::iterator ity = m_Series[i].m_DataXY[1].begin();
            int ind = series_has_independent_labels ? i : 0;
            vector<string>::iterator its = m_Series[ind].m_Label.begin();
            for( ; itx != m_Series[i].m_DataXY[0].end(); itx++ )
            {
                // need to : interpolate between xmin,xmax to get the label at that point,

                if(( x > *itx - xrange ) && ( x < *itx + xrange) )
                {
                    if((y > *ity - yrange) && (y < *ity + yrange))
                    {
                        ostringstream popup, xval, yval;
                        ret.m_SeriesName = "";
                        if(!(m_Series[i].m_SeriesName == ""))
                        {
                            ret.m_SeriesName = m_Series[i].m_SeriesName;
                            popup << m_Series[i].m_SeriesName << "; ";
                        }
                        if ( its != m_Series[ind].m_Label.end() && *its != "")
                        {
                            ret.m_Label = *its;
                            popup << *its << "; ";
                        }
                        popup << "(" << *itx << ", " << *ity << ")";
                        xval << *itx;
                        ret.m_XValue = xval.str();
                        yval << *ity;
                        ret.m_YValue = yval.str();
                        pointfound = true;
                        ret.m_Valid = true;
                        ret.m_PopupText = popup.str();
                    }
                }
                ity++;
                if ( its != m_Series[ind].m_Label.end() ) its++;
            }
        }
    }
    return ret;
}
    
// add a series to the graph
void CcPlotScatter::AddSeries(int type, int length)
{
    CcSeries s;
    s.m_DrawStyle = type;
    m_Series.push_back(s);
    m_NumberOfSeries++;
}

// create the data series
void CcPlotScatter::CreateSeries(int numser, vector<int> & type)
{
    m_Series.clear();
    m_NumberOfSeries = numser;

    // fill this array
    for(int i=0; i<numser; i++)
    {
        CcSeries sc;
        sc.m_DrawStyle = type[i];
        m_Series.push_back( sc );
    }
}



void CcPlotScatter::SaveToFile(string filename) 
{
	
        FILE* output = fopen( filename.c_str(), "w+" );

		if ( output == NULL ) {
             LOGERR("Could not open file to save plot data");
			 return;
		}			
	
       // check if data is present
        if(m_Series[0].m_DataXY[0].empty())     return;
        
        // now loop through the data items
        // loop first through the series
        for(int j=0; j<m_NumberOfSeries; j++)
        {

			fprintf( output, "\nSeries %d: %s\n", j+1, m_Series[j].m_SeriesName.c_str());
			// loop through the data members of this series
            vector<float>::iterator itx = m_Series[j].m_DataXY[0].begin();
            vector<float>::iterator ity = m_Series[j].m_DataXY[1].begin();
            for( ; itx != m_Series[j].m_DataXY[0].end(); itx++ )
            {
				fprintf( output, "%f,%f,%d\n", *itx, *ity, j+1 );
                ity++;
            }
        }
		fclose(output);
}
