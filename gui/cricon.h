////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CrIcon.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef           __CrIcon_H__
#define           __CrIcon_H__
#include    "crguielement.h"
#include    "cctokenlist.h"
class CxIcon;

class CrIcon : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
                  CrIcon( CrGUIElement * mParentPtr );
                  ~CrIcon();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
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
