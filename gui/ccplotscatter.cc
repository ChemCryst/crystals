////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cpp
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotScatter is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
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

#include	<math.h>
#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccplotdata.h"
#include    "ccplotscatter.h"
#include    "crplot.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"
#include	"ccpoint.h"

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif

// set the graph type
CcPlotScatter::CcPlotScatter( )
{
	m_Axes.m_GraphType = Plot_GraphScatter;
}

CcPlotScatter::~CcPlotScatter()
{
}

// handle the data input for scatter graphs
Boolean CcPlotScatter::ParseInput( CcTokenList * tokenList )
{
    CcPlotData::ParseInput( tokenList );

    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kPlotClass) )
        {
			// get a label associated with this data item
			case kTPlotLabel:
			{
				tokenList->GetToken(); // "LABEL"

				// check there is enough space for this data item
				if(m_NextItem >= m_SeriesLength)
				{
					LOGWARN("Series length needs extending: reallocating memory");

					ExtendSeriesLength();
				}

				CcString nlabel = tokenList->GetToken();
				((CcSeriesScatter*)m_Series[0])->m_Label[m_NextItem] = nlabel;

				break;
			}

			// get a data item (x,y pair)
			case kTPlotData:
			{
				tokenList->GetToken(); // "DATA"

				CcString ndata;

				// check there is enough space for this data item
				if(m_NextItem >= m_SeriesLength)
				{
					LOGWARN("Series length needs extending: reallocating memory");

					ExtendSeriesLength();
				}

				// now save the data (x1 y1 x2 y2 ...)
				for(int i=m_CompleteSeries; i< m_NumberOfSeries; i++)
				{
					for(int j=0; j<2; j++)
					{
						ndata = tokenList->GetToken();
						float tempdata = (float)atof(ndata.ToCString());

						// change axis range if necessary
						m_Axes.CheckData(j, tempdata);
		
						if(m_Axes.m_AxisData[j].m_AxisLog)
						{
							if(tempdata <= 0)
							{
								LOGWARN("Negative data passed to a LOG plot...");
							}
							else tempdata = (float)log10(tempdata);
						}

						// and copy this to m_Series[i]->m_Data[j][n]
						((CcSeriesScatter*)m_Series[i])->m_Data[j][m_NextItem] = tempdata;
					}
					
					// let the series know we've added an item
					((CcSeriesScatter*)m_Series[i])->m_NumberOfItems++;
				}
				m_NextItem++;		// make sure next label / data pair goes into the next slot
				if(m_NextItem > m_MaxItem) m_MaxItem = m_NextItem;
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

// reallocate memory if data overruns estimated length
void CcPlotScatter::ExtendSeriesLength()
{
	float *  tempdata[2];
	tempdata[0] = 0;
	tempdata[1] = 0;
	CcString* templabels = 0;
	
	for(int i=0; i< m_NumberOfSeries; i++)
	{
		// check series length is non-zero
		if(m_SeriesLength == 0) m_SeriesLength = 10;

		// allocate some new memory
		tempdata[Axis_X] = new float[(int)(m_SeriesLength * 1.5)];
		tempdata[Axis_YL] = new float[(int)(m_SeriesLength * 1.5)];
		templabels = new CcString[(int)(m_SeriesLength * 1.5)];

		// transfer the data across
		for(int j=0; j<m_SeriesLength; j++)
		{
			tempdata[Axis_X][j] = ((CcSeriesScatter*)m_Series[i])->m_Data[Axis_X][j];
			tempdata[Axis_YL][j] = ((CcSeriesScatter*)m_Series[i])->m_Data[Axis_YL][j];
			templabels[j] = ((CcSeriesScatter*)m_Series[i])->m_Label[j];
		}

		// free the old memory
		delete [] ((CcSeriesScatter*)m_Series[i])->m_Data[Axis_X];
		delete [] ((CcSeriesScatter*)m_Series[i])->m_Data[Axis_YL];
		delete [] ((CcSeriesScatter*)m_Series[i])->m_Label;

		// and point to the new memory
		((CcSeriesScatter*)m_Series[i])->m_Data[Axis_X] = tempdata[Axis_X];
		((CcSeriesScatter*)m_Series[i])->m_Data[Axis_YL] = tempdata[Axis_YL];
		((CcSeriesScatter*)m_Series[i])->m_Label = templabels;
	}

	// series has been extended...
	m_SeriesLength = (int)(m_SeriesLength*1.5);
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
		if(!(m_Axes.m_AxisData[Axis_YR].m_Title == ""))
			m_XGapRight = 200;

		// used in loops
		int i=0;
		int j=0;

		// check the axis divisions have been calculated
		if(!m_AxesOK) m_AxesOK = m_Axes.CalculateDivisions();

		// don't draw the graph if no data is present
		if(m_MaxItem == 0)
			return;
		
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
		
		// draw a grey background (not if printing....)
		if(!print)
		{
			attachedPlot->SetColour(200,200,200);
			attachedPlot->DrawRect(m_XGapLeft, m_YGapTop, 2400-m_XGapRight, 2400-m_YGapBottom, true);
		}

		// now loop through the data items, drawing each one
		// if there are 'm_Next' data items, each will use 2200/m_Next as an offset
		// NB draw data bars FIRST, so axes / markers are always visible
		int offset = (2400-m_XGapLeft-m_XGapRight) / m_MaxItem;

		int x1 = 0;
		int y1 = 0;
		int x2 = 0;
		int y2 = 0;;

		// loop first through the series
		for(j=0; j<m_NumberOfSeries; j++)
		{
			// set to series colour
			attachedPlot->SetColour(m_Colour[0][j],m_Colour[1][j],m_Colour[2][j]);	

			switch(m_Series[j]->m_DrawStyle)
			{
				// draw this data series as a scatter graph
				case Plot_SeriesScatter:
				default:
				{
					// loop through the data members of this series
					for(i=0; i<m_Series[j]->m_NumberOfItems; i++)
					{
						x1 = (int)(xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i]) / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
						y1 = (int)(yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_YL][i] - yoriginvalue) / (m_Axes.m_AxisData[Axis_YL].m_AxisMax- m_Axes.m_AxisData[Axis_YL].m_AxisMin))));
						attachedPlot->DrawLine(2, x1-10, y1-10, x1+10, y1+10);
						attachedPlot->DrawLine(2, x1-10, y1+10, x1+10, y1-10);
					}
					break;

				}

				// draw this data series as a connected line of points
				case Plot_SeriesLine:
				{
					for(i=0; i<m_Series[j]->m_NumberOfItems-1; i++)
					{
						x1 = (int)(xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i]) / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
						y1 = (int)(yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_YL][i] - yoriginvalue) / (m_Axes.m_AxisData[Axis_YL].m_AxisMax- m_Axes.m_AxisData[Axis_YL].m_AxisMin))));
						x2 = (int)(xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i+1]) / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
						y2 = (int)(yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_YL][i+1] - yoriginvalue) / (m_Axes.m_AxisData[Axis_YL].m_AxisMax - m_Axes.m_AxisData[Axis_YL].m_AxisMin))));

						attachedPlot->DrawLine(1,x1,y1,x2,y2);
					}
					break;
				}

				// draw this series as an area graph: line graph with area underneath filled
				case Plot_SeriesArea:
				{
					int vert[8] = {0,0,0,0,0,0,0,0};

					for(i=0; i<m_Series[j]->m_NumberOfItems-1; i++)
					{
						vert[0] = (int)(xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i]) / (m_Axes.m_AxisData[Axis_X].m_AxisMax- m_Axes.m_AxisData[Axis_X].m_AxisMin))));
						vert[1] = (int)(yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_YL][i] - yoriginvalue) / (m_Axes.m_AxisData[Axis_YL].m_AxisMax- m_Axes.m_AxisData[Axis_YL].m_AxisMin))));
						vert[2] = (int)(xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i+1]) / (m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin))));
						vert[3] = (int)(yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_YL][i+1] - yoriginvalue) / (m_Axes.m_AxisData[Axis_YL].m_AxisMax - m_Axes.m_AxisData[Axis_YL].m_AxisMin))));

						vert[4] = vert[2];
						vert[5] = yorigin;
						vert[6] = vert[0];
						vert[7] = yorigin;

						attachedPlot->DrawPoly(4, &vert[0], true);
					}
					break;
				}
			}
		}
		// call the axis drawing code
		m_Axes.DrawAxes(attachedPlot);		

		// display all the above
		attachedPlot->Display();
    }
}

