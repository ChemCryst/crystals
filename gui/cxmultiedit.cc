////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMultiEdit.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  25.2.1998 15:27 Uhr

#include	"crystalsinterface.h"
#include    "ccstring.h"
#include    "cclist.h"
#include    "cclink.h"


#include	"cxmultiedit.h"
#include	"cxgrid.h"
#include	"crmultiedit.h"
#include	"crgrid.h"

int CxMultiEdit::mMultiEditCount = kMultiEditBase;

CxMultiEdit * 	CxMultiEdit::CreateCxMultiEdit( CrMultiEdit * container, CxGrid * guiParent )
{
	CxMultiEdit *theMEdit = new CxMultiEdit (container);
#ifdef __WINDOWS__
        theMEdit->Create(ES_LEFT|ES_AUTOHSCROLL|ES_AUTOVSCROLL|WS_VSCROLL|WS_HSCROLL|WS_VISIBLE|WS_CHILD|ES_MULTILINE,CRect(0,0,10,10),guiParent,mMultiEditCount++);
	theMEdit->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theMEdit->SetFont(CxGrid::mp_font);
//      theMEdit->SetBackgroundColor(false,RGB(255,255,255));
	theMEdit->SetColour(0,0,0);
#endif
#ifdef __LINUX__
      theMEdit->Create(guiParent, -1, "EditBox", wxPoint(0,0), wxSize(10,10), wxTE_MULTILINE); 
#endif
	return theMEdit;
}

CxMultiEdit::CxMultiEdit( CrMultiEdit * container )
: BASEMULTIEDIT ()
{
	mWidget = container;
	mIdealHeight = 30;
	mIdealWidth  = 70;
}

CxMultiEdit::~CxMultiEdit()
{
	RemoveMultiEdit();
}

void  CxMultiEdit::SetText( CcString cText )
{
// Add the text.

#ifdef __WINDOWS__
      int oldend = GetWindowTextLength();
      SetSel( oldend, oldend );
      ReplaceSel(cText.ToCString());
#endif
#ifdef __LINUX__
      AppendText(cText.ToCString());
#endif

// Get CharHeight.
      int charheight;
      int ll;

#ifdef __WINDOWS__
      CClientDC cdc(this);
	TEXTMETRIC textMetric;
      CFont * oldFont = cdc.SelectObject(CxGrid::mp_font);
	cdc.GetTextMetrics(&textMetric);
      charheight = (textMetric.tmHeight + textMetric.tmExternalLeading);
      cdc.SelectObject(oldFont);

      CSize convert( 10, charheight );
      cdc.LPtoDP ( & convert );
      charheight = convert.cy;

      ll = GetLineCount();
#endif
#ifdef __LINUX__
      int charheight = GetCharHeight();

      ll = GetNumberOfLines();
#endif

	//Prune the length or it slows down big time.
	//If more than 1500 lines, chop the first 500. Harsh, but fair.


	if ( ll > 1500 )
	{
#ifdef __WINDOWS__
		int li = LineIndex(500);
		SetSel(0,li);
		Clear();
#endif
#ifdef __LINUX__
            int li = XYToPosition(0,500);
            Remove( 0, li );
#endif
      //Now inform the mHyperLinks list of how many characters we've chopped.
            mHyperLinks.Reset();
            CcLink* alink;
            while ( ( alink = (CcLink*)mHyperLinks.GetItem() ) != nil  )
            {
                  if ( alink->ReIndex(li))
                  {
                        delete alink;
                        mHyperLinks.RemoveItem();
                  }

                  mHyperLinks.GetItemAndMove();
            }

	}

	//Now scroll the text so that the last line is at the bottom of the screen.
	//i.e. so that the line at lastline-firstvisline is the first visible line.
#ifdef __WINDOWS__
      LineScroll ( GetLineCount() - GetFirstVisibleLine() - (int)( (float)GetHeight() / (float)charheight ) + 5 );
#endif
#ifdef __LINUX__
      ShowPosition ( GetLastPosition () );
#endif

}

void  CxMultiEdit::SetHyperText( CcString cText, CcString cCommand  )
{
#ifdef __WINDOWS__
      int oldend = GetWindowTextLength();
      SetSel( oldend, oldend );
      ReplaceSel(cText.ToCString());

      CHARFORMAT cf, ocf;

      GetSelectionCharFormat( ocf );

      cf.dwMask = CFM_COLOR|CFM_UNDERLINE;
      cf.crTextColor= RGB(0,0,200);
      cf.dwEffects = CFE_UNDERLINE;
      int newend = GetWindowTextLength();
      SetSel( oldend, newend );
      SetSelectionCharFormat ( cf );

      SetSel(GetTextLength(),-1);
      SetSelectionCharFormat( ocf );


      CClientDC cdc(this);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
      int charheight = textMetric.tmHeight;


      CcLink * newLink = new CcLink( oldend, cText.Length(), cCommand );

      mHyperLinks.AddItem(newLink);

	//Now scroll the text so that the last line is at the bottom of the screen.
	//i.e. so that the line at lastline-firstvisline is the first visible line.
      LineScroll ( GetLineCount() - GetFirstVisibleLine() - (int)((float)GetHeight() / (float)charheight) + 1 );
#endif
}


