////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 9:47 Uhr


#include    "crystalsinterface.h"
#include    "cxtext.h"
#include    "cxgrid.h"
#include    "crtext.h"


int CxText::mTextCount = kTextBase;
CxText *    CxText::CreateCxText( CrText * container, CxGrid * guiParent )
{
    CxText  *theText = new CxText( container );
#ifdef __CR_WIN__
      theText->Create("Text", SS_LEFTNOWORDWRAP| WS_CHILD| WS_VISIBLE, CRect(0,0,20,20), guiParent);
    theText->SetFont(CxGrid::mp_font);
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

void    CxText::SetText( char * text )
{
#ifdef __BOTHWX__
      SetLabel(text);
#endif
#ifdef __CR_WIN__
    SetWindowText(text);
#endif

}

void  CxText::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
    MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
#endif

}
int   CxText::GetTop()
{
#ifdef __CR_WIN__
      RECT windowRect, parentRect;
    GetWindowRect(&windowRect);
    CWnd* parent = GetParent();
    if(parent != nil)
    {
        parent->GetWindowRect(&parentRect);
        windowRect.top -= parentRect.top;
    }
    return ( windowRect.top );
#endif
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
//  if(parent != nil)
//  {
//            parentRect = parent->GetRect();
//            windowRect.y -= parentRect.y;
//  }
      return ( windowRect.y );
#endif
}
int   CxText::GetLeft()
{
#ifdef __CR_WIN__
      RECT windowRect, parentRect;
    GetWindowRect(&windowRect);
    CWnd* parent = GetParent();
    if(parent != nil)
    {
        parent->GetWindowRect(&parentRect);
        windowRect.left -= parentRect.left;
    }
    return ( windowRect.left );
#endif
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
//  if(parent != nil)
//  {
//            parentRect = parent->GetRect();
//            windowRect.x -= parentRect.x;
//  }
      return ( windowRect.x );
#endif

}
int   CxText::GetWidth()
{
#ifdef __CR_WIN__
    CRect windowRect;
    GetWindowRect(&windowRect);
    return ( windowRect.Width() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxText::GetHeight()
{
#ifdef __CR_WIN__
    CRect windowRect;
    GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


int CxText::GetIdealWidth()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CxGrid::mp_font);
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
    HDC hdc= (HDC) (GetDC()->m_hAttribDC);
    GetWindowText(text);
    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
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
