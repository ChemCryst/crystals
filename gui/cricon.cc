////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CrIcon.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:38 Uhr

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "cricon.h"
#include    "crgrid.h"
#include    "cxicon.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrIcon::CrIcon( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
      ptr_to_cxObject = CxIcon::CreateCxIcon( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = false;
}

CrIcon::~CrIcon()
{
    if ( ptr_to_cxObject != nil )
    {
            delete (CxIcon*) ptr_to_cxObject;
        ptr_to_cxObject = nil;
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

            ((CxIcon *)ptr_to_cxObject)->SetIconType( tokenList->GetDescriptor(kAttributeClass) );
            tokenList->GetToken();
            LOGSTAT( "Setting Icon");

    }

    return retVal;
}
void  CrIcon::SetText( CcString text )
{
    char theText[256];
    strcpy( theText, text.ToCString() );

      ( (CxIcon *)ptr_to_cxObject)->SetText( theText );
}
void  CrIcon::SetGeometry( const CcRect * rect )
{
      ((CxIcon*)ptr_to_cxObject)->SetGeometry(       rect->mTop,
                                            rect->mLeft,
                                            rect->mBottom,
                                            rect->mRight );
}

CcRect      CrIcon::GetGeometry()
{
    CcRect retVal (
                  ((CxIcon*)ptr_to_cxObject)->GetTop(),
                  ((CxIcon*)ptr_to_cxObject)->GetLeft(),
                  ((CxIcon*)ptr_to_cxObject)->GetTop()+((CxIcon*)ptr_to_cxObject)->GetHeight(),
                  ((CxIcon*)ptr_to_cxObject)->GetLeft()+((CxIcon*)ptr_to_cxObject)->GetWidth()   );
    return retVal;
}

void  CrIcon::CalcLayout()
{
      int w =  ((CxIcon*)ptr_to_cxObject)->GetIdealWidth();
      int h =  ((CxIcon*)ptr_to_cxObject)->GetIdealHeight();
      ((CxIcon*)ptr_to_cxObject)->SetGeometry(0,0,h,w);
}

void CrIcon::CrFocus()
{

}
