////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CrPlot.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:20
//
//   $Log: not supported by cvs2svn $
//   Revision 1.2  2001/11/12 16:24:30  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crplot.h"
#include    "crgrid.h"
#include    "cxplot.h"
#include    "ccplotdata.h"
#include    "ccrect.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"    // for sending commands
#include    "crwindow.h" // for getting cursor keys

CrPlot::CrPlot( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxPlot::CreateCxPlot( this,
                                (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
    mXCanResize = true;
    mYCanResize = true;
    attachedPlotData = nil;
}

CrPlot::~CrPlot()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxPlot*)ptr_to_cxObject)->CxDestroyWindow(); 
#ifdef __CR_WIN__
        delete (CxPlot*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }

    if(attachedPlotData != nil)
    {
        if (attachedPlotData==CcPlotData::sm_CurrentPlotData)
            CcPlotData::sm_CurrentPlotData = nil;
        delete attachedPlotData;
    }
}

CcParse CrPlot::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Plot *** Initing...");

        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created Plot      " + mName );

        //Init only parsing
        Boolean hasTokenForMe = true;
        while (hasTokenForMe)
        {
            switch ( tokenList->GetDescriptor(kAttributeClass) )
            {
                case kTNumberOfRows:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxPlot*)ptr_to_cxObject)->SetIdealHeight( chars );
                    LOGSTAT( "Setting Plot Lines Height: " + theString );
                    break;
                }
                case kTNumberOfColumns:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxPlot*)ptr_to_cxObject)->SetIdealWidth( chars );
                    LOGSTAT( "Setting Plot Chars Width: " + theString );
                    break;
                }
                default:
                {
                    hasTokenForMe = false;
                    break; // We leave the token in the list and exit the loop
                }
            }
        }
    }
    // End of Init, now comes the general parser

    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting Plot Text: " + mText );
                break;
            }
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    return retVal;
}

CRSETGEOMETRY(CrPlot,CxPlot)
CRGETGEOMETRY(CrPlot,CxPlot)
CRCALCLAYOUT(CrPlot,CxPlot)

void CrPlot::CrFocus()
{
    ((CxPlot*)ptr_to_cxObject)->Focus();
}

void CrPlot::SetText( CcString text )
{
    char theText[256];
    strcpy( theText, text.ToCString() );
    ( (CxPlot *)ptr_to_cxObject)->SetText( theText );
}


void CrPlot::DrawEllipse(int x, int y, int w, int h, Boolean fill)
{
    ((CxPlot*)ptr_to_cxObject)->DrawEllipse(x,y,w,h,fill);
}

void CrPlot::DrawRect(int x1, int y1, int x2, int y2, Boolean fill)
{
    int temp[10];
    temp[0] = x1; temp[1] = y1;
    temp[2] = x1; temp[3] = y2;
    temp[4] = x2; temp[5] = y2;
    temp[6] = x2; temp[7] = y1;
    temp[8] = x1; temp[9] = y1;
    DrawPoly(5,&temp[0],fill);
}

void CrPlot::DrawPoly(int nVertices, int * vertices, Boolean fill)
{
    ((CxPlot*)ptr_to_cxObject)->DrawPoly(nVertices, vertices, fill);
}

//STEVE added a justification parameter
//RICHARD added a fontsize
void CrPlot::DrawText(int x, int y, CcString text, int param, int fontsize)
{
    ((CxPlot*)ptr_to_cxObject)->DrawText(x, y, text, param, fontsize);
}

CcPoint CrPlot::GetTextArea(int size, CcString text, int param)
{
	return ((CxPlot*)ptr_to_cxObject)->GetTextArea(size,text,param);
}

int CrPlot::GetMaxFontSize(int width, int height, CcString text, int param)
{
    return ((CxPlot*)ptr_to_cxObject)->GetMaxFontSize(width, height, text, param);
}

// STEVE changed cx plot to accept a line thickness
void CrPlot::DrawLine(int thickness, int x1, int y1, int x2, int y2)
{
    ( (CxPlot *)ptr_to_cxObject)->DrawLine(thickness, x1, y1, x2, y2);
}

void CrPlot::Clear()
{
    ((CxPlot*)ptr_to_cxObject)->Clear();
}

// STEVE added this function
void CrPlot::SetColour(int r, int g, int b)
{
	((CxPlot*)ptr_to_cxObject)->SetColour(r,g,b);
}


void CrPlot::Display()
{
    ( (CxPlot *)ptr_to_cxObject)->Display();
}

void CrPlot::ReDrawView()
{
    if(attachedPlotData)
        attachedPlotData->DrawView();
}

void CrPlot::Attach(CcPlotData * doc)
{
    //If there is already an attached Plot, (and it's not the same as the new one) delete it.
    if( (attachedPlotData) && (doc != attachedPlotData) )
        delete attachedPlotData;
    attachedPlotData = doc;
}

int CrPlot::GetIdealWidth()
{
    return ((CxPlot*)ptr_to_cxObject)->GetIdealWidth();
}
int CrPlot::GetIdealHeight()
{
    return ((CxPlot*)ptr_to_cxObject)->GetIdealHeight();
}

CcString CrPlot::GetDataFromPoint(CcPoint point)
{
	if(attachedPlotData) return attachedPlotData->GetDataFromPoint(point);
}

