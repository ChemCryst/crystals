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

}

void CcMenuItem::SetText(CcString theText)
{
    if( parent != nil)
        ((CxMenu*)parent->ptr_to_cxObject)->SetText(theText,id);
    text = theText;
}
