////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxEditBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.12  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
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
//   Revision 1.8  2001/06/17 14:43:40  richard
//   CxDestroyWindow function.
//   Get font from winsizes file. (Can be set via "Appearence" menu.)
//
//   Revision 1.7  2001/03/08 15:51:31  richard
//   Limit number of characters if required.
//

#ifndef     __CxEditBox_H__
#define     __CxEditBox_H__
//Insert your own code here.
#include    "crguielement.h"
#include    "ciinputcontrol.h"

/*#ifdef __POWERPC__
class LEditField;
#endif*/

#ifdef __MOTO__
#include    <LEditField.h>;
#endif

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASEEDITBOX CEdit
#else
 #include <wx/textctrl.h>
 #define BASEEDITBOX wxTextCtrl
#endif


class CrEditBox;
class CxGrid;
//End of user code.

#define CXE_TEXT_STRING 0
#define CXE_INT_NUMBER  1
#define CXE_REAL_NUMBER 2
#define CXE_READ_ONLY   3

class CxEditBox : public BASEEDITBOX, public IInputControl
{
// The interface exposed to the CrClass:
    public:
        void ClearBox();
        void SetInputType( int type );
        void Disable(bool disable);
        void Focus();
        // methods
        static CxEditBox *  CreateCxEditBox( CrEditBox * container, CxGrid * guiParent );
            CxEditBox( CrEditBox * container);
            ~CxEditBox();
            void  AddText( const string & text );
            void  SetText( const string & text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        void CxDestroyWindow();
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int AddEditBox( void ) { mEditBoxCount++; return mEditBoxCount; };
        static void RemoveEditBox( void ) { mEditBoxCount--; };
        string GetText();
        void    LimitChars(string::size_type nChars);
        void    SetVisibleChars( int count );
        void    IsInputPlace();
        void    UpdateFont();

// The private parts:
      public:
        static int mEditBoxCount;
        CrGUIElement *  ptr_to_crObject;
        int mCharsWidth;
        string::size_type m_Limit;

      private:
        int allowedInput;
        bool m_IsInput;

// The private machine specific parts:
        void EditChanged();
		string mPreviousText;


#ifdef CRY_USEMFC
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#else
        void OnChar(wxKeyEvent & event);
        void OnKeyDown(wxKeyEvent & event);
		void OnKeyUp( wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif


// The IInputControl interface:

			void InsertText(const string text){ AddText(text); };



};
#endif
