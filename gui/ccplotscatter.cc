////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cpp
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:29

//BIG NOTICE: PlotScatter is not a CrGUIElement, it's just data to be
//            drawn onto a CrPlot. You can attach it to a CrPlot.
// $Log: not supported by cvs2svn $
//


#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccplotdata.h"
#include    "ccplotscatter.h"
#include    "crplot.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif

CcPlotScatter::CcPlotScatter( )
{
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

        attachedPlot->Display();
    }
}

void CcPlotScatter::Clear()
{
    attachedPlot->Clear();
}


