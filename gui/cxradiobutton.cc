////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxRadioButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.9  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.8  2001/06/17 14:32:57  richard
//   CxDestroyWindow function.
//
//   Revision 1.7  2001/03/08 15:55:41  richard
//   Disable function - called by Cr class to disable the radiobutton.
//


#include    "crystalsinterface.h"
#include    "cxradiobutton.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "crradiobutton.h"

int CxRadioButton::mRadioButtonCount = kRadioButtonBase;

CxRadioButton * CxRadioButton::CreateCxRadioButton( CrRadioButton * container, CxGrid * guiParent )
{
    CxRadioButton   *theStdButton = new CxRadioButton( container );
#ifdef __CR_WIN__
        theStdButton->Create("RadioButton", WS_CHILD| WS_VISIBLE| BS_AUTORADIOBUTTON, CRect(0,0,10,10), guiParent, mRadioButtonCount++);
    theStdButton->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
      theStdButton->Create(guiParent,-1,"Radiobutton");
#endif
    return theStdButton;
}

CxRadioButton::CxRadioButton( CrRadioButton * container)
      :BASERADIOBUTTON()
{
    ptr_to_crObject = container;
}

CxRadioButton::~CxRadioButton()
{
    RemoveRadioButton();
}

void CxRadioButton::CxDestroyWindow()
{
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}

void    CxRadioButton::ButtonChanged()
{
#ifdef __CR_WIN__
    bool state = ( GetRadioState() == 1 ) ? true : false;
    if (state)
        ((CrRadioButton*)ptr_to_crObject)->ButtonOn();
#endif
#ifdef __BOTHWX__
      if ( GetValue() )
        ((CrRadioButton*)ptr_to_crObject)->ButtonOn();
#endif
}

void    CxRadioButton::SetText( char * text )
{
#ifdef __BOTHWX__
      SetLabel(text);
#endif
#ifdef __CR_WIN__
    SetWindowText(text);
#endif

}

CXSETGEOMETRY(CxRadioButton)

CXGETGEOMETRIES(CxRadioButton)


int   CxRadioButton::GetIdealWidth()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CDC* cdc = GetDC();
    HDC hdc= (HDC) (cdc->m_hAttribDC);
    GetWindowText(text);
    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
    ReleaseDC(cdc);
      return (size.cx+20); // optimum width for Windows buttons (only joking)
#endif
#ifdef __BOTHWX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cx+20); // nice width for buttons
#endif

}

int   CxRadioButton::GetIdealHeight()
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

int CxRadioButton::AddRadioButton()
{
    mRadioButtonCount++;
    return mRadioButtonCount;
}

void    CxRadioButton::RemoveRadioButton()
{
    mRadioButtonCount--;
}

void    CxRadioButton::SetRadioState( bool inValue )
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
      SetValue ( inValue );
#endif
}

bool CxRadioButton::GetRadioState()
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
BEGIN_MESSAGE_MAP(CxRadioButton, CButton)
    ON_CONTROL_REFLECT(BN_CLICKED, ButtonChanged)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Map
BEGIN_EVENT_TABLE(CxRadioButton, wxRadioButton)
      EVT_RADIOBUTTON( -1, CxRadioButton::ButtonChanged )
      EVT_CHAR( CxRadioButton::OnChar )
END_EVENT_TABLE()
#endif

void CxRadioButton::Focus()
{
    SetFocus();
}

#ifdef __CR_WIN__
void CxRadioButton::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
    NOTUSED(nRepCnt);
    NOTUSED(nFlags);
    switch(nChar)
    {
        case 9:     //TAB. Shift focus back or forwards.
        {
            bool shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
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
void CxRadioButton::OnChar( wxKeyEvent & event )
{
      switch(event.KeyCode())
    {
        case 9:     //TAB. Shift focus back or forwards.
        {
                  bool shifted = event.m_shiftDown;
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


void CxRadioButton::Disable(bool disabled)
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
