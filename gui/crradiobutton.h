////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrRadioButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.6  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.5  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.4  2001/03/08 15:42:39  richard
//   Included a DISABLED= token for radiobutton (at last).
//

#ifndef     __CrRadioButton_H__
#define     __CrRadioButton_H__
#include    "crguielement.h"
class CxRadioButton;

class   CrRadioButton : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrRadioButton( CrGUIElement * mParentPtr );
            ~CrRadioButton();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue();
            void  GetValue(deque<string> & tokenList);
        void    ButtonOn();
        void    SetState( bool state );

        // attributes

};
#endif
