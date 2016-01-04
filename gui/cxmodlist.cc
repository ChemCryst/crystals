////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModList

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModList.cpp
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include    "cxmodlist.h"

#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "crmodlist.h"
#include    "ccmodelatom.h"
#include    "cccontroller.h"
#include    <math.h>
#include    <string>
#include    <sstream>

#ifdef CRY_USEWX
#include <wx/defs.h>
#endif

int CxModList::mModListCount = kModListBase;


#ifdef CRY_USEWX
int wxCALLBACK MySorter(wxIntPtr item1, wxIntPtr item2, wxIntPtr sortData)
{
    // inverse the order
    if (item1 < item2)
        return -1 * sortData;
    if (item1 > item2)
        return 1 * sortData;
    return 0;
}
#endif


CxModList *    CxModList::CreateCxModList( CrModList * container, CxGrid * guiParent )
{
    CxModList  *theModList = new CxModList( container );
#ifdef CRY_USEMFC
    theModList->Create(WS_CHILD|WS_VISIBLE|LVS_REPORT|LVS_OWNERDRAWFIXED|LVS_SHOWSELALWAYS|WS_VSCROLL, CRect(0,0,5,5), guiParent, mModListCount++);
    theModList->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
    theModList->SetFont(CcController::mp_font);
    theModList->m_listboxparent = guiParent;
#else
      theModList->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10),
                          wxLC_REPORT);
#endif
    theModList->AddCols();
    return theModList;
}



CxModList::CxModList( CrModList * container )
      : BASEMODLIST()
{
    ptr_to_crObject = container;

    mVisibleLines = 0;
    m_numcols = 0;
    nSortedCol = -1;
    bSortAscending = true;
    m_ProgSelecting = 0;
}



void CxModList::AddCols()
{
    m_numcols=13;
    string colHeader[13];
    colHeader[0]  = "Id";
    colHeader[1]  = "Type";
    colHeader[2]  = "Serial";
    colHeader[3]  = "x";
    colHeader[4]  = "y";
    colHeader[5]  = "z";
    colHeader[6]  = "occ";
    colHeader[7]  = "Type";
    colHeader[8]  = "Ueq";
    colHeader[9]  = "Spare";
    colHeader[10] = "Residue";
    colHeader[11] = "Assembly";
    colHeader[12] = "Group";

    for ( int i = 0; i < m_numcols ; i++ )
    {
      m_colTypes.push_back(COL_INT); //Always start with INT. This will fail to REAL, and then to TEXT.
#ifdef CRY_USEMFC
      m_colWidths.push_back(CRMAX(10,GetStringWidth(colHeader[i].c_str())+5));
      InsertColumn( i, colHeader[i].c_str(), LVCFMT_LEFT, 10, i );
#else
      int w,h;
      GetTextExtent(colHeader[i].c_str(),&w,&h);
      m_colWidths.push_back(CRMAX(10,w));
      InsertColumn( i, colHeader[i].c_str(), wxLIST_FORMAT_LEFT, 10 );
#endif
      SetColumnWidth( i, m_colWidths[i]);
    }
}




CxModList::~CxModList()
{
    RemoveModList();
}




void    CxModList::SetVisibleLines( int lines )
{
    mVisibleLines = lines;
}

CXSETGEOMETRY(CxModList)

CXGETGEOMETRIES(CxModList)


int CxModList::GetIdealWidth()
{
    int totWidth = 15; // 5 pixels extra.
    for (int i = 0; i<m_numcols; i++)
    {
        totWidth += m_colWidths[i];
    }
    return ( totWidth );
}

int CxModList::GetIdealHeight()
{
#ifdef CRY_USEMFC
    int lines = mVisibleLines;
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    return lines * ( textMetric.tmHeight + 2 );
#else
      return mVisibleLines * ( GetCharHeight() + 2 );
#endif
}

int CxModList::GetValue()
{
    return 0;
}



#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxModList, CListCtrl)
    ON_WM_CHAR()
    ON_WM_DRAWITEM()
    ON_WM_PAINT()
    ON_WM_KILLFOCUS()
    ON_WM_SETFOCUS()
//    ON_WM_ERASEBKGND()
    ON_COMMAND_RANGE(kMenuBase, kMenuBase+1000, OnMenuSelected)
    ON_NOTIFY(HDN_ITEMCLICKA, 0, OnHeaderClicked)
    ON_NOTIFY(HDN_ITEMCLICKW, 0, OnHeaderClicked)
    ON_NOTIFY_REFLECT( LVN_ITEMCHANGED, ItemChanged )
    ON_NOTIFY_REFLECT( NM_RCLICK,  RightClick )
END_MESSAGE_MAP()
#else
BEGIN_EVENT_TABLE(CxModList, wxListCtrl)
     EVT_CHAR( CxModList::OnChar )
     EVT_LIST_ITEM_SELECTED(-1, CxModList::ItemSelected )
     EVT_LIST_ITEM_DESELECTED(-1, CxModList::ItemDeselected )
     EVT_LIST_ITEM_RIGHT_CLICK(-1, CxModList::RightClick )
     EVT_LIST_COL_CLICK(-1, CxModList::HeaderClicked )
