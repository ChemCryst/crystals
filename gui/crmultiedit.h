////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   6.3.1998 00:02 Uhr
//   Modified:  6.3.1998 00:02 Uhr

#ifndef		__CrMultiEdit_H__
#define		__CrMultiEdit_H__
#include	"crguielement.h"
#include	"cctokenlist.h"
#include	"ccrect.h"
class CxMultiEdit;

#define INPLAINTEXT 1
#define INLINKTEXT 2
#define INLINKCOMMAND 3

 class	CrMultiEdit : public CrGUIElement
{
	public:
		Boolean mNoEcho;
		void NoEcho(Boolean noEcho);
		void SetColour(int red, int green, int blue);
		void CrFocus();
		int GetIdealWidth();
		int GetIdealHeight();
		// methods
            CrMultiEdit( CrGUIElement * mParentPtr );
            ~CrMultiEdit();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetText ( CcString text );
		void 	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry ();
		void	CalcLayout();
		void    Changed();	
//		void    SetWidthScale(float w);
//		CcRect  GetOriginalGeometry();
            void SetOriginalSizes();
            void SetFontHeight(int height);

		// attributes
//		CcRect mOriginalGeometry;
};

#define kSTextColour		"TEXTCOLOUR"
#define kSTextBold		"TEXTBOLD"
#define kSTextItalic		"TEXTITALIC"
#define kSTextUnderline		"TEXTUNDERLINE"
#define kSTextFixedFont		"FIXEDFONT"
#define kSBackLine		"BACKLINE"
#define kSNoEcho		"NOECHO"
#define kSSpew			"SPEW"
#define kSEmpty                "EMPTY"

enum {
 kTTextColour = 1700,
 kTTextBold,	
 kTTextItalic,	
 kTTextUnderline,
 kTTextFixedFont,
 kTBackLine,	
 kTNoEcho,	
 kTSpew,
 kTEmpty
};




#endif
