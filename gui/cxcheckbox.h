////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxCheckBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CxCheckBox_H__
#define     __CxCheckBox_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef __POWERPC__
class LStdCheckBox;
#endif

#ifdef __MOTO__
#include    <LStdControl.h>;
#endif

#ifdef __BOTHWX__
#include <wx/checkbox.h>
#define BASECHECKBOX wxCheckBox
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASECHECKBOX CButton
#endif

class CrCheckBox;
class CxGrid;
//End of user code.

class CxCheckBox : public BASECHECKBOX
{
    public:
        void Focus();
        // methods
        static CxCheckBox * CreateCxCheckBox( CrCheckBox * container, CxGrid * guiParent );
            CxCheckBox( CrCheckBox * container);
            ~CxCheckBox();
//      void    BoxClicked();
        void    SetText( char * text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        void    SetBoxState( Boolean inValue );
        void    Disable(Boolean disabled);
        Boolean GetBoxState();

        // attributes
        CrGUIElement *  ptr_to_crObject;
    protected:
        static int  mCheckBoxCount;


#ifdef __CR_WIN__
        afx_msg void BoxClicked();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
            void BoxClicked();
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif


};
#endif
