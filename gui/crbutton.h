////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.6  2001/09/07 14:35:19  ckp2
//   LENGTH='a string' option lets the button length be based on a string other
//   than the one actually displayed. Useful for making professional looking
//   buttons in a given row, e.g.
//
//   @ 1,1 BUTTON BOK '&OK' LENGTH='Cancel'
//   @ 1,3 BUTTON BXX '&Cancel'
//
//   makes both buttons equal width.
//
//   Revision 1.5  2001/03/08 15:30:50  richard
//   Now DISABLEIF and ENABLEIF flags allow buttons to appear in non-modal windows
//   without worry of interfering with scripts.
//

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
        void    GetValue(CcTokenList * tokenList);

        // attributes
        int bEnableFlags;
        int bDisableFlags;
    protected:
        bool m_AddedToDisableAbleButtonList;
        bool m_ButtonWasPressed;
};

#define kSDefault   "DEFAULT"
#define kSLength    "LENGTH"

enum
{
 kTDefault = 600,
 kTLength
};

#endif
