////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxEditBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  9.3.1998 10:08 Uhr

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cxeditbox.h"
#include    "cccontroller.h"
#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "creditbox.h"
#ifdef __BOTHWX__
#include <ctype.h> //for proto of iscntrl()
#include <wx/utils.h> //for wxBell!
#endif


int CxEditBox::mEditBoxCount = kEditBoxBase;


CxEditBox * CxEditBox::CreateCxEditBox( CrEditBox * container, CxGrid * guiParent )
{
//As with all these Cx classes, this is a static funtion. Call it to create an editbox,
//and it will do the initialisation for you.

    CxEditBox   *theEditBox = new CxEditBox( container );
#ifdef __CR_WIN__
        theEditBox->Create(ES_LEFT| ES_AUTOHSCROLL| WS_VISIBLE| WS_CHILD| ES_WANTRETURN, CRect(0,0,10,10), guiParent, mEditBoxCount++);
    theEditBox->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);  //Sink it into the window.
    theEditBox->SetFont(CxGrid::mp_font);
#endif
#ifdef __BOTHWX__
      theEditBox->Create(guiParent, -1, "EditBox", wxPoint(0,0), wxSize(10,10));
#endif
    return theEditBox;
}
CxEditBox::CxEditBox( CrEditBox * container )
      :BASEEDITBOX()
{
    ptr_to_crObject = container;      //This is the container (CrEditBox)
      mCharsWidth = 50;          //This is the default width if none is specified.
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

#ifdef __BOTHWX__
      SetValue( text.ToCString() );
#endif
#ifdef __CR_WIN__
      SetWindowText( text.ToCString() );
      SetSel(GetWindowTextLength(),GetWindowTextLength());  //Place caret at end of text.
#endif
}

void  CxEditBox::AddText( CcString text )
{
#ifdef __CR_WIN__
      SetSel(GetWindowTextLength(),GetWindowTextLength());       //Set the selection at the end of the text buffer.
      ReplaceSel(text.ToCString());    //Replace the selection (nothing) with the text to add.
      SetWindowPos(&wndTop,0,0,0,0,SWP_NOMOVE|SWP_NOSIZE|SWP_SHOWWINDOW); //Bring the focus to this window.
      SetSel(GetWindowTextLength(),GetWindowTextLength());  //Place caret at end of text.
#endif
#ifdef __BOTHWX__
      AppendText(text.ToCString());
      SetFocus();
#endif
}

void    CxEditBox::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
    MoveWindow(left,top,right-left,bottom-top,true); //Move the edit box
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
#endif
//      LOGSTAT ("I am the editbox " + CcString((int)this));
//      LOGSTAT ("My top is set to " + CcString(top) );
}

int   CxEditBox::GetTop()
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
    if(parent != nil)
    {
            parentRect = parent->GetRect();
            windowRect.y -= parentRect.y;
    }
      LOGSTAT ("I am the editbox " + CcString((int)this));
      LOGSTAT ("My top is " + CcString(windowRect.y) );
      return ( windowRect.y );
#endif
}
int   CxEditBox::GetLeft()
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
int   CxEditBox::GetHeight()
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

int CxEditBox::GetIdealWidth()
{
      return mCharsWidth;
}

int CxEditBox::GetIdealHeight()
{
#ifdef __CR_WIN__
    CClientDC cdc(this);   //See GetIdealWidth for how this works.
    CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
    cdc.SelectObject(oldFont);
    return textMetric.tmHeight + 5;
#endif
#ifdef __BOTHWX__
      int cx, cy;
      GetTextExtent( "Some text", &cx, &cy ) ;
      return cy + 5;
#endif
}

int CxEditBox::GetText(char* theText, int maxlen)
{
#ifdef __CR_WIN__
    int textlen = GetWindowText(theText,maxlen);
#endif
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
      int textlen = GetWindowText((char*)&theText,maxlen);
#endif
#ifdef __BOTHWX__
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

void    CxEditBox::SetVisibleChars( int count )
{
#ifdef __CR_WIN__
    CClientDC cdc(this);    //Get the device context for this window (edit box).
    CFont* oldFont = cdc.SelectObject(CxGrid::mp_font); //Select the standard font into the device context, save the old one for later.
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);   //Get the metrics for this font.
    cdc.SelectObject(oldFont);         //Select the old font back into the DC.
      mCharsWidth = count * textMetric.tmAveCharWidth;  //Work out the ideal width.
#endif
#ifdef __BOTHWX__
      mCharsWidth = count * GetCharWidth();
#endif
}

