////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.cpp
//   Authors:   Richard Cooper
//   Created:   22.2.1998 14:43 Hours
//   Modified:  3.6.1999 16:46 Hours 

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crprogress.h"
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

      mControllerPtr->RemoveProgressOutputPlace(this);
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
}

void	CrProgress::SetText( CcString text )
{
	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxProgress *)mWidgetPtr)->SetText( theText );
}

void	CrProgress::SetGeometry( const CcRect * rect )
{
	((CxProgress*)mWidgetPtr)->SetGeometry(		rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
}
CcRect	CrProgress::GetGeometry()
{
	CcRect retVal (
			((CxProgress*)mWidgetPtr)->GetTop(), 
			((CxProgress*)mWidgetPtr)->GetLeft(),
			((CxProgress*)mWidgetPtr)->GetTop()+((CxProgress*)mWidgetPtr)->GetHeight(),
			((CxProgress*)mWidgetPtr)->GetLeft()+((CxProgress*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void	CrProgress::CalcLayout()
{
	int w =  ((CxProgress*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxProgress*)mWidgetPtr)->GetIdealHeight();
	((CxProgress*)mWidgetPtr)->SetGeometry(0,0,h,w);	
}

void CrProgress::CrFocus()
{

}
