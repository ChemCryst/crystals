////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrDropDown

////////////////////////////////////////////////////////////////////////

//   Filename:  CrDropDown.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:04 Uhr

#ifndef		__CrDropDown_H__
#define		__CrDropDown_H__
#include	"CrGUIElement.h"
//Insert your own code here.
class CcTokenList;
//End of user code.         
 
class	CrDropDown : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
			CrDropDown( CrGUIElement * mParentPtr );
			~CrDropDown();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	SetText( CcString item );
		void	GetValue();
		void	GetValue(CcTokenList* tokenList);
		void	Selected( int item );
		
		// attributes
		
};
#endif
