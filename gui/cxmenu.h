////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMenu.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   09.6.1998 00:03 Uhr
//   Modified:  09.6.1998 00:03 Uhr

#ifndef		__CxMenu_H__
#define		__CxMenu_H__
//Insert your own code here.
#include	"CrGUIElement.h"

#ifdef __POWERPC__
class LCaption;
#endif

#ifdef __MOTO__
#include	<LCaption.h>
#endif

#ifdef __LINUX__
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#endif

//End of user code.         
 
class	CxMenu : public CMenu
{
	public:
		void SetText(CcString theText, int id);
		int AddItem(int position = -1);
		int AddItem(char* text, int position = -1);
		int AddMenu(CxMenu* menuToAdd, char* text, int position = -1);
		// methods
		static CxMenu *	CreateCxMenu( CrMenu * container, CxMenu * guiParent, Boolean popup = FALSE );
			CxMenu( CrMenu * container );
			~CxMenu();
		
		// attributes
		CrGUIElement *	mWidget;
		
	protected:
		// methods
		
		// attributes
		static int	mMenuCount;

};
#endif
