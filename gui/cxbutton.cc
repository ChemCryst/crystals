////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "cxbutton.h"
//insert your own code here.
#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "crbutton.h"


#ifdef __CR_WIN__
#include    <afxwin.h>
#endif

#ifdef __BOTHWX__
#include    <wx/gdicmn.h>
#include    <wx/event.h>
#endif

int CxButton::mButtonCount = kButtonBase;

CxButton *  CxButton::CreateCxButton( CrButton * container, CxGrid * guiParent )
{
    CxButton    *theStdButton = new CxButton(container);
#ifdef __CR_WIN__
        theStdButton->Create("Button",WS_CHILD |WS_VISIBLE |BS_PUSHBUTTON, CRect(0,0,10,10), guiParent, mButtonCount++);
    theStdButton->SetFont(CxGrid::mp_font);
#endif
#ifdef __BOTHWX__
      theStdButton->Create(guiParent,-1,"Button",wxPoint(0,0),wxSize(10,10));
#endif

    return theStdButton;
}

CxButton::CxButton(CrButton* container)
#ifdef __CR_WIN__
    :CButton()
#endif
#ifdef __BOTHWX__
      :wxButton()
#endif
{
     ptr_to_crObject = container;
}

CxButton::~CxButton()
{
    mButtonCount--;
}

void    CxButton::ButtonClicked()
{
    ( (CrButton *)ptr_to_crObject)->ButtonClicked();
}

void    CxButton::SetText( char * text )
{
#ifdef __POWERPC__
    Str255 descriptor;
    strcpy( reinterpret_cast<char *>(descriptor), text );
    c2pstr( reinterpret_cast<char *>(descriptor) );
    SetDescriptor( descriptor );
#endif
#ifdef __BOTHWX__
      SetLabel(text);
#endif
#ifdef __CR_WIN__
    SetWindowText(text);
#endif
}

void    CxButton::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
    MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
      LOGSTAT ("I am button " + CcString(GetLabel()) );
      LOGSTAT ("My top coord is set to " + CcString(top) );
#endif

}
int CxButton::GetTop()
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
//      cerr << "My uncorrected coord is " << CcString(windowRect.y) << "\n";
//  if(parent != nil)
//  {
//            parentRect = parent->GetRect();
//            windowRect.y -= parentRect.y;
//  }
      return ( windowRect.y );
#endif
}
int CxButton::GetLeft()
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
int CxButton::GetWidth()
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
int CxButton::GetHeight()
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

int CxButton::GetIdealWidth()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    HDC hdc= (HDC) (GetDC()->m_hAttribDC);
    GetWindowText(text);
    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
      return (size.cx+20); // optimum width for Windows buttons (only joking)
#endif
#ifdef __BOTHWX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cx+20); // nice width for buttons
#endif

}

int CxButton::GetIdealHeight()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    HDC hdc= (HDC) (GetDC()->m_hAttribDC);
    GetWindowText(text);
    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
    return (size.cy+5); // *** optimum height for MacOS Buttons (depends on users font size?)
#endif
#ifdef __BOTHWX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cy+5); // nice height for buttons
#endif

}

void CxButton::BroadcastValueMessage()
{
    ButtonClicked();
}

void CxButton::SetDef()
{
// create the default outline
#ifdef __CR_WIN__
       ModifyStyle(NULL,BS_DEFPUSHBUTTON,0);
#endif
#ifdef __BOTHWX__
       SetDefault();
#endif

// Store the default button in the responsible window
    CxWindow * window = (CxWindow *) (ptr_to_crObject->GetRootWidget()->GetWidget());
    if ( window != nil )
        window->SetDefaultButton( this );
}


#ifdef __CR_WIN__
//Windows Message Map
BEGIN_MESSAGE_MAP(CxButton, CButton)
    ON_CONTROL_REFLECT(BN_CLICKED, ButtonClicked)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif

#ifdef __BOTHWX__
//wx Message Map
BEGIN_EVENT_TABLE(CxButton, wxButton)
      EVT_BUTTON( -1, CxButton::ButtonClicked )
      EVT_CHAR( CxButton::OnChar )
END_EVENT_TABLE()
#endif

void CxButton::Focus()
{
    SetFocus();
}

#ifdef __CR_WIN__
void CxButton::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
    NOTUSED(nRepCnt);
    NOTUSED(nFlags);
    switch(nChar)
    {
        case 9:     //TAB. Shift focus back or forwards.
        {
            Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
            ptr_to_crObject->NextFocus(shifted);
            break;
        }
        case 32:    //SPACE. Activates button. Don't focus to the input line.
        {
            break;
        }
        default:
        {
            ptr_to_crObject->FocusToInput((char)nChar);
            break;
        }
    }
}
#endif
#ifdef __BOTHWX__
void CxButton::OnChar( wxKeyEvent & event )
{
      switch(event.KeyCode())
    {
        case 9:     //TAB. Shift focus back or forwards.
        {
                  Boolean shifted = event.m_shiftDown;
            ptr_to_crObject->NextFocus(shifted);
            break;
        }
        case 32:    //SPACE. Activates button. Don't focus to the input line.
        {
            break;
        }
        default:
        {
                  ptr_to_crObject->FocusToInput((char)event.KeyCode());
            break;
        }
    }
}
#endif


void CxButton::Disable(Boolean disabled)
{
#ifdef __CR_WIN__
    if(disabled)
            EnableWindow(false);
    else
            EnableWindow(true);
#endif
#ifdef __BOTHWX__
    if(disabled)
            Enable(false);
    else
            Enable(true);
#endif

}
