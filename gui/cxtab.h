////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CxTab.h
//   Authors:   Richard Cooper
//   Created:   23.1.2001 23:30
//   $Log: not supported by cvs2svn $
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

#ifdef __CR_WIN__
#include    <afxwin.h>
#define BASETAB CTabCtrl
#endif

#ifdef __BOTHWX__
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

#ifdef __CR_WIN__
        afx_msg void OnSelChange ( NMHDR * pNotifyStruct, LRESULT* result );
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
        void OnSelChange ( wxNotebookEvent& tab );
        DECLARE_EVENT_TABLE()
#endif

};
#endif
