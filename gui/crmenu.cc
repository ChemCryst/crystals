////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenu

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMenu.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   08.6.1998 02:01 Uhr
//   Modified:  08.6.1998 02:01 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crmenu.h"
#include	"ccmenuitem.h"
//insert your own code here.
//#include	"crgrid.h"
#include	"cxmenu.h"
#include	"ccrect.h"
#include	"crwindow.h"
#include	"cxwindow.h"
#include	"cccontroller.h"	// for sending commands


CrMenu::CrMenu( CrGUIElement * mParentPtr )
   : CrGUIElement( mParentPtr )
{
      mWidgetPtr = CxMenu::CreateCxMenu( this, (CxMenu *)(mParentPtr->GetWidget()) );
	mTabStop = true;
}

CrMenu::CrMenu( CrGUIElement * mParentPtr, Boolean isAPopupMenu )
 :CrGUIElement( mParentPtr )
{
	mWidgetPtr = CxMenu::CreateCxMenu( this, (CxMenu *)(mParentPtr->GetWidget()), true );
	mTabStop = true;
}

CrMenu::~CrMenu()
{
	if ( mWidgetPtr != nil )
	{
		delete (CxMenu*)mWidgetPtr;
		mWidgetPtr = nil;
	}

	mMenuList.Reset();
	CcMenuItem* theItem = (CcMenuItem*)mMenuList.GetItem();
	
	while ( theItem != nil )
	{
		if(theItem->type == CR_SUBMENU)
		{
			delete (CrMenu*)theItem->ptr;
		}
		delete theItem;
		mMenuList.RemoveItem();
		theItem = (CcMenuItem*)mMenuList.GetItem();
	}
	
}

