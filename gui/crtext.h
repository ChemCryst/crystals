////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrText

////////////////////////////////////////////////////////////////////////

//   Filename:  CrText.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.4  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.3  2001/03/08 15:44:10  richard
//   Allow script to query (^^??) what the text is.
//

#ifndef     __CrText_H__
#define     __CrText_H__
#include    "crguielement.h"
class CxText;

class   CrText : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrText( CrGUIElement * mParentPtr );
            ~CrText();
        CcParse ParseInput( deque<string> &  tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue(deque<string> &  tokenList);

        // attributes
};
#endif
