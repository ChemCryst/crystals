////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CrModel
////////////////////////////////////////////////////////////////////////

//   Filename:  CrModel.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.39  2011/05/17 14:44:12  rich
//   Don't remove string twice.
//
//   Revision 1.38  2011/05/16 10:56:32  rich
//   Added pane support to WX version. Added coloured bonds to model.
//
//   Revision 1.37  2009/09/04 09:25:46  rich
//   Added support for Show/Hide H from model toolbar
//   Fixed atom picking after model update in extra model windows.
//
//   Revision 1.36  2009/07/23 14:15:42  rich
//   Removed all uses of OpenGL feedback buffer - was dreadful slow on some new graphics cards.
//
//   Revision 1.35  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.34  2004/11/09 09:45:03  rich
//   Removed some old stuff. Don't use displaylists on the Mac version.
//
//   Revision 1.33  2004/06/29 15:15:30  rich
//   Remove references to unused kTNoMoreToken. Protect against reading
//   an empty list of tokens.
//
//   Revision 1.32  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.31  2004/04/16 12:43:44  rich
//   Speed up for  OpenGL rendering: Use new lighting scheme, drop use of
//   two sets of displaylists for rendering a 'low res' model while rotating -
//   it's faster not too.
//
//   Revision 1.30  2003/05/12 12:01:19  rich
//   RIC: Oops; roll back some unintentional check-ins.
//
//   Revision 1.28  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.27  2002/10/02 13:43:17  rich
//   New ModList class added.
//
//   Revision 1.26  2002/07/23 08:25:43  richard
//
//   Moved selected, disabled and excluded variables and functions into the base class.
//   Added ALL option to DISABLEATOM to enable/disable all atoms.
//
//   Revision 1.25  2002/07/18 16:48:55  richard
//   Prevent crash if some popup menus are missing/not defined from the model window.
//
//   Revision 1.24  2002/07/04 13:04:44  richard
//
//   glPassThrough was causing probs on Latitude notebook. Can only be called in feedback
//   mode, which means that it can't be stuck into the display lists which are used
//   for drawing aswell. Instead, added feedback logical parameter into all Render calls, when
//   true it does a "feedback" render rather than a display list render. Will slow down polygon
//   selection a negligble amount.
//
//   Revision 1.23  2002/06/28 10:09:53  richard
//   Minor gui update enabling vague display of special shapes: ring and sphere.
//
//   Revision 1.22  2002/03/13 12:26:26  richard
//   One new popupmenu for clicking on bonds.
//
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
#include    <string>
#include    <sstream>
using namespace std;
#include    "ccrect.h"
#include    "crgrid.h"
#include    "crmenu.h"
#include    "crmultiedit.h"
#include    "ccmenuitem.h"
#include    "cxmodel.h"
#include    "ccmodeldoc.h"
#include    "cccontroller.h"    // for sending commands
#include    "creditbox.h"      //appends could be done through cccontroller for better separation.
#include    "ccmodelatom.h"
#include    "ccmodelbond.h"
#include        "crwindow.h"      // for getting syskeys
#ifdef CRY_OSMAC
#include    <OpenGL/glu.h>
#else
#include    <GL/glu.h>
#endif
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
  m_InsertWindow = nil;
  ptr_to_cxObject = CxModel::CreateCxModel( this,(CxGrid *)(mParentPtr->GetWidget()) );
  ((CrWindow*)GetRootWidget())->SendMeSysKeys( (CrGUIElement*) this );
  m_style.normal_res = 15;
  m_style.radius_type = CRCOVALENT;
  m_style.radius_scale = 0.25;
  m_style.m_modview = (CxModel*)ptr_to_cxObject;
  m_style.showh = true;
  m_style.bond_style = BONDSTYLE_HALFPARENTPART;
  m_style.min_peak_height_to_show = -99999;
}

