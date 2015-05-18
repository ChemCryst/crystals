////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxListBox.h
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
//   Revision 1.11  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.10  2002/03/05 12:12:59  ckp2
//   Enhancements to listbox for my List 28 project.
//
//   Revision 1.9  2001/06/17 14:39:59  richard
//   CxDestroyWindow function.
//
//   Revision 1.8  2001/03/28 09:17:07  richard
//   Code to allow you to disable the listbox.
//
//   Revision 1.7  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxListBox_H__
#define     __CxListBox_H__
//Insert your own code here.
#include    "crguielement.h"

/*#ifdef __POWERPC__
class LListBox;

#include    <LTabGroup.h>
#endif*/

#ifdef __MOTO__
#include    <LListBox.h>
#include    <LTabGroup.h>
#endif

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASELISTBOX CListBox
#else
 #include <wx/listbox.h>
 #define BASELISTBOX wxListBox
#endif


class CrListBox;
class CxGrid;
//End of user code.

class CxListBox : public BASELISTBOX
{
    public:
        void Focus();
        // methods
        static CxListBox *  CreateCxListBox( CrListBox * container, CxGrid * guiParent);
            CxListBox( CrListBox * container );
            ~CxListBox();
        void CxSetSelection ( int select );
        void CxRemoveItem ( int select );
//      void    DoubleClicked( int itemIndex );
//      void    Selected( int itemIndex );
        void    AddItem( const string &  text );
        void    SetVisibleLines( int lines );
        void    SetGeometry( int top, int left, int bottom, int right );
        void    Disable (bool disable);
        void CxDestroyWindow();
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddListBox( void ) { mListBoxCount++; return mListBoxCount; };
        static void RemoveListBox( void ) { mListBoxCount--; };
//      void    ClickSelf( const SMouseDownEvent &inMouseDown);
        int GetBoxValue();
            string GetListBoxText(int index);
        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int  mListBoxCount;
        int mItems;
        int mVisibleLines;

#ifdef CRY_USEMFC
        afx_msg void DoubleClicked();
        afx_msg void Selected();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#else
        void DoubleClicked(wxCommandEvent & e);
        void Selected(wxCommandEvent & e);
        void OnChar(wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif

};
#endif
