////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrRadioButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrRadioButton_H__
#define     __CrRadioButton_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
class CxRadioButton;

class   CrRadioButton : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrRadioButton( CrGUIElement * mParentPtr );
            ~CrRadioButton();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue();
            void  GetValue(CcTokenList * tokenList);
        void    ButtonOn();
        void    SetState( Boolean state );

        // attributes

};
#endif
