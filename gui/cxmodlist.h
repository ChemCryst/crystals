////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModList

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModList.h
//   Authors:   Richard Cooper

#ifndef     __CxModList_H__
#define     __CxModList_H__
#include    "crguielement.h"

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEMODLIST CListCtrl
#endif

#ifdef __BOTHWX__
#include <wx/event.h>
#include <wx/imaglist.h>
#include <wx/listctrl.h>
#define BASEMODLIST wxListCtrl
#endif

#include "ccstring.h"   // added by ClassView

class CrModList;
class CxGrid;

class CxModList : public BASEMODLIST
{
    public:
        int GetNumberSelected();
        void GetSelectedIndices( int * values );
        void InvertSelection();
        int m_ProgSelecting;
        CcString GetListItem(int item);
        void SelectPattern(CcString* strings, bool select);
        CcString GetCell(int row, int col);
        void SelectAll(bool select);
        void AddRow ( int id, CcString * rowOfStrings, bool sel, bool dis);
        void AddColumn( CcString colHeader);
        void Focus();
        static CxModList * CreateCxModList( CrModList * container, CxGrid * guiParent);
            CxModList( CrModList * container );
            ~CxModList();
        void    AddItem( char * text );
        void    SetVisibleLines( int lines );
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddModList( void ) { mModListCount++; return mModListCount; };
        static void RemoveModList( void ) { mModListCount--; };
        int GetValue();
        void Update(int newsize) ;

#ifdef __CR_WIN__
        void RepaintSelectedItems();

        afx_msg void OnKillFocus(CWnd* pNewWnd);
        afx_msg void OnSetFocus(CWnd* pOldWnd);
        afx_msg void OnPaint() ;
//      afx_msg void DoubleClicked();
//      afx_msg void Selected();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        virtual void DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct);
        afx_msg void OnHeaderClicked(NMHDR* pNMHDR, LRESULT* pResult);
        afx_msg void ItemChanged( NMHDR * pNMHDR, LRESULT* pResult );
        afx_msg void RightClick( NMHDR * pNMHDR, LRESULT* pResult );
//        afx_msg BOOL OnEraseBkgnd( CDC* pDC );
        afx_msg void OnMenuSelected (UINT nID);
        DECLARE_MESSAGE_MAP()

        CxGrid* m_listboxparent;
#endif
#ifdef __BOTHWX__
    void OnChar(wxKeyEvent & event );
    DECLARE_EVENT_TABLE()
#endif

        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int  mModListCount;
        int mItems;
        int mVisibleLines;

    private:
        void AddCols() ;
        int m_numcols;
        int  m_nHighlight;              // Indicate type of selection highlighting
        int * IDlist;
        int m_IDlist_size;
protected:
    int * m_colWidths;
#define COL_INT 1
#define COL_REAL 2
#define COL_TEXT 3
    int* m_colTypes;
    int WhichType(CcString text);


    int nSortedCol;
    bool bSortAscending;
    bool SortItems( int colType, int nCol, bool bAscending);

};
#endif
