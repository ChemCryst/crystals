////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 9:47 Uhr


#include	"crystalsinterface.h"
#include	"cxtext.h"
#include	"cxgrid.h"
#include	"crtext.h"


int	CxText::mTextCount = kTextBase;
CxText *	CxText::CreateCxText( CrText * container, CxGrid * guiParent )
{
	CxText	*theText = new CxText( container );
#ifdef __WINDOWS__
      theText->Create("Text", SS_LEFTNOWORDWRAP| WS_CHILD| WS_VISIBLE, CRect(0,0,20,20), guiParent);
	theText->SetFont(CxGrid::mp_font);
#endif
#ifdef __LINUX__
      theText->Create(guiParent, -1, "text");
#endif
      return theText;
}

CxText::CxText( CrText * container )
      :BASETEXT()
{
	mWidget = container;
	mCharsWidth = 0;
}

CxText::~CxText()
{
	RemoveText();
}

void	CxText::SetText( char * text )
{
#ifdef __LINUX__
      SetLabel(text);
#endif
#ifdef __WINDOWS__
	SetWindowText(text);
#endif

}

void  CxText::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
	MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}
int   CxText::GetTop()
{
#ifdef __WINDOWS__
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
#ifdef __LINUX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
	if(parent != nil)
	{
            parentRect = parent->GetRect();
            windowRect.y -= parentRect.y;
	}
      return ( windowRect.y );
#endif
}
int   CxText::GetLeft()
{
#ifdef __WINDOWS__
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
#ifdef __LINUX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
	if(parent != nil)
	{
            parentRect = parent->GetRect();
            windowRect.x -= parentRect.x;
	}
      return ( windowRect.x );
#endif

}
int   CxText::GetWidth()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxText::GetHeight()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


int	CxText::GetIdealWidth()
{
#ifdef __WINDOWS__
	CString text;
	SIZE size;
	CClientDC dc(this);
	CFont* oldFont = dc.SelectObject(CxGrid::mp_font);
	GetWindowText(text);
	size = dc.GetOutputTextExtent(text);
	dc.SelectObject(oldFont);
	return ( size.cx );
#endif
#ifdef __LINUX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return cx; 
#endif

}

int	CxText::GetIdealHeight()
{
#ifdef __WINDOWS__
	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	GetWindowText(text);
	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
	return ( size.cy );
#endif
#ifdef __LINUX__
      return GetCharHeight();
#endif
}

int	CxText::AddText()
{
	mTextCount++;
	return mTextCount;
}

void	CxText::RemoveText()
{
	mTextCount--;
}

void	CxText::SetVisibleChars( int count )
{
	mCharsWidth = count;
}
