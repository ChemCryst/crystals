////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxDropDown
////////////////////////////////////////////////////////////////////////
//   Filename:  CxDropDown.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
// $Log: not supported by cvs2svn $
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
#include    "ccstring.h"
#include    "cxdropdown.h"
#include    "cccontroller.h"
#include    "cxgrid.h"
#include    "crdropdown.h"

#ifdef __BOTHWX__
#include <wx/settings.h>
#endif

int CxDropDown::mDropDownCount = kDropDownBase;
CxDropDown *    CxDropDown::CreateCxDropDown( CrDropDown * container, CxGrid * guiParent )
{
    CxDropDown* theDropDown = new CxDropDown ( container);
#ifdef __CR_WIN__
        theDropDown->Create(CBS_DROPDOWNLIST |WS_CHILD |WS_VISIBLE, CRect(0,0,10,10), guiParent, mDropDownCount++);
    theDropDown->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
      theDropDown->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10),0,NULL);
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
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}

void CxDropDown::CxSetSelection(int select)
{
#ifdef __CR_WIN__
      SetCurSel ( select - 1 );
#endif
#ifdef __BOTHWX__
      SetSelection ( select -1 );
#endif
}

void CxDropDown::CxRemoveItem ( int item )
{
#ifdef __CR_WIN__
    if ( item > 0 )
    {
       DeleteString ( item - 1 );
       mItems = max(0,mItems-1);
    }
    else
    {
       ResetContent();
       mItems=0;
    }
#endif
}


void    CxDropDown::Selected()
{
#ifdef __CR_WIN__
    ((CrDropDown *)ptr_to_crObject)->Selected( GetCurSel() + 1 );
#endif
#ifdef __BOTHWX__
      ((CrDropDown *)ptr_to_crObject)->Selected( GetSelection() + 1 );
#endif
}

void    CxDropDown::AddItem( char * text )
{
#ifdef __BOTHWX__
    Append ( text );
#endif
#ifdef __CR_WIN__
    AddString(text);
#endif
    if( !mItems ) CxSetSelection(1);
    mItems++;
}

void    CxDropDown::SetGeometry( const int top, const int left, const int bottom, const int right )
{
#ifdef __CR_WIN__
    SetItemHeight(-1, bottom-top); //The closed up height is set by this call, MoveWindow sets the dropped height.
    MoveWindow(left,top,right-left,GetDroppedHeight(),true);
#endif
#ifdef __BOTHWX__
    SetSize(left,top,right-left,bottom-top);
#endif
}

void CxDropDown::ResetHeight()
{
#ifdef __CR_WIN__
  CRect wR; GetWindowRect(&wR);
  SetWindowPos( &wndTop, 0,0, wR.Width(), GetDroppedHeight(), SWP_NOMOVE );
#endif
}

int   CxDropDown::GetTop()
{
#ifdef __CR_WIN__
  RECT windowRect; GetWindowRect(&windowRect); return ( windowRect.top );
#endif
#ifdef __BOTHWX__
  return ( GetRect().y );
#endif
}
int   CxDropDown::GetLeft()
{
#ifdef __CR_WIN__
  RECT windowRect; GetWindowRect(&windowRect); return ( windowRect.left );
#endif
#ifdef __BOTHWX__
  return ( GetRect().x );
#endif
}
int   CxDropDown::GetWidth()
{
#ifdef __CR_WIN__
  CRect windowRect; GetWindowRect(&windowRect); return ( windowRect.Width() );
#endif
#ifdef __BOTHWX__
  return ( GetRect().GetWidth() );
#endif
}
int   CxDropDown::GetHeight()
{
#ifdef __CR_WIN__
  return GetItemHeight(-1);
#endif
#ifdef __BOTHWX__
// May need to base this on font size if it returns the dropped
// list height rather than the closed list height.
  return ( GetRect().GetHeight() );
#endif
}

int CxDropDown::GetIdealWidth()
{
    int maxSiz = 10; //At least you can see it if it's empty!

#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);

    for ( int i=0;i<mItems;i++ )
    {
        GetLBText(i, text);
        size = dc.GetOutputTextExtent(text);
        maxSiz = max ( maxSiz, size.cx );
    }
    dc.SelectObject(oldFont);
    return ( maxSiz + (2 * GetSystemMetrics(SM_CXVSCROLL) ));
#endif
#ifdef __BOTHWX__
    wxString text;
    int cx,cy;
    for ( int i=0;i<mItems;i++ )
    {
        GetTextExtent( GetString(i), &cx, &cy );
        maxSiz = max (maxSiz, cx);
    }
    return ( maxSiz + (3 * wxSystemSettings::GetSystemMetric(wxSYS_VSCROLL_X ) ) ); 
#endif
}


int CxDropDown::GetIdealHeight()
{
#ifdef __CR_WIN__
    return GetItemHeight(-1);
#endif
#ifdef __BOTHWX__
// May need to base this on font size if it returns the dropped
// list height rather than the closed list height.
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return (cy+10); // nice height for closed list boxes.
#endif

}

int CxDropDown::GetDroppedHeight()
{
#ifdef __CR_WIN__
    CClientDC cdc(this);
    CFont* oldFont = cdc.SelectObject(CcController::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
        return (mItems+3) * ( textMetric.tmHeight + 4 );
#endif
#ifdef __BOTHWX__
      int cx,cy;
      GetTextExtent( "Any old string", &cx, &cy );
      return (cy+5); // nice height for closed list boxes.
#endif

}

int CxDropDown::GetDropDownValue()
{
#ifdef __CR_WIN__
    return ( GetCurSel() + 1 );
#endif
#ifdef __BOTHWX__
      return ( GetSelection() + 1 );
#endif
}

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxDropDown, BASEDROPDOWN)
    ON_WM_CHAR()
    ON_CONTROL_REFLECT(CBN_SELCHANGE, Selected)
END_MESSAGE_MAP()
#endif

#ifdef __BOTHWX__
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

CcString CxDropDown::GetDropDownText(int index)
{
   index = min ( index, mItems );
   index = max ( index, 1 );
#ifdef __CR_WIN__
    CString temp;
    GetLBText(index-1,temp);
    CcString result = temp.GetBuffer(temp.GetLength());
    return result;
#endif
#ifdef __BOTHWX__
      wxString temp = GetString( index-1 );
      CcString result ( temp.c_str() );
    return result;
#endif
}
