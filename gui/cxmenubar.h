////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMenuBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMenuBar.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   09.6.1998 00:03 Uhr
//   Modified:  09.6.1998 00:03 Uhr

#ifndef           __CxMenuBar_H__
#define           __CxMenuBar_H__
//Insert your own code here.
#include	"crguielement.h"

#ifdef __POWERPC__
class LCaption;
#endif

#ifdef __MOTO__
#include	<LCaption.h>
#endif

#ifdef __BOTHWX__
#include <wx/menu.h>
#define BASEMENUBAR wxMenuBar
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASEMENUBAR CMenu
#endif

//End of user code.         
 
class CxMenuBar : public BASEMENUBAR
{
	public:
		void SetText(CcString theText, int id);
		int AddItem(int position = -1);
		int AddItem(char* text, int position = -1);
            int AddMenu(CxMenu* menuToAdd, char* text, int position = -1);
		// methods
            static CxMenuBar *   CreateCxMenu( CrMenu * container, CxWindow * guiParent );
                  CxMenuBar( CrMenu * container );
                  ~CxMenuBar();
            void PopupMenuHere(int x, int y, void *window);
            void EnableItem( int id, Boolean enable );


		// attributes
		CrGUIElement *	mWidget;
		
	protected:
		// methods
		
		// attributes
		static int	mMenuCount;

};
#endif
