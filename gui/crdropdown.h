////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrDropDown

////////////////////////////////////////////////////////////////////////

//   Filename:  CrDropDown.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrDropDown_H__
#define     __CrDropDown_H__
#include    "crguielement.h"
class CcTokenList;

class   CrDropDown : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrDropDown( CrGUIElement * mParentPtr );
            ~CrDropDown();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    SetText( CcString item );
        void    GetValue();
        void    GetValue(CcTokenList* tokenList);
        void    Selected( int item );

        // attributes

};
#endif
