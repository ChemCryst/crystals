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
            void SysKey ( UINT nChar );
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
            void  SetOriginalSizes();       
		// attributes
		
private:
	Boolean mSendOnReturn;
      Boolean m_IsInput;
};

#define kSIsInput	"INPUT"
#define kSWantReturn	"SENDONRETURN"
#define kSIntegerInput	"INTEGER"
#define kSRealInput	"REAL"
#define kSNoInput	"READONLY"
#define kSAppend	"APPEND"

enum
{
 kTIsInput = 800, 
 kTWantReturn,	
 kTIntegerInput,	
 kTRealInput,	
 kTNoInput,	
 kTAppend	
};


#endif
