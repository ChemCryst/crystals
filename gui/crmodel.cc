////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrModel
////////////////////////////////////////////////////////////////////////

//   Filename:  CrModel.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.21  2001/09/07 14:39:06  ckp2
//
//   New modelwindow function lets the user choose a background bitmap to
//   display behind the model. David is correct; I've been to too many
//   conferences. But it's too late now, I've done it.
//
//   Revision 1.20  2001/06/18 12:32:19  richard
//   FindObjectByGLName had wrong return type for failure (bool rather than null).
//
//   Revision 1.19  2001/06/17 15:06:48  richard
//   Rename member variables so that they are prefixed "m_".
//   Moved a lot of code over into CcModelDoc - such as sending lists of atoms
//   to the scripts. The ModelDoc holds the lists so is a simpler place to do this.
//   This removed a lot of pointless "call throughs" from CxModel to CcModelDoc.
//
//   Revision 1.18  2001/03/15 11:05:41  richard
//   Error checking. Ensure that if ptr_to_cxObject is NULL then we don't call
//   any of the Cx object's functions. (This allows CxModel to fail gracefully, and
//   the application to continue working). NB. BECAUSE OF CHANGE TO CRYSTALSINTERFACE.H
//   I'D RECOMMEND AT LEAST A 'code gui', IF NOT A 'code' or 'buildall'.
//
//   Revision 1.17  2001/03/08 15:41:48  richard
//   Can switch between rotate mode, selection (box) mode. Can also select a fragment
//   based on a single atom name, and you can zoom in on selected atoms (exclude unselected).
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccstring.h"
#include    "ccrect.h"
#include    "crgrid.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "cxmodel.h"
#include    "ccmodeldoc.h"
#include    "cctokenlist.h"
#include    "cccontroller.h"    // for sending commands
#include    "creditbox.h"      //appends could be done through cccontroller for better separation.
#include    "ccmodelatom.h"
#include    "ccmodelbond.h"
#include        "crwindow.h"      // for getting syskeys
#include    <GL/glu.h>
#include    "crmodel.h"

CrModel::CrModel( CrGUIElement * mParentPtr )
 :     CrGUIElement( mParentPtr )
{
  mTabStop = true;
  mXCanResize = true;
  mYCanResize = true;
  m_ModelDoc = nil;
  m_popupMenu1 = nil;
  m_popupMenu2 = nil;
  m_popupMenu3 = nil;
  m_popupMenu4 = nil;
  m_AtomSelectAction = CR_SELECT;
  ptr_to_cxObject = CxModel::CreateCxModel( this,(CxGrid *)(mParentPtr->GetWidget()) );
  ((CrWindow*)GetRootWidget())->SendMeSysKeys( (CrGUIElement*) this );
  m_style.normal_res = 15;
  m_style.quick_res = 5;
  m_style.radius_type = COVALENT;
  m_style.radius_scale = 0.25;
  m_style.m_modview = (CxModel*)ptr_to_cxObject;
}

