////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMenuBar

////////////////////////////////////////////////////////////////////////

#include	"crystalsinterface.h"
#include	"crmenu.h"
#include    "cxmenu.h"
#include    "cxmenubar.h"


int   CxMenuBar::mMenuCount = kMenuBase;
CxMenuBar *    CxMenuBar::CreateCxMenu( CrMenu * container, CxWindow * guiParent)
{
      CxMenuBar      *theMenu = new CxMenuBar( container );
#ifdef __WINDOWS__
		theMenu->CreateMenu();
#endif
      return theMenu;
}

CxMenuBar::CxMenuBar( CrMenu * container )
:BASEMENUBAR()
{
	mWidget = container;
}

CxMenuBar::~CxMenuBar()
{
}

//To do: Add by position

int CxMenuBar::AddMenu(CxMenu * menuToAdd, char * text, int position)
{
#ifdef __WINDOWS__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING|MF_POPUP, (UINT)menuToAdd->m_hMenu, text);
#endif
#ifdef __LINUX
      Append( -1, text, menuToAdd);
#endif
      return 0;
}

int CxMenuBar::AddItem(char * text, int position)
{
#ifdef __WINDOWS__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING, (UINT)++mMenuCount, text);
#endif
#ifdef __LINUX
      Append( -1, text );
#endif
	return mMenuCount;
}

int CxMenuBar::AddItem(int position)
{
#ifdef __WINDOWS__
	InsertMenu( (UINT)-1, MF_BYPOSITION|MF_SEPARATOR);
#endif
#ifdef __LINUX
      AppendSeparator();
#endif
	return 0;
}


void CxMenuBar::SetText(CcString theText, int id)
{
#ifdef __WINDOWS__
	ModifyMenu(id, MF_BYCOMMAND|MF_STRING, id, theText.ToCString());
#endif
#ifdef __LINUX
      SetLabel( id, theText.ToCString() );
#endif

}
 
void CxMenuBar::PopupMenuHere(int x, int y, void *window)
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

void CxMenuBar::EnableItem( int id, Boolean enable )
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

