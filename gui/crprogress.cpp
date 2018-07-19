////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.cpp
//   Authors:   Richard Cooper
//   Created:   22.2.1998 14:43 Hours
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.12  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.11  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.10  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.9  2001/06/17 15:14:14  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.8  2001/03/08 16:44:07  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crprogress.h"
#include    "crgrid.h"
#include    "cxprogress.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrProgress::CrProgress( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxProgress::CreateCxProgress( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = false;
}

CrProgress::~CrProgress()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxProgress*) ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxProgress*) ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }

      mControllerPtr->RemoveProgressOutputPlace(this);
}

CRSETGEOMETRY(CrProgress,CxProgress)
CRGETGEOMETRY(CrProgress,CxProgress)
CRCALCLAYOUT(CrProgress,CxProgress)

CcParse CrProgress::ParseInput( deque<string> & tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

// Initialization for the first time
    if( ! mSelfInitialised )
    {
            LOGSTAT("*** ProgressBar *** Initing...\n");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

            LOGSTAT( "*** Created ProgressBar    " + mName + "\n");
    }

// End of Init, now comes the general parser
    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTTextSelector:
            {
                tokenList.pop_front(); // Remove that token
                mText = string(tokenList.front());
                tokenList.pop_front();
                SetText( mText );
                LOGSTAT( "Setting Text to " + mText);
                break;
            }
            case kTChars:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxProgress*)ptr_to_cxObject)->SetVisibleChars( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Setting Text Chars Width: " + tokenList.front() );
                tokenList.pop_front(); // Remove that token!
                break;
            }
            case kTComplete:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxProgress*)ptr_to_cxObject)->SetProgress( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Setting Progress: " + tokenList.front() + "% ");
                tokenList.pop_front(); // Remove that token!
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

void    CrProgress::SetText( const string &text )
{
    ( (CxProgress *)ptr_to_cxObject)->SetText( text );
}


void CrProgress::CrFocus()
{

}

void CrProgress::SwitchText ( const string & text )
{
      ((CxProgress*)ptr_to_cxObject)->SwitchText( text );
}
