////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CxTab.cc
//   Authors:   Richard Cooper
//   Created:   23.1.2001 23:38
//   $Log: not supported by cvs2svn $

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
    theTabCtrl->SetFont(CxGrid::mp_font);
#endif
#ifdef __BOTHWX__
      theGrid->Create(guiParent,-1,wxPoint(0,0),wxSize(10,10));
	  theGrid->Show(true);
      mGridCount++;
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


BEGIN_MESSAGE_MAP(CxTab, CTabCtrl)
   ON_NOTIFY_REFLECT(TCN_SELCHANGE, OnSelChange)
END_MESSAGE_MAP()


void    CxTab::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
      CRect work( left, top, right, bottom );
//      AdjustRect(TRUE,&work);
//      work.OffsetRect ( work.left, work.top );
      MoveWindow(work,true);
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
      LOGSTAT("I am grid number " + CcString((int)this) );
#endif
      LOGSTAT("CxTab SetGeom to t:" + CcString(work.top) + " l:" + CcString(work.left) + " b:" + CcString(work.Height()) + " r:" + CcString(work.Width())  );
}

int   CxTab::GetTop()
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
      wxRect windowRect; //, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
//  if(parent != nil)
//  {
//            parentRect = parent->GetRect();
//            windowRect.y -= parentRect.y;
//  }
      LOGSTAT("I am grid number " + CcString((int)this) );
      LOGSTAT("My top coord is " + CcString(windowRect.y));
        return ( windowRect.y );
#endif
}
int   CxTab::GetLeft()
{
#ifdef __CR_WIN__
      RECT windowRect;//, parentRect;
    GetWindowRect(&windowRect);
    CWnd* parent = GetParent();
//  if(parent != nil)
//  {
//      parent->GetWindowRect(&parentRect);
//      windowRect.left -= parentRect.left;
//  }
    return ( windowRect.left );
#endif
#ifdef __BOTHWX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
	  if ( ! parent->IsTopLevel() ) 
	  {
         if(parent != nil)
		 {
            parentRect = parent->GetRect();
            windowRect.x -= parentRect.x;
		 }
	  }
      return ( windowRect.x );
#endif

}
int   CxTab::GetWidth()
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
int   CxTab::GetHeight()
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
  TC_ITEM tab;
  tab.mask = TCIF_TEXT;
  tab.pszText = (char*) tabtext.ToCString();
  InsertItem( m_tab++, &tab );
  return;
}

int CxTab::GetTabsHeight()
{
  CRect work(0,0,0,0);
  AdjustRect(TRUE,&work);
  return -work.top + 2;
}

int CxTab::GetTabsExtraVSpace()
{
  CRect work(0,0,0,0);
  AdjustRect(TRUE,&work);
  return work.bottom + 10; //Good space at bottom.
}

void CxTab::OnSelChange(NMHDR* pNMHDR, LRESULT* pResult)
{
    int nTab = GetCurSel();
    ((CrTab*)ptr_to_crObject)->ChangeTab(nTab);
    *pResult = 0;
}


void CxTab::RedrawTabs()
{
 Invalidate();
}
