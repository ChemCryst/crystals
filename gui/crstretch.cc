////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrStretch
////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crstretch.h"
#include    "crgrid.h"
#include    "cxstretch.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrStretch::CrStretch( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxStretch::CreateCxStretch( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = false;
    mXCanResize = true;
    mYCanResize = true;
}

CrStretch::~CrStretch()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxStretch*) ptr_to_cxObject)->DestroyWindow(); delete (CxStretch*) ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrStretch,CxStretch)
CRGETGEOMETRY(CrStretch,CxStretch)
CRCALCLAYOUT(CrStretch,CxStretch)

CcParse CrStretch::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    if( ! mSelfInitialised )
    {
        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;
        LOGSTAT( "*** Created Stretch  " + mName );
    }

    switch ( tokenList->GetDescriptor(kAttributeClass) )
    {
      case kTHorizontal:
      {
        tokenList->GetToken();
        mXCanResize = true;
        mYCanResize = false;
        break;
      }
      case kTVertical:
      {
        tokenList->GetToken();
        mXCanResize = false;
        mYCanResize = true;
        break;
      }
      case kTBoth:
      {
        tokenList->GetToken();
        // don't break - default is both.
      }
      default:
      {
        mXCanResize = true;
        mYCanResize = true;
        break;
      }
    }

    return CcParse(true,mXCanResize,mYCanResize);
}

void    CrStretch::SetText( CcString text )
{
}

void CrStretch::CrFocus()
{
}
