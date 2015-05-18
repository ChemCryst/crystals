////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrStretch
////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.4  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.3  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.2  2001/06/17 15:14:14  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.1  2001/02/26 12:07:06  richard
//   New stretch class. Probably the simplest class ever written, it has no functionality
//   except that it can be put in a grid of non-resizing items, and it will make that
//   row, column or both appear to be able to resize, thus spreading out fixed size items.
//

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
        ((CxStretch*) ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxStretch*) ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrStretch,CxStretch)
CRGETGEOMETRY(CrStretch,CxStretch)
CRCALCLAYOUT(CrStretch,CxStretch)

CcParse CrStretch::ParseInput( deque<string> & tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    if( ! mSelfInitialised )
    {
        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;
        LOGSTAT( "*** Created Stretch  " + mName );
    }

    switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
    {
      case kTHorizontal:
      {
        tokenList.pop_front();
        mXCanResize = true;
        mYCanResize = false;
        break;
      }
      case kTVertical:
      {
        tokenList.pop_front();
        mXCanResize = false;
        mYCanResize = true;
        break;
      }
      case kTBoth:
      {
        tokenList.pop_front();
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

void    CrStretch::SetText( const string &text )
{
}

void CrStretch::CrFocus()
{
}
