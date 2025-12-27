////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CxListCtrl.cpp
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include    "cxlistctrl.h"

#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "crlistctrl.h"
#include    "cccontroller.h"
#include    <math.h>
#include    <string>
#include    <sstream>

int CxListCtrl::mListCtrlCount = kListCtrlBase;


int wxCALLBACK MyCxListSorter(wxIntPtr item1, wxIntPtr item2, wxIntPtr sortData)
{
    // inverse the order
    if (item1 < item2)
        return -1 * sortData;
    if (item1 > item2)
        return 1 * sortData;
    return 0;
}




CxListCtrl *    CxListCtrl::CreateCxListCtrl( CrListCtrl * container, CxGrid * guiParent )
{
    CxListCtrl  *theListCtrl = new CxListCtrl( container );
      theListCtrl->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10),
                          wxLC_REPORT);
    return theListCtrl;
}

CxListCtrl::CxListCtrl( CrListCtrl * container )
      : BASELISTCTRL()
{
    ptr_to_crObject = container;

    mItems = 0;
    mVisibleLines = 0;
    m_numcols = 0;
    m_nHighlight = HIGHLIGHT_ROW;
    nSortedCol = -1;
    bSortAscending = true;
    m_ProgSelecting = 0;
}

CxListCtrl::~CxListCtrl()
{
    RemoveListCtrl();
}


void    CxListCtrl::SetVisibleLines( int lines )
{
    mVisibleLines = lines;
}

CXSETGEOMETRY(CxListCtrl)

CXGETGEOMETRIES(CxListCtrl)


void CxListCtrl::CxClear(){
    mItems = 0;
    mVisibleLines = 0;
    m_nHighlight = HIGHLIGHT_ROW;
    bSortAscending = true;
    DeleteAllItems();
    m_originalIndex.clear();
}

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
      return mVisibleLines * ( GetCharHeight() + 2 );
}

int CxListCtrl::GetValue()
{
    return 0;
}



BEGIN_EVENT_TABLE(CxListCtrl, wxListCtrl)
     EVT_CHAR( CxListCtrl::OnChar )
     EVT_LIST_COL_CLICK(-1, CxListCtrl::HeaderClicked )
     EVT_LIST_ITEM_SELECTED(-1, CxListCtrl::ItemSelected )
     EVT_LIST_ITEM_DESELECTED(-1, CxListCtrl::ItemDeselected )
END_EVENT_TABLE()


void CxListCtrl::Focus()
{
    SetFocus();
}

CXONCHAR(CxListCtrl)


void CxListCtrl::AddColumn(string colHeader)
{
    m_numcols++;

//Always start with INT. This will fail to REAL, and then to TEXT as data is input
    m_colTypes.push_back(COL_INT);


    int w,h;
    GetTextExtent(colHeader.c_str(),&w,&h);
    m_colWidths.push_back( CRMAX(10,w) );
    InsertColumn(m_numcols-1, colHeader.c_str(),wxLIST_FORMAT_LEFT, 10 );
    SetColumnWidth(m_numcols-1,m_colWidths.back());

}



void CxListCtrl::AddRow(string * rowOfStrings)
{

    int nItem = InsertItem(mItems++, _T(""));

    m_originalIndex.push_back(m_originalIndex.size()); // 0=0,2=2 etc.

    for (int j = 0; j < m_numcols; j++)
    {
        SetItem(nItem, j, rowOfStrings[j].c_str());
        int width,h;
        GetTextExtent(rowOfStrings[j].c_str(),&width,&h);
        m_colWidths[j] = CRMAX(m_colWidths[j],width + 15);
        SetColumnWidth(j,m_colWidths[j]);
        int type = WhichType(rowOfStrings[j]);
        m_colTypes[j] = CRMAX(m_colTypes[j], type);
    }
}

