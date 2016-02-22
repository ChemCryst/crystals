////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CxTab.cc
//   Authors:   Richard Cooper
//   Created:   23.1.2001 23:38
//   $Log: not supported by cvs2svn $
//   Revision 1.13  2005/03/02 14:41:53  stefan
//   1. Return value for mac version from the tabs GetTabHeigh method
//
//   Revision 1.12  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.2  2005/01/13 10:43:49  rich
//   Fix tab layout on WXS version - I think this was changed previously to fix
//   the MAC version, so some machine specific code will be required.
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.10  2004/11/11 14:39:18  stefan
//   1. Mac application files
//
//   Revision 1.9  2004/10/08 10:03:24  rich
//   Tab change notification not required under wxWin. Fix tab sizing by including
//   some space at the bottom.
//
//   Revision 1.8  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.7  2003/01/14 10:27:19  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.6  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.5  2001/07/16 07:25:31  ckp2
//   Make sure (in the wx version) that all the grids in the tab control are removed
//   from the tab control before it is destroyed.
//
//   Revision 1.4  2001/06/18 12:41:14  richard
//   AddTab is now passed a CcTabData rather than just a text string. The wx base
//   class (wxNoteBook) manages the child window for itself, (unlike windows where
//   we just change the child window when the tabs are clicked), so CcTabData
//   contains a pointer to the child.
//
//   Revision 1.3  2001/06/17 14:30:29  richard
//
//   wx support. CxDestroyWindow function.
//
//   Revision 1.2  2001/03/08 16:44:10  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//
//   Revision 1.1  2001/01/25 17:17:05  richard
//   A new control for tabbed property sheets.
//

#include    "crystalsinterface.h"
#include    <string>
using namespace std;
#include    "cxtab.h"
#include    "cccontroller.h"
#include    "crtab.h"
#include    "crgrid.h"
#include    "cxgrid.h"

int     CxTab::mTabCount = kTabBase;


CxTab *    CxTab::CreateCxTab( CrTab * container, CxGrid * guiParent )
{
    CxTab  *theTabCtrl = new CxTab( container );
#ifdef CRY_USEMFC
    theTabCtrl->Create(TCS_TABS|WS_CHILD|WS_VISIBLE|WS_CLIPCHILDREN,
                    CRect(0,0,200,200), guiParent,mTabCount++);
    theTabCtrl->SetFont(CcController::mp_font);
#endif
#ifdef CRY_USEWX
      theTabCtrl->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10), wxWANTS_CHARS);
      theTabCtrl->Show(true);
	  theTabCtrl->Connect(wxID_ANY, wxEVT_CHAR, wxKeyEventHandler(CxTab::OnChar),NULL,theTabCtrl); 
	  theTabCtrl->Connect(wxID_ANY, wxEVT_IDLE, wxIdleEventHandler(CxTab::OnIdle),NULL,theTabCtrl); 
	  mTabCount++;
#endif
    return theTabCtrl;

}

CxTab::CxTab( CrTab * container )
      : BASETAB()
{
    ptr_to_crObject = container;
    m_tab = 0;
}

CxTab::~CxTab()
{
}

void CxTab::CxDestroyWindow()
{
#ifdef CRY_USEMFC
  DestroyWindow();
#endif
#ifdef CRY_USEWX
  Destroy();
#endif
}

#ifdef CRY_USEMFC
BEGIN_MESSAGE_MAP(CxTab, CTabCtrl)
   ON_NOTIFY_REFLECT(TCN_SELCHANGE, OnSelChange)
   ON_WM_CHAR()
END_MESSAGE_MAP()
#endif

#ifdef CRY_USEWX
//wx Message Map
//BEGIN_EVENT_TABLE(CxTab, wxNotebook)
//      EVT_CHAR(CxTab::OnChar)
//END_EVENT_TABLE()
#endif

CXONCHAR(CxTab)
CXSETGEOMETRY(CxTab)
CXGETGEOMETRIES(CxTab)


int CxTab::GetIdealWidth()
{
    return (100);
}

int CxTab::GetIdealHeight()
{
    return (100);
}

void CxTab::AddTab(CcTabData * tab)
{
#ifdef CRY_USEMFC
  TC_ITEM tctab;
  tctab.mask = TCIF_TEXT;
  tctab.pszText = (char*) tab->tabText.c_str();
  InsertItem( m_tab++, &tctab );
#endif
#ifdef CRY_USEWX
  AddPage ( (wxWindow*)tab->tabGrid->GetWidget(), tab->tabText.c_str() );
  LOGSTAT ( "$$$$$$ Adding a page to notebook" );
#endif
  return;
}

int CxTab::GetTabsHeight()
{
#ifdef CRY_USEMFC
  CRect work(0,0,0,0);
  AdjustRect(TRUE,&work);
//  LOGSTAT ( "CxTab::GetTabsHeight work t,b,l,r ="
//  +string(work.top)
//  +" "+string(work.bottom)
// +" "+string(work.left)
//  +" "+string(work.right) );
//  LOGSTAT ( "Returning -top + 2");
  return -work.top + 2;
#endif
#ifdef CRY_USEWX
   wxSize mySize;
   mySize = CalcSizeFromPage(wxSize(0,0));
   // std::cout << "mySize.y " << mySize.y;
#ifdef CRY_OSMAC
   return 0;
#else
   return mySize.y;
#endif
#endif
}

int CxTab::GetTabsExtraVSpace()
{
#ifdef CRY_USEMFC
  CRect work(0,0,0,0);
  AdjustRect(TRUE,&work);
//  LOGSTAT ( "CxTab::GetTabsExtraVSpace work t,b,l,r ="
//  +string(work.top)
//  +" "+string(work.bottom)
//  +" "+string(work.left)
//  +" "+string(work.right) );
//  LOGSTAT ( "Returning bottom + 10");
  return work.bottom + 10; //Good space at bottom.
#endif
#ifdef CRY_USEWX
  return 10;
#endif
}

#ifdef CRY_USEMFC
void CxTab::OnSelChange(NMHDR* pNMHDR, LRESULT* pResult)
{
    int nTab = GetCurSel();
    ((CrTab*)ptr_to_crObject)->ChangeTab(nTab);
    *pResult = 0;
}
#endif

#ifdef CRY_USEWX
void CxTab::LetGoOfTabs()
{
  Show(false);
  int pc = GetPageCount();
  for ( int i = pc-1; i>=0; i-- )
  {
    RemovePage(i); //Removes page, but without deleting the
                   //associated window.
//NB. Remove pages last first as the index changes each time.
  }
}

void CxTab::OnIdle(wxIdleEvent & event)
{

	if ( HasFocus() ){
//		LOGERR("Idle event");
		ptr_to_crObject->FocusToInput(0);
	}
}

#endif

void CxTab::RedrawTabs()
{
#ifdef CRY_USEMFC
 Invalidate();
#endif
#ifdef CRY_USEWX
 Refresh();
#endif

}