END_EVENT_TABLE()
#endif


void CxModList::Focus()
{
    SetFocus();
}

CXONCHAR(CxModList)



void CxModList::StartUpdate() {
#ifdef CRY_USEMFC
      SetRedraw(FALSE);
#endif
}

void CxModList::EndUpdate() {
#ifdef CRY_USEMFC
      SetRedraw(TRUE);
      Invalidate();
      UpdateWindow();
#endif
}


void CxModList::AddRow(int id, vector<string> & rowOfStrings, bool selected,
                               bool disabled)
{
    if ( id <= (int)IDlist.size() )
    {
//Find ID in existing list.
      for ( int i=0; i<(int)IDlist.size(); i++ )
      {
        if ( IDlist[i] == id )
        {

//			ostringstream oo;
//			oo << "Adding row id " << id << " " << rowOfStrings[0] << " " <<  rowOfStrings[1] << " " << rowOfStrings[2];
//			LOGERR(oo.str());

#ifdef CRY_USEMFC
            m_ProgSelecting=m_numcols+1;

            for( int j=0; j<m_numcols; j++) {
                SetItemText( i, j, rowOfStrings[j].c_str());
            }

            if ( selected )
               SetItemState(i, LVIS_SELECTED, LVIS_SELECTED);
            else
               SetItemState(i, 0, LVIS_SELECTED);
            m_ProgSelecting=0;

#else

            wxListItem info;
	        info.SetMask(wxLIST_MASK_TEXT | wxLIST_MASK_STATE);
			info.SetId( i );

            info.SetStateMask(wxLIST_STATE_SELECTED);
            info.m_itemId = i;
			if ( selected ) {
               info.SetState( wxLIST_STATE_SELECTED);
			}
			else {
               info.SetState(0);
			}
            for( int j=0; j<m_numcols; j++) {
			  info.SetColumn ( j );
              info.SetText(rowOfStrings[j].c_str());
              m_ProgSelecting = 2;
              SetItem( info );
              m_ProgSelecting = 0;
            }
#endif

            return;
        }
      }
    }


// A new item. Extend id list.

    IDlist.push_back(IDlist.size()+1);

#ifdef CRY_USEMFC
    int nItem = InsertItem(IDlist.size(), _T(""));
    for (int j = 0; j < m_numcols; j++)
    {
        SetItemText(nItem, j, rowOfStrings[j].c_str());
        int width = GetStringWidth(rowOfStrings[j].c_str());
#else
    int nItem = InsertItem(IDlist.size()-1, _T(""));
    for (int j = 0; j < m_numcols; j++)
    {
        SetItem( nItem, j, rowOfStrings[j].c_str());
        int width,h;
        GetTextExtent(rowOfStrings[j].c_str(),&width,&h);
#endif
        if ( width + 15 > m_colWidths[j] ) // if no change, don't set width.
        {
           m_colWidths[j] = width + 15;
           SetColumnWidth(j,m_colWidths[j]);
        }
        if ( m_colTypes[j] != COL_TEXT )   // if already text, don't bother testing.
        {
          int type = WhichType(rowOfStrings[j]);
          m_colTypes[j] = CRMAX(m_colTypes[j], type);
        }
    }
    if ( selected ) {
#ifdef CRY_USEMFC
       SetItemState(nItem, LVIS_SELECTED, LVIS_SELECTED);
#else
       m_ProgSelecting = 2;

	   SetItemState(nItem, wxLIST_STATE_SELECTED, wxLIST_STATE_SELECTED);
       m_ProgSelecting = 0;
#endif
    } else {
#ifdef CRY_USEMFC
       SetItemState(nItem, 0, LVIS_SELECTED);
#else
       m_ProgSelecting = 2;
       SetItemState(nItem, 0, wxLIST_STATE_SELECTED);
       m_ProgSelecting = 0;
#endif
    }

    return;
}





#ifdef CRY_USEMFC
void CxModList::DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct)
{
        CDC* pDC = CDC::FromHandle(lpDrawItemStruct->hDC);
        CRect rcItem(lpDrawItemStruct->rcItem);
        int nItem = lpDrawItemStruct->itemID;

        // Save dc state
        int nSavedDC = pDC->SaveDC();

        // Get item image and state info
        LV_ITEM lvi;
        lvi.mask = LVIF_IMAGE | LVIF_STATE;
        lvi.iItem = nItem;
        lvi.iSubItem = 0;
        lvi.stateMask = 0xFFFF;         // get all state flags
        GetItem(&lvi);

        // Should the item be highlighted?
        bool bHighlight =((lvi.state & LVIS_DROPHILITED)
                                || ( (lvi.state & LVIS_SELECTED)
                                        && ((GetFocus() == this)
                                                || (GetStyle() & LVS_SHOWSELALWAYS)
                                                )
                                        )
                                );


        // Get rectangles for drawing
        CRect rcBounds, rcLabel;
        GetItemRect(nItem, rcBounds, LVIR_BOUNDS);
        GetItemRect(nItem, rcLabel, LVIR_LABEL);
        CRect rcCol( rcBounds );


        CString sLabel = GetItemText( nItem, 0 );

        // Labels are offset by a certain amount
        // This offset is related to the width of a space character
        int offset = pDC->GetTextExtent(_T(" "), 1 ).cx*2;

        CRect rcHighlight;
        CRect rcWnd;
        GetClientRect(&rcWnd);
        rcHighlight = rcBounds;
        rcHighlight.left = rcLabel.left;
        rcHighlight.right = rcWnd.right+1;   // Add 1 to prevent trails

        // Draw the background color
        if( bHighlight )
        {
                pDC->SetTextColor(::GetSysColor(COLOR_HIGHLIGHTTEXT));
                pDC->SetBkColor(::GetSysColor(COLOR_HIGHLIGHT));
                pDC->FillRect(rcHighlight, &CBrush(::GetSysColor(COLOR_HIGHLIGHT)));
        }
        else
                pDC->FillRect(rcHighlight, &CBrush(::GetSysColor(COLOR_WINDOW)));



        // Set clip region
        rcCol.right = rcCol.left + GetColumnWidth(0);
        CRgn rgn;
        rgn.CreateRectRgnIndirect(&rcCol);
        pDC->SelectClipRgn(&rgn);
        rgn.DeleteObject();


        // Draw item label - Column 0
        rcLabel.left += offset/2;
        rcLabel.right -= offset;

        pDC->DrawText(sLabel,-1,rcLabel,DT_LEFT | DT_SINGLELINE | DT_NOPREFIX | DT_NOCLIP
                                | DT_VCENTER | DT_END_ELLIPSIS);


        // Draw labels for remaining columns
        LV_COLUMN lvc;
        lvc.mask = LVCF_FMT | LVCF_WIDTH;

        rcBounds.right = rcHighlight.right > rcBounds.right ? rcHighlight.right :
                                                        rcBounds.right;
        rgn.CreateRectRgnIndirect(&rcBounds);
        pDC->SelectClipRgn(&rgn);

        for(int nColumn = 1; GetColumn(nColumn, &lvc); nColumn++)
        {
                rcCol.left = rcCol.right;
                rcCol.right += lvc.cx;

                sLabel = GetItemText(nItem, nColumn);
                if (sLabel.GetLength() == 0)
                        continue;

                // Get the text justification
                UINT nJustify = DT_LEFT;
                switch(lvc.fmt & LVCFMT_JUSTIFYMASK)
                {
                case LVCFMT_RIGHT:
                        nJustify = DT_RIGHT;
                        break;
                case LVCFMT_CENTER:
                        nJustify = DT_CENTER;
                        break;
                default:
                        break;
                }

                rcLabel = rcCol;
                rcLabel.left += offset;
                rcLabel.right -= offset;

                pDC->DrawText(sLabel, -1, rcLabel, nJustify | DT_SINGLELINE |
                                        DT_NOPREFIX | DT_VCENTER | DT_END_ELLIPSIS);
        }

        // Draw focus rectangle if item has focus
        if (lvi.state & LVIS_FOCUSED && (GetFocus() == this))
                pDC->DrawFocusRect(rcHighlight);


        // Restore dc
        pDC->RestoreDC( nSavedDC );
}

