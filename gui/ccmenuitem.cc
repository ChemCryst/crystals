// CcMenuItem.cpp: implementation of the CcMenuItem class.
//
//////////////////////////////////////////////////////////////////////

#include "crystalsinterface.h"
#include "ccstring.h"
#include "crconstants.h"

#ifdef __CR_WIN__
#include "crystals.h"
#endif

#include "ccmenuitem.h"
#include "crmenu.h"
#include "cxmenu.h"
#include "cccontroller.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CcMenuItem::CcMenuItem(CrMenu* parentmenu)
{
    type = 100;
    id = 0;
    name = "defaultName";
    originaltext = text = "defaultText";
    originalcommand = command = "defaultCommand";
    ptr = nil;
    disable = 0;
    enable = 0;
    parent = parentmenu;

}

CcMenuItem::~CcMenuItem()
{
	CcController::theController->RemoveMenuItem (this);
}

void CcMenuItem::SetText(CcString theText)
{
    if( parent != nil)
        ((CxMenu*)parent->ptr_to_cxObject)->SetText(theText,id);
    text = theText;
}

void CcMenuItem::SetTitle(CcString theText)
{
    if( parent != nil) {
        CxMenu* xp = (CxMenu*)ptr->ptr_to_cxObject;
        ((CxMenu*)parent->ptr_to_cxObject)->SetTitle(theText,xp);
    }
    text = theText;
}


bool CcMenuItem::ParseInput( CcTokenList * tokenList )
{
    bool retVal = true;
    bool hasTokenForMe = true;

    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                SetText(tokenList->GetToken());
                break;
            }
            
            case kTSetCommandText:
            {
                tokenList->GetToken(); // Remove that token!
                originalcommand = command = tokenList->GetToken();
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
