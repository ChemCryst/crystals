////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CxTab.h
//   Authors:   Richard Cooper
//   Created:   23.1.2001 23:30
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.5  2004/10/08 10:03:24  rich
//   Tab change notification not required under wxWin. Fix tab sizing by including
//   some space at the bottom.
//
//   Revision 1.4  2001/07/16 07:25:31  ckp2
//   Make sure (in the wx version) that all the grids in the tab control are removed
//   from the tab control before it is destroyed.
//
//   Revision 1.3  2001/06/18 12:41:14  richard
//   AddTab is now passed a CcTabData rather than just a text string. The wx base
//   class (wxNoteBook) manages the child window for itself, (unlike windows where
//   we just change the child window when the tabs are clicked), so CcTabData
//   contains a pointer to the child.
//
//   Revision 1.2  2001/06/17 14:30:29  richard
//
//   wx support. CxDestroyWindow function.
//
//   Revision 1.1  2001/01/25 17:17:05  richard
//   A new control for tabbed property sheets.
//

#ifndef     __CxTab_H__
#define     __CxTab_H__

#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include    <afxwin.h>
 #define BASETAB CTabCtrl
#else
 #include <wx/control.h>
 #include <wx/notebook.h>
 #define BASETAB wxNotebook
#endif

class CrTab;
class CxGrid;
class CcTabData;

class CxTab : public BASETAB
{

      public:
        static CxTab * CreateCxTab( CrTab * container, CxGrid * guiParent );
        CxTab( CrTab * container );
        ~CxTab();
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        int GetTabsHeight();
        int GetTabsExtraVSpace();
        void AddTab(CcTabData * tab);
        void RedrawTabs();
        void CxDestroyWindow();
        CrGUIElement *  ptr_to_crObject;
        int m_tab;
        static int mTabCount;

#ifdef CRY_USEMFC
        afx_msg void OnSelChange ( NMHDR * pNotifyStruct, LRESULT* result );
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#else
        void LetGoOfTabs();
        void OnChar(wxKeyEvent & event);
		void OnIdle(wxIdleEvent & event);
//        DECLARE_EVENT_TABLE()
#endif

};
#endif
