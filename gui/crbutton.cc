////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

#include	"CrystalsInterface.h"
#include    "CrConstants.h"
#include	"CrButton.h"
#include	"CrWindow.h"

#include	"CrGrid.h"
#include	"CxButton.h"
#include	"CcRect.h"
#include	"CcTokenList.h"
#include	"CcController.h"	// for sending commands


CrButton::CrButton( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxButton::CreateCxButton( this,
								(CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = true;
	mCallbackState= true;
}

CrButton::~CrButton()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxButton*)mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean	CrButton::ParseInput( CcTokenList * tokenList )
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
				((CxButton*)mWidgetPtr)->Disable( disabled );
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
				((CxButton*)mWidgetPtr)->SetDefault();
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

void	CrButton::SetText( CcString text )
{

	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxButton *)mWidgetPtr)->SetText( theText );

}

void	CrButton::SetGeometry( const CcRect * rect )
{

	((CxButton*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );

}

CcRect	CrButton::GetGeometry()
{

	CcRect retVal (	((CxButton*)mWidgetPtr)->GetTop(), 
					((CxButton*)mWidgetPtr)->GetLeft(),
					((CxButton*)mWidgetPtr)->GetTop()+ ((CxButton*)mWidgetPtr)->GetHeight(),
					((CxButton*)mWidgetPtr)->GetLeft()+((CxButton*)mWidgetPtr)->GetWidth()   );
	return retVal;

}

void	CrButton::CalcLayout()
{

	int w = (int)(mWidthFactor  * (float)((CxButton*)mWidgetPtr)->GetIdealWidth() );
	int h = (int)(mHeightFactor * (float)((CxButton*)mWidgetPtr)->GetIdealHeight());
	((CxButton*)mWidgetPtr)->SetGeometry(0,0,h,w);	

}

void	CrButton::ButtonClicked()
{

	SendCommand(mName);

}

void CrButton::CrFocus()
{
	((CxButton*)mWidgetPtr)->Focus();	
}
