////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrChart

////////////////////////////////////////////////////////////////////////

//   Filename:  CrChart.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.10  2002/05/08 08:56:13  richard
//   Added support for wmf AND emf file output to Chart objects (Cameron). Reason:
//   emf doesn't work on Windows 95. Bah.
//
//   Revision 1.9  2002/01/30 10:58:43  ckp2
//   RIC: Printing and WMF capability for CxChart object. - NB. Steve, this can easily
//   be copied to CxPlot to do same thing.
//
//   Revision 1.8  2001/06/17 15:14:12  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.7  2001/03/08 16:44:04  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crchart.h"
#include    "crgrid.h"
#include    "cxchart.h"
#include    "ccchartdoc.h"
#include    "ccrect.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"    // for sending commands
#include    "crwindow.h" // for getting cursor keys

#ifdef __BOTHWX__
// These macros are being defined somewhere. They shouldn't be.

#ifdef GetCharWidth
 #undef GetCharWidth
#endif
#ifdef DrawText
 #undef DrawText
#endif
#endif


CrChart::CrChart( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxChart::CreateCxChart( this,
                                (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
    mXCanResize = true;
    mYCanResize = true;
    attachedChartDoc = nil;
      mWantSysKeys=false;
}

CrChart::~CrChart()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxChart*)ptr_to_cxObject)->CxDestroyWindow(); 
#ifdef __CR_WIN__
        delete (CxChart*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
    if(attachedChartDoc != nil)
    {
        if (attachedChartDoc==(CcController::theController)->mCurrentChartDoc)
            (CcController::theController)->mCurrentChartDoc = nil;
        delete attachedChartDoc;
    }

}

