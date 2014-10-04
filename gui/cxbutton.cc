////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxButton

////////////////////////////////////////////////////////////////////////

//   Filename:  CxButton.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.14  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.13  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.12  2003/02/20 14:08:04  rich
//   New option of making buttoms "SLIM" they fit into text more easily.
//
//   Revision 1.11  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.10  2001/09/07 14:35:19  ckp2
//   LENGTH='a string' option lets the button length be based on a string other
//   than the one actually displayed. Useful for making professional looking
//   buttons in a given row, e.g.
//
//   @ 1,1 BUTTON BOK '&OK' LENGTH='Cancel'
//   @ 1,3 BUTTON BXX '&Cancel'
//
//   makes both buttons equal width.
//
//   Revision 1.9  2001/06/17 14:46:47  richard
//   CxDestroyWindow function.
//   Size wx buttons so the match MFC buttons.
//
//   Revision 1.8  2001/03/08 16:44:07  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    <string>
using namespace std;
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
    theStdButton->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
      theStdButton->Create(guiParent,-1,"Button",wxPoint(0,0),wxSize(10,10), wxWANTS_CHARS);
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
     m_lengthStringUsed = false;
     m_lengthString = "";
     m_Slim = false;
}

CxButton::~CxButton()
{
    mButtonCount--;
}

void CxButton::CxDestroyWindow()
{
#ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}


#ifdef __CR_WIN__
void    CxButton::ButtonClicked()
{
    ( (CrButton *)ptr_to_crObject)->ButtonClicked();
}
#endif
#ifdef __BOTHWX__
void    CxButton::ButtonClicked(wxCommandEvent& e)
{
    ( (CrButton *)ptr_to_crObject)->ButtonClicked();
}
#endif

void    CxButton::SetText( const string &text )
{
#ifdef __BOTHWX__
      SetLabel(text.c_str());
#endif
#ifdef __CR_WIN__
    SetWindowText(text.c_str());
#endif
}

CXSETGEOMETRY(CxButton)

CXGETGEOMETRIES(CxButton)


int CxButton::GetIdealWidth()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    if ( m_lengthStringUsed )
    {
        text = m_lengthString.c_str();
    }
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    return ( size.cx + 20 );
#endif
#ifdef __BOTHWX__
    int cx,cy;
    wxString text;
    text = GetLabel();
    if ( m_lengthStringUsed )
    {
        text = m_lengthString.c_str();
    }
    GetTextExtent( text, &cx, &cy );
    return (cx+20); // nice width for buttons
#endif

}

int CxButton::GetIdealHeight()
{
#ifdef __CR_WIN__
    CString text;
    SIZE size;
    CClientDC dc(this);
    CFont* oldFont = dc.SelectObject(CcController::mp_font);
    GetWindowText(text);
    size = dc.GetOutputTextExtent(text);
    dc.SelectObject(oldFont);
    if ( m_Slim )
      return ( size.cy + 2 );
    else
      return ( size.cy + 10 );
#endif
#ifdef __BOTHWX__
      int cx,cy;
      GetTextExtent( GetLabel(), &cx, &cy );
      if ( m_Slim )
        return (cy+3); // nice height for slim buttons
      else
        return (cy+10); // nice height for buttons
#endif

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
void CxButton::OnChar( wxKeyEvent & event )
{

//	ostringstream os;
//	os << event.GetKeyCode();
//	LOGERR("Cxbutton code is:");
//		LOGERR(os.str());
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


void CxButton::SetLength(string ltext)
{
    m_lengthStringUsed = true;
    m_lengthString = ltext;
}

void CxButton::SetSlim()
{
    m_Slim = true;
}

void CxButton::Disable(bool disabled)
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
void CxButton::CxSetState(bool highlight)
{
#ifdef __CR_WIN__
            EnableWindow(false);
#endif
#ifdef __BOTHWX__
 // Not implemented
#endif

}
