////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CrIcon.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

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
            ((CxIcon*) ptr_to_cxObject)->DestroyWindow(); delete (CxIcon*) ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrIcon,CxIcon)
CRGETGEOMETRY(CrIcon,CxIcon)
CRCALCLAYOUT(CrIcon,CxIcon)

CcParse     CrIcon::ParseInput( CcTokenList * tokenList )
{
  CcParse retVal(true, mXCanResize, mYCanResize);
  Boolean hasTokenForMe = true;

// This is the only class I can think of that doesn't have
// a general parser. All info must be set up as the icon
// is created. w.f. ^^WI ICON MYICON QUERY

// Initialization for the first time
  if( ! mSelfInitialised )
  {
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
}

void CrIcon::CrFocus()
{
}