CcString CcPlotScatter::GetDataFromPoint(CcPoint *point)
{
	CcString ret = "error";
	bool pointfound = false;

	if((point->x < (2400 - m_XGapRight)) && (point->x > m_XGapLeft) && (point->y > m_YGapTop) && (point->y < (2400 - m_YGapBottom)))
	{
		// search through all data points to find the one the pointer is over
		for(int i=0; (i<m_NumberOfSeries) && (pointfound == false); i++)
		{
			for(int j=0; j<m_SeriesLength; j++)
			{
				int axis = m_Series[i]->m_YAxis;

				// need to : interpolate between xmin,xmax to get the label at that point,
				int axiswidth = 2400 - m_XGapLeft - m_XGapRight;
				int axisheight = 2400 - m_YGapTop - m_YGapBottom;

				int xrange = m_Axes.m_AxisData[Axis_X].m_AxisMax - m_Axes.m_AxisData[Axis_X].m_AxisMin;
				int yrange = m_Axes.m_AxisData[axis].m_AxisMax - m_Axes.m_AxisData[axis].m_AxisMin;

				xrange /= 100;
				yrange /= 100;

				// calculate x and y positions of the cursor
				float y = m_Axes.m_AxisData[axis].m_AxisMax   + (m_Axes.m_AxisData[axis].m_AxisMin   - m_Axes.m_AxisData[axis].m_AxisMax)  *(point->y - m_YGapTop) / axisheight;
				float x = m_Axes.m_AxisData[Axis_X].m_AxisMax + (m_Axes.m_AxisData[Axis_X].m_AxisMin - m_Axes.m_AxisData[Axis_X].m_AxisMax)*(2400-point->x - m_XGapRight) / axiswidth;

				if((x > ((CcSeriesScatter*)m_Series[i])->m_Data[0][j]-xrange) && (x < ((CcSeriesScatter*)m_Series[i])->m_Data[0][j]+xrange))
				{
					if((y > ((CcSeriesScatter*)m_Series[i])->m_Data[1][j]-yrange) && (y < ((CcSeriesScatter*)m_Series[i])->m_Data[1][j]+yrange))
					{
						if(!(m_Series[i]->m_SeriesName == ""))
						{
							ret = m_Series[i]->m_SeriesName;
							ret += "; ";
						}
						else ret = "";
						if(!(((CcSeriesScatter*)m_Series[i])->m_Label[j] == ""))
						{
							ret += ((CcSeriesScatter*)m_Series[i])->m_Label[j];
							ret += "; ";
						}
						ret += "(";
						ret += ((CcSeriesScatter*)m_Series[i])->m_Data[0][j];
						ret += ", ";
						ret += ((CcSeriesScatter*)m_Series[i])->m_Data[1][j];
						ret += ")";
						
						pointfound = true;

						point->y = m_YGapTop;
					}
				}
			}
		}
	}
	return ret;
}
	
