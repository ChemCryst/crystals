////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenuBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMenuBar.h
//   Authors:   Richard Cooper

#ifndef         __CrMenuBar_H__
#define         __CrMenuBar_H__
#include "crguielement.h"

#include <list>
using namespace std;

class CcMenuItem;

class   CrMenuBar : public CrGUIElement
{
    public:

           CrMenuBar( CrGUIElement * mParentPtr );
           ~CrMenuBar();
// methods

           int Condition(string conditions);
           void CrFocus();
           CcParse ParseInput( deque<string> & tokenList );
           void    SetText( const string &text );
           void    SetGeometry( const CcRect * rect );
           CcRect  GetGeometry();
           CcRect CalcLayout(bool recalculate=false);

// attributes
            int mMenuType;
            list<CcMenuItem*> mMenuList;

};

#endif
