// This class is being temporarily removed from the LINUX version,
// as it is far too complicated and not even used in SCRIPTS yet.
#ifdef __CR_WIN__

////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CxListCtrl.cc
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include    "cxlistctrl.h"

#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "crlistctrl.h"
#include    "cccontroller.h"
#include    <math.h>

int CxListCtrl::mListCtrlCount = kListCtrlBase;

CxListCtrl *    CxListCtrl::CreateCxListCtrl( CrListCtrl * container, CxGrid * guiParent )
{
    CxListCtrl  *theListCtrl = new CxListCtrl( container );
#ifdef __CR_WIN__
    theListCtrl->Create(WS_CHILD|WS_VISIBLE|LVS_REPORT|LVS_OWNERDRAWFIXED|LVS_SHOWSELALWAYS|WS_VSCROLL, CRect(0,0,5,5), guiParent, mListCtrlCount++);
    theListCtrl->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
    theListCtrl->SetFont(CcController::mp_font);
#endif
#ifdef nnLINUXnn
      theListCtrl->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10),
                          wxLC_REPORT);
#endif
    return theListCtrl;
}

CxListCtrl::CxListCtrl( CrListCtrl * container )
      : BASELISTCTRL()
{
    ptr_to_crObject = container;

    mItems = 0;
    mVisibleLines = 0;
    m_numcols = 0;
    m_colWidths = nil;
    m_colTypes = nil;
    m_nHighlight = HIGHLIGHT_ROW;
    nSortedCol = -1;
    bSortAscending = true;
    m_ProgSelecting = 0;
    m_originalIndex = nil;
}

CxListCtrl::~CxListCtrl()
{
    RemoveListCtrl();
    delete [] m_colWidths;
    delete [] m_colTypes;
}


void    CxListCtrl::SetVisibleLines( int lines )
{
    mVisibleLines = lines;
}

CXSETGEOMETRY(CxListCtrl)

CXGETGEOMETRIES(CxListCtrl)


int CxListCtrl::GetIdealWidth()
{
    int totWidth = 15; // 5 pixels extra.
    for (int i = 0; i<m_numcols; i++)
    {
        totWidth += m_colWidths[i];
    }
    return ( totWidth );
}

int CxListCtrl::GetIdealHeight()
{
#ifdef __CR_WIN__
    int lines = mVisibleLines;
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    return lines * ( textMetric.tmHeight + 2 );
#endif
#ifdef nnLINUXnn
      return mVisibleLines * ( GetCharHeight() + 2 );
#endif
}

int CxListCtrl::GetValue()
{
    return 0;
}



#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxListCtrl, CListCtrl)
    ON_WM_CHAR()
    ON_WM_DRAWITEM()
    ON_WM_PAINT()
    ON_WM_KILLFOCUS()
    ON_WM_SETFOCUS()
    ON_NOTIFY(HDN_ITEMCLICKA, 0, OnHeaderClicked)
      ON_NOTIFY(HDN_ITEMCLICKW, 0, OnHeaderClicked)
    ON_NOTIFY_REFLECT( LVN_ITEMCHANGED, ItemChanged )
END_MESSAGE_MAP()
#endif
#ifdef nnLINUXnn
//wx Message Map
BEGIN_EVENT_TABLE(CxButton, wxButton)
      EVT_CHAR( CxButton::OnChar )
      EVT...
      EVT...
      EVT...
      ECT...
      EVT...
      EVT_LIST_COL_CLICK
END_EVENT_TABLE()
#endif




void CxListCtrl::Focus()
{
    SetFocus();
}

CXONCHAR(CxListCtrl)


void CxListCtrl::AddColumn(CcString colHeader)
{
    m_numcols++;
    int *newcolWidths = new int[m_numcols];
    int *newcolTypes  = new int[m_numcols];

    for ( int i = 0; i < (m_numcols - 1); i++ )
    {
        newcolWidths[i] = m_colWidths[i];
        newcolTypes[i]  = m_colTypes[i];
    }
    newcolTypes[m_numcols-1] = COL_INT; //Always start with INT. This will fail to REAL, and then to TEXT.
    newcolWidths[m_numcols-1] = max(10,GetStringWidth(colHeader.ToCString())+15);
    InsertColumn( m_numcols, colHeader.ToCString(), LVCFMT_LEFT, 10, m_numcols );
    SetColumnWidth(m_numcols,newcolWidths[m_numcols-1]);

    delete [] m_colWidths;      //delete the old list of widths.
    m_colWidths = newcolWidths; //re-assign pointer, to the new list.
    delete [] m_colTypes;
    m_colTypes = newcolTypes;
}

