////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrCheckBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:41 Uhr

#include	"CrystalsInterface.h"
#include	"CrConstants.h"
#include	"CrCheckBox.h"

#include	"CrGrid.h"
#include	"CxCheckBox.h"
#include	"CcRect.h"
#include	"CcTokenList.h"
#include	"CcController.h"	// for sending commands

CrCheckBox::CrCheckBox( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxCheckBox::CreateCxCheckBox( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = true;
}

CrCheckBox::~CrCheckBox()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxCheckBox*)mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean	CrCheckBox::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** CheckBox *** Initing...");

		retVal = CrGUIElement::ParseInput( tokenList );
		mSelfInitialised = true;

		LOGSTAT( "*** Created CheckBox    " + mName );
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
				LOGSTAT( "Setting CheckBox Text: " + mText );
				break;
			}
			case kTInform:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				if(inform)
					LOGSTAT( "CrCheckBox:ParseInput Checkbox INFORM on ");
				else
					LOGSTAT( "CrCheckBox:ParseInput Checkbox INFORM off ");
				mCallbackState = inform;
				break;
			}
			case kTDisabled:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean disabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				if(disabled)
					LOGSTAT( "CrCheckBox:ParseInput Checkbox disabled ");
				else
					LOGSTAT( "CrCheckBox:ParseInput Checkbox enabled ");
				((CxCheckBox*)mWidgetPtr)->Disable( disabled );
				break;
			}
			case kTState:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTOn) ? true : false;
				tokenList->GetToken(); // Remove that token!
				if(state)
					LOGSTAT( "CrCheckBox:ParseInput Checkbox STATE on ");
				else
					LOGSTAT( "CrCheckBox:ParseInput Checkbox STATE off ");
				SetState(state);
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
// OPSignature: void CrCheckBox:SetText( CcString:text ) 
void	CrCheckBox::SetText( CcString text )
{
//Insert your own code here.
	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxCheckBox *)mWidgetPtr)->SetText( theText );
//End of user code.         
}
// OPSignature: void CrCheckBox:SetGeometry( const CcRect *:rect ) 
void	CrCheckBox::SetGeometry( const CcRect * rect )
{
//Insert your own code here.
	((CxCheckBox*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
//End of user code.         
}
// OPSignature: CcRect CrCheckBox:GetGeometry() 
CcRect	CrCheckBox::GetGeometry()
{
//Insert your own code here.
	CcRect retVal	(((CxCheckBox*)mWidgetPtr)->GetTop(), 
					 ((CxCheckBox*)mWidgetPtr)->GetLeft(),
					 ((CxCheckBox*)mWidgetPtr)->GetTop()+((CxCheckBox*)mWidgetPtr)->GetHeight(),
					 ((CxCheckBox*)mWidgetPtr)->GetLeft()+((CxCheckBox*)mWidgetPtr)->GetWidth() );
	return retVal;
//End of user code.         
}
// OPSignature: void CrCheckBox:CalcLayout() 
void	CrCheckBox::CalcLayout()
{

	int w =  ((CxCheckBox*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxCheckBox*)mWidgetPtr)->GetIdealHeight();
	((CxCheckBox*)mWidgetPtr)->SetGeometry(0,0,h,w);	

}

void	CrCheckBox::GetValue()
{

	CcString stateString;
	if ( ((CxCheckBox*)mWidgetPtr)->GetBoxState() )
		stateString = kSOn;
	else
		stateString = kSOff;
	SendCommand( stateString );

}

void	CrCheckBox::GetValue(CcTokenList * tokenList)
{
	CcString stateString;
	if( tokenList->GetDescriptor(kQueryClass) == kTQState )
	{
		tokenList->GetToken();
		if ( ((CxCheckBox*)mWidgetPtr)->GetBoxState() )
			stateString = kSOn;
		else
			stateString = kSOff;
		SendCommand( stateString,true);
	}
	else
	{
		SendCommand( "ERROR",true );
		stateString = tokenList->GetToken();
		LOGWARN( "CrCheckBox:GetValue Error unrecognised token." + stateString);
	}
}

void	CrCheckBox::BoxChanged( Boolean state )
{
	if(mCallbackState)
	{
		CcString stateString;
		if ( state )
			stateString = kSOn;
		else
			stateString = kSOff;
		SendCommand(mName + "_N" + stateString);
	}
//End of user code.         
}
// OPSignature: void CrCheckBox:SetState( Boolean:state ) 
void	CrCheckBox::SetState( Boolean state )
{
//Insert your own code here.
	((CxCheckBox*)mWidgetPtr)->SetBoxState(state);	
//End of user code.         
}

void CrCheckBox::CrFocus()
{
	((CxCheckBox*)mWidgetPtr)->Focus();	
}