CrModel::~CrModel()
{
  if(m_ModelDoc) m_ModelDoc->RemoveView(this);

  if ( ptr_to_cxObject )
  {
    ((CxModel*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
    delete (CxModel*)ptr_to_cxObject;
#endif
    ptr_to_cxObject = nil;
  }

  delete m_popupMenu1;
  delete m_popupMenu2;
  delete m_popupMenu3;
  delete m_popupMenu4;

}

CRSETGEOMETRY(CrModel,CxModel)
CRGETGEOMETRY(CrModel,CxModel)
CRCALCLAYOUT(CrModel,CxModel)


CcParse CrModel::ParseInput( CcTokenList * tokenList )
{
  CcParse retVal(true, mXCanResize, mYCanResize);
  Boolean hasTokenForMe = true;

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    retVal = CrGUIElement::ParseInput( tokenList );
    mSelfInitialised = true;
    LOGSTAT( "*** Created Model      " + mName );

    hasTokenForMe = true;
    while ( hasTokenForMe )
    {
      switch ( tokenList->GetDescriptor(kAttributeClass) )
      {
        case kTNumberOfRows:
        {
          tokenList->GetToken(); // Remove that token!
          CcString theString = tokenList->GetToken();
          int chars = atoi( theString.ToCString() );
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SetIdealHeight( chars );
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
          LOGSTAT( "Setting Model Lines Height: " + theString );
          break;
        }
        case kTNumberOfColumns:
        {
          tokenList->GetToken(); // Remove that token!
          CcString theString = tokenList->GetToken();
          int chars = atoi( theString.ToCString() );
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SetIdealWidth( chars );
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
          LOGSTAT( "Setting Model Chars Width: " + theString );
          break;
        }
        default:
        {
          hasTokenForMe = false;

          CcString bitmap = (CcController::theController)->GetKey( mName );
          ((CxModel*)ptr_to_cxObject)->LoadDIBitmap(bitmap);

          break;
        }
      }
    }
  }
// End of Init, now comes the general parser

  hasTokenForMe = true;
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
        if (mCallbackState)
            LOGSTAT( "Enabling Model callback" );
        else
            LOGSTAT( "Disabling Model callback" );
        break;
      }
      case kTRadiusType:
      {
        tokenList->GetToken(); // Remove that token!
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
          case kTCovalent:
          {
            m_style.radius_type = COVALENT;
            break;
          }
          case kTVDW:
          {
            m_style.radius_type = VDW;
            break;
          }
          case kTThermal:
          {
            m_style.radius_type = THERMAL;
            break;
          }
          case kTSpare:
          {
            m_style.radius_type = SPARE;
            break;
          }
        }
        Update(true);
        tokenList->GetToken(); // Remove that token!
        break;
      }
      case kTRadiusScale:
      {
        tokenList->GetToken(); // Remove that token!
        CcString theString = tokenList->GetToken();
        m_style.radius_scale = float(atoi(theString.ToCString()))/1000.0f;
        Update(true);
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
      case kTSelectAction:
      {
        tokenList->GetToken(); // Remove that token!
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
          case kTSelect:
            tokenList->GetToken();
            m_AtomSelectAction = CR_SELECT;
            break;
          case kTAppendTo:
            tokenList->GetToken();
            m_AtomSelectAction = CR_APPEND;
            break;
          case kTSendA:
            tokenList->GetToken();
            m_AtomSelectAction = CR_SENDA;
            break;
          case kTSendB:
            tokenList->GetToken();
            m_AtomSelectAction = CR_SENDB;
            break;
          case kTSendC:
            tokenList->GetToken();
            m_AtomSelectAction = CR_SENDC;
            break;
          case kTSendCAndSelect:
            tokenList->GetToken();
            m_AtomSelectAction = CR_SENDC_AND_SELECT;
            break;
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
             case 4:
               m_popupMenu4 = mMenuPtr;
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
      case kTSelectAtoms:
      {
        tokenList->GetToken(); //Remove the kTSelectAtoms token!
        if( tokenList->GetDescriptor(kLogicalClass) == kTAll)
        {
          tokenList->GetToken(); //Remove the kTAll token!
          Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
          tokenList->GetToken();
          if(m_ModelDoc) m_ModelDoc->SelectAllAtoms(select);
        }
        else if( tokenList->GetDescriptor(kLogicalClass) == kTInvert)
        {
          tokenList->GetToken(); //Remove the kTInvert token!
          if(m_ModelDoc) m_ModelDoc->InvertSelection();
        }
        else
        {
          CcString atomLabel = tokenList->GetToken();
          Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
          tokenList->GetToken(); //Remove the kTYes/kTNo token
          if(m_ModelDoc) m_ModelDoc->SelectAtomByLabel(atomLabel,select);
        }
        break;
      }
      case kTDisableAtoms:
      {
        tokenList->GetToken(); //Remove the kTDisableAtoms token!
        CcString atomLabel = tokenList->GetToken();
        Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
        tokenList->GetToken(); //Remove the kTYes/kTNo token
        if(m_ModelDoc) m_ModelDoc->DisableAtomByLabel(atomLabel,select);
        break;
      }
      case kTCheckValue:
      {
        tokenList->GetToken();
        CcString atomLabel = tokenList->GetToken();
        if(m_ModelDoc)
        {
          CcModelAtom* atom = m_ModelDoc->FindAtomByLabel(atomLabel);
          if (atom)
          {
            if (atom->IsSelected()) (CcController::theController)->SendCommand("SET");
            else                    (CcController::theController)->SendCommand("UNSET");
          }
          else LOGERR("CrModel:ParseInput:kTCheckValue No such atom");
        }
        else LOGERR("CrModel:ParseInput:kTCheckValue Sent a CheckValue request, but there is no attached ModelDoc");
        break;
      }
      case kTNRes:
      {
        tokenList->GetToken();
        CcString theString = tokenList->GetToken();
        m_style.normal_res = atoi( theString.ToCString() );
        break;
      }
      case kTQRes:
      {
        tokenList->GetToken();
        CcString theString = tokenList->GetToken();
        m_style.quick_res = atoi( theString.ToCString() );
        break;
      }
      case kTStyle:
      {
        tokenList->GetToken();
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
          case kTStyleSmooth:
            if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SetDrawStyle( MODELSMOOTH );
            else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
            tokenList->GetToken();
            break;
          case kTStyleLine:
            if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetDrawStyle( MODELLINE );
            else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
            tokenList->GetToken();
            break;
          case kTStylePoint:
            if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetDrawStyle( MODELPOINT );
            else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
            tokenList->GetToken();
            break;
        }
        break;
      }
      case kTAutoSize:
      {
        tokenList->GetToken();
        Boolean size = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
        tokenList->GetToken(); // Remove that token!
        if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetAutoSize( size );
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTHover:
      {
        tokenList->GetToken();
        Boolean hover = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
        tokenList->GetToken(); // Remove that token!
        if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetHover( hover );
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTShading:
      {
        tokenList->GetToken();
        Boolean shading = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
        tokenList->GetToken(); // Remove that token!
        if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetShading( shading );
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTSelectTool:
      {
        tokenList->GetToken();
        Boolean bRect = true;
        if (tokenList->GetDescriptor(kLogicalClass) == kTSelectRect)
        {
          tokenList->GetToken();
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SelectTool(CXRECTSEL);
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        }
        else if (tokenList->GetDescriptor(kLogicalClass) == kTSelectPoly)
        {
          tokenList->GetToken();
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SelectTool(CXPOLYSEL);
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        }
        else
        {
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SelectTool(CXRECTSEL);
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        }
        break;
      }
      case kTRotateTool:
      {
        tokenList->GetToken();
        if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SelectTool(CXROTATE);
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTZoomSelected:
      {
        tokenList->GetToken();
        if (tokenList->GetDescriptor(kLogicalClass) == kTYes)
        {
          tokenList->GetToken();
          if(m_ModelDoc) m_ModelDoc->ZoomAtoms(true);
          (CcController::theController)->status.SetZoomedFlag(true);
          Update(true);
        }
        else if (tokenList->GetDescriptor(kLogicalClass) == kTNo)
        {
          tokenList->GetToken();
          if(m_ModelDoc) m_ModelDoc->ZoomAtoms(false);
          (CcController::theController)->status.SetZoomedFlag(false);
          Update(true);
        }
        else
        {
          if(m_ModelDoc) m_ModelDoc->ZoomAtoms(false);
          Update(true);
        }
        break;
      }
      case kTSelectFrag:
      {
        tokenList->GetToken();
        CcString atomname = tokenList->GetToken();
        if (tokenList->GetDescriptor(kLogicalClass) == kTYes)
        {
          tokenList->GetToken();
          SelectFrag(atomname,true);
        }
        else if (tokenList->GetDescriptor(kLogicalClass) == kTNo)
        {
          tokenList->GetToken();
          SelectFrag(atomname,false);
        }
        else
        {
          SelectFrag(atomname,true);
        }
        break;
      }
      case kTLoadBitmap:
      {
        tokenList->GetToken();
        CcString filename = tokenList->GetToken();
        if ( ptr_to_cxObject) ((CxModel*)ptr_to_cxObject)->LoadDIBitmap(filename);
        (CcController::theController)->StoreKey( mName, filename );
        break;
      }
      default:
      {
        hasTokenForMe = false;
        break; // We leave the token in the list and exit the loop
      }
    }
  }
  return retVal;
}

void CrModel::CrFocus()
{
  if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->Focus();
  else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
}

int CrModel::GetIdealWidth()
{
  if ( ptr_to_cxObject ) return ((CxModel*)ptr_to_cxObject)->GetIdealWidth();
  LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
  return 0;
}
int CrModel::GetIdealHeight()
{
  if ( ptr_to_cxObject ) return ((CxModel*)ptr_to_cxObject)->GetIdealHeight();
  LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
  return 0;
}

void CrModel::DocRemoved()
{
  m_ModelDoc = nil;
}


void CrModel::ContextMenu(int x, int y, CcString atomname, int selection, CcString atom2)
{
    if ( m_ModelDoc == nil ) return;

    CcString nameOfMenuToUse;
    CrMenu* theMenu = nil;

    switch ( selection ) {
      case 1:  // The user has clicked on nothing. Display general menu.
        theMenu = m_popupMenu1;
        break;
      case 2:  // The user has clicked on a set of selected atoms.
        theMenu = m_popupMenu2;
        break;
      case 3: // The user has clicked on a single atom
        theMenu = m_popupMenu3;
        break;
      case 4: // The user has clicked on a normal bond
        theMenu = m_popupMenu4;
        (CcController::theController)->status.SetBondType(BOND_NORM);
        break;
      case 5: // The user has clicked on a bond to a symm atom
        theMenu = m_popupMenu4;
        (CcController::theController)->status.SetBondType(BOND_SYMM);
        break;
      case 6: // The user has clicked on an aromatic bond.
        theMenu = m_popupMenu4;
        (CcController::theController)->status.SetBondType(BOND_AROMATIC);
        break;
      default:
        theMenu = nil;
    }

    theMenu->Substitute(atomname, m_ModelDoc, atom2);

    if(theMenu)
    {
        if ( ptr_to_cxObject ) theMenu->Popup(x,y,(void*)ptr_to_cxObject);
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
    }
}

void CrModel::MenuSelected(int id)
{
    CcMenuItem* menuItem = (CcController::theController)->FindMenuItem( id );

    if ( menuItem )
    {
        CcString theCommand = menuItem->command;
        SendCommand(theCommand);
        return;
    }

    LOGERR("CrModel:MenuSelected Model cannot find menu item id = " + CcString(id));
    return;
}


void CrModel::Update(bool rescale)
{
  if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->Update(rescale);
  else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
}


void CrModel::GetValue()
{
//Return all the selected atoms in the current format, followed by END.
  if(m_ModelDoc) m_ModelDoc->SendAtoms(m_AtomSelectAction,true);
  SendCommand ( "END" );
}

int CrModel::GetSelectionAction()
{
  return m_AtomSelectAction;
}

Boolean CrModel::RenderModel(Boolean detailed)
{
//    TEXTOUT ( "RenderModel" );
    m_style.high_res = detailed;
    if(m_ModelDoc) return m_ModelDoc->RenderModel(&m_style);
    return false;
}


void CrModel::SysKey ( UINT nChar )
{
      switch (nChar)
      {
            case CRCONTROL:
                  if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->ChooseCursor(1);
                  else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
                  break;
            default:
                  break;
      }
}

void CrModel::SysKeyUp ( UINT nChar )
{
      switch (nChar)
      {
            case CRCONTROL:
            case CRSHIFT:
                  if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->ChooseCursor(0);
                  else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
                  break;
            default:
                  break;
      }
}


void CrModel::SetText( CcString text )
{

}

void CrModel::SelectFrag(CcString atomname, bool select)
{
  if(m_ModelDoc) m_ModelDoc->SelectFrag(atomname,select);
}

CcModelObject * CrModel::FindObjectByGLName(GLuint name)
{
  if(m_ModelDoc) return m_ModelDoc->FindObjectByGLName(name);
  return NULL;
}