void CxListCtrl::AddRow(CcString * rowOfStrings)
{

    int nItem = InsertItem(mItems++, _T(""));

    int *newIndex = new int[mItems+1];
    for ( int i=1; i < (mItems); i++ )
    {
        newIndex[i] = m_originalIndex[i];
    }
    newIndex[mItems] = mItems;
    delete [] m_originalIndex;
    m_originalIndex = newIndex;

    for (int j = 0; j < m_numcols; j++)
    {
        SetItemText(nItem, j, rowOfStrings[j].ToCString());
        int width = GetStringWidth(rowOfStrings[j].ToCString());
        m_colWidths[j] = max(m_colWidths[j],width + 15);
        SetColumnWidth(j,m_colWidths[j]);
        int type = WhichType(rowOfStrings[j]);
        m_colTypes[j] = max(m_colTypes[j], type);
    }
}





//// The following code fragment is from www.codeguru.com and implements full row highlighting:


void CxListCtrl::DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct)
{
        CDC* pDC = CDC::FromHandle(lpDrawItemStruct->hDC);
        CRect rcItem(lpDrawItemStruct->rcItem);
        int nItem = lpDrawItemStruct->itemID;
        CImageList* pImageList;

        // Save dc state
        int nSavedDC = pDC->SaveDC();

        // Get item image and state info
        LV_ITEM lvi;
        lvi.mask = LVIF_IMAGE | LVIF_STATE;
        lvi.iItem = nItem;
        lvi.iSubItem = 0;
        lvi.stateMask = 0xFFFF;         // get all state flags
        GetItem(&lvi);

        // Should the item be highlighted
        bool bHighlight =((lvi.state & LVIS_DROPHILITED)
                                || ( (lvi.state & LVIS_SELECTED)
                                        && ((GetFocus() == this)
                                                || (GetStyle() & LVS_SHOWSELALWAYS)
                                                )
                                        )
                                );


        // Get rectangles for drawing
        CRect rcBounds, rcLabel, rcIcon;
        GetItemRect(nItem, rcBounds, LVIR_BOUNDS);
        GetItemRect(nItem, rcLabel, LVIR_LABEL);
        GetItemRect(nItem, rcIcon, LVIR_ICON);
        CRect rcCol( rcBounds );


        CString sLabel = GetItemText( nItem, 0 );

        // Labels are offset by a certain amount
        // This offset is related to the width of a space character
        int offset = pDC->GetTextExtent(_T(" "), 1 ).cx*2;

        CRect rcHighlight;
        CRect rcWnd;
        int nExt;
        switch( m_nHighlight )
        {
        case 0:
                nExt = pDC->GetOutputTextExtent(sLabel).cx + offset;
                rcHighlight = rcLabel;
                if( rcLabel.left + nExt < rcLabel.right )
                        rcHighlight.right = rcLabel.left + nExt;
                break;
        case 1:
                rcHighlight = rcBounds;
                rcHighlight.left = rcLabel.left;
                break;
//        case 2:
//                GetClientRect(&rcWnd);
//                rcHighlight = rcBounds;
//                rcHighlight.left = rcLabel.left;
//                rcHighlight.right = rcWnd.right;
//                break;
        case 2:
                GetClientRect(&rcWnd);
                rcHighlight = rcBounds;
                rcHighlight.left = rcLabel.left;
                rcHighlight.right = rcWnd.right+1;   // Add 1 to prevent trails
                break;
        default:
                rcHighlight = rcLabel;
        }

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

        // Draw state icon
        if (lvi.state & LVIS_STATEIMAGEMASK)
        {
                int nImage = ((lvi.state & LVIS_STATEIMAGEMASK)>>12) - 1;
                pImageList = GetImageList(LVSIL_STATE);
                if (pImageList)
                {
                        pImageList->Draw(pDC, nImage,
                                CPoint(rcCol.left, rcCol.top), ILD_TRANSPARENT);
                }
        }

        // Draw normal and overlay icon
        pImageList = GetImageList(LVSIL_SMALL);
        if (pImageList)
        {
                UINT nOvlImageMask=lvi.state & LVIS_OVERLAYMASK;
                pImageList->Draw(pDC, lvi.iImage,
                        CPoint(rcIcon.left, rcIcon.top),
                        (bHighlight?ILD_BLEND50:0) | ILD_TRANSPARENT | nOvlImageMask );
        }



        // Draw item label - Column 0
        rcLabel.left += offset/2;
        rcLabel.right -= offset;

        pDC->DrawText(sLabel,-1,rcLabel,DT_LEFT | DT_SINGLELINE | DT_NOPREFIX | DT_NOCLIP
                                | DT_VCENTER | DT_END_ELLIPSIS);


        // Draw labels for remaining columns
        LV_COLUMN lvc;
        lvc.mask = LVCF_FMT | LVCF_WIDTH;

        if( m_nHighlight == 0 )         // Highlight only first column
        {
                pDC->SetTextColor(::GetSysColor(COLOR_WINDOWTEXT));
                pDC->SetBkColor(::GetSysColor(COLOR_WINDOW));
        }

        rcBounds.right = rcHighlight.right > rcBounds.right ? rcHighlight.right :
                                                        rcBounds.right;
        rgn.CreateRectRgnIndirect(&rcBounds);
        pDC->SelectClipRgn(&rgn);

        for(int nColumn = 1; GetColumn(nColumn, &lvc); nColumn++)
        {
                rcCol.left = rcCol.right;
                rcCol.right += lvc.cx;

                // Draw the background if needed
                if( m_nHighlight == HIGHLIGHT_NORMAL )
                        pDC->FillRect(rcCol, &CBrush(::GetSysColor(COLOR_WINDOW)));

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


void CxListCtrl::RepaintSelectedItems()
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

void CxListCtrl::OnPaint()
{
        // in full row select mode, we need to extend the clipping region
        // so we can paint a selection all the way to the right
        if (m_nHighlight == HIGHLIGHT_ROW &&
                (GetStyle() & LVS_TYPEMASK) == LVS_REPORT )
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

                        rcClip.left = min(rcBounds.right-1, rcClip.left);
                        rcClip.right = rcClient.right;

                        InvalidateRect(rcClip, false);
                }
        }

        CListCtrl::OnPaint();
}


