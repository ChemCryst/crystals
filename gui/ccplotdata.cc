////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotData is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
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
	m_Axes = 0;
	m_Series = 0;
}

CcPlotData::~CcPlotData()
{
// Remove from list of plotdata objects:
	sm_PlotList.FindItem(this);
	sm_PlotList.RemoveItem();

	if(m_Series) delete m_Series;
	if(m_Axes) delete m_Axes;
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

Boolean CcPlotData::ParseInput( CcTokenList * tokenList )
{
	Boolean hasTokenForMe = true;
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kPlotClass) )
		{
			case kTPlotAttach:
			{
				tokenList->GetToken(); // Remove that token!
				CcString chartName = tokenList->GetToken();
				attachedPlot = (CrPlot*)(CcController::theController)->FindObject(chartName);
				if(attachedPlot != nil)
					attachedPlot->Attach(this);
				break;
			}
			case kTPlotShow:
			{
				tokenList->GetToken(); // Remove that token!
				this->DrawView();
				break;
			}
			case kTPlotLinear:
			{
				tokenList->GetToken();
				m_Axes->m_AxisLog[Axis_X] = false;
				m_Axes->m_AxisLog[Axis_Y] = false;
				break;
			}
			case kTPlotLog:
			{
				tokenList->GetToken();
				m_Axes->m_AxisLog[Axis_X] = false;	// x axis always linear
				m_Axes->m_AxisLog[Axis_Y] = true;	// set y axis to be logarithmic (sp?)
				break;
			}
			case kTPlotTitle:
			{
				tokenList->GetToken();
				m_PlotTitle = tokenList->GetToken();
				break;
			}
			case kTPlotAuto:		// this mode sets y axis range to 0 < y < ymax
			{
				tokenList->GetToken();
				m_Axes->m_AxisScaleType = Plot_AxisAuto;
				break;
			}
			case kTPlotSpan:		// this mode sets y axis range to ymin < y < ymax
			{
				tokenList->GetToken();
				m_Axes->m_AxisScaleType = Plot_AxisSpan;
				break;
			}
			case kTPlotZoom:
			{
				tokenList->GetToken();
				m_Axes->m_AxisScaleType = Plot_AxisZoom;
				
				// next four tokens should be: xmin, xmax, ymin, ymax
				float xmin = atof(tokenList->GetToken().ToCString());
				float xmax = atof(tokenList->GetToken().ToCString());
				float ymin = atof(tokenList->GetToken().ToCString());
				float ymax = atof(tokenList->GetToken().ToCString());

				// check bounds: if min/max pair both zero don't change limits for that axis
				if(ymin != 0 && ymax != 0)
				{
					m_Axes->m_AxisMin[Axis_Y] = ymin;
					m_Axes->m_AxisMax[Axis_Y] = ymax;
				}
				if(xmin != 0 && xmax != 0)
				{
					m_Axes->m_AxisMin[Axis_X] = xmin;
					m_Axes->m_AxisMax[Axis_X] = xmax;
				}

				// specify that axes need rescaling
				m_AxesOK = false;

				break;
			}
			case kTPlotNSeries:				// number of series specified
			{
			    tokenList->GetToken();
			    CcString nseries = tokenList->GetToken();
				int num = atoi(nseries.ToCString());

				// create series here, 
				if(m_Series) m_Series->CreateSeries(num);
				else LOGWARN("NSERIES: Series not initialised");
			    break;
			}
		    case kTPlotLength:				// length of series specified
			{
			    tokenList->GetToken();
			    CcString plotlength = tokenList->GetToken();
			    int length = atoi(plotlength.ToCString());

				// allocate space for the data
				if(m_Series) m_Series->AllocateMemory(length);
				else LOGWARN("LENGTH: Series not yet initialised. Specify NSERIES before LENGTH");

//Don't assume that you'll get a full array - this gets incrmtd as data flows in anyway...
//				m_Axes->m_Max[Axis_X] = length;
				break;
			}
			case kTPlotSeriesName:
			{
				tokenList->GetToken();

				for(int i=0; i<m_Series->m_NumberOfSeries; i++)
				{
					m_Series->m_SeriesName[i] = tokenList->GetToken();
				}
				break;
			}
			case kTPlotXTitle:
			{
				tokenList->GetToken();
				m_XTitle = tokenList->GetToken();
				break;
			}
			case kTPlotYTitle:
			{
				tokenList->GetToken();
				m_YTitle = tokenList->GetToken();
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


CcPlotData *  CcPlotData::FindObject( CcString Name )
{
	if ( Name == mName )
		return this;
	else
		return nil;
}

///////////////////////////////////////////
//
// The CcSeries stuff:                   
//
///////////////////////////////////////////


CcSeries::CcSeries()
{
   m_Length = 0;
   m_Next = 0;

   // initialise the colours
   // nb only for 6 series currently
   for(int i=0; i<6; i++)
   {
	   m_Colour[0][i] = 0;
	   m_Colour[1][i] = 0;
	   m_Colour[2][i] = 0;
   }

   m_Colour[0][0] = 255;
   m_Colour[1][1] = 255;
   m_Colour[0][3] = 255;
   m_Colour[1][3] = 255;
   m_Colour[2][2] = 255;
   m_Colour[0][4] = 255;
   m_Colour[2][4] = 255;
   m_Colour[1][5] = 255;
   m_Colour[2][5] = 255;

   m_SeriesName = 0;
}

CcSeries::~CcSeries()
{
	delete [] m_SeriesName;
	m_SeriesName = 0;
}


Boolean CcSeries::ParseInput( CcTokenList * tokenList )
{
// Not initialised yet.
	  switch ( tokenList->GetDescriptor(kPlotClass) )
	  {
		default:
		{     //      LOGWARN( "CcSeries: Failed to initialise '" + tokenList->GetToken() + "'");
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
}

CcPlotAxes::~CcPlotAxes()
{
}

Boolean CcPlotAxes::CalculateDivisions()
{
	return false;
}

Boolean CcPlotAxes::CalculateLinearDivisions(int axis)
{
	// now do linear y axis
	m_Delta[axis] = 0.001;
	m_NumDiv[axis] = (m_AxisMax[axis] - m_AxisMin[axis]) / m_Delta[axis];	// initial number of divisions based on delta

	int numinc = 0;									// number of increments of delta
	int modulus = 0;								// used to align divisions to nice numbers

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
		m_NumDiv[axis] = (m_AxisMax[axis] - m_AxisMin[axis]) / m_Delta[axis];// find new number of divisions
	}

	// move all divisions such that they are multiples of the delta
	if(m_Delta[axis] > 1) 
		modulus = (int)m_AxisMin[axis]%(int)m_Delta[axis];

	// adjust modulus so there are enough divisions
	if(m_AxisScaleType != Plot_AxisZoom && m_AxisMin[axis] < 0) modulus += m_Delta[axis];

	// make sure there are enough divisions
	if((-modulus + m_AxisMin[axis] + (m_NumDiv[axis] * m_Delta[axis]) < m_Max[axis]) && m_AxisScaleType != Plot_AxisZoom)
		(m_NumDiv[axis])++;

	// allocate space for data (changed to new)
	m_AxisDivisions[axis] = new float[m_NumDiv[axis]+1];

	// loop through points, fill with data
	for(int i=0; i<(m_NumDiv[axis]+1); i++)
	{
		m_AxisDivisions[axis][i] = -modulus + m_AxisMin[axis] + m_Delta[axis]*i;

		if(m_AxisDivisions[axis][i] > -0.0001 && m_AxisDivisions[axis][i] < 0.0001)
			m_AxisDivisions[axis][i] = 0;
	}

	m_AxisMin[axis] = m_AxisDivisions[axis][0];
	m_AxisMax[axis] = m_AxisDivisions[axis][m_NumDiv[axis]];

	return true;
}

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

	// make sure there are enough divisions
	if((log10(m_AxisMin[axis]) + (m_NumDiv[axis] * m_Delta[axis]) < log10(m_Max[axis])))
		(m_NumDiv[axis])++;

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