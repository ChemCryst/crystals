////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CrIcon.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.4  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.3  2001/03/08 16:44:05  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef           __CrIcon_H__
#define           __CrIcon_H__
#include    "crguielement.h"
class CxIcon;

class CrIcon : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
                  CrIcon( CrGUIElement * mParentPtr );
                  ~CrIcon();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);

        // attributes

};

#define     kSIconInfo          "INFO"
#define     kSIconError         "ERROR"
#define     kSIconWarn          "WARN"
#define     kSIconQuery         "QUERY"

enum
{
 kTIconInfo = 1200,
 kTIconError,
 kTIconWarn,
 kTIconQuery
};

#endif
