////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.h
//   Authors:   Richard Cooper
//   Created:   05.11.1998 14:26 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrProgress_H__
#define     __CrProgress_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
#include    "ccstring.h"
class CxProgress;

class   CrProgress : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrProgress( CrGUIElement * mParentPtr );
            ~CrProgress();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
            void  SwitchText ( CcString * text );

        // attributes

};

#define kSComplete  "COMPLETE"

enum
{
 kTComplete = 1500
};


#endif
