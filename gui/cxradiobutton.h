////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxRadioButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.10  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.9  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.8  2001/06/17 14:32:57  richard
//   CxDestroyWindow function.
//
//   Revision 1.7  2001/03/08 15:55:41  richard
//   Disable function - called by Cr class to disable the radiobutton.
//

#ifndef     __CxRadioButton_H__
#define     __CxRadioButton_H__
#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASERADIOBUTTON CButton
#else
 #include <wx/radiobut.h>
 #define BASERADIOBUTTON wxRadioButton
#endif

class CrRadioButton;
class CxGrid;

class CxRadioButton : public BASERADIOBUTTON
{

// The interface exposed to the CrClass

    public:
        void Focus();
        // methods
        static CxRadioButton *  CreateCxRadioButton( CrRadioButton * container, CxGrid * guiParent );
            CxRadioButton( CrRadioButton * container);
            ~CxRadioButton();
//      void    ButtonChanged();
        void    SetText( const string & text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddRadioButton();
        static void RemoveRadioButton();
        void    BroadcastValueMessage();
        void    SetRadioState( bool inValue );
        bool GetRadioState();
        void Disable(bool disabled);
        void CxDestroyWindow();

// The private parts.
        CrGUIElement *  ptr_to_crObject;

    protected:
        static int  mRadioButtonCount;

// The private platform specific parts.

#ifdef CRY_USEMFC
      public:
        afx_msg void ButtonChanged();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

        DECLARE_MESSAGE_MAP()
#else
        void ButtonChanged(wxCommandEvent& e);
        void OnChar(wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif


};
#endif
