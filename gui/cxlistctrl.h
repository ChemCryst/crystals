////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CxListCtrl.h
//   Authors:   Richard Cooper

#ifndef     __CxListCtrl_H__
#define     __CxListCtrl_H__
#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASELISTCTRL CListCtrl
#else
 #include <wx/listctrl.h>
 #include <wx/event.h>
 #define BASELISTCTRL wxListCtrl
#endif

#include <string>
#include <vector>
using namespace std;
   // added by ClassView

class CrListCtrl;
class CxGrid;

class CxListCtrl : public BASELISTCTRL
{
    public:
        int GetNumberSelected();
        void GetSelectedIndices( int * values );
        int m_ProgSelecting;
        string GetListItem(int item);
        string GetCell(int row, int col);
        void InvertSelection();
        void SelectAll(bool select);
        void SelectPattern(string* strings, bool select);
        void SortCol(int col, bool sort);
        void AddRow ( string * rowOfStrings );
        void AddColumn( string colHeader);
        void Focus();
        static CxListCtrl * CreateCxListCtrl( CrListCtrl * container, CxGrid * guiParent);
            CxListCtrl( CrListCtrl * container );
            ~CxListCtrl();
        void    AddItem( const string & text );
        void    SetVisibleLines( int lines );
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddListCtrl( void ) { mListCtrlCount++; return mListCtrlCount; };
        static void RemoveListCtrl( void ) { mListCtrlCount--; };
        int GetValue();

        enum EHighlight {HIGHLIGHT_NORMAL, HIGHLIGHT_ALLCOLUMNS, HIGHLIGHT_ROW};

        void CxSetSelection( int select );
        void CxClear();
        void RepaintSelectedItems();
        int SetHighlightType(EHighlight hilite);

#ifdef CRY_USEMFC

        afx_msg void OnKillFocus(CWnd* pNewWnd);
        afx_msg void OnSetFocus(CWnd* pOldWnd);
        afx_msg void OnPaint() ;
//      afx_msg void DoubleClicked();
//      afx_msg void Selected();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        virtual void DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct);
        afx_msg void OnHeaderClicked(NMHDR* pNMHDR, LRESULT* pResult);
        afx_msg void ItemChanged( NMHDR * pNMHDR, LRESULT* pResult );

        DECLARE_MESSAGE_MAP()

#else
    void OnChar(wxKeyEvent & event );
    DECLARE_EVENT_TABLE()
#endif


        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int  mListCtrlCount;
        int mItems;
        int mVisibleLines;

    private:
        int m_numcols;
        int  m_nHighlight;              // Indicate type of selection highlighting

protected:
#define COL_INT 1
#define COL_REAL 2
#define COL_TEXT 3
//    int* m_colTypes;
//    int * m_colWidths;
    vector<int> m_colTypes;
    vector<int> m_colWidths;

    int WhichType(string text);

//    int * m_originalIndex;
    vector<int> m_originalIndex;


    int nSortedCol;
    bool bSortAscending;
    bool SortTextItems( int colType, int nCol, bool bAscending);

};
#endif
