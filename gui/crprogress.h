////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.h
//   Authors:   Richard Cooper
//   Created:   05.11.1998 14:26 Uhr
//   Modified:  05.11.1998 14:27 Uhr

#ifndef		__CrProgress_H__
#define		__CrProgress_H__
#include	"crguielement.h"
#include	"cctokenlist.h"
#include    "ccstring.h"
class CxProgress;
 
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
            void  SwitchText ( CcString * text );
		
		// attributes
		
};

#define kSComplete	"COMPLETE"

enum
{
 kTComplete = 1500
};


#endif