void CxListCtrl::HeaderClicked( wxListEvent& wxLE )
{

    if( wxLE.GetColumn() == nSortedCol )
        bSortAscending = !bSortAscending;
    else
        bSortAscending = true;

    nSortedCol = wxLE.GetColumn();
    CxSortItems( m_colTypes[nSortedCol], nSortedCol, bSortAscending );
 
}
bool CxListCtrl::CxSortItems( int colType, int nCol, bool bAscending)
{


    int size = GetItemCount();
//	int nColCount = GetColumnCount();

	vector<int> intsToSort;
    vector<float> floatsToSort;
    vector<string> stringsToSort;
	vector<int> index;


// Make a list of the things that are going to be used to sort on
    
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
        int IDhold = m_originalIndex[element];
		int indexHold = index[element];


// Take out 2nd element, and move it backwards down the list until it is in right 'place'.
// Take out 3rd element, and move it backwards down the list until it is in right 'place'.

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
                        m_originalIndex[place+1]     = IDhold;
                        intsToSort[place+1] = tempi;
                    }
                    else
                    {
// shuffle other elements up to make space.
						index[place+1]		= index[place];
                        m_originalIndex[place+1]     = m_originalIndex[place];
                        intsToSort[place+1] = intsToSort[place];
                    }
                    break;
                case COL_REAL:
                    if(    (  bAscending && (floatsToSort[place] <= tempf))
                        || ( !bAscending && (floatsToSort[place] >= tempf)) )
                    {
                        repeat                = false;
						index[place+1]		= indexHold;
                        m_originalIndex[place+1]       = IDhold;
                        floatsToSort[place+1] = tempf;
                    }
                    else
                    {
						index[place+1]		= index[place];
                        m_originalIndex[place+1]      = m_originalIndex[place];
                        floatsToSort[place+1] = floatsToSort[place];
                    }
                    break;
                case COL_TEXT:
                    if(    (  bAscending && (stringsToSort[place] <= temps))
                        || ( !bAscending && (stringsToSort[place] >= temps)) )
                    {
                        repeat                 = false;
						index[place+1]		= indexHold;
                        m_originalIndex[place+1]       = IDhold;
                        stringsToSort[place+1] = temps;
                    }
                    else
                    {
						index[place+1]		= index[place];
                        m_originalIndex[place+1]      = m_originalIndex[place];
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
                m_originalIndex[0]      = IDhold;
                index[0]	   = indexHold;
                repeat = false;
            }
        }
    }

//    for ( int ioc = 0; ioc < m_originalIndex.size(); ioc ++ ) {
//      ostringstream strm;
//      strm << m_originalIndex[ioc] ;
//      LOGWARN(strm.str());
//    }
    

	for ( int rc = 0; rc < size; rc++ ) {
		SetItemData(index[rc], rc);
	}

	SortItems(MyCxListSorter, 1);
    return true;

}


void CxListCtrl::ItemSelected ( wxListEvent& event )
{
    if(m_ProgSelecting > 0)
    {
        m_ProgSelecting--;
    }
    else
    {
      int item = event.m_itemIndex;
      int origi = m_originalIndex[item];
      ostringstream strm;
      strm << "SELECTED_N" << origi + 1;
      ((CrListCtrl*)ptr_to_crObject)->SendValue( strm.str() ); //Send the index only.
//      LOGWARN( "CrListCtrl sent: " + strm.str());

    }
}

void CxListCtrl::ItemDeselected ( wxListEvent& event )
{
    if(m_ProgSelecting > 0)
    {
        m_ProgSelecting--;
    }
    else
    {
      int item = event.m_itemIndex;
      int origi = m_originalIndex[item];
      ostringstream strm;
      strm << "UNSELECTED_N" << origi + 1;
      ((CrListCtrl*)ptr_to_crObject)->SendValue( strm.str() ); //Send the index
//      LOGWARN( "CrListCtrl sent: " + strm.str());
    }
}






void CxListCtrl::SortCol(int col, bool sort)
{
}





//Work out whether a string is REAL, INT or TEXT.

int CxListCtrl::WhichType(string text)
{
    string::size_type i;
//Test one: Any characters other than space, number or point.
    for (i = 0; i < text.length(); i++)
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
    for (i = 0; i < text.length(); i++)
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
    for (i = 0; i < text.length(); i++)
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
}

string CxListCtrl::GetCell(int row, int col)
{
 return string("Unimplemented");
}

void CxListCtrl::SelectPattern(string * strings, bool select)
{
}

string CxListCtrl::GetListItem(int item)
{
  return string("Unimplemented");
}

void    CxListCtrl::InvertSelection()
{
}


int CxListCtrl::GetNumberSelected()
{
  return -1;
}

void CxListCtrl::GetSelectedIndices(  int * values )
{
   return;
}

void CxListCtrl::CxSetSelection( int select )
{
   if ( mItems < 1 ) return;

   if ( select < 1 ) select = mItems+select+1; // reverse indexing is possible

   select = CRMIN ( select, mItems );
   select = CRMAX ( select, 1 );
    SetItemState(select - 1, wxLIST_STATE_SELECTED, wxLIST_STATE_SELECTED);
}
