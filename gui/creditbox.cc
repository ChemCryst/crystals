////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrEditBox

////////////////////////////////////////////////////////////////////////

// $Log: not supported by cvs2svn $
// Revision 1.11  2001/06/17 15:14:12  richard
// Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
// Revision 1.10  2001/03/08 15:32:42  richard
// Limit=n token prevents user entering more than n characters.
//
// Revision 1.9  2001/01/16 15:34:57  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.8  2000/12/11 09:26:36  richard
// RIC: Modified way EDITBOX sends notify commands, so that when it is in
// a GRID with a COMMAND modifier, it will not send the COMMAND twice.
//
// Revision 1.7  1999/06/22 13:06:57  dosuser
// RIC: Only reset the text if in initialisation. This was where the
// editbox cursor was getting set to the beginning of the text. Fixed.
//
// Revision 1.6  1999/06/13 14:38:56  dosuser
// RIC: Added m_IsInput boolean. Set with the kTIsInput token. Causes
// the editbox to register itself as the user input place with the
// controller. Also sends text and clears itself automatically when
// return is pressed.
// RIC: SetOriginalSizes() is called after CalcLayout(), before Show() from
// kTShow in CrWindow. It adjusts the ideal width (mCharsWidth) to the size
// that it now is, rather than the size it was set to by SCRIPTS. This helps
// when calculating the change in size as the user resizes the whole window.
//
// Revision 1.5  1999/05/28 17:53:18  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.4  1999/05/07 16:03:52  dosuser
// RIC: Removed Arrow() function. System keys now arrive
// through SysKey() functions.
//
// Revision 1.3  1999/03/05 17:07:10  dosuser
// RIC: Standardising syntax. Main window definition moved to external
//      ASCII file for user flexibility.
//

//   Filename:  CrEditBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "creditbox.h"
#include    "crgrid.h"
#include    "cxeditbox.h"
#include    "ccrect.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"    // for sending commands
#include    "crwindow.h"  // for getting cursor keys

CrEditBox::CrEditBox( CrGUIElement * mParentPtr )
:   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxEditBox::CreateCxEditBox( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mXCanResize = true;
    mTabStop = true;
    mSendOnReturn = false;
    m_IsInput = false;
}

CrEditBox::~CrEditBox()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxEditBox*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
        delete (CxEditBox*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }

      mControllerPtr->RemoveInputPlace(this);

}

CRSETGEOMETRY(CrEditBox,CxEditBox)
CRGETGEOMETRY(CrEditBox,CxEditBox)

CcRect CrEditBox::CalcLayout(bool recalc)
{                                                                          
  if(!recalc) return CcRect(0,0,m_InitHeight,m_InitWidth);
  if (m_IsInput)
  {
    ((CxEditBox*)ptr_to_cxObject)->UpdateFont();
  }
  return CcRect(0,0,(int)(m_InitHeight=((CxEditBox*)ptr_to_cxObject)->GetIdealHeight()),
                          m_InitWidth =((CxEditBox*)ptr_to_cxObject)->GetIdealWidth());
};



