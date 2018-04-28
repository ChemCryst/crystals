////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.12  2012/03/26 11:37:55  rich
//   Better sizing.
//
//   Revision 1.11  2011/04/15 15:03:23  rich
//   Fix text height
//
//   Revision 1.10  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.9  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.8  2001/06/17 14:29:33  richard
//   Destroy window function. Fix resize bug in wx version.
//
//   Revision 1.7  2001/03/08 16:44:11  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//


#include    "crystalsinterface.h"
#include    "cxtext.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    <string>
using namespace std;
#include    "crtext.h"
#include    "mathsymbols.h"


int CxText::mTextCount = kTextBase;
CxText *    CxText::CreateCxText( CrText * container, CxGrid * guiParent )
{
    CxText  *theText = new CxText( container );
#ifdef CRY_USEMFC
    theText->Create("Text", SS_LEFTNOWORDWRAP| WS_CHILD| WS_VISIBLE, CRect(0,0,20,20), guiParent);
    theText->SetFont(CcController::mp_font);
#endif
#ifdef CRY_USEWX
    theText->Create(guiParent, -1, "text", wxPoint(0,0),wxSize(0,0), wxWANTS_CHARS); // wxTRANSPARENT_WINDOW);
#endif
    return theText;
}

CxText::CxText( CrText * container )
      :BASETEXT()
{
    ptr_to_crObject = container;
    mCharsWidth = 0;
}

CxText::~CxText()
{
    RemoveText();
}

void CxText::CxDestroyWindow()
{
#ifdef CRY_USEMFC
DestroyWindow();
#endif
#ifdef CRY_USEWX
Destroy();
#endif
}


void    CxText::SetText( const string & text )
{
#ifdef CRY_USEWX
    wxString wtext = wxString(text.c_str());
    MathSymbols::replaceMarkup(wtext);
    SetLabel(wtext);
    SetSize(GetIdealWidth(),GetHeight());
    Refresh();
#endif
#ifdef CRY_USEMFC
    SetWindowText(text.c_str());
//    MoveWindow(GetLeft(),GetTop(),GetIdealWidth(),GetHeight(),true); //Naughty but harmless.
#endif

}

#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxText, CStatic)
   ON_WM_CHAR()
END_MESSAGE_MAP()
#else
//wx Message Map
BEGIN_EVENT_TABLE(CxText, wxStaticText)
      EVT_CHAR(CxText::OnChar)
END_EVENT_TABLE()
#endif

CXONCHAR(CxText)

CXSETGEOMETRY(CxText)

CXGETGEOMETRIES(CxText)



int CxText::GetIdealWidth()
{
#ifdef CRY_USEMFC
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    return ( size.cx );
#endif
#ifdef CRY_USEWX
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return cx + 8;
#endif

}

int CxText::GetIdealHeight()
{
#ifdef CRY_USEMFC
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    return ( size.cy );
#endif
#ifdef CRY_USEWX
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cy+5); // nice height for static text
#endif
}

int CxText::AddText()
{
    mTextCount++;
    return mTextCount;
}

void    CxText::RemoveText()
{
    mTextCount--;
}

void    CxText::SetVisibleChars( int count )
{
    mCharsWidth = count;
}
