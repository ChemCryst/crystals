////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrToolBar
////////////////////////////////////////////////////////////////////////
//   Filename:  CrToolBar.cpp
//   Authors:   Richard Cooper
//   Created:   26.1.2001 17:10 Uhr
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crtoolbar.h"
#include    "crwindow.h"
#include    "crgrid.h"
#include    "cxtoolbar.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands



CrToolBar::CrToolBar( CrGUIElement * mParentPtr )
    :CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxToolBar::CreateCxToolBar( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
}

CrToolBar::~CrToolBar()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxToolBar*)ptr_to_cxObject)->DestroyWindow(); delete (CxToolBar*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }

    m_ToolList.Reset();
    CcTool* theItem = (CcTool *)m_ToolList.GetItemAndMove();
    while ( theItem != nil )
    {
       delete theItem;
       theItem = (CcTool*)m_ToolList.GetItemAndMove();
    }
}

CRSETGEOMETRY(CrToolBar,CxToolBar)
CRGETGEOMETRY(CrToolBar,CxToolBar)
CRCALCLAYOUT(CrToolBar,CxToolBar)

CcParse CrToolBar::ParseInput( CcTokenList * tokenList )
{

  CcParse retVal(true, mXCanResize, mYCanResize);
  Boolean hasTokenForMe = true;
  CcString theToken;

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    mName = tokenList->GetToken();
    mSelfInitialised = true;
    LOGSTAT( "Created ToolBar " + mName );
  }

  hasTokenForMe = true;

  while ( hasTokenForMe )
  {
    switch ( tokenList->GetDescriptor(kAttributeClass) )
    {
      case kTOpenGrid: //Really just here to make things line
      {                //up nicely in the scripts.
        tokenList->GetToken(); // Remove that token!
        break;
      }
      case kTAddTool:
      {
        tokenList->GetToken(); // Remove that token!
        CcTool * newTool = new CcTool();
        m_ToolList.AddItem(newTool);
        (CcController::theController)->AddTool(newTool);
        newTool->tName = tokenList->GetToken();
        newTool->tImage = tokenList->GetToken();
        newTool->tText = tokenList->GetToken();
        newTool->tCommand = tokenList->GetToken();
        newTool->tDisableFlags = 0;
        newTool->tEnableFlags = 0;
        newTool->toolType = CT_NORMAL;
        newTool->toggleable = false;
        newTool->tTool = this;

        Boolean moreTokens = true;
        while ( moreTokens )
        {
          switch ( tokenList->GetDescriptor(kAttributeClass) )
          {
            case kTMenuDisableCondition:
            {
              tokenList->GetToken();
              newTool->tDisableFlags = (CcController::theController)->status.CreateFlag(tokenList->GetToken());
              break;
            }
            case kTMenuEnableCondition:
            {
              tokenList->GetToken();
              newTool->tEnableFlags = (CcController::theController)->status.CreateFlag(tokenList->GetToken());
              break;
            }
            case kTToggle:
            {
              tokenList->GetToken();
              newTool->toggleable = true;
              break;
            }
            case kTAppIcon:
            {
              tokenList->GetToken();
              newTool->toolType = CT_APPICON;
              break;
            }
            default:
            {
              moreTokens = false;
              break;
            }
          }
        }
        ((CxToolBar*)ptr_to_cxObject)->AddTool( newTool );
        break;
      }
      case kTMenuSplit:
      {
        tokenList->GetToken();             // Remove that token!
        CcTool * newTool = new CcTool();
        m_ToolList.AddItem(newTool);
        newTool->toolType = CT_SEP;
        newTool->tName = "";
        newTool->tImage = "";
        newTool->tText = "";
        newTool->tCommand = "";
        newTool->tDisableFlags = 0;
        newTool->tEnableFlags = 0;
        newTool->toggleable = false;
        newTool->tTool = nil;
        ((CxToolBar*)ptr_to_cxObject)->AddTool( newTool );
        break;
      }
      case kTItem:
      {
        tokenList->GetToken();                 // Remove that token!
        CcString item = tokenList->GetToken(); // Get Item Name.
        CcTool* nt = (CcController::theController)->FindTool(item);
        if ( !nt ) break;

        Boolean moreTokens = true;
        while ( moreTokens )
        {
          switch ( tokenList->GetDescriptor(kAttributeClass) )
          {
            case kTState:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean on = (tokenList->GetDescriptor(kLogicalClass) == kTOn) ? true : false;
                tokenList->GetToken(); // Remove that token!
                ((CxToolBar*)ptr_to_cxObject)->CheckTool(on,nt->CxID);
                break;
            }
            default:
            {
              moreTokens = false;
              break;
            }
          }
        }
        break;
      }
      case kTEndGrid:
      {
        tokenList->GetToken();
      }                       //run on into default...
      default:
      {
        hasTokenForMe = false;
        break; // We leave the token in the list and exit the loop
      }
    }
  }
  return ( retVal );
}

void CrToolBar::CrFocus()
{
    ((CxToolBar*)ptr_to_cxObject)->Focus();
}


void CrToolBar::SetText( CcString text )
{

}

CcTool* CrToolBar::FindTool(int ID)
{
  m_ToolList.Reset();
  CcTool* theItem = (CcTool *)m_ToolList.GetItemAndMove();
  while ( theItem != nil )
  {
    if ( theItem->CxID == ID ) return theItem;
    theItem = (CcTool*)m_ToolList.GetItemAndMove();
  }

  return nil;

}


void CrToolBar::CxEnable(bool enable, int id)
{
   ((CxToolBar*)ptr_to_cxObject)->CxEnable( enable, id );
}
