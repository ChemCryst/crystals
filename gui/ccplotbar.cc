////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CcPlotBar
////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:28

// $Log: not supported by cvs2svn $
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccplotdata.h"
#include    "ccplotbar.h"
#include    "crplot.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif

CcPlotBar::CcPlotBar( )
{
}

CcPlotBar::~CcPlotBar()
{
}


Boolean CcPlotBar::ParseInput( CcTokenList * tokenList )
{

    CcPlotData::ParseInput( tokenList );

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

void CcPlotBar::DrawView()
{
    if(attachedPlot)
    {
        //
       //  DRAW THE GRAPH HERE!
      //

        attachedPlot->DrawLine( 100,100,200,2300 );
        attachedPlot->DrawLine( 200,2300,2000,2100 );
        attachedPlot->DrawLine( 2000,2100,2300,300 );
        attachedPlot->DrawLine( 2300,300,100,100 );
        attachedPlot->Display();
    }
}

void CcPlotBar::Clear()
{
    attachedPlot->Clear();
}
