////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxEditBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  9.3.1998 10:08 Uhr

#include	"crystalsinterface.h"
#include	"cxeditbox.h"

#include	"cxgrid.h"
#include	"cxwindow.h"
#include	"creditbox.h"
#ifdef __LINUX__
#include <ctype.h> //for proto of iscntrl()
#include <wx/utils.h> //for wxBell!
#endif


int CxEditBox::mEditBoxCount = kEditBoxBase;


CxEditBox *	CxEditBox::CreateCxEditBox( CrEditBox * container, CxGrid * guiParent )
{
//As with all these Cx classes, this is a static funtion. Call it to create an editbox,
//and it will do the initialisation for you.
	
	CxEditBox	*theEditBox = new CxEditBox( container );
#ifdef __WINDOWS__
	theEditBox->Create(ES_LEFT|ES_AUTOHSCROLL|WS_VISIBLE|WS_CHILD|ES_WANTRETURN,CRect(0,0,10,10),guiParent,mEditBoxCount++);
	theEditBox->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);  //Sink it into the window.
	theEditBox->SetFont(CxGrid::mp_font);
#endif
#ifdef __LINUX__
      theEditBox->Create(guiParent, -1, "EditBox", wxPoint(0,0), wxSize(10,10));
#endif
	return theEditBox;
}
CxEditBox::CxEditBox( CrEditBox * container )
      :BASEEDITBOX()
{
	mWidget = container;      //This is the container (CrEditBox)
	mCharsWidth = 5;          //This is the default width if none is specified.
	allowedInput = CXE_TEXT_STRING;  //This is the default allowed input. See header file for other types.
}

CxEditBox::~CxEditBox()
{
	RemoveEditBox();
}

void  CxEditBox::SetText( CcString text )
{

//If we have an integer, read it in then write it out again to check.
	if(allowedInput == CXE_INT_NUMBER)
	{
            int number = atoi(text.ToCString());
//            sprintf(text.ToCString(),"%-d",number);
            text = CcString ( number );
		//Remove spaces.
            for ( int i = strlen(text.ToCString()) - 1; i > 0; i-- )
			if ( text[i] == ' ' )
				text[i] = '\0';
			else
				i = 0;
	}
//If we have an real, read it in then write it out again to check.
	else if( allowedInput == CXE_REAL_NUMBER)
	{
            double number = atof(text.ToCString());
//            sprintf(text.ToCString(),"%-8.5g",number);     //LOOK OUT. Precision limited to 5 places. (Width will probably not truncate though.)
            text = CcString ( number );
		//Remove spaces.
            for ( int i = strlen(text.ToCString()) - 1; i > 0; i-- )
			if ( text[i] == ' ' )
				text[i] = '\0';
			else
				i = 0;
	}

#ifdef __LINUX__
      SetValue( text.ToCString() );
#endif
#ifdef __WINDOWS__
      SetWindowText( text.ToCString() );
#endif
}

void  CxEditBox::AddText( CcString text )
{
#ifdef __WINDOWS__
      SetSel(GetWindowTextLength(),GetWindowTextLength());       //Set the selection at the end of the text buffer.
      ReplaceSel(text.ToCString());    //Replace the selection (nothing) with the text to add.
      SetWindowPos(&wndTop,0,0,0,0,SWP_NOMOVE|SWP_NOSIZE|SWP_SHOWWINDOW); //Bring the focus to this window.
      SetSel(GetWindowTextLength(),GetWindowTextLength());  //Place caret at end of text.
#endif
#ifdef __LINUX__
      AppendText(text.ToCString());
      SetFocus();
#endif
}

void	CxEditBox::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
	MoveWindow(left,top,right-left,bottom-top,true); //Move the edit box
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}

int   CxEditBox::GetTop()
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
int   CxEditBox::GetLeft()
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
int   CxEditBox::GetWidth()
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
int   CxEditBox::GetHeight()
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

int	CxEditBox::GetIdealWidth()
{
#ifdef __WINDOWS__
	CClientDC cdc(this);	//Get the device context for this window (edit box).
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font); //Select the standard font into the device context, save the old one for later.
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);   //Get the metrics for this font.
	cdc.SelectObject(oldFont);         //Select the old font back into the DC.
	return mCharsWidth * textMetric.tmAveCharWidth;  //Work out the ideal width.
