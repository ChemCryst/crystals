////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxRadioButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 10:38 Uhr

#ifndef		__CxRadioButton_H__
#define		__CxRadioButton_H__
//Insert your own code here.
#include	"CrGUIElement.h"

#include <afxwin.h>


class CrRadioButton;
class CxGrid;
//End of user code.         
 
class	CxRadioButton : public CButton
{
	public:
		void Focus();
		// methods
		static CxRadioButton *	CreateCxRadioButton( CrRadioButton * container, CxGrid * guiParent );
			CxRadioButton( CrRadioButton * container);
			~CxRadioButton();
//		void	ButtonChanged();
		void	SetText( char * text );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int	AddRadioButton();
		static void	RemoveRadioButton();
		void	BroadcastValueMessage();
		void	SetRadioState( Boolean inValue );
		Boolean	GetRadioState();

		afx_msg void ButtonChanged();
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

		DECLARE_MESSAGE_MAP()

		// attributes
		CrGUIElement *	mWidget;
		
	protected:
		// methods
		
		// attributes
		static int	mRadioButtonCount;
		
};
#endif
