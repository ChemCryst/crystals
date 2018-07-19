////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CrTab.cpp
//   Authors:   Richard Cooper
//   Created:   23.1.2001 20:46
//   $Log: not supported by cvs2svn $
//   Revision 1.11  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.10  2004/10/08 09:57:41  rich
//   Get initial tab to display under wxMSW
//
//   Revision 1.9  2004/06/29 15:15:30  rich
//   Remove references to unused kTNoMoreToken. Protect against reading
//   an empty list of tokens.
//
//   Revision 1.8  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.7  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.6  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.5  2001/07/16 07:25:31  ckp2
//   Make sure (in the wx version) that all the grids in the tab control are removed
//   from the tab control before it is destroyed.
//
//   Revision 1.4  2001/06/18 12:36:13  richard
//   Moved CcTabData definition into header so it can be used by CxTab.
//
//   Revision 1.3  2001/06/17 15:14:12  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.2  2001/03/08 15:43:42  richard
//   Minor bug fixes.
//
//   Revision 1.1  2001/01/25 17:17:05  richard
//   A new control for tabbed property sheets.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include        <string>
using namespace std;
#include        "crtab.h"
#include        "cxtab.h"
#include    "crgrid.h"
#include        "cxgrid.h"
#include    "cccontroller.h"
#include    "crwindow.h"
#include    "ccrect.h"



CrTab::CrTab( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
        ptr_to_cxObject = CxTab::CreateCxTab( this, (CxGrid *)(mParentPtr->GetWidget()) );
        mTabStop = true;
        m_nTabs = 0;
        m_currentTab = nil;
        mXCanResize = false;
        mYCanResize = false;
}

