////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CrTextOut.cc
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include <string>
using namespace std;

#include    "crconstants.h"
#include    "ccrect.h"
#include    "crtextout.h"
#include    "crgrid.h"
#include    "cccontroller.h"
#include    "cxtextout.h"

#ifdef CRY_USEWX
#include <wx/filename.h>
#include <wx/mimetype.h>
#endif


CrTextOut::CrTextOut( CrGUIElement * mParentPtr )
 : CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxTextOut::CreateCxTextOut( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mXCanResize = true;
    mYCanResize = true;
    mTabStop = true;
}

CrTextOut::~CrTextOut()
{
    mControllerPtr->RemoveTextOutputPlace(this);
    if ( ptr_to_cxObject != nil )
    {
        ((CxTextOut*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxTextOut*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrTextOut,CxTextOut)
CRGETGEOMETRY(CrTextOut,CxTextOut)
CRCALCLAYOUT(CrTextOut,CxTextOut)

CcParse CrTextOut::ParseInput( deque<string> & tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** TextOut *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created MulitEdit    " + mName );

            int size = 200;
            string cgeom = (CcController::theController)->GetKey( "FontSize" );
            if ( cgeom.length() )
                size = atoi( cgeom.c_str() );
//            ((CxTextOut*)ptr_to_cxObject)->SetFontHeight(size);
    }
    // End of Init, now comes the general parser
    while ( hasTokenForMe && !tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTTextSelector:
            {
                tokenList.pop_front(); // Remove that token!
                mText = string(tokenList.front());
                tokenList.pop_front();
                SetText( mText );
                LOGSTAT( "Setting TextOut Text: " + mText );
                break;
            }
            case kTEmpty:
            {
                    tokenList.pop_front(); //Remove kTEmpty tokens.
                    ((CxTextOut*)ptr_to_cxObject)->Empty();
                    break;
            }
            case kTViewTop:
            {
                    tokenList.pop_front(); //Remove token.
                    ((CxTextOut*)ptr_to_cxObject)->ViewTop();
                    break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                mDisabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                break;
            }
                        case kTFontSelect:
            {
                tokenList.pop_front(); // Remove that token!
                                ((CxTextOut*)ptr_to_cxObject)->ChooseFont();
                                break;
            }


            case kTNumberOfRows:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxTextOut*)ptr_to_cxObject)->SetIdealHeight( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Setting TextOut Lines Height: " + tokenList.front() );
                tokenList.pop_front();
                break;
            }
            case kTNumberOfColumns:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxTextOut*)ptr_to_cxObject)->SetIdealWidth( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Setting TextOut Chars Width: " + tokenList.front() );
                tokenList.pop_front();
                break;
            }
            case kTTextTransparent:
            {
                tokenList.pop_front(); // Remove that token!
                LOGSTAT( "Setting TextOut Transparent " );
                ((CxTextOut*)ptr_to_cxObject)->SetTransparent();
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

void CrTextOut::SetText ( const string & cText )
{
   ((CxTextOut*)ptr_to_cxObject)->SetText(cText);
}


int CrTextOut::GetIdealWidth()
{
    return ((CxTextOut*)ptr_to_cxObject)->GetIdealWidth();
}
int CrTextOut::GetIdealHeight()
{
    return ((CxTextOut*)ptr_to_cxObject)->GetIdealHeight();
}

void CrTextOut::CrFocus()
{
    ((CxTextOut*)ptr_to_cxObject)->Focus();
}

void CrTextOut::ProcessLink( string aString )
{
      SendCommand("$ " + aString,TRUE);
}

void CrTextOut::ScrollPage(bool up)
{
    ((CxTextOut*)ptr_to_cxObject)->ScrollPage(up);
}
