////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrRadioButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:29 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crradiobutton.h"
//insert your own code here.
#include	"crgrid.h"
#include	"cxradiobutton.h"
#include	"ccrect.h"
#include	"cccontroller.h"	// for sending commands


CrRadioButton::CrRadioButton( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxRadioButton::CreateCxRadioButton( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = true;
}

CrRadioButton::~CrRadioButton()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxRadioButton*)mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean	CrRadioButton::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
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
			case kTCallback:
			{
				tokenList->GetToken(); // Remove that token!
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

void	CrRadioButton::SetText( CcString text )
{
	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxRadioButton *)mWidgetPtr)->SetText( theText );
}

void	CrRadioButton::SetGeometry( const CcRect * rect )
{
	((CxRadioButton*)mWidgetPtr)->SetGeometry(	rect->mTop,
												rect->mLeft,
												rect->mBottom,
												rect->mRight );
}

CcRect	CrRadioButton::GetGeometry()
{
	 CcRect retVal(
			((CxRadioButton*)mWidgetPtr)->GetTop(), 
			((CxRadioButton*)mWidgetPtr)->GetLeft(),
			((CxRadioButton*)mWidgetPtr)->GetTop()+((CxRadioButton*)mWidgetPtr)->GetHeight(),
			((CxRadioButton*)mWidgetPtr)->GetLeft()+((CxRadioButton*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void	CrRadioButton::CalcLayout()
{
	int w =  ((CxRadioButton*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxRadioButton*)mWidgetPtr)->GetIdealHeight();
	((CxRadioButton*)mWidgetPtr)->SetGeometry(0,0,h,w);	
}

void	CrRadioButton::GetValue()
{
	CcString stateString;
	if ( ((CxRadioButton*)mWidgetPtr)->GetRadioState() )
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
            if ( ((CxRadioButton*)mWidgetPtr)->GetRadioState() )
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




void	CrRadioButton::ButtonOn()
{
	if ( mCallbackState )
	{
		SendCommand(mName);
	}
}

void	CrRadioButton::SetState( Boolean state )
{

	((CxRadioButton*)mWidgetPtr)->SetRadioState(state);
}

void CrRadioButton::CrFocus()
{
	((CxRadioButton*)mWidgetPtr)->Focus();	
}
