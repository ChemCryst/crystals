////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CrTab.cpp
//   Authors:   Richard Cooper
//   Created:   23.1.2001 20:46
//   $Log: not supported by cvs2svn $
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
#include        "ccstring.h"
#include        "crtab.h"
#include        "cxtab.h"
#include    "crgrid.h"
#include        "cxgrid.h"
#include    "cctokenlist.h"
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

#ifdef __BOTHWX__
//The wxNotebook class likes to delete all of its own tabs,
//we can't have this because we need to delete all the Cr classes
//aswell, so before deleting anything, we simply remove all the
//windows from the control of the wxNotebook, so that when it is
//deleted, it has no child windows to delete.
       ((CxTab*)ptr_to_cxObject)->LetGoOfTabs();
#endif

    mTabsList.Reset();
    CrGUIElement * theItem = (CrGUIElement *)mTabsList.GetItem();
    while ( theItem != nil )
    {
      delete theItem;
      mTabsList.RemoveItem();
      theItem = (CrGUIElement *)mTabsList.GetItem();
    }

    if ( ptr_to_cxObject != nil )
    {
      ((CxTab*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
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
  mTabsList.Reset();
  CrGrid* theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    aRectangle.Set(offTop,EMPTY_CELL,height-offBot,width-EMPTY_CELL);
    LOGSTAT ("TAB"); CcController::debugIndent++;
    theItem->SetGeometry(&aRectangle);
    CcController::debugIndent--;
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }
}

CRGETGEOMETRY(CrTab,CxTab)


CcParse CrTab::ParseInput( CcTokenList * tokenList )
{
  CcParse retVal(false, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;
  CcString theString;

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    LOGSTAT("Tabctrl Initing...");
    retVal = CrGUIElement::ParseInputNoText( tokenList );
    LOGSTAT( "Created TabControl  " + mName );

    while ( hasTokenForMe )
    {
      switch ( tokenList->GetDescriptor(kAttributeClass) )
      {
        case kTInform:
        {
          tokenList->GetToken(); // Remove that token!
          bool inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
          tokenList->GetToken(); // Remove that token!
          mCallbackState = inform;
          break;
        }
        case kTOpenGrid:
          tokenList->GetToken();
        default:
        {
          hasTokenForMe = false;
          break; // We leave the token in the list and exit the loop
        }
      }
    }

    mSelfInitialised = true;

  }  // End of Init, now comes the general parser


  if( tokenList->GetDescriptor( kInstructionClass ) == kTNoMoreToken )
        return true;

  hasTokenForMe = true;

  while ( hasTokenForMe )
  {
    switch ( tokenList->GetDescriptor( kInstructionClass ) )
    {
      case kTCreateTab:
      {
        tokenList->GetToken(); // Remove that token!
        CcTabData* tabData = new CcTabData();
        tabData->tabName = tokenList->GetToken();
        tabData->tabText = tokenList->GetToken();

        LOGSTAT("Tab created, named " + tabData->tabName + " with text " + tabData->tabText );
        CrGrid* gridPtr = new CrGrid( this );
        if ( gridPtr != nil )
        {
          tokenList->GetToken();      // remove that token
          retVal = gridPtr->ParseInput( tokenList );

          mXCanResize = mXCanResize || retVal.CanXResize();
          mYCanResize = mYCanResize || retVal.CanYResize();
          if ( retVal.OK() )
          {
            tabData->tabGrid = gridPtr;
            mTabsList.AddItem( (void*) gridPtr );
            ((CxTab*)ptr_to_cxObject)->AddTab(tabData) ;
#ifdef __CR_WIN__
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
        tokenList->GetToken();  //run on into default.
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

  CrGrid* theItem;
  CcRect aRectangle;
  int maxH = 0;
  int maxW = 0;

  LOGSTAT("CrTab: " + mName + " CalcLayout Step 1: Calculating size of all child tabs");
  mTabsList.Reset();
  theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    LOGSTAT ("TAB"); CcController::debugIndent++;
    aRectangle = theItem->CalcLayout(recalc);
    maxH = max ( maxH, aRectangle.Height() );
    maxW = max ( maxW, aRectangle.Width()  );
    CcController::debugIndent--;
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }

  int offTop = ((CxTab*)ptr_to_cxObject)->GetTabsHeight();
  int offBot = ((CxTab*)ptr_to_cxObject)->GetTabsExtraVSpace();

  CcController::debugIndent--;

  return CcRect( 0, 0, maxH+offTop+offBot, maxW+(2*EMPTY_CELL));

}


void    CrTab::SetText( CcString item )
{
}

CrGUIElement *  CrTab::FindObject( CcString Name )
{
  CrGUIElement* theElement = nil;
  mTabsList.Reset();
  CrGrid* theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil && theElement == nil )
  {
    theElement = theItem->FindObject( Name );
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }
  return ( theElement );
}


void CrTab::CrFocus()
{
}

void CrTab::ChangeTab(int tab)
{

  if ( m_currentTab ) m_currentTab->CrShowGrid(false);

  mTabsList.Reset();
  for ( int i = 0; i <= tab; i++ ) m_currentTab = (CrGrid*) mTabsList.GetItemAndMove();

  if ( m_currentTab ) m_currentTab->CrShowGrid(true);

  ((CxTab*)ptr_to_cxObject)->RedrawTabs();
}

int CrTab::GetIdealWidth()
{
  int resizeableWidth=0;

  mTabsList.Reset();
  CrGrid* theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    resizeableWidth = max ( resizeableWidth, theItem->GetIdealWidth() );
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }

  return resizeableWidth;
}

int CrTab::GetIdealHeight()
{
  int offy = ((CxTab*)ptr_to_cxObject)->GetTabsHeight();
  int offh = ((CxTab*)ptr_to_cxObject)->GetTabsExtraVSpace();
  int resizeableHeight=0;

  mTabsList.Reset();
  CrGrid* theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    resizeableHeight = max ( resizeableHeight, theItem->GetIdealHeight() );
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }

  return resizeableHeight;
}
