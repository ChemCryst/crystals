////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrRadioButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crradiobutton.h"
#include    "crgrid.h"
#include    "cxgrid.h"
#include    "cxradiobutton.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrRadioButton::CrRadioButton( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxRadioButton::CreateCxRadioButton( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
}

CrRadioButton::~CrRadioButton()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxRadioButton*)ptr_to_cxObject)->DestroyWindow(); delete (CxRadioButton*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
}


CRSETGEOMETRY(CrRadioButton,CxRadioButton)
CRGETGEOMETRY(CrRadioButton,CxRadioButton)
CRCALCLAYOUT(CrRadioButton,CxRadioButton)

CcParse CrRadioButton::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("RadioButton Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "Created RadioButton " + mName );
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
                LOGSTAT( "Setting RadioButton Text: " + mText );
                break;
            }
            case kTInform:
            {
                mCallbackState = true;
                tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Enabling RadioButton callback" );
                break;
            }
            case kTIgnore:
            {
                mCallbackState = false;
                tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Disabling RadioButton callback" );
                break;
            }
            case kTDisabled:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean disabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                if(disabled)
                    LOGSTAT( "CrRadiobutton:ParseInput "+mName+" disabled ");
                else
                    LOGSTAT( "CrRadiobutton:ParseInput "+mName+" enabled ");
                ((CxRadioButton*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTState:
            {
                tokenList->GetToken(); // Remove that token!
                break;
            }
            case kTOn:
            {
                SetState( true );
                tokenList->GetToken(); // Remove that token!
                LOGSTAT( "RadioButton State turned on" );
                break;
            }
            case kTOff:
            {
                SetState( false );
                tokenList->GetToken(); // Remove that token!
                LOGSTAT( "RadioButton State turned off" );
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

void    CrRadioButton::SetText( CcString text )
{
    char theText[256];
    strcpy( theText, text.ToCString() );

    ( (CxRadioButton *)ptr_to_cxObject)->SetText( theText );
}

void    CrRadioButton::GetValue()
{
    CcString stateString;
    if ( ((CxRadioButton*)ptr_to_cxObject)->GetRadioState() )
        stateString = kSOn;
    else
        stateString = kSOff;
    SendCommand( stateString );
}

void  CrRadioButton::GetValue( CcTokenList * tokenList )
{
    CcString stateString;

      if( tokenList->GetDescriptor(kQueryClass) == kTQState )
      {
            tokenList->GetToken();
            if ( ((CxRadioButton*)ptr_to_cxObject)->GetRadioState() )
                  stateString = kSOn;
            else
                  stateString = kSOff;
            SendCommand( stateString,true);
      }
      else
      {
            SendCommand( "ERROR",true );
            stateString = tokenList->GetToken();
            LOGWARN( "CrCheckBox:GetValue Error unrecognised token." + stateString );
      }
}




void    CrRadioButton::ButtonOn()
{
    if ( mCallbackState )
    {
        SendCommand(mName);
    }
}

void    CrRadioButton::SetState( Boolean state )
{

    ((CxRadioButton*)ptr_to_cxObject)->SetRadioState(state);
}

void CrRadioButton::CrFocus()
{
    ((CxRadioButton*)ptr_to_cxObject)->Focus();
}
