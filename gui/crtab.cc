////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrTab
////////////////////////////////////////////////////////////////////////
//   Filename:  CrTab.cpp
//   Authors:   Richard Cooper 
//   Created:   23.1.2001 20:46 
//   $Log: not supported by cvs2svn $

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include        "ccstring.h"
#include        "crtab.h"
#include        "cxtab.h"
#include	"crgrid.h"
#include        "cxgrid.h"
#include	"cctokenlist.h"
#include	"cccontroller.h"
#include	"crwindow.h"
#include	"ccrect.h"



class CcTabData
{
  public:
    CcString tabName;
    CcString tabText;
    CrGrid*  tabGrid;
};

CrTab::CrTab( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
        ptr_to_cxObject = CxTab::CreateCxTab( this, (CxGrid *)(mParentPtr->GetWidget()) );
        mTabStop = true;
        m_nTabs = 0;
        m_nRealParent = mParentPtr;
        m_currentTab = nil;
        mXCanResize = true;
        mYCanResize = true;
}

CrTab::~CrTab()
{
	CrGUIElement * theItem;
	
        mTabsList.Reset();
        theItem = (CrGUIElement *)mTabsList.GetItem();
	
	while ( theItem != nil )
	{
		delete theItem;
                mTabsList.RemoveItem();
                theItem = (CrGUIElement *)mTabsList.GetItem();
	}
	
        if ( ptr_to_cxObject != nil )
	{
                delete (CxTab*)ptr_to_cxObject;
                ptr_to_cxObject = nil;
	}
}

Boolean CrTab::ParseInput( CcTokenList * tokenList )
{
  Boolean retVal = false;
  Boolean hasTokenForMe = true;
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
          Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
          tokenList->GetToken(); // Remove that token!
          mCallbackState = inform;
          break;
        }
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
   
          if ( retVal )
          {
            tabData->tabGrid = gridPtr;
            mTabsList.AddItem( (void*) gridPtr );
            ((CxTab*)ptr_to_cxObject)->AddTab(tabData->tabText) ;
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

            m_nTabs++;

          }
          else
          {
            delete gridPtr;
            gridPtr = nil;
          }
   
        }
        break;
      }
      default:
      {
        ((CxTab*)ptr_to_cxObject)->RedrawTabs();
        hasTokenForMe = false;
      }
    }
  }
  return (retVal);
}

void    CrTab::SetGeometry( const CcRect * rect )
{
  ((CxGrid*)ptr_to_cxObject)->SetGeometry(rect->mTop,rect->mLeft,rect->mBottom,rect->mRight );
  LOGSTAT ("CrTab SetGeom top = " + CcString(rect->mTop) +
                       " left = " + CcString(rect->mLeft) +
                       " bottom = " + CcString(rect->mBottom) +
                       " right = " + CcString(rect->mRight)
                       );
}

CcRect  CrTab::GetGeometry()
{
  int top    = ((CxGrid*)ptr_to_cxObject)->GetTop();
  int left   = ((CxGrid*)ptr_to_cxObject)->GetLeft();
  int bottom = ((CxGrid*)ptr_to_cxObject)->GetTop()+((CxGrid*)ptr_to_cxObject)->GetHeight();
  int right  = ((CxGrid*)ptr_to_cxObject)->GetLeft()+((CxGrid*)ptr_to_cxObject)->GetWidth();

  LOGSTAT ("CrTab GetGeom top = " + CcString(top) +
                       " left = " + CcString(left) +
                       " bottom = " + CcString(bottom) +
                       " right = " + CcString(right)
                       );

  CcRect retVal( top, left, bottom, right );

  return retVal;
}

void    CrTab::CalcLayout()
{
// Calclayout works out size of all children, adjusts the children
// for neatness if necessary/possible, and then sets the Cxgeometry
// of this tabctrl to fit around the children.

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
    theItem->CalcLayout();
    CcController::debugIndent--;
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }

  LOGSTAT("CrTab: " + mName + " CalcLayout Step 2: find max height and width");
  mTabsList.Reset();
  theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    aRectangle = theItem->GetGeometry();
    maxH =       max ( maxH, aRectangle.Height() );
    maxW =       max ( maxW, aRectangle.Width()  );
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }

  int offy = ((CxTab*)ptr_to_cxObject)->GetTabsHeight();
  int offh = ((CxTab*)ptr_to_cxObject)->GetTabsExtraVSpace();

  LOGSTAT("CrTab: " + mName + " CalcLayout Step 3: set max height and width of all tabs.");
  mTabsList.Reset();
  theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    aRectangle.Set(offy,EMPTY_CELL,maxH+offy,maxW+EMPTY_CELL);
    LOGSTAT ("TAB"); CcController::debugIndent++;
    theItem->SetGeometry(&aRectangle);
    CcController::debugIndent--;
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }

  m_GridH = maxH;
  m_GridW = maxW;
 
  LOGSTAT("CrTab  " + mName + "CalcLayout, m_gridH and W = "+CcString(m_GridH)+" "+CcString(m_GridW));

  ((CxTab*)ptr_to_cxObject)->SetGeometry(0,0,maxH+offy+offh,maxW+2*EMPTY_CELL);

  LOGSTAT("CrTab  " + mName + "CalcLayout, Set CxGeom to 0,0,"+CcString(maxH+offy+offh)+","+CcString(maxW+2*EMPTY_CELL));

  CcController::debugIndent--;

}

void  CrTab::SetOriginalSizes()
{
  // Call SetOriginalSizes() for child elements.
  mTabsList.Reset();
  CrGrid* theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    theItem->SetOriginalSizes();
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }
}

void    CrTab::SetText( CcString item )
{
}

CrGUIElement *  CrTab::FindObject( CcString Name )
{
  CrGUIElement* theElement;
  mTabsList.Reset();
  CrGrid* theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
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


void CrTab::Resize(int newWidth, int newHeight, int origWidth, int origHeight)
{
 // Need to subtract space for the tab control, then call resize on
 // all the child grids.

  LOGSTAT("CrTab  " + mName + "Resize nW,nH,oW,oH: "+CcString(newWidth)+CcString(newHeight)+CcString(origWidth)+CcString(origHeight));

  int offy = ((CxTab*)ptr_to_cxObject)->GetTabsHeight();
  int offh = ((CxTab*)ptr_to_cxObject)->GetTabsExtraVSpace();

  int nW = newWidth - 2*EMPTY_CELL;
  int oW = origWidth - 2*EMPTY_CELL;
  int nH = newHeight - EMPTY_CELL - offy - offh;
  int oH = origHeight - EMPTY_CELL - offy - offh;

  LOGSTAT("CrTab  " + mName + "Resize adjusted nW,nH,oW,oH: "+CcString(nW)+CcString(nH)+CcString(oW)+CcString(oH));

  mTabsList.Reset();
  CrGrid* theItem = (CrGrid *)mTabsList.GetItemAndMove();
  while ( theItem != nil )
  {
    theItem->Resize(nW,nH,oW,oH);
    theItem = (CrGrid*)mTabsList.GetItemAndMove();
  }
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

