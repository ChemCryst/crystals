////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrRadioButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.8  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.7  2001/06/17 15:14:14  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.6  2001/03/08 15:42:39  richard
//   Included a DISABLED= token for radiobutton (at last).
//

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
        ((CxRadioButton*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
        delete (CxRadioButton*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}


CRSETGEOMETRY(CrRadioButton,CxRadioButton)
CRGETGEOMETRY(CrRadioButton,CxRadioButton)
CRCALCLAYOUT(CrRadioButton,CxRadioButton)

CcParse CrRadioButton::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("RadioButton Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "Created RadioButton " + mName );
    }
    // End of Init, now comes the general parser
    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTTextSelector:
            {
                tokenList.pop_front(); // Remove that token!
                mText = string(tokenList.front());
                tokenList.pop_front();
                SetText( mText );
                LOGSTAT( "Setting RadioButton Text: " + mText );
                break;
            }
            case kTInform:
            {
                mCallbackState = true;
                tokenList.pop_front(); // Remove that token!
                LOGSTAT( "Enabling RadioButton callback" );
                break;
            }
            case kTIgnore:
            {
                mCallbackState = false;
                tokenList.pop_front(); // Remove that token!
                LOGSTAT( "Disabling RadioButton callback" );
                break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                bool disabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(disabled)
                    LOGSTAT( "CrRadiobutton:ParseInput "+mName+" disabled ");
                else
                    LOGSTAT( "CrRadiobutton:ParseInput "+mName+" enabled ");
                ((CxRadioButton*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTState:
            {
                tokenList.pop_front(); // Remove that token!
                break;
            }
            case kTOn:
            {
                SetState( true );
                tokenList.pop_front(); // Remove that token!
                LOGSTAT( "RadioButton State turned on" );
                break;
            }
            case kTOff:
            {
                SetState( false );
                tokenList.pop_front(); // Remove that token!
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

void    CrRadioButton::SetText( const string &text )
{
    char theText[256];
    strcpy( theText, text.c_str() );

    ( (CxRadioButton *)ptr_to_cxObject)->SetText( theText );
}

void    CrRadioButton::GetValue()
{
    if ( ((CxRadioButton*)ptr_to_cxObject)->GetRadioState() )
        SendCommand( kSOn );
    else
        SendCommand( kSOff );
}

void  CrRadioButton::GetValue( deque<string> &  tokenList )
{
      if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQState )
      {
            tokenList.pop_front();
            if ( ((CxRadioButton*)ptr_to_cxObject)->GetRadioState() )
                SendCommand( kSOn,true);
            else
                SendCommand( kSOff,true);
      }
      else
      {
            SendCommand( "ERROR",true );
            LOGWARN( "CrCheckBox:GetValue Error unrecognised token." + tokenList.front() );
            tokenList.pop_front();
      }
}




void    CrRadioButton::ButtonOn()
{
    if ( mCallbackState )
    {
        SendCommand(mName);
    }
}

void    CrRadioButton::SetState( bool state )
{

    ((CxRadioButton*)ptr_to_cxObject)->SetRadioState(state);
}

void CrRadioButton::CrFocus()
{
    ((CxRadioButton*)ptr_to_cxObject)->Focus();
}
