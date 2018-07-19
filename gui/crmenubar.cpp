////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenuBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMenuBar.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   08.6.1998 02:01 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.5  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.4  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.3  2001/06/17 15:14:14  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.2  2001/03/08 16:44:06  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    <string>
using namespace std;
#include    "crconstants.h"
#include    "ccmenuitem.h"
#include    "crmenubar.h"
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
    list<CcMenuItem*>::iterator mili = mMenuList.begin();
    for ( ; mili != mMenuList.end(); mili++ )
    {
       delete *mili;
    }
    mMenuList.clear();


#ifdef CRY_USEMFC
    if ( ptr_to_cxObject != nil )
    {
        delete (CxMenuBar*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
#endif

}

CcParse CrMenuBar::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;
    bool isMainMenu = false;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Menu *** Initing...");
        mName = string(tokenList.front());
        tokenList.pop_front();
        isMainMenu = true;
        mText = string(tokenList.front());
        tokenList.pop_front();
        SetText(mText);
        mSelfInitialised = true;
        LOGSTAT( "*** Created Menu      " + mName );
    }
    // End of Init, now comes the general parser

    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTMenu:
            {
                CrMenu* mMenuPtr = new CrMenu( this );
                if ( mMenuPtr != nil )
                {
                    tokenList.pop_front();
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
                menuItem->command = "";
                menuItem->ptr = mMenuPtr;
                bool moreTokens = true;
                while ( moreTokens && !tokenList.empty() )
                {
                    switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
                    {
                        case kTMenuDisableCondition:
                        {
                            tokenList.pop_front();
                            menuItem->disable = Condition( tokenList.front() );
                            tokenList.pop_front();
                            break;
                        }
                        case kTMenuEnableCondition:
                        {
                            tokenList.pop_front();
                            menuItem->enable = Condition( tokenList.front() );
                            tokenList.pop_front();
                            break;
                        }
                        default:
                        {
                            moreTokens = false;
                            break;
                        }
                    }
                }

                menuItem->id = ((CxMenuBar*)ptr_to_cxObject)->AddMenu((CxMenu*)menuItem->ptr->GetWidget(),(char*)menuItem->text.c_str());
                mMenuList.push_back(menuItem);
                CrMenu::AddMenuItem(menuItem);
                break;
            }
            case kTItem:
            {
                tokenList.pop_front();
                CcMenuItem* menuItem = new CcMenuItem(nil);
                menuItem->type = CR_MENUITEM;
                menuItem->name = string(tokenList.front());
                tokenList.pop_front();
                menuItem->text    = menuItem->originaltext    = string(tokenList.front());
                tokenList.pop_front();
                menuItem->command = menuItem->originalcommand = string(tokenList.front());
                tokenList.pop_front();
                menuItem->ptr = nil;
                bool moreTokens = true;
                while ( moreTokens && !tokenList.empty() )
                {
                    switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
                    {
                        case kTMenuDisableCondition:
                        {
                            tokenList.pop_front();
                            menuItem->disable = Condition( tokenList.front() );
                            tokenList.pop_front();
                            break;
                        }
                        case kTMenuEnableCondition:
                        {
                            tokenList.pop_front();
                            menuItem->enable = Condition( tokenList.front() );
                            tokenList.pop_front();
                            break;
                        }
                        default:
                        {
                            moreTokens = false;
                            break;
                        }
                    }
                }
                menuItem->id = ((CxMenuBar*)ptr_to_cxObject)->AddItem((char*)menuItem->text.c_str());
                mMenuList.push_back(menuItem);
                CrMenu::AddMenuItem(menuItem);
                break;
            }
            case kTMenuSplit:
            {
                tokenList.pop_front();
                CcMenuItem* menuItem = new CcMenuItem(nil);
                menuItem->type = CR_SPLIT;
                menuItem->name = "";
                menuItem->text = "";
                menuItem->command = "";
                menuItem->ptr = nil;
                menuItem->disable = nil;
                mMenuList.push_back(menuItem);
                menuItem->id = ((CxMenuBar*)ptr_to_cxObject)->AddItem();
                CrMenu::AddMenuItem(menuItem);
                break;
            }
            case kTEndMenu:
            {
                tokenList.pop_front();
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

void    CrMenuBar::SetText( const string &text )
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

int CrMenuBar::Condition(string conditions)
{
    return (CcController::theController)->status.CreateFlag(conditions);
}
