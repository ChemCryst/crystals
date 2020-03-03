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
      theModList->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10),
                          wxLC_REPORT);
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
    m_numcols=14;
    string colHeader[14];
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
    colHeader[13] = "Flags";

    for ( int i = 0; i < m_numcols ; i++ )
    {
      m_colTypes.push_back(COL_INT); //Always start with INT. This will fail to REAL, and then to TEXT.
      int w,h;
      GetTextExtent(colHeader[i].c_str(),&w,&h);
      m_colWidths.push_back(CRMAX(10,w));
      InsertColumn( i, colHeader[i].c_str(), wxLIST_FORMAT_LEFT, 10 );
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
      return mVisibleLines * ( GetCharHeight() + 2 );
}

int CxModList::GetValue()
{
    return 0;
}



BEGIN_EVENT_TABLE(CxModList, wxListCtrl)
     EVT_CHAR( CxModList::OnChar )
     EVT_LIST_ITEM_SELECTED(-1, CxModList::ItemSelected )
     EVT_LIST_ITEM_DESELECTED(-1, CxModList::ItemDeselected )
     EVT_LIST_ITEM_RIGHT_CLICK(-1, CxModList::RightClick )
     EVT_LIST_COL_CLICK(-1, CxModList::HeaderClicked )
END_EVENT_TABLE()


void CxModList::Focus()
{
    SetFocus();
}

CXONCHAR(CxModList)


void CxModList::StartUpdate() {
}

void CxModList::EndUpdate() {
}


void CxModList::AddRow(int id, vector<string> & rowOfStrings, bool selected,
                               bool disabled)
{
//	ostringstream oo;
//	oo << "Adding row id " << id << " " << rowOfStrings[0] << " " <<  rowOfStrings[1] << " " << rowOfStrings[2];
//	LOGERR(oo.str());

    if ( id <= (int)IDlist.size() )
    {
//Find ID in existing list.
      for ( int i=0; i<(int)IDlist.size(); i++ )
      {
        if ( IDlist[i] == id )
        {
//			ostringstream oo;
//			oo << "Replacing row " << i << " with id " << id << " " << rowOfStrings[0] << " " <<  rowOfStrings[1] << " " << rowOfStrings[2];
//			LOGERR(oo.str());

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

            return;
        }
      }
    }


// A new item. Extend id list.

//    IDlist.push_back(IDlist.size()+1);
    IDlist.push_back(id);

    int nItem = InsertItem(IDlist.size()-1, _T(""));
    for (int j = 0; j < m_numcols; j++)
    {
        SetItem( nItem, j, rowOfStrings[j].c_str());
        int width,h;
        GetTextExtent(rowOfStrings[j].c_str(),&width,&h);
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
       m_ProgSelecting = 2;

	   SetItemState(nItem, wxLIST_STATE_SELECTED, wxLIST_STATE_SELECTED);
       m_ProgSelecting = 0;
    } else {
       m_ProgSelecting = 2;
       SetItemState(nItem, 0, wxLIST_STATE_SELECTED);
       m_ProgSelecting = 0;
    }

    return;
}








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



string CxModList::GetCell(int row, int col)
{
 return string("Unimplemented");
}
string CxModList::GetListItem(int item)
{
 return string("unimplemented");
}



int CxModList::GetNumberSelected()
{
  return -1;
}


void CxModList::GetSelectedIndices(  int * values )
{
  return;
}

void CxModList::Update(int newsize) 
{
//  LOGERR ( "Model changed" );
// Fetch new atom info from ModelDoc.

       if (newsize != IDlist.size())
       {
//          ostringstream oo;
//          oo << "New size: " << newsize << " old list " << IDlist.size();
//          LOGERR(oo.str());
          DeleteAllItems();
          IDlist.clear();
       }

//       m_listboxparent->LockWindowUpdate();

       ((CrModList*)ptr_to_crObject)->DocToList();
       Refresh();

}



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


void CxModList::CxEnsureVisible(CcModelObject* va)
{
//Find atom id in list
       int id;
       for ( id = 0; id < (int)IDlist.size(); id++ )
       {
          if ( IDlist[id] == va->id ) break;
       }
       if ( id == IDlist.size() ) return; // Ran off end
       EnsureVisible(id); //Call library function to ensure it is shown.
}
