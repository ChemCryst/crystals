////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:38 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crprogress.h"
//insert your own code here.
#include	"crgrid.h"
#include	"cxprogress.h"
#include	"ccrect.h"
#include	"cccontroller.h"	// for sending commands


CrProgress::CrProgress( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxProgress::CreateCxProgress( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = false;
}
	CrProgress::~CrProgress()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxProgress*) mWidgetPtr;
		mWidgetPtr = nil;
	}

	if ( mControllerPtr->GetProgressOutputPlace() == this )
	{
		mControllerPtr->RemoveProgressOutputPlace();
	}

}

Boolean	CrProgress::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
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
				tokenList->GetToken(); // Remove that token!
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
				((CxProgress*)mWidgetPtr)->SetVisibleChars( chars );
				LOGSTAT( "Setting Text Chars Width: " + theString );
				break;
			}
			case kTComplete:
			{
				tokenList->GetToken(); // Remove that token!
				CcString theString = tokenList->GetToken();
				int complete = atoi( theString.ToCString() );
				((CxProgress*)mWidgetPtr)->SetProgress( complete );
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
//End of user code.         
}
// OPSignature: void CrProgress:SetText( CcString:text ) 
void	CrProgress::SetText( CcString text )
{
//Insert your own code here.
	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxProgress *)mWidgetPtr)->SetText( theText );
//End of user code.         
}
// OPSignature: void CrProgress:SetGeometry( const CcRect *:rect ) 
void	CrProgress::SetGeometry( const CcRect * rect )
{
//Insert your own code here.
	((CxProgress*)mWidgetPtr)->SetGeometry(		rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
//End of user code.         
}
// OPSignature: CcRect CrProgress:GetGeometry() 
CcRect	CrProgress::GetGeometry()
{
//Insert your own code here.
	CcRect retVal (
			((CxProgress*)mWidgetPtr)->GetTop(), 
			((CxProgress*)mWidgetPtr)->GetLeft(),
			((CxProgress*)mWidgetPtr)->GetTop()+((CxProgress*)mWidgetPtr)->GetHeight(),
			((CxProgress*)mWidgetPtr)->GetLeft()+((CxProgress*)mWidgetPtr)->GetWidth()   );
	return retVal;
//End of user code.         
}
// OPSignature: void CrProgress:CalcLayout() 
void	CrProgress::CalcLayout()
{
//Insert your own code here.
	int w =  ((CxProgress*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxProgress*)mWidgetPtr)->GetIdealHeight();
	((CxProgress*)mWidgetPtr)->SetGeometry(0,0,h,w);	
//End of user code.         
}

void CrProgress::CrFocus()
{

}
