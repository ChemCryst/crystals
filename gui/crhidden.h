////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrHidden

////////////////////////////////////////////////////////////////////////

//   Filename:  CrHidden.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.2  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.1  2002/05/14 17:07:10  richard
//   New GUI control CrHidden (HIDDENSTRING) is completely transparent and small, but
//   will store a text string, so that, for example you can pass data from one script
//   to another via a window which is open in between. (Use therefore mainly lies in
//   programming Non-Modal windows like "Guide" and "Add H".)
//

#ifndef     __CrHidden_H__
#define     __CrHidden_H__
#include    "crguielement.h"

class   CrHidden : public CrGUIElement
{
    public:
        // methods
        CrHidden( CrGUIElement * mParentPtr );
        ~CrHidden();
        CcParse ParseInput( deque<string> &  tokenList );
        void    SetGeometry( const CcRect * rect );
        void    SetText( const string &text );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void CrFocus();
        void GetValue( deque<string> &  tokenList);
};
#endif
