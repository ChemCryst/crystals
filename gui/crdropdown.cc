////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrDropDown

////////////////////////////////////////////////////////////////////////

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crdropdown.h"
#include	"crgrid.h"
#include	"cxdropdown.h"
#include	"ccrect.h"
#include	"cctokenlist.h"
#include	"cccontroller.h"	// for sending commands


CrDropDown::CrDropDown( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxDropDown::CreateCxDropDown( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = true;
}

CrDropDown::~CrDropDown()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxDropDown*)mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean	CrDropDown::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	CcString theToken;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** DropDown *** Initing...");

		retVal = CrGUIElement::ParseInputNoText( tokenList );
		mSelfInitialised = true;

		LOGSTAT( "*** Created DropDown    " + mName );
	}
	// End of Init, now comes the general parser
	
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kAttributeClass) )
		{
			case kTInform:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				if(inform)
					LOGSTAT( "CrDropDown:ParseInput Dropdown INFORM on ");
				else
					LOGSTAT( "CrDropDown:ParseInput Dropdown INFORM off ");
				mCallbackState = inform;
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
						LOGSTAT("Adding DropDown text '" + theToken + "'");
					}
				}
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

void	CrDropDown::SetGeometry( const CcRect * rect )
{
	((CxDropDown*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
}

CcRect	CrDropDown::GetGeometry()
{
	CcRect retVal(
			((CxDropDown*)mWidgetPtr)->GetTop(), 
			((CxDropDown*)mWidgetPtr)->GetLeft(),
			((CxDropDown*)mWidgetPtr)->GetTop()+((CxDropDown*)mWidgetPtr)->GetHeight(),
			((CxDropDown*)mWidgetPtr)->GetLeft()+((CxDropDown*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void	CrDropDown::CalcLayout()
{
	int w =  ((CxDropDown*)mWidgetPtr)->GetIdealWidth();
	int h =  ((CxDropDown*)mWidgetPtr)->GetIdealHeight();
	((CxDropDown*)mWidgetPtr)->SetGeometry(0,0,h,w);	
}

void	CrDropDown::SetText( CcString item )
{
	char theText[256];
	strcpy( theText, item.ToCString() );

	( (CxDropDown *)mWidgetPtr)->AddItem( theText );
}

void	CrDropDown::GetValue()
{
	int value = ( (CxDropDown *)mWidgetPtr)->GetDropDownValue();
	
	SendCommand( CcString( value ) );
}



void	CrDropDown::GetValue(CcTokenList * tokenList)
{
	int desc = tokenList->GetDescriptor(kQueryClass);

	if( desc == kTQListtext )
	{
		tokenList->GetToken();
		CcString theString = tokenList->GetToken();
		int index = atoi( theString.ToCString() );
		CcString text = ( ( CxDropDown*)mWidgetPtr)->GetDropDownText(index);
		SendCommand( text,true );
	}
	else if (desc == kTQSelected )
	{
		int value = ( (CxDropDown *)mWidgetPtr)->GetDropDownValue();
		SendCommand( CcString( value ), true );
	}
	else
	{
		SendCommand( "ERROR",true );
		CcString error = tokenList->GetToken();
		LOGWARN( "CrDropDown:GetValue Error unrecognised token." + error);
	}
}

void	CrDropDown::Selected( int item )
{
	if(mCallbackState)
	{
		CcString theItem;
		theItem = CcString( item );
		SendCommand(mName + "_N" + theItem);

	}
}

void CrDropDown::CrFocus()
{
	((CxDropDown*)mWidgetPtr)->Focus();	
}
