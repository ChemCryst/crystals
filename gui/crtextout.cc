////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CrTextOut.cc
//   Authors:   Richard Cooper

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include 	"ccrect.h"
#include	"crtextout.h"
#include	"crgrid.h"
#include	"cccontroller.h"
#include	"cxtextout.h"


CrTextOut::CrTextOut( CrGUIElement * mParentPtr )
 : CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxTextOut::CreateCxTextOut( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mXCanResize = true;
	mYCanResize = true;
	mTabStop = true;
}

CrTextOut::~CrTextOut()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxTextOut*)mWidgetPtr;
		mWidgetPtr = nil;
	}
      mControllerPtr->RemoveTextOutputPlace(this);
}

Boolean	CrTextOut::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** TextOut *** Initing...");

		retVal = CrGUIElement::ParseInput( tokenList );
		mSelfInitialised = true;

		LOGSTAT( "*** Created MulitEdit    " + mName );

            int size = 200;
            CcString cgeom = (CcController::theController)->GetKey( "FontSize" );
            if ( cgeom.Len() )
                size = atoi( cgeom.ToCString() );
//            ((CxTextOut*)mWidgetPtr)->SetFontHeight(size); 
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
				LOGSTAT( "Setting TextOut Text: " + mText );
				break;
			}
                        case kTEmpty:
                        {
                                tokenList->GetToken(); //Remove kTEmpty tokens.
                                ((CxTextOut*)mWidgetPtr)->Empty();
                                break;
                        }
                        case kTDisabled:
			{
				tokenList->GetToken(); // Remove that token!
				mDisabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
				break;
			}
                        case kTFontSelect:
			{
				tokenList->GetToken(); // Remove that token!
                                ((CxTextOut*)mWidgetPtr)->ChooseFont();
                                break;
			}
                                

			case kTNumberOfRows:
			{
				tokenList->GetToken(); // Remove that token!
				CcString theString = tokenList->GetToken();
				int chars = atoi( theString.ToCString() );
				((CxTextOut*)mWidgetPtr)->SetIdealHeight( chars );
				LOGSTAT( "Setting TextOut Lines Height: " + theString );
				break;
			}
			case kTNumberOfColumns:
			{
				tokenList->GetToken(); // Remove that token!
				CcString theString = tokenList->GetToken();
				int chars = atoi( theString.ToCString() );
				((CxTextOut*)mWidgetPtr)->SetIdealWidth( chars );
				LOGSTAT( "Setting TextOut Chars Width: " + theString );
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

void CrTextOut::SetText ( CcString cText )
{
                   ((CxTextOut*)mWidgetPtr)->SetText(cText);
}

void CrTextOut::SetGeometry( const CcRect * rect )
{
	((CxTextOut*)mWidgetPtr)->SetGeometry(	rect->mTop,
												rect->mLeft,
												rect->mBottom,
												rect->mRight );
}

CcRect CrTextOut::GetGeometry ()
{
	CcRect retVal(
			((CxTextOut*)mWidgetPtr)->GetTop(), 
			((CxTextOut*)mWidgetPtr)->GetLeft(),
			((CxTextOut*)mWidgetPtr)->GetTop()+((CxTextOut*)mWidgetPtr)->GetHeight(),
			((CxTextOut*)mWidgetPtr)->GetLeft()+((CxTextOut*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void CrTextOut::CalcLayout()
{
	int w = int( mWidthFactor * (float)((CxTextOut*)mWidgetPtr)->GetIdealWidth() );
	int h = int( mHeightFactor* (float)((CxTextOut*)mWidgetPtr)->GetIdealHeight() );
	((CxTextOut*)mWidgetPtr)->SetGeometry(-1,-1,h,w);
}

int CrTextOut::GetIdealWidth()
{
	return ((CxTextOut*)mWidgetPtr)->GetIdealWidth();
}
int CrTextOut::GetIdealHeight()
{
	return ((CxTextOut*)mWidgetPtr)->GetIdealHeight();
}

void CrTextOut::CrFocus()
{
	((CxTextOut*)mWidgetPtr)->Focus();	
}

void CrTextOut::SetOriginalSizes()
{
      ((CxTextOut*)mWidgetPtr)->SetOriginalSizes(); 
      return;
}

void CrTextOut::ProcessLink( CcString aString )
{
      SendCommand("$start " + aString,TRUE);
}
