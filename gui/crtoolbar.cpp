////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrToolBar
////////////////////////////////////////////////////////////////////////
//   Filename:  CrToolBar.cpp
//   Authors:   Richard Cooper
//   Created:   26.1.2001 17:10 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.9  2009/09/04 09:25:46  rich
//   Added support for Show/Hide H from model toolbar
//   Fixed atom picking after model update in extra model windows.
//
//   Revision 1.8  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.7  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.6  2003/09/16 14:47:47  rich
//   If toolbar item fails to create, finish parsing any remaining options anyway.
//
//   Revision 1.5  2003/09/11 13:18:17  rich
//   If toolbar buttons fail to initialise delete containers.
//
//   Revision 1.4  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.3  2001/06/17 15:14:12  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.2  2001/03/08 16:44:07  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//
//   Revision 1.1  2001/02/26 12:02:15  richard
//   New toolbar classes.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crtoolbar.h"
#include    "crwindow.h"
#include    "crgrid.h"
#include    "cxtoolbar.h"
#include    "ccrect.h"
#include    "ccstatus.h"
#include    "cccontroller.h"    // for sending commands

static list<CcTool*>  m_AllToolsList;   // All tools in all toolbars.
static int m_next_tool_id_to_try = kToolButtonBase;


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
        ((CxToolBar*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxToolBar*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }

    list<CcTool*>::iterator cti = m_ToolList.begin();
    for ( ; cti != m_ToolList.end(); cti++ )
    {
       RemoveTool(*cti);
       delete *cti;
    }
    m_ToolList.clear();
}

CRSETGEOMETRY(CrToolBar,CxToolBar)
CRGETGEOMETRY(CrToolBar,CxToolBar)
CRCALCLAYOUT(CrToolBar,CxToolBar)

