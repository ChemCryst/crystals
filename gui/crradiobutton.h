////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrRadioButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:29 Uhr

#ifndef		__CrRadioButton_H__
#define		__CrRadioButton_H__
#include	"crguielement.h"
//insert your own code here.
#include	"cctokenlist.h"
class CxRadioButton;
//End of user code.         
 
class	CrRadioButton : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
			CrRadioButton( CrGUIElement * mParentPtr );
			~CrRadioButton();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	GetValue();
		void	ButtonOn();
		void	SetState( Boolean state );
		
		// attributes
		
};
#endif
