////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.cpp
//   Authors:   Richard Cooper
//   Created:   22.2.1998 14:43 Hours
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crprogress.h"
#include    "crgrid.h"
#include    "cxprogress.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrProgress::CrProgress( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxProgress::CreateCxProgress( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = false;
}

CrProgress::~CrProgress()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxProgress*) ptr_to_cxObject)->DestroyWindow(); delete (CxProgress*) ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }

      mControllerPtr->RemoveProgressOutputPlace(this);
}

CRSETGEOMETRY(CrProgress,CxProgress)
CRGETGEOMETRY(CrProgress,CxProgress)
CRCALCLAYOUT(CrProgress,CxProgress)

CcParse CrProgress::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

// Initialization for the first time
    if( ! mSelfInitialised )
    {
            LOGSTAT("*** ProgressBar *** Initing...\n");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

            LOGSTAT( "*** Created ProgressBar    " + mName + "\n");
    }

// End of Init, now comes the general parser
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting Text to '" + mText);
                break;
            }
            case kTChars:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                int chars = atoi( theString.ToCString() );
                ((CxProgress*)ptr_to_cxObject)->SetVisibleChars( chars );
                LOGSTAT( "Setting Text Chars Width: " + theString );
                break;
            }
            case kTComplete:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                int complete = atoi( theString.ToCString() );
                ((CxProgress*)ptr_to_cxObject)->SetProgress( complete );
                LOGSTAT( "Setting Progress: " + theString + "% ");
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

void    CrProgress::SetText( CcString text )
{
    char theText[256];
    strcpy( theText, text.ToCString() );

    ( (CxProgress *)ptr_to_cxObject)->SetText( theText );
}


void CrProgress::CrFocus()
{

}

void CrProgress::SwitchText ( CcString * text )
{
      ((CxProgress*)ptr_to_cxObject)->SwitchText( text );
}
