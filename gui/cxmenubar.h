////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxMenuBar
////////////////////////////////////////////////////////////////////////

//   Filename:  CxMenuBar.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   09.6.1998 00:03 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.4  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef           __CxMenuBar_H__
#define           __CxMenuBar_H__
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
#define BASEMENUBAR wxMenuBar
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEMENUBAR CMenu
#endif

class CxMenu;
class CrMenu;
class CxWindow;
class CrMenuBar;

class CxMenuBar : public BASEMENUBAR
{
    public:
        void SetText(CcString theText, int id);
        int AddItem(int position = -1);
        int AddItem(char* text, int position = -1);
        int AddMenu(CxMenu* menuToAdd, char* text, int position = -1);

        // methods
        static CxMenuBar *   CreateCxMenu( CrMenuBar * container, CxWindow * guiParent );
        CxMenuBar( CrMenuBar * container );
        ~CxMenuBar();
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
