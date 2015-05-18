////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrDropDown

////////////////////////////////////////////////////////////////////////

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crdropdown.h"
#include    "crgrid.h"
#include    "cxdropdown.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands
#include    <string>
#include    <sstream>


CrDropDown::CrDropDown( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxDropDown::CreateCxDropDown( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
}

CrDropDown::~CrDropDown()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxDropDown*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxDropDown*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrDropDown,CxDropDown)
CRGETGEOMETRY(CrDropDown,CxDropDown)
CRCALCLAYOUT(CrDropDown,CxDropDown)

CcParse CrDropDown::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;
    string theToken;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** DropDown *** Initing...");

        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created DropDown    " + mName );
    }
    // End of Init, now comes the general parser

    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTInform:
            {
                tokenList.pop_front(); // Remove that token!
                bool inform = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if(inform)
                    LOGSTAT( "CrDropDown:ParseInput Dropdown INFORM on ");
                else
                    LOGSTAT( "CrDropDown:ParseInput Dropdown INFORM off ");
                mCallbackState = inform;
                break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                bool disabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                LOGSTAT( "Dropdown disabled = " + tokenList.front());
                tokenList.pop_front();
                ((CxDropDown*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTAddToList:
            {
                tokenList.pop_front(); // Remove that token!
                bool stop = false;
                while ( ! stop )
                {
                    if ( strcmp( kSNull, tokenList.front().c_str() ) == 0 )
                        stop = true;
                    else
                    {
                        SetText( tokenList.front() );
                        LOGSTAT("Adding DropDown text '" + tokenList.front() + "'");
                    }
                    tokenList.pop_front();
                }
                ((CxDropDown*)ptr_to_cxObject)->ResetHeight();
                break;
            }
            case kTSetSelection:
            {
                  tokenList.pop_front(); //Remove that token!
                  int select = atoi ( tokenList.front().c_str() );
                  tokenList.pop_front();
                  ((CxDropDown*)ptr_to_cxObject)->CxSetSelection(select);
                  break;
            }
            case kTRemove:
            {
                  tokenList.pop_front(); //Remove that token!
                  int select = atoi ( tokenList.front().c_str() );
                  tokenList.pop_front();
                  ((CxDropDown*)ptr_to_cxObject)->CxRemoveItem(select);
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

void    CrDropDown::SetText( const string &item )
{
    ( (CxDropDown *)ptr_to_cxObject)->AddItem( item );
}

void    CrDropDown::GetValue()
{
    ostringstream strm;
    strm << ((CxDropDown *)ptr_to_cxObject)->GetDropDownValue();
    SendCommand( strm.str() );
}



void    CrDropDown::GetValue(deque<string> &  tokenList)
{
    int desc = CcController::GetDescriptor( tokenList.front(), kQueryClass );

    if( desc == kTQListtext )
    {
        tokenList.pop_front();
        SendCommand( ((CxDropDown*)ptr_to_cxObject)->GetDropDownText(atoi( tokenList.front().c_str() )),true );
        tokenList.pop_front();
    }
    else if (desc == kTQSelected )
    {
        tokenList.pop_front();
        ostringstream strm;
        strm << ( (CxDropDown *)ptr_to_cxObject)->GetDropDownValue();
        SendCommand( strm.str() , true );
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrDropDown:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }
}

void    CrDropDown::Selected( int item )
{
    if(mCallbackState)
    {
        ostringstream strm;
        strm << mName << "_N" << item;
        SendCommand( strm.str() );

    }
}

void CrDropDown::CrFocus()
{
    ((CxDropDown*)ptr_to_cxObject)->Focus();
}