CcParse CrToolBar::ParseInput( deque<string> & tokenList )
{

  CcParse retVal(true, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;
  string theToken;

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    mName = string(tokenList.front());
    tokenList.pop_front();
    mSelfInitialised = true;
    LOGSTAT( "Created ToolBar " + mName );
  }

  hasTokenForMe = true;

  while ( hasTokenForMe && ! tokenList.empty() )
  {
    switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
    {
      case kTOpenGrid: //Really just here to make things line
      {                //up nicely in the scripts.
        tokenList.pop_front(); // Remove that token!
        break;
      }
      case kTAddTool:
      {
        tokenList.pop_front(); // Remove that token!
        CcTool * newTool = new CcTool();
        m_ToolList.push_back(newTool);
        AddTool(newTool); //Add to list.
        newTool->tName = string(tokenList.front()); tokenList.pop_front();
        newTool->tImage = string(tokenList.front()); tokenList.pop_front();
        newTool->tText = string(tokenList.front()); tokenList.pop_front();
        newTool->tCommand = string(tokenList.front()); tokenList.pop_front();
        newTool->tDisableFlags = 0;
        newTool->tEnableFlags = 0;
        newTool->toolType = CT_NORMAL;
        newTool->toggleable = false;
        newTool->tTool = this;

        bool moreTokens = true;
        while ( moreTokens && !tokenList.empty() )
        {
          switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
          {
            case kTMenuDisableCondition:
            {
              tokenList.pop_front();
              newTool->tDisableFlags = (CcController::theController)->status.CreateFlag(tokenList.front());
              tokenList.pop_front();
              break;
            }
            case kTMenuEnableCondition:
            {
              tokenList.pop_front();
              newTool->tEnableFlags = (CcController::theController)->status.CreateFlag(tokenList.front());
              tokenList.pop_front();
              break;
            }
            case kTToggle:
            {
              tokenList.pop_front();
              newTool->toggleable = true;
              break;
            }
            case kTAppIcon:
            {
              tokenList.pop_front();
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
        if ( !((CxToolBar*)ptr_to_cxObject)->AddTool( newTool ) )
        {
           //Remove tool
           LOGSTAT("Failed to create toolbar item: " + newTool->tName);
           RemoveTool(newTool);
           m_ToolList.remove( newTool );
           delete newTool;
        }
        break;
      }
      case kTMenuSplit:
      {
        tokenList.pop_front();             // Remove that token!
        CcTool * newTool = new CcTool();
        m_ToolList.push_back(newTool);
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
        tokenList.pop_front();                 // Remove that token!
        CcTool* nt = FindAnyTool(tokenList.front());
        tokenList.pop_front();

        bool moreTokens = true;
        while ( moreTokens && !tokenList.empty() )
        {
          switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
          {
            case kTState:
            {
                tokenList.pop_front(); // Remove that token!
                bool on = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTOn) ? true : false;
                tokenList.pop_front(); // Remove that token!
                if ( nt ) ((CxToolBar*)ptr_to_cxObject)->CheckTool(on,nt->CxID);
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
        tokenList.pop_front();
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


void  CrToolBar::GetValue( deque<string> &  tokenList )
{
    if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQState ) {

		tokenList.pop_front();
		CcTool* nt = FindAnyTool(tokenList.front());
        tokenList.pop_front();

		bool on = false;
		
		if ( nt ) {
           on = ((CxToolBar*)ptr_to_cxObject)->GetToolState(nt->CxID);
		}
		if ( on ) {
            SendCommand( kSOn,true);
        } else {
            SendCommand( kSOff,true);
		}
    } else {
        SendCommand( "ERROR",true );
        LOGWARN( "CrCheckBox:GetValue Error unrecognised token." + tokenList.front() );
        tokenList.pop_front();
    }
}



void CrToolBar::CrFocus()
{
    ((CxToolBar*)ptr_to_cxObject)->Focus();
}


void CrToolBar::SetText( const string &text )
{

}

CcTool* CrToolBar::FindTool(int ID)
{
  list<CcTool*>::iterator cti = m_ToolList.begin();
  for ( ; cti != m_ToolList.end(); cti++ )
  {
    if ( (*cti)->CxID == ID ) return *cti;
  }
  return nil;

}


void CrToolBar::CxEnable(bool enable, int id)
{
   ((CxToolBar*)ptr_to_cxObject)->CxEnable( enable, id );
}


int CrToolBar::FindFreeToolId()
{

    m_next_tool_id_to_try++;
    int starting_try = m_next_tool_id_to_try;
    list<CcTool*>::iterator ti;

    while (1)
    {
       bool pointerfree = true;

       for ( ti = m_AllToolsList.begin(); ti != m_AllToolsList.end(); ti++ )
       {
          if ( (*ti)->CxID  == m_next_tool_id_to_try )
          {
             pointerfree = false;
             m_next_tool_id_to_try++;

             if ( m_next_tool_id_to_try > ( kToolButtonBase + 5000 ) )
             {
//Reset id pointer to start:
                m_next_tool_id_to_try = kToolButtonBase;
             }
             if ( m_next_tool_id_to_try == starting_try )
             {
//No more free id's:
                 return -1;
             }
             break;
          }
       }

       if ( pointerfree ) return m_next_tool_id_to_try;

    }

}

void CrToolBar::AddTool( CcTool * tool )
{
      m_AllToolsList.push_back( tool );
      if ( m_AllToolsList.size() > 5000 )
      {
         //error
//         std::cerr << "More than 5000 toolbar items. Rethink or recompile.\n";
      //   ASSERT(0);
      }
}

CcTool* CrToolBar::FindAnyTool ( int id )
{

   list<CcTool*>::iterator ti;
   for ( ti = m_AllToolsList.begin(); ti != m_AllToolsList.end(); ti++ )
   {
      if ( (*ti)->CxID  == id )
      {
         return *ti;
      }
   }
  return nil;
}

CcTool* CrToolBar::FindAnyTool ( const string & name )
{

   list<CcTool*>::iterator ti;
   for ( ti = m_AllToolsList.begin(); ti != m_AllToolsList.end(); ti++ )
   {
      if ( (*ti)->tName  == name )
      {
         return *ti;
      }
   }
  return nil;
}

void CrToolBar::RemoveTool ( CcTool * tool )
{
   m_AllToolsList.remove(tool);
}

/*
void CrToolBar::RemoveTool ( const string & toolname )
{

   list<CcTool*>::iterator ti;
   for ( ti = m_AllToolsList.begin(); ti != m_AllToolsList.end(); )
   {
      if ( (*ti)->tName  == toolname )
      {
         m_AllToolsList.erase(ti);
         break;
      }
   }
}
*/

void CrToolBar::UpdateToolBars(CcStatus & status)
{
   list<CcTool*>::iterator ti;
   for ( ti = m_AllToolsList.begin(); ti != m_AllToolsList.end(); ti++ )
   {
        (*ti)->tTool->CxEnable(status.ShouldBeEnabled((*ti)->tEnableFlags,(*ti)->tDisableFlags), (*ti)->CxID);
   }
}
