////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CrButton_H__
#define     __CrButton_H__
#include    "crguielement.h"

class CcTokenList;

class   CrButton : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrButton( CrGUIElement * mParentPtr );
            ~CrButton();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    ButtonClicked();
        void    Enable(bool enabled);

        // attributes
        int bEnableFlags;
        int bDisableFlags;
    protected:
        bool m_AddedToDisableAbleButtonList;
};

#define kSDefault   "DEFAULT"

enum
{
 kTDefault = 600
};

#endif
