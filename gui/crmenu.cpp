//////////////////////////////9//////////////////////////////////////////

//   CRYSTALS Interface      Class CrMenu

////////////////////////////////////////////////////////////////////////

//   Filename:  CrMenu.cc
//   Authors:   Richard Cooper and Ludwig Macko

#include    "crystalsinterface.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    "crconstants.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "cxmenu.h"
#include    "ccrect.h"
#include    "crwindow.h"
#include    "cccontroller.h"    // for sending commands
#include    "ccmodeldoc.h"


static list<CcMenuItem*>  mMenuItemList;
static int m_next_id_to_try = kMenuBase;

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
    list<CcMenuItem*>::iterator mili = mMenuList.begin();
    for ( ; mili != mMenuList.end(); mili++ )
    {
       delete *mili;
    }
    mMenuList.clear();


#ifdef CRY_USEMFC
//for wx version, only delete the top level menu bar.
    if ( ptr_to_cxObject != nil )
    {
        delete (CxMenu*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
#endif

}

CcParse CrMenu::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Menu *** Initing...");
        mName = string(tokenList.front());
        tokenList.pop_front();
        mText = string(tokenList.front());
        tokenList.pop_front();

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
                CcMenuItem * menuItem = new CcMenuItem(this);
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

                menuItem->id = ((CxMenu*)ptr_to_cxObject)->AddMenu((CxMenu*)menuItem->ptr->GetWidget(),(char*)menuItem->text.c_str());
                mMenuList.push_back(menuItem);
                AddMenuItem(menuItem);
                break;
            }
            case kTItem:
            {
                tokenList.pop_front();
                CcMenuItem* menuItem = new CcMenuItem(this);
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
                menuItem->id = ((CxMenu*)ptr_to_cxObject)->AddItem((char*)menuItem->text.c_str());
                mMenuList.push_back(menuItem);
                AddMenuItem(menuItem);

                ostringstream strstrm;
                strstrm << "Menu item id: " << menuItem->id;
                LOGSTAT( strstrm.str() );

                break;
            }
            case kTMenuSplit:
            {
                tokenList.pop_front();
                CcMenuItem* menuItem = new CcMenuItem(this);
                menuItem->type = CR_SPLIT;
                menuItem->name = "";
                menuItem->text = "";
                menuItem->command = "";
                menuItem->ptr = nil;
                menuItem->disable = 0;
                mMenuList.push_back(menuItem);
                menuItem->id = ((CxMenu*)ptr_to_cxObject)->AddItem();
                AddMenuItem(menuItem);
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


    return retVal;
}

