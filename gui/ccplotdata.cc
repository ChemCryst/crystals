////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotData is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
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
#include    "cclist.h"
#include    "ccplotdata.h"
#include    "ccplotbar.h"
#include    "ccplotscatter.h"
#include    "crplot.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"
#include	"ccpoint.h"
#include	"ccstring.h"
#include	<math.h>

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif

CcList CcPlotData::sm_PlotList;
CcPlotData* CcPlotData::sm_CurrentPlotData = nil;


CcPlotData::CcPlotData( )
{
	attachedPlot = nil;
	mSelfInitialised = false;
	sm_PlotList.AddItem(this);

	m_AxesOK = false;
	m_Series = 0;
	m_SeriesLength = 0;
	m_NextItem = 0;
	
	m_XGapRight = 160;		// horizontal gap between graph and edge of window
	m_XGapLeft = 200;			//		nb: leave enough space for labels
	m_YGapTop = 200;			// and the vertical gap
	m_YGapBottom = 300;		//		nb: lots of space for labels

	// initialise the colours
   // nb only for 6 series currently
   for(int i=0; i<6; i++)
   {
	   m_Colour[0][i] = 0;
	   m_Colour[1][i] = 0;
	   m_Colour[2][i] = 0;
   }

   m_Colour[0][0] = 255;
   m_Colour[2][1] = 255;
   m_Colour[1][2] = 255;
   m_Colour[0][3] = 255;
   m_Colour[1][3] = 255;
   m_Colour[0][4] = 255;
   m_Colour[2][4] = 255;
   m_Colour[1][5] = 255;
   m_Colour[2][5] = 255;
}

CcPlotData::~CcPlotData()
{
// Remove from list of plotdata objects:
	sm_PlotList.FindItem(this);
	sm_PlotList.RemoveItem();

	if(m_Series) delete [] m_Series;
	m_Series = 0;
}

