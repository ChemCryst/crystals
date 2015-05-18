////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMenuBar

////////////////////////////////////////////////////////////////////////

#include    "crystalsinterface.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    "cccontroller.h"
#include    "crmenu.h"
#include    "cxmenu.h"
#include    "crmenubar.h"
#include    "cxmenubar.h"
#include    "cxwindow.h"


int   CxMenuBar::mMenuCount = kMenuBase;
CxMenuBar *    CxMenuBar::CreateCxMenu( CrMenuBar * container, CxWindow * guiParent)
{
      CxMenuBar      *theMenu = new CxMenuBar( container );
#ifdef CRY_USEMFC
        theMenu->CreateMenu();
#endif
      return theMenu;
}

CxMenuBar::CxMenuBar( CrMenuBar * container )
:BASEMENUBAR()
{
    ptr_to_crObject = container;
}

CxMenuBar::~CxMenuBar()
{

}

//To do: Add by position

int CxMenuBar::AddMenu(CxMenu * menuToAdd, const string & text, int position)
{
      int id = CrMenu::FindFreeMenuId();
#ifdef CRY_USEMFC
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING|MF_POPUP, (UINT)menuToAdd->m_hMenu, text.c_str());
#else
      ostringstream strm;
      strm << "cxmenubar " << (long)this << " adding menu called " << text << (long)menuToAdd;
      if ( Append( menuToAdd, text.c_str()) )
          LOGSTAT ( strm.str() );
      else
          LOGERR ( "FAIL: "+strm.str() );
#endif
      return id;
}

int CxMenuBar::AddItem(const string & text, int position)
{
#ifdef CRY_USEMFC
//      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING, (UINT)id, text.c_str());
#else
//      Append(  text.c_str() );
#endif
      LOGERR ( "cxmenubar - ERROR - Can't add items to top level menu bar - " + text );
      return mMenuCount;
}

int CxMenuBar::AddItem(int position)
{
#ifdef CRY_USEMFC
//    InsertMenu( (UINT)-1, MF_BYPOSITION|MF_SEPARATOR);
#else
//      AppendSeparator();
#endif
    LOGERR ("cxmenubar - ERROR - Can't add separators to top level menu bar ");
    return 0;
}


void CxMenuBar::SetText(const string & theText, int id)
{
#ifdef CRY_USEMFC
    ModifyMenu(id, MF_BYCOMMAND|MF_STRING, id, theText.c_str());
#else
      SetLabel( id, theText.c_str() );
#endif

}

void CxMenuBar::PopupMenuHere(int x, int y, void *window)
{
#ifdef CRY_USEMFC
      TrackPopupMenu(
                 TPM_LEFTALIGN | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
                  x, y, (CWnd*)window);
#else
// This is handled by the window class. But that's easy:
//      ((wxWindow*)window)->PopupMenu(this, x, y);
      LOGERR("cxmenubar - ERROR - Can't popup a menu bar ");
#endif
}

void CxMenuBar::EnableItem( int id, bool enable )
{
#ifdef CRY_USEMFC
      if (enable)
         EnableMenuItem( id, MF_ENABLED|MF_BYCOMMAND);
      else
         EnableMenuItem( id, MF_GRAYED|MF_BYCOMMAND);
#else
         Enable( id, enable );
#endif
}
