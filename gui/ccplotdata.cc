////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotData is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
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

	m_DrawKey = false;
	m_AxesOK = false;
	m_Series = 0;
	m_SeriesLength = 0;
	m_CompleteSeries = 0;	// no data present
	m_NewSeriesNextItem = 0;
	m_NextItem = 0;
	m_NewSeries = false;
	m_CurrentSeries = -1;	// all series selected
	m_CurrentAxis = -1;		// also all axes selected
	
	m_XGapRight = 160;		// horizontal gap between graph and edge of window
	m_XGapLeft = 200;		//		nb: leave enough space for labels
	m_YGapTop = 200;		// and the vertical gap
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

   m_NumberOfSeries = 0;
}

CcPlotData::~CcPlotData()
{
// Remove from list of plotdata objects:
	sm_PlotList.FindItem(this);
	sm_PlotList.RemoveItem();

	if(m_Series) 
	{
		for(int i=0; i<m_NumberOfSeries; i++)
		{
			delete m_Series[i];
		}		
		delete [] m_Series;
		m_Series = 0;
	}
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

			// display this graph
			case kTPlotShow:
			{
				tokenList->GetToken(); // Remove that token!#
				this->DrawView();
				break;
			}
			
			// use linear axis scaling
			case kTPlotLinear:
			{
				tokenList->GetToken();	// "LINEAR"
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
				tokenList->GetToken();	// "LOG"
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
				tokenList->GetToken();
				m_Axes.m_PlotTitle = tokenList->GetToken();
				break;
			}

			// use automatic axis scaling: 0 -> max if all +ve, min -> max if not.
			case kTPlotAuto:		// this mode sets y axis range to 0 < y < ymax
			{
				tokenList->GetToken();	// "AUTO"
				if(m_CurrentAxis != -1)
					m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisAuto;
				else
				{
					for(int i=0; i<3; i++)
						m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisAuto;
				}
				break;
			}

			// uses axis scaling of min->max always.
			case kTPlotSpan:		// this mode sets y axis range to ymin < y < ymax
			{
				tokenList->GetToken();	// "SPAN"
		
				if(m_CurrentAxis != -1)
					m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisSpan;
				else
				{
					for(int i=0; i<3; i++)
						m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisSpan;
				}
				break;
			}

			// lets the user specify an axis range.
			case kTPlotZoom:
			{
				tokenList->GetToken();	//"ZOOM"

				// next two tokens should be: min, max
				float min = (float)atof(tokenList->GetToken().ToCString());
				float max = (float)atof(tokenList->GetToken().ToCString());

				if(m_CurrentAxis != -1)
				{
					m_Axes.m_AxisData[m_CurrentAxis].m_AxisScaleType = Plot_AxisSpan;

					m_Axes.m_AxisData[m_CurrentAxis].m_AxisMin = min;
					m_Axes.m_AxisData[m_CurrentAxis].m_AxisMax = max;
				}
				else
				{
					for(int i=0; i<3; i++)
					{
						m_Axes.m_AxisData[i].m_AxisScaleType = Plot_AxisSpan;

						m_Axes.m_AxisData[i].m_AxisMin = min;
						m_Axes.m_AxisData[i].m_AxisMax = max;
					}
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
				delete [] types;
		
				break;
			}

			// set the number of data items in each series (semi-optional, since series is extended if necessary)
		    case kTPlotLength:
			{
			    tokenList->GetToken();
			    CcString plotlength = tokenList->GetToken();
			    int length = atoi(plotlength.ToCString());

				// allocate space for the data
				AllocateMemory(length);

				break;
			}

			// set the series names, for the key
			case kTPlotSeriesName:
			{
				tokenList->GetToken();	// "NAME"

				CcString name = tokenList->GetToken();

				if(m_CurrentSeries != -1)
					m_Series[m_CurrentSeries]->m_SeriesName = name;
				else LOGWARN("Can't apply the same name to all series...");
				break;
			}

			// set the title of this axis (drawn next to it)
			case kTPlotAxisTitle:
			{
				tokenList->GetToken();	// "TITLE"	

				CcString title = tokenList->GetToken();

				if(m_CurrentAxis != -1)
					m_Axes.m_AxisData[m_CurrentAxis].m_Title = title;
				else LOGWARN("Same title applied to all axes...");
				break;
			}
				
			// set the drawing style for a series
			case kTPlotSeriesType:
			{
				CcString name;						// the series name (if given)
				CcString textstyle;					// the drawing style, in text
				int style = Plot_SeriesBar;			// the style in Plot_SeriesX form
				int series = 0;
		
				tokenList->GetToken();				// 'TYPE'

				style = FindSeriesType((tokenList->GetToken()).ToCString());

				// if current series is -1, apply to all series
				if(m_CurrentSeries == -1)
				{
					for(int i=0; i<m_NumberOfSeries; i++)
						m_Series[i]->m_DrawStyle = style;
				}
				else
				{
					m_Series[m_CurrentSeries]->m_DrawStyle = style;
				}
				break;
			}

			// select a series
			case kTPlotSeries:
			{
				tokenList->GetToken();	// "SERIES"

				CcString sname = tokenList->GetToken();

				if(sname == "ALL") m_CurrentSeries = -1;
		
				bool seriesfound = false;

				// now search series names for the token sname
				for(int i=0; i<m_NumberOfSeries; i++)
				{
					if((sname == m_Series[i]->m_SeriesName) && !(m_Series[i]->m_SeriesName == ""))
					{
						m_CurrentSeries = i;
						seriesfound = true;
					}
				}
				
				// if name doesn't match, try getting a number
				if(!seriesfound)
				{
					m_CurrentSeries = atoi(sname.ToCString()) - 1;				
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
				tokenList->GetToken();	// "XAXIS"
				m_CurrentAxis = Axis_X;
				break;
			}
			case kTPlotYAxis:
			{
				tokenList->GetToken();	// "YAXIS"
				m_CurrentAxis = Axis_YL;
				break;
			}
			case kTPlotYAxisRight:
			{
				tokenList->GetToken();	// "YAXISRIGHT"
				m_CurrentAxis = Axis_YR;
				break;
			}

			// add a series to the graph
			case kTPlotAddSeries:
			{
				tokenList->GetToken();	// "ADDSERIES"

				CcString sname;

				// next token should be the name of the series (but is optional so scan for type instead
				CcString next = tokenList->PeekToken();

				if(!(next == "TYPE"))
					sname = tokenList->GetToken();

				// next token should be "TYPE"
				tokenList->GetToken();
				// followed by the type itself
				next = tokenList->GetToken();

				AddSeries(FindSeriesType(next));
				break;
			}

			// set the current series to use the right-hand y axis
			case kTPlotUseRightAxis:
			{
				tokenList->GetToken();	// "USERIGHTAXIS"

				if(m_CurrentAxis == (-1))
				{
					for(int i=0; i<m_NumberOfSeries; i++)
					{
						m_Series[i]->m_YAxis = Axis_YR;
					}
				}
				else m_Series[m_CurrentSeries]->m_YAxis = Axis_YR;
				
				m_Axes.m_NumberOfYAxes = 2;
				break;
			}

			// tells this graph to draw a key
			case kTPlotKey:
			{
				tokenList->GetToken();	// "KEY"

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
	CcString * names = new CcString[m_NumberOfSeries];
	int ** col;
	col = new int*[3];

	col[0] = new int[m_NumberOfSeries];
	col[1] = new int[m_NumberOfSeries];
	col[2] = new int[m_NumberOfSeries];

	for(int i=0; i<m_NumberOfSeries; i++)
	{
		names[i] = m_Series[i]->m_SeriesName;
		col[0][i] = m_Colour[0][i];
		col[1][i] = m_Colour[1][i];
		col[2][i] = m_Colour[2][i];
	}
	attachedPlot->CreateKey(m_NumberOfSeries, names, col);

	delete [] names;
	delete [] col[0];
	delete [] col[1];
	delete [] col[2];
	delete [] col;
}

// returns the series type identifier corresponding to the text string supplied
int CcPlotData::FindSeriesType(CcString textstyle)
{
	int style = -1;

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
	m_YAxis = Axis_YL;
	m_DrawStyle = -1;
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
//	The AxesData stuff
//
///////////////////////////////////////////////////////////////////////////////////////////

// set all values to default
CcAxisData::CcAxisData()
{
	m_Max = 0;
	m_Min = 10000;

	m_AxisMax = 0;
	m_AxisMin = 0;

	m_Delta = 0;

	m_NumDiv = 0;

	m_AxisDivisions = 0;

	m_AxisScaleType = Plot_AxisAuto; 
	m_AxisLog = false;
}

CcAxisData::~CcAxisData()
{
}

// calculate a linear set of axis divisions, make them fall on 'nice' numbers with sensible delta
Boolean CcAxisData::CalculateLinearDivisions()
{
	// initial delta value - too high? Can be reduced if any lower is needed, but use either ...1, ...2 or ...5
	m_Delta = 0.001f;
	m_NumDiv = (float)((m_AxisMax - m_AxisMin) / m_Delta);	// initial number of divisions based on delta

	int numinc = 0;							// number of increments of delta

	// increment the delta, so reducing the number of divisions needed.
	// x2, x2.5, x2, x2, x2.5, x2, x2 etc
	// this gives 'nice' delta values - 1,2,5,10,20,50,100,200,500,1000 etc.
	while(m_NumDiv > 15)				// max 15 divisions
	{
		if((numinc+2)%3 == 0)				// every third increment is x2.5
		{
			m_Delta *= 2.5f;
		}
		else m_Delta *= 2;			// others are x2

		numinc++;
		m_NumDiv = (float)((m_AxisMax - m_AxisMin) / m_Delta);// find new number of divisions
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

	if(m_AxisMin < 0) 
		m_AxisMin = -absdelta;

	// make sure there are enough divisions
	if(m_AxisScaleType != Plot_AxisZoom)
		while (m_AxisMin + (m_NumDiv * m_Delta) < m_Max) 
			(m_NumDiv)++;

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
Boolean CcAxisData::CalculateLogDivisions()
{
	// now do log y axis
	m_Delta = 1;
	if(m_AxisMin <= 0) m_AxisMin = 1;

	m_NumDiv = (float)((log10(m_AxisMax) - log10(m_AxisMin)) / m_Delta);// initial number of divisions based on delta

	int numinc = 0;									// number of increments of delta

	// increment the delta, so reducing the number of divisions needed.
	// x2, x2.5, x2, x2, x2.5, x2, x2 etc
	// this gives 'nice' delta values - 1,2,5,10,20,50,100,200,500,1000 etc.
	while(m_NumDiv > 15)				// max 15 divisions
	{
		if((numinc+2)%3 == 0)						// ever third increment is x2.5
		{
			m_Delta *= 2.5f;
		}
		else m_Delta *= 2;						// others are x2

		numinc++;
		m_NumDiv = (float)((log10(m_AxisMax) - log10(m_AxisMin)) / m_Delta);// find new number of divisions
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

	if(m_AxisMin < 0)	m_AxisMin = -absdelta;

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
//	The CcPlotAxes stuff
//
///////////////////////////////////////////////////////////////////////////////////////////

// set all variables to initial default values
CcPlotAxes::CcPlotAxes()
{
	m_Labels = 0;
	m_NumberOfYAxes = 1;	// only one y axis (left) is default
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

	if(m_Labels) delete [] m_Labels;
	m_Labels = 0;
}


// work out the division markers for the axes
Boolean CcPlotAxes::CalculateDivisions()
{
	Boolean tempx = false;
	Boolean tempyl = false;
	Boolean tempyr = false;

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
		int xgapright = 160;		// horizontal gap between graph and edge of window
		int xgapleft = 200;			//		nb: leave enough space for labels
		int ygaptop = 200;			// and the vertical gap
		int ygapbottom = 300;		//		nb: lots of space for labels

		// if graph has a title, make top gap bigger
		if(!(m_PlotTitle == ""))
			ygaptop = 300;

		// if x axis has a title make the bottom gap bigger
		if(!(m_AxisData[Axis_X].m_Title == ""))
			ygapbottom = 500;

		// if y axis has a title make the lhs gap bigger
		if(!(m_AxisData[Axis_YL].m_Title == ""))
			xgapleft = 300;
		if(!(m_AxisData[Axis_YR].m_Title == ""))
			xgapright = 300;

		// variables used for loops
		int i=0;
		int j=0;

		// temp string for text label
		CcString ylabel;
		
		// gap between division markers on x and y axes
		int xdivoffset = (2400-xgapleft-xgapright) / (m_AxisData[Axis_X].m_NumDiv);
		int ydivoffset = (2400-ygaptop-ygapbottom) / (m_AxisData[Axis_YL].m_NumDiv);
		int yroffset   = 0;
		
		if(m_NumberOfYAxes == 2) yroffset = (2400 - ygaptop - ygapbottom)/(m_AxisData[Axis_YR].m_NumDiv);

		// axis dimensions after rounding
		int axisheight = ydivoffset * (m_AxisData[Axis_YL].m_NumDiv);				
		int axiswidth = xdivoffset * (m_AxisData[Axis_X].m_NumDiv);
		
		// take the axis height, work out where zero is...
		int xorigin = (float)(2400 - xgapleft + ((axiswidth * m_AxisData[Axis_X].m_Min) / (m_AxisData[Axis_X].m_Max - m_AxisData[Axis_X].m_Min)));
		int yorigin = (float)(2400 - ygapbottom + (axisheight * (m_AxisData[Axis_YL].m_AxisMin/ (m_AxisData[Axis_YL].m_AxisMax - m_AxisData[Axis_YL].m_AxisMin))));
		int yorigright = (float)(2400 - ygapbottom + (axisheight * (m_AxisData[Axis_YR].m_AxisMin / (m_AxisData[Axis_YR].m_AxisMax - m_AxisData[Axis_YR].m_AxisMin))));

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
		attachedPlot->DrawLine(3, xgapleft, 2400-ygapbottom-axisheight, xgapleft, 2400-ygapbottom);
		attachedPlot->DrawLine(3, xgapleft, yorigin, 2400-xgapright, yorigin);

		if(m_NumberOfYAxes == 2)
			attachedPlot->DrawLine(3, 2400-xgapright, 2400-ygapbottom-axisheight, 2400-xgapright, 2400-ygapbottom);

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
				for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i++)
				{
					textextent = attachedPlot->GetTextArea(fontsize, m_Labels[i], 0);
					if(textextent.x > maxhorizontaltextextent.x) maxhorizontaltextextent.x = textextent.x;
					if(textextent.y > maxhorizontaltextextent.y) maxhorizontaltextextent.y = textextent.y;
				}

				// if the text fits at this size, draw normally
				if((maxhorizontaltextextent.x < xdivoffset))
				{
					for(i=0; i<m_AxisData[Axis_X].m_NumDiv;i++)
					{
						attachedPlot->DrawText((int)(xgapleft+(i+0.5)*xdivoffset),2400-ygapbottom, m_Labels[i].ToCString(), TEXT_HCENTRE|TEXT_TOP, fontsize);
					}
					textOK = true;
				}
				// otherwise try at an angle
				else
				{
					// find the maximum screen area occupied by a label at this font size
					maxangletextextent.x = 0;
					maxangletextextent.y = 0;
					for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i++)
					{
						textextent = attachedPlot->GetTextArea(fontsize, m_Labels[i], TEXT_ANGLE);
						if(textextent.x > maxangletextextent.x) maxangletextextent.x = textextent.x;
						if(textextent.y > maxangletextextent.y) maxangletextextent.y = textextent.y;
					}
					// if this angled text fits, draw it
					if(maxangletextextent.y < 3*ygapbottom/4 && maxhorizontaltextextent.y < xdivoffset*2)
					{
						for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i++)
						{
							attachedPlot->DrawText((int)(xgapleft+(i+0.5)*xdivoffset), 2400-ygapbottom, m_Labels[i].ToCString(), TEXT_ANGLE, fontsize);
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
			for(i=0; i<m_AxisData[Axis_X].m_NumDiv+1; i++)
			{
				ylabel = m_AxisData[Axis_X].m_AxisDivisions[i];
				attachedPlot->DrawText((int)(xgapleft+i*xdivoffset), 2400-ygapbottom, ylabel.ToCString(), TEXT_TOP|TEXT_HCENTRE, fontsize);
			}
		}
		
		// if the above methods couldn't fit the text without making it too small, plot every other label
		//		NB this doesn't matter too much (I think) since mouse-over shows all labels...
		if(smalltext)
		{
			fontsize = 8;

			for(i=0; i<m_AxisData[Axis_X].m_NumDiv; i+=2)
			{
				attachedPlot->DrawText(xgapleft+(i+0.5)*xdivoffset, 2400-ygapbottom, m_Labels[i].ToCString(), TEXT_ANGLE, fontsize);
			}
		}

		fontsize = 12;

		// now draw the y axis labels, again without worrying about overlap
		for(i=0; i<m_AxisData[Axis_YL].m_NumDiv+1; i++)
		{
			ylabel = m_AxisData[Axis_YL].m_AxisDivisions[i];
			attachedPlot->DrawText(xgapleft-10, (2400-ygapbottom)-i*ydivoffset, ylabel.ToCString(), TEXT_VCENTRE|TEXT_RIGHT, fontsize);
		}		

		if(m_NumberOfYAxes == 2)
		{
			// if there is a right-hand y axis, draw labels here...
			for(i=0; i<m_AxisData[Axis_YR].m_NumDiv+1; i++)
			{
				ylabel = m_AxisData[Axis_YR].m_AxisDivisions[i];
				attachedPlot->DrawText(2400-xgapright+15, (2400-ygapbottom)-i*yroffset, ylabel.ToCString(), TEXT_VCENTRE, fontsize);
			}
		}
		
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
		attachedPlot->DrawText(1200, ygaptop/2, m_PlotTitle.ToCString(), TEXT_VCENTRE|TEXT_HCENTRE|TEXT_BOLD, 20);
		attachedPlot->DrawText(1200, 2400-ygapbottom/6, m_AxisData[Axis_X].m_Title.ToCString(), TEXT_HCENTRE|TEXT_BOTTOM, 16);
		attachedPlot->DrawText(xgapleft/6, 1200, m_AxisData[Axis_YL].m_Title.ToCString(), TEXT_VERTICAL, 16);
		if(m_NumberOfYAxes == 2)
			attachedPlot->DrawText(2400-xgapright/6, 1200, m_AxisData[Axis_YR].m_Title.ToCString(), TEXT_VERTICALDOWN, 16);
	}
}