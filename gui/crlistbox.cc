////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

#include	"CrystalsInterface.h"
#include	"CrConstants.h"
#include	"CrListBox.h"
//Insert your own code here.
#include	"CrWindow.h"
#include	"CrGrid.h"
#include	"CxListBox.h"
#include	"CcRect.h"
#include	"CcController.h"	// for sending commands


// OPSignature:  CrListBox:CrListBox( CrGUIElement *:mParentPtr ) 
	CrListBox::CrListBox( CrGUIElement * mParentPtr )
//Insert your own initialization here.
	:	CrGUIElement( mParentPtr )
//End of user initialization.         
{
//Insert your own code here.
	mWidgetPtr = CxListBox::CreateCxListBox( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = true;
//End of user code.         
}
// OPSignature:  CrListBox:~CrListBox() 
	CrListBox::~CrListBox()
{
//Insert your own code here.
	if ( mWidgetPtr != nil )
	{
		delete (CxListBox*)mWidgetPtr;
		mWidgetPtr = nil;
	}
//End of user code.         
}
// OPSignature: Boolean CrListBox:ParseInput( CcTokenList *:tokenList ) 
Boolean	CrListBox::ParseInput( CcTokenList * tokenList )
{
//Insert your own code here.
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	CcString theToken;
	Boolean stop = false;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** ListBox *** Initing...");

		mName = tokenList->GetToken();
		mSelfInitialised = true;

		LOGSTAT( "*** Created ListBox     " + mName );
	}
	// End of Init, now comes the general parser
	
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kAttributeClass) )
		{
			case kTCallback:
		 	{
				mCallbackState = true;
				tokenList->GetToken(); // Remove that token!
				LOGSTAT("Enabling ListBox callback");
				break;
			}
			case kTVisibleLines:
		 	{
		 		int lines = 0;
		 		tokenList->GetToken(); // Remove the keyword
				CcString theToken = tokenList->GetToken();
				lines = atoi( theToken.ToCString() );
				( (CxListBox *)mWidgetPtr)->SetVisibleLines( lines );
				LOGSTAT("Setting ListBox visible lines to " + theToken);
				break;
			}

			default:
			{
				hasTokenForMe = false;
				break; // We leave the token in the list and exit the loop
			}
		}	
	}
	
	while ( ! stop ) 
	{
		theToken = tokenList->GetToken();
		
		if ( strcmp( kSNull, theToken.ToCString() ) == 0 )
			stop = true;
		else
		{
			SetText( theToken );
			LOGSTAT("Adding ListBox text '" + theToken + "'");
		}
	}

	return ( retVal );
//End of user code.         
}
// OPSignature: void CrListBox:SetGeometry( const CcRect *:rect ) 
void	CrListBox::SetGeometry( const CcRect * rect )
{
//Insert your own code here.
	((CxListBox*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
//End of user code.         
}
// OPSignature: CcRect CrListBox:GetGeometry() 
CcRect	CrListBox::GetGeometry()
{
//Insert your own code here.
	CcRect retVal(
			((CxListBox*)mWidgetPtr)->GetTop(), 
			((CxListBox*)mWidgetPtr)->GetLeft(),
			((CxListBox*)mWidgetPtr)->GetTop()+((CxListBox*)mWidgetPtr)->GetHeight(),
			((CxListBox*)mWidgetPtr)->GetLeft()+((CxListBox*)mWidgetPtr)->GetWidth()   );
	return retVal;
//End of user code.         
}
// OPSignature: void CrListBox:CalcLayout() 
void	CrListBox::CalcLayout()
{
//Insert your own code here.
	int w =  ((CxListBox*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxListBox*)mWidgetPtr)->GetIdealHeight();
	((CxListBox*)mWidgetPtr)->SetGeometry(-1,-1,h,w);	
//End of user code.         
}
// OPSignature: void CrListBox:SetText( CcString:item ) 
void	CrListBox::SetText( CcString item )
{
//Insert your own code here.
	char theText[256];
	strcpy( theText, item.ToCString() );

	( (CxListBox *)mWidgetPtr)->AddItem( theText );
	LOGSTAT( "Adding Item '" + item + "'");
//End of user code.         
}
// OPSignature: void CrListBox:GetValue() 
void	CrListBox::GetValue()
{
//Insert your own code here.
	int value = ( (CxListBox *)mWidgetPtr)->GetBoxValue();
	
	SendCommand( CcString( value ) );
//End of user code.         
}
// OPSignature: void CrListBox:Selected( int:item ) 
void	CrListBox::Selected( int item )
{
//Insert your own code here.
	CcString theCommand;
	theCommand = mName;
	SendCommand(theCommand);
	theCommand = CcString( item );
	SendCommand(theCommand);
//End of user code.         
}

void	CrListBox::Committed( int item )
{
//Insert your own code here.
	CcString theCommand;
	theCommand = mName;
	SendCommand(theCommand);
	theCommand = CcString( item );
	SendCommand(theCommand);
	((CrWindow*)GetRootWidget())->Committed();
//End of user code.         
}

void CrListBox::CrFocus()
{
	((CxListBox*)mWidgetPtr)->Focus();	
}
