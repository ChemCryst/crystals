////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   06.3.1998 00:04 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.16  2004/09/17 14:03:54  rich
//   Better support for accessing text in Multiline edit control from scripts.
//
//   Revision 1.15  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.14  2004/05/13 09:14:49  rich
//   Re-invigorate the MULTIEDIT control. Currently not used, but I have
//   something in mind for it.
//
//   Revision 1.13  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.12  2001/06/17 15:14:13  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.11  2001/03/08 16:44:06  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include <string>
#include <sstream>
using namespace std;

#include    "crconstants.h"
#include    "ccrect.h"
#include    "crmultiedit.h"
#include    "crgrid.h"
#include    "cccontroller.h"
#include    "cxmultiedit.h"


CrMultiEdit::CrMultiEdit( CrGUIElement * mParentPtr )
 : CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxMultiEdit::CreateCxMultiEdit( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mXCanResize = true;
    mYCanResize = true;
    mTabStop = true;
    mNoEcho = false;
}

CrMultiEdit::~CrMultiEdit()
{
    mControllerPtr->RemoveTextOutputPlace(this);
    if ( ptr_to_cxObject != nil )
    {
        ((CxMultiEdit*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
        delete (CxMultiEdit*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}


CRSETGEOMETRY(CrMultiEdit,CxMultiEdit)
CRGETGEOMETRY(CrMultiEdit,CxMultiEdit)
CRCALCLAYOUT(CrMultiEdit,CxMultiEdit)

CcParse CrMultiEdit::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** MultiEdit *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created MulitEdit    " + mName );

            int size = 200;
            string cgeom = (CcController::theController)->GetKey( "FontSize" );
            if ( cgeom.length() )
                size = atoi( cgeom.c_str() );
            ((CxMultiEdit*)ptr_to_cxObject)->SetFontHeight(size);
    }
    // End of Init, now comes the general parser
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
                LOGSTAT( "Setting MultiEdit Text: " + mText );
                break;
            }
            case kTNumberOfRows:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxMultiEdit*)ptr_to_cxObject)->SetIdealHeight( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Setting MultiEdit Lines Height: " + tokenList.front() );
                tokenList.pop_front();
                break;
            }
            case kTNumberOfColumns:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxMultiEdit*)ptr_to_cxObject)->SetIdealWidth( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Setting MultiEdit Chars Width: " + tokenList.front() );
                tokenList.pop_front();
                break;
            }
            case kTInform:
            {
                mCallbackState = true;
                tokenList.pop_front(); // Remove that token!
                LOGSTAT( "Enabling EditBox callback" );
                break;
            }
            case kTIgnore:
            {
                mCallbackState = false;
                tokenList.pop_front(); // Remove that token!
                LOGSTAT( "Disabling EditBox callback " );
                break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                mDisabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                break;
            }
            case kTSave:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxMultiEdit*)ptr_to_cxObject)->SaveAs( tokenList.front() );
                LOGSTAT( "Saving MultiEdit contents as: " + tokenList.front() );
                tokenList.pop_front();
                break;
            }
            case kTLoad:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxMultiEdit*)ptr_to_cxObject)->Load( tokenList.front() );
                LOGSTAT( "Loading MultiEdit contents from: " + tokenList.front() );
                tokenList.pop_front();
                break;
            }
            case kTNoEcho:
            {
                tokenList.pop_front(); // Remove that token!
                mNoEcho = true;
                break;
            }
                  case kTSpew:
                  {
                        tokenList.pop_front(); //Remove kTSpew tokens.
                        // Dump whole text window to Crystals input.
                        ((CxMultiEdit*)ptr_to_cxObject)->Spew();
                        break;
                  }
            case kTEmpty:
            {
                   tokenList.pop_front(); //Remove kTEmpty tokens.
                   ((CxMultiEdit*)ptr_to_cxObject)->Empty();
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

void CrMultiEdit::SetText ( const string &cText )
{
    if(!mNoEcho)
      {


                   ((CxMultiEdit*)ptr_to_cxObject)->SetText(cText+"\r\n");
      }
}

void  CrMultiEdit::GetValue( deque<string> &  tokenList )
{
      if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQNLines )
      {
            tokenList.pop_front();
            int nL =  ((CxMultiEdit*)ptr_to_cxObject)->GetNLines();
            ostringstream strm;
            strm << nL;
            SendCommand( strm.str(),true);
      }
      else if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQText )
      {
            tokenList.pop_front();
            ((CxMultiEdit*)ptr_to_cxObject)->Spew();
      }
      else
      {
            SendCommand( "ERROR",true );
            LOGWARN( "CrMultiEdit:GetValue Error unrecognised token." + tokenList.front() );
            tokenList.pop_front();
      }
}


void CrMultiEdit::Changed()
{
    SendCommand(mName+"_NCHANGED");
}

int CrMultiEdit::GetIdealWidth()
{
    return ((CxMultiEdit*)ptr_to_cxObject)->GetIdealWidth();
}
int CrMultiEdit::GetIdealHeight()
{
    return ((CxMultiEdit*)ptr_to_cxObject)->GetIdealHeight();
}

void CrMultiEdit::CrFocus()
{
    ((CxMultiEdit*)ptr_to_cxObject)->Focus();
}


void CrMultiEdit::NoEcho(bool noEcho)
{
    mNoEcho = noEcho;
}

void CrMultiEdit::SetFontHeight(int height)
{
      ((CxMultiEdit*)ptr_to_cxObject)->SetFontHeight(height);
      return;
}
