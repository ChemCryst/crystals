////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrEditBox

////////////////////////////////////////////////////////////////////////

// $Log: not supported by cvs2svn $
// Revision 1.4  1999/05/07 16:03:52  dosuser
// RIC: Removed Arrow() function. System keys now arrive
// through SysKey() functions.
//
// Revision 1.3  1999/03/05 17:07:10  dosuser
// RIC: Standardising syntax. Main window definition moved to external
//      ASCII file for user flexibility.
//

//   Filename:  CrEditBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:15 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"creditbox.h"
//insert your own code here.
#include	"crgrid.h"
#include	"cxeditbox.h"
#include	"ccrect.h"
#include	"cctokenlist.h"
#include	"cccontroller.h"	// for sending commands
#include    "crwindow.h"  // for getting cursor keys

CrEditBox::CrEditBox( CrGUIElement * mParentPtr )
:	CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxEditBox::CreateCxEditBox( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mXCanResize = true;
	mTabStop = true;
	mSendOnReturn = false;
}

CrEditBox::~CrEditBox()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxEditBox*)mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean	CrEditBox::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** EditBox *** Initing...");

		retVal = CrGUIElement::ParseInput( tokenList );
		mSelfInitialised = true;

		LOGSTAT( "*** Created EditBox     " + mName );

            if ( mName == "_MAINTEXTINPUT" )
            {
                  ((CrWindow*)GetRootWidget())->SendMeSysKeys( (CrGUIElement*) this);
            }            

		while ( hasTokenForMe )
		{
			switch ( tokenList->GetDescriptor(kAttributeClass) )
			{
				case kTNumberOfColumns:
				case kTChars:
				{
					tokenList->GetToken(); // Remove that token!
					CcString theString = tokenList->GetToken();
					int chars = atoi( theString.ToCString() );
						((CxEditBox*)mWidgetPtr)->SetVisibleChars( chars );
					LOGSTAT( "Setting EditBox Chars Width: " + theString );
					break;
				}
				case kTIntegerInput:
				{
					tokenList->GetToken(); // Remove that token!
					((CxEditBox*)mWidgetPtr)->SetInputType( CXE_INT_NUMBER );
					break;
				}
				case kTRealInput:
				{
					tokenList->GetToken(); // Remove that token!
					((CxEditBox*)mWidgetPtr)->SetInputType( CXE_REAL_NUMBER );
					break;
				}
				case kTNoInput:
				{
					tokenList->GetToken(); // Remove that token!
					((CxEditBox*)mWidgetPtr)->SetInputType( CXE_READ_ONLY );
					break;
				}
				default:
				{
					hasTokenForMe = false;
					break; // We leave the token in the list and exit the loop
				}
			} //end switch
		}// end while
	}// end if

	// End of Init, now comes the general parser

	hasTokenForMe = true;
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kAttributeClass) )
		{
			case kTTextSelector:
			{
				tokenList->GetToken(); // Remove that token!
				mText = tokenList->GetToken();
				SetText( mText );
				LOGSTAT( "Setting EditBox Text: " + mText );
				break;
			}
			case kTInform:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				mCallbackState = inform;
				if (mCallbackState)
					LOGSTAT( "Enabling EditBox callback" );
				else
					LOGSTAT( "Disabling EditBox callback" );
				break;
			}
			case kTDisabled:
			{
				tokenList->GetToken(); // Remove that token!
				Boolean disabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				CcString temp = tokenList->GetToken(); // Remove that token!
				LOGSTAT( "EditBox disabled = " + temp);
				((CxEditBox*)mWidgetPtr)->Disable( disabled );
				break;
			}
			case kTAppend:
			{
				tokenList->GetToken(); // Remove that token!
                        ((CxEditBox*)mWidgetPtr)->AddText(tokenList->GetToken());
                        mText = ((CxEditBox*)mWidgetPtr)->GetText();
				break;
			}
			case kTWantReturn:
			{
				tokenList->GetToken(); // Remove that token!
				mSendOnReturn = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				break;
			}
			default:
			{
				hasTokenForMe = false;
				break; // We leave the token in the list and exit the loop
			}
		}
	}	
	
	SetText(mText); //Re-set the text as it now knows if it is REAL,INT or TEXT..

	return retVal;

}

