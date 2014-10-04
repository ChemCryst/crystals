////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
// $Log: not supported by cvs2svn $
// Revision 1.1.1.1  2004/12/13 11:16:17  rich
// New CRYSTALS repository
//
// Revision 1.15  2004/06/28 13:26:57  rich
// More Linux fixes, stl updates.
//
// Revision 1.14  2004/06/24 09:12:01  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.13  2003/05/07 12:18:56  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.12  2003/02/20 14:08:04  rich
// New option of making buttoms "SLIM" they fit into text more easily.
//
// Revision 1.11  2003/01/14 10:27:18  rich
// Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
// Revision 1.10  2001/12/12 14:06:36  ckp2
// RIC: Give buttons the "INFORM=NO" attribute and they'll not inform you that
// they've been pressed. Instead you can query them using ^^?? BTNNAME STATE and
// get "ON" if they've been pressed. Use SET INFORM=NO to reset the state if you
// want to use them again. Can be used for an "ABORT" type of button which can be
// checked again and again during long operations.
//
// Revision 1.9  2001/09/07 14:35:19  ckp2
// LENGTH='a string' option lets the button length be based on a string other
// than the one actually displayed. Useful for making professional looking
// buttons in a given row, e.g.
//
// @ 1,1 BUTTON BOK '&OK' LENGTH='Cancel'
// @ 1,3 BUTTON BXX '&Cancel'
//
// makes both buttons equal width.
//
// Revision 1.8  2001/06/17 15:14:12  richard
// Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
// Revision 1.7  2001/03/21 16:59:51  richard
// Ensure button removes itself from controllers list of disableable buttons, if appropriate,
// when it is destroyed.
//
// Revision 1.6  2001/03/08 15:30:50  richard
// Now DISABLEIF and ENABLEIF flags allow buttons to appear in non-modal windows
// without worry of interfering with scripts.
//
// Revision 1.5  2001/01/16 15:34:57  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.4  2000/12/13 17:54:16  richard
// Support for Linux. Changed SetDefault function in CxButton to prevent
// it clashing with a base class function in the wx library.
//


#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crbutton.h"
#include    "crwindow.h"

#include    "crgrid.h"
#include    "cxbutton.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrButton::CrButton( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxButton::CreateCxButton( this,
                                (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
    mCallbackState= true;
    m_AddedToDisableAbleButtonList = false;
    bEnableFlags = 0;
    bDisableFlags = 0;
}

CrButton::~CrButton()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxButton*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
        delete (CxButton*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
    if ( m_AddedToDisableAbleButtonList ) CcController::theController->RemoveDisableableButton(this);


}

CRSETGEOMETRY(CrButton,CxButton)
CRGETGEOMETRY(CrButton,CxButton)
CRCALCLAYOUT(CrButton,CxButton)

CcParse CrButton::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("CrButton:ParseInput Button *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT("CrButton:ParseInput Created Button      " + mName );
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
                LOGSTAT( "CrButton:ParseInput Setting Button Text: " + mText );
                break;
            }
            case kTInform:
            {
                tokenList.pop_front(); // Remove that token!
                bool inform = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(inform) {
                    LOGSTAT( "CrButton:ParseInput INFORM on (default)");
                }
                else {
                    LOGSTAT( "CrCheckBox:ParseInput INFORM off (reset)");
                    ((CxButton*)ptr_to_cxObject)->CxSetState(false);
                }
                mCallbackState = inform;
                m_ButtonWasPressed=false;
                break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                bool disabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(disabled)
                    LOGSTAT( "CrButton:ParseInput Button disabled ");
                else
                    LOGSTAT( "CrButton:ParseInput Button enabled ");
                ((CxButton*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTLength:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxButton*)ptr_to_cxObject)->SetLength( tokenList.front() );
                tokenList.pop_front();
                break;
            }
            case kTSlim:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxButton*)ptr_to_cxObject)->SetSlim();
                break;
            }
            case kTSetCommitText:
            {
                tokenList.pop_front(); // Remove that token!
                ((CrWindow*)GetRootWidget())->SetCommitText( mName );
                break;
            }
            case kTSetCancelText:
            {
                tokenList.pop_front(); // Remove that token!
                ((CrWindow*)GetRootWidget())->SetCancelText( mName );
                break;
            }
            case kTDefault:
            {
                ((CxButton*)ptr_to_cxObject)->SetDef();
                tokenList.pop_front(); // Remove that token!
                LOGSTAT( "CrButton:ParseInput Setting default button" );
                break;
            }
            case kTMenuDisableCondition:
            {
                tokenList.pop_front();
                bDisableFlags = (CcController::theController)->status.CreateFlag(tokenList.front());
                tokenList.pop_front();
                if ( !m_AddedToDisableAbleButtonList )
                {
                    m_AddedToDisableAbleButtonList = true;
                    CcController::theController->AddDisableableButton(this);
                }
                break;
            }
            case kTMenuEnableCondition:
            {
                tokenList.pop_front();
                bEnableFlags = (CcController::theController)->status.CreateFlag(tokenList.front());
                tokenList.pop_front();
                if ( !m_AddedToDisableAbleButtonList )
                {
                  m_AddedToDisableAbleButtonList = true;
                  CcController::theController->AddDisableableButton(this);
                }
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

void    CrButton::SetText( const string &text )
{
    ( (CxButton *)ptr_to_cxObject)->SetText( text );
}

void    CrButton::ButtonClicked()
{
    if ( mCallbackState )
    {
        SendCommand(mName);
    }
    else
    {
        m_ButtonWasPressed = true;
        ((CxButton*)ptr_to_cxObject)->CxSetState(true);
    }
}

void CrButton::CrFocus()
{
    ((CxButton*)ptr_to_cxObject)->Focus();
}

void CrButton::Enable(bool enabled)
{
    ((CxButton*)ptr_to_cxObject)->Disable( !enabled );
}

void CrButton::GetValue( deque<string> &  tokenList)
{
    if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQState )
    {
        tokenList.pop_front();
        if ( m_ButtonWasPressed )
            SendCommand( kSOn,true);
        else
            SendCommand( kSOff,true);
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrButton:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }
}