void CxModList::RepaintSelectedItems()
{
        CRect rcBounds, rcLabel;

        // Invalidate focused item so it can repaint
        int nItem = GetNextItem(-1, LVNI_FOCUSED);

        if(nItem != -1)
        {
                GetItemRect(nItem, rcBounds, LVIR_BOUNDS);
                GetItemRect(nItem, rcLabel, LVIR_LABEL);
                rcBounds.left = rcLabel.left;

                InvalidateRect(rcBounds, false);
        }

        // Invalidate selected items depending on LVS_SHOWSELALWAYS
        if(!(GetStyle() & LVS_SHOWSELALWAYS))
        {
                for(nItem = GetNextItem(-1, LVNI_SELECTED);
                        nItem != -1; nItem = GetNextItem(nItem, LVNI_SELECTED))
                {
                        GetItemRect(nItem, rcBounds, LVIR_BOUNDS);
                        GetItemRect(nItem, rcLabel, LVIR_LABEL);
                        rcBounds.left = rcLabel.left;

                        InvalidateRect(rcBounds, false);
                }
        }

        UpdateWindow();
}
#endif

//BOOL CxModList::OnEraseBkgnd( CDC* pDC )
//{
//    return ( TRUE ) ; //prevent flicker
//}

#ifdef CRY_USEMFC
void CxModList::OnPaint()
{

        // in full row select mode, we need to extend the clipping region
        // so we can paint a selection all the way to the right
        if ( (GetStyle() & LVS_TYPEMASK) == LVS_REPORT )
        {
                CRect rcBounds;
                GetItemRect(0, rcBounds, LVIR_BOUNDS);


                CRect rcClient;
                GetClientRect(&rcClient);
                if(rcBounds.right < rcClient.right)
                {
                        CPaintDC dc(this);

                        CRect rcClip;
                        dc.GetClipBox(rcClip);

                        rcClip.left = CRMIN(rcBounds.right-1, rcClip.left);
                        rcClip.right = rcClient.right;

                        InvalidateRect(rcClip, false);
                }
        }

        CListCtrl::OnPaint();
}
#endif

