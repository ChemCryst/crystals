////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.9  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.8  2001/09/07 14:35:19  ckp2
//   LENGTH='a string' option lets the button length be based on a string other
//   than the one actually displayed. Useful for making professional looking
//   buttons in a given row, e.g.
//
//   @ 1,1 BUTTON BOK '&OK' LENGTH='Cancel'
//   @ 1,3 BUTTON BXX '&Cancel'
//
//   makes both buttons equal width.
//
//   Revision 1.7  2001/06/17 14:46:47  richard
//   CxDestroyWindow function.
//   Size wx buttons so the match MFC buttons.
//
//   Revision 1.6  2001/03/08 16:44:07  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxButton_H__
#define     __CxButton_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef __POWERPC__
class LStdButton;
#endif

#ifdef __MOTO__
#include    <LStdControl.h>
#endif

#ifdef __BOTHWX__
#include <wx/button.h>
#include <wx/event.h>
#define BASEBUTTON wxButton
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEBUTTON CButton
#endif

class CrButton;
class CxGrid;
//End of user code.

class CxButton : public BASEBUTTON
{
// The interface exposed to the CrClass
    public:
        void Disable(Boolean disabled);
        void CxSetState(Boolean highlight);
        void Focus();
        // methods
        static CxButton *   CreateCxButton( CrButton * container, CxGrid * guiParent );
        CxButton(CrButton* container);
        ~CxButton();
        void CxDestroyWindow();
        void    SetText( char * text );
        void    SetLength( CcString ltext );
        void    SetSlim();
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int AddButton( void ) { mButtonCount++; return mButtonCount; };
        static void RemoveButton( void ) { mButtonCount--; };
        void    BroadcastValueMessage( void );
        void SetDef();

        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int mButtonCount;
        bool m_lengthStringUsed;
        CcString m_lengthString;
        Boolean m_Slim;
//      LDefaultOutline * mOutlineWidget;


// Private machine specific parts:
#ifdef __CR_WIN__
        afx_msg void ButtonClicked();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
            void ButtonClicked();
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
