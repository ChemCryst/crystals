////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cpp
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotScatter is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
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

CcPlotScatter::CcPlotScatter( )
{
	m_Series = (CcSeriesScatter*)new(CcSeriesScatter);
	m_Axes = (CcPlotAxesScatter*)new(CcPlotAxesScatter);
}

CcPlotScatter::~CcPlotScatter()
{
}

Boolean CcPlotScatter::ParseInput( CcTokenList * tokenList )
{
    CcPlotData::ParseInput( tokenList );

    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kPlotClass) )
        {
			case kTPlotData:
			{
				tokenList->GetToken(); // "DATA", then next two tokens are an x,y pair

				CcString ndata;

				// check there is enough space for this data item
				if(m_Series->m_Next >= m_Series->m_Length)
				{
					LOGWARN("Series length needs extending: reallocating memory");

					float **   tempdata[2];
					tempdata[Axis_X] = new float*[m_Series->m_NumberOfSeries];
					tempdata[Axis_Y] = new float*[m_Series->m_NumberOfSeries];
					
					for(int i=0; i< m_Series->m_NumberOfSeries; i++)
					{
						tempdata[Axis_X][i] = new float[m_Series->m_Length * 1.5];
						tempdata[Axis_Y][i] = new float[m_Series->m_Length * 1.5];

						for(int j=0; j<m_Series->m_Length; j++)
						{
							tempdata[Axis_X][i][j] = ((CcSeriesScatter*)m_Series)->m_Data[Axis_X][i][j];
							tempdata[Axis_Y][i][j] = ((CcSeriesScatter*)m_Series)->m_Data[Axis_Y][i][j];
						}
						delete ((CcSeriesScatter*)m_Series)->m_Data[Axis_X][i];
						delete ((CcSeriesScatter*)m_Series)->m_Data[Axis_Y][i];
					}

					// free up the previously allocated memory
					delete (((CcSeriesScatter*)m_Series)->m_Data[Axis_X]);
					delete (((CcSeriesScatter*)m_Series)->m_Data[Axis_Y]);

					((CcSeriesScatter*)m_Series)->m_Data[Axis_X] = tempdata[Axis_X];
					((CcSeriesScatter*)m_Series)->m_Data[Axis_Y] = tempdata[Axis_Y];
					((CcSeriesScatter*)m_Series)->m_Length *= 1.5;
				}

				for(int i=0; i< (m_Series->m_NumberOfSeries); i++)
				{
					for(int j=0; j<2; j++)
					{
						// now get the data
						ndata = tokenList->GetToken();
						float tempdata = atof(ndata.ToCString());

						((CcPlotAxesScatter*)m_Axes)->CheckData(j, tempdata);			// changes axis range if necessary
		
						if(((CcPlotAxesScatter*)m_Axes)->m_AxisLog[j])
						{
							if(tempdata <= 0)
							{
								LOGWARN("Negative data passed to a LOG plot...");
							}
							else tempdata = log10(tempdata);
						}

						// and copy this to m_Series->m_Data[i][n]
						((CcSeriesScatter*)m_Series)->m_Data[j][i][m_Series->m_Next] = tempdata;
					}
				}
				m_Series->m_Next++;		// make sure next label / data pair goes into the next slot

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

void CcPlotScatter::DrawView()
{
    if(attachedPlot)
    {
        //
       //  DRAW THE GRAPH HERE!
      //

		// setup variables for scaling / positioning of graphs
		int xgap = 200;		// horizontal gap between graph and edge of window
		int ygap = 400;		// and the vertical gap

		int i=0;
		int j=0;

		// check the axis divisions have been calculated
		if(!m_AxesOK) m_AxesOK = m_Axes->CalculateDivisions();
		
		int xdivoffset = (2400-2*xgap) / (m_Axes->m_NumDiv[Axis_X]);			// gap between division markers on x axis
		int ydivoffset = (2400-2*ygap) / (m_Axes->m_NumDiv[Axis_Y]);			// and y

		int axisheight = ydivoffset * (m_Axes->m_NumDiv[Axis_Y]);
		int axiswidth = xdivoffset * (m_Axes->m_NumDiv[Axis_X]);
		
		int xseroffset = xdivoffset / m_Series->m_NumberOfSeries;			// offset if more than one series

		// take the axis height, work out where zero is...
		int xorigin = xgap + (axiswidth * (m_Axes->m_Min[Axis_X] / (m_Axes->m_Max[Axis_X] - m_Axes->m_Min[Axis_X])));
		int yorigin = 2400 - ygap + (axisheight * (m_Axes->m_AxisMin[Axis_Y] / (m_Axes->m_AxisMax[Axis_Y] - m_Axes->m_AxisMin[Axis_Y])));

		//this is the value of y at the origin (may be non-zero for span-graphs)
		float yoriginvalue = 0;

		if(m_Axes->m_AxisScaleType == Plot_AxisSpan && m_Axes->m_AxisMin[Axis_Y] > 0) 
		{
			yorigin = 2400 - ygap;
			yoriginvalue = m_Axes->m_AxisDivisions[Axis_Y][0];
		}

		// draw a grey background
		attachedPlot->SetColour(200,200,200);
		attachedPlot->DrawRect(xgap, ygap, 2400-xgap, 2400-ygap, true);
		
		// now loop through the data items, drawing each one
		// if there are 'm_Next' data items, each will use 2200/m_Next as an offset
		// NB draw data bars FIRST, so axes / markers are always visible
		int offset = (2400-2*xgap) / m_Series->m_Next;
		xseroffset = offset / m_Series->m_NumberOfSeries;
		int x, y;

		// loop first through the series
		for(j=0; j<m_Series->m_NumberOfSeries; j++)
		{
			// set to series colour
			attachedPlot->SetColour(m_Series->m_Colour[0][j],m_Series->m_Colour[1][j],m_Series->m_Colour[2][j]);	

			// loop through the data members of this series
			for(i=0; i<m_Series->m_Next; i++)
			{
				x = xorigin + (axiswidth * ((((CcSeriesScatter*)m_Series)->m_Data[Axis_X][j][i]) / (m_Axes->m_AxisMax[Axis_X] - m_Axes->m_AxisMin[Axis_X])));
				y = yorigin - (axisheight * ((((CcSeriesScatter*)m_Series)->m_Data[Axis_Y][j][i] - yoriginvalue) / (m_Axes->m_AxisMax[Axis_Y] - m_Axes->m_AxisMin[Axis_Y])));
				attachedPlot->DrawLine(1, x-15, y-15, x+15, y+15);
				attachedPlot->DrawLine(1, x-15, y+15, x+15, y-15);
			}
		}

		// now draw the axes in black: overwrite bars
		attachedPlot->SetColour(0,0,0);
		attachedPlot->DrawLine(3, xgap, 2400-ygap-axisheight, xgap, 2400-ygap);
		attachedPlot->DrawLine(3, xgap, yorigin, 2400-xgap, yorigin);


		int fontsize = 14;
		CcPoint maxtextextent;
		CcPoint textextent;
		Boolean textOK = false;

		// temp string for text label
		CcString label;

		for(i=0; i<m_Axes->m_NumDiv[Axis_X]+1; i++)
		{
			label = m_Axes->m_AxisDivisions[Axis_X][i];
			attachedPlot->DrawText(xgap+i*xdivoffset, yorigin, label.ToCString(), TEXT_TOP|TEXT_HCENTRE, fontsize);
		}

		for(i=0; i<m_Axes->m_NumDiv[Axis_Y]+1; i++)
		{
			label = m_Axes->m_AxisDivisions[Axis_Y][i];
			attachedPlot->DrawText(xgap-10, (2400-ygap)-i*ydivoffset, label.ToCString(), TEXT_VCENTRE|TEXT_RIGHT, fontsize);
		}		
		
		// draw marker lines in grey
		attachedPlot->SetColour(150,150,150);
		// now loop through the divisions on each axis, drawing each one and putting text labels in...
		// first x axis:
		for(i=0; i<m_Axes->m_NumDiv[Axis_X]+1; i++)
		{
			attachedPlot->DrawLine(1, xgap+i*xdivoffset, ygap, xgap + i*xdivoffset, 2400-ygap);
		}
		// and the y axis
		for(i=0; i<m_Axes->m_NumDiv[Axis_Y]+1; i++)
		{
			attachedPlot->DrawLine(1, xgap, (2400-ygap)-i*ydivoffset, 2400-xgap, (2400-ygap)-i*ydivoffset);
		}
		
		// write the labels for each axis, and the graph title
		attachedPlot->DrawText(1200, ygap/2, m_PlotTitle.ToCString(), TEXT_VCENTRE|TEXT_HCENTRE|TEXT_BOLD, 20);
		attachedPlot->DrawText(1200, 2400-ygap/4, m_XTitle.ToCString(), TEXT_HCENTRE|TEXT_BOTTOM, 16);
		attachedPlot->DrawText(xgap/4, 1200, m_YTitle.ToCString(), TEXT_VERTICAL, 16);

		// display all the above
		attachedPlot->Display();
    }
}

void CcPlotScatter::Clear()
{
    attachedPlot->Clear();
}

////////////////////////////////////////////////////////////////////////////////
//
// CSeriesScatter stuff
//
////////////////////////////////////////////////////////////////////////////////

CcSeriesScatter::CcSeriesScatter()
{
	m_Data[Axis_X] = 0;
	m_Data[Axis_Y] = 0;
	m_NumberOfSeries = 0;
}

CcSeriesScatter::~CcSeriesScatter()
{
	for(int i=0; i<m_NumberOfSeries; i++)
	{
		if(m_Data[Axis_X][i]) delete [] m_Data[Axis_X][i];
		if(m_Data[Axis_Y][i]) delete [] m_Data[Axis_Y][i];

		m_Data[Axis_X][i] = 0;
		m_Data[Axis_Y][i] = 0;

	}

	delete [] m_Data[Axis_X];
	delete [] m_Data[Axis_Y];

	m_Data[Axis_X] = 0;
	m_Data[Axis_Y] = 0;
}

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

void CcSeriesScatter::AllocateMemory(int length)
{
	// allocate data space for each series
	for(int i=0; i<m_NumberOfSeries; i++)
	{
		m_Data[Axis_X][i] = new float[length];
		m_Data[Axis_Y][i] = new float[length];

		for(int j=0; j<length; j++)
		{
			m_Data[Axis_X][i][j] = 0;
			m_Data[Axis_Y][i][j] = 0;
		}
	}
	m_Length = length;
}

void CcSeriesScatter::CreateSeries(int numser)
{
	m_NumberOfSeries = numser;

	m_Data[Axis_X] = new float*[numser];
	m_Data[Axis_Y] = new float*[numser];

	for(int i=0; i<numser; i++)
	{
		m_Data[Axis_X][i] = 0;
		m_Data[Axis_Y][i] = 0;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////
//
//	The CcPlotAxesScatter stuff
//
/////////////////////////////////////////////////////////////////////////////////////////////

CcPlotAxesScatter::CcPlotAxesScatter()
{
	m_AxisScaleType = Plot_AxisAuto;
}

CcPlotAxesScatter::~CcPlotAxesScatter()
{
	if(m_AxisDivisions[Axis_X])
	{
		delete [] m_AxisDivisions[Axis_X];
		m_AxisDivisions[Axis_X] = 0;
	}
	if(m_AxisDivisions[Axis_Y])
	{
		delete [] m_AxisDivisions[Axis_Y];
		m_AxisDivisions[Axis_Y] = 0;
	}
}


// work out the division markers for the axes
Boolean CcPlotAxesScatter::CalculateDivisions()
{
	if(m_AxisScaleType == Plot_AxisAuto)
	{
		if(m_Min[Axis_Y] > 0)
			m_AxisMin[Axis_Y] = 0;
		else m_AxisMin[Axis_Y] = m_Min[Axis_Y];

		if(m_Min[Axis_X] > 0)
			m_AxisMin[Axis_X] = 0;
		else m_AxisMin[Axis_X] = m_Min[Axis_X];

		m_AxisMax[Axis_Y] = m_Max[Axis_Y];
		m_AxisMax[Axis_X] = m_Max[Axis_X];
	}
	if(m_AxisScaleType == Plot_AxisSpan)
	{
		//m_AxisMin[Axis_Y] = m_Min[Axis_Y];
		//m_AxisMax[Axis_Y] = m_Max[Axis_Y];
	}
	if(m_AxisScaleType == Plot_AxisZoom)
	{}// leave things as they were.
	;

	Boolean tempx = false;
	Boolean tempy = false;

	if(m_AxisLog[Axis_X]) tempx = CalculateLogDivisions(Axis_X);
	else tempx = CalculateLinearDivisions(Axis_X);

	// now the y axis
	if(m_AxisLog[Axis_Y]) tempy = CalculateLogDivisions(Axis_Y);
	else tempy = CalculateLinearDivisions(Axis_Y);

	return (tempx & tempy);
}

// check a data item, change y axis range if necessary
void CcPlotAxesScatter::CheckData(int axis, float data)
{
	if(data > m_Max[axis]) m_Max[axis] = data;
	if(data < m_Min[axis]) m_Min[axis] = data;
	
	switch(m_AxisScaleType)
	{
		case Plot_AxisAuto:
		{
			if(data > m_AxisMax[axis]) m_AxisMax[axis] = data;
			break;
		}
		case Plot_AxisSpan:
		{
			if(data > m_AxisMax[axis])
				m_AxisMax[axis] = data;
			if(data < m_AxisMin[axis])
				m_AxisMin[axis] = data;
			break;
		}
		case Plot_AxisZoom:
		{
			// dont change the axis limits (already set)
			break;
		}
	}
}