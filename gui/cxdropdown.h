////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxDropDown

////////////////////////////////////////////////////////////////////////

//   Filename:  CxDropDown.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  6.3.1998 10:10 Uhr

#ifndef		__CxDropDown_H__
#define		__CxDropDown_H__
//Insert your own code here.
#include	"CrGUIElement.h"

#ifdef __POWERPC__
class LStdPopupMenu;
#endif

#ifdef __MOTO__
#include	<LStdControl.h>
#endif

#ifdef __LINUX__
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#endif

class CrDropDown;
class CxGrid;
//End of user code.         
 
class	CxDropDown : public CComboBox
{
	public:
		CcString GetDropDownText(int index);
		int mItems;
		void Focus();
		// methods
		static CxDropDown *	CreateCxDropDown( CrDropDown * container, CxGrid * guiParent );
			CxDropDown( CrDropDown * container );
			~CxDropDown();
		void	Selected();
		void	AddItem( char * text );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int	AddDropDown( void ) { mDropDownCount++; return mDropDownCount; };
		static void	RemoveDropDown( void ) { mDropDownCount--; };
		void BroadcastValueMessage( void );
		int	GetDropDownValue();
		
		// attributes
		CrGUIElement *	mWidget;
		static int	mDropDownCount;

		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

		DECLARE_MESSAGE_MAP()

};
#endif