void CrEditBox::SetText( CcString text )
{

	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxEditBox *)mWidgetPtr)->SetText( theText );

}

void CrEditBox::SetGeometry( const CcRect * rect )
{

	((CxEditBox*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );

}

CcRect CrEditBox::GetGeometry()
{

	CcRect retVal(
			((CxEditBox*)mWidgetPtr)->GetTop(), 
			((CxEditBox*)mWidgetPtr)->GetLeft(),
			((CxEditBox*)mWidgetPtr)->GetTop()+((CxEditBox*)mWidgetPtr)->GetHeight(),
			((CxEditBox*)mWidgetPtr)->GetLeft()+((CxEditBox*)mWidgetPtr)->GetWidth()   );
	return retVal;	

}

void CrEditBox::CalcLayout()
{

	int w = (int)( mWidthFactor * (float) ((CxEditBox*)mWidgetPtr)->GetIdealWidth() ) ;
	int h =  ((CxEditBox*)mWidgetPtr)->GetIdealHeight();
	((CxEditBox*)mWidgetPtr)->SetGeometry(0,0,h,w);	

}

void CrEditBox::GetValue()
{
	char theText[256];
//TODO: Oops. Get text is a base class call. Wrap it.
	int textLen = ((CxEditBox*)mWidgetPtr)->GetText(&theText[0]);
	SendCommand( CcString( theText ) );
}

void CrEditBox::GetValue(CcTokenList * tokenList)
{
	int desc = tokenList->GetDescriptor(kQueryClass);
	if( desc == kTQText )
	{
		tokenList->GetToken();
		char theText[256];
		int textLen = ((CxEditBox*)mWidgetPtr)->GetText(&theText[0]);
		SendCommand( CcString( theText ), true );
	}
	else
	{
		SendCommand( "ERROR",true );
		CcString error = tokenList->GetToken();
		LOGWARN( "CrEditBox:GetValue Error unrecognised token." + error);
	}
}

void	CrEditBox::BoxChanged()
{
//Insert your own code here.
	if(mCallbackState)
	{
		char theText[256];
		int theTextLen = ((CxEditBox*)mWidgetPtr)->GetText(&theText[0]);
		SendCommand(mName);
		SendCommand( CcString( theText ) );
	}
//End of user code.         
}

int CrEditBox::GetIdealWidth()
{
	return ((CxEditBox*)mWidgetPtr)->GetIdealWidth();
}

void CrEditBox::CrFocus()
{
	((CxEditBox*)mWidgetPtr)->Focus();	
}

void CrEditBox::ReturnPressed()
{
	if(mSendOnReturn)
	{
		char theText[256];
		int textLen = ((CxEditBox*)mWidgetPtr)->GetText(&theText[0]);
		SendCommand(mName + " " + CcString( theText ) );
	}
	else
	{
		//FocusToInput, unless this IS the input, of course.
		if(this != CcController::theController->mInputWindow)
			FocusToInput( (char)13 );
	}
}


void CrEditBox::AddText(CcString theText)
{
	((CxEditBox*)mWidgetPtr)->AddText( (char*) theText.ToCString() );
}

//void CrEditBox::Arrow(Boolean up)
//{
//      //Only send History requests if this is _the_ input window.
//      if ( (CcController::theController)->mInputWindow == this)
//            (CcController::theController)->History(up);
//}

void CrEditBox::ClearBox()
{
	((CxEditBox*)mWidgetPtr)->ClearBox();
}

void CrEditBox::SysKey ( UINT nChar )
{
//Only send History requests if this is _the_ input window.
	if ( (CcController::theController)->mInputWindow == this)
      {
            switch ( nChar )
            {
                  case CRUP:
                        (CcController::theController)->History(true);
                        break;      
                  case CRDOWN:
                        (CcController::theController)->History(false);
                        break;
                  default:
                        break;
            }
      }
}
