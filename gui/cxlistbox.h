////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxListBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  6.3.1998 10:10 Uhr

#ifndef     __CxListBox_H__
#define     __CxListBox_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef __POWERPC__
class LListBox;

#include    <LTabGroup.h>
#endif

#ifdef __MOTO__
#include    <LListBox.h>
#include    <LTabGroup.h>
#endif

#ifdef __BOTHWX__
#include <wx/listbox.h>
#define BASELISTBOX wxListBox
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASELISTBOX CListBox
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
                void  CxSetSelection ( int select );
//      void    DoubleClicked( int itemIndex );
//      void    Selected( int itemIndex );
        void    AddItem( char * text );
        void    SetVisibleLines( int lines );
        void    SetGeometry( int top, int left, int bottom, int right );
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
            CcString GetListBoxText(int index);
        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int  mListBoxCount;
        int mItems;
        int mVisibleLines;

#ifdef __CR_WIN__
        afx_msg void DoubleClicked();
        afx_msg void Selected();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
            void DoubleClicked();
            void Selected();
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
