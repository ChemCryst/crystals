////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxListBox
////////////////////////////////////////////////////////////////////////
//   Filename:  CxListBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
// $Log: not supported by cvs2svn $
// Revision 1.20  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.1.1.1  2004/12/13 11:16:18  rich
// New CRYSTALS repository
//
// Revision 1.19  2004/06/28 13:38:28  rich
// Implemented missing REMOVE feature.
//
// Revision 1.18  2004/06/24 09:12:01  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.17  2003/11/28 10:29:11  rich
// Replace min and max macros with CRMIN and CRMAX. These names are
// less likely to confuse gcc.
//
// Revision 1.16  2003/05/07 12:18:58  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.15  2002/12/05 15:57:47  rich
// Allow listbox selection to be set from end if selection number is negative.
// In structure undo dialog, start with last L5 highlighted.
//
// Revision 1.14  2002/07/18 16:57:52  richard
// Upgrade to use standard c++ library, rather than old C libraries.
//
// Revision 1.13  2002/03/05 12:12:58  ckp2
// Enhancements to listbox for my List 28 project.
//
// Revision 1.12  2001/09/11 08:31:10  ckp2
// Protect the program from invalid list index numbers being
// passed to a LISTTEXT query.
//
// Revision 1.11  2001/06/17 14:39:59  richard
// CxDestroyWindow function.
//
// Revision 1.10  2001/03/28 09:17:07  richard
// Code to allow you to disable the listbox.
//
// Revision 1.9  2001/03/08 16:44:09  richard
// General changes - replaced common functions in all GUI classes by macros.
// Generally tidied up, added logs to top of all source files.
//
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
#include    <string>
#include    <sstream>

#ifdef CRY_USEWX
#include <wx/settings.h>
#endif

int CxListBox::mListBoxCount = kListBoxBase;


CxListBox * CxListBox::CreateCxListBox( CrListBox * container, CxGrid * guiParent )
{
    CxListBox   *theListBox = new CxListBox( container );
#ifdef CRY_USEMFC
        theListBox->Create(WS_CHILD| WS_VISIBLE| LBS_NOTIFY| LBS_HASSTRINGS| WS_VSCROLL, CRect(0,0,5,5), guiParent, mListBoxCount++);
    theListBox->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
    theListBox->SetFont(CcController::mp_font);
#else
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

void CxListBox::CxDestroyWindow()
{
  #ifdef CRY_USEMFC
DestroyWindow();
#else
Destroy();
#endif
}

#ifdef CRY_USEMFC
void    CxListBox::DoubleClicked()
{
            int itemIndex = GetCurSel();
#else
void    CxListBox::DoubleClicked(wxCommandEvent & e)
{
            int itemIndex = GetSelection();
#endif
            ((CrListBox *)ptr_to_crObject)->Committed( itemIndex + 1 );
}

#ifdef CRY_USEMFC
void    CxListBox::Selected()
{
            int itemIndex = GetCurSel();
#else
void    CxListBox::Selected(wxCommandEvent & e)
{
            int itemIndex = GetSelection();
#endif
        ((CrListBox *)ptr_to_crObject)->Selected( itemIndex + 1 );
}

void    CxListBox::AddItem( const string &  text )
{
#ifdef CRY_USEMFC
    AddString(text.c_str());
    if( !mItems ) SetCurSel(0);
    mItems++;
#else
      Append (text.c_str());
      if( !mItems ) SetSelection(0);
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
#ifdef CRY_USEMFC
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);

    for ( int i=0;i<mItems;i++ )
    {
        GetText(i, text);
        size = dc.GetOutputTextExtent(text);
        maxSiz = CRMAX ( maxSiz, size.cx );
    }
    dc.SelectObject(oldFont);
    if(mItems > mVisibleLines) maxSiz += GetSystemMetrics(SM_CXVSCROLL);
    return ( maxSiz + 10 );
#else
    for ( int i=0;i<mItems;i++ )
    {
            int cx,cy;
            GetTextExtent( GetString(i), &cx, &cy );
            if ( maxSiz < cx )  maxSiz = cx;
    }

    if(mItems > mVisibleLines)
      {
            wxSystemSettings ss;
            maxSiz += ss.GetMetric(wxSYS_VSCROLL_X);
      }

#endif

    return ( maxSiz + 10 ); //10 pixels spare

}

int CxListBox::GetIdealHeight()
{
#ifdef CRY_USEMFC
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    return mVisibleLines * ( textMetric.tmHeight + 2 );
#else
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return mVisibleLines * ( cy + 2 );
#endif

}

int CxListBox::GetBoxValue()
{

#ifdef CRY_USEMFC
      return ( GetCurSel() + 1 );
#else
      return ( GetSelection() + 1 );
#endif

}

#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxListBox, CListBox)
    ON_CONTROL_REFLECT(LBN_DBLCLK, DoubleClicked)
    ON_CONTROL_REFLECT(LBN_SELCHANGE, Selected)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#else
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
   if ( mItems < 1 ) return;

   if ( select < 1 ) select = mItems+select+1;

   select = CRMIN ( select, mItems );
   select = CRMAX ( select, 1 );
#ifdef CRY_USEMFC
    SetCurSel ( select - 1 );
#else
    SetSelection ( select - 1 );
#endif

}

void CxListBox::CxRemoveItem ( int item )
{
#ifdef CRY_USEMFC
    if ( item > 0 )
    {
       DeleteString ( item - 1 );
       mItems = CRMAX(0,mItems-1);
    }
    else
    {
       ResetContent();
       mItems=0;
    }
#else
    if ( item > 0 )
    {
       Delete ( item - 1 );
       mItems = CRMAX(0,mItems-1);
    }
    else
    {
       Clear();
       mItems=0;
    }
#endif
}



string CxListBox::GetListBoxText(int index)
{
   if ( mItems < 1 ) return string(" ");
   index = CRMIN ( index, mItems );
   index = CRMAX ( index, 1 );
#ifdef CRY_USEMFC
    CString temp;
    GetText(index-1, temp);
    string result = temp.GetBuffer(temp.GetLength());
    return result;
#else
      wxString temp = GetString( index -1 );
      string result ( temp.c_str() );
    return result;
#endif

}

void CxListBox::Disable(bool disable)
{
#ifdef CRY_USEMFC
      if(disable)
            EnableWindow(false);
      else
            EnableWindow(true);
#else
      if(disable)
            Enable(false);
    else
            Enable(true);
#endif
}
