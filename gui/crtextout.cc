////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CrTextOut.cc
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include "ccstring.h"
#include    "crconstants.h"
#include    "ccrect.h"
#include    "crtextout.h"
#include    "crgrid.h"
#include    "cccontroller.h"
#include    "cxtextout.h"


CrTextOut::CrTextOut( CrGUIElement * mParentPtr )
 : CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxTextOut::CreateCxTextOut( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mXCanResize = true;
    mYCanResize = true;
    mTabStop = true;
}

CrTextOut::~CrTextOut()
{
    mControllerPtr->RemoveTextOutputPlace(this);
    if ( ptr_to_cxObject != nil )
    {
        ((CxTextOut*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
        delete (CxTextOut*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrTextOut,CxTextOut)
CRGETGEOMETRY(CrTextOut,CxTextOut)
CRCALCLAYOUT(CrTextOut,CxTextOut)

CcParse CrTextOut::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** TextOut *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created MulitEdit    " + mName );

            int size = 200;
            CcString cgeom = (CcController::theController)->GetKey( "FontSize" );
            if ( cgeom.Len() )
                size = atoi( cgeom.ToCString() );
//            ((CxTextOut*)ptr_to_cxObject)->SetFontHeight(size);
    }
    // End of Init, now comes the general parser
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting TextOut Text: " + mText );
                break;
            }
                        case kTEmpty:
                        {
                                tokenList->GetToken(); //Remove kTEmpty tokens.
                                ((CxTextOut*)ptr_to_cxObject)->Empty();
                                break;
                        }
                        case kTDisabled:
            {
                tokenList->GetToken(); // Remove that token!
                mDisabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                break;
            }
                        case kTFontSelect:
            {
                tokenList->GetToken(); // Remove that token!
                                ((CxTextOut*)ptr_to_cxObject)->ChooseFont();
                                break;
            }


            case kTNumberOfRows:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                int chars = atoi( theString.ToCString() );
                ((CxTextOut*)ptr_to_cxObject)->SetIdealHeight( chars );
                LOGSTAT( "Setting TextOut Lines Height: " + theString );
                break;
            }
            case kTNumberOfColumns:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                int chars = atoi( theString.ToCString() );
                ((CxTextOut*)ptr_to_cxObject)->SetIdealWidth( chars );
                LOGSTAT( "Setting TextOut Chars Width: " + theString );
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

void CrTextOut::SetText ( CcString cText )
{
   ((CxTextOut*)ptr_to_cxObject)->SetText(cText);
}


int CrTextOut::GetIdealWidth()
{
    return ((CxTextOut*)ptr_to_cxObject)->GetIdealWidth();
}
int CrTextOut::GetIdealHeight()
{
    return ((CxTextOut*)ptr_to_cxObject)->GetIdealHeight();
}

void CrTextOut::CrFocus()
{
    ((CxTextOut*)ptr_to_cxObject)->Focus();
}

void CrTextOut::ProcessLink( CcString aString )
{
      SendCommand("$ " + aString,TRUE);
}

void CrTextOut::ScrollPage(bool up)
{
    ((CxTextOut*)ptr_to_cxObject)->ScrollPage(up);
}
