////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrBitmap

////////////////////////////////////////////////////////////////////////

//   Filename:  CrBitmap.cc
//   Authors:   Richard Cooper

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include        "crbitmap.h"

#include	"crgrid.h"
#include        "cxbitmap.h"
#include	"ccrect.h"
#include	"cccontroller.h"	// for sending commands


CrBitmap::CrBitmap( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
        mWidgetPtr = CxBitmap::CreateCxBitmap( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = false;
}

CrBitmap::~CrBitmap()
{
	if ( mWidgetPtr != nil )
	{
                delete (CxBitmap*) mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean CrBitmap::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
                LOGSTAT("*** Bitmap *** Initing...");

                retVal = CrGUIElement::ParseInputNoText( tokenList );
		mSelfInitialised = true;

                LOGSTAT( "*** Created Bitmap " + mName );
	}
	
	// End of Init, now comes the general parser
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kAttributeClass) )
		{
                        case kTBitmapFile:
			{
				tokenList->GetToken(); // Remove that token!
				mText = tokenList->GetToken();
                                ((CxBitmap*)mWidgetPtr)->LoadFile(mText);
                                LOGSTAT( "Loading bitmap " + mText );
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

void    CrBitmap::SetText( CcString text )
{
// Do nothing - just overriding virtual void...
}

void    CrBitmap::SetGeometry( const CcRect * rect )
{
        ((CxBitmap*)mWidgetPtr)->SetGeometry( rect->mTop,
                                            rect->mLeft,
                                            rect->mBottom,
                                            rect->mRight );
}
CcRect  CrBitmap::GetGeometry()
{
	CcRect retVal (
                        ((CxBitmap*)mWidgetPtr)->GetTop(), 
                        ((CxBitmap*)mWidgetPtr)->GetLeft(),
                        ((CxBitmap*)mWidgetPtr)->GetTop()+((CxBitmap*)mWidgetPtr)->GetHeight(),
                        ((CxBitmap*)mWidgetPtr)->GetLeft()+((CxBitmap*)mWidgetPtr)->GetWidth()   );
	return retVal;
}
void    CrBitmap::CalcLayout()
{
        int w =  ((CxBitmap*)mWidgetPtr)->GetIdealWidth();
        int h =  ((CxBitmap*)mWidgetPtr)->GetIdealHeight();
        ((CxBitmap*)mWidgetPtr)->SetGeometry(0,0,h,w); 
}

void CrBitmap::CrFocus()
{

}
