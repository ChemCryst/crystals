////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CxTab.cc
//   Authors:   Richard Cooper
//   Created:   23.1.2001 23:38
//   $Log: not supported by cvs2svn $
//   Revision 1.2  2001/03/08 16:44:10  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//
//   Revision 1.1  2001/01/25 17:17:05  richard
//   A new control for tabbed property sheets.
//

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "cccontroller.h"
#include    "crtab.h"
#include    "cxtab.h"
#include    "crgrid.h"
#include    "cxgrid.h"

int     CxTab::mTabCount = kTabBase;


CxTab *    CxTab::CreateCxTab( CrTab * container, CxGrid * guiParent )
{
    CxTab  *theTabCtrl = new CxTab( container );
#ifdef __CR_WIN__
    theTabCtrl->Create(TCS_TABS|WS_CHILD|WS_VISIBLE,
                    CRect(0,0,200,200), guiParent,mTabCount++);
    theTabCtrl->SetFont(CcController::mp_font);
#endif
#ifdef __BOTHWX__
      theTabCtrl->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10));
      theTabCtrl->Show(true);
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
#ifdef __CR_WIN__
  DestroyWindow();
#endif
#ifdef __BOTHWX__
  Destroy();
#endif
}

#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CxTab, CTabCtrl)
   ON_NOTIFY_REFLECT(TCN_SELCHANGE, OnSelChange)
END_MESSAGE_MAP()
#endif

#ifdef __BOTHWX__
//wx Message Map
BEGIN_EVENT_TABLE(CxTab, wxTabCtrl)
      EVT_TAB_SEL_CHANGED( -1, CxTab::OnSelChange )
END_EVENT_TABLE()
#endif



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

void CxTab::AddTab(CcString tabtext)
{
#ifdef __CR_WIN__
  TC_ITEM tab;
  tab.mask = TCIF_TEXT;
  tab.pszText = (char*) tabtext.ToCString();
  InsertItem( m_tab++, &tab );
#endif
#ifdef __BOTHWX__
  InsertItem (m_tab++, tabtext.ToCString() );
#endif
  return;
}

int CxTab::GetTabsHeight()
{
#ifdef __CR_WIN__
  CRect work(0,0,0,0);
  AdjustRect(TRUE,&work);
  LOGSTAT ( "CxTab::GetTabsHeight work t,b,l,r ="
  +CcString(work.top)
  +" "+CcString(work.bottom)
  +" "+CcString(work.left)
  +" "+CcString(work.right) );
  LOGSTAT ( "Returning -top + 2");
  return -work.top + 2;
#endif
#ifdef __BOTHWX__
  wxRect rc;
  GetItemRect(0,rc);
  return rc.GetHeight() + 5;
#endif
}

int CxTab::GetTabsExtraVSpace()
{
#ifdef __CR_WIN__
  CRect work(0,0,0,0);
  AdjustRect(TRUE,&work);
  LOGSTAT ( "CxTab::GetTabsExtraVSpace work t,b,l,r ="
  +CcString(work.top)
  +" "+CcString(work.bottom)
  +" "+CcString(work.left)
  +" "+CcString(work.right) );
  LOGSTAT ( "Returning bottom + 10");
  return work.bottom + 10; //Good space at bottom.
#endif
#ifdef __BOTHWX__
  return 10;
#endif
}

#ifdef __CR_WIN__
void CxTab::OnSelChange(NMHDR* pNMHDR, LRESULT* pResult)
{
    int nTab = GetCurSel();
    ((CrTab*)ptr_to_crObject)->ChangeTab(nTab);
    *pResult = 0;
}
#endif

#ifdef __BOTHWX__
void CxTab::OnSelChange(wxTabEvent& tabevt)
{
    int nTab = GetSelection();
    ((CrTab*)ptr_to_crObject)->ChangeTab(nTab);
}
#endif

void CxTab::RedrawTabs()
{
#ifdef __CR_WIN__
 Invalidate();
#endif
#ifdef __BOTHWX__
 Refresh();
#endif


}
