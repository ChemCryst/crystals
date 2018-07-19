////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CrIcon.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.6  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.5  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.4  2001/06/17 15:14:13  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.3  2001/03/08 16:44:05  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

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
            ((CxIcon*) ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
            delete (CxIcon*) ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrIcon,CxIcon)
CRGETGEOMETRY(CrIcon,CxIcon)
CRCALCLAYOUT(CrIcon,CxIcon)

CcParse     CrIcon::ParseInput( deque<string> & tokenList )
{
  CcParse retVal(true, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;

// This is the only class I can think of that doesn't have
// a general parser. All info must be set up as the icon
// is created. w.f. ^^WI ICON MYICON QUERY

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    retVal = CrGUIElement::ParseInputNoText( tokenList );
    mSelfInitialised = true;

    LOGSTAT( "*** Created Icon        " + mName );
    ((CxIcon *)ptr_to_cxObject)->SetIconType( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) );
    tokenList.pop_front();
    LOGSTAT( "Setting Icon");
  }
  return retVal;
}

void  CrIcon::SetText( const string &text )
{
}

void CrIcon::CrFocus()
{
}