void    CxEditBox::EditChanged()
{
    ((CrEditBox*)ptr_to_crObject)->BoxChanged();  //Inform container that the text has changed.
}

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxEditBox, CEdit)
    ON_WM_CHAR()
        ON_WM_KEYDOWN()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Table
BEGIN_EVENT_TABLE(CxEditBox, BASEEDITBOX)
      EVT_CHAR( CxEditBox::OnChar )
      EVT_KEY_DOWN( CxEditBox::OnKeyDown )
END_EVENT_TABLE()
#endif


void CxEditBox::Focus()
{
    SetFocus();
#ifdef __CR_WIN__
      SetSel(GetWindowTextLength(),GetWindowTextLength());  //Place caret at end of text.
#endif
#ifdef __BOTHWX__
      SetInsertionPoint( GetLineLength(0) );  //Place caret at end of text.
#endif

}


#ifdef __CR_WIN__
void CxEditBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
    if( nChar == 9 )   //TAB. Move focus to next UI object.
    {
        Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
        ptr_to_crObject->NextFocus(shifted);
    }
    else if ( allowedInput == CXE_READ_ONLY )
    {
        return;
    }
    else if ( nChar == 13 ) //RETURN.
    {
        ((CrEditBox*)ptr_to_crObject)->ReturnPressed();
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
#ifdef __CR_WIN__
            if (((c < '0') || (c > '9')) && (c != '.')) {Beep(1000,50); return;} //If it is non numeric, and not '.', then ignore.
#endif
#ifdef __BOTHWX__
                  if (((c < '0') || (c > '9')) && (c != '.')) {wxBell(); return;} //If it is non numeric, and not '.', then ignore.
#endif
            }

        if( allowedInput == CXE_INT_NUMBER ) //It's an integer.
        {
#ifdef __CR_WIN__
            if ( c == '.' ) {Beep(1000,50); return;} //If it's a dot, ignore.
#endif
#ifdef __BOTHWX__
                  if ( c == '.' ) {wxBell(); return;} //If it's a dot, ignore.
#endif
        }

        CEdit::OnChar( nChar, nRepCnt, nFlags );
        EditChanged();
        return;
    }
}
#endif
#ifdef __BOTHWX__
void CxEditBox::OnChar( wxKeyEvent & event )
{
      int nChar = event.KeyCode();

      if ( nChar == 9 )
    {
             Boolean shifted = event.m_shiftDown;
             ptr_to_crObject->NextFocus(shifted);
      }
    else if ( allowedInput == CXE_READ_ONLY )
    {
        return;
    }
      else if ( nChar == 13 ) //RETURN.
    {
        ((CrEditBox*)ptr_to_crObject)->ReturnPressed();
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
#ifdef __CR_WIN__
            if (((c < '0') || (c > '9')) && (c != '.')) {Beep(1000,50); return;} //If it is non numeric, and not '.', then ignore.
#endif
#ifdef __BOTHWX__
                  if (((c < '0') || (c > '9')) && (c != '.')) {wxBell(); return;} //If it is non numeric, and not '.', then ignore.
#endif
        }

        if( allowedInput == CXE_INT_NUMBER ) //It's an integer.
        {
#ifdef __CR_WIN__
            if ( c == '.' ) {Beep(1000,50); return;} //If it's a dot, ignore.
#endif
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
      if(disable)
            EnableWindow(false);
      else
            EnableWindow(true);
#endif
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
    SetSel(0,-1);       //Set the selection to the whole of the text buffer.
    Clear();            //Clears the selection.
#endif
#ifdef __BOTHWX__
      Clear();
#endif
}

#ifdef __CR_WIN__
void CxEditBox::OnKeyDown ( UINT nChar, UINT nRepCnt, UINT nFlags )
{
            switch (nChar)
            {
                  case VK_UP:
                        ((CrEditBox*)ptr_to_crObject)->SysKey( CRUP );
                        break;
                  case VK_DOWN:
                        ((CrEditBox*)ptr_to_crObject)->SysKey( CRDOWN );
                        break;
                  default:
                        CEdit::OnKeyDown( nChar, nRepCnt, nFlags );
                        break;
            }
}
#endif
#ifdef __BOTHWX__
void CxEditBox::OnKeyDown ( wxKeyEvent & event )
{
            switch (event.KeyCode())
            {
                  case WXK_UP:
                        ((CrEditBox*)ptr_to_crObject)->SysKey( CRUP );
                        break;
                  case WXK_DOWN:
                        ((CrEditBox*)ptr_to_crObject)->SysKey( CRDOWN );
                        break;
                  default:
                        event.Skip();
                        break;
            }
}
#endif

void CxEditBox::SetOriginalSizes()
{
      mCharsWidth = GetWidth();

}
