////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxCheckBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 10:38 Uhr

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cxcheckbox.h"

#include    "cxgrid.h"
#include    "crcheckbox.h"

int CxCheckBox::mCheckBoxCount = kCheckBoxBase;
CxCheckBox *    CxCheckBox::CreateCxCheckBox( CrCheckBox * container, CxGrid * guiParent )
{

    char * defaultName = (char *)"StdButton" ;
    CxCheckBox  *theStdButton = new CxCheckBox(container);

#ifdef __CR_WIN__
        theStdButton->Create("CheckBox",WS_CHILD| WS_VISIBLE| BS_AUTOCHECKBOX, CRect(0,0,10,10), guiParent, mCheckBoxCount++);
    theStdButton->SetFont(CxGrid::mp_font);
#endif
#ifdef __BOTHWX__
      theStdButton->Create(guiParent,-1,"CheckBox",wxPoint(0,0),wxSize(0,0));
#endif

    return theStdButton;
}

CxCheckBox::CxCheckBox( CrCheckBox * container)
      :BASECHECKBOX()
{
    ptr_to_crObject = container;
}

CxCheckBox::~CxCheckBox()
{
    mCheckBoxCount--;
}

void    CxCheckBox::BoxClicked()
{
#ifdef __CR_WIN__
      Boolean state = GetBoxState() == 1 ? true : false;
#endif
#ifdef __BOTHWX__
      Boolean state = GetValue();
#endif

    ( (CrCheckBox *)ptr_to_crObject)->BoxChanged( state );
}

void    CxCheckBox::SetText( char * text )
{
//Insert your own code here.
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


void  CxCheckBox::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
    MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
#endif

}
int   CxCheckBox::GetTop()
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
int   CxCheckBox::GetLeft()
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
int   CxCheckBox::GetWidth()
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
int   CxCheckBox::GetHeight()
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

int   CxCheckBox::GetIdealWidth()
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

int   CxCheckBox::GetIdealHeight()
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

void    CxCheckBox::SetBoxState( Boolean inValue )
{
#ifdef __CR_WIN__
    int value;
    if ( inValue == true )
        value = 1;
    else
        value = 0;
    SetCheck( value );
#endif
#ifdef __BOTHWX__
      SetValue (inValue);
#endif

}

Boolean CxCheckBox::GetBoxState()
{
#ifdef __CR_WIN__
    int value = GetCheck();
    if ( value == 1 )
        return (true);
    else
        return (false);
#endif
#ifdef __BOTHWX__
      return GetValue();
#endif
}

#ifdef __CR_WIN__
//Windows Message Map
BEGIN_MESSAGE_MAP(CxCheckBox, BASECHECKBOX)
    ON_CONTROL_REFLECT(BN_CLICKED, BoxClicked)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif

#ifdef __BOTHWX__
//wxWindows Event Table
BEGIN_EVENT_TABLE(CxCheckBox, BASECHECKBOX)
      EVT_CHECKBOX( -1, CxCheckBox::BoxClicked )
      EVT_CHAR( CxCheckBox::OnChar )
END_EVENT_TABLE()
#endif


#ifdef __CR_WIN__
void CxCheckBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
    NOTUSED(nRepCnt);
    NOTUSED(nFlags);
    switch(nChar)
    {
        case 9:
        {
            Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
            ptr_to_crObject->NextFocus(shifted);
            break;
        }
        case 32:    //SPACE. Activate Button.
        {
            BoxClicked();
            break;
        }

        default:
        {
            ptr_to_crObject->FocusToInput((char)nChar);
        }
    }
}
#endif
#ifdef __BOTHWX__
void CxCheckBox::OnChar( wxKeyEvent & event )
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
                  BoxClicked();
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

void CxCheckBox::Focus()
{
    SetFocus();
}

void CxCheckBox::Disable(Boolean disabled)
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