#endif
#ifdef __LINUX__
      return mCharsWidth * GetCharWidth();
#endif
}

int	CxEditBox::GetIdealHeight()
{
#ifdef __WINDOWS__
	CClientDC cdc(this);   //See GetIdealWidth for how this works.
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	return textMetric.tmHeight + 5;
#endif
#ifdef __LINUX__
      return GetCharHeight() + 5;
#endif
}

int CxEditBox::GetText(char* theText, int maxlen)
{
#ifdef __WINDOWS__
	int textlen = GetWindowText(theText,maxlen);
#endif
#ifdef __LINUX__
      wxString wtext = GetValue();
      int textlen = wtext.Length();
      strcpy(theText, wtext.c_str());
#endif

//If the allowed input is a number, check it before returning.
//It should be a number, if it isn't 0 or 0.0 will be returned.
	if(allowedInput == CXE_INT_NUMBER)
	{
		int number = atoi(theText);
		sprintf(theText,"%-d",number);
	}
	else if( allowedInput == CXE_REAL_NUMBER)
	{
		double number = atof(theText);
		sprintf(theText,"%-f",number);
	}

	return textlen;
}

CcString CxEditBox::GetText()
{
      char theText[255];
      int maxlen = 255;
#ifdef __WINDOWS__
      int textlen = GetWindowText((char*)&theText,maxlen);
#endif
#ifdef __LINUX__
      wxString wtext = GetValue();
      int textlen = wtext.Length();
      strcpy(theText, wtext.c_str());
#endif

//If the allowed input is a number, check it before returning.
//It should be a number, if it isn't 0 or 0.0 will be returned.
	if(allowedInput == CXE_INT_NUMBER)
	{
		int number = atoi(theText);
		sprintf(theText,"%-d",number);
	}
	else if( allowedInput == CXE_REAL_NUMBER)
	{
		double number = atof(theText);
		sprintf(theText,"%-f",number);
	}

      return CcString( theText );
}

void	CxEditBox::SetVisibleChars( int count )
{
	mCharsWidth = count;   //Set the ideal width in characters.
}

void	CxEditBox::EditChanged()
{
	((CrEditBox*)mWidget)->BoxChanged();  //Inform container that the text has changed.
}

#ifdef __WINDOWS__
BEGIN_MESSAGE_MAP(CxEditBox, CEdit)
	ON_WM_CHAR()
	ON_WM_KEYDOWN()
END_MESSAGE_MAP()
#endif
#ifdef __LINUX__
//wx Message Table
BEGIN_EVENT_TABLE(CxEditBox, BASEEDITBOX)
      EVT_CHAR( CxEditBox::OnChar )
      EVT_KEY_DOWN( CxEditBox::OnKeyDown )
END_EVENT_TABLE()
#endif


void CxEditBox::Focus()
{
	SetFocus();
#ifdef __WINDOWS__
      SetSel(GetWindowTextLength(),GetWindowTextLength());  //Place caret at end of text.
#endif
#ifdef __LINUX__
      SetInsertionPoint( GetLineLength(0) );  //Place caret at end of text.
#endif

}


