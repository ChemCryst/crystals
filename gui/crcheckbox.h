////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrCheckBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.3  2001/03/08 16:44:05  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

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
        void    BoxChanged( bool state );
        void    SetState( bool state );

        // attributes

};
#endif