int	CxMultiEdit::GetIdealWidth()
{
	return mIdealWidth;
}
int	CxMultiEdit::GetIdealHeight()
{
	return mIdealHeight;
}

void CxMultiEdit::SetIdealHeight(int nCharsHigh)
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealHeight = nCharsHigh * textMetric.tmHeight;
#endif
#ifdef __LINUX__
      mIdealHeight = nCharsHigh * GetCharHeight();
#endif      
}

void CxMultiEdit::SetIdealWidth(int nCharsWide)
{
#ifdef __WINDOWS__
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;
#endif
#ifdef __LINUX__
      mIdealWidth = nCharsWide * GetCharWidth();
#endif      
}


void  CxMultiEdit::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
	if((top<0) || (left<0))
	{
		RECT windowRect;
		RECT parentRect;
		GetWindowRect(&windowRect);
		CWnd* parent = GetParent();
		if(parent != nil)
		{
			parent->GetWindowRect(&parentRect);
			windowRect.top -= parentRect.top;
			windowRect.left -= parentRect.left;
		}
		MoveWindow(windowRect.left,windowRect.top,right-left,bottom-top,false);
	}
	else
	{
		MoveWindow(left,top,right-left,bottom-top,true);
	}
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}

int   CxMultiEdit::GetTop()
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
int   CxMultiEdit::GetLeft()
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
int   CxMultiEdit::GetWidth()
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
int   CxMultiEdit::GetHeight()
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


void CxMultiEdit::Focus()
{
	SetFocus();
}

#ifdef __WINDOWS__
BEGIN_MESSAGE_MAP(CxMultiEdit, CRichEditCtrl)
	ON_WM_CHAR()
      ON_WM_LBUTTONUP()
      ON_WM_LBUTTONDOWN()
END_MESSAGE_MAP()
#endif
#ifdef __LINUX__
//wx Message Table
BEGIN_EVENT_TABLE(CxMultiEdit, wxTextCtrl)
      EVT_CHAR( CxMultiEdit::OnChar )
END_EVENT_TABLE()
#endif

#ifdef __WINDOWS__
void CxMultiEdit::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	NOTUSED(nRepCnt);
	NOTUSED(nFlags);
	switch(nChar)
	{
		case 9:     //TAB. Shift focus back or forwards.
		{
			Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
			if(mWidget->mDisabled)
				mWidget->FocusToInput((char)nChar);
			else
				CRichEditCtrl::OnChar( nChar, nRepCnt, nFlags );
		}
	}
}
#endif
#ifdef __LINUX__
void CxMultiEdit::OnChar( wxKeyEvent & event )
{
      switch(event.KeyCode())
	{
		case 9:     //TAB. Shift focus back or forwards.
		{
                  Boolean shifted = event.m_shiftDown;
			mWidget->NextFocus(shifted);
			break;
		}
		default:
		{
			if(mWidget->mDisabled)
                        mWidget->FocusToInput((char)event.KeyCode());
			else
                        event.Skip();
                  break;
		}
	}
}
#endif

#ifdef __WINDOWS__
void CxMultiEdit::OnLButtonUp( UINT nFlags, CPoint point )
{
	NOTUSED(nFlags);
      int iCharIndex = (int)SendMessage(EM_CHARFROMPOS,0,(LPARAM) &point);

      mHyperLinks.Reset();
      CcLink* pLink = (CcLink*)mHyperLinks.GetItemAndMove();
      while ( pLink != nil  )
      {
            if ( pLink->IsClicked(iCharIndex))
            {
                  mWidget->SendCommand( pLink->GetLinkCommand() );      
                  pLink = nil;
            }
            else
            {
                  pLink = (CcLink*)mHyperLinks.GetItemAndMove();
            }
      }
}
#endif

#ifdef __WINDOWS__
void CxMultiEdit::OnLButtonDown( UINT nFlags, CPoint point )
{
//      if( !(mWidget->mDisabled))
            CRichEditCtrl::OnLButtonDown( nFlags, point );
}
#endif