// add a series to the graph
void CcPlotScatter::AddSeries(int type)
{
	// need to re-allocate memory for the series list, transfer pointers over, and delete old memory
	CcSeries** temp = new CcSeries*[m_NumberOfSeries + 1];
	for(int i=0; i<m_NumberOfSeries; i++)
	{
		temp[i] = m_Series[i];
	}

	temp[m_NumberOfSeries] = new CcSeriesScatter;
	temp[m_NumberOfSeries]->m_DrawStyle = type;
	temp[m_NumberOfSeries]->AllocateMemory(m_SeriesLength);

	delete [] m_Series;
	
	m_Series = temp;

	m_NumberOfSeries++;
}

// create the data series
void CcPlotScatter::CreateSeries(int numser, int* type)
{
	// create an array of pointers to the series
	m_Series = new CcSeries*[numser];
	m_NumberOfSeries = numser;

	// fill this array
	for(int i=0; i<numser; i++)
	{
		m_Series[i] = new CcSeriesScatter();
		m_Series[i]->m_DrawStyle = type[i];
	}
}

// allocate memory for the series
void CcPlotScatter::AllocateMemory(int length)
{
	m_SeriesLength = length;

	// allocate the data memory space here
	for(int i=0; i<m_NumberOfSeries; i++)
	{
		m_Series[i]->AllocateMemory(length);
	}
}

////////////////////////////////////////////////////////////////////////////////
//
// CSeriesScatter stuff
//
////////////////////////////////////////////////////////////////////////////////

CcSeriesScatter::CcSeriesScatter()
{
	m_Data[Axis_X]	= 0;
	m_Data[Axis_YL]	= 0;
	m_DrawStyle		= Plot_SeriesScatter;	// draw a scatter graph unless specified
}

// free allocated memory
CcSeriesScatter::~CcSeriesScatter()
{
	if(m_Data[Axis_X]) delete [] m_Data[Axis_X];
	if(m_Data[Axis_YL]) delete [] m_Data[Axis_YL];
	if(m_Label) delete [] m_Label;

	m_Data[Axis_X] = 0;
	m_Data[Axis_YL] = 0;
	m_Label = 0;
}

// parse any series input (not used at present)
Boolean CcSeriesScatter::ParseInput( CcTokenList * tokenList )
{
    CcSeries::ParseInput( tokenList );

    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kPlotClass) )
        {
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    return true;
}

// allocate memory for this series' data
void CcSeriesScatter::AllocateMemory(int length)
{
	m_Data[Axis_X] = new float[length];
	m_Data[Axis_YL] = new float[length];
	m_Label = new CcString[length];

	for(int j=0; j<length; j++)
	{
		m_Data[Axis_X][j] = 0;
		m_Data[Axis_YL][j] = 0;
		m_Label[j] = "";
	}
}
