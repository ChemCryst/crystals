////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxListBox
////////////////////////////////////////////////////////////////////////
//   Filename:  CxListBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
// $Log: not supported by cvs2svn $
// Revision 1.8  2001/01/16 15:35:03  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.7  2000/12/13 18:17:12  richard
// Linux support. SetSelection has become CxSetSelection to avoid name clash.
//
// Revision 1.6  2000/07/04 14:42:01  ckp2
// Gui changes since last year.
// Mainly chart handling for multiple charts in one window.
// Some Cx files only changed to split long lines to make inclusion
// into "the thesis" more automatic.
// New GUIMENU.SSR has more "right-click" options and swapped panes for model
// and text output.
//
// Revision 1.5  1999/05/28 18:00:29  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.4  1999/04/26 13:14:32  dosuser
// RIC: Added void SetSelection ( int select ) function.
//

#include    "crystalsinterface.h"
#include    "cxlistbox.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "cxwindow.h"
#include    "crlistbox.h"

#ifdef __BOTHWX__
#include <wx/settings.h>
#endif

int CxListBox::mListBoxCount = kListBoxBase;


CxListBox * CxListBox::CreateCxListBox( CrListBox * container, CxGrid * guiParent )
{
    CxListBox   *theListBox = new CxListBox( container );
#ifdef __CR_WIN__
        theListBox->Create(WS_CHILD| WS_VISIBLE| LBS_NOTIFY| LBS_HASSTRINGS| WS_VSCROLL, CRect(0,0,5,5), guiParent, mListBoxCount++);
    theListBox->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
    theListBox->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
      theListBox->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10),0,NULL,wxLB_SINGLE|wxLB_NEEDED_SB);
#endif
    return theListBox;

}

CxListBox::CxListBox( CrListBox * container )
      : BASELISTBOX()
{
    ptr_to_crObject = container;
    mItems = 0;
    mVisibleLines = 0;
}

CxListBox::~CxListBox()
{
    RemoveListBox();
}

void    CxListBox::DoubleClicked()
{
#ifdef __CR_WIN__
            int itemIndex = GetCurSel();
#endif
#ifdef __BOTHWX__
            int itemIndex = GetSelection();
#endif
            ((CrListBox *)ptr_to_crObject)->Committed( itemIndex + 1 );
}

void    CxListBox::Selected()
{
#ifdef __CR_WIN__
            int itemIndex = GetCurSel();
#endif
#ifdef __BOTHWX__
            int itemIndex = GetSelection();
#endif
        ((CrListBox *)ptr_to_crObject)->Selected( itemIndex + 1 );
}

void    CxListBox::AddItem( char * text )
{
#ifdef __POWERPC__
    ListHandle  macListH;
    Cell    theCell = {0, 0};
    macListH = GetMacListH();                   // Get control handle
    LAddRow(1, mItems, macListH);               // Add a row
    mItems++;
    theCell.v = mItems -1;                      // Set cell
    LSetCell( text, strlen( text ), theCell, macListH);
#endif
#ifdef __BOTHWX__
      Append (text);
      if( !mItems ) SetSelection(0);
    mItems++;
#endif
#ifdef __CR_WIN__
    AddString(text);
    if( !mItems ) SetCurSel(0);
    mItems++;
#endif

}

void    CxListBox::SetVisibleLines( int lines )
{
    mVisibleLines = lines;
}

CXSETGEOMETRY(CxListBox)

CXGETGEOMETRIES(CxListBox)



int CxListBox::GetIdealWidth()
{
    int maxSiz = 10; //At least you can see it if it's empty!
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);

    for ( int i=0;i<mItems;i++ )
    {
        GetText(i, text);
        size = dc.GetOutputTextExtent(text);
        maxSiz = max ( maxSiz, size.cx );
    }
    dc.SelectObject(oldFont);
    if(mItems > mVisibleLines) maxSiz += GetSystemMetrics(SM_CXVSCROLL);
    return ( maxSiz + 10 );
#endif
#ifdef __BOTHWX__
    for ( int i=0;i<mItems;i++ )
    {
            int cx,cy;
            GetTextExtent( GetString(i), &cx, &cy );
            if ( maxSiz < cx )  maxSiz = cx;
    }

    if(mItems > mVisibleLines)
      {
            wxSystemSettings ss;
            maxSiz += ss.GetSystemMetric(wxSYS_VSCROLL_X);
      }

#endif

    return ( maxSiz + 10 ); //10 pixels spare

}

int CxListBox::GetIdealHeight()
{
#ifdef __CR_WIN__
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    return mVisibleLines * ( textMetric.tmHeight + 2 );
#endif
#ifdef __BOTHWX__
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return mVisibleLines * ( cy + 2 );
#endif

}

int CxListBox::GetBoxValue()
{

#ifdef __CR_WIN__
      return ( GetCurSel() + 1 );
#endif
#ifdef __BOTHWX__
      return ( GetSelection() + 1 );
#endif

}

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxListBox, CListBox)
    ON_CONTROL_REFLECT(LBN_DBLCLK, DoubleClicked)
    ON_CONTROL_REFLECT(LBN_SELCHANGE, Selected)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Map
BEGIN_EVENT_TABLE(CxListBox, BASELISTBOX)
      EVT_LISTBOX_DCLICK(-1, CxListBox::DoubleClicked )
      EVT_LISTBOX(-1, CxListBox::Selected )
      EVT_CHAR( CxListBox::OnChar )
END_EVENT_TABLE()
#endif

void CxListBox::Focus()
{
    SetFocus();
}

CXONCHAR(CxListBox)


void CxListBox::CxSetSelection( int select )
{
#ifdef __CR_WIN__
    SetCurSel ( select - 1 );
#endif
#ifdef __BOTHWX__
    SetSelection ( select - 1 );
#endif

}

CcString CxListBox::GetListBoxText(int index)
{
#ifdef __CR_WIN__
    CString temp;
      GetText(index-1, temp);
    CcString result = temp.GetBuffer(temp.GetLength());
    return result;
#endif
#ifdef __BOTHWX__
      wxString temp = GetString( index -1 );
      CcString result ( temp.c_str() );
    return result;
#endif

}
