////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CrProgress.h
//   Authors:   Richard Cooper
//   Created:   05.11.1998 14:26 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.5  2001/03/08 16:44:07  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CrProgress_H__
#define     __CrProgress_H__
#include    "crguielement.h"
#include    <string>
using namespace std;
class CxProgress;

class   CrProgress : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrProgress( CrGUIElement * mParentPtr );
            ~CrProgress();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void  SwitchText ( const string & text );

        // attributes

};

#define kSComplete  "COMPLETE"

enum
{
 kTComplete = 1500
};


#endif
