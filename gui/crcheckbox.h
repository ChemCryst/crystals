////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrCheckBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:41 Uhr

#ifndef		__CrCheckBox_H__
#define		__CrCheckBox_H__
#include	"crguielement.h"
//Insert your own code here.
class CcTokenList;
//End of user code.         
 
class	CrCheckBox : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
			CrCheckBox( CrGUIElement * mParentPtr );
			~CrCheckBox();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	GetValue();
		void	GetValue(CcTokenList * tokenList);
		void	BoxChanged( Boolean state );
		void	SetState( Boolean state );
		
		// attributes
		
};
#endif