#ifdef CRY_USEMFC
void CxModList::OnKillFocus(CWnd* pNewWnd)
{
        CListCtrl::OnKillFocus(pNewWnd);

        // check if we are losing focus to label edit box
        if(pNewWnd != NULL && pNewWnd->GetParent() == this)
                return;

        // repaint items that should change appearance
        if((GetStyle() & LVS_TYPEMASK) == LVS_REPORT)
                RepaintSelectedItems();
}
#endif


#ifdef CRY_USEMFC
void CxModList::OnSetFocus(CWnd* pOldWnd)
{
        CListCtrl::OnSetFocus(pOldWnd);

        // check if we are getting focus from label edit box
        if(pOldWnd!=NULL && pOldWnd->GetParent()==this)
                return;

        // repaint items that should change appearance
        if((GetStyle() & LVS_TYPEMASK)==LVS_REPORT)
                RepaintSelectedItems();
}
#endif



#ifdef CRY_USEMFC
void CxModList::ItemChanged( NMHDR * pNMHDR, LRESULT* pResult )
{
    NM_LISTVIEW* pnmv = (NM_LISTVIEW FAR *) pNMHDR;


    //Flags pnmv->uOldState and uNewState.    Meaning
    //                0             0         Nothing, happens on setup.
    //                0             1         Gained caret focus (but not selection) (I don't think this happens)
    //                0             2         Item has become selected
    //                0             3         Selected and has caret.
    //                1             0         Lost caret.
    //                2             0         Unselected.
    //                3             0         Unselected and lost caret.

// we are only interested in changes from (or to) {0|1} to {2|3}

    if(m_ProgSelecting > 0)
    {
        m_ProgSelecting--;
    }
    else
    {

        int item = (int)pnmv->iItem;
        ostringstream strm;
        if (pnmv->uNewState <= 1 && pnmv->uOldState >= 2) //Unselect Item.
        {
           strm << "UNSELECTED_N" + (int)pnmv->iItem + 1;
           ((CrModList*)ptr_to_crObject)->SendValue( strm.str() ); //Send the index
           int id = IDlist[item]-1;
//           TEXTOUT ( "Unselect. item=" + string(item) + ", id=" + string(id) );
           ((CrModList*)ptr_to_crObject)->SelectAtomByPosn(id,false);
        }
        else if (pnmv->uNewState >= 2 && pnmv->uOldState <= 1) //Select Item
        {
           strm << "SELECTED_N" + (int)pnmv->iItem + 1;
           ((CrModList*)ptr_to_crObject)->SendValue( strm.str() ); //Send the index only.
           int id = IDlist[item]-1;
//           TEXTOUT ( "Select. item=" + string(item) + ", id=" + string(id) );
           ((CrModList*)ptr_to_crObject)->SelectAtomByPosn(id,true);
        }


    }
}
#else
void CxModList::ItemSelected ( wxListEvent& event )
{
    if(m_ProgSelecting > 0)
    {
        m_ProgSelecting--;
    }
    else
    {
      int item = event.m_itemIndex;
      ostringstream strm;
      strm << "SELECTED_N" << item + 1;
      ((CrModList*)ptr_to_crObject)->SendValue( strm.str() ); //Send the index only.

      int id = IDlist[item]-1;
//      TEXTOUT ( "Select. item=" + string(item) + ", id=" + string(id) );
      ((CrModList*)ptr_to_crObject)->SelectAtomByPosn(id,true);
    }
}

void CxModList::ItemDeselected ( wxListEvent& event )
{
    if(m_ProgSelecting > 0)
    {
        m_ProgSelecting--;
    }
    else
    {
      int item = event.m_itemIndex;
      ostringstream strm;
      strm << "UNSELECTED_N" << item + 1;
      ((CrModList*)ptr_to_crObject)->SendValue( strm.str() ); //Send the index
      int id = IDlist[item]-1;
//      TEXTOUT ( "Unselect. item=" + string(item) + ", id=" + string(id) );
      ((CrModList*)ptr_to_crObject)->SelectAtomByPosn(id,false);
    }
}

