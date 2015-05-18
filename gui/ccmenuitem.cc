// CcMenuItem.cpp: implementation of the CcMenuItem class.
//
//////////////////////////////////////////////////////////////////////

#include "crystalsinterface.h"
#include <string>
using namespace std;

#include "crconstants.h"

#ifdef CRY_USEMFC
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
    if(type == CR_SUBMENU)
    {
      delete ptr;
    }
    CrMenu::RemoveMenuItem (this);
}

void CcMenuItem::SetText(string theText)
{
    if( parent != nil)
        ((CxMenu*)parent->ptr_to_cxObject)->SetText(theText,id);
    text = theText;
}

void CcMenuItem::SetTitle(string theText)
{
    if( parent != nil) {
#ifdef CRY_USEMFC
        CxMenu* xp = (CxMenu*)ptr->ptr_to_cxObject;
        ((CxMenu*)parent->ptr_to_cxObject)->SetTitle(theText,xp);
#else
		((CxMenu*)parent->ptr_to_cxObject)->SetText(theText,id);
#endif
    }
    text = theText;
}


bool CcMenuItem::ParseInput( deque<string> &  tokenList )
{
    bool retVal = true;
    bool hasTokenForMe = true;

    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTTextSelector:
            {
                tokenList.pop_front(); // Remove that token!
                SetText(tokenList.front());
                tokenList.pop_front(); // Remove that token!
                break;
            }
            
            case kTSetCommandText:
            {
                tokenList.pop_front(); // Remove that token!
                originalcommand = command = string(tokenList.front());
                tokenList.pop_front(); // Remove that token!
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
