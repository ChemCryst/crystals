////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   06.3.1998 00:04 Uhr
//   Modified:  06.3.1998 00:04 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include 	"ccrect.h"
#include	"crmultiedit.h"
//insert your own code here.
#include	"crgrid.h"
#include	"cccontroller.h"
#include	"cxmultiedit.h"
//End of user code.          

// OPSignature:  CrMultiEdit:CrMultiEdit( CrGUIElement *:mParentPtr ) 
	CrMultiEdit::CrMultiEdit( CrGUIElement * mParentPtr )
//Insert your own initialization here.
	:	CrGUIElement( mParentPtr )
//End of user initialization.         
{
//Insert your own code here.
	mWidgetPtr = CxMultiEdit::CreateCxMultiEdit( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mXCanResize = true;
	mYCanResize = true;
	mTabStop = true;
	mNoEcho = false;
//End of user code.         
}
// OPSignature:  CrMultiEdit:~CrMultiEdit() 
	CrMultiEdit::~CrMultiEdit()
{
//Insert your own code here.
	if ( mWidgetPtr != nil )
	{
		delete (CxMultiEdit*)mWidgetPtr;
		mWidgetPtr = nil;
	}
	if ( mControllerPtr->GetTextOutputPlace() == this )
	{
		mControllerPtr->RemoveTextOutputPlace();
	}
//End of user code.         
}
// OPSignature: Boolean CrMultiEdit:ParseInput( CcTokenList *:tokenList ) 
Boolean	CrMultiEdit::ParseInput( CcTokenList * tokenList )
{
//Insert your own code here.
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** MultiEdit *** Initing...");

		retVal = CrGUIElement::ParseInput( tokenList );
		mSelfInitialised = true;

		LOGSTAT( "*** Created MulitEdit    " + mName );
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
				LOGSTAT( "Setting MultiEdit Text: " + mText );
				break;
			}
			case kTNumberOfRows:
			{
				tokenList->GetToken(); // Remove that token!
				CcString theString = tokenList->GetToken();
				int chars = atoi( theString.ToCString() );
				((CxMultiEdit*)mWidgetPtr)->SetIdealHeight( chars );
				LOGSTAT( "Setting MultiEdit Lines Height: " + theString );
				break;
			}
			case kTNumberOfColumns:
			{
				tokenList->GetToken(); // Remove that token!
				CcString theString = tokenList->GetToken();
				int chars = atoi( theString.ToCString() );
				((CxMultiEdit*)mWidgetPtr)->SetIdealWidth( chars );
				LOGSTAT( "Setting MultiEdit Chars Width: " + theString );
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
				LOGSTAT( "Enabling EditBox callback" );
				break;
			}
			case kTIgnore:
			{
				mCallbackState = false;
				tokenList->GetToken(); // Remove that token!
				LOGSTAT( "Disabling EditBox callback " );
				break;
			}
			case kTDisabled:
			{
				tokenList->GetToken(); // Remove that token!
				mDisabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				break;
			}
			case kTTextColour:
			{
				tokenList->GetToken(); // Remove that token!
				CcString theString = tokenList->GetToken();
				if(theString == "DEFAULT")
				{
					SetColour(255,255,255);
					LOGSTAT( "Setting MultiEdit DEFAULT colour ");
				}
				else
				{
					int red = atoi( theString.ToCString() );
					int green = atoi( tokenList->GetToken().ToCString() );
					int blue = atoi( tokenList->GetToken().ToCString() );
					SetColour (red,green,blue);
					LOGSTAT( "Setting MultiEdit Colourful: " + theString );
				}
				break;
			}
			case kTTextItalic:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
					((CxMultiEdit*)mWidgetPtr)->SetItalic(state);
				CcString theString = tokenList->GetToken(); // Remove that token!
				LOGSTAT( "Setting MultiEdit Italic: " + theString  );
				break;
			}
			case kTTextBold:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
					((CxMultiEdit*)mWidgetPtr)->SetBold(state);
				CcString theString = tokenList->GetToken(); // Remove that token!
				LOGSTAT( "Setting MultiEdit Bold: " + theString  );
				break;
			}
			case kTTextUnderline:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
					((CxMultiEdit*)mWidgetPtr)->SetUnderline(state);
				CcString theString = tokenList->GetToken(); // Remove that token!
				LOGSTAT( "Setting MultiEdit Underline: " + theString );
				break;
			}
			case kTTextFixedFont:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
					((CxMultiEdit*)mWidgetPtr)->SetFixedWidth(state);
				CcString theString = tokenList->GetToken(); // Remove that token!
				LOGSTAT( "Setting MultiEdit Fixedfont: " + theString );
				break;
			}
			case kTBackLine:
			{
				tokenList->GetToken(); // Remove that token!
				if(!mNoEcho)
				{
					((CxMultiEdit*)mWidgetPtr)->BackALine();
					LOGSTAT( "Setting MultiEdit back a line ");
				}
				else
					LOGWARN( "Not setting MultiEdit back a line: it is in NOECHO state. ");

				break;
			}
			case kTNoEcho:
			{
				tokenList->GetToken(); // Remove that token!
				mNoEcho = true;
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

void CrMultiEdit::SetText ( CcString text )
{
	if(!mNoEcho)
	{
		char theText[256];
		strcpy (theText, text.ToCString() );
		((CxMultiEdit*)mWidgetPtr)->SetText(theText);
	}
}

void CrMultiEdit::SetGeometry( const CcRect * rect )
{
	((CxMultiEdit*)mWidgetPtr)->SetGeometry(	rect->mTop,
												rect->mLeft,
												rect->mBottom,
												rect->mRight );
}

CcRect CrMultiEdit::GetGeometry ()
{
	CcRect retVal(
			((CxMultiEdit*)mWidgetPtr)->GetTop(), 
			((CxMultiEdit*)mWidgetPtr)->GetLeft(),
			((CxMultiEdit*)mWidgetPtr)->GetTop()+((CxMultiEdit*)mWidgetPtr)->GetHeight(),
			((CxMultiEdit*)mWidgetPtr)->GetLeft()+((CxMultiEdit*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void CrMultiEdit::CalcLayout()
{
	int w = int( mWidthFactor * (float)((CxMultiEdit*)mWidgetPtr)->GetIdealWidth() );
	int h = int( mHeightFactor* (float)((CxMultiEdit*)mWidgetPtr)->GetIdealHeight() );
	((CxMultiEdit*)mWidgetPtr)->SetGeometry(-1,-1,h,w);
}

void CrMultiEdit::Changed()
{
	SendCommand(mName+"_NCHANGED");
}

//CcRect CrMultiEdit::GetOriginalGeometry()
//{
//	return mOriginalGeometry;
//}

//void CrMultiEdit::SetWidthScale(float w)
//{
//	int width =  ((CxMultiEdit*)mWidgetPtr)->GetWidth();
//	int height =  ((CxMultiEdit*)mWidgetPtr)->GetHeight();
//	int x =  ((CxMultiEdit*)mWidgetPtr)->GetLeft();
//	int y =  ((CxMultiEdit*)mWidgetPtr)->GetTop();
//
//	((CxMultiEdit*)mWidgetPtr)->SetGeometry( y, x, height, (int)( width * w ) );
//}


int CrMultiEdit::GetIdealWidth()
{
	return ((CxMultiEdit*)mWidgetPtr)->GetIdealWidth();
}
int CrMultiEdit::GetIdealHeight()
{
	return ((CxMultiEdit*)mWidgetPtr)->GetIdealHeight();
}

void CrMultiEdit::CrFocus()
{
	((CxMultiEdit*)mWidgetPtr)->Focus();	
}

void CrMultiEdit::SetColour(int red, int green, int blue)
{
	((CxMultiEdit*)mWidgetPtr)->SetColour(red,green,blue);	
}


void CrMultiEdit::NoEcho(Boolean noEcho)
{
	mNoEcho = noEcho;
}
