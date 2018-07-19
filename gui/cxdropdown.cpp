////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxDropDown
////////////////////////////////////////////////////////////////////////
//   Filename:  CxDropDown.cc
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
// Revision 1.19  2004/06/24 09:12:01  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.18  2003/11/28 10:29:11  rich
// Replace min and max macros with CRMIN and CRMAX. These names are
// less likely to confuse gcc.
//
// Revision 1.17  2003/06/19 16:40:30  rich
// Allow DropDown listboxes to be disabled from SCRIPT.
//
// Increase minimum height of dropdown listbox on Windows, as
// it wasn't quite high enough.
//
// Revision 1.16  2003/01/14 10:27:18  rich
// Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
// Revision 1.15  2002/07/25 16:00:13  richard
//
// Resize dropdown listbox if number of items changes.
//
// Revision 1.14  2002/07/18 16:51:49  richard
// For LISTTEXT queries, use 1-based indexing as for CrListbox objects. Also
// catch and limit unacceptable values for LISTTEXT argument.
//
// Revision 1.13  2001/06/18 12:47:26  richard
// *** empty log message ***
//
// Revision 1.12  2001/06/17 14:44:39  richard
// CxDestroyWindow function.
//
// Revision 1.11  2001/03/08 16:44:08  richard
// General changes - replaced common functions in all GUI classes by macros.
// Generally tidied up, added logs to top of all source files.
//
// Revision 1.10  2001/01/16 15:35:02  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.9  2000/12/13 18:11:34  richard
// Linux support. Changed SetSelection to CxSetSelection to avoid name clash.
//
// Revision 1.6  2000/07/04 14:41:54  ckp2
// Gui changes since last year.
// Mainly chart handling for multiple charts in one window.
// Some Cx files only changed to split long lines to make inclusion
// into "the thesis" more automatic.
// New GUIMENU.SSR has more "right-click" options and swapped panes for model
// and text output.
//
// Revision 1.5  1999/06/22 13:14:12  dosuser
// RIC: Moved the calls in SetGeometry round a bit.
//
// Revision 1.4  1999/05/28 17:59:56  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.3  1999/04/28 13:59:06  dosuser
// RIC: Added support for SetSelection to DropDown so that the SCRIPT
//      writer can choose which item is selected.
//

#include    "crystalsinterface.h"
#include    <string>
using namespace std;
#include    "cxdropdown.h"
#include    "cccontroller.h"
#include    "cxgrid.h"
#include    "crdropdown.h"

#ifdef CRY_USEWX
#include <wx/settings.h>
#endif

int CxDropDown::mDropDownCount = kDropDownBase;
CxDropDown *    CxDropDown::CreateCxDropDown( CrDropDown * container, CxGrid * guiParent )
{
    CxDropDown* theDropDown = new CxDropDown ( container);
#ifdef CRY_USEMFC
        theDropDown->Create(CBS_DROPDOWNLIST |WS_CHILD |WS_VISIBLE, CRect(0,0,10,10), guiParent, mDropDownCount++);
    theDropDown->SetFont(CcController::mp_font);
#else

      wxArrayString a;
      theDropDown->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10),a);
#endif
    return theDropDown;
}

CxDropDown::CxDropDown( CrDropDown * container)
            :BASEDROPDOWN()
{
    ptr_to_crObject = container;
    mItems = 0;

}

CxDropDown::~CxDropDown()
{
    mDropDownCount--;
}

void CxDropDown::CxDestroyWindow()
{
#ifdef CRY_USEMFC
DestroyWindow();
#else

Destroy();
#endif
}

void CxDropDown::CxSetSelection(int select)
{
#ifdef CRY_USEMFC
      SetCurSel ( select - 1 );
#else

      SetSelection ( select -1 );
#endif
}

void CxDropDown::CxRemoveItem ( int item )
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
#endif
}


