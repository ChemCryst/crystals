////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrText

////////////////////////////////////////////////////////////////////////

//   Filename:  CrText.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:38 Uhr

#ifndef		__CrText_H__
#define		__CrText_H__
#include	"crguielement.h"
//insert your own code here.
#include	"cctokenlist.h"
class CxText;
//End of user code.         
 
class	CrText : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
			CrText( CrGUIElement * mParentPtr );
			~CrText();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		
		// attributes
		
};
#endif
