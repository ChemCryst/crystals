////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrCheckBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.5  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.4  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.3  2001/03/08 16:44:05  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CrCheckBox_H__
#define     __CrCheckBox_H__
#include    "crguielement.h"


class   CrCheckBox : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrCheckBox( CrGUIElement * mParentPtr );
            ~CrCheckBox();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue();
        void    GetValue(deque<string> & tokenList);
        void    BoxChanged( bool state );
        void    SetState( bool state );

        // attributes

};
#endif