//This static function reads the name of the plotdata and
//creates the correct derived type of plotdata.
CcPlotData * CcPlotData::CreatePlotData( CcTokenList * tokenList )
{
	CcPlotData* retval = nil;
	CcString dataname = tokenList->GetToken();
	switch ( tokenList->GetDescriptor(kPlotClass) )
	{
	   case kTPlotBarGraph:
	   {
		   tokenList->GetToken(); // Remove that token!
		   retval = new CcPlotBar();
		   retval->mName = dataname;
		   break;
	   }
	   case kTPlotScatter:
	   {
		   tokenList->GetToken(); // Remove that token!
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
Boolean CcPlotData::ParseInput( CcTokenList * tokenList )
{
	Boolean hasTokenForMe = true;
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kPlotClass) )
		{
			// get the window name to attach this plot to.
			case kTPlotAttach:
			{
				tokenList->GetToken(); // Remove that token!
				CcString chartName = tokenList->GetToken();
				attachedPlot = (CrPlot*)(CcController::theController)->FindObject(chartName);
				if(attachedPlot != nil)
					attachedPlot->Attach(this);
				break;
			}

			// display all of this graph
			case kTPlotShow:
			{
				tokenList->GetToken(); // Remove that token!
				this->DrawView();
				break;
			}
			
			// use linear axis scaling
			case kTPlotLinear:
			{
				tokenList->GetToken();
				m_Axes.m_AxisLog[Axis_X] = false;
				m_Axes.m_AxisLog[Axis_Y] = false;
				break;
			}

			// use log axis scaling (for y axis only...)
			case kTPlotLog:
			{
				tokenList->GetToken();
				m_Axes.m_AxisLog[Axis_X] = false;	// x axis always linear
				m_Axes.m_AxisLog[Axis_Y] = true;	// set y axis to be logarithmic (sp?)
				break;
			}

			// set the graph title
			case kTPlotTitle:
			{
				tokenList->GetToken();
				m_Axes.m_PlotTitle = tokenList->GetToken();
				break;
			}

			// use automatic axis scaling: 0 -> max if all +ve, min -> max if not.
			case kTPlotAuto:		// this mode sets y axis range to 0 < y < ymax
			{
				tokenList->GetToken();
				m_Axes.m_AxisScaleType = Plot_AxisAuto;
				break;
			}

			// uses axis scaling of min->max always.
			case kTPlotSpan:		// this mode sets y axis range to ymin < y < ymax
			{
				tokenList->GetToken();
				m_Axes.m_AxisScaleType = Plot_AxisSpan;
				break;
			}

			// lets the user specify an axis range.
			case kTPlotZoom:
			{
				tokenList->GetToken();
				m_Axes.m_AxisScaleType = Plot_AxisZoom;
				
				// next four tokens should be: xmin, xmax, ymin, ymax
				float xmin = atof(tokenList->GetToken().ToCString());
				float xmax = atof(tokenList->GetToken().ToCString());
				float ymin = atof(tokenList->GetToken().ToCString());
				float ymax = atof(tokenList->GetToken().ToCString());

				// check bounds: if min/max pair both zero don't change limits for that axis
				if(ymin != 0 && ymax != 0)
				{
					m_Axes.m_AxisMin[Axis_Y] = ymin;
					m_Axes.m_AxisMax[Axis_Y] = ymax;
				}
				if(xmin != 0 && xmax != 0)
				{
					m_Axes.m_AxisMin[Axis_X] = xmin;
					m_Axes.m_AxisMax[Axis_X] = xmax;
				}

				// specify that axes need rescaling
				m_AxesOK = false;

				break;
			}

			// set the number of data series
			case kTPlotNSeries:				// number of series specified
			{
			    tokenList->GetToken();		// "NSERIES"
			    CcString nseries = tokenList->GetToken();		// number
				int num = atoi(nseries.ToCString());

				// now use PeekToken to look at the next token in the list. If it is a valid type,
				//		then grab it, and set the series types
				int *types = new int[num];
				for(int i=0; i<num; i++)
				{
					if(FindSeriesType(tokenList->PeekToken()) != -1)
						types[i] = FindSeriesType(tokenList->GetToken());
					else types[i] = Plot_SeriesBar;
				}

				// create series here, 
				CreateSeries(num, types);

				break;
			}

			// set the number of data items in each series (semi-optional, since series is extended if necessary)
		    case kTPlotLength:				// length of series specified
			{
			    tokenList->GetToken();
			    CcString plotlength = tokenList->GetToken();
			    int length = atoi(plotlength.ToCString());

				// allocate space for the data
				AllocateMemory(length);

				break;
			}

			// set the series names, for a key (not used yet)
			case kTPlotSeriesName:
			{
				tokenList->GetToken();

				for(int i=0; i<m_NumberOfSeries; i++)
				{
					m_Series[i]->m_SeriesName = tokenList->GetToken();
				}
				break;
			}

			// set the x-axis label
			case kTPlotXTitle:
			{
				tokenList->GetToken();
				m_Axes.m_XTitle = tokenList->GetToken();
				break;
			}

			// set the y axis label
			case kTPlotYTitle:
			{
				tokenList->GetToken();
				m_Axes.m_YTitle = tokenList->GetToken();
				break;
			}

			// set the drawing style for a series
			case kTPlotSeriesType:
			{
				CcString name;						// the series name (if given)
				CcString textstyle;					// the drawing style, in text
				int style = Plot_SeriesBar;			// the style in Plot_SeriesX form
				bool seriesfound = false;	
				int series = 0;
		
				tokenList->GetToken();				// 'SERIESTYPE'

				// first check that at least one series has a name...
				int numnames = 0;
				for(series=0; series<m_NumberOfSeries; series++)
				{
					if(!(m_Series[series]->m_SeriesName == ""))
						numnames++;
				}

				// if no series are named, set all series to this style
				if(numnames == 0)
				{
					style = FindSeriesType(tokenList->GetToken());

					for(int series=0; series<m_NumberOfSeries; series++)
						m_Series[series]->m_DrawStyle = style;
				}
				// otherwise search for the specified series
				else
				{
					name = tokenList->GetToken();		// the series name (NB: identify by number too?)
					style = FindSeriesType(tokenList->GetToken());	// the drawing style

					series = 0;					

					while(!seriesfound && series < m_NumberOfSeries)
					{
						if(m_Series[series]->m_SeriesName == name)	// compare the names
						{
							seriesfound = true;
							
							m_Series[series]->m_DrawStyle = style;
						}

						series++;
					}

					// if seriesfound is still false, series does not exist
					if(!seriesfound)
						LOGWARN("Specified series doesn't exist: " + name);
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

int CcPlotData::FindSeriesType(CcString textstyle)
{
	int style;

	if(textstyle == "BAR")
		style = Plot_SeriesBar;
	else if(textstyle == "SCATTER")
		style = Plot_SeriesScatter;
	else if(textstyle == "LINE")
		style = Plot_SeriesLine;
	else if(textstyle == "AREA")
		style = Plot_SeriesArea;
	else style = -1;	// no style selected	

	return style;
}

CcPlotData *  CcPlotData::FindObject( CcString Name )
{
	if ( Name == mName )
		return this;
	else
		return nil;
}

void CcPlotData::Clear()
{
	attachedPlot->Clear();
}

///////////////////////////////////////////
//
// The CcSeries stuff:                   
//
///////////////////////////////////////////


CcSeries::CcSeries()
{
}

CcSeries::~CcSeries()
{
}

// parse any input for this series
Boolean CcSeries::ParseInput( CcTokenList * tokenList )
{
	// nb: series class doesn't handle any messages
	  switch ( tokenList->GetDescriptor(kPlotClass) )
	  {
		default:
		{  
			return true; // Failed to initialise. Some sort of error.
			break; 
		}
	  }
	  
	return true;
}

///////////////////////////////////////////////////////////////////////////////////////////
//
//	The CcPlotAxes stuff
//
///////////////////////////////////////////////////////////////////////////////////////////

// set all variables to initial default values
CcPlotAxes::CcPlotAxes()
{
	m_Max[0] = 0;
	m_Max[1] = 0;
	m_Min[0] = 10000;
	m_Min[1] = 10000;

	m_AxisMax[0] = 0;
	m_AxisMin[0] = 10000;
	m_AxisMax[1] = 0;
	m_AxisMin[1] = 10000;

	m_Delta[0] = 0;
	m_Delta[1] = 0;

	m_NumDiv[0] = 0;
	m_NumDiv[1] = 0;

	m_AxisDivisions[0] = 0;
	m_AxisDivisions[1] = 0;

	m_AxisScaleType = Plot_AxisAuto; 
	m_AxisLog[0] = false;
	m_AxisLog[1] = false;

	m_Labels = 0;
}

// free any allocated memory
CcPlotAxes::~CcPlotAxes()
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

	if(m_Labels) delete [] m_Labels;
	m_Labels = 0;
}


// work out the division markers for the axes
Boolean CcPlotAxes::CalculateDivisions()
{
	Boolean tempx = false;
	Boolean tempy = false;

	// change axis limits if required
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

	// for bar graphs, the x axis is different. One division per data item.
	if(m_GraphType == Plot_GraphBar)
	{
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

		tempx = true;
	}
	// for scatter graphs calculate divisions for both axes
	else if(m_GraphType == Plot_GraphScatter)
	{
		if(m_AxisScaleType == Plot_AxisAuto)
		{
			if(m_Min[Axis_X] > 0)
				m_AxisMin[Axis_X] = 0;
			else m_AxisMin[Axis_X] = m_Min[Axis_X];

			m_AxisMax[Axis_X] = m_Max[Axis_X];
		}

		if(m_AxisLog[Axis_X]) tempx = CalculateLogDivisions(Axis_X);
		else tempx = CalculateLinearDivisions(Axis_X);
	}

	// now the y axis
	if(m_AxisLog[Axis_Y]) tempy = CalculateLogDivisions(Axis_Y);
	else tempy = CalculateLinearDivisions(Axis_Y);

	return (tempx & tempy);
}

// calculate a linear set of axis divisions, make them fall on 'nice' numbers with sensible delta
Boolean CcPlotAxes::CalculateLinearDivisions(int axis)
{
	// initial delta value - too high? Can be reduced if any lower is needed, but use either ...1, ...2 or ...5
	m_Delta[axis] = 0.001;
	m_NumDiv[axis] = (m_AxisMax[axis] - m_AxisMin[axis]) / m_Delta[axis];	// initial number of divisions based on delta

	int numinc = 0;							// number of increments of delta

	// increment the delta, so reducing the number of divisions needed.
	// x2, x2.5, x2, x2, x2.5, x2, x2 etc
	// this gives 'nice' delta values - 1,2,5,10,20,50,100,200,500,1000 etc.
	while(m_NumDiv[axis] > 15)				// max 15 divisions
	{
		if((numinc+2)%3 == 0)				// every third increment is x2.5
		{
			m_Delta[axis] *= 2.5f;
		}
		else m_Delta[axis] *= 2;			// others are x2

		numinc++;
		m_NumDiv[axis] = (m_AxisMax[axis] - m_AxisMin[axis]) / m_Delta[axis];// find new number of divisions
	}

	// move all divisions such that they are multiples of the delta
	bool smallerthan = false;
	float absdelta = m_Delta[axis];
	float absmin = m_AxisMin[axis];
	if(absmin < 0) absmin = -absmin;

	while(!smallerthan)
	{
		if(absdelta < absmin)
			absdelta += m_Delta[axis];
		else smallerthan = true;
	}

	if(m_AxisMin[axis] < 0)	m_AxisMin[axis] = -absdelta;

//	// adjust modulus so there are enough divisions
//	if(m_AxisScaleType != Plot_AxisZoom && m_AxisMin[axis] < 0) modulus += m_Delta[axis];

	// make sure there are enough divisions
	if(m_AxisScaleType != Plot_AxisZoom)
		while (m_AxisMin[axis] + (m_NumDiv[axis] * m_Delta[axis]) < m_Max[axis]) 
			(m_NumDiv[axis])++;

	// allocate space for data 
	m_AxisDivisions[axis] = new float[m_NumDiv[axis]+1];

	// loop through points, fill with data
	for(int i=0; i<(m_NumDiv[axis]+1); i++)
	{
		m_AxisDivisions[axis][i] = m_AxisMin[axis] + m_Delta[axis]*i;

		if(m_AxisDivisions[axis][i] > -0.0001 && m_AxisDivisions[axis][i] < 0.0001)
			m_AxisDivisions[axis][i] = 0;
	}

	m_AxisMin[axis] = m_AxisDivisions[axis][0];
	m_AxisMax[axis] = m_AxisDivisions[axis][m_NumDiv[axis]];

	return true;
}

// now the division calculations for a log axis.
// Does linear scaling of the log values, then logs all the labels.
Boolean CcPlotAxes::CalculateLogDivisions(int axis)
{
	// now do log y axis
	m_Delta[axis] = 1;
	if(m_AxisMin[axis] <= 0) m_AxisMin[axis] = 1;

	m_NumDiv[axis] = (log10(m_AxisMax[axis]) - log10(m_AxisMin[axis])) / m_Delta[axis];	// initial number of divisions based on delta

	int numinc = 0;									// number of increments of delta

	// increment the delta, so reducing the number of divisions needed.
	// x2, x2.5, x2, x2, x2.5, x2, x2 etc
	// this gives 'nice' delta values - 1,2,5,10,20,50,100,200,500,1000 etc.
	while(m_NumDiv[axis] > 15)				// max 15 divisions
	{
		if((numinc+2)%3 == 0)						// ever[axis] third increment is x2.5
		{
			m_Delta[axis] *= 2.5f;
		}
		else m_Delta[axis] *= 2;						// others are x2

		numinc++;
		m_NumDiv[axis] = (log10(m_AxisMax[axis]) - log10(m_AxisMin[axis])) / m_Delta[axis];// find new number of divisions
	}

	// move all divisions such that they are multiples of the delta
	bool smallerthan = false;
	float absdelta = m_Delta[axis];
	float absmin = m_AxisMin[axis];
	if(absmin < 0) absmin = -absmin;

	while(!smallerthan)
	{
		if(absdelta < absmin)
			absdelta += m_Delta[axis];
		else smallerthan = true;
	}

	if(m_AxisMin[axis] < 0)	m_AxisMin[axis] = -absdelta;

	// make sure there are enough divisions
	while((log10(m_AxisMin[axis]) + (m_NumDiv[axis] * m_Delta[axis]) < log10(m_Max[axis])))
		m_NumDiv[axis]++;

	// allocate space for data (changed to new)
	m_AxisDivisions[axis] = new float[m_NumDiv[axis]+1];

	// loop through points, fill with data
	for(int i=0; i<(m_NumDiv[axis]+1); i++)
	{
		m_AxisDivisions[axis][i] = pow(10,(log10(m_AxisMin[axis]) + m_Delta[axis]*i));

		if(m_AxisDivisions[axis][i] > -0.000001 && m_AxisDivisions[axis][i] < 0.000001)
			m_AxisDivisions[axis][i] = 0;
	}

	m_AxisMin[axis] = log10(m_AxisDivisions[axis][0]);
	m_AxisMax[axis] = log10(m_AxisDivisions[axis][m_NumDiv[axis]]);

	return true;
}

// check a data item, change axis range if necessary
void CcPlotAxes::CheckData(int axis, float data)
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

// draw the bits of the graph common to all graph types
void CcPlotAxes::DrawAxes(CrPlot* attachedPlot)
{
	if(attachedPlot)
	{
		// setup variables for scaling / positioning of graphs
		int xgapright = 160;		// horizontal gap between graph and edge of window
		int xgapleft = 200;			//		nb: leave enough space for labels
		int ygaptop = 200;			// and the vertical gap
		int ygapbottom = 300;		//		nb: lots of space for labels

		// if graph has a title, make top gap bigger
		if(!(m_PlotTitle == ""))
			ygaptop = 300;

		// if x axis has a title make the bottom gap bigger
		if(!(m_XTitle == ""))
			ygapbottom = 500;

		// if y axis has a title make the lhs gap bigger
		if(!(m_YTitle == ""))
			xgapleft = 300;

		// variables used for loops
		int i=0;
		int j=0;

		// temp string for text label
		CcString ylabel;
		
		// gap between division markers on x and y axes
		int xdivoffset = (2400-xgapleft-xgapright) / (m_NumDiv[Axis_X]);
		int ydivoffset = (2400-ygaptop-ygapbottom) / (m_NumDiv[Axis_Y]);			

		// axis dimensions after rounding
		int axisheight = ydivoffset * (m_NumDiv[Axis_Y]);				
		int axiswidth = xdivoffset * (m_NumDiv[Axis_X]);
		
		// take the axis height, work out where zero is...
		int xorigin = 2400 - xgapleft + ((axiswidth * m_Min[Axis_X]) / (m_Max[Axis_X] - m_Min[Axis_X]));
		int yorigin = 2400 - ygapbottom + (axisheight * (m_AxisMin[Axis_Y] / (m_AxisMax[Axis_Y] - m_AxisMin[Axis_Y])));

		//this is the value of y at the origin (may be non-zero for span-graphs)
		float yoriginvalue = 0;
		if(m_AxisScaleType == Plot_AxisSpan && m_AxisMin[Axis_Y] > 0) 
		{
			yorigin = 2400 - ygapbottom;
			yoriginvalue = m_AxisDivisions[Axis_Y][0];
		}

		// now draw the axes in black: overwrite bars
		attachedPlot->SetColour(0,0,0);
		attachedPlot->DrawLine(3, xgapleft, 2400-ygapbottom-axisheight, xgapleft, 2400-ygapbottom);
		attachedPlot->DrawLine(3, xgapleft, yorigin, 2400-xgapright, yorigin);

		// the following tries to find an optimal font size
		int fontsize = 12;			// 14 is the max 
		CcPoint maxangletextextent;
		CcPoint maxhorizontaltextextent;
		CcPoint textextent;
		Boolean textOK = false;
		Boolean smalltext = false;	// true if text gets too small

		if(m_GraphType == Plot_GraphBar)
		{
			while(!textOK && !smalltext)
			{
				// find the maximum screen area occupied by a label at this font size
				for(i=0; i<m_NumDiv[Axis_X]; i++)
				{
					textextent = attachedPlot->GetTextArea(fontsize, m_Labels[i], 0);
					if(textextent.x > maxhorizontaltextextent.x) maxhorizontaltextextent.x = textextent.x;
					if(textextent.y > maxhorizontaltextextent.y) maxhorizontaltextextent.y = textextent.y;
				}

				// if the text fits at this size, draw normally
				if((maxhorizontaltextextent.x < xdivoffset))
				{
					for(i=0; i<m_NumDiv[Axis_X];i++)
					{
						attachedPlot->DrawText(xgapleft+(i+0.5)*xdivoffset,2400-ygapbottom, m_Labels[i].ToCString(), TEXT_HCENTRE|TEXT_TOP, fontsize);
					}
					textOK = true;
				}
				// otherwise try at an angle
				else
				{
					// find the maximum screen area occupied by a label at this font size
					maxangletextextent.x = 0;
					maxangletextextent.y = 0;
					for(i=0; i<m_NumDiv[Axis_X]; i++)
					{
						textextent = attachedPlot->GetTextArea(fontsize, m_Labels[i], TEXT_ANGLE);
						if(textextent.x > maxangletextextent.x) maxangletextextent.x = textextent.x;
						if(textextent.y > maxangletextextent.y) maxangletextextent.y = textextent.y;
					}
					// if this angled text fits, draw it
					if(maxangletextextent.y < 3*ygapbottom/4 && maxhorizontaltextextent.y < xdivoffset*2)
					{
						for(i=0; i<m_NumDiv[Axis_X]; i++)
						{
							attachedPlot->DrawText(xgapleft+(i+0.5)*xdivoffset, 2400-ygapbottom, m_Labels[i].ToCString(), TEXT_ANGLE, fontsize);
						}
						textOK = true;
					}
				}
				// if the text didn't fit, try again with smaller font
				fontsize--;
				if (fontsize <= 6) smalltext = true; //Bail out.
			}
		}
		// for scatter graphs use horizontal text always
		else if(m_GraphType == Plot_GraphScatter)
		{
			for(i=0; i<m_NumDiv[Axis_X]+1; i++)
			{
				ylabel = m_AxisDivisions[Axis_X][i];
				attachedPlot->DrawText(xgapleft+i*xdivoffset, 2400-ygapbottom, ylabel.ToCString(), TEXT_TOP|TEXT_HCENTRE, fontsize);
			}
		}
		
		// if the above methods couldn't fit the text without making it too small, plot every other label
		if(smalltext)
		{
			fontsize = 8;

			for(i=0; i<m_NumDiv[Axis_X]; i+=2)
			{
				attachedPlot->DrawText(xgapleft+(i+0.5)*xdivoffset, 2400-ygapbottom, m_Labels[i].ToCString(), TEXT_ANGLE, fontsize);
			}
		}

		fontsize = 12;

		// now draw the y axis labels, again without worrying about overlap
		for(i=0; i<m_NumDiv[Axis_Y]+1; i++)
		{
			ylabel = m_AxisDivisions[Axis_Y][i];
			attachedPlot->DrawText(xgapleft-10, (2400-ygapbottom)-i*ydivoffset, ylabel.ToCString(), TEXT_VCENTRE|TEXT_RIGHT, fontsize);
		}		
		
		// draw marker lines in grey
		attachedPlot->SetColour(150,150,150);

		// now loop through the divisions on each axis, drawing each one and putting text labels in...
		// first x axis:
		for(i=0; i<m_NumDiv[Axis_X]; i++)
		{
			attachedPlot->DrawLine(1, xgapleft+i*xdivoffset, ygaptop, xgapleft + i*xdivoffset, 2400-ygapbottom );
		}
	
		// and the y axis
		for(i=0; i<m_NumDiv[Axis_Y]+1; i++)
		{
			attachedPlot->DrawLine(1, xgapleft, (2400-ygapbottom)-i*ydivoffset, 2400-xgapright, (2400-ygapbottom)-i*ydivoffset);
		}
		
		// write the labels for each axis, and the graph title
		attachedPlot->DrawText(1200, ygaptop/2, m_PlotTitle.ToCString(), TEXT_VCENTRE|TEXT_HCENTRE|TEXT_BOLD, 20);
		attachedPlot->DrawText(1200, 2400-ygapbottom/6, m_XTitle.ToCString(), TEXT_HCENTRE|TEXT_BOTTOM, 16);
		attachedPlot->DrawText(xgapleft/6, 1200, m_YTitle.ToCString(), TEXT_VERTICAL, 16);
	}
}