////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMenu.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   09.6.1998 00:03 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.6  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxMenu_H__
#define     __CxMenu_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef __POWERPC__
class LCaption;
#endif

#ifdef __MOTO__
#include    <LCaption.h>
#endif

#ifdef __BOTHWX__
#include <wx/menu.h>
#define BASEMENU wxMenu
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEMENU CMenu
#endif

class CrMenu;
class CxMenu;


class CxMenu : public BASEMENU
{
    public:
        void SetText(CcString theText, int id);
        void SetTitle(CcString theText, CxMenu* ptr);
        int AddItem(int position = -1);
        int AddItem(char* text, int position = -1);
        int AddMenu(CxMenu* menuToAdd, char* text, int position = -1);
        // methods
        static CxMenu * CreateCxMenu( CrMenu * container, CxMenu * guiParent, Boolean popup = FALSE );
            CxMenu( CrMenu * container );
            ~CxMenu();
            void PopupMenuHere(int x, int y, void *window);
            void EnableItem( int id, Boolean enable );


        // attributes
        CrGUIElement *  ptr_to_crObject;

    protected:
        // methods

        // attributes
        static int  mMenuCount;

};
#endif
