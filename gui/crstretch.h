////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.2  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.1  2001/02/26 12:07:06  richard
//   New stretch class. Probably the simplest class ever written, it has no functionality
//   except that it can be put in a grid of non-resizing items, and it will make that
//   row, column or both appear to be able to resize, thus spreading out fixed size items.
//

#ifndef     __CrStretch_H__
#define     __CrStretch_H__
#include    "crguielement.h"
class CxStretch;

class   CrStretch : public CrGUIElement
{
    public:
        // methods
        CrStretch( CrGUIElement * mParentPtr );
        ~CrStretch();
        CcParse ParseInput( deque<string> &  tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void CrFocus();
};
#endif
