////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CxProgress.cc
//   Authors:   Richard Cooper
//   Created:   05.11.1998 14:24 Uhr
//   Modified:  05.11.1998 14:25 Uhr

#include	"CrystalsInterface.h"
#include	"CxProgress.h"
#include	"CxGrid.h"
#include	"CrProgress.h"

int	CxProgress::mProgressCount = kProgressBase;
CxProgress *	CxProgress::CreateCxProgress( CrProgress * container, CxGrid * guiParent )
{
	CxProgress	*theProgress = new CxProgress( container );
	theProgress->Create( WS_CHILD|WS_VISIBLE,CRect(0,0,20,20),guiParent,mProgressCount++);
	theProgress->SetFont(CxGrid::mp_font);
	return theProgress;
}
CxProgress::CxProgress( CrProgress * container )
	:CProgressCtrl()
{
	mWidget = container;
	mCharsWidth = 10;
	m_TextOverlay = nil;
}

CxProgress::~CxProgress()
{
	RemoveProgress();
	if(m_TextOverlay != nil)
		delete m_TextOverlay;
}
void	CxProgress::SetText( char * text )
{
// We have to be a bit clever here:
// Every time we're told to set the text we check if m_textoverlay is present
// If not: create one and set its text; if so: set its text.
// Every time we're told to set the progress, we destroy to textoverlay. Simple.	
	if(m_TextOverlay == nil)
	{
		m_TextOverlay = new CStatic();
		CRect rectangle;
		GetClientRect(&rectangle);
		m_TextOverlay->Create( text, WS_VISIBLE|WS_CHILD, rectangle, this, 54999) ;
		m_TextOverlay->SetFont(CxGrid::mp_font);
	}
	else
		m_TextOverlay->SetWindowText(text);
	
}
void	CxProgress::SetGeometry( int top, int left, int bottom, int right )
{
	MoveWindow(left,top,right-left,bottom-top,true);
	if(m_TextOverlay != nil)
	{
		CRect rectangle;
		GetClientRect(&rectangle);
		m_TextOverlay->MoveWindow(rectangle) ;
	}
}
int	CxProgress::GetTop()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.top -= parentRect.top;
	}
	return ( windowRect.top );
}
int	CxProgress::GetLeft()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.left -= parentRect.left;
	}
	return ( windowRect.left );
}

int	CxProgress::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}

int	CxProgress::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

int	CxProgress::GetIdealWidth()
{
	CClientDC cdc(this);	//Get the device context for this window (edit box).
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font); //Select the standard font into the device context, save the old one for later.
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);   //Get the metrics for this font.
	cdc.SelectObject(oldFont);         //Select the old font back into the DC.
	return mCharsWidth * textMetric.tmAveCharWidth;  //Work out the ideal width.
}

int	CxProgress::GetIdealHeight()
{
	CString text;
	SIZE size;
	CClientDC dc(this);
	CFont* oldFont = dc.SelectObject(CxGrid::mp_font);
	GetWindowText(text);
	size = dc.GetOutputTextExtent("ql");
	dc.SelectObject(oldFont);
	return ( size.cy + 5);
}
int	CxProgress::AddProgress()
{
	mProgressCount++;
	return mProgressCount;
}
void	CxProgress::RemoveProgress()
{
	mProgressCount--;
}
void	CxProgress::SetVisibleChars( int count )
{
	mCharsWidth = count;
}

void CxProgress::SetProgress(int complete)
{
	if(m_TextOverlay != nil)
	{		
		delete m_TextOverlay;
		m_TextOverlay = nil;
	}

	SetPos ( complete );
}
