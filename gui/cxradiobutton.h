////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxRadioButton.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 10:38 Uhr

#ifndef     __CxRadioButton_H__
#define     __CxRadioButton_H__
#include    "crguielement.h"

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASERADIOBUTTON CButton
#endif

#ifdef __BOTHWX__
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
        void    SetText( char * text );
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
        void    SetRadioState( Boolean inValue );
        Boolean GetRadioState();

// The private parts.
        CrGUIElement *  ptr_to_crObject;

    protected:
        static int  mRadioButtonCount;

// The private platform specific parts.

#ifdef __CR_WIN__
      public:
        afx_msg void ButtonChanged();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
            void ButtonChanged();
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif


};
#endif
