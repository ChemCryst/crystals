////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrBitmap

////////////////////////////////////////////////////////////////////////

//   Filename:  CrBitmap.h
//   Authors:   Richard Cooper 

#ifndef         __CrBitmap_H__
#define         __CrBitmap_H__
#include	"crguielement.h"

#include	"cctokenlist.h"
class CxBitmap;
 
class   CrBitmap : public CrGUIElement
{
	public:
		void CrFocus();
		// methods
                        CrBitmap( CrGUIElement * mParentPtr );
                        ~CrBitmap();
		Boolean	ParseInput( CcTokenList * tokenList );
                void    SetText( CcString text );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		
		// attributes
		
};

#define kSBitmapFile    "FILE"

enum
{
 kTBitmapFile = 1800
};



#endif