CcParse CrChart::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Chart *** Initing...");

        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created Chart      " + mName );

        //Init only parsing
        bool hasTokenForMe = true;
        while (hasTokenForMe)
        {
            switch ( tokenList->GetDescriptor(kAttributeClass) )
            {
                case kTNumberOfRows:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxChart*)ptr_to_cxObject)->SetIdealHeight( chars );
                    LOGSTAT( "Setting Chart Lines Height: " + theString );
                    break;
                }
                case kTNumberOfColumns:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxChart*)ptr_to_cxObject)->SetIdealWidth( chars );
                    LOGSTAT( "Setting Chart Chars Width: " + theString );
                    break;
                }
                case kTNoEdge:
                {
                    tokenList->GetToken();
                    ((CxChart*)ptr_to_cxObject)->NoEdge();
                    break;
                }
                case kTIsoView:
                {
                    tokenList->GetToken();
                    bool state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                    tokenList->GetToken(); // Remove that token!
                    ((CxChart*)ptr_to_cxObject)->UseIsotropicCoords(state);
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

    bool hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting Chart Text: " + mText );
                break;
            }
            case kTInform:
            {
                tokenList->GetToken(); // Remove that token!
                bool inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                if(inform)
                    LOGSTAT( "CrButton:ParseInput Chart INFORM on ");
                else
                    LOGSTAT( "CrButton:ParseInput Chart INFORM off ");
                mCallbackState = inform;
                break;
            }
            case kTGetPolygonArea:
            {
                tokenList->GetToken(); // Remove that token!
                bool state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                CcString theString = tokenList->GetToken(); // Remove that token!
                ((CxChart*)ptr_to_cxObject)->SetPolygonDrawMode(state);
                break;
            }
                  case kTGetCursorKeys:
            {
                tokenList->GetToken(); // Remove that token!
                bool state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                CcString theString = tokenList->GetToken(); // Remove that token!
                        ((CrWindow*)GetRootWidget())->SendMeSysKeys( (CrGUIElement*) ((state)?this:nil) );
                        mWantSysKeys=true;
                        GetRootWidget()->CrFocus();
                break;
            }
            case kTChartHighlight:
            {
                tokenList->GetToken();
                bool state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken();
                Highlight(state);
                ReDrawView();
                break;
            }
            case kTChartSave:
            {
                tokenList->GetToken();
                int w = atoi( tokenList->GetToken().ToCString() );
                int h = atoi( tokenList->GetToken().ToCString() );
                ((CxChart*)ptr_to_cxObject)->MakeMetaFile(w,h,false);
                break;
            }
            case kTChartSaveEnh:
            {
                tokenList->GetToken();
                int w = atoi( tokenList->GetToken().ToCString() );
                int h = atoi( tokenList->GetToken().ToCString() );
                ((CxChart*)ptr_to_cxObject)->MakeMetaFile(w,h,true);
                break;
            }
            case kTChartPrint:
            {
                tokenList->GetToken();
                ((CxChart*)ptr_to_cxObject)->PrintPicture();
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

CRSETGEOMETRY(CrChart,CxChart)

CRGETGEOMETRY(CrChart,CxChart)

CRCALCLAYOUT(CrChart,CxChart)

void CrChart::CrFocus()
{
    ((CxChart*)ptr_to_cxObject)->Focus();
}

void    CrChart::SetText( CcString text )
{
    char theText[256];
    strcpy( theText, text.ToCString() );

    ( (CxChart *)ptr_to_cxObject)->SetText( theText );
}


void CrChart::DrawLine(int x1, int y1, int x2, int y2)
{
    ( (CxChart *)ptr_to_cxObject)->DrawLine(x1, y1, x2, y2);
}



void CrChart::Display()
{
    ( (CxChart *)ptr_to_cxObject)->Display();
}

void CrChart::ReDrawView()
{
    if(attachedChartDoc)
        attachedChartDoc->DrawView();
}

void CrChart::Attach(CcChartDoc * doc)
{
    //If there is already an attached chart, (and it's not the same as the new one) delete it.
    if( (attachedChartDoc) && (doc != attachedChartDoc) )
        delete attachedChartDoc;

    attachedChartDoc = doc;
}

int CrChart::GetIdealWidth()
{
    return ((CxChart*)ptr_to_cxObject)->GetIdealWidth();
}
int CrChart::GetIdealHeight()
{
    return ((CxChart*)ptr_to_cxObject)->GetIdealHeight();
}


void CrChart::Clear()
{
    ((CxChart*)ptr_to_cxObject)->Clear();
}

void CrChart::DrawEllipse(int x, int y, int w, int h, bool fill)
{
    ((CxChart*)ptr_to_cxObject)->DrawEllipse(x,y,w,h,fill);
}

void CrChart::DrawRect(int x1, int y1, int x2, int y2, bool fill)
{
    int temp[10];
    temp[0] = x1; temp[1] = y1;
    temp[2] = x1; temp[3] = y2;
    temp[4] = x2; temp[5] = y2;
    temp[6] = x2; temp[7] = y1;
    temp[8] = x1; temp[9] = y1;
    DrawPoly(5,&temp[0],fill);
}

void CrChart::DrawPoly(int nVertices, int * vertices, bool fill)
{
    ((CxChart*)ptr_to_cxObject)->DrawPoly(nVertices, vertices, fill);
}

void CrChart::DrawText(int x, int y, CcString text)
{
    ((CxChart*)ptr_to_cxObject)->DrawText(x, y, text);
}

void CrChart::SetColour(int r, int g, int b)
{
    ((CxChart*)ptr_to_cxObject)->SetColour(r, g, b);
}

void CrChart::LMouseClick(int x, int y)
{
    if(mCallbackState)
    {   CcString command = "LCLICK ";
        CcString cx = CcString(x);
        CcString cy = CcString(y);
        SendCommand(command + cx + " " + cy);
    }
}

void CrChart::PolygonCancelled()
{
    SendCommand( CcString( "CANCEL" ) );
}

void CrChart::PolygonClosed()
{
    SendCommand( CcString( "CLOSED" ) );
}

void CrChart::FitText(int x1, int y1, int x2, int y2, CcString theText, bool rotated)
{
    ((CxChart*)ptr_to_cxObject)->FitText(x1, y1, x2, y2, theText, rotated);
}

void CrChart::Highlight(bool highlight)
{
    ((CxChart*)ptr_to_cxObject)->Invert(highlight);
}

void CrChart::SysKey ( UINT nChar )
{
   if ( mWantSysKeys)
   {
      switch (nChar)
      {
            case CRLEFT:
                  SendCommand( CcString( "L" ) );
                  break;
            case CRRIGHT:
                  SendCommand( CcString( "R" ) );
                  break;
            case CRUP:
                  SendCommand( CcString( "U" ) );
                  break;
            case CRDOWN:
                  SendCommand( CcString( "D" ) );
                  break;
            case CRDELETE:
                  SendCommand( CcString( "A" ) );
                  break;
            case CREND:
                  SendCommand( CcString( "C" ) );
                  break;
            case CRESCAPE:
                  SendCommand( CcString( "E" ) );
                  break;
            default:
                  break;
      }
   }
}
