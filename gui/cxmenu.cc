////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMenu

////////////////////////////////////////////////////////////////////////

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "crmenu.h"
#include    "cxmenu.h"


int CxMenu::mMenuCount = kMenuBase;
CxMenu *    CxMenu::CreateCxMenu( CrMenu * container, CxMenu * guiParent, Boolean popup )
{
    CxMenu  *theMenu = new CxMenu( container );
#ifdef __CR_WIN__
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
    ptr_to_crObject = container;
}

CxMenu::~CxMenu()
{
}

//To do: Add by position

int CxMenu::AddMenu(CxMenu * menuToAdd, char * text, int position)
{
      int id = (CcController::theController)->FindFreeMenuId();
#ifdef __CR_WIN__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING|MF_POPUP, (UINT)menuToAdd->m_hMenu, text);
#endif
#ifdef __BOTHWX__
      Append( id, text, menuToAdd);
          LOGSTAT ( "cxmenu " + CcString((int)this) + " adding submenu called " + CcString(text) );
#endif
      return id;
}

int CxMenu::AddItem(char * text, int position)
{
      int id = (CcController::theController)->FindFreeMenuId();
#ifdef __CR_WIN__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING, (UINT)id, text);
#endif
#ifdef __BOTHWX__
      Append( id, wxString(text), wxString("") );
      LOGSTAT ("cxmenu " + CcString((int)this) + " adding item called " + CcString(text) );
#endif
    return id;
}

int CxMenu::AddItem(int position)
{
      int id = (CcController::theController)->FindFreeMenuId();
#ifdef __CR_WIN__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_SEPARATOR, (UINT)id);
#endif
#ifdef __BOTHWX__
      AppendSeparator();
#endif
    return id;
}


void CxMenu::SetText(CcString theText, int id)
{
#ifdef __CR_WIN__
    ModifyMenu(id, MF_BYCOMMAND|MF_STRING, id, theText.ToCString());
#endif
#ifdef __BOTHWX__
      SetLabel( id, theText.ToCString() );
#endif
}

void CxMenu::SetTitle(CcString theText, CxMenu* ptr)
{
#ifdef __CR_WIN__
    for ( int i = 0; i < (int)GetMenuItemCount() ; i++ )
    {
       CxMenu* subm = (CxMenu*)GetSubMenu(i);
       if (!subm) continue;
       if (!subm->m_hMenu) continue;

       if ( subm == ptr ) {
          ModifyMenu(i, MF_BYPOSITION|MF_STRING, i, theText.ToCString());
          break;
       }
    }
#endif
#ifdef __BOTHWX__
      SetLabel( id, theText.ToCString() );
#endif
}

void CxMenu::PopupMenuHere(int x, int y, void *window)
{
#ifdef __CR_WIN__
      TrackPopupMenu(
                 TPM_LEFTALIGN | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
                  x, y, (CWnd*)window);
#endif
#ifdef __BOTHWX__
// This is handled by the window class. But that's easy:
      ((wxWindow*)window)->PopupMenu(this, x, y);
#endif
}

void CxMenu::EnableItem( int id, Boolean enable )
{
#ifdef __CR_WIN__
      if (enable)
         EnableMenuItem( id, MF_ENABLED|MF_BYCOMMAND);
      else
         EnableMenuItem( id, MF_GRAYED|MF_BYCOMMAND);
#endif
#ifdef __BOTHWX__
         Enable( id, enable );
#endif
}
