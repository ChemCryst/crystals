////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModList

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModList.cpp
//   Authors:   Richard Cooper
//   Created:   13.08.2002 22:51
//   $Log: not supported by cvs2svn $
//   Revision 1.8  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.7  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.6  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.5  2003/10/31 10:44:16  rich
//   When an atom is selected in the model window, it is scrolled
//   into view in the atom list, if not already in view.
//
//   Revision 1.4  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.3  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.2  2002/11/18 17:28:36  djw
//   Fix function returning a value when it should not.
//
//   Revision 1.1  2002/10/02 13:43:17  rich
//   New ModList class added.
//
//   Revision 1.7  2001/06/17 15:14:13  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.6  2001/03/08 16:44:05  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crmodlist.h"
#include    "ccmodeldoc.h"
#include    "crwindow.h"
#include    "crgrid.h"
#include    "cxmodlist.h"
#include    "ccrect.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "ccmodelatom.h"
#include    "cccontroller.h"    // for sending commands
#include    <string>
#include    <sstream>

CrModList::CrModList( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    m_ModelDoc = nil;
    ptr_to_cxObject = CxModList::CreateCxModList( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mXCanResize = true;
    mYCanResize = true;
    mTabStop = true;
    m_popupMenu1 = nil;
    m_popupMenu2 = nil;
    m_popupMenu3 = nil;
}

CrModList::~CrModList()
{
    if ( ptr_to_cxObject != nil )
    {
#ifdef CRY_USEMFC
        ((CxModList*)ptr_to_cxObject)->DestroyWindow();
        delete (CxModList*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
    delete m_popupMenu1;
    delete m_popupMenu2;
    delete m_popupMenu3;
}

CRSETGEOMETRY(CrModList,CxModList)
CRGETGEOMETRY(CrModList,CxModList)
CRCALCLAYOUT(CrModList,CxModList)

CcParse CrModList::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;
    string theToken;

    if( ! mSelfInitialised ) //Once Only.
    {
        LOGSTAT("*** ModList *** Initing...");

        mName = string(tokenList.front());
        tokenList.pop_front();
        mSelfInitialised = true;

        LOGSTAT( "*** Created ModList     " + mName );

        while ( hasTokenForMe && ! tokenList.empty() )
        {
            switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
            {
                case kTVisibleLines:
                {
                    tokenList.pop_front(); // Remove the keyword
                    ( (CxModList *)ptr_to_cxObject)->SetVisibleLines( atoi( tokenList.front().c_str() ) );
                    LOGSTAT("Setting ModList visible lines to " + tokenList.front());
                    tokenList.pop_front();
                    break;
                }
                default:
                {
                    hasTokenForMe = false;
                    break; // We leave the token in the list and exit the loop
                }
            }
        }

    }
    hasTokenForMe = true;
    while ( hasTokenForMe && ! tokenList.empty() ) //Every time
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTInform:
            {
                tokenList.pop_front(); // Remove that token!
                bool inform = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                mCallbackState = inform;
                if (mCallbackState)
                    LOGSTAT( "Enabling ModList callback" );
                else
                    LOGSTAT( "Disabling ModList callback" );
                break;
            }
            case kTAttachModel:
            {
                tokenList.pop_front();
                if( ( m_ModelDoc = (CcController::theController)->FindModelDoc(tokenList.front()) ) != nil )
                    m_ModelDoc->AddModelView(this);
                else
                {
                  m_ModelDoc = (CcController::theController)->CreateModelDoc(tokenList.front());
                  m_ModelDoc->AddModelView(this);
                }
                tokenList.pop_front();
                break;
            }
            case kTDefinePopupMenu:
            {
              tokenList.pop_front();
              LOGSTAT("Defining Popup Model Menu...");
              int menuNumber = atoi( tokenList.front().c_str() );
              tokenList.pop_front();
              CrMenu* mMenuPtr = new CrMenu( this, POPUP_MENU );
              if ( mMenuPtr != nil )
              {
// ParseInput generates all objects in the menu
                 CcParse menuP = mMenuPtr->ParseInput( tokenList );
                 if ( ! menuP.OK() )
                 {
                   delete mMenuPtr;
                   mMenuPtr = nil;
                 }
                 switch (menuNumber)
                 {
                   case 1:
                     m_popupMenu1 = mMenuPtr;
                     break;
                   case 2:
                     m_popupMenu2 = mMenuPtr;
                     break;
                   case 3:
                     m_popupMenu3 = mMenuPtr;
                     break;
                }
              }

              break;
            }
            case kTEndDefineMenu:
            {
              tokenList.pop_front();
              LOGSTAT("Popup Model Menu Definined.");
              break;
            }
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    return ( retVal );
}


void    CrModList::SetText( const string &item )
{
    LOGWARN( "CrModList:SetText Don't add text to a ModList.");
}

void    CrModList::GetValue()
{
    ostringstream strm;
    strm << ( (CxModList *)ptr_to_cxObject)->GetValue();
    SendCommand( strm.str() );
}

void CrModList::GetValue(deque<string> &  tokenList)
{

    int desc = CcController::GetDescriptor( tokenList.front(), kQueryClass );

    switch (desc)
    {
        case kTQListitem:
        {
            tokenList.pop_front();
            int i = atoi (tokenList.front().c_str()) - 1;
            tokenList.pop_front();
            int j = atoi (tokenList.front().c_str()) - 1;
            tokenList.pop_front();
            SendCommand( ((CxModList*)ptr_to_cxObject)->GetCell(i,j) , true );
            break;
        }
        case kTQListrow:
        {
            tokenList.pop_front();
            (CcController::theController)->SendCommand(((CxModList*)ptr_to_cxObject)->GetListItem(atoi( tokenList.front().c_str() )), true);
            tokenList.pop_front();
            break;
        }
        case kTQSelected:
        {
            tokenList.pop_front();
            int nv = ( (CxModList *)ptr_to_cxObject)->GetNumberSelected();
            int * values = new int [nv];
            ( (CxModList *)ptr_to_cxObject)->GetSelectedIndices(values);
            ostringstream strm;
            for ( int i = 0; i < nv; i++ )
            {
                strm.str("");
                strm << values[i];
                SendCommand( strm.str() , true );
            }
            SendCommand( "END" , true );
            break;
        }
        case kTQNselected:
        {
            tokenList.pop_front();
            ostringstream strm;
            strm << ( (CxModList *)ptr_to_cxObject)->GetNumberSelected();
            SendCommand( strm.str() , true );
            break;
        }
        default:
        {
            SendCommand( "ERROR",true );
            LOGWARN( "CrEditCtrl:GetValue Error unrecognised token." + tokenList.front());
            tokenList.pop_front();
            break;
        }
    }
}




void CrModList::CrFocus()
{
    ((CxModList*)ptr_to_cxObject)->Focus();
}

int CrModList::GetIdealWidth()
{
    return ((CxModList*)ptr_to_cxObject)->GetIdealWidth();
}

int CrModList::GetIdealHeight()
{
    return ((CxModList*)ptr_to_cxObject)->GetIdealHeight();
}

void CrModList::SendValue(const string & message)
{
    if(mCallbackState)
    {
            SendCommand(mName + " " + message);
    }
}

void CrModList::Update(int newsize)
{
  ((CxModList*)ptr_to_cxObject)->Update(newsize);
}

void CrModList::EnsureVisible(CcModelAtom* va)
{
  ((CxModList*)ptr_to_cxObject)->CxEnsureVisible(va);
}


void CrModList::DocToList()
{
    if(m_ModelDoc) m_ModelDoc->DocToList(this);
}

void CrModList::DocRemoved()
{
  m_ModelDoc = nil;
}

void CrModList::StartUpdate(){   
  ((CxModList*)ptr_to_cxObject)->StartUpdate();
}
void CrModList::EndUpdate(){
  ((CxModList*)ptr_to_cxObject)->EndUpdate();
}


void CrModList::AddRow( int id, vector<string> & rowOfStrings, bool s, bool d )
{
  ((CxModList*)ptr_to_cxObject)->AddRow( id, rowOfStrings, s, d);
   LOGSTAT("Added row: " + rowOfStrings[0] + rowOfStrings[1] + rowOfStrings[2]);
}

void CrModList::SelectAtomByPosn(int id, bool select)
{
  CcModelAtom* atom = nil;

  if(m_ModelDoc) atom = m_ModelDoc->FindAtomByPosn(id);

  if(atom) atom->Select(select);

  m_ModelDoc->DrawViews();

}

void CrModList::ContextMenu(int x, int y, int iitem, int mtype)
{
  if ( m_ModelDoc == nil ) return;

  CcModelAtom* atom = m_ModelDoc->FindAtomByPosn(iitem);

  if ( !atom ) return;

  string atomname = atom->Label();
  CrMenu* theMenu = nil;

  switch ( mtype ) {
      case 1:  // The user has clicked on nothing. Display general menu.
        theMenu = m_popupMenu1;
        break;
      case 2:  // The user has clicked on a selected atom. Decide.
        if ( m_ModelDoc->NumSelected() == 1 )
          theMenu = m_popupMenu3;
        else
          theMenu = m_popupMenu2;
        break;
      case 3: // The user has clicked on a single unselected atom.
        theMenu = m_popupMenu3;
        break;
      default:
        theMenu = nil;
    }


    if(theMenu)
    {
        string atom2 = "";
        theMenu->Substitute(atomname, m_ModelDoc, atom2);
        if ( ptr_to_cxObject ) theMenu->Popup(x,y,(void*)ptr_to_cxObject);
        else LOGERR ( "Unusable ModelList " + mName + ": failed to create.");
    }

}


void CrModList::MenuSelected(int id)
{
    CcMenuItem* menuItem = CrMenu::FindMenuItem( id );

    if ( menuItem )
    {
        string theCommand = menuItem->command;
        SendCommand(theCommand);
        return;
    }
    ostringstream strm;
    strm << "CrModList:MenuSelected Model cannot find menu item id = " << id;
    LOGERR(strm.str());
    return;
}
