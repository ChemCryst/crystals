////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CxListCtrl.h
//   Authors:   Richard Cooper

#ifndef		__CxListCtrl_H__
#define		__CxListCtrl_H__
#include	"crguielement.h"


#include <afxwin.h>
#include "ccstring.h"	// added by ClassView

class CrListCtrl;
class CxGrid;
 
class	CxListCtrl : public CListCtrl
{
	public:
		Boolean m_SendIndex;
		void InvertSelection();
		int m_ProgSelecting;
		CcString GetListItem(int item);
		void SelectPattern(CcString* strings, Boolean select);
		CcString GetCell(int row, int col);
		void SelectAll(Boolean select);
		void AddRow ( CcString * rowOfStrings );
		void AddColumn( CcString colHeader);
		void Focus();
		static CxListCtrl *	CreateCxListCtrl( CrListCtrl * container, CxGrid * guiParent);
			CxListCtrl( CrListCtrl * container );
			~CxListCtrl();
		void	AddItem( char * text );
		void	SetVisibleLines( int lines );
		void	SetGeometry( int top, int left, int bottom, int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int	AddListCtrl( void ) { mListCtrlCount++; return mListCtrlCount; };
		static void	RemoveListCtrl( void ) { mListCtrlCount--; };
		int	GetValue();

        enum EHighlight {HIGHLIGHT_NORMAL, HIGHLIGHT_ALLCOLUMNS, HIGHLIGHT_ROW};


		void RepaintSelectedItems();
		int SetHighlightType(EHighlight hilite);


		afx_msg void OnKillFocus(CWnd* pNewWnd); 
		afx_msg void OnSetFocus(CWnd* pOldWnd);
		afx_msg void OnPaint() ;
//		afx_msg void DoubleClicked();
//		afx_msg void Selected();
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		virtual void DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct); 
		afx_msg void OnHeaderClicked(NMHDR* pNMHDR, LRESULT* pResult); 
		afx_msg void ItemChanged( NMHDR * pNMHDR, LRESULT* pResult );

		DECLARE_MESSAGE_MAP()


		
		// attributes
		CrGUIElement *	mWidget;
		static int	mListCtrlCount;
		int mItems;
		int mVisibleLines;
    
	private:
		int m_numcols;
	    int  m_nHighlight;              // Indicate type of selection highlighting

protected:
	int * m_colWidths;
#define COL_INT 1
#define COL_REAL 2
#define COL_TEXT 3
	int* m_colTypes;
	int WhichType(CcString text);


    int nSortedCol; 
    Boolean bSortAscending; 
	BOOL SortTextItems( int colType, int nCol, BOOL bAscending);

};
#endif



