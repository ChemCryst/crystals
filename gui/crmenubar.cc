////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenuBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMenuBar.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   08.6.1998 02:01 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.3  2001/06/17 15:14:14  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.2  2001/03/08 16:44:06  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    "ccstring.h"
#include    "crconstants.h"
#include    "crmenubar.h"
#include    "ccmenuitem.h"
#include    "crmenu.h"
#include    "cxmenu.h"
#include    "cxmenubar.h"
#include    "ccrect.h"
#include    "crwindow.h"
#include    "cxwindow.h"
#include    "cccontroller.h"    // for sending commands

CrMenuBar::CrMenuBar( CrGUIElement * mParentPtr )
 :CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxMenuBar::CreateCxMenu( this, (CxWindow *)(mParentPtr->GetWidget()));
}

CrMenuBar::~CrMenuBar()
{
    mMenuList.Reset();
    CcMenuItem* theItem = (CcMenuItem*) mMenuList.GetItem();

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
    if ( ptr_to_cxObject != nil )
    {
        delete (CxMenuBar*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
#endif

}

CcParse CrMenuBar::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;
    bool isMainMenu = false;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Menu *** Initing...");
        mName = tokenList->GetToken();
        isMainMenu = true;
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
                CcMenuItem* menuItem = new CcMenuItem(nil);
                menuItem->type = CR_SUBMENU;
                menuItem->text = menuItem->originaltext = mMenuPtr->mText;
                menuItem->name = mMenuPtr->mName;
                menuItem->command = nil;
                menuItem->ptr = mMenuPtr;
                bool moreTokens = true;
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

                menuItem->id = ((CxMenuBar*)ptr_to_cxObject)->AddMenu((CxMenu*)menuItem->ptr->GetWidget(),(char*)menuItem->text.ToCString());
                mMenuList.AddItem(menuItem);
                (CcController::theController)->AddMenuItem(menuItem);
                break;
            }
            case kTItem:
            {
                tokenList->GetToken();
                CcMenuItem* menuItem = new CcMenuItem(nil);
                menuItem->type = CR_MENUITEM;
                menuItem->name = tokenList->GetToken();
                menuItem->text    = menuItem->originaltext    = tokenList->GetToken();
                menuItem->command = menuItem->originalcommand = tokenList->GetToken();
                menuItem->ptr = nil;
                bool moreTokens = true;
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
                menuItem->id = ((CxMenuBar*)ptr_to_cxObject)->AddItem((char*)menuItem->text.ToCString());
                mMenuList.AddItem(menuItem);
                (CcController::theController)->AddMenuItem(menuItem);
                break;
            }
            case kTMenuSplit:
            {
                tokenList->GetToken();
                CcMenuItem* menuItem = new CcMenuItem(nil);
                menuItem->type = CR_SPLIT;
                menuItem->name = nil;
                menuItem->text = nil;
                menuItem->command = nil;
                menuItem->ptr = nil;
                menuItem->disable = nil;
                mMenuList.AddItem(menuItem);
                menuItem->id = ((CxMenuBar*)ptr_to_cxObject)->AddItem();
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
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    CrWindow* parentWindow = (CrWindow*)GetRootWidget();
    parentWindow->SetMainMenu(this);

    return retVal;
}

void    CrMenuBar::SetText( CcString text )
{

}

void    CrMenuBar::SetGeometry( const CcRect * rect )
{
    NOTUSED(rect);
    LOGWARN("CrMenuBar:SetGeometry Bad Script: Attempt to set geometry of a menu.");
}

CcRect  CrMenuBar::GetGeometry()
{
    LOGWARN("CrMenuBar:GetGeometry Bad Script: Attempt to get geometry of a menu.");
    CcRect retVal (0,0,0,0);
    return retVal;
}

CcRect CrMenuBar::CalcLayout(bool recalc)
{
    LOGWARN("CrMenuBar:CalcLayout Bad Script: Attempt to calc layout of a menu.");
    return CcRect(0,0,0,0);
}

void CrMenuBar::CrFocus()
{
    LOGWARN("CrMenuBar:CrFocus Bad Script: Attempt to set focus on a menu. ");
}

int CrMenuBar::Condition(CcString conditions)
{
    return (CcController::theController)->status.CreateFlag(conditions);
}
