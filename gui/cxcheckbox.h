////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxCheckBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 10:38 Uhr

#ifndef		__CxCheckBox_H__
#define		__CxCheckBox_H__
//Insert your own code here.
#include	"crguielement.h"

#ifdef __POWERPC__
class LStdCheckBox;
#endif

#ifdef __MOTO__
#include	<LStdControl.h>;
#endif

#ifdef __LINUX__
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#endif

class CrCheckBox;
class CxGrid;
//End of user code.         
 
class	CxCheckBox : public CButton
{
	public:
		void Focus();
		// methods
		static CxCheckBox *	CreateCxCheckBox( CrCheckBox * container, CxGrid * guiParent );
			CxCheckBox( CrCheckBox * container);
			~CxCheckBox();
//		void	BoxClicked();
		void	SetText( char * text );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int	AddCheckBox();
		static void	RemoveCheckBox();
		void	BroadcastValueMessage();
		void	SetBoxState( Boolean inValue );
		void	Disable(Boolean disabled);
		Boolean	GetBoxState();
		
		// attributes
		CrGUIElement *	mWidget;

		afx_msg void BoxClicked();
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

		DECLARE_MESSAGE_MAP()

		
	protected:
		// methods
		
		// attributes
		static int	mCheckBoxCount;
		
};
#endif