void CxModList::HeaderClicked( wxListEvent& wxLE )
{

	if( wxLE.GetColumn() == nSortedCol )
		bSortAscending = !bSortAscending;
    else
        bSortAscending = true;

	nSortedCol = wxLE.GetColumn();
    CxSortItems( m_colTypes[nSortedCol], nSortedCol, bSortAscending );
 
}
bool CxModList::CxSortItems( int colType, int nCol, bool bAscending)
{


    int size = GetItemCount();
	int nColCount = GetColumnCount();

	vector<int> intsToSort;
    vector<float> floatsToSort;
    vector<string> stringsToSort;
	vector<int> index;


    for ( int i = 0; i < size; i++ )
    {
		index.push_back(i);

		wxListItem info;
        info.SetMask(wxLIST_MASK_TEXT);
        info.SetId( i );
		info.SetColumn ( nCol );
		GetItem(info);
		string ss = string(info.GetText().mb_str());

		switch ( colType )
        {
        case COL_INT:
            intsToSort.push_back( atoi(ss.c_str()) );
            break;
        case COL_REAL:
            floatsToSort.push_back( (float)atof(ss.c_str()) );
            break;
        case COL_TEXT:
            stringsToSort.push_back(ss);
            break;
        }
    }

	int tempi;
	float tempf;
	string temps;


// Sort the items along with the index. This is a stable insertion sort
// so that previous sorts remain in effect for a given value of this sort.
    for ( int element = 1; element < size; element++)
    {


// Extract details of this element
        switch ( colType )
        {
        case COL_INT:
			tempi = intsToSort[element];
            break;
        case COL_REAL:
            tempf = floatsToSort[element];
            break;
        case COL_TEXT:
            temps = stringsToSort[element];
            break;
        }
        int IDhold = IDlist[element];
		int indexHold = index[element];


// Take out 2nd element, and move it backwards down the list until it is in right 'place'.
// Take out 3rd element, and move it backwards down the list until it is in right 'place'.
// usw.

		bool repeat = true;
        int place;

		//Compare element with position back one place.
		
		for ( place = element-1; repeat; place-- )
        {
            if (place >= 0)
            {
                switch ( colType )
                {
                case COL_INT:
                    if(    (  bAscending && (intsToSort[place] <= tempi))
                        || ( !bAscending && (intsToSort[place] >= tempi)) )
                    {
// insert element here
						repeat              = false;
						index[place+1]		= indexHold;
                        IDlist[place+1]     = IDhold;
                        intsToSort[place+1] = tempi;
                    }
                    else
                    {
// shuffle other elements up to make space.
						index[place+1]		= index[place];
                        IDlist[place+1]     = IDlist[place];
                        intsToSort[place+1] = intsToSort[place];
                    }
                    break;
                case COL_REAL:
                    if(    (  bAscending && (floatsToSort[place] <= tempf))
                        || ( !bAscending && (floatsToSort[place] >= tempf)) )
                    {
                        repeat                = false;
						index[place+1]		= indexHold;
                        IDlist[place+1]       = IDhold;
                        floatsToSort[place+1] = tempf;
                    }
                    else
                    {
						index[place+1]		= index[place];
                        IDlist[place+1]      = IDlist[place];
                        floatsToSort[place+1] = floatsToSort[place];
                    }
                    break;
                case COL_TEXT:
                    if(    (  bAscending && (stringsToSort[place] <= temps))
                        || ( !bAscending && (stringsToSort[place] >= temps)) )
                    {
                        repeat                 = false;
						index[place+1]		= indexHold;
                        IDlist[place+1]       = IDhold;
                        stringsToSort[place+1] = temps;
                    }
                    else
                    {
						index[place+1]		= index[place];
                        IDlist[place+1]      = IDlist[place];
                        stringsToSort[place+1] = stringsToSort[place];
                    }
                    break;
                }
            }
            else
            {
                switch ( colType )
                {
                case COL_INT:
                    intsToSort[0] = tempi;
                    break;
                case COL_REAL:
                    floatsToSort[0] = tempf;
                    break;
                case COL_TEXT:
                    stringsToSort[0] = temps;
                    break;
                }
                IDlist[0]      = IDhold;
				index[0]	   = indexHold;
                repeat = false;
            }
        }
    }


	for ( int rc = 0; rc < size; rc++ ) {
		SetItemData(index[rc], rc);
	}

	SortItems(MySorter, 1);
    return true;

}
#endif

//         Copyright 1997-1998 CodeGuru
//         Contact : webmaster@codeguru.com

//         Modified to sort based on REAL, INT or TEXT. R.Cooper Nov 98.

//         Clever sort replaced with straight insertion so that previous
//         sorts still remain in effect if there is no difference in the
//         current sorted values.                       R.Cooper Nov 98.

//         Sort of items in place replaced with an indexed sort on the column data
//         which is then applied to the whole list. This saves an incredible
//         amount of time.                              R.Cooper Nov 98.

#ifdef CRY_USEMFC
void CxModList::OnHeaderClicked(NMHDR* pNMHDR, LRESULT* pResult)
{
        HD_NOTIFY *phdn = (HD_NOTIFY *) pNMHDR;

        if( phdn->iButton == 0 )
        {
                // User clicked on header using left mouse button
                if( phdn->iItem == nSortedCol )
                        bSortAscending = !bSortAscending;
                else
                        bSortAscending = true;

                nSortedCol = phdn->iItem;
                CxSortItems( m_colTypes[nSortedCol], nSortedCol, bSortAscending );

        }
        *pResult = 0;
}
#endif

