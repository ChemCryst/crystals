////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenu

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.10  2002/03/13 12:20:55  richard
//   Update menus to allow context menus for clicked on bonds.
//
//   Revision 1.9  2002/02/20 12:05:20  DJWgroup
//   SH: Added class to allow easier passing of mouseover information from plot classes.
//
//   Revision 1.8  2002/02/19 16:34:52  ckp2
//   Menus for plots.
//
//   Revision 1.7  2001/06/17 15:10:15  richard
//   Lowercase included file for linux compatibility.
//   Reworked Substitute function so that a pointer to the modeldoc is
//   passed in rather than an array of atoms. The model has a public
//   function SelectedAsString("string") to return a list of the selected atoms
//   delimited by the string in "string".
//
//   Revision 1.6  2001/03/08 16:44:06  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CrMenu_H__
#define     __CrMenu_H__
#include    "crguielement.h"
#include "crplot.h"
#include <list>
using namespace std;

class CxMenu;
class CcMenuItem;
class CxWindow;
class CcModelDoc;

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
        CcParse ParseInput( deque<string> & tokenList );

        void Substitute(string atomname, CcModelDoc* model, string atom2);
        void Substitute(PlotDataPopup data);
        void Popup(int x, int y, void* window);
        int Condition(string conditions);

        void    CrFocus();
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);



        static int FindFreeMenuId();
        static void AddMenuItem( CcMenuItem * menuitem );
        static void RemoveMenuItem( CcMenuItem * menuitem );
//        static void RemoveMenuItem ( const string & menuitemname );
        static CcMenuItem* FindMenuItem( int id );
        static CcMenuItem* FindMenuItem( const string & name );


          // attributes
                int mMenuType;
        list<CcMenuItem*> mMenuList;

};

#define kSMenu              "MENU"
#define kSEndMenu           "ENDMENU"

enum
{
 kTMenu = 1300,
 kTEndMenu
};



#endif
