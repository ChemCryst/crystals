////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

//  $Log: not supported by cvs2svn $

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crlistbox.h"
//insert your own code here.
#include	"crwindow.h"
#include	"crgrid.h"
#include	"cxlistbox.h"
#include	"ccrect.h"
#include	"cccontroller.h"	// for sending commands


CrListBox::CrListBox( CrGUIElement * mParentPtr )
	:CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxListBox::CreateCxListBox( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = true;
}

	CrListBox::~CrListBox()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxListBox*)mWidgetPtr;
		mWidgetPtr = nil;
	}

}

Boolean	CrListBox::ParseInput( CcTokenList * tokenList )
{

	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	CcString theToken;
//t	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** ListBox *** Initing...");

		mName = tokenList->GetToken();
		mSelfInitialised = true;

		hasTokenForMe = true;
		while ( hasTokenForMe )
		{
			switch ( tokenList->GetDescriptor(kAttributeClass) )
			{
				case kTVisibleLines:
			 	{
			 		tokenList->GetToken(); // Remove the keyword
			 		int lines;
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

		LOGSTAT( "*** Created ListBox     " + mName );
	}
	// End of Init, now comes the general parser
	
	hasTokenForMe = true;
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kAttributeClass) )
		{
			case kTInform:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				mCallbackState = inform;
				if (mCallbackState)
                              LOGSTAT( "Enabling ListBox callback" );
				else
                              LOGSTAT( "Disabling ListBox callback" );
				break;
			}
			case kTAddToList:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean stop = false;
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
				break;
			}
                  case kTSetSelection:
                  {
                        tokenList->GetToken(); //Remove that token!
                        int select = atoi ( tokenList->GetToken().ToCString() );
                        ((CxListBox*)mWidgetPtr)->SetSelection(select); 
                  }
			default:
			{
				hasTokenForMe = false;
				break; // We leave the token in the list and exit the loop
			}
		}	
	}
	

	return ( retVal );

}

void	CrListBox::SetGeometry( const CcRect * rect )
{

	((CxListBox*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );

}

CcRect	CrListBox::GetGeometry()
{

	CcRect retVal(
			((CxListBox*)mWidgetPtr)->GetTop(), 
			((CxListBox*)mWidgetPtr)->GetLeft(),
			((CxListBox*)mWidgetPtr)->GetTop()+((CxListBox*)mWidgetPtr)->GetHeight(),
			((CxListBox*)mWidgetPtr)->GetLeft()+((CxListBox*)mWidgetPtr)->GetWidth()   );
	return retVal;

}

void	CrListBox::CalcLayout()
{

	int w =  ((CxListBox*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxListBox*)mWidgetPtr)->GetIdealHeight();
	((CxListBox*)mWidgetPtr)->SetGeometry(-1,-1,h,w);	

}

void	CrListBox::SetText( CcString item )
{

	char theText[256];
	strcpy( theText, item.ToCString() );

	( (CxListBox *)mWidgetPtr)->AddItem( theText );
	LOGSTAT( "Adding Item '" + item + "'");

}

void	CrListBox::GetValue()
{
	int value = ( (CxListBox *)mWidgetPtr)->GetBoxValue();
	SendCommand( CcString( value ) );
}


void CrListBox::GetValue(CcTokenList * tokenList)
{

	int desc = tokenList->GetDescriptor(kQueryClass);

	if( desc == kTQListtext )
	{
		tokenList->GetToken();
            int index = atoi ((tokenList->GetToken()).ToCString());
		char theText[256];
 //TODO. Wrap this call with a CxListBox function, rather that this base class.
            int textLen = ((CxListBox*)mWidgetPtr)->GetText(index - 1,&theText[0]);
		SendCommand( CcString( theText ), true );
	}
	else if (desc == kTQSelected )
	{
		tokenList->GetToken();
		int value = ( (CxListBox *)mWidgetPtr)->GetBoxValue();
		SendCommand( CcString( value ) , true );
	}
	else
	{
		SendCommand( "ERROR",true );
		CcString error = tokenList->GetToken();
		LOGWARN( "CrEditBox:GetValue Error unrecognised token." + error);
	}


}



void	CrListBox::Selected( int item )
{

	if (mCallbackState)
	{
		CcString theCommand;
		theCommand = mName;
		SendCommand(theCommand);
		theCommand = CcString( item );
		SendCommand(theCommand);
	}
}

void	CrListBox::Committed( int item )
{
	if (mCallbackState)
	{
		CcString theCommand;
		theCommand = mName;
		SendCommand(theCommand);
		theCommand = CcString( item );
		SendCommand(theCommand);
		((CrWindow*)GetRootWidget())->Committed();
	}
}

void CrListBox::CrFocus()
{
	((CxListBox*)mWidgetPtr)->Focus();	
}
