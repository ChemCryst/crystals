////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   6.3.1998 00:02 Uhr
//   $Log: not supported by cvs2svn $
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
#include    "cctokenlist.h"
#include    "ccrect.h"
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
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText ( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry ();
        CcRect CalcLayout(bool recalculate=false);
        void    Changed();
//      void    SetWidthScale(float w);
//      CcRect  GetOriginalGeometry();
            void SetFontHeight(int height);

        // attributes
//      CcRect mOriginalGeometry;
};

#define kSNoEcho        "NOECHO"
#define kSSpew          "SPEW"

enum {
 kTNoEcho     = 1900,
 kTSpew,
};




#endif