// SortItems            - Sort the list based on column text
// Returns              - Returns true for success
// colType              - INT, REAL or TEXT. Makes sure correct sort is done.
// nCol                 - column that contains the text to be sorted
// bAscending           - indicate sort order
#ifdef CRY_USEMFC
bool CxModList::CxSortItems( int colType, int nCol, bool bAscending)
{
    int nColCount = ((CHeaderCtrl*)GetDlgItem(0))->GetItemCount();
    if( nCol >= nColCount)
            return false;

    int size = GetItemCount();

    int *intsToSort = nil;
    float *floatsToSort = nil;
    CString *stringsToSort = nil;

    int* index = new int[size+1];

    switch ( colType )
    {
    case COL_INT:
        intsToSort = new int[size+1];
        break;
    case COL_REAL:
        floatsToSort = new float [size+1];
        break;
    case COL_TEXT:
        stringsToSort = new CString[size+1];
        break;
    }

    index[0] = 0;
    for ( int i = 0; i < size; i++ )
    {
        index[i+1] = i+1;
        CString s = GetItemText(i, nCol);
        switch ( colType )
        {
        case COL_INT:
            intsToSort[i+1] = atoi(s);
            break;
        case COL_REAL:
            floatsToSort[i+1] = (float)atof(s);
            break;
        case COL_TEXT:
            stringsToSort[i+1] = s;
            break;
        }
    }

// Sort the items along with the index. This is a stable sort
// so that previous sorts remain in effect for a given value of this sort.
    for ( int element = 2; element <= size; element++)
    {
        switch ( colType )
        {
        case COL_INT:
            intsToSort[0] = intsToSort[element];
            break;
        case COL_REAL:
            floatsToSort[0] = floatsToSort[element];
            break;
        case COL_TEXT:
            stringsToSort[0] = stringsToSort[element];
            break;
        }
        int hold = index[element];
        int IDhold = IDlist[element-1];
        bool repeat = true;
        int place;
        for ( place = element - 1; repeat; place-- )
        {
            if (place > 0)
            {
                switch ( colType )
                {
                case COL_INT:
                    if(    (  bAscending && (intsToSort[place] <= intsToSort[0]))
                        || ( !bAscending && (intsToSort[place] >= intsToSort[0])) )
                    {
                        repeat              = false;
                        index[place+1]      = hold;
                        IDlist[place]       = IDhold;
                        intsToSort[place+1] = intsToSort[0];
                    }
                    else
                    {
                        index[place+1]      = index[place];
                        IDlist[place]      = IDlist[place-1];
                        intsToSort[place+1] = intsToSort[place];
                    }
                    break;
                case COL_REAL:
                    if(    (  bAscending && (floatsToSort[place] <= floatsToSort[0]))
                        || ( !bAscending && (floatsToSort[place] >= floatsToSort[0])) )
                    {
                        repeat                = false;
                        index[place+1]        = hold;
                        IDlist[place]       = IDhold;
                        floatsToSort[place+1] = floatsToSort[0];
                    }
                    else
                    {
                        index[place+1]        = index[place];
                        IDlist[place]      = IDlist[place-1];
                        floatsToSort[place+1] = floatsToSort[place];
                    }
                    break;
                case COL_TEXT:
                    if(    (  bAscending && (stringsToSort[place] <= stringsToSort[0]))
                        || ( !bAscending && (stringsToSort[place] >= stringsToSort[0])) )
                    {
                        repeat                 = false;
                        index[place+1]         = hold;
                        IDlist[place]       = IDhold;
                        stringsToSort[place+1] = stringsToSort[0];
                    }
                    else
                    {
                        index[place+1]         = index[place];
                        IDlist[place]      = IDlist[place-1];
                        stringsToSort[place+1] = stringsToSort[place];
                    }
                    break;
                }
            }
            else
            {
                switch ( colType )
                {
                case COL_INT:
                    intsToSort[1] = intsToSort[0];
                    break;
                case COL_REAL:
                    floatsToSort[1] = floatsToSort[0];
                    break;
                case COL_TEXT:
                    stringsToSort[1] = stringsToSort[0];
                    break;
                }
                index[1] = hold;
                IDlist[0]      = IDhold;
                repeat = false;
            }
        }
    }

//The array should be in the right order now, if errors are occuring they are
//probably from the next section which sorts the original list into the same order.

//  int ic;
    LV_ITEM insertItem;
    LV_ITEM moveItem;
    CStringArray rowText;
    rowText.SetSize( nColCount );

    bool *sorted = new bool[size+1];
    for (int i = 0; i <= size; i++)
        sorted[i] = false;

    for ( int j = 1; j <= size; j++)
    {

        if ( sorted[j] == false )
        {
            int newPoint = j;
            for( i=0; i<nColCount; i++)
                rowText[i] = GetItemText(newPoint - 1, i);

            insertItem.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
            insertItem.iItem = newPoint - 1;
            insertItem.iSubItem = 0;
            insertItem.stateMask =  LVIS_CUT | LVIS_DROPHILITED |
                                    LVIS_FOCUSED |  LVIS_SELECTED |
                                    LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;
            GetItem( &insertItem );
//          TRACE("Storing item at %d \n",newPoint);

            sorted[newPoint] = true;

            while ( index[newPoint] != j )
            {
                moveItem.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
                moveItem.iItem = index[newPoint] - 1;
                moveItem.iSubItem = 0;
                moveItem.stateMask = LVIS_CUT | LVIS_DROPHILITED |
                                    LVIS_FOCUSED |  LVIS_SELECTED |
                                    LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;
                GetItem( &moveItem );
                moveItem.iItem = newPoint - 1;
                m_ProgSelecting = 2;
                SetItem( &moveItem );
                m_ProgSelecting = 0;


//              TRACE("Moving item from %d to %d \n",index[newPoint],newPoint);
                for( i=0; i<nColCount; i++)
                    SetItemText(newPoint-1, i, GetItemText(index[newPoint]-1, i));

                newPoint = index[newPoint];
                sorted[newPoint] = true;
            }

//          TRACE("Moving stored item ( from %d ) to %d \n",j,newPoint);
            for( i=0; i<nColCount; i++)
                SetItemText( newPoint - 1, i, rowText[i]);
            insertItem.iItem = newPoint - 1;
            m_ProgSelecting = 2;
            SetItem( &insertItem );
            m_ProgSelecting = 0;
        }                     
    }
    delete [] index;
    delete [] intsToSort;
    delete [] floatsToSort;
    delete [] stringsToSort;
    delete [] sorted;

    return true;

}
#endif





