////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   6.3.1998 00:02 Uhr
//   $Log: not supported by cvs2svn $
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
        void SetColour(int red, int green, int blue);
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

#define kSTextColour        "TEXTCOLOUR"
#define kSTextBold      "TEXTBOLD"
#define kSTextItalic        "TEXTITALIC"
#define kSTextUnderline     "TEXTUNDERLINE"
#define kSTextFixedFont     "FIXEDFONT"
#define kSBackLine      "BACKLINE"
#define kSNoEcho        "NOECHO"
#define kSSpew          "SPEW"

enum {
 kTTextColour = 1900,
 kTTextBold,
 kTTextItalic,
 kTTextUnderline,
 kTTextFixedFont,
 kTBackLine,
 kTNoEcho,
 kTSpew,
};




#endif
