////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrCheckBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:19  rich
//   New CRYSTALS repository
//
//   Revision 1.8  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
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
//   Revision 1.5  2001/06/17 15:14:12  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.4  2001/03/08 16:44:04  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crcheckbox.h"

#include    "crgrid.h"
#include    "cxcheckbox.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands

CrCheckBox::CrCheckBox( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxCheckBox::CreateCxCheckBox( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
    mCallbackState = false;
}

CrCheckBox::~CrCheckBox()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxCheckBox*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxCheckBox*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrCheckBox,CxCheckBox)
CRGETGEOMETRY(CrCheckBox,CxCheckBox)
CRCALCLAYOUT(CrCheckBox,CxCheckBox)

CcParse CrCheckBox::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** CheckBox *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created CheckBox    " + mName );
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
                LOGSTAT( "Setting CheckBox Text: " + mText );
                break;
            }
            case kTInform:
            {
                tokenList.pop_front(); // Remove that token!
                bool inform = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(inform)
                    LOGSTAT( "CrCheckBox:ParseInput Checkbox INFORM on ");
                else
                    LOGSTAT( "CrCheckBox:ParseInput Checkbox INFORM off ");
                mCallbackState = inform;
                break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                bool disabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(disabled)
                    LOGSTAT( "CrCheckBox:ParseInput Checkbox disabled ");
                else
                    LOGSTAT( "CrCheckBox:ParseInput Checkbox enabled ");
                ((CxCheckBox*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTState:
            {
                tokenList.pop_front(); // Remove that token!
                bool state = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTOn) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(state)
                    LOGSTAT( "CrCheckBox:ParseInput Checkbox STATE on ");
                else
                    LOGSTAT( "CrCheckBox:ParseInput Checkbox STATE off ");
                SetState(state);
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
void    CrCheckBox::SetText( const string &text )
{
    ( (CxCheckBox *)ptr_to_cxObject)->SetText( text );
}

void    CrCheckBox::GetValue()
{
    if ( ((CxCheckBox*)ptr_to_cxObject)->GetBoxState() )
        SendCommand( kSOn );
    else
        SendCommand( kSOff );
}

void    CrCheckBox::GetValue(deque<string> & tokenList)
{
    if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQState )
    {
        tokenList.pop_front();
        if ( ((CxCheckBox*)ptr_to_cxObject)->GetBoxState() )
            SendCommand( kSOn,true);
        else
            SendCommand( kSOff,true);
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrCheckBox:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }
}

void    CrCheckBox::BoxChanged( bool state )
{
    if(mCallbackState)
    {
        if ( state )
            SendCommand(mName + "_N" + kSOn);
        else
            SendCommand(mName + "_N" + kSOff);
    }
}

void    CrCheckBox::SetState( bool state )
{
    ((CxCheckBox*)ptr_to_cxObject)->SetBoxState(state);
}

void CrCheckBox::CrFocus()
{
    ((CxCheckBox*)ptr_to_cxObject)->Focus();
}
