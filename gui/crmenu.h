////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenu

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrMenu_H__
#define     __CrMenu_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
#include "cclist.h" // added by ClassView
class CxMenu;
class CcMenuItem;
class CxWindow;

#define NORMAL_MENU 0
#define POPUP_MENU  1
#define MENU_BAR    2

#define CR_MENUITEM 0
#define CR_SUBMENU  1
#define CR_SPLIT    2


class   CrMenu : public CrGUIElement
{
    public:
                CrMenu( CrGUIElement * mParentPtr , int menuType = NORMAL_MENU );
                ~CrMenu();

          // methods
        CcParse ParseInput( CcTokenList * tokenList );
        void Substitute(CcString atomname, int nSelected, CcString* atomNames);
        void Popup(int x, int y, void* window);
        int Condition(CcString conditions);

                void    CrFocus();
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);

          // attributes
                int mMenuType;
        CcList mMenuList;

};

#define kSMenu              "MENU"
#define kSEndMenu           "ENDMENU"

enum
{
 kTMenu = 1300,
 kTEndMenu
};



#endif
