////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModel.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crmodel.h"
#include	"crgrid.h"
#include	"crmenu.h"
#include	"ccmenuitem.h"
#include	"cxmodel.h"
#include    "ccmodeldoc.h"
#include	"ccrect.h"
#include	"cctokenlist.h"
#include	"cccontroller.h"	// for sending commands
#include	"creditbox.h"      //appends could be done through cccontroller for better separation.
#include	"ccmodelatom.h"
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
	mWidgetPtr = CxModel::CreateCxModel( this,
								(CxGrid *)(mParentPtr->GetWidget()) );
        ((CrWindow*)GetRootWidget())->SendMeSysKeys( (CrGUIElement*) this );
      m_NormalRes = 15;
      m_QuickRes = 5;

}

CrModel::~CrModel()
{
	if(mAttachedModelDoc)
		mAttachedModelDoc->RemoveView(this);

	if ( mWidgetPtr != nil )
	{
		delete (CxModel*)mWidgetPtr;
		mWidgetPtr = nil;
	}

	delete popupMenu1;
	delete popupMenu2;
	delete popupMenu3;

}

Boolean	CrModel::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** Model *** Initing...");

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
                              ((CxModel*)mWidgetPtr)->SetIdealHeight( chars );
                              LOGSTAT( "Setting Model Lines Height: " + theString );
                              break;
                        }
                        case kTNumberOfColumns:
                        {
                              tokenList->GetToken(); // Remove that token!
                              CcString theString = tokenList->GetToken();
                              int chars = atoi( theString.ToCString() );
                              ((CxModel*)mWidgetPtr)->SetIdealWidth( chars );
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
					LOGSTAT( "Enabling ListCtrl callback" );
				else
					LOGSTAT( "Disabling ListCtrl callback" );
				break;
			}
			case kTRadiusType:
			{
				tokenList->GetToken(); // Remove that token!
				switch ( tokenList->GetDescriptor(kAttributeClass) )
				{
					case kTCovalent:
					{
						((CxModel*)mWidgetPtr)->SetRadiusType( COVALENT );
						tokenList->GetToken(); // Remove that token!
						break;
					}
					case kTVDW:
					{
						((CxModel*)mWidgetPtr)->SetRadiusType( VDW );
						tokenList->GetToken(); // Remove that token!
						break;
					}
                              case kTThermal:
					{
                                    ((CxModel*)mWidgetPtr)->SetRadiusType( THERMAL );
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
				((CxModel*)mWidgetPtr)->SetRadiusScale( chars );
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
					retVal = mMenuPtr->ParseInput( tokenList );
					if ( ! retVal )
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
				retVal = true;
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
					if(mAttachedModelDoc)
						mAttachedModelDoc->SelectAllAtoms(select);
				}
				else if( tokenList->GetDescriptor(kLogicalClass) == kTInvert)
				{
					tokenList->GetToken(); //Remove the kTInvert token!
					if(mAttachedModelDoc)
						mAttachedModelDoc->InvertSelection();
				}
				else
				{
					CcString atomLabel = tokenList->GetToken();
					Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
					tokenList->GetToken(); //Remove the kTYes/kTNo token
					if(mAttachedModelDoc)
						mAttachedModelDoc->SelectAtomByLabel(atomLabel,select);
				}
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
						if (atom->IsSelected())
							(CcController::theController)->SendCommand("SET");
						else
							(CcController::theController)->SendCommand("UNSET");
					}
					else
						LOGERR("CrModel:ParseInput:kTCheckValue No such atom");
				}
				else
					LOGERR("CrModel:ParseInput:kTCheckValue Sent a CheckValue request, but there is no attached ModelDoc");

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
                                    ((CxModel*)mWidgetPtr)->SetDrawStyle( MODELSMOOTH );
                                    tokenList->GetToken();
                                    break;
                              case kTStyleLine:
                                    ((CxModel*) mWidgetPtr)->SetDrawStyle( MODELLINE );
                                    tokenList->GetToken();
                                    break;
                              case kTStylePoint:
                                    ((CxModel*) mWidgetPtr)->SetDrawStyle( MODELPOINT );
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
                        ((CxModel*) mWidgetPtr)->SetAutoSize( size );
				break;
                  }
                  case kTHover:
			{
				tokenList->GetToken();
                        Boolean hover = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
                        ((CxModel*) mWidgetPtr)->SetHover( hover );
				break;
                  }
                  case kTShading:
			{
				tokenList->GetToken();
                        Boolean shading = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
				tokenList->GetToken(); // Remove that token!
                        ((CxModel*) mWidgetPtr)->SetShading( shading );
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
void	CrModel::SetGeometry( const CcRect * rect )
{
	((CxModel*)mWidgetPtr)->SetGeometry(	rect->mTop,
											rect->mLeft,
											rect->mBottom,
											rect->mRight );
}
CcRect	CrModel::GetGeometry()
{
      CcRect retVal (   ((CxModel*)mWidgetPtr)->GetTop(), 
				((CxModel*)mWidgetPtr)->GetLeft(),
				((CxModel*)mWidgetPtr)->GetTop()+ ((CxModel*)mWidgetPtr)->GetHeight(),
				((CxModel*)mWidgetPtr)->GetLeft()+((CxModel*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void	CrModel::CalcLayout()
{
	int w = (int)(mWidthFactor  * (float)((CxModel*)mWidgetPtr)->GetIdealWidth() );
	int h = (int)(mHeightFactor * (float)((CxModel*)mWidgetPtr)->GetIdealHeight());
	((CxModel*)mWidgetPtr)->SetGeometry(-1,-1,h,w);	
}

void CrModel::CrFocus()
{
	((CxModel*)mWidgetPtr)->Focus();	
}

void	CrModel::SetText( CcString text )
{
	char theText[256];
	strcpy( theText, text.ToCString() );

	( (CxModel *)mWidgetPtr)->SetText( theText );
}

//void CrModel::ReDrawView()
//{
//      if(mAttachedModelDoc)
//            mAttachedModelDoc->DrawView(this);
//}

int CrModel::GetIdealWidth()
{
	return ((CxModel*)mWidgetPtr)->GetIdealWidth();
}
int CrModel::GetIdealHeight()
{
	return ((CxModel*)mWidgetPtr)->GetIdealHeight();
}


//void CrModel::Clear()
//{
//      ((CxModel*)mWidgetPtr)->Clear();
//}

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

//void CrModel::Start()
//{
 //     ((CxModel *)mWidgetPtr)->Start();
//}

//void CrModel::DrawAtom(CcModelAtom* anAtom)
//{
//      ((CxModel*)mWidgetPtr)->DrawAtom(anAtom);
//}

//void CrModel::Display()
//{
//      ((CxModel *)mWidgetPtr)->Display();
//}





//void CrModel::DrawBond(int x1, int y1, int z1, int x2, int y2, int z2, int r, int g, int b, int rad)
//{
 //     ((CxModel*)mWidgetPtr)->DrawBond(x1,y1,z1,x2,y2,z2,r,g,b,rad);
//}

//void CrModel::DrawTri(int x1, int y1, int z1, int x2, int y2, int z2, int x3, int y3, int z3, int r, int g, int b, Boolean fill)
//{
//      ((CxModel*)mWidgetPtr)->DrawTri(x1,y1,z1,x2,y2,z2,x3,y3,z3,r,g,b,fill);
//}

CcModelAtom* CrModel::GetModelAtom()
{
      if(mAttachedModelDoc)
            return mAttachedModelDoc->GetModelAtom();
      else
            return nil;
}

//void CrModel::ReDrawHighlights()
//{
 //     if(mAttachedModelDoc)
//           mAttachedModelDoc->ReDrawHighlights(false);
//}


//void CrModel::HighlightAtom(CcModelAtom * theAtom)
//{
//      ((CxModel*)mWidgetPtr)->HighlightAtom(theAtom);
//}

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
	else					   // The user has clicked on a single atom.
	{
		theMenu = popupMenu3;
	}
	
	if(theMenu !=nil)
	{
		theMenu->Substitute(atomname, nSelected, atomNames);
		theMenu->Popup(x,y,(void*)mWidgetPtr);
	}
}

void CrModel::MenuSelected(int id)
{
	CcMenuItem* menuItem = nil; 
	if (popupMenu1 != nil)
	{
		if (menuItem = popupMenu1->FindItembyID( id )) //Assignment.
		{
			CcString theCommand = menuItem->command;
			SendCommand(theCommand);
			return;
		}
	}

	if (popupMenu2 != nil)
	{
		if (menuItem = popupMenu2->FindItembyID( id )) //Assignment.
		{
			CcString theCommand = menuItem->command;
			SendCommand(theCommand);
			return;
		}
	}
	
	if (popupMenu3 != nil)
	{
		if (menuItem = popupMenu3->FindItembyID( id )) //Assignment.
		{
			CcString theCommand = menuItem->command;
			SendCommand(theCommand);
			return;
		}
	}

	LOGERR("CrModel:MenuSelected Model cannot find menu item id = " + CcString(id));
	return;
}


void CrModel::PrepareToGetAtoms()
{
      if(mAttachedModelDoc)
            mAttachedModelDoc->PrepareToGetAtoms();
}

void CrModel::Update()
{
      ((CxModel*)mWidgetPtr)->Update();
}

CcModelAtom* CrModel::GetSelectedAtoms(int * nSelected)
{

      CcModelAtom *atom;
      int i=0;

      *nSelected = 0;
      //Count the number of selected atoms.
      PrepareToGetAtoms();
      while ( (atom = GetModelAtom()) != nil )
      {
            if(atom->IsSelected()) (*nSelected)++;
      }

      CcModelAtom *atoms = new CcModelAtom[*nSelected];

      //Get all the selected atoms. Store pointers to them.
      PrepareToGetAtoms();
      while ( (atom = GetModelAtom()) != nil )
      {
            if(atom->IsSelected())
                  atoms[i++] = *atom;
      }

     return atoms;
}

void CrModel::GetValue()
{
	//Return all the selected atoms in the current format, followed by END.
	CcModelAtom* atoms;
	int nAtoms, i;

	atoms = GetSelectedAtoms(&nAtoms);

	for (i = 0; i < nAtoms; i++)
	{
		SendAtom(&atoms[i],true); //True ensures that if the action is SELECT or APPEND, then SENDA is used instead.
	}
	SendCommand("END");
}

void CrModel::SendAtom(CcModelAtom * atom, Boolean output)
{
      int style = (output) ? CR_SENDA : m_AtomSelectAction;

	CcString atomname = atom->Label();
	switch ( style )
	{
		case CR_SELECT:
		{
			atom->Select();
//                  ReDrawHighlights();
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
//                  ReDrawHighlights();
                  Update();
			SendCommand("ATOM_N" + atomname + "_N" + cSet);
			break;
		}
	}

}

//void CrModel::Reset()
//{
//    ((CxModel*)mWidgetPtr)->Reset();
//}
//void CrModel::StartHighlights()
//{
//    ((CxModel*)mWidgetPtr)->StartHighlights();
//}
//void CrModel::FinishHighlights()
//{
//    ((CxModel*)mWidgetPtr)->FinishHighlights();
//}



void CrModel::RenderModel(Boolean detailed)
{
    if(mAttachedModelDoc)
            mAttachedModelDoc->RenderModel(this,detailed);
}      


CcModelAtom* CrModel::LitAtom()
{
      return ((CxModel*)mWidgetPtr)->m_LitAtom;
}

int CrModel::RadiusType()
{
      return ((CxModel*)mWidgetPtr)->m_radius;
}

float CrModel::RadiusScale()
{
      return ((CxModel*)mWidgetPtr)->m_radscale;
}

void CrModel::SysKey ( UINT nChar )
{
      switch (nChar)
      {
            case CRCONTROL:
                  ((CxModel*)mWidgetPtr)->ChooseCursor(1);
                  break;
            case CRSHIFT:
                  ((CxModel*)mWidgetPtr)->ChooseCursor(2);
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
                  ((CxModel*)mWidgetPtr)->ChooseCursor(0);
                  break;
            default:
                  break;
      }
}