#ifdef CRY_USEMFC
void    CxDropDown::Selected()
{
    ((CrDropDown *)ptr_to_crObject)->Selected( GetCurSel() + 1 );
#else

void    CxDropDown::Selected(wxCommandEvent & e)
{
      ((CrDropDown *)ptr_to_crObject)->Selected( GetSelection() + 1 );
#endif
}

void    CxDropDown::AddItem( const string & text )
{
#ifdef CRY_USEMFC
    AddString(text.c_str() );
#else

    Append ( text.c_str() );
#endif
    if( !mItems ) CxSetSelection(1);
    mItems++;
}

void    CxDropDown::SetGeometry( const int top, const int left, const int bottom, const int right )
{
#ifdef CRY_USEMFC
    SetItemHeight(-1, bottom-top); //The closed up height is set by this call, MoveWindow sets the dropped height.
    MoveWindow(left,top,right-left,GetDroppedHeight(),true);
#else
    SetSize(left,top,right-left,bottom-top);
#endif
}

void CxDropDown::ResetHeight()
{
#ifdef CRY_USEMFC
  CRect wR; GetWindowRect(&wR);
  SetWindowPos( &wndTop, 0,0, wR.Width(), GetDroppedHeight(), SWP_NOMOVE );
#endif
}

int   CxDropDown::GetTop()
{
#ifdef CRY_USEMFC
  RECT windowRect; GetWindowRect(&windowRect); return ( windowRect.top );
#else
  return ( GetRect().y );
#endif
}
int   CxDropDown::GetLeft()
{
#ifdef CRY_USEMFC
  RECT windowRect; GetWindowRect(&windowRect); return ( windowRect.left );
#else
  return ( GetRect().x );
#endif
}
int   CxDropDown::GetWidth()
{
#ifdef CRY_USEMFC
  CRect windowRect; GetWindowRect(&windowRect); return ( windowRect.Width() );
#else
  return ( GetRect().GetWidth() );
#endif
}
int   CxDropDown::GetHeight()
{
#ifdef CRY_USEMFC
  return GetItemHeight(-1);
#else
// May need to base this on font size if it returns the dropped
// list height rather than the closed list height.
  return ( GetRect().GetHeight() );
#endif
}

int CxDropDown::GetIdealWidth()
{
    int maxSiz = 10; //At least you can see it if it's empty!

#ifdef CRY_USEMFC
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);

    for ( int i=0;i<mItems;i++ )
    {
        GetLBText(i, text);
        size = dc.GetOutputTextExtent(text);
        maxSiz = CRMAX ( maxSiz, size.cx );
    }
    dc.SelectObject(oldFont);
    return ( maxSiz + (2 * GetSystemMetrics(SM_CXVSCROLL) ));
#else
    wxString text;
    int cx,cy;
    for ( int i=0;i<mItems;i++ )
    {
        GetTextExtent( GetString(i), &cx, &cy );
        maxSiz = CRMAX (maxSiz, cx);
    }
    return ( maxSiz + (3 * wxSystemSettings::GetMetric(wxSYS_VSCROLL_X ) ) ); 
#endif
}


int CxDropDown::GetIdealHeight()
{
#ifdef CRY_USEMFC
    return CRMAX ( GetItemHeight(-1) + 2, GetSystemMetrics(SM_CYVSCROLL) + 2 ) ;
#else
// May need to base this on font size if it returns the dropped
// list height rather than the closed list height.
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return (cy+10); // nice height for closed list boxes.
#endif

}

int CxDropDown::GetDroppedHeight()
{
#ifdef CRY_USEMFC
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
        return (mItems+3) * ( textMetric.tmHeight + 4 );
#else
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return (cy+5); // nice height for closed list boxes.
#endif

}

int CxDropDown::GetDropDownValue()
{
#ifdef CRY_USEMFC
    return ( GetCurSel() + 1 );
#else
      return ( GetSelection() + 1 );
#endif
}

#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxDropDown, BASEDROPDOWN)
    ON_WM_CHAR()
    ON_CONTROL_REFLECT(CBN_SELCHANGE, Selected)
END_MESSAGE_MAP()
#else

//wx Message Map
BEGIN_EVENT_TABLE(CxDropDown, BASEDROPDOWN)
      EVT_CHOICE( -1, CxDropDown::Selected )
      EVT_CHAR( CxDropDown::OnChar )
END_EVENT_TABLE()
#endif


CXONCHAR(CxDropDown)

void CxDropDown::Focus()
{
    SetFocus();
}

string CxDropDown::GetDropDownText(int index)
{
   index = CRMIN ( index, mItems );
   index = CRMAX ( index, 1 );
#ifdef CRY_USEMFC
    CString temp;
    GetLBText(index-1,temp);
    string result = temp.GetBuffer(temp.GetLength());
    return result;
#else
      wxString temp = GetString( index-1 );
      string result ( temp.c_str() );
    return result;
#endif
}

void CxDropDown::Disable(bool disable)
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
