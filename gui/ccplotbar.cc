////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CcPlotBar
////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:28

// $Log: not supported by cvs2svn $
// Revision 1.2  2001/11/12 16:24:28  ckpgroup
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
#include    "ccplotbar.h"
#include    "crplot.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"
#include	"ccpoint.h"

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif

CcPlotBar::CcPlotBar( )
{
	m_Series = new(CcSeriesBar);
	m_Axes = new(CcPlotAxesBar);
}

CcPlotBar::~CcPlotBar()
{
}


Boolean CcPlotBar::ParseInput( CcTokenList * tokenList )
{
	// first see if the command is for the parent class
    CcPlotData::ParseInput( tokenList );

    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kPlotClass) )
        {
			case kTPlotLabel:
			{
				// first token is LABEL - remove it
				tokenList->GetToken();
				
				// next is the label for the nth data item
				CcString nlabel = tokenList->GetToken();

				// check there is enough space for this string
				if(m_Series->m_Next >= m_Series->m_Length)
				{
					LOGWARN("Series length needs extending: reallocating memory");

					CcString* templabels = new CcString[m_Series->m_Length * 1.5];
					float **   tempdata = new float*[m_Series->m_NumberOfSeries];
					
					// this loops through the previous series, copying data to the new one
					for(int j=0; j<m_Series->m_Length; j++)		
					{
						templabels[j] = ((CcSeriesBar*)m_Series)->m_Labels[j].ToCString();
					}

					delete [] ((CcSeriesBar*)m_Series)->m_Labels;					
					((CcSeriesBar*)m_Series)->m_Labels = templabels;

					for(int i=0; i< m_Series->m_NumberOfSeries; i++)
					{
						tempdata[i] = new float[m_Series->m_Length * 1.5];

						for(j=0; j<m_Series->m_Length; j++)
						{
							tempdata[i][j] = ((CcSeriesBar*)m_Series)->m_Data[i][j];
						}
						delete ((CcSeriesBar*)m_Series)->m_Data[i];
					}

					// free up the previously allocated memory
					delete (((CcSeriesBar*)m_Series)->m_Data);

					((CcSeriesBar*)m_Series)->m_Data = tempdata;
					((CcSeriesBar*)m_Series)->m_Length *= 1.5;
				}
				// copy this to m_Series->m_Label[n]
				((CcSeriesBar*)m_Series)->m_Labels[m_Series->m_Next] = nlabel;

				break;
			}
			case kTPlotData:
			{
				// again ditch the DATA token
				tokenList->GetToken();

				for(int i=0; i< (m_Series->m_NumberOfSeries); i++)
				{
					// now get the data
					CcString ndata = tokenList->GetToken();
					float tempdata = atof(ndata.ToCString());

					((CcPlotAxesBar*)m_Axes)->CheckData(Axis_Y, tempdata);			// changes axis range if necessary
					if(((CcPlotAxesBar*)m_Axes)->m_AxisLog[Axis_Y])
					{
						if(tempdata <= 0)
						{
							LOGWARN("Negative data passed to a LOG plot...");
						}
						else tempdata = log10(tempdata);
					}

					// and copy this to m_Series->m_Data[i][n]
					((CcSeriesBar*)m_Series)->m_Data[i][m_Series->m_Next] = tempdata;
				}

				m_Series->m_Next++;		// make sure next label / data pair goes into the next slot
				
				// make sure the x axis knows how many items there are...
				if(m_Series->m_Next > m_Axes->m_Max[Axis_X]) m_Axes->m_Max[Axis_X]++;

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

void CcPlotBar::DrawView()
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
		int xorigin = 2400 - xgap + ((axiswidth * m_Axes->m_Min[Axis_X]) / (m_Axes->m_Max[Axis_X] - m_Axes->m_Min[Axis_X]));
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
		int x1,y1,x2,y2;

		// loop first through the series
		for(j=0; j<m_Series->m_NumberOfSeries; j++)
		{
			// set to series colour
			attachedPlot->SetColour(m_Series->m_Colour[0][j],m_Series->m_Colour[1][j],m_Series->m_Colour[2][j]);	

			// loop through the data members of this series
			for(i=0; i<m_Series->m_Next; i++)
			{
				x1 = xgap + i*offset + j*xseroffset + 5;
				x2 = x1 + xseroffset - 5;
				y1 = yorigin;
				y2 = yorigin - (axisheight * ((((CcSeriesBar*)m_Series)->m_Data[j][i] - yoriginvalue) / (m_Axes->m_AxisMax[Axis_Y] - m_Axes->m_AxisMin[Axis_Y])));

				attachedPlot->DrawRect(x1,y1,x2,y2, true);
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

		while(!textOK)
		{
			// find the maximum screen area occupied by a label at this font size
			for(i=0; i<m_Axes->m_NumDiv[Axis_X]; i++)
			{
				textextent = attachedPlot->GetTextArea(fontsize, ((CcSeriesBar*)m_Series)->m_Labels[i], 0);
				if(textextent.x > maxtextextent.x) maxtextextent.x = textextent.x;
				if(textextent.y > maxtextextent.y) maxtextextent.y = textextent.y;
			}

			if((maxtextextent.x < xdivoffset))
			{
				// draw normal text labels horizontally
				for(i=0; i<m_Axes->m_NumDiv[Axis_X];i++)
				{
					attachedPlot->DrawText(xgap+(i+0.5)*xdivoffset,yorigin, ((CcSeriesBar*)m_Series)->m_Labels[i].ToCString(), TEXT_HCENTRE|TEXT_TOP, fontsize);
				}
				textOK = true;
			}
			else
			{
				// draw angled text
				// find the maximum screen area occupied by a label at this font size
				maxtextextent.x = 0;
				maxtextextent.y = 0;
				for(i=0; i<m_Axes->m_NumDiv[Axis_X]; i++)
				{
					textextent = attachedPlot->GetTextArea(fontsize, ((CcSeriesBar*)m_Series)->m_Labels[i], TEXT_ANGLE);
					if(textextent.x > maxtextextent.x) maxtextextent.x = textextent.x;
					if(textextent.y > maxtextextent.y) maxtextextent.y = textextent.y;
				}
				if(maxtextextent.y < 3*ygap/4)
				{
					for(i=0; i<m_Axes->m_NumDiv[Axis_X]; i++)
					{
						attachedPlot->DrawText(xgap+(i+0.5)*xdivoffset, yorigin, ((CcSeriesBar*)m_Series)->m_Labels[i].ToCString(), TEXT_ANGLE, fontsize);
					}
					textOK = true;
				}
			}
			fontsize--;
		}

		// temp string for text label
		CcString ylabel;

		for(i=0; i<m_Axes->m_NumDiv[Axis_Y]+1; i++)
		{
			ylabel = m_Axes->m_AxisDivisions[Axis_Y][i];
			attachedPlot->DrawText(xgap-10, (2400-ygap)-i*ydivoffset, ylabel.ToCString(), TEXT_VCENTRE|TEXT_RIGHT, 14);//fontsize);
		}		
		
		// draw marker lines in grey
		attachedPlot->SetColour(150,150,150);
		// now loop through the divisions on each axis, drawing each one and putting text labels in...
		// first x axis:
		for(i=0; i<m_Axes->m_NumDiv[Axis_X]; i++)
		{
			attachedPlot->DrawLine(1, xgap+i*xdivoffset, ygap, xgap + i*xdivoffset, 2400-ygap );
		}
	
		// and the y axis
		for(i=0; i<m_Axes->m_NumDiv[Axis_Y]+1; i++)
		{
			attachedPlot->DrawLine(1, xgap, (2400-ygap)-i*ydivoffset, 2400-xgap, (2400-ygap)-i*ydivoffset);
		}
		
		// write the labels for each axis, and the graph title
		attachedPlot->DrawText(1200, ygap/2, m_PlotTitle.ToCString(), TEXT_VCENTRE|TEXT_HCENTRE|TEXT_BOLD, 20);//fontsize*1.5);
		attachedPlot->DrawText(1200, 2400-ygap/4, m_XTitle.ToCString(), TEXT_HCENTRE|TEXT_BOTTOM, 16);
		attachedPlot->DrawText(xgap/4, 1200, m_YTitle.ToCString(), TEXT_VERTICAL, 16);

		// display all the above
		attachedPlot->Display();
    }
}

void CcPlotBar::Clear()
{
    attachedPlot->Clear();
}

////////////////////////////////////////////////////////////////////////////////////////////
//
//	The CcSeriesBar stuff
//
////////////////////////////////////////////////////////////////////////////////////////////

CcSeriesBar::CcSeriesBar()
{
	m_Labels = 0;
	m_Data	 = 0;
	m_SeriesName = 0;
	m_NumberOfSeries = 0;
}

CcSeriesBar::~CcSeriesBar()
{
	// loop through series, delete each one
	for(int i=0; i<m_NumberOfSeries; i++)
	{
		if(m_Data[i]) delete [] m_Data[i];
		m_Data[i] = 0;
	}

	delete [] m_Labels;
	m_Labels = 0;
	delete [] m_Data;
	m_Data = 0;
}

Boolean CcSeriesBar::ParseInput( CcTokenList * tokenList )
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

void CcSeriesBar::AllocateMemory(int length)
{
	// an array of pointers to CcString text labels
	m_Labels = new CcString[length];

	for(int j=0; j<length; j++)
		m_Labels[j] = "testing";

	// allocate a data space for each series
	for(int i=0; i< m_NumberOfSeries; i++)
	{
		m_Data[i] = new float[length];
		for(int j=0; j<length; j++)
		{
			m_Data[i][j] = 0;
		}
	}

	m_Length = length;
}

void CcSeriesBar::CreateSeries(int numser)
{
	m_NumberOfSeries = numser;

	m_Data	= new float*[numser];
	m_SeriesName = new CcString[numser];

	for(int i=0; i<numser; i++)
		m_Data[i] = 0;
}


////////////////////////////////////////////////////////////////////////////////////////////
//
//	The CcPlotAxesBar stuff
//
////////////////////////////////////////////////////////////////////////////////////////////

CcPlotAxesBar::CcPlotAxesBar()
{
	m_AxisScaleType = Plot_AxisAuto;
}

CcPlotAxesBar::~CcPlotAxesBar()
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
Boolean CcPlotAxesBar::CalculateDivisions()
{
	if(m_AxisScaleType == Plot_AxisAuto)
	{
		if((m_Min[Axis_Y] > 0) && !m_AxisLog[Axis_Y])
			m_AxisMin[Axis_Y] = 0;
		else m_AxisMin[Axis_Y] = m_Min[Axis_Y];

		m_AxisMax[Axis_Y] = m_Max[Axis_Y];
	}
	if(m_AxisScaleType == Plot_AxisSpan)
	{
		//m_AxisMin[Axis_Y] = m_Min[Axis_Y];
		//m_AxisMax[Axis_Y] = m_Max[Axis_Y];
	}
	if(m_AxisScaleType == Plot_AxisZoom)
	{}// leave things as they were.
	;

	// do the x axis first - one division per data item
	// x axis always linear so can do it here...
	m_Delta[Axis_X] = 1;
	m_NumDiv[Axis_X] = (int)m_Max[Axis_X];

	// allocate space for data
	m_AxisDivisions[Axis_X] = new float[m_NumDiv[Axis_X]];

	for(int i=0; i<m_NumDiv[Axis_X]; i++)
	{
		m_AxisDivisions[Axis_X][i] = i;
	}

	// now the y axis
	if(m_AxisLog[Axis_Y]) return CalculateLogDivisions(Axis_Y);
	else return CalculateLinearDivisions(Axis_Y);
}

// check a data item, change axis range if necessary
void CcPlotAxesBar::CheckData(int axis, float data)
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