////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrModel
////////////////////////////////////////////////////////////////////////

//   Filename:  CrModel.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccstring.h"
#include    "ccrect.h"
#include    "crmodel.h"
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

CrModel::CrModel( CrGUIElement * mParentPtr )
 :     CrGUIElement( mParentPtr )
{
  mTabStop = true;
  mXCanResize = true;
  mYCanResize = true;
  mAttachedModelDoc = nil;
  popupMenu1 = nil;
  popupMenu2 = nil;
  popupMenu3 = nil;
  m_AtomSelectAction = CR_SELECT;
  ptr_to_cxObject = CxModel::CreateCxModel( this,(CxGrid *)(mParentPtr->GetWidget()) );
  ((CrWindow*)GetRootWidget())->SendMeSysKeys( (CrGUIElement*) this );
  m_NormalRes = 15;
  m_QuickRes = 5;
}

CrModel::~CrModel()
{
  if(mAttachedModelDoc) mAttachedModelDoc->RemoveView(this);

  if ( ptr_to_cxObject != nil )
  {
    ((CxModel*)ptr_to_cxObject)->DestroyWindow(); delete (CxModel*)ptr_to_cxObject;
    ptr_to_cxObject = nil;
  }

  delete popupMenu1;
  delete popupMenu2;
  delete popupMenu3;

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
          ((CxModel*)ptr_to_cxObject)->SetIdealHeight( chars );
          LOGSTAT( "Setting Model Lines Height: " + theString );
          break;
        }
        case kTNumberOfColumns:
        {
          tokenList->GetToken(); // Remove that token!
          CcString theString = tokenList->GetToken();
          int chars = atoi( theString.ToCString() );
          ((CxModel*)ptr_to_cxObject)->SetIdealWidth( chars );
          LOGSTAT( "Setting Model Chars Width: " + theString );
          break;
        }
        default:
        {
          hasTokenForMe = false;
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
            ((CxModel*)ptr_to_cxObject)->SetRadiusType( COVALENT );
            tokenList->GetToken(); // Remove that token!
            break;
          }
          case kTVDW:
          {
            ((CxModel*)ptr_to_cxObject)->SetRadiusType( VDW );
            tokenList->GetToken(); // Remove that token!
            break;
          }
          case kTThermal:
          {
            ((CxModel*)ptr_to_cxObject)->SetRadiusType( THERMAL );
            tokenList->GetToken(); // Remove that token!
            break;
          }
          case kTSpare:
          {
            ((CxModel*)ptr_to_cxObject)->SetRadiusType( SPARE );
            tokenList->GetToken(); // Remove that token!
            break;
          }
        }
        break;
      }
      case kTRadiusScale:
      {
        tokenList->GetToken(); // Remove that token!
        CcString theString = tokenList->GetToken();
        int chars = atoi( theString.ToCString() );
        ((CxModel*)ptr_to_cxObject)->SetRadiusScale( chars );
        break;
      }
      case kTAttachModel:
      {
        tokenList->GetToken();
        CcString name = tokenList->GetToken();
        if( ( mAttachedModelDoc = (CcController::theController)->FindModelDoc(name) ) != nil )
            mAttachedModelDoc->AddModelView(this);
        else
        {
          mAttachedModelDoc = (CcController::theController)->CreateModelDoc(name);
          mAttachedModelDoc->AddModelView(this);
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
               popupMenu1 = mMenuPtr;
               break;
             case 2:
               popupMenu2 = mMenuPtr;
               break;
             case 3:
               popupMenu3 = mMenuPtr;
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
          if(mAttachedModelDoc) mAttachedModelDoc->SelectAllAtoms(select);
        }
        else if( tokenList->GetDescriptor(kLogicalClass) == kTInvert)
        {
          tokenList->GetToken(); //Remove the kTInvert token!
          if(mAttachedModelDoc) mAttachedModelDoc->InvertSelection();
        }
        else
        {
          CcString atomLabel = tokenList->GetToken();
          Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
          tokenList->GetToken(); //Remove the kTYes/kTNo token
          if(mAttachedModelDoc) mAttachedModelDoc->SelectAtomByLabel(atomLabel,select);
        }
        break;
      }
      case kTDisableAtoms:
      {
        tokenList->GetToken(); //Remove the kTDisableAtoms token!
        CcString atomLabel = tokenList->GetToken();
        Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
        tokenList->GetToken(); //Remove the kTYes/kTNo token
        if(mAttachedModelDoc) mAttachedModelDoc->DisableAtomByLabel(atomLabel,select);
        break;
      }
      case kTCheckValue:
      {
        tokenList->GetToken();
        CcString atomLabel = tokenList->GetToken();
        if(mAttachedModelDoc)
        {
          CcModelAtom* atom = mAttachedModelDoc->FindAtomByLabel(atomLabel);
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
        m_NormalRes = atoi( theString.ToCString() );
        break;
      }
      case kTQRes:
      {
        tokenList->GetToken();
        CcString theString = tokenList->GetToken();
        m_QuickRes = atoi( theString.ToCString() );
        break;
      }
      case kTStyle:
      {
        tokenList->GetToken();
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
          case kTStyleSmooth:
            ((CxModel*)ptr_to_cxObject)->SetDrawStyle( MODELSMOOTH );
            tokenList->GetToken();
            break;
          case kTStyleLine:
            ((CxModel*) ptr_to_cxObject)->SetDrawStyle( MODELLINE );
            tokenList->GetToken();
            break;
          case kTStylePoint:
            ((CxModel*) ptr_to_cxObject)->SetDrawStyle( MODELPOINT );
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
        ((CxModel*) ptr_to_cxObject)->SetAutoSize( size );
        break;
      }
      case kTHover:
      {
        tokenList->GetToken();
        Boolean hover = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
        tokenList->GetToken(); // Remove that token!
        ((CxModel*) ptr_to_cxObject)->SetHover( hover );
        break;
      }
      case kTShading:
      {
        tokenList->GetToken();
        Boolean shading = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
        tokenList->GetToken(); // Remove that token!
        ((CxModel*) ptr_to_cxObject)->SetShading( shading );
        break;
      }
      case kTSelectTool:
      {
        tokenList->GetToken();
        Boolean bRect = true;
        if (tokenList->GetDescriptor(kLogicalClass) == kTSelectRect)
        {
          tokenList->GetToken();
          ((CxModel*)ptr_to_cxObject)->SelectTool(CXRECTSEL);
        }
        else if (tokenList->GetDescriptor(kLogicalClass) == kTSelectPoly)
        {
          tokenList->GetToken();
          ((CxModel*)ptr_to_cxObject)->SelectTool(CXPOLYSEL);
        }
        else
        {
          ((CxModel*)ptr_to_cxObject)->SelectTool(CXRECTSEL);
        }
        break;
      }
      case kTRotateTool:
      {
        tokenList->GetToken();
        ((CxModel*)ptr_to_cxObject)->SelectTool(CXROTATE);
        break;
      }
      case kTZoomSelected:
      {
        tokenList->GetToken();
        if (tokenList->GetDescriptor(kLogicalClass) == kTYes)
        {
          tokenList->GetToken();
          ZoomSelected(true);
        }
        else if (tokenList->GetDescriptor(kLogicalClass) == kTNo)
        {
          tokenList->GetToken();
          ZoomSelected(false);
        }
        else
        {
          ZoomSelected(false);
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
  ((CxModel*)ptr_to_cxObject)->Focus();
}

int CrModel::GetIdealWidth()
{
  return ((CxModel*)ptr_to_cxObject)->GetIdealWidth();
}
int CrModel::GetIdealHeight()
{
  return ((CxModel*)ptr_to_cxObject)->GetIdealHeight();
}

void CrModel::LMouseClick(int x, int y)
{
  CcString command = "LCLICK ";
  CcString cx = CcString(x);
  CcString cy = CcString(y);
  SendCommand(command + cx + " " + cy);
}

void CrModel::DocRemoved()
{
  mAttachedModelDoc = nil;
}


void CrModel::ContextMenu(int x, int y, CcString atomname, int nSelected, CcString* atomNames)
{
    CcString nameOfMenuToUse;
    CrMenu* theMenu = nil;
    if ( atomname == "" )      // The user has clicked on nothing. Display general menu.
    {
        theMenu = popupMenu1;
    }
    else if ( nSelected != 0 ) // The user has clicked on a set of selected atoms.
    {
        theMenu = popupMenu2;
    }
    else                       // The user has clicked on a single atom.
    {
        theMenu = popupMenu3;
    }

    if(theMenu !=nil)
    {
        theMenu->Substitute(atomname, nSelected, atomNames);
        theMenu->Popup(x,y,(void*)ptr_to_cxObject);
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


void CrModel::PrepareToGetAtoms()
{
  if(mAttachedModelDoc) mAttachedModelDoc->PrepareToGetAtoms();
}

void CrModel::PrepareToGetBonds()
{
  if(mAttachedModelDoc) mAttachedModelDoc->PrepareToGetBonds();
}

void CrModel::ExcludeBonds()
{
  if(mAttachedModelDoc) mAttachedModelDoc->ExcludeBonds();
}

CcModelAtom* CrModel::GetModelAtom()
{
  if(mAttachedModelDoc) return mAttachedModelDoc->GetModelAtom();
  return nil;
}

CcModelBond* CrModel::GetModelBond()
{
  if(mAttachedModelDoc) return mAttachedModelDoc->GetModelBond();
  return nil;
}


void CrModel::Update()
{
  ((CxModel*)ptr_to_cxObject)->Update();
}

CcModelAtomPtr * CrModel::GetAllAtoms(int * nAtoms)
{
  CcModelAtom * anAtom;
  int i=0;

  *nAtoms = 0;
//Count the number of selected atoms.
   PrepareToGetAtoms();
   while ( (anAtom = GetModelAtom()) != nil ) { (*nAtoms)++; };

   CcModelAtomPtr * atoms;

   atoms = new CcModelAtomPtr[*nAtoms];

//Get all the  atoms. Store pointers to them.
   PrepareToGetAtoms();
   while ( (anAtom = GetModelAtom()) != nil ) { atoms[i++].atom = anAtom; };
   return atoms;
}

CcModelAtomPtr* CrModel::GetSelectedAtoms(int * nSelected)
{
  CcModelAtom *anAtom;
  int i=0;

  *nSelected = 0;
//Count the number of selected atoms.
   PrepareToGetAtoms();
   while ( (anAtom = GetModelAtom()) != nil )
   {
     if(anAtom->IsSelected()) (*nSelected)++;
   }

   CcModelAtomPtr *atoms = new CcModelAtomPtr[*nSelected];

//Get all the selected atoms. Store pointers to them.
   PrepareToGetAtoms();
   while ( (anAtom = GetModelAtom()) != nil )
   {
     if(anAtom->IsSelected()) atoms[i++].atom = anAtom;
   }
   return atoms;
}

void CrModel::GetValue()
{
//Return all the selected atoms in the current format, followed by END.
  CcModelAtomPtr* atoms;
  int nAtoms, i;

  atoms = GetSelectedAtoms(&nAtoms);

  for (i = 0; i < nAtoms; i++)
  {
    SendAtom(atoms[i].atom,true); //True ensures that if the action is SELECT or APPEND, then SENDA is used instead.
  }
  SendCommand("END");

  delete [] atoms;
}


void CrModel::ZoomSelected(bool doZoom)
{

  (CcController::theController)->status.SetZoomedFlag(doZoom);

  CcModelAtomPtr * atoms;

  int nAtoms, i;

  if ( doZoom )
  {
    atoms = GetAllAtoms(&nAtoms);
    for (i=0; i<nAtoms; i++) { atoms[i].atom->m_excluded=true; }

    atoms = GetSelectedAtoms(&nAtoms);
    for (i=0; i<nAtoms; i++) { atoms[i].atom->m_excluded=false;}
  }
  else
  {
    atoms = GetAllAtoms(&nAtoms);
    for (i=0; i<nAtoms; i++) { atoms[i].atom->m_excluded=false; }
  }

  ExcludeBonds();

  Update();

  delete [] atoms;
}


void CrModel::SendAtom(CcModelAtom * atom, Boolean output)
{
  int style = (output) ? CR_SENDA : m_AtomSelectAction;

  if (atom->m_disabled) return;

  CcString atomname = atom->Label();
  switch ( style )
  {
    case CR_SELECT:
    {
      atom->Select();
      Update();
      break;
    }
    case CR_APPEND:
    {
      ((CrEditBox*)(CcController::theController)->GetInputPlace())->AddText(" "+atomname+" ");
      break;
    }
    case CR_SENDA:
    {
      SendCommand(atomname);
      break;
    }
    case CR_SENDB:
    {
      CcString element, number;
      int pos1 = 1, pos2 = 1;
      for (int i = 1; i < atomname.Length(); i++)
      {
        if ( atomname[i] == '(' )
        {
          pos1 = i+1;
          element = atomname.Sub(1,pos1-1);
        }
        if ( atomname[i] == ')' )
        {
          pos2 = i+1;
          number = atomname.Sub(pos1+1, pos2-1);
        }
      }
      if ( ( pos1 != 1 ) && ( pos2 != 1 ) )
      {
        SendCommand(element + "_N" + number);
      }
      break;
    }
    case CR_SENDC:
    {
      SendCommand("ATOM_N" + atomname);
      break;
    }
    case CR_SENDD:
    {
      CcString element, number;
      int pos1 = 1, pos2 = 1;
      for (int i = 1; i < atomname.Length(); i++)
      {
        if ( atomname[i] == '(' )
        {
          pos1 = i+1;
          element = atomname.Sub(1,pos1-1);
        }
        if ( atomname[i] == ')' )
        {
          pos2 = i+1;
          number = atomname.Sub(pos1+1, pos2-1);
        }
      }
      if ( ( pos1 != 1 ) && ( pos2 != 1 ) )
      {
        SendCommand("ATOM_N" + element + "_N" + number);
      }
      break;
    }
    case CR_SENDC_AND_SELECT:
    {
      CcString cSet = (atom->Select()) ? "SET" : "UNSET" ;
      Update();
      SendCommand("ATOM_N" + atomname + "_N" + cSet);
      break;
    }
  }
}

Boolean CrModel::RenderModel(Boolean detailed)
{
//    TEXTOUT ( "RenderModel" );
    if(mAttachedModelDoc) return mAttachedModelDoc->RenderModel(this,detailed);

    return false;
}


CcModelAtom* CrModel::LitAtom()
{
      return ((CxModel*)ptr_to_cxObject)->m_LitAtom;
}

int CrModel::RadiusType()
{
      return ((CxModel*)ptr_to_cxObject)->m_radius;
}

float CrModel::RadiusScale()
{
      return ((CxModel*)ptr_to_cxObject)->m_radscale;
}

void CrModel::SysKey ( UINT nChar )
{
      switch (nChar)
      {
            case CRCONTROL:
                  ((CxModel*)ptr_to_cxObject)->ChooseCursor(1);
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
                  ((CxModel*)ptr_to_cxObject)->ChooseCursor(0);
                  break;
            default:
                  break;
      }
}


void    CrModel::SetText( CcString text )
{

}

void    CrModel::SelectFrag(CcString atomname, bool select)
{
  if(mAttachedModelDoc) mAttachedModelDoc->SelectFrag(atomname,select);
}
