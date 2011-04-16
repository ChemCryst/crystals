////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrWeb

////////////////////////////////////////////////////////////////////////

//   Filename:  CrWeb.h
//   Authors:   Richard Cooper
//   Created:   04.3.2011 14:41 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrWeb_H__
#define     __CrWeb_H__
#include    "crguielement.h"


class   CrWeb : public CrGUIElement
{
    public:
        // methods
        CrWeb( CrGUIElement * mParentPtr );
        ~CrWeb();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
		void    CrFocus();
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    Enable(bool enabled);
        void    GetValue(deque<string> & tokenList);

        // attributes
    protected:
};

//#define kSDefault   "DEFAULT"
//#define kSLength    "LENGTH"
//#define kSSlim    "SLIM"

enum
{
 //kTDefault = 600,
 //kTLength,
 //kTSlim
};

#endif
