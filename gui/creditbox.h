////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrEditBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:15 Uhr

#ifndef		__CrEditBox_H__
#define		__CrEditBox_H__
#include	"crguielement.h"
//Insert your own code here.
class CcTokenList;
//End of user code.         
 
class	CrEditBox : public CrGUIElement
{
	public:
		void ClearBox();
		void Arrow(Boolean up);
		void AddText(CcString theText);
		void ReturnPressed();
		void CrFocus();
		int GetIdealWidth();
		// methods
			CrEditBox( CrGUIElement * mParentPtr );
			~CrEditBox();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	GetValue();
		void	GetValue(CcTokenList* tokenList);
		void	BoxChanged();
		
		// attributes
		
private:
	Boolean mSendOnReturn;
};
#endif
