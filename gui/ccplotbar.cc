////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CcPlotBar
////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:28

// $Log: not supported by cvs2svn $
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
// e.g. <iostream.h> -> <iostream>. Couldn't change the ones in ccstring however, yet.
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
#include	<math.h>
#include    "crconstants.h"
#include    "ccplotdata.h"
#include    "ccplotbar.h"
#include    "crplot.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"
#include	"ccpoint.h"

#ifdef __BOTHWX__
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
Boolean CcPlotBar::ParseInput( CcTokenList * tokenList )
{
	// first see if the command is for the parent class
    CcPlotData::ParseInput( tokenList );

    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kPlotClass) )
        {
			// a bar-graph label
			case kTPlotLabel:
			{
				tokenList->GetToken();	// 'LABEL'
				
				// next is the label for the nth data item
				CcString nlabel = tokenList->GetToken();

				// check there is enough space for this string
				if(m_NextItem >= m_Axes.m_NumberOfLabels) //m_Series[0]->m_SeriesLength)
				{
					LOGSTAT("Series length needs extending: reallocating memory");

					ExtendSeriesLength(-1);
				}
				
				// copy this label to m_Label[n]
				m_Axes.m_Labels[m_NextItem] = nlabel.ToCString();

				break;
			}
			// a set of data items to match a previously-given label
			case kTPlotData:
			{
				// again ditch the DATA token
				tokenList->GetToken();

				// now record the data itself
				for(int i=m_CompleteSeries; i < (m_NumberOfSeries); i++)
				{
					CcString ndata = tokenList->GetToken();
					float tempdata = (float)atof(ndata.ToCString());

					// changes axis range if necessary
					m_Axes.CheckData(m_Series[i]->m_YAxis, tempdata);			
				
					if(m_Axes.m_AxisData[m_Series[i]->m_YAxis].m_AxisLog)
					{
						if(tempdata <= 0)
						{
							LOGERR("Negative data passed to a LOG plot...");
						}
						else tempdata = (float)log10(tempdata);
					}

					// check there is enough space for this string
					if(m_NextItem >= m_Series[i]->m_SeriesLength)
					{
						LOGSTAT("Series length needs extending: reallocating memory");

						ExtendSeriesLength(i);
					}

					// and copy this to m_Series[i]->m_Data[n]
					((CcSeriesBar*)m_Series[i])->m_Data[m_NextItem] = tempdata;
					// let the series know we've added an item
					((CcSeriesBar*)m_Series[i])->m_NumberOfItems++;
				}

				m_NextItem++;		// make sure next label / data pair goes into the next slot
				if(m_NextItem > m_MaxItem) m_MaxItem = m_NextItem;

				// make sure the x axis knows how many items there are...
				if(m_NextItem > m_Axes.m_AxisData[Axis_X].m_Max) m_Axes.m_AxisData[Axis_X].m_Max++;

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

// reallocate memory if series overruns estimated length
void CcPlotBar::ExtendSeriesLength(int ser)
{
	bool prevlabel; // are any labels present?
	if(ser == -1)
	{
		if(m_Axes.m_NumberOfLabels == 0)
		{
			prevlabel = false;
			m_Axes.m_NumberOfLabels = 10;
		}
		else prevlabel = true;

		// allocate new memory 
		CcString* templabels = new CcString[(int)(m_Axes.m_NumberOfLabels * 1.5)];
		
		// loop through the previous set of bar-labels, copying data to the new one
		// NB: if prevlabel = false (eg this is the first label stored) there are no previous labels to copy, so skip this loop.
		//		(m_NumberOfLabels * false) == 0 ! Yuck.
		for(int j=0; j<m_Axes.m_NumberOfLabels*prevlabel; j++)		
		{
			templabels[j] = m_Axes.m_Labels[j].ToCString();
		}

		// free the previously allocated memory, point to the new area
		if(prevlabel) delete [] m_Axes.m_Labels;					
		m_Axes.m_Labels = templabels;
		m_Axes.m_NumberOfLabels = (int)(m_Axes.m_NumberOfLabels * 1.5);

		return;
	}

	int i = ser;
	float *   tempdata = 0;

	// check m_SeriesLength is non-zero
	if(m_Series[i]->m_SeriesLength == 0) m_Series[i]->m_SeriesLength = 10;

	// copy data to newly allocated memory
	tempdata = new float[(int)(m_Series[i]->m_SeriesLength * 1.5)];

	for(int j=0; j<m_Series[i]->m_SeriesLength; j++)
	{
		tempdata[j] = ((CcSeriesBar*)m_Series[i])->m_Data[j];
	}

	// delete the previous memory area, point to the new one.
	delete [] ((CcSeriesBar*)m_Series[i])->m_Data;
	((CcSeriesBar*)m_Series[i])->m_Data = tempdata;

	// the series has now been extended
	m_Series[i]->m_SeriesLength = (int)(m_Series[i]->m_SeriesLength*1.5);
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
		if(!(m_Axes.m_AxisData[Axis_YR].m_Title == ""))
			m_XGapRight = 300;

		// variables used for loops
		int i=0;
		int j=0;

		// check the axis divisions have been calculated
		if(!m_AxesOK) m_AxesOK = m_Axes.CalculateDivisions();

		// don't draw graph if no data present
		if(m_MaxItem == 0)
			return;

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
		int xorigin	   = (int)(2400 - m_XGapLeft   + ((axiswidth *  m_Axes.m_AxisData[Axis_X].m_Min)     / (m_Axes.m_AxisData[Axis_X].m_Max      - m_Axes.m_AxisData[Axis_X].m_Min)));
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

		// draw a grey background (not if printing)
		if(!print)
		{
			attachedPlot->SetColour(200,200,200);
			attachedPlot->DrawRect(m_XGapLeft, m_YGapTop, 2400-m_XGapRight, 2400-m_YGapBottom, true);
		}
		
		// now loop through the data items, drawing each one
		// if there are 'm_Next' data items, each will use axiswidth/m_Next as an offset
		// NB draw data bars FIRST, so axes / markers are always visible
		int offset = (2400-m_XGapLeft-m_XGapRight) / m_MaxItem;

		// now work out the number of *bar* graphs
		m_NumberOfBarSeries = 0;
		for(i=0; i<m_NumberOfSeries; i++)
			if(m_Series[i]->m_DrawStyle == Plot_SeriesBar)
				m_NumberOfBarSeries++;

		if(m_NumberOfBarSeries > 0) xseroffset = offset / m_NumberOfBarSeries;
		else xseroffset = 0;

		int x1 = 0;
		int y1 = 0;
		int x2 = 0;
		int y2 = 0;
		int ysorig = 0;
		float ysorigval = 0;

		// loop first through the series
		for(j=0; j<m_NumberOfSeries; j++)
		{
			// set to series colour
			attachedPlot->SetColour(m_Colour[0][j],m_Colour[1][j],m_Colour[2][j]);	
			
			int justify = m_Series[j]->m_YAxis;

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

			switch(m_Series[j]->m_DrawStyle)
			{				
				// draw this series as a set of vertical bars
				case Plot_SeriesBar:
				{
					for(i=0; i<m_Series[j]->m_NumberOfItems; i++)
					{
						x1 = m_XGapLeft + i*offset + j*xseroffset + 5;
						x2 = x1 + xseroffset - 5;
						y1 = ysorig;
						y2 = ysorig - (int)((axisheight * ((((CcSeriesBar*)m_Series[j])->m_Data[i] - ysorigval) / (m_Axes.m_AxisData[justify].m_AxisMax - m_Axes.m_AxisData[justify].m_AxisMin))));

						attachedPlot->DrawRect(x1,y1,x2,y2, true);
					}
					break;
				}

				// draw this series as a set of straight lines connecting the points
				case Plot_SeriesLine:
				{
					for(i=0; i<m_Series[j]->m_NumberOfItems-1; i++)
					{
						x1 = m_XGapLeft + (int)((i+0.5)*offset);
						x2 = x1 + offset;
						y1 = ysorig - (int)((axisheight * ((((CcSeriesBar*)m_Series[j])->m_Data[i] - ysorigval) / (m_Axes.m_AxisData[justify].m_AxisMax- m_Axes.m_AxisData[justify].m_AxisMin))));
						y2 = ysorig - (int)((axisheight * ((((CcSeriesBar*)m_Series[j])->m_Data[i+1] - ysorigval) / (m_Axes.m_AxisData[justify].m_AxisMax - m_Axes.m_AxisData[justify].m_AxisMin))));

                                                attachedPlot->DrawLine(2, x1,y1,x2,y2);
					}
					break;
				}
			}
		}

		// call the axis drawing code (draw on top of data bars)
		m_Axes.DrawAxes(attachedPlot);		

		// display all the above
		attachedPlot->Display();
    }
}

// create a text string describing the data point at a certain coordinate
PlotDataPopup CcPlotBar::GetDataFromPoint(CcPoint *point)
{
	PlotDataPopup ret;

// don't draw graph if no data present
	if(m_MaxItem == 0)
                return ret;


	// point has not yet been found
	bool pointfound = false;

	// only calculate mouse-over when pointer is inside the graph itself
	if((point->x < (2400 - m_XGapRight)) && (point->x > m_XGapLeft) && (point->y > m_YGapTop) && (point->y < (2400 - m_YGapBottom)))
	{
		// if there are non-bar data series (scatter or line), calculate for them first...
		if(m_NumberOfBarSeries > 0)
		{
			// search through all data points to find the one the pointer is over
			for(int i=0; i<m_NumberOfSeries; i++)
			{
				if(m_Series[i]->m_DrawStyle != Plot_SeriesBar)
				{
					for(int j=0; j<m_Series[i]->m_NumberOfItems; j++)
					{
						int axis = m_Series[i]->m_YAxis;

						// need to : interpolate between xmin,xmax to get the label at that point,
						int axiswidth = 2400 - m_XGapLeft - m_XGapRight;
						int axisheight = 2400 - m_YGapTop - m_YGapBottom;
		
						// calculate x and y positions of the cursor
						float y = m_Axes.m_AxisData[axis].m_AxisMax + (m_Axes.m_AxisData[axis].m_AxisMin-m_Axes.m_AxisData[axis].m_AxisMax)*(point->y - m_YGapTop) / axisheight;
						int x = point->x - m_XGapLeft;

						int bar = axiswidth / m_MaxItem;

						if((y > ((CcSeriesBar*)m_Series[i])->m_Data[j]-0.1) && (y < ((CcSeriesBar*)m_Series[i])->m_Data[j]+0.1))
						{
							if((x > (j+0.5)*bar-20) && (x < (j+0.5)*bar+20))
							{
								if(!(m_Series[i]->m_SeriesName == ""))
								{
									ret.m_PopupText = m_Series[i]->m_SeriesName;
									ret.m_SeriesName = m_Series[i]->m_SeriesName;
									ret.m_PopupText += "; ";
								}
								else
								{
									ret.m_PopupText = "";
								}

								ret.m_PopupText += m_Axes.m_Labels[j];
								ret.m_PopupText += "; ";
								ret.m_PopupText += ((CcSeriesBar*)m_Series[i])->m_Data[j];
								ret.m_XValue = m_Axes.m_Labels[j];
								ret.m_YValue = ((CcSeriesBar*)m_Series[i])->m_Data[j];
								pointfound = true;
								ret.m_Valid = true;

								point->y = m_YGapTop;
								point->x = (int)(m_XGapLeft + (j+0.5)*bar);
							}
						}
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
			int width = axiswidth / (m_MaxItem);

			// now work out the label which contains point.x
			int num = (point->x - m_XGapLeft)/width;

			// now work out the specific bar...
			// this is the lhs of the label...
			int lowerlimit = num*width;	
			int bar = m_NumberOfBarSeries*(point->x - m_XGapLeft - lowerlimit)/width;

			if(num < (m_MaxItem))
			{
				// put together a text string to describe the data under the mouse pointer
				if(!(m_Series[bar]->m_SeriesName == ""))
				{
					ret.m_PopupText = m_Series[bar]->m_SeriesName;
					ret.m_PopupText += "; ";
				}
				else ret.m_PopupText = "";

				ret.m_PopupText += m_Axes.m_Labels[num];
				ret.m_PopupText += "; ";
				ret.m_XValue = m_Axes.m_Labels[num];

				if(m_Axes.m_AxisData[Axis_YL].m_AxisLog)
				{
					ret.m_PopupText += pow(10,((CcSeriesBar*)m_Series[bar])->m_Data[num]);
					ret.m_YValue = pow(10,((CcSeriesBar*)m_Series[bar])->m_Data[num]);
				}
				else
				{
					ret.m_PopupText += ((CcSeriesBar*)m_Series[bar])->m_Data[num];
					ret.m_YValue = ((CcSeriesBar*)m_Series[bar])->m_Data[num];
				}

				// change the popup position to better align with bars
				point->x = m_XGapLeft + (num+1)*width;
				point->y = m_YGapTop;
				ret.m_Valid = true;
			}
		}
	}

	return ret;
}

// add a series (note: can be called after the rest of the graph is initialised)
void CcPlotBar::AddSeries(int type, int length)
{
	// need to re-allocate memory for the series list, transfer pointers over, and delete old memory
	CcSeries** temp = new CcSeries*[m_NumberOfSeries + 1];
	for(int i=0; i<m_NumberOfSeries; i++)
	{
		temp[i] = m_Series[i];
	}

	temp[m_NumberOfSeries] = new CcSeriesBar;
	temp[m_NumberOfSeries]->m_DrawStyle = type;
	temp[m_NumberOfSeries]->m_SeriesLength = length;
	temp[m_NumberOfSeries]->AllocateMemory();

	delete [] m_Series;
	
	m_Series = temp;

	m_CompleteSeries = m_NumberOfSeries;
	m_NumberOfSeries++;
}

// create the data series
void CcPlotBar::CreateSeries(int numser, int* type)
{
	// create an array of pointers to data series
	m_Series = new CcSeries*[numser];
	m_NumberOfSeries = numser;

	// fill the array with bar-series
	for(int i=0; i<numser; i++)
	{
		m_Series[i] = new CcSeriesBar();
		m_Series[i]->m_DrawStyle = type[i];
	}
}

// allocate memory within each series
void CcPlotBar::AllocateMemory()
{
	// an array of pointers to CcString text labels
	if ( m_Axes.m_NumberOfLabels )
    	m_Axes.m_Labels = new CcString[m_Axes.m_NumberOfLabels];
	for(int j=0; j<m_Axes.m_NumberOfLabels; j++)
		m_Axes.m_Labels[j] = j;
	
	m_NextItem = 0;

	// allocate the data memory space here
	for(int i=0; i<m_NumberOfSeries; i++)
	{
		m_Series[i]->AllocateMemory();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////
//
//	The CcSeriesBar stuff
//
////////////////////////////////////////////////////////////////////////////////////////////

CcSeriesBar::CcSeriesBar()
{
	m_Data		= 0;
	m_DrawStyle = Plot_SeriesBar;		// draw bars by default
}

// free up any allocated memory
CcSeriesBar::~CcSeriesBar()
{
	if(m_Data) delete [] m_Data;
	m_Data = 0;
}

// handle any messages (none used at present)
Boolean CcSeriesBar::ParseInput( CcTokenList * tokenList )
{
    CcSeries::ParseInput( tokenList );

//    Boolean hasTokenForMe = true;
//    while ( hasTokenForMe )
//    {
//        switch ( tokenList->GetDescriptor(kPlotClass) )
//        {
//            default:
//            {
//                hasTokenForMe = false;
//                break; // We leave the token in the list and exit the loop
//            }
//        }
//    }
//
    return true;
}

// allocate memory for this series
void CcSeriesBar::AllocateMemory()
{
	if(m_SeriesLength == 0) m_SeriesLength = 10;

	m_Data = new float[m_SeriesLength];
	for(int j=0; j<m_SeriesLength; j++)
	{
		m_Data[j] = 0;
	}
}
