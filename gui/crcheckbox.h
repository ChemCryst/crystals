////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrCheckBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrCheckBox_H__
#define     __CrCheckBox_H__
#include    "crguielement.h"

class CcTokenList;

class   CrCheckBox : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrCheckBox( CrGUIElement * mParentPtr );
            ~CrCheckBox();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue();
        void    GetValue(CcTokenList * tokenList);
        void    BoxChanged( Boolean state );
        void    SetState( Boolean state );

        // attributes

};
#endif
