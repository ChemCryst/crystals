////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $

#ifndef     __CrStretch_H__
#define     __CrStretch_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
class CxStretch;

class   CrStretch : public CrGUIElement
{
    public:
        // methods
        CrStretch( CrGUIElement * mParentPtr );
        ~CrStretch();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void CrFocus();
};
#endif