Boolean	CrMenu::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	Boolean isMainMenu = false;

	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** Menu *** Initing...");
		mName = tokenList->GetToken();
		if ( tokenList->GetDescriptor(0) == kTNull )
		{
			isMainMenu = true;
		}
		mText = tokenList->GetToken();
		SetText(mText);
		mSelfInitialised = true;
		LOGSTAT( "*** Created Menu      " + mName );
	}
	// End of Init, now comes the general parser
	
	while ( hasTokenForMe )
	{
		switch ( tokenList->GetDescriptor(kAttributeClass) )
		{
			case kTMenu:
			{
				CrMenu* mMenuPtr = new CrMenu( this );
				if ( mMenuPtr != nil )
				{
					tokenList->GetToken();
					// ParseInput generates all objects in the menu
					// Of course the token list must be full
					retVal = mMenuPtr->ParseInput( tokenList );
					if ( ! retVal )
					{
						delete mMenuPtr;
						mMenuPtr = nil;
					}
				}
				CcMenuItem* menuItem = new CcMenuItem(this);
				menuItem->type = CR_SUBMENU;
				menuItem->text = menuItem->originaltext = mMenuPtr->mText;
				menuItem->name = mMenuPtr->mName;
				menuItem->command = nil;
				menuItem->ptr = mMenuPtr;
				Boolean moreTokens = true;
				while ( moreTokens )
				{
					switch ( tokenList->GetDescriptor(kAttributeClass) )
					{
						case kTMenuDisableCondition:
						{
							tokenList->GetToken();
							menuItem->disable = Condition( tokenList->GetToken() );
							break;
						}
						case kTMenuEnableCondition:
						{
							tokenList->GetToken();
							menuItem->enable = Condition( tokenList->GetToken() );
							break;
						}
						default:
						{
							moreTokens = false;
							break;
						}
					}
				}

				menuItem->id = ((CxMenu*)mWidgetPtr)->AddMenu((CxMenu*)menuItem->ptr->GetWidget(),(char*)menuItem->text.ToCString());
				mMenuList.AddItem(menuItem);

//                        TRACE("Created Sub Menu (type %d), Name = %s, Command = nil, Pointer = %d, DisableCondition = %d\n",
//                              menuItem->type, menuItem->name.ToCString(), (int)menuItem->ptr, menuItem->disable);
				break;
			}
			case kTMenuItem:
			{
				tokenList->GetToken();
				CcMenuItem* menuItem = new CcMenuItem(this);
				menuItem->type = CR_MENUITEM;
				menuItem->name = tokenList->GetToken();
				menuItem->text    = menuItem->originaltext    = tokenList->GetToken();
				menuItem->command = menuItem->originalcommand = tokenList->GetToken();
				menuItem->ptr = nil;
				Boolean moreTokens = true;
				while ( moreTokens )
				{
					switch ( tokenList->GetDescriptor(kAttributeClass) )
					{
						case kTMenuDisableCondition:
						{
							tokenList->GetToken();
							menuItem->disable = Condition( tokenList->GetToken() );
							break;
						}
						case kTMenuEnableCondition:
						{
							tokenList->GetToken();
							menuItem->enable = Condition( tokenList->GetToken() );
							break;
						}
						default:
						{
							moreTokens = false;
							break;
						}
					}
				}
				menuItem->id = ((CxMenu*)mWidgetPtr)->AddItem((char*)menuItem->text.ToCString());
				mMenuList.AddItem(menuItem);
//                        TRACE("Created MenuItem (type %d), Name = %s, Command = %s, Pointer = nil, DisableCondition = %d\n",
//                              menuItem->type, menuItem->text.ToCString(), menuItem->command.ToCString(), menuItem->disable);
				break;
			}
			case kTMenuSplit:
			{
				tokenList->GetToken();
				CcMenuItem* menuItem = new CcMenuItem(this);
				menuItem->type = CR_SPLIT;
				menuItem->name = nil;
				menuItem->text = nil;
				menuItem->command = nil;
				menuItem->ptr = nil;
				menuItem->disable = nil;
				mMenuList.AddItem(menuItem);
				((CxMenu*)mWidgetPtr)->AddItem();
//                        TRACE("Created Menu splitter (type %d)\n", menuItem->type);
				break;
			}
			case kTEndMenu:
			{
				tokenList->GetToken();
				hasTokenForMe = false;
				break; // We leave the token in the list and exit the loop
			}	
			default:
			{
				hasTokenForMe = false;
//				TRACE("Unknown token %s\n", tokenList->GetToken().ToCString());
				break; // We leave the token in the list and exit the loop
			}
		}
	}
	
	if(isMainMenu)
	{
		CrWindow* parentWindow = (CrWindow*)GetRootWidget();
		parentWindow->SetMainMenu(this);
	}
	
	return retVal;
//End of user code.         
}
// OPSignature: void CrMenu:SetText( CcString:text ) 
void	CrMenu::SetText( CcString text )
{
//Insert your own code here.
//End of user code.         
}






// OPSignature: void CrMenu:SetGeometry( const CcRect *:rect ) 
void	CrMenu::SetGeometry( const CcRect * rect )
{
//Insert your own code here.
	NOTUSED(rect);
	LOGWARN("CrMenu:SetGeometry Bad Script: Attempt to set geometry of a menu.");
//End of user code.         
}
// OPSignature: CcRect CrMenu:GetGeometry() 
CcRect	CrMenu::GetGeometry()
{
//Insert your own code here.
	LOGWARN("CrMenu:GetGeometry Bad Script: Attempt to get geometry of a menu.");
	CcRect retVal (0,0,0,0);
	return retVal;
//End of user code.         
}
// OPSignature: void CrMenu:CalcLayout() 
void	CrMenu::CalcLayout()
{
//Insert your own code here.
	LOGWARN("CrMenu:CalcLayout Bad Script: Attempt to calc layout of a menu.");
//End of user code.         
}
// OPSignature: void CrMenu:MenuClicked() 
void CrMenu::CrFocus()
{
	LOGWARN("CrMenu:CrFocus Bad Script: Attempt to set focus on a menu. ");
}

int CrMenu::Condition(CcString conditions)
{
	return (CcController::theController)->status.CreateFlag(conditions);
}


