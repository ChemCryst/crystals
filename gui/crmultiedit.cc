////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   06.3.1998 00:04 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.11  2001/03/08 16:44:06  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include "ccstring.h"
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
    if ( ptr_to_cxObject != nil )
    {
        ((CxMultiEdit*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
        delete (CxMultiEdit*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
      mControllerPtr->RemoveTextOutputPlace(this);
}


CRSETGEOMETRY(CrMultiEdit,CxMultiEdit)
CRGETGEOMETRY(CrMultiEdit,CxMultiEdit)
CRCALCLAYOUT(CrMultiEdit,CxMultiEdit)

CcParse CrMultiEdit::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** MultiEdit *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created MulitEdit    " + mName );

            int size = 200;
            CcString cgeom = (CcController::theController)->GetKey( "FontSize" );
            if ( cgeom.Len() )
                size = atoi( cgeom.ToCString() );
            ((CxMultiEdit*)ptr_to_cxObject)->SetFontHeight(size);
    }
    // End of Init, now comes the general parser
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting MultiEdit Text: " + mText );
                break;
            }
            case kTNumberOfRows:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                int chars = atoi( theString.ToCString() );
                ((CxMultiEdit*)ptr_to_cxObject)->SetIdealHeight( chars );
                LOGSTAT( "Setting MultiEdit Lines Height: " + theString );
                break;
            }
            case kTNumberOfColumns:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                int chars = atoi( theString.ToCString() );
                ((CxMultiEdit*)ptr_to_cxObject)->SetIdealWidth( chars );
                LOGSTAT( "Setting MultiEdit Chars Width: " + theString );
                break;
            }
            case kTInform:
            {
                mCallbackState = true;
                tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Enabling EditBox callback" );
                break;
            }
            case kTIgnore:
            {
                mCallbackState = false;
                tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Disabling EditBox callback " );
                break;
            }
            case kTDisabled:
            {
                tokenList->GetToken(); // Remove that token!
                mDisabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                break;
            }
            case kTTextColour:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                if(theString == "DEFAULT")
                {
                    SetColour(255,255,255);
                    LOGSTAT( "Setting MultiEdit DEFAULT colour ");
                }
                else
                {
                    int red = atoi( theString.ToCString() );
                    int green = atoi( tokenList->GetToken().ToCString() );
                    int blue = atoi( tokenList->GetToken().ToCString() );
                    SetColour (red,green,blue);
                    LOGSTAT( "Setting MultiEdit Colourful: " + theString );
                }
                break;
            }
            case kTTextItalic:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                    ((CxMultiEdit*)ptr_to_cxObject)->SetItalic(state);
                CcString theString = tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Setting MultiEdit Italic: " + theString  );
                break;
            }
            case kTTextBold:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                    ((CxMultiEdit*)ptr_to_cxObject)->SetBold(state);
                CcString theString = tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Setting MultiEdit Bold: " + theString  );
                break;
            }
            case kTTextUnderline:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                    ((CxMultiEdit*)ptr_to_cxObject)->SetUnderline(state);
                CcString theString = tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Setting MultiEdit Underline: " + theString );
                break;
            }
            case kTTextFixedFont:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean state = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                    ((CxMultiEdit*)ptr_to_cxObject)->SetFixedWidth(state);
                CcString theString = tokenList->GetToken(); // Remove that token!
                LOGSTAT( "Setting MultiEdit Fixedfont: " + theString );
                break;
            }
            case kTBackLine:
            {
                tokenList->GetToken(); // Remove that token!
                if(!mNoEcho)
                {
                    ((CxMultiEdit*)ptr_to_cxObject)->BackALine();
                    LOGSTAT( "Setting MultiEdit back a line ");
                }
                else
                    LOGWARN( "Not setting MultiEdit back a line: it is in NOECHO state. ");

                break;
            }
            case kTNoEcho:
            {
                tokenList->GetToken(); // Remove that token!
                mNoEcho = true;
                break;
            }
                  case kTSpew:
                  {
                        tokenList->GetToken(); //Remove kTSpew tokens.
                        // Dump whole text window to Crystals input.
                        ((CxMultiEdit*)ptr_to_cxObject)->Spew();
                        break;
                  }
                  case kTEmpty:
                  {
                        tokenList->GetToken(); //Remove kTEmpty tokens.
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

void CrMultiEdit::SetText ( CcString cText )
{
    if(!mNoEcho)
      {


                   ((CxMultiEdit*)ptr_to_cxObject)->SetText(cText+"\r\n");


/*
// Scan for @ markup.
// Format is:               Normal text @Link Text@Link Commands@ normal text
// e.g  You may @Click here@#SCRIPT ANALYSE@ to see an analysis.

            CcString cLinkText;
            int iSt = 1;
            int iCr = 1;
            int iPosType = INPLAINTEXT;

            for ( iCr = 1; iCr <= cText.Length(); iCr++ )
            {
                  if (cText.Sub(iCr,iCr) == '@')
                  {
                        if ( iPosType == INPLAINTEXT )
                        {
// Flush text as far as the @
                             ((CxMultiEdit*)ptr_to_cxObject)->SetText(cText.Sub(iSt,iCr-1));
                              iSt = iCr+1;
                              iPosType = INLINKTEXT;
                        }
                        else if ( iPosType == INLINKTEXT )
                        {
                              cLinkText = cText.Sub(iSt,iCr-1);
                              iSt = iCr+1;
                              iPosType = INLINKCOMMAND;
                        }
                        else
                        {
                             ((CxMultiEdit*)ptr_to_cxObject)->SetHyperText(cLinkText,cText.Sub(iSt,iCr-1));
                              iPosType = INPLAINTEXT;
                              iSt = iCr+1;
                        }
                  }
            }

                  if ( cText.Length() == 0 )
                   ((CxMultiEdit*)ptr_to_cxObject)->SetText(cText);
            else
                   ((CxMultiEdit*)ptr_to_cxObject)->SetText(cText.Sub(iSt,iCr-1));
*/


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

void CrMultiEdit::SetColour(int red, int green, int blue)
{
    ((CxMultiEdit*)ptr_to_cxObject)->SetColour(red,green,blue);
}


void CrMultiEdit::NoEcho(Boolean noEcho)
{
    mNoEcho = noEcho;
}

void CrMultiEdit::SetFontHeight(int height)
{
      ((CxMultiEdit*)ptr_to_cxObject)->SetFontHeight(height);
      return;
}