//Work out whether a string is REAL, INT or TEXT.

int CxModList::WhichType(const string & text)
{
    string::size_type tbegin, tend;

//Test one: Any characters other than space, number or point.
    if ( text.find_first_not_of(" 1234567890-.") != string::npos ) {
//		ostringstream o;
//		o << "Text contains non sp,num,point: " << text.find_first_not_of(" 1234567890-.") << " " << text;
//		LOGERR(o.str());
        return COL_TEXT;
	}

//Test two: One token only.
    tbegin = text.find_first_not_of(" ");
    if ( tbegin != string::npos ) 
    {
       tend = text.find_first_of(" ",tbegin);
       if ( ( tend != string::npos ) && 
            ( text.find_first_not_of(" ",tend) != string::npos ) ) {
//				ostringstream o;
//				o << "Text contains 2 tokens: " << text;
//				LOGERR(o.str());
				return COL_TEXT;
			}
//Test two(b): Minus sign in correct place if present.
       if (text.find_last_of("-") != string::npos ) {
			if (text.find_last_of("-") != tbegin ) {
//   				ostringstream o;
//				o << "Text contains - tokens not a beginning: " << text;
//				LOGERR(o.str());
				return COL_TEXT;
			}
		}
    }

//Test three, check for one decimal point.

    tbegin = text.find_first_of(".");
    tend = text.find_last_of(".");

    if ( tbegin != tend ) {
//		ostringstream o;
//		o << "Text contains 2 dps: " << text;
//		LOGERR(o.str());
		return COL_TEXT;  // Two decimal points.
	}
    if ( tbegin != string::npos ) return COL_REAL; // One decimal point
    
    return COL_INT;       // No decimal points.

}


#ifdef CRY_USEMFC
void CxModList::SelectAll(bool select)
{
    int size = GetItemCount();
    m_ProgSelecting = size;
    LV_ITEM moveItem;

    for ( int i = 0; i < size; i++ )
    {
        moveItem.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
        moveItem.iItem = i;
        moveItem.iSubItem = 0;
        moveItem.stateMask = LVIS_CUT | LVIS_DROPHILITED |
                            LVIS_FOCUSED |  LVIS_SELECTED |
                            LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;
        GetItem( &moveItem );
        if(select)
            moveItem.state |= LVIS_SELECTED;
        else
            moveItem.state &= (~LVIS_SELECTED);
        SetItem( &moveItem );
    }

}
#endif

#ifdef CRY_USEMFC
string CxModList::GetCell(int row, int col)
{
    CString temp = GetItemText(row, col);
    string retVal = temp.GetBuffer(temp.GetLength());
    return retVal;
}
#else
string CxModList::GetCell(int row, int col)
{
 return string("Unimplemented");
}
string CxModList::GetListItem(int item)
{
 return string("unimplemented");
}
#endif

#ifdef CRY_USEMFC
string CxModList::GetListItem(int item)
{
    int nColCount = ((CHeaderCtrl*)GetDlgItem(0))->GetItemCount();
    CString textresult = "";

    for( int i=0; i<nColCount; i++)
        textresult += GetItemText(item, i) + " ";

    string result = textresult.GetBuffer(textresult.GetLength());
    return result;
}

void    CxModList::InvertSelection()
{
    int size = GetItemCount();
    m_ProgSelecting = size;
    LV_ITEM moveItem;

    for ( int i = 0; i < size; i++ )
    {
        moveItem.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
        moveItem.iItem = i;
        moveItem.iSubItem = 0;
        moveItem.stateMask = LVIS_CUT | LVIS_DROPHILITED |
                            LVIS_FOCUSED |  LVIS_SELECTED |
                            LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;
        GetItem( &moveItem );

        bool select = (( moveItem.state & LVIS_SELECTED ) != 0);

        if(select)
            moveItem.state &= (~LVIS_SELECTED);
        else
            moveItem.state |= LVIS_SELECTED;
        SetItem( &moveItem );
    }

}
#else


int CxModList::GetNumberSelected()
{
  return -1;
}
#endif

#ifdef CRY_USEMFC
int CxModList::GetNumberSelected()
{
    int size = GetItemCount();
    LV_ITEM moveItem;
    int count = 0;

    for ( int i = 0; i < size; i++ )
    {
        moveItem.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
        moveItem.iItem = i;
        moveItem.iSubItem = 0;
        moveItem.stateMask = LVIS_CUT | LVIS_DROPHILITED |
                            LVIS_FOCUSED |  LVIS_SELECTED |
                            LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;
        GetItem( &moveItem );
        if (( moveItem.state & LVIS_SELECTED ) != 0) count++;

    }
    return count;
}
#else

