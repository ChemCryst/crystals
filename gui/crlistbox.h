////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

#ifndef		__CrListBox_H__
#define		__CrListBox_H__
#include	"crguielement.h"
//insert your own code here.
#include	"cctokenlist.h"
//End of user code.         
 
class	CrListBox : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
			CrListBox( CrGUIElement * mParentPtr );
			~CrListBox();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	SetText( CcString item );
		void	GetValue();
		void	Selected ( int item );
		void	Committed( int item );
		
		// attributes
		
};
#endif
