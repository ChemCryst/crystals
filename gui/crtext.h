////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrText

////////////////////////////////////////////////////////////////////////

//   Filename:  CrText.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrText_H__
#define     __CrText_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
class CxText;

class   CrText : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrText( CrGUIElement * mParentPtr );
            ~CrText();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue(CcTokenList* tokenList);

        // attributes
};
#endif
