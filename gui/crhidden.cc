////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrHidden
////////////////////////////////////////////////////////////////////////

//   Filename:  CrHidden.cc
//   Authors:   Richard Cooper
//   Created:   09.5.2002 17:51
//
//   This class is a GUI element that holds a string. Can be used
//   to store info outside the scope of SCRIPTS. It doesn't have a
//   Cx equivalent class.
//
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crhidden.h"
#include    "crgrid.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrHidden::CrHidden( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = nil;
    mTabStop = false;
}

CrHidden::~CrHidden()
{
}


CcRect CrHidden::CalcLayout(bool recalc)
{
  return CcRect(0,0,0,0);
}

CcRect CrHidden::GetGeometry()
{
  return CcRect(0,0,0,0);
}

void CrHidden::SetGeometry(const CcRect * rect)
{
  return;
}

CcParse CrHidden::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    if( ! mSelfInitialised )
    {
        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;
        LOGSTAT( "*** Created Hidden  " + mName + mText );
    }

    switch ( tokenList->GetDescriptor(kAttributeClass) )
    {
       case kTTextSelector:
       {
           tokenList->GetToken(); // Remove that token!
           mText = tokenList->GetToken();
           LOGSTAT( "Set Hidden Text String to '" + mText );
           break;
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

void    CrHidden::SetText( CcString text )
{
}

void CrHidden::CrFocus()
{
}


void CrHidden::GetValue(CcTokenList * tokenList)
{
    int desc = tokenList->GetDescriptor(kQueryClass);
    if( desc == kTQText )
    {
        tokenList->GetToken();
        SendCommand( mText, true );
    }
    else
    {
        SendCommand( "ERROR",true );
        CcString error = tokenList->GetToken();
        LOGWARN( "CrEditBox:GetValue Error unrecognised token." + error);
    }
}