void CxListCtrl::OnKillFocus(CWnd* pNewWnd)
{
        CListCtrl::OnKillFocus(pNewWnd);

        // check if we are losing focus to label edit box
        if(pNewWnd != NULL && pNewWnd->GetParent() == this)
                return;

        // repaint items that should change appearance
        if((GetStyle() & LVS_TYPEMASK) == LVS_REPORT)
                RepaintSelectedItems();
}

void CxListCtrl::OnSetFocus(CWnd* pOldWnd)
{
        CListCtrl::OnSetFocus(pOldWnd);

        // check if we are getting focus from label edit box
        if(pOldWnd!=NULL && pOldWnd->GetParent()==this)
                return;

        // repaint items that should change appearance
        if((GetStyle() & LVS_TYPEMASK)==LVS_REPORT)
                RepaintSelectedItems();
}


int CxListCtrl::SetHighlightType(EHighlight hilite)
{
        int oldhilite = m_nHighlight;
        if( hilite <= HIGHLIGHT_ROW )
        {
                m_nHighlight = hilite;
                Invalidate();
        }
        return oldhilite;
}


void CxListCtrl::ItemChanged( NMHDR * pNMHDR, LRESULT* pResult )
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

        if (pnmv->uNewState <= 1 && pnmv->uOldState >= 2) //Unselect Item.
        {
                        ((CrListCtrl*)ptr_to_crObject)->SendValue("UNSELECTED_N" + CcString( m_originalIndex[(int)pnmv->iItem+1]) ); //Send the index
        }
        else if (pnmv->uNewState >= 2 && pnmv->uOldState <= 1) //Select Item
        {
                        ((CrListCtrl*)ptr_to_crObject)->SendValue("SELECTED_N" + CcString( m_originalIndex[(int)pnmv->iItem+1]) ); //Send the index only.
        }

    }
}