CrTab::~CrTab()
{

#ifdef CRY_USEWX
//The wxNotebook class likes to delete all of its own tabs,
//we can't have this because we need to delete all the Cr classes
//aswell, so before deleting anything, we simply remove all the
//windows from the control of the wxNotebook, so that when it is
//deleted, it has no child windows to delete.

#ifndef CRY_OSMAC
    ((CxTab*)ptr_to_cxObject)->LetGoOfTabs();
#endif

#endif

    list<CrGrid*>::iterator crgi = mTabsList.begin();
    for ( ; crgi != mTabsList.end(); crgi++ )
    {
     delete *crgi;
    }

    mTabsList.clear();

    if ( ptr_to_cxObject != nil )
    {
      ((CxTab*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
      delete (CxTab*)ptr_to_cxObject;
#endif
      ptr_to_cxObject = nil;
    }
}

void CrTab::SetGeometry( const CcRect * rect )
{
  ((CxTab*)ptr_to_cxObject)->SetGeometry( rect->mTop,    rect->mLeft,
                                           rect->mBottom, rect->mRight );

  CcRect aRectangle;
  int height = rect->mBottom-rect->mTop;
  int width  = rect->mRight-rect->mLeft;
  int offTop = ((CxTab*)ptr_to_cxObject)->GetTabsHeight();
  int offBot = ((CxTab*)ptr_to_cxObject)->GetTabsExtraVSpace();

  //Set height and width of all tabs - allowing for edges of tab control.

  LOGSTAT("CrTab: " + mName + " SetGeometry: set height and width of all tabs.");


  list<CrGrid*>::iterator crgi = mTabsList.begin();
  for ( ; crgi != mTabsList.end(); crgi++ )
  {
     aRectangle.Set(offTop,EMPTY_CELL,height-offBot,width-EMPTY_CELL);
     LOGSTAT ("TAB"); CcController::debugIndent++;
     (*crgi)->SetGeometry(&aRectangle);
     CcController::debugIndent--;
  }
}

CRGETGEOMETRY(CrTab,CxTab)


CcParse CrTab::ParseInput( deque<string> & tokenList )
{
  CcParse retVal(false, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;
  string theString;

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    LOGSTAT("Tabctrl Initing...");
    retVal = CrGUIElement::ParseInputNoText( tokenList );
    LOGSTAT( "Created TabControl  " + mName );

    while ( hasTokenForMe && ! tokenList.empty() )
    {
      switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
      {
        case kTInform:
        {
          tokenList.pop_front(); // Remove that token!
          bool inform = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
          tokenList.pop_front(); // Remove that token!
          mCallbackState = inform;
          break;
        }
        case kTOpenGrid:
          tokenList.pop_front();
        default:
        {
          hasTokenForMe = false;
          break; // We leave the token in the list and exit the loop
        }
      }
    }

    mSelfInitialised = true;

  }  // End of Init, now comes the general parser

  if ( tokenList.empty() ) return true;

  hasTokenForMe = true;

  while ( hasTokenForMe && ! tokenList.empty() )
  {
    switch ( CcController::GetDescriptor( tokenList.front(), kInstructionClass ) )
    {
      case kTCreateTab:
      {
        tokenList.pop_front(); // Remove that token!
        CcTabData* tabData = new CcTabData();
        tabData->tabName = string(tokenList.front());
        tokenList.pop_front();
        tabData->tabText = string(tokenList.front());
        tokenList.pop_front();

        LOGSTAT("Tab created, named " + tabData->tabName + " with text " + tabData->tabText );
        CrGrid* gridPtr = new CrGrid( this );
        if ( gridPtr != nil )
        {
          tokenList.pop_front();      // remove that token
          retVal = gridPtr->ParseInput( tokenList );

          mXCanResize = mXCanResize || retVal.CanXResize();
          mYCanResize = mYCanResize || retVal.CanYResize();
          if ( retVal.OK() )
          {
            tabData->tabGrid = gridPtr;
            mTabsList.push_back( gridPtr );
            ((CxTab*)ptr_to_cxObject)->AddTab(tabData) ;
#ifdef CRY_OSWIN32
//NB- under Win32 we manage the tabs, under wx the framework manages them.
            if ( m_nTabs )
            {
              gridPtr->CrShowGrid(false);
              LOGSTAT ("Not first grid in tab control: Hiding");
            }
            else
            {
              gridPtr->CrShowGrid(true);
              m_currentTab = gridPtr;
              LOGSTAT ("First grid in tab control: Showing");
            }
#endif
            m_nTabs++;

          }
          else
          {
            delete gridPtr;
            gridPtr = nil;
          }

        }
        delete tabData;  //Don't think tabdata is really needed.
        break;
      }
      case kTEndGrid:
        tokenList.pop_front();  //run on into default.
      default:
      {
        ((CxTab*)ptr_to_cxObject)->RedrawTabs();
        hasTokenForMe = false;
      }
    }
  }
  return CcParse(true,mXCanResize,mYCanResize);
}

CcRect CrTab::CalcLayout(bool recalc)
{
// Calclayout works out size of all children.

  CcController::debugIndent++;

  CcRect aRectangle;
  int maxH = 0;
  int maxW = 0;

  LOGSTAT("CrTab: " + mName + " CalcLayout Step 1: Calculating size of all child tabs");
  list<CrGrid*>::iterator crgi = mTabsList.begin();
  for ( ; crgi != mTabsList.end(); crgi++ )
  {
    LOGSTAT ("TAB"); CcController::debugIndent++;
    aRectangle = (*crgi)->CalcLayout(recalc);
    maxH = CRMAX ( maxH, aRectangle.Height() );
    maxW = CRMAX ( maxW, aRectangle.Width()  );
    CcController::debugIndent--;
  }

  int offTop = ((CxTab*)ptr_to_cxObject)->GetTabsHeight();
  int offBot = ((CxTab*)ptr_to_cxObject)->GetTabsExtraVSpace();

  CcController::debugIndent--;

  return CcRect( 0, 0, maxH+offTop+offBot, maxW+(2*EMPTY_CELL));

}


void    CrTab::SetText( const string &item )
{
}

CrGUIElement *  CrTab::FindObject( const string & Name )
{
  CrGUIElement* theElement = nil;

  list<CrGrid*>::iterator crgi = mTabsList.begin();
  for ( ; crgi != mTabsList.end(); crgi++ )
  {
    theElement = (*crgi)->FindObject( Name );
    if ( theElement ) return (CrGUIElement*) theElement;
  }
  return nil;
}


void CrTab::CrFocus()
{
}

void CrTab::ChangeTab(int tab)  //zero-based index of tab to change to
{

  if ( m_currentTab ) m_currentTab->CrShowGrid(false);

  list<CrGrid*>::iterator crgi = mTabsList.begin();
  for ( int i = 0; i < tab && crgi != mTabsList.end(); i++ ) { crgi++; }

  m_currentTab = *crgi;
  if ( m_currentTab ) m_currentTab->CrShowGrid(true);
  ((CxTab*)ptr_to_cxObject)->RedrawTabs();
}

int CrTab::GetIdealWidth()
{
  int resizeableWidth=0;
  list<CrGrid*>::iterator crgi = mTabsList.begin();
  for ( ; crgi != mTabsList.end(); crgi++ )
  {
    resizeableWidth = CRMAX ( resizeableWidth, (*crgi)->GetIdealWidth() );
  }
  return resizeableWidth;
}

int CrTab::GetIdealHeight()
{
  int offy = ((CxTab*)ptr_to_cxObject)->GetTabsHeight();
  int offh = ((CxTab*)ptr_to_cxObject)->GetTabsExtraVSpace();
  int resizeableHeight=0;

  list<CrGrid*>::iterator crgi = mTabsList.begin();
  for ( ; crgi != mTabsList.end(); crgi++ )
  {
    resizeableHeight = CRMAX ( resizeableHeight, (*crgi)->GetIdealHeight() );
  }

  return resizeableHeight;
}
