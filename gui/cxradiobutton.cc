////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxRadioButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxRadioButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.13  2011/02/22 13:12:41  rich
//   Fixed width of radiobuttons (was too big).
//
//   Revision 1.12  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.10  2004/05/13 09:16:12  rich
//   I must release the device context after 'get'ting it during GetIdealHeight
//   and width calls.
//
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
#ifdef CRY_USEMFC
        theStdButton->Create("RadioButton", WS_CHILD| WS_VISIBLE| BS_AUTORADIOBUTTON, CRect(0,0,10,10), guiParent, mRadioButtonCount++);
    theStdButton->SetFont(CcController::mp_font);
#endif
#ifdef CRY_USEWX
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
  #ifdef CRY_USEMFC
DestroyWindow();
#endif
#ifdef CRY_USEWX
Destroy();
#endif
}

#ifdef CRY_USEMFC
void    CxRadioButton::ButtonChanged()
{
    bool state = ( GetRadioState() == 1 ) ? true : false;
    if (state)
        ((CrRadioButton*)ptr_to_crObject)->ButtonOn();
}
#endif
#ifdef CRY_USEWX
void    CxRadioButton::ButtonChanged(wxCommandEvent& e)
{
      if ( GetValue() )
        ((CrRadioButton*)ptr_to_crObject)->ButtonOn();
}
#endif

void    CxRadioButton::SetText( const string & text )
{
#ifdef CRY_USEWX
      SetLabel(text.c_str());
#endif
#ifdef CRY_USEMFC
    SetWindowText(text.c_str());
#endif

}

CXSETGEOMETRY(CxRadioButton)

CXGETGEOMETRIES(CxRadioButton)


int   CxRadioButton::GetIdealWidth()
{
#ifdef CRY_USEMFC
	CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    return ( size.cx + 20); //Allow space for checkbox

/*    CDC* cdc = GetDC();
    HDC hdc= (HDC) (cdc->m_hAttribDC);
    GetWindowText(text);
    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
    ReleaseDC(cdc);
    return (size.cx+5); // optimum width for Windows buttons (only joking)*/
#endif
#ifdef CRY_USEWX
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cx+20); // nice width for buttons
#endif

}

int   CxRadioButton::GetIdealHeight()
{
#ifdef CRY_USEMFC
    CString text;
    SIZE size;
    HDC hdc= (HDC) (GetDC()->m_hAttribDC);
    GetWindowText(text);
    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
    return (size.cy+5); // *** optimum height for MacOS Buttons (depends on users font size?)
#endif
#ifdef CRY_USEWX
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
#ifdef CRY_USEMFC
    int value;
    if ( inValue == true )
        value = 1;
    else
        value = 0;
    SetCheck( value );
#endif
#ifdef CRY_USEWX
      SetValue ( inValue );
#endif
}

bool CxRadioButton::GetRadioState()
{
#ifdef CRY_USEMFC
      int value = GetCheck();
    if ( value == 1 )
        return (true);
    else
        return (false);
#endif
#ifdef CRY_USEWX
      return GetValue();
#endif
}

#ifdef CRY_USEMFC
//Windows Message Map
BEGIN_MESSAGE_MAP(CxRadioButton, CButton)
    ON_CONTROL_REFLECT(BN_CLICKED, ButtonChanged)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#endif
#ifdef CRY_USEWX
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

#ifdef CRY_USEMFC
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
#else
void CxRadioButton::OnChar( wxKeyEvent & event )
{
      switch(event.GetKeyCode())
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
                  ptr_to_crObject->FocusToInput((char)event.GetKeyCode());
            break;
        }
    }
}
#endif


void CxRadioButton::Disable(bool disabled)
{
#ifdef CRY_USEMFC
    if(disabled)
            EnableWindow(false);
    else
            EnableWindow(true);
#else
    if(disabled)
            Enable(false);
    else
            Enable(true);
#endif
}
