////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGrid.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 16:18 Uhr

#ifndef		__CxGrid_H__
#define		__CxGrid_H__
//Insert your own code here.
#include	"CrGUIElement.h"

#include	<afxwin.h>
#include	"CxRadioButton.h"

class CrGrid;
class CxGrid;

//End of user code.         
 
class	CxGrid : public CWnd
{
	public:
		// methods
		static CFont* mp_font;
		static CxGrid *	CreateCxGrid( CrGrid * container, CxGrid * guiParent );
			CxGrid( CrGrid * container );
			~CxGrid();
		void	SetText( char * text );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
//		static int AddGrid( void) { mGridCount++; return mGridCount; };
//		static void RemoveGrid( void) { mGridCount--; };
		void	AddRadioButton( CxRadioButton * theRadio );
		
		// attributes
		CrGUIElement *	mWidget;
		static int mGridCount;
//		QButtonGroup * mRadioGroup;
};
#endif
