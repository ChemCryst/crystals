////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxCheckBox
////////////////////////////////////////////////////////////////////////
//   Filename:  CxCheckBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:19  rich
//   New CRYSTALS repository
//
//   Revision 1.13  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.12  2004/05/13 09:16:12  rich
//   I must release the device context after 'get'ting it during GetIdealHeight
//   and width calls.
//
//   Revision 1.11  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.10  2001/11/16 15:12:01  ckp2
//   Updated GetIdealWidth routine to be more accurate (use correct DC for calculations).
//
//   Revision 1.9  2001/06/17 14:45:02  richard
//   CxDestroyWindow function.
//
//   Revision 1.8  2001/03/08 16:44:08  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    <string>
using namespace std;
#include    "cxcheckbox.h"
#include    "cccontroller.h"
#include    "cxgrid.h"
#include    "crcheckbox.h"

int CxCheckBox::mCheckBoxCount = kCheckBoxBase;
CxCheckBox *    CxCheckBox::CreateCxCheckBox( CrCheckBox * container, CxGrid * guiParent )
{
    CxCheckBox  *theStdButton = new CxCheckBox(container);
#ifdef CRY_USEMFC
        theStdButton->Create("CheckBox",WS_CHILD| WS_VISIBLE| BS_AUTOCHECKBOX, CRect(0,0,10,10), guiParent, mCheckBoxCount++);
    theStdButton->SetFont(CcController::mp_font);
#else
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

void CxCheckBox::CxDestroyWindow()
{
  #ifdef CRY_USEMFC
DestroyWindow();
#else
Destroy();
#endif
}

#ifdef CRY_USEMFC
void    CxCheckBox::BoxClicked()
{
      bool state = GetBoxState() == 1 ? true : false;
#else
void    CxCheckBox::BoxClicked(wxCommandEvent & e)
{
      bool state = GetValue();
#endif

    ( (CrCheckBox *)ptr_to_crObject)->BoxChanged( state );
}

void    CxCheckBox::SetText( const string & text )
{
#ifdef CRY_USEMFC
	SetWindowText(text.c_str());
#else
    SetLabel(text.c_str());
#endif
}

CXSETGEOMETRY(CxCheckBox)

CXGETGEOMETRIES(CxCheckBox)

int   CxCheckBox::GetIdealWidth()
{
#ifdef CRY_USEMFC
    CString text;
    SIZE size;
//    HDC hdc= (HDC) (GetDC()->m_hAttribDC);
//    GetWindowText(text);
//    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
//    return (size.cx+20); // optimum width for Windows buttons (only joking)

    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    return ( size.cx + 20); //Allow space for checkbox

#else
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cx+20); // nice width for buttons
#endif

}

int   CxCheckBox::GetIdealHeight()
{
#ifdef CRY_USEMFC
    CString text;
    SIZE size;
    CDC* cdc = GetDC();
    HDC hdc= (HDC) (cdc->m_hAttribDC);
    GetWindowText(text);
    GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
    ReleaseDC(cdc);
    return (size.cy+5); // *** optimum height for MacOS Buttons (depends on users font size?)
#else
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      return (cy+5); // nice height for buttons
#endif

}

void    CxCheckBox::SetBoxState( bool inValue )
{
#ifdef CRY_USEMFC
    int value;
    if ( inValue == true )
        value = 1;
    else
        value = 0;
    SetCheck( value );
#else
      SetValue (inValue);
#endif

}

bool CxCheckBox::GetBoxState()
{
#ifdef CRY_USEMFC
    int value = GetCheck();
    if ( value == 1 )
        return (true);
    else
        return (false);
#else
      return GetValue();
#endif
}

#ifdef CRY_USEMFC
//Windows Message Map
BEGIN_MESSAGE_MAP(CxCheckBox, BASECHECKBOX)
    ON_CONTROL_REFLECT(BN_CLICKED, BoxClicked)
    ON_WM_CHAR()
END_MESSAGE_MAP()
#else
//wxWindows Event Table
BEGIN_EVENT_TABLE(CxCheckBox, BASECHECKBOX)
      EVT_CHECKBOX( -1, CxCheckBox::BoxClicked )
      EVT_CHAR( CxCheckBox::OnChar )
END_EVENT_TABLE()
#endif


#ifdef CRY_USEMFC
void CxCheckBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
    NOTUSED(nRepCnt);
    NOTUSED(nFlags);
    switch(nChar)
    {
        case 9:
        {
            bool shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
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
#else
void CxCheckBox::OnChar( wxKeyEvent & event )
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
           bool state = GetValue();
    		( (CrCheckBox *)ptr_to_crObject)->BoxChanged( state );
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

void CxCheckBox::Focus()
{
    SetFocus();
}

void CxCheckBox::Disable(bool disabled)
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
