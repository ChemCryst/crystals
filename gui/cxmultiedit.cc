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
//insert your own code here.
#include	"cxgrid.h"
//#include	"ccrect.h"
#include	"crmultiedit.h"
#include	"crgrid.h"
//#include	<lview.h>
//#include	<LGroupBox.h>
//End of user code.          

int CxMultiEdit::mMultiEditCount = kMultiEditBase;

CxMultiEdit * 	CxMultiEdit::CreateCxMultiEdit( CrMultiEdit * container, CxGrid * guiParent )
{
	CxMultiEdit *theMEdit = new CxMultiEdit (container);
        theMEdit->Create(ES_LEFT|ES_AUTOHSCROLL|ES_AUTOVSCROLL|WS_VSCROLL|WS_HSCROLL|WS_VISIBLE|WS_CHILD|ES_MULTILINE,CRect(0,0,10,10),guiParent,mMultiEditCount++);
	theMEdit->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);
	theMEdit->SetFont(CxGrid::mp_font);
	theMEdit->SetBackgroundColor(FALSE,RGB(255,255,255));
	theMEdit->SetColour(0,0,0);

	return theMEdit;
}

CxMultiEdit::CxMultiEdit( CrMultiEdit * container )
: CRichEditCtrl ()
{
	mWidget = container;
#ifdef __LINUX__
	connect ( this, SIGNAL(textChanged()), this, SLOT(Changed()) );
#endif
	mIdealHeight = 30;
	mIdealWidth  = 70;
}
	CxMultiEdit::~CxMultiEdit()
{
	RemoveMultiEdit();
}

void  CxMultiEdit::SetText( CcString cText )
{
      int oldend = GetWindowTextLength();
      SetSel( oldend, oldend );
      ReplaceSel(cText.ToCString());

      CClientDC cdc(this);
// /* Need height of current font, not our ideal */ CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
//      cdc.SelectObject(oldFont);

	//Prune the length or it slows down big time.
	//If more than 1500 lines, chop the first 500. Harsh, but fair.
	int ll = GetLineCount();
	if ( ll > 1500 )
	{
		int li = LineIndex(500);
		SetSel(0,li);
		Clear();
      //Now inform the mHyperLinks list of how many characters we've chopped.

            mHyperLinks.Reset();
            CcLink* alink;
            while ( ( alink = (CcLink*)mHyperLinks.GetItem() ) != nil  )
            {
                  if ( alink->ReIndex(li))
                  {
                        mHyperLinks.RemoveItem();
                  }

                  mHyperLinks.GetItemAndMove();
            }

	}
	//Now scroll the text so that the last line is at the bottom of the screen.
	//i.e. so that the line at lastline-firstvisline is the first visible line.
	LineScroll ( GetLineCount() - GetFirstVisibleLine() - (int)((float)GetHeight() / (float)textMetric.tmHeight) + 1 );

}

void  CxMultiEdit::SetHyperText( CcString cText, CcString cCommand  )
{
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


      CcLink * newLink = new CcLink( oldend, cText.Length(), cCommand );

      mHyperLinks.AddItem(newLink);

	//Now scroll the text so that the last line is at the bottom of the screen.
	//i.e. so that the line at lastline-firstvisline is the first visible line.
	LineScroll ( GetLineCount() - GetFirstVisibleLine() - (int)((float)GetHeight() / (float)textMetric.tmHeight) + 1 );
}


void	CxMultiEdit::Changed()
{
//	mWidget->Changed();
}

int	CxMultiEdit::GetIdealWidth()
{
	return mIdealWidth;
}
int	CxMultiEdit::GetIdealHeight()
{
	return mIdealHeight;
}
void	CxMultiEdit::SetIdealHeight(int nCharsHigh)
{
//	QFontMetrics fontmetric ( fontMetrics() ) ;
//	mIdealHeight = nCharsHigh * fontmetric.lineSpacing();
//	CDC* cdc= GetDC();
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealHeight = nCharsHigh * textMetric.tmHeight;
}
void	CxMultiEdit::SetIdealWidth(int nCharsWide)
{
//	QFontMetrics fontmetric ( fontMetrics() ) ;
//	mIdealHeight = nCharsWide * fontmetric.maxWidth();
	CClientDC cdc(this);
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	mIdealWidth = nCharsWide * textMetric.tmAveCharWidth;
}
// OPSignature: void CxMultiEdit:SetGeometry( int:top  int:left  int:bottom  int:right ) 
void	CxMultiEdit::SetGeometry( int top, int left, int bottom, int right )
{
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
}
int	CxMultiEdit::GetTop()
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
int	CxMultiEdit::GetLeft()
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
int	CxMultiEdit::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxMultiEdit::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}


void CxMultiEdit::Focus()
{
	SetFocus();
}

BEGIN_MESSAGE_MAP(CxMultiEdit, CRichEditCtrl)
	ON_WM_CHAR()
      ON_WM_LBUTTONUP()
      ON_WM_LBUTTONDOWN()
END_MESSAGE_MAP()

void CxMultiEdit::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	switch(nChar)
	{
		case 9:
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

void CxMultiEdit::OnLButtonDown( UINT nFlags, CPoint point )
{
      if( !(mWidget->mDisabled))
            CRichEditCtrl::OnLButtonDown( nFlags, point );
}

void CxMultiEdit::SetColour(int red, int green, int blue)
{
	CHARFORMAT cf;

	SetSel(GetTextLength() ,-1);
	GetSelectionCharFormat( cf );

	cf.dwMask = ( cf.dwMask | CFM_COLOR ) ; //Add the CFM_COLOR attribute
	cf.dwEffects = ( cf.dwEffects & (~CFE_AUTOCOLOR) ) ; //Remove the CFE_AUTOCOLOR attribute
	cf.crTextColor = RGB ( red, green, blue ); //Set the text colour.

	SetSel(GetTextLength() ,-1);
	SetSelectionCharFormat( cf );
//	SetDefaultCharFormat( cf );
}


void CxMultiEdit::SetBold(Boolean bold)
{
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
}

void CxMultiEdit::SetUnderline(Boolean underline)
{
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

}

void CxMultiEdit::SetItalic(Boolean italic)
{
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

}

                  
void CxMultiEdit::SetFixedWidth(Boolean fixed)
{
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
}

void CxMultiEdit::BackALine()
{
	SetSel(  LineIndex(GetLineCount()-2), GetTextLength());
	Clear();
}

void CxMultiEdit::Spew()
{
//Send all text to crystals a line at a time.
    char theLine[80];
    int line = 0;
    while ( LineIndex(line) >= 0 )
    {
       int cp = GetLine(line, theLine, 79);
       theLine[cp]='\0';
       ((CrMultiEdit*)mWidget)->SendCommand( CcString( theLine ));
       line++;
    }
}

