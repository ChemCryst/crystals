////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrText

////////////////////////////////////////////////////////////////////////

//   Filename:  CrText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:38 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crtext.h"
//insert your own code here.
#include	"crgrid.h"
#include	"cxtext.h"
#include	"ccrect.h"
#include	"cccontroller.h"	// for sending commands


// OPSignature:  CrText:CrText( CrGUIElement *:mParentPtr ) 
	CrText::CrText( CrGUIElement * mParentPtr )
//Insert your own initialization here.
	:	CrGUIElement( mParentPtr )
//End of user initialization.         
{
//Insert your own code here.
	mWidgetPtr = CxText::CreateCxText( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = false;
//End of user code.         
}
// OPSignature:  CrText:~CrText() 
	CrText::~CrText()
{
//Insert your own code here.
	if ( mWidgetPtr != nil )
	{
		delete (CxText*) mWidgetPtr;
		mWidgetPtr = nil;
	}
//End of user code.         
}
// OPSignature: Boolean CrText:ParseInput( CcTokenList *:tokenList ) 
Boolean	CrText::ParseInput( CcTokenList * tokenList )
{
//Insert your own code here.
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** Text *** Initing...");

		retVal = CrGUIElement::ParseInput( tokenList );
		mSelfInitialised = true;

		LOGSTAT( "*** Created Text        " + mName );
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
				LOGSTAT( "Setting Text to '" + mText );
				break;
			}
			case kTChars:
			{
				tokenList->GetToken(); // Remove that token!
				CcString theString = tokenList->GetToken();
				int chars = atoi( theString.ToCString() );
				((CxText*)mWidgetPtr)->SetVisibleChars( chars );
				LOGSTAT( "Setting Text Chars Width: " + theString );
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
// OPSignature: void CrText:SetText( CcString:text ) 
void	CrText::SetText( CcString text )
{
//Insert your own code here.
	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxText *)mWidgetPtr)->SetText( theText );
//End of user code.         
}
// OPSignature: void CrText:SetGeometry( const CcRect *:rect ) 
void	CrText::SetGeometry( const CcRect * rect )
{
//Insert your own code here.
	((CxText*)mWidgetPtr)->SetGeometry(		rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
//End of user code.         
}
// OPSignature: CcRect CrText:GetGeometry() 
CcRect	CrText::GetGeometry()
{
//Insert your own code here.
	CcRect retVal (
			((CxText*)mWidgetPtr)->GetTop(), 
			((CxText*)mWidgetPtr)->GetLeft(),
			((CxText*)mWidgetPtr)->GetTop()+((CxText*)mWidgetPtr)->GetHeight(),
			((CxText*)mWidgetPtr)->GetLeft()+((CxText*)mWidgetPtr)->GetWidth()   );
	return retVal;
//End of user code.         
}
// OPSignature: void CrText:CalcLayout() 
void	CrText::CalcLayout()
{
//Insert your own code here.
	int w =  ((CxText*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxText*)mWidgetPtr)->GetIdealHeight();
	((CxText*)mWidgetPtr)->SetGeometry(0,0,h,w);	
//End of user code.         
}

void CrText::CrFocus()
{

}
