////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr
// $Log: not supported by cvs2svn $
// Revision 1.4  2000/12/13 17:54:16  richard
// Support for Linux. Changed SetDefault function in CxButton to prevent
// it clashing with a base class function in the wx library.
//


#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crbutton.h"
#include    "crwindow.h"

#include    "crgrid.h"
#include    "cxbutton.h"
#include    "ccrect.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"    // for sending commands


CrButton::CrButton( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxButton::CreateCxButton( this,
                                (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
    mCallbackState= true;
}

CrButton::~CrButton()
{
    if ( ptr_to_cxObject != nil )
    {
        delete (CxButton*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
}

Boolean CrButton::ParseInput( CcTokenList * tokenList )
{
    Boolean retVal = true;
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("CrButton:ParseInput Button *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT("CrButton:ParseInput Created Button      " + mName );
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
                LOGSTAT( "CrButton:ParseInput Setting Button Text: " + mText );
                break;
            }
            case kTDisabled:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean disabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                if(disabled)
                    LOGSTAT( "CrButton:ParseInput Button disabled ");
                else
                    LOGSTAT( "CrButton:ParseInput Button enabled ");
                ((CxButton*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTSetCommitText:
            {
                tokenList->GetToken(); // Remove that token!
                ((CrWindow*)GetRootWidget())->SetCommitText( mName );
                break;
            }
            case kTSetCancelText:
            {
                tokenList->GetToken(); // Remove that token!
                ((CrWindow*)GetRootWidget())->SetCancelText( mName );
                break;
            }
            case kTDefault:
            {
                ((CxButton*)ptr_to_cxObject)->SetDef();
                tokenList->GetToken(); // Remove that token!
                LOGSTAT( "CrButton:ParseInput Setting default button" );
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

void    CrButton::SetText( CcString text )
{

    char theText[256];
    strcpy( theText, text.ToCString() );

    ( (CxButton *)ptr_to_cxObject)->SetText( theText );

}

void    CrButton::SetGeometry( const CcRect * rect )
{

    ((CxButton*)ptr_to_cxObject)->SetGeometry(   rect->mTop,
                                                rect->mLeft,
                                                rect->mBottom,
                                                rect->mRight   );

}

CcRect  CrButton::GetGeometry()
{

    CcRect retVal ( ((CxButton*)ptr_to_cxObject)->GetTop(),
                    ((CxButton*)ptr_to_cxObject)->GetLeft(),
                    ((CxButton*)ptr_to_cxObject)->GetTop()+ ((CxButton*)ptr_to_cxObject)->GetHeight(),
                    ((CxButton*)ptr_to_cxObject)->GetLeft()+((CxButton*)ptr_to_cxObject)->GetWidth()   );
    return retVal;

}

void    CrButton::CalcLayout()
{

    int w = (int)(mWidthFactor  * (float)((CxButton*)ptr_to_cxObject)->GetIdealWidth() );
    int h = (int)(mHeightFactor * (float)((CxButton*)ptr_to_cxObject)->GetIdealHeight());
    ((CxButton*)ptr_to_cxObject)->SetGeometry(0,0,h,w);

}

void    CrButton::ButtonClicked()
{

    SendCommand(mName);

}

void CrButton::CrFocus()
{
    ((CxButton*)ptr_to_cxObject)->Focus();
}
