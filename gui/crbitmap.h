////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrBitmap

////////////////////////////////////////////////////////////////////////

//   Filename:  CrBitmap.h
//   Authors:   Richard Cooper

#ifndef         __CrBitmap_H__
#define         __CrBitmap_H__
#include    "crguielement.h"

#include    "cctokenlist.h"
class CxBitmap;

class   CrBitmap : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
                        CrBitmap( CrGUIElement * mParentPtr );
                        ~CrBitmap();
        CcParse ParseInput( CcTokenList * tokenList );
                void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);

        // attributes
        bool m_Trans;
};

#define kSBitmapFile    "FILE"
#define kSTransparent   "TRANS"

enum
{
 kTBitmapFile = 1800,
 kTTransparent
};



#endif