//         Copyright 1997-1998 CodeGuru
//         Contact : webmaster@codeguru.com

//         Modified to sort based on REAL, INT or TEXT. R.Cooper Nov 98.

//         Clever sort replaced with straight insertion so that previous
//         sorts still remain in effect if there is no difference in the
//         current sorted values.                       R.Cooper Nov 98.

//         Sort of items in place replaced with an indexed sort on the column data
//         which is then applied to the whole list. This saves an incredible
//         amount of time.                              R.Cooper Nov 98.

void CxListCtrl::OnHeaderClicked(NMHDR* pNMHDR, LRESULT* pResult)
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
                SortTextItems( m_colTypes[nSortedCol], nSortedCol, bSortAscending );

        }
        *pResult = 0;
}


// SortTextItems        - Sort the list based on column text
// Returns              - Returns true for success
// colType              - INT, REAL or TEXT. Makes sure correct sort is done.
// nCol                 - column that contains the text to be sorted
// bAscending           - indicate sort order
bool CxListCtrl::SortTextItems( int colType, int nCol, bool bAscending)
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

// Sort the items along with the index. This is a straight insertion sort
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
        int hold2 = m_originalIndex[element];
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
                        m_originalIndex[place+1] = hold2;
                        intsToSort[place+1] = intsToSort[0];
                    }
                    else
                    {
                        index[place+1]      = index[place];
                        m_originalIndex[place+1] = m_originalIndex[place];
                        intsToSort[place+1] = intsToSort[place];
                    }
                    break;
                case COL_REAL:
                    if(    (  bAscending && (floatsToSort[place] <= floatsToSort[0]))
                        || ( !bAscending && (floatsToSort[place] >= floatsToSort[0])) )
                    {
                        repeat                = false;
                        index[place+1]        = hold;
                        m_originalIndex[place+1]  = hold2;
                        floatsToSort[place+1] = floatsToSort[0];
                    }
                    else
                    {
                        index[place+1]        = index[place];
                        m_originalIndex[place+1] = m_originalIndex[place];
                        floatsToSort[place+1] = floatsToSort[place];
                    }
                    break;
                case COL_TEXT:
                    if(    (  bAscending && (stringsToSort[place] <= stringsToSort[0]))
                        || ( !bAscending && (stringsToSort[place] >= stringsToSort[0])) )
                    {
                        repeat                 = false;
                        index[place+1]         = hold;
                        m_originalIndex[place+1]         = hold2;
                        stringsToSort[place+1] = stringsToSort[0];
                    }
                    else
                    {
                        index[place+1]         = index[place];
                        m_originalIndex[place+1]         = m_originalIndex[place];
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
                m_originalIndex[1] = hold2;
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
    for (i = 0; i <= size; i++)
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
                SetItem( &moveItem );

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
            SetItem( &insertItem );
        }

    }
    delete [] index;
    delete [] intsToSort;
    delete [] floatsToSort;
    delete [] stringsToSort;
    delete [] sorted;

      return true;

}











//Work out whether a string is REAL, INT or TEXT.

int CxListCtrl::WhichType(CcString text)
{
    int i;
//Test one: Any characters other than space, number or point.
    for (i = 0; i < text.Length(); i++)
    {
        if (   text[i] != ' '
            && text[i] != '1'
            && text[i] != '2'
            && text[i] != '3'
            && text[i] != '4'
            && text[i] != '5'
            && text[i] != '6'
            && text[i] != '7'
            && text[i] != '8'
            && text[i] != '9'
            && text[i] != '0'
            && text[i] != '-'
            && text[i] != '.' ) return COL_TEXT;
    }

//Test two: One token only.
//Test two(b): Minus sign in correct place if present.
    bool inLeadingSpace = true;
    bool inFinalSpace = false;
    for (i = 0; i < text.Length(); i++)
    {
        if(inLeadingSpace)
        {
            if ( text[i] != ' ' )
            {
                inLeadingSpace = false;
            }
        }
        else
        {
            if ( text[i] == ' ' )
            {
                inFinalSpace = true;
            }
            if ( text[i] == '-' )
            {
                return COL_TEXT; //if we're not in leading space, or first char, there should be no minus sign.
            }
        }

        if(inFinalSpace)
        {
            if ( text[i] != ' ' )
            {
                return COL_TEXT;
            }
        }
    }



//Test three: One point symbol in the text.
    bool pointFound = false;
    for (i = 0; i < text.Length(); i++)
    {
        if ( text[i] == '.' )
        {
            if(pointFound)
            {
                return COL_TEXT;
            }
            else
            {
                pointFound = true;
            }
        }
    }

    if(pointFound)
    {
        return COL_REAL;
    }
    else
    {
        return COL_INT;
    }

}

