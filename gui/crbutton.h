////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

#ifndef		__CrButton_H__
#define		__CrButton_H__
#include	"crguielement.h"
//Insert your own code here.
class CcTokenList;
//End of user code.         
 
class	CrButton : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
			CrButton( CrGUIElement * mParentPtr );
			~CrButton();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	ButtonClicked();
		
		// attributes
};

#define kSDefault	"DEFAULT"

enum 
{
 kTDefault = 600
};

#endif
