////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrListBox_H__
#define     __CrListBox_H__
#include    "crguielement.h"
#include    "cctokenlist.h"

class   CrListBox : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrListBox( CrGUIElement * mParentPtr );
            ~CrListBox();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    SetText( CcString item );
        void    GetValue();
        void    GetValue(CcTokenList * tokenlist);
        void    Selected ( int item );
        void    Committed( int item );

        // attributes

};
#endif
