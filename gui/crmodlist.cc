#ifdef __CR_WIN__
////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModList

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModList.cpp
//   Authors:   Richard Cooper
//   Created:   13.08.2002 22:51
//   $Log: not supported by cvs2svn $
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
#ifdef __CR_WIN__
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

CcParse CrModList::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;
    CcString theToken;

    if( ! mSelfInitialised ) //Once Only.
    {
        LOGSTAT("*** ModList *** Initing...");

        mName = tokenList->GetToken();
        mSelfInitialised = true;

        LOGSTAT( "*** Created ModList     " + mName );

        while ( hasTokenForMe )
        {
            switch ( tokenList->GetDescriptor(kAttributeClass) )
            {
                case kTVisibleLines:
                {
                    int lines;
                    tokenList->GetToken(); // Remove the keyword
                    CcString theToken = tokenList->GetToken();
                    lines = atoi( theToken.ToCString() );
                    ( (CxModList *)ptr_to_cxObject)->SetVisibleLines( lines );
                    LOGSTAT("Setting ModList visible lines to " + theToken);
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
    while ( hasTokenForMe ) //Every time
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTInform:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                mCallbackState = inform;
                if (mCallbackState)
                    LOGSTAT( "Enabling ModList callback" );
                else
                    LOGSTAT( "Disabling ModList callback" );
                break;
            }
            case kTAttachModel:
            {
                tokenList->GetToken();
                CcString name = tokenList->GetToken();
                if( ( m_ModelDoc = (CcController::theController)->FindModelDoc(name) ) != nil )
                    m_ModelDoc->AddModelView(this);
                else
                {
                  m_ModelDoc = (CcController::theController)->CreateModelDoc(name);
                  m_ModelDoc->AddModelView(this);
                }
                break;
            }
            case kTDefinePopupMenu:
            {
              tokenList->GetToken();
              LOGSTAT("Defining Popup Model Menu...");
              CcString theString = tokenList->GetToken();
              int menuNumber = atoi( theString.ToCString() );
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
              tokenList->GetToken();
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


void    CrModList::SetText( CcString item )
{
    LOGWARN( "CrModList:SetText Don't add text to a ModList.");
}

void    CrModList::GetValue()
{
    int value = ( (CxModList *)ptr_to_cxObject)->GetValue();
    SendCommand( CcString( value ) );
}

void CrModList::GetValue(CcTokenList * tokenList)
{

    int desc = tokenList->GetDescriptor(kQueryClass);

    switch (desc)
    {
        case kTQListitem:
        {
            tokenList->GetToken();
            int i = atoi ((tokenList->GetToken()).ToCString()) - 1;
            int j = atoi ((tokenList->GetToken()).ToCString()) - 1;
            CcString theItem = ((CxModList*)ptr_to_cxObject)->GetCell(i,j);
            SendCommand( theItem , true );
            break;
        }
        case kTQListrow:
        {
            tokenList->GetToken();
            CcString theString = tokenList->GetToken();
            int itemNo = atoi( theString.ToCString() );
            CcString result = ((CxModList*)ptr_to_cxObject)->GetListItem(itemNo);
            (CcController::theController)->SendCommand(result, true);
            break;
        }
        case kTQSelected:
        {
            tokenList->GetToken();
            int nv = ( (CxModList *)ptr_to_cxObject)->GetNumberSelected();
            int * values = new int [nv];
            ( (CxModList *)ptr_to_cxObject)->GetSelectedIndices(values);
            for ( int i = 0; i < nv; i++ )
            {
                SendCommand( CcString( values[i] ) , true );
            }
            SendCommand( "END" , true );
            break;
        }
        case kTQNselected:
        {
            tokenList->GetToken();
            int value = ( (CxModList *)ptr_to_cxObject)->GetNumberSelected();
            SendCommand( CcString( value ) , true );
            break;
        }
        default:
        {
            SendCommand( "ERROR",true );
            CcString error = tokenList->GetToken();
            LOGWARN( "CrEditCtrl:GetValue Error unrecognised token." + error);
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

void CrModList::SendValue(CcString message)
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

void CrModList::DocToList()
{
    if(m_ModelDoc) return m_ModelDoc->DocToList(this);
}

void CrModList::DocRemoved()
{
  m_ModelDoc = nil;
}

void CrModList::AddRow( int id, CcString* rowOfStrings, bool s, bool d )
{
  ((CxModList*)ptr_to_cxObject)->AddRow( id, rowOfStrings, s, d);
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

  CcString atomname = atom->Label();
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
        CcString atom2 = "";
        theMenu->Substitute(atomname, m_ModelDoc, atom2);
        if ( ptr_to_cxObject ) theMenu->Popup(x,y,(void*)ptr_to_cxObject);
        else LOGERR ( "Unusable ModelList " + mName + ": failed to create.");
    }

}


void CrModList::MenuSelected(int id)
{
    CcMenuItem* menuItem = (CcController::theController)->FindMenuItem( id );

    if ( menuItem )
    {
        CcString theCommand = menuItem->command;
        SendCommand(theCommand);
        return;
    }

    LOGERR("CrModList:MenuSelected Model cannot find menu item id = " + CcString(id));
    return;
}

#endif


