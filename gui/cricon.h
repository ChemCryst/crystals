////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CrIcon.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:38 Uhr

#ifndef           __CrIcon_H__
#define           __CrIcon_H__
#include	"crguielement.h"
#include	"cctokenlist.h"
class CxIcon;

class CrIcon : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
                  CrIcon( CrGUIElement * mParentPtr );
                  ~CrIcon();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		
		// attributes
		
};
#endif
