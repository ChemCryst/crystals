////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $


#include    "crystalsinterface.h"
#include    "cxtext.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "ccstring.h"
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

void    CxText::SetText( CcString text )
{
#ifdef __BOTHWX__
    SetLabel(text.ToCString());
    MoveWindow(GetTop(),GetLeft(),GetIdealWidth(),GetHeight(),true); //Naughty but harmless.
#endif
#ifdef __CR_WIN__
    SetWindowText(text.ToCString());
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