#ifdef __WINDOWS__
void CxEditBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	if( nChar == 9 )   //TAB. Move focus to next UI object.
	{
		Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
		mWidget->NextFocus(shifted);
	}
	else if ( allowedInput == CXE_READ_ONLY )
	{
		return;
	}
	else if ( nChar == 13 ) //RETURN.
	{
		((CrEditBox*)mWidget)->ReturnPressed();
	}
	else
	{
//Block unwanted keypresses...
		char c = (char) nChar;
		if(iscntrl( nChar )) //It it a control char (delete, arrow keys), let it through
		{
			CEdit::OnChar( nChar, nRepCnt, nFlags );
			EditChanged();
			return;
		}

		if( allowedInput != CXE_TEXT_STRING ) //It's not text (it's a number).
		{
#ifdef __WINDOWS__
			if (((c < '0') || (c > '9')) && (c != '.')) {Beep(1000,50); return;} //If it is non numeric, and not '.', then ignore.
#endif
#ifdef __LINUX__
                  if (((c < '0') || (c > '9')) && (c != '.')) {wxBell(); return;} //If it is non numeric, and not '.', then ignore.
#endif
            }
		
		if( allowedInput == CXE_INT_NUMBER ) //It's an integer.
		{
#ifdef __WINDOWS__
			if ( c == '.' ) {Beep(1000,50); return;} //If it's a dot, ignore.
#endif
#ifdef __LINUX__
                  if ( c == '.' ) {wxBell(); return;} //If it's a dot, ignore.
#endif
		}

		CEdit::OnChar( nChar, nRepCnt, nFlags );
		EditChanged();
		return;
	}
}
#endif
#ifdef __LINUX__
void CxEditBox::OnChar( wxKeyEvent & event )
{
      int nChar = event.KeyCode();

      if ( nChar == 9 )
	{
             Boolean shifted = event.m_shiftDown;
             mWidget->NextFocus(shifted);
      }
	else if ( allowedInput == CXE_READ_ONLY )
	{
		return;
	}
      else if ( nChar == 13 ) //RETURN.
	{
		((CrEditBox*)mWidget)->ReturnPressed();
	}
	else
	{
//Block unwanted keypresses...
		char c = (char) nChar;
		if(iscntrl( nChar )) //It it a control char (delete, arrow keys), let it through
		{
                  event.Skip();
			EditChanged();
			return;
		}
		if( allowedInput != CXE_TEXT_STRING ) //It's not text (it's a number).
		{
#ifdef __WINDOWS__
			if (((c < '0') || (c > '9')) && (c != '.')) {Beep(1000,50); return;} //If it is non numeric, and not '.', then ignore.
#endif
#ifdef __LINUX__
                  if (((c < '0') || (c > '9')) && (c != '.')) {wxBell(); return;} //If it is non numeric, and not '.', then ignore.
#endif
		}
		
		if( allowedInput == CXE_INT_NUMBER ) //It's an integer.
		{
#ifdef __WINDOWS__
			if ( c == '.' ) {Beep(1000,50); return;} //If it's a dot, ignore.
#endif
#ifdef __LINUX__
                  if ( c == '.' ) {wxBell(); return;} //If it's a dot, ignore.
#endif
		}

            event.Skip();
		EditChanged();
		return;
	}
}
#endif



void CxEditBox::Disable(Boolean disable)
{
#ifdef __WINDOWS__
      if(disable)
            EnableWindow(false);
      else               
            EnableWindow(true);
#endif
#ifdef __LINUX__
      if(disable)
            Enable(false);
	else
            Enable(true);
#endif
}

void CxEditBox::SetInputType(int type)
{
	allowedInput = type;  //See header file for the three types. The default
						  // is to allow text. It can be changed to REAL or INT.
}

void CxEditBox::ClearBox()
{
#ifdef __WINDOWS__
	SetSel(0,-1);       //Set the selection to the whole of the text buffer.
	Clear();			//Clears the selection.
#endif
#ifdef __LINUX__
      Clear();
#endif
}

#ifdef __WINDOWS__
void CxEditBox::OnKeyDown ( UINT nChar, UINT nRepCnt, UINT nFlags )
{
            switch (nChar)
            {
                  case VK_UP:
                        ((CrEditBox*)mWidget)->SysKey( CRUP );
                        break;
                  case VK_DOWN:
                        ((CrEditBox*)mWidget)->SysKey( CRDOWN );
                        break;
                  default:
                        CEdit::OnKeyDown( nChar, nRepCnt, nFlags );
                        break;
            }
}
#endif
#ifdef __LINUX__
void CxEditBox::OnKeyDown ( wxKeyEvent & event )
{
            switch (event.KeyCode())
            {
                  case WXK_UP:
                        ((CrEditBox*)mWidget)->SysKey( CRUP );
                        break;
                  case WXK_DOWN:
                        ((CrEditBox*)mWidget)->SysKey( CRDOWN );
                        break;
                  default:
                        event.Skip();
                        break;
            }
}
#endif
