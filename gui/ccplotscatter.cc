////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cpp
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotScatter is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
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
			// get a data item (x,y pair)
			case kTPlotData:
			{
				tokenList->GetToken(); // "DATA"

				CcString ndata;

				// check there is enough space for this data item
				if(m_NextItem >= m_SeriesLength)
				{
					LOGWARN("Series length needs extending: reallocating memory");

					float *  tempdata[2];
					
					for(int i=0; i< m_NumberOfSeries; i++)
					{
						// check series length is non-zero
						if(m_SeriesLength == 0) m_SeriesLength = 10;

						// allocate some new memory
						tempdata[Axis_X] = new float[m_SeriesLength * 1.5];
						tempdata[Axis_Y] = new float[m_SeriesLength * 1.5];

						// transfer the data across
						for(int j=0; j<m_SeriesLength; j++)
						{
							tempdata[Axis_X][j] = ((CcSeriesScatter*)m_Series[i])->m_Data[Axis_X][j];
							tempdata[Axis_Y][j] = ((CcSeriesScatter*)m_Series[i])->m_Data[Axis_Y][j];
						}

						// free the old memory
						delete ((CcSeriesScatter*)m_Series)->m_Data[Axis_X];
						delete ((CcSeriesScatter*)m_Series)->m_Data[Axis_Y];

						// and point to the new memory
						((CcSeriesScatter*)m_Series)->m_Data[Axis_X] = tempdata[Axis_X];
						((CcSeriesScatter*)m_Series)->m_Data[Axis_Y] = tempdata[Axis_Y];
					}

					// series has been extended...
					m_SeriesLength *= 1.5;
				}

				// now save the data (x1 y1 x2 y2 ...)
				for(int i=0; i< m_NumberOfSeries; i++)
				{
					for(int j=0; j<2; j++)
					{
						ndata = tokenList->GetToken();
						float tempdata = atof(ndata.ToCString());

						// change axis range if necessary
						m_Axes.CheckData(j, tempdata);
		
						if(m_Axes.m_AxisLog[j])
						{
							if(tempdata <= 0)
							{
								LOGWARN("Negative data passed to a LOG plot...");
							}
							else tempdata = log10(tempdata);
						}

						// and copy this to m_Series[i]->m_Data[j][n]
						((CcSeriesScatter*)m_Series[i])->m_Data[j][m_NextItem] = tempdata;
					}
				}
				m_NextItem++;		// make sure next label / data pair goes into the next slot

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
void CcPlotScatter::DrawView()
{
    if(attachedPlot)
    {
		// setup variables for scaling / positioning of graphs
		int xgapright = 160;		// horizontal gap between graph and edge of window
		int xgapleft = 200;			//		nb: leave enough space for labels
		int ygaptop = 200;			// and the vertical gap
		int ygapbottom = 300;		//		nb: lots of space for labels

		// if graph has a title, make top gap bigger
		if(!(m_Axes.m_PlotTitle == ""))
			ygaptop = 300;

		// if x axis has a title make the bottom gap bigger
		if(!(m_Axes.m_XTitle == ""))
			ygapbottom = 500;

		// if y axis has a title make the lhs gap bigger
		if(!(m_Axes.m_YTitle == ""))
			xgapleft = 300;

		// used in loops
		int i=0;
		int j=0;

		// check the axis divisions have been calculated
		if(!m_AxesOK) m_AxesOK = m_Axes.CalculateDivisions();
		
		// gap between division markers on x and y axes
		int xdivoffset = (2400-xgapleft-xgapright) / (m_Axes.m_NumDiv[Axis_X]);			
		int ydivoffset = (2400-ygaptop-ygapbottom) / (m_Axes.m_NumDiv[Axis_Y]);

		// axis dimensions after rounding
		int axisheight = ydivoffset * (m_Axes.m_NumDiv[Axis_Y]);
		int axiswidth = xdivoffset * (m_Axes.m_NumDiv[Axis_X]);
		
		// the offset along the x axis if more than one series
		int xseroffset = xdivoffset / m_NumberOfSeries;			

		// take the axis height, work out where zero is...
		int xorigin = xgapleft + (axiswidth * (m_Axes.m_AxisMin[Axis_X] / (m_Axes.m_AxisMax[Axis_X] - m_Axes.m_AxisMin[Axis_X])));
		int yorigin = 2400 - ygapbottom + (axisheight * (m_Axes.m_AxisMin[Axis_Y] / (m_Axes.m_AxisMax[Axis_Y] - m_Axes.m_AxisMin[Axis_Y])));

		//this is the value of y at the origin (may be non-zero for span-graphs)
		float yoriginvalue = 0;
		if(m_Axes.m_AxisScaleType == Plot_AxisSpan && m_Axes.m_AxisMin[Axis_Y] > 0) 
		{
			yorigin = 2400 - ygapbottom;
			yoriginvalue = m_Axes.m_AxisDivisions[Axis_Y][0];
		}
		
		// draw a grey background
		attachedPlot->SetColour(200,200,200);
		attachedPlot->DrawRect(xgapleft, ygaptop, 2400-xgapright, 2400-ygapbottom, true);

		// now loop through the data items, drawing each one
		// if there are 'm_Next' data items, each will use 2200/m_Next as an offset
		// NB draw data bars FIRST, so axes / markers are always visible
		int offset = (2400-xgapleft-xgapright) / m_NextItem;

		int x1, y1, x2, y2;

		// loop first through the series
		for(j=0; j<m_NumberOfSeries; j++)
		{
			// set to series colour
			attachedPlot->SetColour(m_Colour[0][j],m_Colour[1][j],m_Colour[2][j]);	

			switch(m_Series[j]->m_DrawStyle)
			{
				// draw this data series as a scatter graph
				case Plot_SeriesScatter:
				{
					// loop through the data members of this series
					for(i=0; i<m_NextItem; i++)
					{
						x1 = xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i]) / (m_Axes.m_AxisMax[Axis_X] - m_Axes.m_AxisMin[Axis_X])));
						y1 = yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_Y][i] - yoriginvalue) / (m_Axes.m_AxisMax[Axis_Y] - m_Axes.m_AxisMin[Axis_Y])));
						attachedPlot->DrawLine(2, x1-10, y1-10, x1+10, y1+10);
						attachedPlot->DrawLine(2, x1-10, y1+10, x1+10, y1-10);
					}
					break;
				}

				// draw this data series as a connected line of points
				case Plot_SeriesLine:
				{
					for(i=0; i<m_NextItem-1; i++)
					{
						x1 = xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i]) / (m_Axes.m_AxisMax[Axis_X] - m_Axes.m_AxisMin[Axis_X])));
						y1 = yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_Y][i] - yoriginvalue) / (m_Axes.m_AxisMax[Axis_Y] - m_Axes.m_AxisMin[Axis_Y])));
						x2 = xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i+1]) / (m_Axes.m_AxisMax[Axis_X] - m_Axes.m_AxisMin[Axis_X])));
						y2 = yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_Y][i+1] - yoriginvalue) / (m_Axes.m_AxisMax[Axis_Y] - m_Axes.m_AxisMin[Axis_Y])));

						attachedPlot->DrawLine(1,x1,y1,x2,y2);
					}
					break;
				}

				// draw this series as an area graph: line graph with area underneath filled
				case Plot_SeriesArea:
				{
					int vert[8];

					for(i=0; i<m_NextItem-1; i++)
					{
						vert[0] = xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i]) / (m_Axes.m_AxisMax[Axis_X] - m_Axes.m_AxisMin[Axis_X])));
						vert[1] = yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_Y][i] - yoriginvalue) / (m_Axes.m_AxisMax[Axis_Y] - m_Axes.m_AxisMin[Axis_Y])));
						vert[2] = xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_X][i+1]) / (m_Axes.m_AxisMax[Axis_X] - m_Axes.m_AxisMin[Axis_X])));
						vert[3] = yorigin - (axisheight * ((((CcSeriesScatter*)m_Series[j])->m_Data[Axis_Y][i+1] - yoriginvalue) / (m_Axes.m_AxisMax[Axis_Y] - m_Axes.m_AxisMin[Axis_Y])));

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
	m_Data[Axis_Y]	= 0;
	m_DrawStyle		= Plot_SeriesScatter;	// draw a scatter graph unless specified
}

// free allocated memory
CcSeriesScatter::~CcSeriesScatter()
{
	delete [] m_Data[Axis_X];
	delete [] m_Data[Axis_Y];

	m_Data[Axis_X] = 0;
	m_Data[Axis_Y] = 0;
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
	m_Data[Axis_Y] = new float[length];

	for(int j=0; j<length; j++)
	{
		m_Data[Axis_X][j] = 0;
		m_Data[Axis_Y][j] = 0;
	}
}
