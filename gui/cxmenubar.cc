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
#ifdef __CR_WIN__
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
#ifdef __CR_WIN__
      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING|MF_POPUP, (UINT)menuToAdd->m_hMenu, text.c_str());
#endif
#ifdef __BOTHWX__
      ostringstream strm;
      strm << "cxmenubar " << (int)this << " adding menu called " << text << (int)menuToAdd;
      if ( Append( menuToAdd, text.c_str()) )
          LOGSTAT ( strm.str() );
      else
          LOGERR ( "FAIL: "+strm.str() );
#endif
      return id;
}

int CxMenuBar::AddItem(const string & text, int position)
{
#ifdef __CR_WIN__
//      InsertMenu( (UINT)-1, MF_BYPOSITION|MF_STRING, (UINT)id, text.c_str());
#endif
#ifdef __BOTHWX__
//      Append(  text.c_str() );
#endif
      LOGERR ( "cxmenubar - ERROR - Can't add items to top level menu bar - " + text );
      return mMenuCount;
}

int CxMenuBar::AddItem(int position)
{
#ifdef __CR_WIN__
//    InsertMenu( (UINT)-1, MF_BYPOSITION|MF_SEPARATOR);
#endif
#ifdef __BOTHWX__
//      AppendSeparator();
#endif
    LOGERR ("cxmenubar - ERROR - Can't add separators to top level menu bar ");
    return 0;
}


void CxMenuBar::SetText(const string & theText, int id)
{
#ifdef __CR_WIN__
    ModifyMenu(id, MF_BYCOMMAND|MF_STRING, id, theText.c_str());
#endif
#ifdef __BOTHWX__
      SetLabel( id, theText.c_str() );
#endif

}

void CxMenuBar::PopupMenuHere(int x, int y, void *window)
{
#ifdef __CR_WIN__
      TrackPopupMenu(
                 TPM_LEFTALIGN | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
                  x, y, (CWnd*)window);
#endif
#ifdef __BOTHWX__
// This is handled by the window class. But that's easy:
//      ((wxWindow*)window)->PopupMenu(this, x, y);
      LOGERR("cxmenubar - ERROR - Can't popup a menu bar ");
#endif
}

void CxMenuBar::EnableItem( int id, bool enable )
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
