////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMenu

////////////////////////////////////////////////////////////////////////

#include	"CrystalsInterface.h"
#include	"CrMenu.h"
#include	"CxMenu.h"


int	CxMenu::mMenuCount = kMenuBase;
CxMenu *	CxMenu::CreateCxMenu( CrMenu * container, CxMenu * guiParent, Boolean popup )
{
	char * defaultName = (char *)"String";
	CxMenu	*theMenu = new CxMenu( container );
	if(popup)
		theMenu->CreatePopupMenu();
	else
		theMenu->CreateMenu();
	return theMenu;
}
CxMenu::CxMenu( CrMenu * container )
:CMenu()
{
	mWidget = container;
}

CxMenu::~CxMenu()
{
}

//To do: Add by position

int CxMenu::AddMenu(CxMenu * menuToAdd, char * text, int position)
{
	InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING|MF_POPUP, (UINT)menuToAdd->m_hMenu, text);
	return 0;
}

int CxMenu::AddItem(char * text, int position)
{
	InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING, (UINT)++mMenuCount, text);
	return mMenuCount;
}

int CxMenu::AddItem(int position)
{
	InsertMenu( (UINT)-1, MF_BYPOSITION|MF_SEPARATOR);
	return 0;
}


void CxMenu::SetText(CcString theText, int id)
{
	ModifyMenu(id, MF_BYCOMMAND|MF_STRING, id, theText.ToCString());
}


 