CrModel::~CrModel()
{
  if(m_ModelDoc) m_ModelDoc->RemoveView(this);

  if ( ptr_to_cxObject )
  {
    ((CxModel*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
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


CcParse CrModel::ParseInput( deque<string> &  tokenList )
{
  CcParse retVal(true, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    retVal = CrGUIElement::ParseInput( tokenList );
    mSelfInitialised = true;
    LOGSTAT( "*** Created Model      " + mName );

    hasTokenForMe = true;
    while ( hasTokenForMe && ! tokenList.empty() )
    {
      switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
      {
        case kTNumberOfRows:
        {
          tokenList.pop_front(); // Remove that token!
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SetIdealHeight( atoi( tokenList.front().c_str() ) );
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
          LOGSTAT( "Setting Model Lines Height: " + tokenList.front() );
          tokenList.pop_front(); // Remove that token!
          break;
        }
        case kTNumberOfColumns:
        {
          tokenList.pop_front(); // Remove that token!
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SetIdealWidth( atoi( tokenList.front().c_str() ) );
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
          LOGSTAT( "Setting Model Chars Width: " + tokenList.front() );
          tokenList.pop_front();
          break;
        }
        default:
        {
          hasTokenForMe = false;
//          string bitmap = (CcController::theController)->GetKey( mName );
//          ((CxModel*)ptr_to_cxObject)->LoadDIBitmap(bitmap);

          break;
        }
      }
    }
  }
// End of Init, now comes the general parser

  hasTokenForMe = true;
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
        if (mCallbackState)
            LOGSTAT( "Enabling Model callback" );
        else
            LOGSTAT( "Disabling Model callback" );
        break;
      }
      case kTRadiusType:
      {
        tokenList.pop_front(); // Remove that token!
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
          case kTCovalent:
          {
            m_style.radius_type = CRCOVALENT;
            break;
          }
          case kTVDW:
          {
            m_style.radius_type = CRVDW;
            break;
          }
          case kTThermal:
          {
            m_style.radius_type = CRTHERMAL;
            break;
          }
          case kTTiny:
          {
            m_style.radius_type = CRTINY;
            break;
          }
          case kTSpare:
          {
            m_style.radius_type = CRSPARE;
            break;
          }
        }
        Update(true);
        tokenList.pop_front(); // Remove that token!
        break;
      }
      case kTBondStyle:
      {
        tokenList.pop_front(); // Remove that token!
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
          case kTNormal:
          {
            m_style.bond_style = BONDSTYLE_BLACK;
            break;
          }
          case kTPart:
          {
            m_style.bond_style = BONDSTYLE_HALFPARENTPART;
            break;
          }
          case kTElement:
          {
            m_style.bond_style = BONDSTYLE_HALFPARENTELEMENT;
            break;
          }
        }
        Update(true);
        tokenList.pop_front(); // Remove that token!
        break;
      }
      case kTRadiusScale:
      {
        tokenList.pop_front(); // Remove that token!
        m_style.radius_scale = float(atoi(tokenList.front().c_str()))/1000.0f;
        tokenList.pop_front();
        Update(true);
        break;
      }
      case kTMinPeakHeight:
      {
        tokenList.pop_front(); // Remove that token!
        m_style.min_peak_height_to_show = atoi(tokenList.front().c_str());
        tokenList.pop_front();
        Update(true);
        break;
      }
      case kTShowH:
      {
        tokenList.pop_front(); // Remove that token!
        bool select = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes);
        tokenList.pop_front();
        m_style.showh = select;
        Update(true);
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
      case kTSelectAction:
      {
        tokenList.pop_front(); // Remove that token!
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
          case kTSelect:
            tokenList.pop_front();
            m_AtomSelectAction = CR_SELECT;
            break;
          case kTAppendTo:
            tokenList.pop_front();
            m_AtomSelectAction = CR_APPEND;
            break;
          case kTSendA:
            tokenList.pop_front();
            m_AtomSelectAction = CR_SENDA;
            break;
          case kTSendB:
            tokenList.pop_front();
            m_AtomSelectAction = CR_SENDB;
            break;
          case kTSendC:
            tokenList.pop_front();
            m_AtomSelectAction = CR_SENDC;
            break;
          case kTSendCAndSelect:
            tokenList.pop_front();
            m_AtomSelectAction = CR_SENDC_AND_SELECT;
            break;
          case kTInsertIn:
            tokenList.pop_front();
            m_AtomSelectAction = CR_INSERTIN;
//			LOGERR(tokenList.front());
			m_InsertWindow = (CrMultiEdit*) GetRootWidget()->FindObject(tokenList.front());
			if ( m_InsertWindow == nil ) {
//		        LOGERR("Insert editor window not found");
				m_InsertWindow = (CrMultiEdit*) (CcController::theController)->FindObject(tokenList.front());				
				if ( m_InsertWindow == nil ) {
			        LOGERR("Insert editor window not found.");
				} //else {
//					LOGERR("Insert editor finally found :) ");
//				}
//			} else {
//				LOGERR("Insert editor found :) ");
			}
//			LOGERR(tokenList.front());
			tokenList.pop_front();
            break;
        }
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
             case 4:
               m_popupMenu4 = mMenuPtr;
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
      case kTSelectAtoms:
      {
        tokenList.pop_front(); //Remove the kTSelectAtoms token!
        if( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTAll)
        {
          tokenList.pop_front(); //Remove the kTAll token!
          bool select = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes);
          tokenList.pop_front();
          if(m_ModelDoc) m_ModelDoc->SelectAllAtoms(select);
        }
        else if( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTInvert)
        {
          tokenList.pop_front(); //Remove the kTInvert token!
          if(m_ModelDoc) m_ModelDoc->InvertSelection();
        }
        else
        {
          string atomLabel = string(tokenList.front());
          tokenList.pop_front();
          bool select = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes);
          tokenList.pop_front(); //Remove the kTYes/kTNo token
          if(m_ModelDoc) m_ModelDoc->SelectAtomByLabel(atomLabel,select);
        }
        break;
      }
      case kTDisableAtoms:
      {
        tokenList.pop_front(); //Remove the kTDisableAtoms token!

        if( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTAll)
        {
          tokenList.pop_front(); //Remove the kTAll token!
          bool select = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes);
          tokenList.pop_front();
          if(m_ModelDoc) m_ModelDoc->DisableAllAtoms(select);
        }
        else
        {
          string atomLabel = tokenList.front();
          tokenList.pop_front();
          bool select = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes);
          tokenList.pop_front(); //Remove the kTYes/kTNo token
          if(m_ModelDoc) m_ModelDoc->DisableAtomByLabel(atomLabel,select);
        }
        break;
      }
      case kTCheckValue:
      {
        tokenList.pop_front();
        if(m_ModelDoc)
        {
          CcModelObject* oitem = m_ModelDoc->FindAtomByLabel(tokenList.front());
          if (oitem)
          {
            if ( oitem->Type()==CC_ATOM )
            {
              if (((CcModelAtom*)oitem)->IsSelected()) (CcController::theController)->SendCommand("SET");
              else                                     (CcController::theController)->SendCommand("UNSET");
            }
            else if ( oitem->Type()==CC_SPHERE )
            {
              if (((CcModelSphere*)oitem)->IsSelected()) (CcController::theController)->SendCommand("SET");
              else                                     (CcController::theController)->SendCommand("UNSET");
            }
            else if ( oitem->Type()==CC_DONUT )
            {
              if (((CcModelDonut*)oitem)->IsSelected()) (CcController::theController)->SendCommand("SET");
              else                                     (CcController::theController)->SendCommand("UNSET");
            }

          }
          else LOGERR("CrModel:ParseInput:kTCheckValue No such atom:" + tokenList.front());
        }
        else LOGERR("CrModel:ParseInput:kTCheckValue Sent a CheckValue request, but there is no attached ModelDoc");
        tokenList.pop_front();
        break;
      }
      case kTNRes:
      {
        tokenList.pop_front();
        m_style.normal_res = atoi( tokenList.front().c_str() );
        tokenList.pop_front();
        break;
      }
      case kTStyle:
      {
        tokenList.pop_front();
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
          case kTStyleSmooth:
            if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SetDrawStyle( MODELSMOOTH );
            else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
            tokenList.pop_front();
            break;
          case kTStyleLine:
            if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetDrawStyle( MODELLINE );
            else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
            tokenList.pop_front();
            break;
          case kTStylePoint:
            if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetDrawStyle( MODELPOINT );
            else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
            tokenList.pop_front();
            break;
        }
        break;
      }
      case kTAutoSize:
      {
        tokenList.pop_front();
        bool size = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
        tokenList.pop_front(); // Remove that token!
        if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetAutoSize( size );
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTHover:
      {
        tokenList.pop_front();
        bool hover = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
        tokenList.pop_front(); // Remove that token!
        if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetHover( hover );
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTShading:
      {
        tokenList.pop_front();
        bool shading = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
        tokenList.pop_front(); // Remove that token!
        if ( ptr_to_cxObject ) ((CxModel*) ptr_to_cxObject)->SetShading( shading );
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTSelectTool:
      {
        tokenList.pop_front();
        bool bRect = true;
        if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTSelectRect)
        {
          tokenList.pop_front();
          if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SelectTool(CXRECTSEL);
          else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        }
        else if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTSelectPoly)
        {
          tokenList.pop_front();
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
        tokenList.pop_front();
        if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->SelectTool(CXROTATE);
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
        break;
      }
      case kTZoomSelected:
      {
        tokenList.pop_front();
        if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes)
        {
          tokenList.pop_front();
          if(m_ModelDoc) m_ModelDoc->ZoomAtoms(true);
          (CcController::theController)->status.SetZoomedFlag(true);
          Update(true);
        }
        else if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTNo)
        {
          tokenList.pop_front();
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
        tokenList.pop_front();
        string atomname = string(tokenList.front());
        tokenList.pop_front();
        if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes)
        {
          tokenList.pop_front();
          SelectFrag(atomname,true);
        }
        else if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTNo)
        {
          tokenList.pop_front();
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
        tokenList.pop_front();
        LOGERR ( "ModelWindow no longer supports BITMAP background keyword.");
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


void CrModel::SendInsertText( string s )
{

	if ( m_InsertWindow ) {
		m_InsertWindow->InsertAtom(s);
	}

}


void CrModel::ContextMenu(int x, int y, string atomname, int selection, string atom2)
{
    if ( m_ModelDoc == nil ) return;

//    string nameOfMenuToUse;
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


    if(theMenu)
    {
        theMenu->Substitute(atomname, m_ModelDoc, atom2);
        if ( ptr_to_cxObject ) theMenu->Popup(x,y,(void*)ptr_to_cxObject);
        else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
    }
}

void CrModel::MenuSelected(int id)
{
    CcMenuItem* menuItem = CrMenu::FindMenuItem( id );

    if ( menuItem )
    {
        string theCommand = menuItem->command;
        SendCommand(theCommand);
        return;
    }


    ostringstream strm;
    strm << "CrModel:MenuSelected Model cannot find menu item id = " << id ;
    LOGERR(strm.str());
    return;
}


void CrModel::Update(bool rescale)
{
  if ( ptr_to_cxObject ) ((CxModel*)ptr_to_cxObject)->CxUpdate(rescale);
  else LOGERR ( "Unusable ModelWindow " + mName + ": failed to create.");
}

void CrModel::ApplyIndexColour( GLuint indx ) {
     if ( ptr_to_cxObject )
        ((CxModel*)ptr_to_cxObject)->ApplyIndexColour( indx );
}

void CrModel::GetValue()
{
//Return all the selected atoms in the current format, followed by END.
  if(m_ModelDoc) m_ModelDoc->SendAtoms(m_AtomSelectAction,true);
  SendCommand ( "END" );
}

void CrModel::GetValue(deque<string> &  tokenList)
{
    int desc = CcController::GetDescriptor( tokenList.front(), kQueryClass );

    if( desc == kTQBondStyle )
    {
        tokenList.pop_front();
		switch ( m_style.bond_style ) {
			case BONDSTYLE_BLACK:
				SendCommand( "NORMAL", true );
				break;
            case BONDSTYLE_HALFPARENTPART:
				SendCommand( "PART", true );
				break;
            case BONDSTYLE_HALFPARENTELEMENT:
				SendCommand( "ELEMENT", true );
				break;
  		    default:
			    SendCommand( "BONDSTYLEUNKNOWN",true );
				LOGWARN( "CrModel:GetValue Error unrecognised bond style ");
				break;
		}
    }
    else if (desc == kTQAtomStyle )
    {
        tokenList.pop_front();
		switch ( m_style.radius_type ) {
            case CRCOVALENT:
				SendCommand( "COVALENT" , true );
				break;
            case CRVDW:
				SendCommand( "VDW" , true );
				break;
            case CRTHERMAL:
				SendCommand( "THERMAL" , true );
				break;
			case CRSPARE:
				SendCommand( "SPARE" , true );
				break;
			case CRTINY:
				SendCommand( "TINY" , true );
				break;
			default:
				SendCommand( "ATOMSTYLEUNKNOWN" , true );
				LOGWARN( "CrModel:GetValue Error unrecognised atom style ");
				break;
		}
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrModel:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }


}


int CrModel::GetSelectionAction()
{
  return m_AtomSelectAction;
}

bool CrModel::RenderModel()
{
    if(m_ModelDoc) return m_ModelDoc->RenderModel(&m_style);
    return false;
}
bool CrModel::RenderAtoms(bool feedback)
{
    if(m_ModelDoc) return m_ModelDoc->RenderAtoms(&m_style,feedback);
    return false;
}
bool CrModel::RenderBonds(bool feedback)
{
    if(m_ModelDoc) return m_ModelDoc->RenderBonds(&m_style,feedback);
    return false;
}

CcRect CrModel::FindModel2DExtent(float * mat)
{
	if(m_ModelDoc) {
		return m_ModelDoc->FindModel2DExtent(mat, &m_style);
    }
	return CcRect(0,0,1,1);
}

std::list<Cc2DAtom> CrModel::AtomCoords2D(float * mat) {
	return m_ModelDoc->AtomCoords2D(mat);
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


void CrModel::SetText( const string &text )
{

}

void CrModel::SelectFrag(string atomname, bool select)
{
  if(m_ModelDoc) m_ModelDoc->SelectFrag(atomname,select);
}

CcModelObject * CrModel::FindObjectByGLName(GLuint name)
{
  if(m_ModelDoc) return m_ModelDoc->FindObjectByGLName(name);
  return NULL;
}
