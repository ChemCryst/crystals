////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.h
//   Authors:   Richard Cooper
//   Created:   05.11.1998 14:26 Uhr
//   Modified:  05.11.1998 14:27 Uhr

#ifndef		__CrProgress_H__
#define		__CrProgress_H__
#include	"CrGUIElement.h"
//Insert your own code here.
#include	"CcTokenList.h"
class CxProgress;
//End of user code.         
 
class	CrProgress : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
			CrProgress( CrGUIElement * mParentPtr );
			~CrProgress();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		
		// attributes
		
};
#endif