CcParse CrEditBox::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** EditBox *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created EditBox     " + mName );

        while ( hasTokenForMe )
        {
            switch ( tokenList->GetDescriptor(kAttributeClass) )
            {
                case kTNumberOfColumns:
                case kTChars:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxEditBox*)ptr_to_cxObject)->SetVisibleChars( chars );
                    LOGSTAT( "Setting EditBox Chars Width: " + theString );
                    break;
                }
                case kTIntegerInput:
                {
                    tokenList->GetToken(); // Remove that token!
                    ((CxEditBox*)ptr_to_cxObject)->SetInputType( CXE_INT_NUMBER );
                    break;
                }
                case kTRealInput:
                {
                    tokenList->GetToken(); // Remove that token!
                    ((CxEditBox*)ptr_to_cxObject)->SetInputType( CXE_REAL_NUMBER );
                    break;
                }
                case kTNoInput:
                {
                    tokenList->GetToken(); // Remove that token!
                    ((CxEditBox*)ptr_to_cxObject)->SetInputType( CXE_READ_ONLY );
                    break;
                }
                case kTLimit:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxEditBox*)ptr_to_cxObject)->LimitChars( chars );
                    LOGSTAT( "Limiting EditBox characters: " + theString );
                    break;
                }
                default:
                {
                    hasTokenForMe = false;
                    break; // We leave the token in the list and exit the loop
                }
            } //end switch
        }// end while

            SetText(mText); //Re-set the text as it now knows if it is REAL,INT or TEXT..
    }// end if

    // End of Init, now comes the general parser

    hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting EditBox Text: " + mText );
                break;
            }
            case kTInform:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                mCallbackState = inform;
                if (mCallbackState)
                    LOGSTAT( "Enabling EditBox callback" );
                else
                    LOGSTAT( "Disabling EditBox callback" );
                break;
            }
            case kTDisabled:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean disabled = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                CcString temp = tokenList->GetToken(); // Remove that token!
                LOGSTAT( "EditBox disabled = " + temp);
                ((CxEditBox*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTAppend:
            {
                tokenList->GetToken(); // Remove that token!
                        ((CxEditBox*)ptr_to_cxObject)->AddText(tokenList->GetToken());
                        mText = ((CxEditBox*)ptr_to_cxObject)->GetText();
                break;
            }
            case kTWantReturn:
            {
                tokenList->GetToken(); // Remove that token!
                mSendOnReturn = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                break;
            }
            case kTIsInput:
            {
                tokenList->GetToken(); // Remove that token!
                m_IsInput = true;
                (CcController::theController)->SetInputPlace(this);
                ((CxEditBox*)ptr_to_cxObject)->IsInputPlace();
//                        ((CrWindow*)GetRootWidget())->SendMeSysKeys( (CrGUIElement*) this);
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

void CrEditBox::SetText( CcString text )
{

    char theText[256];
    strcpy( theText, text.ToCString() );

    ( (CxEditBox *)ptr_to_cxObject)->SetText( theText );

}

void CrEditBox::GetValue()
{
    char theText[256];
//TODO: Oops. Get text is a base class call. Wrap it.
    int textLen = ((CxEditBox*)ptr_to_cxObject)->GetText(&theText[0]);
    SendCommand( CcString( theText ) );
}

void CrEditBox::GetValue(CcTokenList * tokenList)
{
    int desc = tokenList->GetDescriptor(kQueryClass);
    if( desc == kTQText )
    {
        tokenList->GetToken();
        char theText[256];
        int textLen = ((CxEditBox*)ptr_to_cxObject)->GetText(&theText[0]);
        SendCommand( CcString( theText ), true );
    }
    else
    {
        SendCommand( "ERROR",true );
        CcString error = tokenList->GetToken();
        LOGWARN( "CrEditBox:GetValue Error unrecognised token." + error);
    }
}

void    CrEditBox::BoxChanged()
{
    if(mCallbackState)
    {
        char theText[256];
        int theTextLen = ((CxEditBox*)ptr_to_cxObject)->GetText(&theText[0]);
                SendCommand(mName + "_N" + CcString( theText ) );
    }
}

int CrEditBox::GetIdealWidth()
{
    return ((CxEditBox*)ptr_to_cxObject)->GetIdealWidth();
}

void CrEditBox::CrFocus()
{
    ((CxEditBox*)ptr_to_cxObject)->Focus();
}

void CrEditBox::ReturnPressed()
{
    if(mSendOnReturn)
    {
        char theText[256];
        int textLen = ((CxEditBox*)ptr_to_cxObject)->GetText(&theText[0]);
            if ( m_IsInput )
            {
                  SendCommand( CcString ( theText ) );
                  (CcController::theController)->AddHistory( theText );
                  ClearBox();
            }
            else
            {
                  SendCommand(mName + " " + CcString( theText ) );
            }
    }
    else
    {
        //FocusToInput, unless this IS the input, of course.
            if(m_IsInput)
            FocusToInput( (char)13 );
    }
}


void CrEditBox::AddText(CcString theText)
{
    ((CxEditBox*)ptr_to_cxObject)->AddText( (char*) theText.ToCString() );
}

void CrEditBox::ClearBox()
{
    ((CxEditBox*)ptr_to_cxObject)->ClearBox();
}

void CrEditBox::SysKey ( UINT nChar )
{
//Only send History requests if this is _the_ input window.
      if ( (CcController::theController)->GetInputPlace() == this)
      {
            switch ( nChar )
            {
                  case CRUP:
                        (CcController::theController)->History(true);
                        break;
                  case CRDOWN:
                        (CcController::theController)->History(false);
                        break;
                  default:
                        break;
            }
      }
}