void CxMultiEdit::SetColour(int red, int green, int blue)
{
#ifdef __WINDOWS__
	CHARFORMAT cf;

	SetSel(GetTextLength() ,-1);
	GetSelectionCharFormat( cf );

	cf.dwMask = ( cf.dwMask | CFM_COLOR ) ; //Add the CFM_COLOR attribute
	cf.dwEffects = ( cf.dwEffects & (~CFE_AUTOCOLOR) ) ; //Remove the CFE_AUTOCOLOR attribute
	cf.crTextColor = RGB ( red, green, blue ); //Set the text colour.

	SetSel(GetTextLength() ,-1);
	SetSelectionCharFormat( cf );
//	SetDefaultCharFormat( cf );
#endif
}


void CxMultiEdit::SetBold(Boolean bold)
{
#ifdef __WINDOWS__
	CHARFORMAT cf;

	SetSel(GetTextLength() ,-1);
	GetSelectionCharFormat( cf );

	cf.dwMask = ( cf.dwMask | CFM_BOLD ) ; //Add the CFM_BOLD attribute

	if(bold)
		cf.dwEffects = ( cf.dwEffects | CFE_BOLD ) ; //Add the CFE_BOLD attribute
	else
		cf.dwEffects = ( cf.dwEffects & (~CFE_BOLD) ) ; //Remove the CFE_BOLD attribute


	SetSel(GetTextLength() ,-1);
	SetSelectionCharFormat( cf );
#endif

}

void CxMultiEdit::SetUnderline(Boolean underline)
{
#ifdef __WINDOWS__
	CHARFORMAT cf;

	SetSel(GetTextLength() ,-1);
	GetSelectionCharFormat( cf );

	cf.dwMask = ( cf.dwMask | CFM_UNDERLINE ) ; //Add the CFM_UNDERLINE attribute

	if(underline)
		cf.dwEffects = ( cf.dwEffects | CFE_UNDERLINE ) ; //Add the CFE_UNDERLINE attribute
	else
		cf.dwEffects = ( cf.dwEffects & (~CFE_UNDERLINE) ) ; //Remove the CFE_UNDERLINE attribute


	SetSel(GetTextLength() ,-1);
	SetSelectionCharFormat( cf );
#endif
}

void CxMultiEdit::SetItalic(Boolean italic)
{
#ifdef __WINDOWS__
	CHARFORMAT cf;

	SetSel(GetTextLength() ,-1);
	GetSelectionCharFormat( cf );

	cf.dwMask = ( cf.dwMask | CFM_ITALIC ) ; //Add the CFM_ITALIC attribute

	if(italic)
		cf.dwEffects = ( cf.dwEffects | CFE_ITALIC ) ; //Add the CFE_ITALIC attribute
	else
		cf.dwEffects = ( cf.dwEffects & (~CFE_ITALIC) ) ; //Remove the CFE_ITALIC attribute


	SetSel(GetTextLength() ,-1);
	SetSelectionCharFormat( cf );
#endif
}

                  
void CxMultiEdit::SetFixedWidth(Boolean fixed)
{
#ifdef __WINDOWS__
      CHARFORMAT cf;
	char face[32]; face[0] = '\0';

	SetSel(GetTextLength()-1 ,-1);
	GetSelectionCharFormat( cf );


	cf.dwMask = ( cf.dwMask | CFM_FACE ) ; //Add the CFM_FACE attribute

    lstrcpy(cf.szFaceName, "");  
	
	if(fixed)
		cf.bPitchAndFamily = (FIXED_PITCH|FF_MODERN);
	else
		cf.bPitchAndFamily = (VARIABLE_PITCH|FF_SWISS);

	SetSel(GetTextLength()-1 ,-1);
	SetSelectionCharFormat( cf );
#endif
}

void CxMultiEdit::BackALine()
{
#ifdef __WINDOWS__
      SetSel(  LineIndex(GetLineCount()-2), GetTextLength());
	Clear();
#endif
}

void CxMultiEdit::Spew()
{
//Send all text to crystals a line at a time.
    char theLine[80];
    int line = 0;
#ifdef __WINDOWS__
    while ( LineIndex(line) >= 0 )
    {
       int cp = GetLine(line, theLine, 79);
#endif
#ifdef __LINUX__
    for (int i=0; i<GetNumberOfLines(); i++)
    {
       wxString aline = GetLineText(i);
       int cp = min ( aline.Length(), 80 );
       strcpy ( (char*)&theLine, aline.c_str() );
#endif
       theLine[cp]='\0';
       ((CrMultiEdit*)mWidget)->SendCommand( CcString( theLine ));
       line++;
    }
}

void CxMultiEdit::SetOriginalSizes()
{
      mIdealHeight = GetHeight();
      mIdealWidth  = GetWidth();
      return;
}

void CxMultiEdit::Empty()
{
      SetSel( 0, GetWindowTextLength() );
      Clear();
}
