////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   6.3.1998 00:02 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.13  2004/09/17 14:03:54  rich
//   Better support for accessing text in Multiline edit control from scripts.
//
//   Revision 1.12  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.11  2004/05/13 09:14:49  rich
//   Re-invigorate the MULTIEDIT control. Currently not used, but I have
//   something in mind for it.
//
//   Revision 1.10  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.9  2001/03/08 16:44:06  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CrMultiEdit_H__
#define     __CrMultiEdit_H__
#include    "crguielement.h"
#include    "ccrect.h"
#include <string>
class CxMultiEdit;

#define INPLAINTEXT 1
#define INLINKTEXT 2
#define INLINKCOMMAND 3

 class  CrMultiEdit : public CrGUIElement
{
    public:
        bool mNoEcho;
        void NoEcho(bool noEcho);
        void CrFocus();
        int GetIdealWidth();
        int GetIdealHeight();
        // methods
            CrMultiEdit( CrGUIElement * mParentPtr );
            ~CrMultiEdit();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText ( const string &text );
        void  GetValue(deque<string> & tokenList);
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry ();
        CcRect CalcLayout(bool recalculate=false);
        void    Changed();
		void    InsertAtom(string s);
//      void    SetWidthScale(float w);
//      CcRect  GetOriginalGeometry();
            void SetFontHeight(int height);

        // attributes
//      CcRect mOriginalGeometry;
};

#define kSNoEcho        "NOECHO"
#define kSSpew          "SPEW"
#define kSLoad          "LOAD"

enum {
 kTNoEcho     = 1900,
 kTSpew,
 kTLoad
};




#endif
