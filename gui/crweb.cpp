////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrWeb

////////////////////////////////////////////////////////////////////////

//   Filename:  CrWeb.cc
//   Authors:   Richard Cooper
//   Created:   04.3.2011 14:43 Uhr
// $Log: not supported by cvs2svn $
// Revision 1.2  2011/04/18 08:17:57  rich
// MFC patches.
//
// Revision 1.1  2011/04/16 07:33:06  rich
// HTML control
//


#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crweb.h"

#include    "crgrid.h"
#include    "cxweb.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands

#ifdef DEPRECATEDCRY_USEWX


CrWeb::CrWeb( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxWeb::CreateCxWeb( this,
                                (CxGrid *)(mParentPtr->GetWidget()) );
	mXCanResize = true;
    mYCanResize = true;

}

CrWeb::~CrWeb()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxWeb*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxWeb*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrWeb,CxWeb)
CRGETGEOMETRY(CrWeb,CxWeb)
CRCALCLAYOUT(CrWeb,CxWeb)

CcParse CrWeb::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("CrWeb:ParseInput Web *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT("CrWeb:ParseInput Created Web      " + mName );
    }
    // End of Init, now comes the general parser

    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                bool disabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(disabled)
                    LOGSTAT( "CrWeb:ParseInput Web disabled ");
                else
                    LOGSTAT( "CrWeb:ParseInput Web enabled ");
                ((CxWeb*)ptr_to_cxObject)->Disable( disabled );
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


void CrWeb::Enable(bool enabled)
{
    ((CxWeb*)ptr_to_cxObject)->Disable( !enabled );
}

void CrWeb::SetText(const string &text)
{
    ((CxWeb*)ptr_to_cxObject)->SetAddress(text);
}

void CrWeb::CrFocus()
{
    ((CxWeb*)ptr_to_cxObject)->Focus();
}



void CrWeb::GetValue( deque<string> &  tokenList)
{
    if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQState )
    {
        tokenList.pop_front();
        SendCommand( kSOn,true);
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrCheckBox:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }
}
#endif
