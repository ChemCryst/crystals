////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CrTextOut.h
//   Authors:   Richard Cooper

#ifndef     __CrTextOut_H__
#define     __CrTextOut_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
#include    "ccrect.h"
class CxTextOut;

#define INPLAINTEXT 1
#define INLINKTEXT 2
#define INLINKCOMMAND 3

 class  CrTextOut : public CrGUIElement
{
    public:
        void CrFocus();
        int GetIdealWidth();
        int GetIdealHeight();
        // methods
            CrTextOut( CrGUIElement * mParentPtr );
            ~CrTextOut();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText ( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry ();
        CcRect CalcLayout(bool recalculate=false);
        void   ScrollPage(bool up);

                void ProcessLink( CcString aString );
        // attributes
};


#define kSFontSelect            "FONT"

enum {
 kTFontSelect = 1700
};


#endif