CcMenuItem* CrMenu::FindItembyID(int id)
{
	CcMenuItem* retVal = nil;
	CcMenuItem* menuItem = nil;
	mMenuList.Reset();
//While there are more items in list AND the item has not been found.
	while( ( menuItem = (CcMenuItem*)mMenuList.GetItemAndMove() ) && ( retVal == nil )) //Assignment inside conditional (OK)
	{
		if (menuItem->type == CR_SUBMENU)
		{
			retVal = menuItem->ptr->FindItembyID(id);
		}
		else if (menuItem->type == CR_MENUITEM)
		{
			if ( menuItem->id == id ) retVal = menuItem;
		}
	}
	return retVal;
}

void CrMenu::Popup(int x, int y, void * window)
{
      ((CxMenu*)mWidgetPtr)->PopupMenuHere(x,y,window);
//      ((CxMenu*)mWidgetPtr)->TrackPopupMenu(
//                                          TPM_LEFTALIGN | TPM_LEFTBUTTON | TPM_RIGHTBUTTON,
//                                          x, y, (CWnd*)window); 
//To do: hide the base class call above in the CxMenu class.
//DONE.
}

void CrMenu::Substitute(CcString atomname, int nSelected, CcString* atomNames)
{
//Replace all occurences of _A in the command and text fields with the atomname.
//Replace all occurences of _G in the command with a newline seperated list of atom names, followed by END.	
	CcMenuItem* menuItem = nil;
	CcString acommand, atext;
	mMenuList.Reset();
	while( menuItem = (CcMenuItem*)mMenuList.GetItemAndMove() )  //Assignment inside conditional (OK)
	{
		if (menuItem->type == CR_SUBMENU)
		{
			menuItem->ptr->Substitute(atomname, nSelected, atomNames);
			atext    = menuItem->originaltext;
			int i; 
			for (i = 0; i < atext.Len()-1; i++)
			{
				if(atext[i] == '_' && atext[i+1] == 'A')
				{
					CcString firstPart = atext.Chop(i+1,atext.Len());
					CcString lastPart  = atext.Chop(1,i+2);
					atext = firstPart + atomname + lastPart;
				}
			}
			menuItem->SetText(atext);
		}
		else if (menuItem->type == CR_MENUITEM)
		{
			acommand = menuItem->originalcommand;
			atext    = menuItem->originaltext;
			int i; 
			for (i = 0; i < acommand.Len()-1; i++)
			{
				if(acommand[i] == '_' && acommand[i+1] == 'A')
				{
					CcString firstPart = acommand.Chop(i+1,acommand.Len());
					CcString lastPart  = acommand.Chop(1,i+2);
					acommand = firstPart + atomname + lastPart;
				}
			}
			for (i = 0; i < acommand.Len()-1; i++)
			{
				if(acommand[i] == '_' && acommand[i+1] == 'G')
				{
					CcString firstPart = acommand.Chop(i+1,acommand.Len());
					CcString lastPart  = acommand.Chop(1,i+2);
					acommand = firstPart;
					for (int k=0; k<nSelected; k++)
					{
						acommand += atomNames[k] + "_N";
					}
					acommand +=	"END _N" + lastPart;
				}
			}

			
			for (i = 0; i < atext.Len()-1; i++)
			{
				if(atext[i] == '_' && atext[i+1] == 'A')
				{
					CcString firstPart = atext.Chop(i+1,atext.Len());
					CcString lastPart  = atext.Chop(1,i+2);
					atext = firstPart + atomname + lastPart;
				}
			}
			menuItem->command = acommand;
			menuItem->SetText(atext);
			if ( (CcController::theController)->status.ShouldBeEnabled( menuItem->enable, menuItem->disable ) )
                        ((CxMenu*)mWidgetPtr)->EnableItem( menuItem->id, true);
			else
                        ((CxMenu*)mWidgetPtr)->EnableItem( menuItem->id, false);
		}
	}

}
