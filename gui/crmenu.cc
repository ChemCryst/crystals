////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenu

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMenu.cc
//   Authors:   Richard Cooper and Ludwig Macko

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "crconstants.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "cxmenu.h"
#include    "ccrect.h"
#include    "crwindow.h"
#include    "cccontroller.h"    // for sending commands
#include    "ccmodeldoc.h"


CrMenu::CrMenu( CrGUIElement * mParentPtr, int menuType )
 :CrGUIElement( mParentPtr )
{
      switch ( menuType )
      {
            case NORMAL_MENU:
                  ptr_to_cxObject = CxMenu::CreateCxMenu( this, (CxMenu *)(mParentPtr->GetWidget()) );
                  break;
            case POPUP_MENU:
                  ptr_to_cxObject = CxMenu::CreateCxMenu( this, (CxMenu *)(mParentPtr->GetWidget()), true );
                  break;
      }
      mMenuType = menuType;
}

CrMenu::~CrMenu()
{

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

#ifdef __CR_WIN__
//for wx version, only delete the top level menu bar.
    if ( ptr_to_cxObject != nil )
    {
        delete (CxMenu*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
#endif

}

CcParse CrMenu::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Menu *** Initing...");
        mName = tokenList->GetToken();
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
                    if ( ! retVal.OK() )
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

                menuItem->id = ((CxMenu*)ptr_to_cxObject)->AddMenu((CxMenu*)menuItem->ptr->GetWidget(),(char*)menuItem->text.ToCString());
                mMenuList.AddItem(menuItem);
                (CcController::theController)->AddMenuItem(menuItem);
                break;
            }
            case kTItem:
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
                menuItem->id = ((CxMenu*)ptr_to_cxObject)->AddItem((char*)menuItem->text.ToCString());
                mMenuList.AddItem(menuItem);
                (CcController::theController)->AddMenuItem(menuItem);
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
                menuItem->id = ((CxMenu*)ptr_to_cxObject)->AddItem();
                (CcController::theController)->AddMenuItem(menuItem);
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
//              TRACE("Unknown token %s\n", tokenList->GetToken().ToCString());
                break; // We leave the token in the list and exit the loop
            }
        }
    }


    return retVal;
}

void    CrMenu::SetText( CcString text )
{

}

void    CrMenu::SetGeometry( const CcRect * rect )
{
    NOTUSED(rect);
    LOGWARN("CrMenu:SetGeometry Bad Script: Attempt to set geometry of a menu.");
}

CcRect CrMenu::GetGeometry()
{
    LOGWARN("CrMenu:GetGeometry Bad Script: Attempt to get geometry of a menu.");
    return CcRect(0,0,0,0);
}

CcRect CrMenu::CalcLayout(bool recalc)
{
    LOGWARN("CrMenu:CalcLayout Bad Script: Attempt to calc layout of a menu.");
    return CcRect(0,0,0,0);
}

void CrMenu::CrFocus()
{
    LOGWARN("CrMenu:CrFocus Bad Script: Attempt to set focus on a menu. ");
}

int CrMenu::Condition(CcString conditions)
{
    return (CcController::theController)->status.CreateFlag(conditions);
}

void CrMenu::Popup(int x, int y, void * window)
{
      ((CxMenu*)ptr_to_cxObject)->PopupMenuHere(x,y,window);
}

void CrMenu::Substitute(CcString atomname, CcModelDoc* model)
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
            menuItem->ptr->Substitute(atomname, model);
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
                    acommand =  firstPart;
                    acommand += model->SelectedAsString("_N");
                    acommand += lastPart;
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
                  {
                              ((CxMenu*)ptr_to_cxObject)->EnableItem( menuItem->id, true);
                  }
                  else
                  {
                              ((CxMenu*)ptr_to_cxObject)->EnableItem( menuItem->id, false);
                  }
        }
    }

}

void CrMenu::Substitute(PlotDataPopup data)
{
//Replace all occurences of:
// _D in the command and text fields with the popup text.
// _S with the seriesname
// _X with the x value (a text label for bar graphs)
// _Y with the y value
// _L with the label (scatterpoints only)

	if(data.m_Valid == false) return;

    CcMenuItem* menuItem = nil;
    CcString acommand, atext;
    mMenuList.Reset();
    while( menuItem = (CcMenuItem*)mMenuList.GetItemAndMove() )  //Assignment inside conditional (OK)
    {
        if (menuItem->type == CR_SUBMENU)
        {
            menuItem->ptr->Substitute(data);
            atext    = menuItem->originaltext;
            int i;
            for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'D')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_PopupText + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'S')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_SeriesName + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'X')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_XValue + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'Y')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_YValue + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'L')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_Label + lastPart;
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
                if(acommand[i] == '_' && acommand[i+1] == 'D')
                {
                    CcString firstPart = acommand.Chop(i+1,acommand.Len());
                    CcString lastPart  = acommand.Chop(1,i+2);
                    acommand = firstPart + data.m_PopupText + lastPart;
                }
            }
            for (i = 0; i < acommand.Len()-1; i++)
            {
                if(acommand[i] == '_' && acommand[i+1] == 'S')
                {
                    CcString firstPart = acommand.Chop(i+1,acommand.Len());
                    CcString lastPart  = acommand.Chop(1,i+2);
                    acommand = firstPart + data.m_SeriesName + lastPart;
                }
            }
            for (i = 0; i < acommand.Len()-1; i++)
            {
                if(acommand[i] == '_' && acommand[i+1] == 'X')
                {
                    CcString firstPart = acommand.Chop(i+1,acommand.Len());
                    CcString lastPart  = acommand.Chop(1,i+2);
                    acommand = firstPart + data.m_XValue + lastPart;
                }
            }
            for (i = 0; i < acommand.Len()-1; i++)
            {
                if(acommand[i] == '_' && acommand[i+1] == 'Y')
                {
                    CcString firstPart = acommand.Chop(i+1,acommand.Len());
                    CcString lastPart  = acommand.Chop(1,i+2);
                    acommand = firstPart + data.m_YValue + lastPart;
                }
            }
            for (i = 0; i < acommand.Len()-1; i++)
            {
                if(acommand[i] == '_' && acommand[i+1] == 'L')
                {
                    CcString firstPart = acommand.Chop(i+1,acommand.Len());
                    CcString lastPart  = acommand.Chop(1,i+2);
                    acommand = firstPart + data.m_Label + lastPart;
                }
            }
            for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'D')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_PopupText + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'S')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_SeriesName + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'X')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_XValue + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'Y')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_YValue + lastPart;
                }
            }
			for (i = 0; i < atext.Len()-1; i++)
            {
                if(atext[i] == '_' && atext[i+1] == 'L')
                {
                    CcString firstPart = atext.Chop(i+1,atext.Len());
                    CcString lastPart  = atext.Chop(1,i+2);
                    atext = firstPart + data.m_Label + lastPart;
                }
            }
            menuItem->command = acommand;
            menuItem->SetText(atext);
            if ( (CcController::theController)->status.ShouldBeEnabled( menuItem->enable, menuItem->disable ) )
            {
                 ((CxMenu*)ptr_to_cxObject)->EnableItem( menuItem->id, true);
            }
            else
            {
                 ((CxMenu*)ptr_to_cxObject)->EnableItem( menuItem->id, false);
            }
        }
    }
}
