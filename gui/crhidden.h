////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrHidden

////////////////////////////////////////////////////////////////////////

//   Filename:  CrHidden.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $

#ifndef     __CrHidden_H__
#define     __CrHidden_H__
#include    "crguielement.h"
#include    "cctokenlist.h"

class   CrHidden : public CrGUIElement
{
    public:
        // methods
        CrHidden( CrGUIElement * mParentPtr );
        ~CrHidden();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetGeometry( const CcRect * rect );
        void    SetText( CcString text );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void CrFocus();
        void GetValue(CcTokenList * tokenList);
};
#endif
