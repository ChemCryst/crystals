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
#include	"crgrid.h"
#include	"cccontroller.h"
#include	"cxmultiedit.h"


CrMultiEdit::CrMultiEdit( CrGUIElement * mParentPtr )
 : CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxMultiEdit::CreateCxMultiEdit( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mXCanResize = true;
	mYCanResize = true;
	mTabStop = true;
	mNoEcho = false;
}

CrMultiEdit::~CrMultiEdit()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxMultiEdit*)mWidgetPtr;
		mWidgetPtr = nil;
	}
      mControllerPtr->RemoveTextOutputPlace(this);
}

Boolean	CrMultiEdit::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** MultiEdit *** Initing...");

		retVal = CrGUIElement::ParseInput( tokenList );
		mSelfInitialised = true;

		LOGSTAT( "*** Created MulitEdit    " + mName );

            int size = 200;
            CcString cgeom = (CcController::theController)->GetKey( "FontSize" );
            if ( cgeom.Len() )
                size = atoi( cgeom.ToCString() );
            ((CxMultiEdit*)mWidgetPtr)->SetFontHeight(size); 
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
                  case kTSpew:
                  {
                        tokenList->GetToken(); //Remove kTSpew tokens.
                        // Dump whole text window to Crystals input.
                        ((CxMultiEdit*)mWidgetPtr)->Spew();
                        break;
                  }
                  case kTEmpty:
                  {
                        tokenList->GetToken(); //Remove kTEmpty tokens.
                        ((CxMultiEdit*)mWidgetPtr)->Empty();
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

void CrMultiEdit::SetText ( CcString cText )
{
	if(!mNoEcho)
      {


                   ((CxMultiEdit*)mWidgetPtr)->SetText(cText);


/*
// Scan for @ markup.
// Format is:               Normal text @Link Text@Link Commands@ normal text
// e.g  You may @Click here@#SCRIPT ANALYSE@ to see an analysis.

            CcString cLinkText;
            int iSt = 1;
            int iCr = 1;
            int iPosType = INPLAINTEXT;

            for ( iCr = 1; iCr <= cText.Length(); iCr++ )
            {
                  if (cText.Sub(iCr,iCr) == '@')
                  {
                        if ( iPosType == INPLAINTEXT )
                        {
// Flush text as far as the @
                             ((CxMultiEdit*)mWidgetPtr)->SetText(cText.Sub(iSt,iCr-1));
                              iSt = iCr+1;
                              iPosType = INLINKTEXT;
                        }
                        else if ( iPosType == INLINKTEXT )
                        {
                              cLinkText = cText.Sub(iSt,iCr-1);
                              iSt = iCr+1;
                              iPosType = INLINKCOMMAND;
                        }
                        else
                        {
                             ((CxMultiEdit*)mWidgetPtr)->SetHyperText(cLinkText,cText.Sub(iSt,iCr-1));
                              iPosType = INPLAINTEXT;
                              iSt = iCr+1;
                        }
                  }
            }

                  if ( cText.Length() == 0 )
                   ((CxMultiEdit*)mWidgetPtr)->SetText(cText);
			else
                   ((CxMultiEdit*)mWidgetPtr)->SetText(cText.Sub(iSt,iCr-1));
*/


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

void CrMultiEdit::SetOriginalSizes()
{
      ((CxMultiEdit*)mWidgetPtr)->SetOriginalSizes(); 
      return;
}

void CrMultiEdit::SetFontHeight(int height)
{
      ((CxMultiEdit*)mWidgetPtr)->SetFontHeight(height); 
      return;
}
