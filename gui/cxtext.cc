////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
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


int CxText::mTextCount = kTextBase;
CxText *    CxText::CreateCxText( CrText * container, CxGrid * guiParent )
{
    CxText  *theText = new CxText( container );
#ifdef __CR_WIN__
    theText->Create("Text", SS_LEFTNOWORDWRAP| WS_CHILD| WS_VISIBLE, CRect(0,0,20,20), guiParent);
    theText->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
    theText->Create(guiParent, -1, "text");
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
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}


void    CxText::SetText( const string & text )
{
#ifdef __BOTHWX__
    SetLabel(text.c_str());
    SetSize(GetLeft(),GetTop(),GetIdealWidth(),GetHeight());
    Refresh();
#endif
#ifdef __CR_WIN__
    SetWindowText(text.c_str());
//    MoveWindow(GetLeft(),GetTop(),GetIdealWidth(),GetHeight(),true); //Naughty but harmless.
#endif

}

CXSETGEOMETRY(CxText)

CXGETGEOMETRIES(CxText)



int CxText::GetIdealWidth()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    return ( size.cx );
#endif
#ifdef __BOTHWX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return cx;
#endif

}

int CxText::GetIdealHeight()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    return ( size.cy );
#endif
#ifdef __BOTHWX__
      return GetCharHeight();
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
