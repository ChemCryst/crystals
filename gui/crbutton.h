////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CrButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.8  2003/02/20 14:08:04  rich
//   New option of making buttoms "SLIM" they fit into text more easily.
//
//   Revision 1.7  2001/12/12 14:06:36  ckp2
//   RIC: Give buttons the "INFORM=NO" attribute and they'll not inform you that
//   they've been pressed. Instead you can query them using ^^?? BTNNAME STATE and
//   get "ON" if they've been pressed. Use SET INFORM=NO to reset the state if you
//   want to use them again. Can be used for an "ABORT" type of button which can be
//   checked again and again during long operations.
//
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


class   CrButton : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrButton( CrGUIElement * mParentPtr );
            ~CrButton();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    ButtonClicked();
        void    Enable(bool enabled);
        void    GetValue(deque<string> & tokenList);

        // attributes
        int bEnableFlags;
        int bDisableFlags;
    protected:
        bool m_AddedToDisableAbleButtonList;
        bool m_ButtonWasPressed;
};

#define kSDefault   "DEFAULT"
#define kSLength    "LENGTH"
#define kSSlim    "SLIM"

enum
{
 kTDefault = 600,
 kTLength,
 kTSlim
};

#endif
