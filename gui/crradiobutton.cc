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


// OPSignature:  CrRadioButton:CrRadioButton( CrGUIElement *:mParentPtr ) 
	CrRadioButton::CrRadioButton( CrGUIElement * mParentPtr )
//Insert your own initialization here.
	:	CrGUIElement( mParentPtr )
//End of user initialization.         
{
//Insert your own code here.
	mWidgetPtr = CxRadioButton::CreateCxRadioButton( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = true;
//End of user code.         
}
// OPSignature:  CrRadioButton:~CrRadioButton() 
	CrRadioButton::~CrRadioButton()
{
//Insert your own code here.
	if ( mWidgetPtr != nil )
	{
		delete (CxRadioButton*)mWidgetPtr;
		mWidgetPtr = nil;
	}
//End of user code.         
}
// OPSignature: Boolean CrRadioButton:ParseInput( CcTokenList *:tokenList ) 
Boolean	CrRadioButton::ParseInput( CcTokenList * tokenList )
{
//Insert your own code here.
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
//End of user code.         
}
// OPSignature: void CrRadioButton:SetText( CcString:text ) 
void	CrRadioButton::SetText( CcString text )
{
//Insert your own code here.
	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxRadioButton *)mWidgetPtr)->SetText( theText );
//End of user code.         
}
// OPSignature: void CrRadioButton:SetGeometry( const CcRect *:rect ) 
void	CrRadioButton::SetGeometry( const CcRect * rect )
{
//Insert your own code here.
	((CxRadioButton*)mWidgetPtr)->SetGeometry(	rect->mTop,
												rect->mLeft,
												rect->mBottom,
												rect->mRight );
//End of user code.         
}
// OPSignature: CcRect CrRadioButton:GetGeometry() 
CcRect	CrRadioButton::GetGeometry()
{
//Insert your own code here.
	 CcRect retVal(
			((CxRadioButton*)mWidgetPtr)->GetTop(), 
			((CxRadioButton*)mWidgetPtr)->GetLeft(),
			((CxRadioButton*)mWidgetPtr)->GetTop()+((CxRadioButton*)mWidgetPtr)->GetHeight(),
			((CxRadioButton*)mWidgetPtr)->GetLeft()+((CxRadioButton*)mWidgetPtr)->GetWidth()   );
	return retVal;
//End of user code.         
}
// OPSignature: void CrRadioButton:CalcLayout() 
void	CrRadioButton::CalcLayout()
{
//Insert your own code here.
	int w =  ((CxRadioButton*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxRadioButton*)mWidgetPtr)->GetIdealHeight();
	((CxRadioButton*)mWidgetPtr)->SetGeometry(0,0,h,w);	
//End of user code.         
}
// OPSignature: void CrRadioButton:GetValue() 
void	CrRadioButton::GetValue()
{
//Insert your own code here.
	CcString stateString;
	if ( ((CxRadioButton*)mWidgetPtr)->GetRadioState() )
		stateString = kSOn;
	else
		stateString = kSOff;
	SendCommand( stateString );
//End of user code.         
}
// OPSignature: void CrRadioButton:ButtonChanged( Boolean:state ) 
void	CrRadioButton::ButtonOn()
{
//Insert your own code here.
	if ( mCallbackState )
	{
		SendCommand(mName);
	}
//End of user code.         
}
// OPSignature: void CrRadioButton:SetState( Boolean:state ) 
void	CrRadioButton::SetState( Boolean state )
{
//Insert your own code here.
	((CxRadioButton*)mWidgetPtr)->SetRadioState(state);	
//End of user code.         
}

void CrRadioButton::CrFocus()
{
	((CxRadioButton*)mWidgetPtr)->Focus();	
}
