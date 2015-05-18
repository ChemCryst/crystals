////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrText
////////////////////////////////////////////////////////////////////////

//   Filename:  CrText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.7  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.6  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.5  2001/06/17 15:14:14  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.4  2001/03/08 15:44:10  richard
//   Allow script to query (^^??) what the text is.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crtext.h"
#include    "crgrid.h"
#include    "cxtext.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrText::CrText( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxText::CreateCxText( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = false;
}

CrText::~CrText()
{
    if ( ptr_to_cxObject )
    {
        ((CxText*) ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxText*) ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrText,CxText)
CRGETGEOMETRY(CrText,CxText)
CRCALCLAYOUT(CrText,CxText)

CcParse CrText::ParseInput( deque<string> & tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;
        LOGSTAT( "Created Static Text " + mName );
    }

    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTTextSelector:
            {
                tokenList.pop_front(); // Remove that token!
                mText = string(tokenList.front());
                tokenList.pop_front();
                SetText( mText );
                LOGSTAT( "Setting Text to '" + mText + "'");
                break;
            }
            case kTChars:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxText*)ptr_to_cxObject)->SetVisibleChars( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Setting Text Chars Width: " + tokenList.front() );
                tokenList.pop_front();
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

void CrText::GetValue( deque<string> &  tokenList)
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




void CrText::SetText( const string &text )
{
    ( (CxText *)ptr_to_cxObject)->SetText( text );
}

void CrText::CrFocus()
{

}
