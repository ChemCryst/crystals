////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenu

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

#ifndef		__CrMenu_H__
#define		__CrMenu_H__
#include	"crguielement.h"
//insert your own code here.
#include	"cctokenlist.h"
#include "cclist.h"	// added by ClassView
class CxMenu;
class CcMenuItem;
class CxWindow;
//End of user code.         
 
class	CrMenu : public CrGUIElement
{
	public:
		void Substitute(CcString atomname, int nSelected, CcString* atomNames);
		void Popup(int x, int y, void* window);
		CcMenuItem* FindItembyID(int id);
		int Condition(CcString conditions);
		CcList mMenuList;
		void CrFocus();
		// methods
			CrMenu( CrGUIElement * mParentPtr );
			CrMenu( CrGUIElement * mParentPtr , Boolean IsAPopupMenu );
			~CrMenu();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		
		// attributes
		
};
#endif
