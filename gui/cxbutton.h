////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.12  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.11  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.10  2003/02/20 14:08:04  rich
//   New option of making buttoms "SLIM" they fit into text more easily.
//
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

//#ifdef __POWERPC__
//class LStdButton;
//#endif

#ifdef __MOTO__
#include    <LStdControl.h>
#endif

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASEBUTTON CButton
#else
 #include <wx/button.h>
 #include <wx/event.h>
 #define BASEBUTTON wxButton
#endif


class CrButton;
class CxGrid;
//End of user code.

class CxButton : public BASEBUTTON
{
// The interface exposed to the CrClass
    public:
        void Disable(bool disabled);
        void CxSetState(bool highlight);
        void Focus();
        // methods
        static CxButton *   CreateCxButton( CrButton * container, CxGrid * guiParent );
        CxButton(CrButton* container);
        ~CxButton();
        void CxDestroyWindow();
        void    SetText( const string &text );
        void    SetLength( string ltext );
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
        void SetDef();

        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int mButtonCount;
        bool m_lengthStringUsed;
        string m_lengthString;
        bool m_Slim;
//      LDefaultOutline * mOutlineWidget;


// Private machine specific parts:
#ifdef CRY_USEMFC
        afx_msg void ButtonClicked();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#else
            void ButtonClicked(wxCommandEvent & e);
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