void CxModList::GetSelectedIndices(  int * values )
{
  return;
}
#endif

#ifdef CRY_USEMFC
void CxModList::GetSelectedIndices(  int * values )
{
    int size = GetItemCount();
    int count = 0;
    LV_ITEM moveItem;

    for ( int i = 0; i < size; i++ )
    {
        moveItem.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
        moveItem.iItem = i;
        moveItem.iSubItem = 0;
        moveItem.stateMask = LVIS_CUT | LVIS_DROPHILITED |
                            LVIS_FOCUSED |  LVIS_SELECTED |
                            LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;
        GetItem( &moveItem );
        if (( moveItem.state & LVIS_SELECTED ) != 0)
        {
            values[count] = i;
            count ++;
        }
    }
    return;
}
#endif

void CxModList::Update(int newsize) 
{
//  LOGERR ( "Model changed" );
// Fetch new atom info from ModelDoc.

       if (newsize != IDlist.size())
       {
//		   LOGERR("New size");
          DeleteAllItems();
          IDlist.clear();
       }

//       m_listboxparent->LockWindowUpdate();

#ifdef CRY_USEMFC
       SetRedraw(FALSE);
//       SendMessage(WM_SETREDRAW,FALSE,0);
       ((CrModList*)ptr_to_crObject)->DocToList();
       SetRedraw(TRUE);
//       SendMessage(WM_SETREDRAW,TRUE,0);
       Invalidate(FALSE);
#else
//       SendMessage((HWND)GetHWND(),WM_SETREDRAW,FALSE,0);
       ((CrModList*)ptr_to_crObject)->DocToList();
//       SendMessage((HWND)GetHWND(),WM_SETREDRAW,TRUE,0);
       Refresh();
#endif

}


#ifdef CRY_USEMFC
void CxModList::RightClick( NMHDR * pNMHDR, LRESULT* pResult )
{
 NMITEMACTIVATE* lpnmitem = (LPNMITEMACTIVATE) pNMHDR;

// TEXTOUT("Right click! "+string(lpnmitem->iItem));

 int iitem = lpnmitem->iItem;

 CPoint p = lpnmitem->ptAction;
 ClientToScreen(&p); // change the coordinates of the click from window to screen coords so that the menu appears in the right place

 int px = p.x;
 int py = p.y;

 if ( iitem >= 0 )
 {
   LV_ITEM lvi;
   lvi.mask = LVIF_IMAGE | LVIF_STATE;
   lvi.iItem = lpnmitem->iItem;
   lvi.iSubItem = 0;
   lvi.stateMask = 0xFFFF;         // get all state flags
   GetItem(&lvi);
// Is item highlighted?
   bool bHighlight = (lvi.state & LVIS_SELECTED) != 0;

   int id = IDlist[iitem]-1;


   if ( bHighlight )
   {
//item is selected, but only one: show SINGLE menu.
//item is selected, more than one: show GROUP menu. Let Cr decide.
    ((CrModList*)ptr_to_crObject)->ContextMenu(px, py, id, 2);
   }
   else
   {
//item is not selected: show SINGLE menu.
    ((CrModList*)ptr_to_crObject)->ContextMenu(px, py, id, 3);
   }
  }
  else
  {
//Click missed all items: show NONE menu.
    ((CrModList*)ptr_to_crObject)->ContextMenu(px, py, -1, 1);
  }
 *pResult = 1;

}
#else

void CxModList::RightClick( wxListEvent& event )
{
 int item = event.m_itemIndex;

 wxPoint p = event.GetPoint();

 int px = p.x;
 int py = p.y;

 if ( item >= 0 )
 {
   wxListItem li = event.GetItem();

//   int d = li.GetState();

//   bool bHighlight = (d & wxLIST_STATE_SELECTED) != 0;

   bool bHighlight = ((GetItemState (item, wxLIST_STATE_SELECTED) & wxLIST_STATE_SELECTED) != 0);
   int id = IDlist[item]-1;

   if ( bHighlight )
   {
//item is selected, but only one: show SINGLE menu.
//item is selected, more than one: show GROUP menu. Let Cr decide.
    ((CrModList*)ptr_to_crObject)->ContextMenu(px, py, id, 2);
   }
   else
   {
//item is not selected: show SINGLE menu.
    ((CrModList*)ptr_to_crObject)->ContextMenu(px, py, id, 3);
   }
  }
  else
  {
//Click missed all items: show NONE menu.
    ((CrModList*)ptr_to_crObject)->ContextMenu(px, py, -1, 1);
  }
}
#endif

#ifdef CRY_USEMFC
void CxModList::OnMenuSelected(UINT nID)
{
    ((CrModList*)ptr_to_crObject)->MenuSelected( nID );
}
#endif

void CxModList::CxEnsureVisible(CcModelAtom* va)
{
//Find atom id in list
       int id;
       for ( id = 0; id < (int)IDlist.size(); id++ )
       {
          if ( IDlist[id] == va->id ) break;
       }
#ifdef CRY_USEMFC
       EnsureVisible(id,false); //Call library function to ensure it is shown.
#else
       EnsureVisible(id); //Call library function to ensure it is shown.
#endif
}
