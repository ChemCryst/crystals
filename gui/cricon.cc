////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CrIcon.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:38 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include    "cricon.h"
#include	"crgrid.h"
#include    "cxicon.h"
#include	"ccrect.h"
#include	"cccontroller.h"	// for sending commands


CrIcon::CrIcon( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
      mWidgetPtr = CxIcon::CreateCxIcon( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTabStop = false;
}

CrIcon::~CrIcon()
{
	if ( mWidgetPtr != nil )
	{
            delete (CxIcon*) mWidgetPtr;
		mWidgetPtr = nil;
	}
}

Boolean     CrIcon::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
// This is the only class I can think of that doesn't have
// a general parser. All info must be set up as the icon
// is created. w.f. ^^WI ICON MYICON QUERY

	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
            LOGSTAT("*** Icon *** Initing...");

		retVal = CrGUIElement::ParseInputNoText( tokenList );
		mSelfInitialised = true;

            LOGSTAT( "*** Created Icon        " + mName );

            ((CxIcon *)mWidgetPtr)->SetIconType( tokenList->GetDescriptor(kAttributeClass) );
            tokenList->GetToken();
            LOGSTAT( "Setting Icon");

	}
	
	return retVal;
}
void  CrIcon::SetText( CcString text )
{
	char theText[256];
	strcpy( theText, text.ToCString() );

      ( (CxIcon *)mWidgetPtr)->SetText( theText );
}
void  CrIcon::SetGeometry( const CcRect * rect )
{
      ((CxIcon*)mWidgetPtr)->SetGeometry(       rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
}

CcRect      CrIcon::GetGeometry()
{
	CcRect retVal (
                  ((CxIcon*)mWidgetPtr)->GetTop(), 
                  ((CxIcon*)mWidgetPtr)->GetLeft(),
                  ((CxIcon*)mWidgetPtr)->GetTop()+((CxIcon*)mWidgetPtr)->GetHeight(),
                  ((CxIcon*)mWidgetPtr)->GetLeft()+((CxIcon*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void  CrIcon::CalcLayout()
{
      int w =  ((CxIcon*)mWidgetPtr)->GetIdealWidth();
      int h =  ((CxIcon*)mWidgetPtr)->GetIdealHeight();
      ((CxIcon*)mWidgetPtr)->SetGeometry(0,0,h,w); 
}

void CrIcon::CrFocus()
{

}
