////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrDropDown

////////////////////////////////////////////////////////////////////////

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crdropdown.h"
#include    "crgrid.h"
#include    "cxdropdown.h"
#include    "ccrect.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"    // for sending commands


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
#ifdef __CR_WIN__
        delete (CxDropDown*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrDropDown,CxDropDown)
CRGETGEOMETRY(CrDropDown,CxDropDown)
CRCALCLAYOUT(CrDropDown,CxDropDown)

CcParse CrDropDown::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;
    CcString theToken;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** DropDown *** Initing...");

        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created DropDown    " + mName );
    }
    // End of Init, now comes the general parser

    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTInform:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                if(inform)
                    LOGSTAT( "CrDropDown:ParseInput Dropdown INFORM on ");
                else
                    LOGSTAT( "CrDropDown:ParseInput Dropdown INFORM off ");
                mCallbackState = inform;
                break;
            }
            case kTAddToList:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean stop = false;
                while ( ! stop )
                {
                    theToken = tokenList->GetToken();

                    if ( strcmp( kSNull, theToken.ToCString() ) == 0 )
                        stop = true;
                    else
                    {
                        SetText( theToken );
                        LOGSTAT("Adding DropDown text '" + theToken + "'");
                    }
                }
                ((CxDropDown*)ptr_to_cxObject)->ResetHeight();
                break;
            }
            case kTSetSelection:
            {
                  tokenList->GetToken(); //Remove that token!
                  int select = atoi ( tokenList->GetToken().ToCString() );
                  ((CxDropDown*)ptr_to_cxObject)->CxSetSelection(select);
                  break;
            }
            case kTRemove:
            {
                  tokenList->GetToken(); //Remove that token!
                  int select = atoi ( tokenList->GetToken().ToCString() );
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

void    CrDropDown::SetText( CcString item )
{
    char theText[256];
    strcpy( theText, item.ToCString() );

    ( (CxDropDown *)ptr_to_cxObject)->AddItem( theText );
}

void    CrDropDown::GetValue()
{
    int value = ( (CxDropDown *)ptr_to_cxObject)->GetDropDownValue();

    SendCommand( CcString( value ) );
}



void    CrDropDown::GetValue(CcTokenList * tokenList)
{
    int desc = tokenList->GetDescriptor(kQueryClass);

    if( desc == kTQListtext )
    {
        tokenList->GetToken();
        CcString theString = tokenList->GetToken();
        int index = atoi( theString.ToCString() );
        CcString text = ( ( CxDropDown*)ptr_to_cxObject)->GetDropDownText(index);
        SendCommand( text,true );
    }
    else if (desc == kTQSelected )
    {
        tokenList->GetToken();
        int value = ( (CxDropDown *)ptr_to_cxObject)->GetDropDownValue();
        SendCommand( CcString( value ), true );
    }
    else
    {
        SendCommand( "ERROR",true );
        CcString error = tokenList->GetToken();
        LOGWARN( "CrDropDown:GetValue Error unrecognised token." + error);
    }
}

void    CrDropDown::Selected( int item )
{
    if(mCallbackState)
    {
        CcString theItem;
        theItem = CcString( item );
        SendCommand(mName + "_N" + theItem);

    }
}

void CrDropDown::CrFocus()
{
    ((CxDropDown*)ptr_to_cxObject)->Focus();
}
