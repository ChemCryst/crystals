////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CxIcon.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 9:47 Uhr


#include	"crystalsinterface.h"
#include    "crconstants.h" //unusual, but used for kTIcon<Type>.
#include    "cxicon.h"
#include	"cxgrid.h"
#include    "cricon.h"

#define kIconBase 56000

int   CxIcon::mTextCount = kIconBase;
CxIcon *    CxIcon::CreateCxIcon( CrIcon * container, CxGrid * guiParent )
{

      CxIcon      *theText = new CxIcon( container );

#ifdef __WINDOWS__
      theText->Create(NULL, SS_ICON|WS_CHILD|WS_VISIBLE,CRect(0,0,20,20),guiParent);
	theText->SetFont(CxGrid::mp_font);
#endif
#ifdef __LINUX__
      theText->Create(guiParent, -1, "text");
#endif
      return theText;
}

CxIcon::CxIcon( CrIcon * container )
      :BASETEXT()
{
	mWidget = container;
	mCharsWidth = 0;
}

CxIcon::~CxIcon()
{
	RemoveText();
}

void  CxIcon::SetText( char * text )
{
#ifdef __LINUX__
      SetLabel(text);
#endif
#ifdef __WINDOWS__
	SetWindowText(text);
#endif

}

void  CxIcon::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
	MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}
int   CxIcon::GetTop()
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
int   CxIcon::GetLeft()
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
int   CxIcon::GetWidth()
{
#ifdef __WINDOWS__
      return GetSystemMetrics(SM_CXICON);
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxIcon::GetHeight()
{
#ifdef __WINDOWS__
      return GetSystemMetrics(SM_CYICON);
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


int   CxIcon::GetIdealWidth()
{
#ifdef __WINDOWS__
      return GetSystemMetrics(SM_CXICON);
#endif
#ifdef __LINUX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return cx; 
#endif

}

int   CxIcon::GetIdealHeight()
{
#ifdef __WINDOWS__
      return GetSystemMetrics(SM_CYICON);
#endif
#ifdef __LINUX__
      return GetCharHeight();
#endif
}

int   CxIcon::AddText()
{
	mTextCount++;
	return mTextCount;
}

void  CxIcon::RemoveText()
{
	mTextCount--;
}

void  CxIcon::SetVisibleChars( int count )
{
	mCharsWidth = count;
}


void CxIcon::SetIconType( int iIconId )
{
#ifdef __WINDOWS__
      HICON icon;
      switch ( iIconId )
      {
            case kTIconInfo:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_ASTERISK )) ;
                 break;
            case kTIconWarn:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_EXCLAMATION )) ;
                 break;
            case kTIconError:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_HAND )) ;
                 break;
            case kTIconQuery:
            default:
                 icon = ::LoadIcon(NULL, MAKEINTRESOURCE ( IDI_QUESTION )) ;
                 break;
      }

      SetIcon ( icon );
#endif


}
