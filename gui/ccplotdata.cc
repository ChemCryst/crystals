////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotData

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotData.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotData is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
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
    m_seriesList = new CcList();
}

CcPlotData::~CcPlotData()
{
// Remove from list of plotdata objects:
    sm_PlotList.FindItem(this);
    sm_PlotList.RemoveItem();
//Should delete all series here...
//...
    delete m_seriesList;
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
            case kTPlotSeries:
            {
                tokenList->GetToken(); // Remove that token!
                CcString seriesName = tokenList->GetToken();

//See if this series already exists:
                m_seriesList->Reset();
                CcSeries* theItem = (CcSeries *)m_seriesList->GetItemAndMove();
                while ( theItem )
                {
                   if ( theItem->mName == seriesName )
                   {
                      break;
                   }
                }
//If it doesn't exist, create a new one:
                if ( ! theItem )
                {
                   theItem = new CcSeries();
                   m_seriesList->AddItem(theItem);
                   theItem->mName = seriesName;
                }
//Pass the tokenList to it:
                theItem->ParseInput( tokenList );
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
   m_type = 0;
   r = g = b = 0;
   xdata = ydata = nil;
   xlabel = nil;
   m_Length = 0;
   m_Next = 0;
}

Boolean CcSeries::ParseInput( CcTokenList * tokenList )
{
    if ( m_type == 0 )
    {
// Not initialised yet.
      switch ( tokenList->GetDescriptor(kPlotClass) )
      {
        case kTPlotLabel:
        {
           tokenList->GetToken(); // Remove that token!
           m_type = SERIES_LABEL;
           break;
        }
        case kTPlotXValue:
        {                   
           tokenList->GetToken(); // Remove that token!
           m_type = SERIES_XVALUE;
           break;
        }
        case kTPlotYValue:
        {
           tokenList->GetToken(); // Remove that token!
           m_type = SERIES_YVALUE;
           break;
        }
        default:
        {
           LOGWARN( "CcSeries: Failed to initialise '" + tokenList->GetToken() + "'");
           return true; // Failed to initialise. Some sort of error.
           break; 
        }
      }


      CcString aString = tokenList->GetToken();
      LOGWARN( "Setting m_length to this: '" + aString + "'");
      m_Length = atoi( aString.ToCString() );
      LOGWARN( "Check m_Length is same:   '" + CcString ( m_Length ) + "'");


      if ( m_Length <= 0 )
      {
         LOGWARN( "CcSeries: Failed to initialise or zero length: '" + aString + "'");
         m_type = 0;
         return true; // Failed to initialise. Some sort of error.
      }

      switch ( m_type )
      {
        case SERIES_LABEL:
          xlabel = new CcString[m_Length];
          break;
        case SERIES_XVALUE:
          xdata =  new float[m_Length];
          break;
        case SERIES_YVALUE:
          ydata =  new float[m_Length];
          break;
      }
    }

//By the time we get here we have initialised, this must be some data.


    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {

        if ( tokenList->GetDescriptor(kPlotClass) == kTPlotData )
        {
          tokenList->GetToken(); //Remove the "DATA" token.
 
		  
          if ( m_Next >= m_Length )
          {
            LOGWARN( "CcSeries: Too many data statements given" + CcString(m_Next) + " " + CcString(m_Length)   ) ;
            return true;
          }

          CcString tempString = tokenList->GetToken();
          switch ( m_type )
          {
            case SERIES_LABEL:
              xlabel[m_Next] = tempString;
              break;
            case SERIES_XVALUE:
              xdata[m_Next] = atof( tempString.ToCString() );
              break;
            case SERIES_YVALUE:
              ydata[m_Next] = atof( tempString.ToCString() );
              break;
          }
          m_Next++ ;
        }
        else
        {
          hasTokenForMe = false;
        }
    }
    return true;
}


