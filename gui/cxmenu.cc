////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMenu

////////////////////////////////////////////////////////////////////////

#include	"crystalsinterface.h"
#include	"crmenu.h"
#include	"cxmenu.h"


int	CxMenu::mMenuCount = kMenuBase;
CxMenu *	CxMenu::CreateCxMenu( CrMenu * container, CxMenu * guiParent, Boolean popup )
{
//      char * defaultName = (char *)"String";
	CxMenu	*theMenu = new CxMenu( container );
#ifdef __WINDOWS__
	if(popup)
		theMenu->CreatePopupMenu();
	else
		theMenu->CreateMenu();
#endif
      return theMenu;
}

CxMenu::CxMenu( CrMenu * container )
:BASEMENU()
{
	mWidget = container;
}

CxMenu::~CxMenu()
{
}

//To do: Add by position

int CxMenu::AddMenu(CxMenu * menuToAdd, char * text, int position)
{
#ifdef __WINDOWS__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING|MF_POPUP, (UINT)menuToAdd->m_hMenu, text);
#endif
#ifdef __LINUX
      Append( -1, text, menuToAdd);
#endif
      return 0;
}

int CxMenu::AddItem(char * text, int position)
{
#ifdef __WINDOWS__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING, (UINT)++mMenuCount, text);
#endif
#ifdef __LINUX
      Append( -1, text );
#endif
	return mMenuCount;
}

int CxMenu::AddItem(int position)
{
#ifdef __WINDOWS__
	InsertMenu( (UINT)-1, MF_BYPOSITION|MF_SEPARATOR);
#endif
#ifdef __LINUX
      AppendSeparator();
#endif
	return 0;
}


void CxMenu::SetText(CcString theText, int id)
{
#ifdef __WINDOWS__
	ModifyMenu(id, MF_BYCOMMAND|MF_STRING, id, theText.ToCString());
#endif
#ifdef __LINUX
      SetLabel( id, theText.ToCString() );
#endif

}
 
void CxMenu::PopupMenuHere(int x, int y, void *window)
{
#ifdef __WINDOWS__
      TrackPopupMenu(
                 TPM_LEFTALIGN | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
                  x, y, (CWnd*)window); 
#endif
#ifdef __LINUX
// This is handled by the window class. But that's easy:
      ((wxWindow*)window)->PopupMenu(this, x, y);
#endif
}

void CxMenu::EnableItem( int id, Boolean enable )
{
#ifdef __WINDOWS__
      if (enable)
         EnableMenuItem( id, MF_ENABLED|MF_BYCOMMAND);
      else
         EnableMenuItem( id, MF_GRAYED|MF_BYCOMMAND);
#endif
#ifdef __LINUX
         Enable( id, enable );
#endif
}

