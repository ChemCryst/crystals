////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListCtrl.cc
//   Authors:   Richard Cooper
//   Created:   10.11.1998 16:36
//   Modified:  10.11.1998 16:36

#include	"CrystalsInterface.h"
#include	"CrConstants.h"
#include	"CrListCtrl.h"
#include	"CrWindow.h"
#include	"CrGrid.h"
#include	"CxListCtrl.h"
#include	"CcRect.h"
#include	"CcController.h"	// for sending commands

CrListCtrl::CrListCtrl( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxListCtrl::CreateCxListCtrl( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mXCanResize = true;
	mYCanResize = true;
	mTabStop = true;
	m_cols = 0;
}

CrListCtrl::~CrListCtrl()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxListCtrl*)mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean	CrListCtrl::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	CcString theToken;
	
	if( ! mSelfInitialised ) //Once Only.
	{	
		LOGSTAT("*** ListCtrl *** Initing...");

		mName = tokenList->GetToken();
		mSelfInitialised = true;

		LOGSTAT( "*** Created ListCtrl     " + mName );
	
		while ( hasTokenForMe )
		{
			switch ( tokenList->GetDescriptor(kAttributeClass) )
			{
				case kTVisibleLines:
			 	{
		 			int lines;
		 			tokenList->GetToken(); // Remove the keyword
					CcString theToken = tokenList->GetToken();
					lines = atoi( theToken.ToCString() );
					( (CxListCtrl *)mWidgetPtr)->SetVisibleLines( lines );
					LOGSTAT("Setting ListCtrl visible lines to " + theToken);
					break;
				}
				case kTNumberOfColumns:
				{
			 		tokenList->GetToken(); // Remove the keyword
					CcString theToken = tokenList->GetToken();
					m_cols = atoi( theToken.ToCString() );
					LOGSTAT("Setting ListCtrl columns to " + theToken);
					for (int k = 0; k < m_cols; k++)
					{
						theToken = tokenList->GetToken();
						((CxListCtrl *)mWidgetPtr)->AddColumn( theToken );
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
		
	}
	hasTokenForMe = true;
	while ( hasTokenForMe ) //Every time
	{
		switch ( tokenList->GetDescriptor(kAttributeClass) )
		{

			case kTCallback:
		 	{
				mCallbackState = true;
				tokenList->GetToken(); // Remove that token!
				LOGSTAT("Enabling ListCtrl callback");
				break;
			}
			case kTIgnore:
			{
				mCallbackState = false;
				tokenList->GetToken(); // Remove that token!
				LOGSTAT( "Disabling EditBox callback" );
				break;
			}
			case kTAddToList:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean stop = false;
				while ( ! stop ) 
				{
					CcString* rowOfStrings = new CcString[m_cols];
		
					for (int k = 0; k < m_cols; k++)
					{
						theToken = tokenList->GetToken();
						
						if ( strcmp( kSNull, theToken.ToCString() ) == 0 )
						{
							stop = true;
							k = m_cols;
						}
						else
						{
							rowOfStrings[k] = theToken;
						}
					}
					if( ! stop ) ((CxListCtrl *)mWidgetPtr)->AddRow( rowOfStrings );
					delete [] rowOfStrings; //Oops, forgot this first time!
				}
				break;
			}
			case kTSelectAtoms:
			{
				tokenList->GetToken(); //Remove the kTSelectAtoms token!
				if( tokenList->GetDescriptor(kLogicalClass) == kTAll)
				{
					tokenList->GetToken(); //Remove the kTAll token!
					Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
					tokenList->GetToken(); //Remove the kTYes/No token!
					((CxListCtrl *)mWidgetPtr)->SelectAll(select);
				}
				else if( tokenList->GetDescriptor(kLogicalClass) == kTInvert)
				{
					tokenList->GetToken(); //Remove the kTInvert token!
					((CxListCtrl *)mWidgetPtr)->InvertSelection();
				}
				else
				{
					CcString* rowOfStrings = new CcString[m_cols];
					for (int k = 0; k < m_cols; k++)
						rowOfStrings[k] = tokenList->GetToken();
	
					Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
					tokenList->GetToken();
					((CxListCtrl*)mWidgetPtr)->SelectPattern(rowOfStrings,select);
					delete [] rowOfStrings;
				}
				break;
			}
			case kTGetItem:
			{
				tokenList->GetToken();
				CcString theString = tokenList->GetToken();
				int itemNo = atoi( theString.ToCString() );
				CcString result = ((CxListCtrl*)mWidgetPtr)->GetListItem(itemNo);
				(CcController::theController)->SendCommand(result, true);
				break;
			}
			case kTSelectAction:
			{
				tokenList->GetToken(); // Remove that token!
				switch ( tokenList->GetDescriptor(kAttributeClass) )
				{
					case kTSendIndex:
						tokenList->GetToken();
						((CxListCtrl*)mWidgetPtr)->m_SendIndex = true;
						break;
					case kTSendLine:
						tokenList->GetToken();
						((CxListCtrl*)mWidgetPtr)->m_SendIndex = false;
						break;
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

	return ( retVal );
}

void	CrListCtrl::SetGeometry( const CcRect * rect )
{

	((CxListCtrl*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
}

CcRect	CrListCtrl::GetGeometry()
{

	CcRect retVal(
			((CxListCtrl*)mWidgetPtr)->GetTop(), 
			((CxListCtrl*)mWidgetPtr)->GetLeft(),
			((CxListCtrl*)mWidgetPtr)->GetTop()+((CxListCtrl*)mWidgetPtr)->GetHeight(),
			((CxListCtrl*)mWidgetPtr)->GetLeft()+((CxListCtrl*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void	CrListCtrl::CalcLayout()
{
	int w = (int)(mWidthFactor  * (float)((CxListCtrl*)mWidgetPtr)->GetIdealWidth() );
	int h = (int)(mHeightFactor * (float)((CxListCtrl*)mWidgetPtr)->GetIdealHeight());
	((CxListCtrl*)mWidgetPtr)->SetGeometry(-1,-1,h,w);	
}

void	CrListCtrl::SetText( CcString item )
{
	LOGWARN( "CrListCtrl:SetText Don't add text to a ListCtrl.");
}

void	CrListCtrl::GetValue()
{
	int value = ( (CxListCtrl *)mWidgetPtr)->GetValue();
	SendCommand( CcString( value ) );
}

void CrListCtrl::CrFocus()
{
	((CxListCtrl*)mWidgetPtr)->Focus();	
}

int CrListCtrl::GetIdealWidth()
{
	return ((CxListCtrl*)mWidgetPtr)->GetIdealWidth();
}

int CrListCtrl::GetIdealHeight()
{
	return ((CxListCtrl*)mWidgetPtr)->GetIdealHeight();
}

void CrListCtrl::SendValue(CcString message)
{
	if(mCallbackState)
		SendCommand(message);
}