void CxListCtrl::SelectAll(bool select)
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


CcString CxListCtrl::GetCell(int row, int col)
{
    CString temp = GetItemText(row, col);
    CcString retVal = temp.GetBuffer(temp.GetLength());
    return retVal;
}

void CxListCtrl::SelectPattern(CcString * strings, bool select)
{
    int size = GetItemCount();
    bool match = true;
    for ( int i = 0; i < size; i++ )
    {
        match = true;
        for ( int j = 0; ( ( j < m_numcols ) && match ); j++ )
        {
            if (  ! ( strings[j] == "*" ) )
            {
                switch ( m_colTypes[j] )
                {
                case COL_INT:
                    if ( strings[j].Sub(1,1) == ">" )
                    {
                        if( atoi(strings[j].Sub(2,-1).ToCString()) >= atoi(GetCell(i,j).ToCString()) )
                            match = false;
                    }
                    else if ( strings[j].Sub(1,1) == "<" )
                    {
                        if( atoi(strings[j].Sub(2,-1).ToCString()) <= atoi(GetCell(i,j).ToCString()) )
                            match = false;
                    }
                    else
                    {
                        if( atoi(strings[j].ToCString()) != atoi(GetCell(i,j).ToCString()) )
                            match = false;
                    }
                    break;
                case COL_REAL:
                    if ( strings[j].Sub(1,1) == ">" )
                    {
                        if( atof(strings[j].Sub(2,-1).ToCString()) >= atof(GetCell(i,j).ToCString()) )
                            match = false;
                    }
                    else if ( strings[j].Sub(1,1) == "<" )
                    {
                        if( atof(strings[j].Sub(2,-1).ToCString()) <= atof(GetCell(i,j).ToCString()) )
                            match = false;
                    }
                    else
                    {
                        if( atof(strings[j].ToCString()) != atof(GetCell(i,j).ToCString()) )
                            match = false;
                    }
                    break;
                case COL_TEXT:
                    if( ! ( strings[j] == GetCell(i,j) ) ) match = false;
                    break;
                }
            }
        }
        if (match)
        {
            m_ProgSelecting++;
            LV_ITEM setItem;
            setItem.mask = LVIF_IMAGE | LVIF_PARAM | LVIF_STATE;
            setItem.iItem = i;
            setItem.iSubItem = 0;
            setItem.stateMask = LVIS_CUT | LVIS_DROPHILITED |
                                LVIS_FOCUSED |  LVIS_SELECTED |
                                LVIS_OVERLAYMASK | LVIS_STATEIMAGEMASK;
            GetItem( &setItem );
            if(select)
                setItem.state |= LVIS_SELECTED;
            else
                setItem.state &= (~LVIS_SELECTED);
            SetItem( &setItem );
        }
    }
}

CcString CxListCtrl::GetListItem(int item)
{
    int nColCount = ((CHeaderCtrl*)GetDlgItem(0))->GetItemCount();
    CString textresult = "";

    for( int i=0; i<nColCount; i++)
        textresult += GetItemText(item, i) + " ";

    CcString result = textresult.GetBuffer(textresult.GetLength());
    return result;
}

void    CxListCtrl::InvertSelection()
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



int CxListCtrl::GetNumberSelected()
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

void CxListCtrl::GetSelectedIndices(  int * values )
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

void CxListCtrl::CxSetSelection( int select )
{
   if ( mItems < 1 ) return;

   if ( select < 1 ) select = mItems+select+1; // reverse indexing is possible

   select = min ( select, mItems );
   select = max ( select, 1 );
#ifdef __CR_WIN__
    SetItemState(select - 1, 0xFFFF, LVIS_SELECTED);
#endif
}


#endif
