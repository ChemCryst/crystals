////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   6.3.1998 00:02 Uhr
//   Modified:  6.3.1998 00:02 Uhr

#ifndef		__CrMultiEdit_H__
#define		__CrMultiEdit_H__
#include	"crguielement.h"
//insert your own code here.
#include	"cctokenlist.h"
#include	"ccrect.h"
class CxMultiEdit;
//End of user code.         

 class	CrMultiEdit : public CrGUIElement
{
	public:
		Boolean mNoEcho;
		void NoEcho(Boolean noEcho);
		void SetColour(int red, int green, int blue);
		void CrFocus();
		int GetIdealWidth();
		int GetIdealHeight();
		// methods
			CrMultiEdit( CrGUIElement * mParentPtr );
			~CrMultiEdit();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText ( CcString text );
		void 	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry ();
		void	CalcLayout();
		void    Changed();	
//		void    SetWidthScale(float w);
//		CcRect  GetOriginalGeometry();

		// attributes
//		CcRect mOriginalGeometry;
};
#endif
