////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxEditBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#ifndef     __CxEditBox_H__
#define     __CxEditBox_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef __POWERPC__
class LEditField;
#endif

#ifdef __MOTO__
#include    <LEditField.h>;
#endif

#ifdef __BOTHWX__
#include <wx/textctrl.h>
#define BASEEDITBOX wxTextCtrl
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEEDITBOX CEdit
#endif

class CrEditBox;
class CxGrid;
//End of user code.

#define CXE_TEXT_STRING 0
#define CXE_INT_NUMBER  1
#define CXE_REAL_NUMBER 2
#define CXE_READ_ONLY   3

class CxEditBox : public BASEEDITBOX
{
// The interface exposed to the CrClass:
    public:
        void ClearBox();
        void SetInputType( int type );
        void Disable(Boolean disable);
        void Focus();
        // methods
        static CxEditBox *  CreateCxEditBox( CrEditBox * container, CxGrid * guiParent );
            CxEditBox( CrEditBox * container);
            ~CxEditBox();
            void  AddText( CcString text );
            void  SetText( CcString text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int AddEditBox( void ) { mEditBoxCount++; return mEditBoxCount; };
        static void RemoveEditBox( void ) { mEditBoxCount--; };
        int GetText(char* theText, int maxlen = 256);
            CcString GetText();
        void    LimitChars(int nChars);
        void    SetVisibleChars( int count );
        void    IsInputPlace();
        void    UpdateFont();

// The private parts:
      public:
        static int mEditBoxCount;
        CrGUIElement *  ptr_to_crObject;
        int mCharsWidth;
        int m_Limit;

      private:
        int allowedInput;
        bool m_IsInput;

// The private machine specific parts:
            void EditChanged();


#ifdef __CR_WIN__
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
            afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
            void OnChar(wxKeyEvent & event);
            void OnKeyDown(wxKeyEvent & event);
            DECLARE_EVENT_TABLE()
#endif


};
#endif
