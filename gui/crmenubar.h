////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenuBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMenuBar.h
//   Authors:   Richard Cooper

#ifndef         __CrMenuBar_H__
#define         __CrMenuBar_H__
#include "crguielement.h"
#include "cctokenlist.h"
#include "cclist.h"


class   CrMenuBar : public CrGUIElement
{
    public:

           CrMenuBar( CrGUIElement * mParentPtr );
           ~CrMenuBar();
// methods

           int Condition(CcString conditions);
           void CrFocus();
           CcParse ParseInput( CcTokenList * tokenList );
           void    SetText( CcString text );
           void    SetGeometry( const CcRect * rect );
           CcRect  GetGeometry();
           CcRect CalcLayout(bool recalculate=false);

// attributes
            int mMenuType;
            CcList mMenuList;

};

#endif
