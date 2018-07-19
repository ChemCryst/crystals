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
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.3  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.2  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.1  2002/05/14 17:07:11  richard
//   New GUI control CrHidden (HIDDENSTRING) is completely transparent and small, but
//   will store a text string, so that, for example you can pass data from one script
//   to another via a window which is open in between. (Use therefore mainly lies in
//   programming Non-Modal windows like "Guide" and "Add H".)
//

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

CcParse CrHidden::ParseInput( deque<string> & tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    if( ! mSelfInitialised )
    {
        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;
        LOGSTAT( "*** Created Hidden  " + mName + mText );
    }

    switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
    {
       case kTTextSelector:
       {
           tokenList.pop_front(); // Remove that token!
           mText = string(tokenList.front());
           tokenList.pop_front();
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

void    CrHidden::SetText( const string &text )
{
}

void CrHidden::CrFocus()
{
}


void CrHidden::GetValue(deque<string> &  tokenList)
{
    int desc = CcController::GetDescriptor( tokenList.front(), kQueryClass );
    if( desc == kTQText )
    {
        tokenList.pop_front();
        SendCommand( mText, true );
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrEditBox:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }
}