void    CrMenu::SetText( const string &text )
{
//     ((CxMenu*)ptr_to_cxObject)->SetText(text);
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

int CrMenu::Condition(string conditions)
{
    return (CcController::theController)->status.CreateFlag(conditions);
}

void CrMenu::Popup(int x, int y, void * window)
{
      ((CxMenu*)ptr_to_cxObject)->PopupMenuHere(x,y,window);
}

void CrMenu::Substitute(string atomname, CcModelDoc* model, string atom2)
{
//Replace all occurences of _A in the command and text fields with the atomname.
//Replace all occurences of _S in the command and text fields with atom2.
//Replace all occurences of _G in the command with a newline seperated list of selected atom names, followed by END.
//Replace all occurences of _F in the command with a newline seperated list of fragment atom names, followed by END.

    string acommand, atext;
    list<CcMenuItem*>::iterator mili = mMenuList.begin();
    for ( ; mili != mMenuList.end(); mili ++ )
    {
        string::size_type i;
        if ((*mili)->type == CR_SUBMENU)
        {
            (*mili)->ptr->Substitute(atomname, model, atom2);
            atext    = (*mili)->originaltext;

            i = atext.find("_A");
            if ( i != string::npos ) atext.replace( i, 2, atomname );
            i = atext.find("_S");
            if ( i != string::npos ) atext.replace( i, 2, atom2 );

            (*mili)->SetTitle(atext);
        }
        else if ((*mili)->type == CR_MENUITEM)
        {
            acommand = (*mili)->originalcommand;
            atext    = (*mili)->originaltext;
            int i;

            i = acommand.find("_A");
            if ( i != string::npos ) acommand.replace( i, 2, atomname );
            i = acommand.find("_S");
            if ( i != string::npos ) acommand.replace( i, 2, atom2 );
            i = acommand.find("_G");
            if ( i != string::npos ) acommand.replace( i, 2, model->SelectedAsString("_N") );
            i = acommand.find("_F");
            if ( i != string::npos ) acommand.replace( i, 2, model->FragAsString(atomname,"_N") );

            i = atext.find("_A");
            if ( i != string::npos ) atext.replace( i, 2, atomname );
            i = atext.find("_S");
            if ( i != string::npos ) atext.replace( i, 2, atom2 );

            (*mili)->command = acommand;
            (*mili)->SetText(atext);
            if ( (CcController::theController)->status.ShouldBeEnabled( (*mili)->enable, (*mili)->disable ) )
                 ((CxMenu*)ptr_to_cxObject)->EnableItem( (*mili)->id, true);
            else
                 ((CxMenu*)ptr_to_cxObject)->EnableItem( (*mili)->id, false);
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

    string acommand, atext;
    string::size_type i;
    list<CcMenuItem*>::iterator mili = mMenuList.begin();
    for ( ; mili != mMenuList.end(); mili ++ )
    {
        if ((*mili)->type == CR_SUBMENU)
        {
            (*mili)->ptr->Substitute(data);
            atext    = (*mili)->originaltext;

            i = atext.find("_D");
            if ( i != string::npos ) atext.replace( i, 2, data.m_PopupText );
            i = atext.find("_S");
            if ( i != string::npos ) atext.replace( i, 2, data.m_SeriesName );
            i = atext.find("_X");
            if ( i != string::npos ) atext.replace( i, 2, data.m_XValue );
            i = atext.find("_Y");
            if ( i != string::npos ) atext.replace( i, 2, data.m_YValue );
            i = atext.find("_L");
            if ( i != string::npos ) atext.replace( i, 2, data.m_Label );

            (*mili)->SetText(atext);
        }
        else if ((*mili)->type == CR_MENUITEM)
        {
            acommand = (*mili)->originalcommand;
            atext    = (*mili)->originaltext;

            i = acommand.find("_D");
            if ( i != string::npos ) acommand.replace( i, 2, data.m_PopupText );
            i = acommand.find("_S");
            if ( i != string::npos ) acommand.replace( i, 2, data.m_SeriesName );
            i = acommand.find("_X");
            if ( i != string::npos ) acommand.replace( i, 2, data.m_XValue );
            i = acommand.find("_Y");
            if ( i != string::npos ) acommand.replace( i, 2, data.m_YValue );
            i = acommand.find("_L");
            if ( i != string::npos ) acommand.replace( i, 2, data.m_Label );

            i = atext.find("_D");
            if ( i != string::npos ) atext.replace( i, 2, data.m_PopupText );
            i = atext.find("_S");
            if ( i != string::npos ) atext.replace( i, 2, data.m_SeriesName );
            i = atext.find("_X");
            if ( i != string::npos ) atext.replace( i, 2, data.m_XValue );
            i = atext.find("_Y");
            if ( i != string::npos ) atext.replace( i, 2, data.m_YValue );
            i = atext.find("_L");
            if ( i != string::npos ) atext.replace( i, 2, data.m_Label );

            (*mili)->command = acommand;
            (*mili)->SetText(atext);
            if ( (CcController::theController)->status.ShouldBeEnabled( (*mili)->enable, (*mili)->disable ) )
            {
                 ((CxMenu*)ptr_to_cxObject)->EnableItem( (*mili)->id, true);
            }
            else
            {
                 ((CxMenu*)ptr_to_cxObject)->EnableItem( (*mili)->id, false);
            }
        }
    }
}



int CrMenu::FindFreeMenuId()
{

    m_next_id_to_try++;
    int starting_try = m_next_id_to_try;
    list<CcMenuItem*>::iterator mi;

    while (1)
    {
       bool pointerfree = true;

       for ( mi = mMenuItemList.begin(); mi != mMenuItemList.end(); mi++ )
       {
          if ( (*mi)->id  == m_next_id_to_try )
          {
             pointerfree = false;
             m_next_id_to_try++;

             if ( m_next_id_to_try > ( kMenuBase + 5000 ) )
             {
//Reset id pointer to start:
                m_next_id_to_try = kMenuBase;
             }
             if ( m_next_id_to_try == starting_try )
             {
//No more free id's:
                 return -1;
             }
             break;
          }
       }

       if ( pointerfree ) return m_next_id_to_try;

    }

}

void CrMenu::AddMenuItem( CcMenuItem * menuitem )
{
      mMenuItemList.push_back( menuitem );
      if ( mMenuItemList.size() > 5000 )
      {
         //error
//         std::cerr << "More than 5000 menu items. Rethink or recompile.\n";
         //ASSERT(0);
      }
}

CcMenuItem* CrMenu::FindMenuItem ( int id )
{
   list<CcMenuItem*>::iterator mi;
   for ( mi = mMenuItemList.begin(); mi != mMenuItemList.end(); mi++ )
   {
      if ( (*mi)->id  == id )
      {
         return *mi;
      }
   }
  return nil;
}

CcMenuItem* CrMenu::FindMenuItem ( const string & name )
{
   list<CcMenuItem*>::iterator mi;
   for ( mi = mMenuItemList.begin(); mi != mMenuItemList.end(); mi++ )
   {
      if ( (*mi)->name  == name )
      {
         return *mi;
      }
   }
  return nil;
}

void CrMenu::RemoveMenuItem ( CcMenuItem * menuitem )
{
   mMenuItemList.remove(menuitem);
}

/*
void CrMenu::RemoveMenuItem ( const string & menuitemname )
{
   list<CcMenuItem*>::iterator mi;
   for ( mi = mMenuItemList.begin(); mi != mMenuItemList.end(); )
   {
      if ( (*mi)->name  == menuitemname )
      {
         mMenuItemList.erase(mi);
         break;
      }
   }
}
*/


