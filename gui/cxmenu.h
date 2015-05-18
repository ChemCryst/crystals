////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMenu.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   09.6.1998 00:03 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.9  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.8  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.7  2002/01/31 14:58:56  ckp2
//   RIC: SetTitle function allows substitution of atom names into menuitems which
//   open submenus.
//
//   Revision 1.6  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxMenu_H__
#define     __CxMenu_H__
//Insert your own code here.
#include    "crguielement.h"

//#ifdef __POWERPC__
//class LCaption;
//#endif

#ifdef __MOTO__
#include    <LCaption.h>
#endif

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASEMENU CMenu
#else
 #include <wx/menu.h>
 #define BASEMENU wxMenu
#endif


class CrMenu;
class CxMenu;


class CxMenu : public BASEMENU
{
    public:
        void SetText(const string & theText, int id);
        void SetTitle(const string & theText, CxMenu* ptr);
        int AddItem(int position = -1);
        int AddItem(const string & text, int position = -1);
        int AddMenu(CxMenu* menuToAdd, const string & text, int position = -1);
        // methods
        static CxMenu * CreateCxMenu( CrMenu * container, CxMenu * guiParent, bool popup = FALSE );
            CxMenu( CrMenu * container );
            ~CxMenu();
            void PopupMenuHere(int x, int y, void *window);
            void EnableItem( int id, bool enable );


        // attributes
        CrGUIElement *  ptr_to_crObject;

    protected:
        // methods

        // attributes
        static int  mMenuCount;

};
#endif
