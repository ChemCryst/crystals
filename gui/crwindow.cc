////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CrWindow.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:26 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.29  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.28  2003/02/27 13:42:01  rich
//   If LARGE specified and window is the MAIN one, then use the desktop
//   size to size to. Change guimenu.ssr to make the main CRYSTALS window LARGE!
//
//   Revision 1.27  2003/02/25 15:36:48  rich
//   New WINDOW modifer "LARGE" makes the given window take up 64% of the area
//   of the Main CRYSTALS window, provided the window doesn't already have a
//   stored size from a previous "KEEP" modifier. This means that the first time
//   windows appear (e.g. Cameron) they don't have to be ridiculously small.
//
//   Revision 1.26  2003/01/15 14:06:29  rich
//   Some fail-safe code in the GUI. In the event of a creation of a window failing don't
//   allow the rest of the windows to be corrupted.
//
//   Revision 1.25  2001/06/17 14:51:29  richard
//   New stayopen property for windows.
//
//   Revision 1.24  2001/03/27 15:15:00  richard
//   Added a timer to the main window that is activated as the main window is
//   created.
//   The timer fires every half a second and causes any messages in the
//   CRYSTALS message queue to be processed. This is not the main way that messages
//   are found and processed, but sometimes the program just seemed to freeze and
//   would stay that way until you moved the mouse. This should (and in fact, does
//   seem to) remedy that problem.
//   Good good good.
//
//   Revision 1.23  2001/03/08 15:46:00  richard
//   Re-written sizing and resizing code. DISABLEIF= and ENABLEIF= flags let
//   you disable a whole non-modal window based on current status.
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crwindow.h"
#include    "crgrid.h"
#include    "crmenubar.h"
#include    "cxmenubar.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "cccontroller.h"
#include    "cxwindow.h"
#include    "ccrect.h"
#include    "crtoolbar.h"

CcList CrWindow::mModalWindowStack;

CrWindow::CrWindow( )
    :   CrGUIElement((CrGUIElement*)NULL)
{
    // For the window object we don't generate the on-screen window immediately
    // because we have to find the attributes first
    ptr_to_cxObject = nil;
    mGridPtr = nil;
    mMenuPtr = nil;
    mTabGroup = new CcList();
    mTabStop = false;
    mIsModal = false;
    mStayOpen = false;
    mIsSizeable = false;
    mCancelSet  = false;
    mCommitSet  = false;
    mCommandSet = false;
    mCommitText = "";
    mCancelText = "";
    mCommandText= "";
    m_relativePosition = kTCentred;
    m_relativeWinPtr = nil;
    mSafeClose=0;
    m_Keep = false;
    m_Large = false;
    m_Shown = false;
    m_AddedToDisableAbleWindowList = false;
    wEnableFlags = 0;
    wDisableFlags = 0;
}


CrWindow::~CrWindow()
{
   
    if (mName == "_MAIN") { LOGSTAT("Closing the main window"); }

    if ( m_Keep )
    {
// Store the old size in a file...
        CcRect currentSize = GetGeometry();
        if ( ( currentSize.Height() > 30 ) &&
             ( currentSize.Width()  > 30 ) )
        {
            (CcController::theController)->StoreKey( mName, currentSize.AsString() );
        }
    }
    if ( mGridPtr != nil )
    {
        delete mGridPtr;
        mGridPtr = nil;
    }
    if ( mMenuPtr != nil )
    {
        delete mMenuPtr;
        mMenuPtr = nil;
    }

    while ( mModalWindowStack.FindItem((void*) this) )
    {
        mModalWindowStack.RemoveItem();
    }

    if ( m_AddedToDisableAbleWindowList )
    {
      CcController::theController->RemoveDisableableWindow(this);
    }

    if ( ptr_to_cxObject != nil )
    {
          ((CxWindow*)ptr_to_cxObject)->CxPreDestroy();  //my function
          ((CxWindow*)ptr_to_cxObject)->CxDestroyWindow(); //MFC function.
// CxWindow is derived from CFrameWnd which is "auto-cleanup"
// which means it deletes itself. No need for this next line:
//        delete (CxWindow*)ptr_to_cxObject;
    }

    delete mTabGroup;
}

CcParse CrWindow::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(false, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( !mSelfInitialised )
    {
        int attributes = 0;

        LOGSTAT("Window");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        void* modalParent = nil;
                if (void* modalParentWindow = mModalWindowStack.GetLastItem()) //NB: Assignment(=), not comparison(==)
                        modalParent = ((CrWindow*)modalParentWindow)->GetWidget();

        // Get attributes
        while ( hasTokenForMe )
        {
            switch ( tokenList->GetDescriptor(kAttributeClass) )
            {
                case kTModal:
                {
                    tokenList->GetToken(); // Remove that token!
                    attributes += kModal;
                    mIsModal = true;
                    mModalWindowStack.AddItem((void*)this);
                    LOGSTAT( "Setting Window modal" );
                    break;
                }
                case kTClose:
                {
                    tokenList->GetToken(); // Remove that token!
                    attributes += kClose;
                    LOGSTAT( "Setting Window hideable" );
                    break;
                }
                case kTZoom:
                {
                    tokenList->GetToken(); // Remove that token!
                    attributes += kZoom;
                    LOGSTAT( "Setting Window zoomable" );
                    break;
                }
                case kTSize:
                {
                    tokenList->GetToken(); // Remove that token!
                    attributes += kSize;
                    mIsSizeable = true;
                    LOGSTAT( "Setting Window sizeable" );
                    break;
                }
                case kTSetCommitText:
                {
                    tokenList->GetToken(); // Remove that token!
                    SetCommitText( tokenList->GetToken() );
                    break;
                }
                case kTSetCancelText:
                {
                    tokenList->GetToken(); // Remove that token!
                    SetCancelText( tokenList->GetToken() );
                    break;
                }
                case kTSetCommandText:
                {
                    tokenList->GetToken(); // Remove that token!
                    SetCommandText( tokenList->GetToken() );
                    break;
                }
                case kTPosition:
                {
                    tokenList->GetToken();
                    m_relativePosition = tokenList->GetDescriptor(kPositionalClass);
                    tokenList->GetToken();
                    CcString nearWindow = tokenList->GetToken();
                    if(!(m_relativeWinPtr = (CcController::theController)->FindObject(nearWindow)))
                        LOGWARN("CrWindow:ParseInput:POSITION Couldn't find window to position near: "+nearWindow);
                    break;
                }
                case kTMenuDisableCondition:
                {
                  tokenList->GetToken();
                  wDisableFlags = (CcController::theController)->status.CreateFlag(tokenList->GetToken());
                  if ( !m_AddedToDisableAbleWindowList )
                  {
                    m_AddedToDisableAbleWindowList = true;
                    CcController::theController->AddDisableableWindow(this);
                  }
                  break;
                }
                case kTMenuEnableCondition:
                {
                  tokenList->GetToken();
                  wEnableFlags = (CcController::theController)->status.CreateFlag(tokenList->GetToken());
                  if ( !m_AddedToDisableAbleWindowList )
                  {
                    m_AddedToDisableAbleWindowList = true;
                    CcController::theController->AddDisableableWindow(this);
                  }
                  break;
                }
                case kTKeep:
                {
                    tokenList->GetToken();
                    m_Keep = true;
                    break;
                }
                case kTLarge:
                {
                    tokenList->GetToken();
                    m_Large = true;
                    break;
                }
                case kTStayOpen:
                {
                    tokenList->GetToken(); // Remove that token!
                    mStayOpen = true;
                    LOGSTAT( "Setting Window to stay open on script exit" );
                    break;
                }
                default:
                {
                    hasTokenForMe = false;
                    break; // We leave the token in the list and exit the loop
                }
            }
        }

        // now create window
        ptr_to_cxObject = CxWindow::CreateCxWindow( this, modalParent, attributes );

        SetText( mText );

        LOGSTAT( "CxWindow created " + mName );
    }

    // If grid is created, but not finished then pass tokenlist straight down.
    {
        if( mGridPtr != nil )
        {
            // SubGrid exists. Testing for completeness
            if(!mGridPtr->GridComplete())
            {
                // SubGrid incomplete passing tokenList
                return retVal = mGridPtr->ParseInput( tokenList );
            }
        }
    }

    // *** This check must be enhanced
    if( tokenList->GetDescriptor( kInstructionClass ) == kTNoMoreToken)
        return true;

    // This is a creategrid instruction, or some window operation, or nothing.
    switch ( tokenList->GetDescriptor( kInstructionClass ) )
    {
        case kTCreateGrid:
        {
            if( mGridPtr != nil )
            {
               LOGERR("Attempt to recreate main window GRID. Not allowed.");
               tokenList->GetToken();  //remove GRID token
               tokenList->GetToken();  //remove GRID name
               tokenList->GetToken();  //remove GRID nrows keyword
               tokenList->GetToken();  //remove GRID nrows value
               tokenList->GetToken();  //remove GRID ncols keyword
               tokenList->GetToken();  //remove GRID ncols value
               retVal.m_ok = true; //Set to true, or we will be destroyed.
               break;
            }


            LOGSTAT("Creating Grid...");

            mGridPtr = new CrGrid( this );
            if ( mGridPtr != nil )
            {
                // remove that token
                tokenList->GetToken();

                // ParseInput generates all objects in the window
                // Of course the token list must be full
                retVal = mGridPtr->ParseInput( tokenList );
                if ( ! retVal.OK() )
                {
                    delete mGridPtr;
                    mGridPtr = nil;
                }
            }
            break;
        }
        case kTShowWindow:
        {
            CcRect newPosn;
            tokenList->GetToken();

// Never re-show the main window - it looks messy, and can easily happen
// in error if a script bombs while setting up another window as the
// SHOW token will end up here.

            if ( m_Shown && ( mName == "_MAIN" ))
            {
               LOGERR("Attempt to re-show main window. Not allowed.");
               retVal.m_ok = true;
               break;
            }

            m_Shown = true;

            CcRect gridRect = this->CalcLayout(true); //First call CalcLayout() on all children.

            LOGSTAT("CrWindow: " + mName + " Child is set to    " + gridRect.AsString() );
            mGridPtr->SetGeometry(&gridRect);
// STEP3 Set the geometry of this window to fit around the child grid.
            SetGeometry( &gridRect );


            if (!m_relativeWinPtr)
            {
// Either no posn specified (in which case centre over _MAIN)
// or invalid window name given, (in which case position relative to _MAIN)
                   m_relativeWinPtr = (CcController::theController)->FindObject( "_MAIN" );
            }

            if(m_relativeWinPtr)
            {
                CcRect winRect(m_relativeWinPtr->GetGeometry());
                CcRect workRect((CcController::theController)->GetScreenArea());
                CcRect thisRect(GetGeometry());
                switch (m_relativePosition)
                {
                    case kTRightOf:
                    {
                        newPosn.mTop    = winRect.Top();
                        newPosn.mBottom = winRect.Top() + thisRect.Height();
                        newPosn.mLeft   = winRect.Right() + EMPTY_CELL;
                        newPosn.mRight  = winRect.Right() + EMPTY_CELL + thisRect.Width();
                        break;
                    }
                    case kTLeftOf:
                    {
                        newPosn.mTop    = winRect.Top();
                        newPosn.mBottom = winRect.Top() + thisRect.Height();
                        newPosn.mRight  = winRect.Left() - EMPTY_CELL;
                        newPosn.mLeft   = winRect.Left() - EMPTY_CELL - thisRect.Width();
                        break;
                    }
                    case kTAbove:
                    {
                        newPosn.mLeft   = winRect.Left();
                        newPosn.mRight  = winRect.Left() + thisRect.Width();
                        newPosn.mBottom = winRect.Top() - EMPTY_CELL;
                        newPosn.mTop    = winRect.Top() - EMPTY_CELL - thisRect.Height();
                        break;
                    }
                    case kTBelow:
                    {
                        newPosn.mLeft   = winRect.Left();
                        newPosn.mRight  = winRect.Left() + thisRect.Width();
                        newPosn.mTop    = winRect.Bottom() + EMPTY_CELL;
                        newPosn.mBottom = winRect.Bottom() + EMPTY_CELL + thisRect.Height();
                        break;
                    }
                    case kTCascade:
                    {
                        newPosn.mLeft   = winRect.Left() + EMPTY_CELL;
                        newPosn.mTop    = winRect.Top()  + EMPTY_CELL;
                        newPosn.mRight  = newPosn.Left() + thisRect.Width() ;
                        newPosn.mBottom = newPosn.Top()  + thisRect.Height();
                        break;
                    }
                    case kTCentred:
                    default:
                    {
                        newPosn.mLeft   = winRect.Left() + ( ( winRect.Width()  - thisRect.Width()  ) / 2 );
                        newPosn.mTop    = winRect.Top()  + ( ( winRect.Height() - thisRect.Height() ) / 2 );
                        newPosn.mRight  = newPosn.Left() + thisRect.Width() ;
                        newPosn.mBottom = newPosn.Top()  + thisRect.Height();
                        break;
                    }
                }

                //Check the right.
                if ( newPosn.Right()  > workRect.Right() )
                {
                    newPosn.mRight  = workRect.Right();
                    newPosn.mLeft   = workRect.Right() - thisRect.Width();
                }
                //Check the left.
                if ( newPosn.Left()   < workRect.Left() )
                {
                    newPosn.mLeft   = workRect.Left();
                    newPosn.mRight  = workRect.Left() + thisRect.Width();
                }
// Check the right again.
// If it is still off the
// screen, we need to
// shrink the window a bit.
                if ( newPosn.Right()  > workRect.Right() )
                {
                    newPosn.mRight  = workRect.Right();
                }

                //Check the bottom.
                if ( newPosn.Bottom() > workRect.Bottom() )
                {
                    newPosn.mBottom = workRect.Bottom();
                    newPosn.mTop    = workRect.Bottom() - thisRect.Height();
                }
                //Check the top.
                if ( newPosn.Top()    < workRect.Top() )
                {
                    newPosn.mTop     = workRect.Top();
                    newPosn.mBottom  = workRect.Top() + thisRect.Height();
                }
// Check the bottom again.
// If it is still off the
// screen, we need to
// shrink the window a bit.
                if ( newPosn.Bottom() > workRect.Bottom() )
                {
                    newPosn.mBottom = workRect.Bottom();
                }


                ((CxWindow*)ptr_to_cxObject)->SetGeometry(   newPosn.Top(),
                                                                  newPosn.Left(),
                                                                  newPosn.Bottom(),
                                                                  newPosn.Right() );
            }

            bool keep_no_info = true;

            if ( m_Keep )
            {
// Get the old size out of a file...
                CcString cgeom = (CcController::theController)->GetKey( mName );
                CcRect oldSize(0,0,0,0);
                if ( cgeom.Len() )
                   oldSize = CcRect( cgeom );

                if (( oldSize.Height() > 10) && ( oldSize.Width() > 10 ))
                {
                   ((CxWindow*)ptr_to_cxObject)->SetGeometry(oldSize.mTop,
                                                             oldSize.mLeft,
                                                             oldSize.mBottom,
                                                             oldSize.mRight );
                   keep_no_info = false;
                }
// NB Direct call to the CxWindow::SetGeometry, avoids the AdjustSize call
// in CrWindow::SetGeometry which adds on height and width for borders and
// menubars.

            }

// Only go large if there is no previous kept size in effect.
            if ( m_Large && keep_no_info ) 
            {
// Make the size large - take up about 80% of the main CRYSTALS window.
// (or 80% of screen if main window isn't found)

               CcRect mainSize(0,0,0,0);
               mainSize = (CcController::theController)->GetScreenArea();
               CrGUIElement *main = (CcController::theController)->FindObject("_MAIN");

               if ( main && ( main != this ))
                  mainSize = main->GetGeometry();

               if ( newPosn.Width() < (int)(0.8 * mainSize.Width()) )
               {
                 mainSize.mLeft  += (int)(mainSize.Width() * 0.1);
                 mainSize.mRight -= (int)(mainSize.Width() * 0.1);
               }
               if ( newPosn.Height() < (int)(0.8 * mainSize.Height()) )
               {
                 mainSize.mTop    += (int)(mainSize.Height() * 0.1);
                 mainSize.mBottom -= (int)(mainSize.Height() * 0.1);
               }

                  
               if (( mainSize.Height() > 10) && ( mainSize.Width() > 10 ))
                ((CxWindow*)ptr_to_cxObject)->SetGeometry(mainSize.mTop,
                                                          mainSize.mLeft,
                                                          mainSize.mBottom,
                                                          mainSize.mRight );
// NB Direct call to the CxWindow::SetGeometry, avoids the AdjustSize call
// in CrWindow::SetGeometry which adds on height and width for borders and
// menubars.

            }

            // Lock the original sizes of all resizable windows.
            // These are needed to calculate how extra space
            // is shared out when the window is resized by the
            // user.


            //For now show self. Children are shown automagically.
            this->Show(true);


            LOGSTAT( "Window '" + mName + "' obeys SHOW");
            retVal.m_ok = true;
            break;
        }
        case kTHideWindow:
        {
            tokenList->GetToken();

            // Hide self
            this->Show(false);

            LOGSTAT( "Window '" + mName + "' obeys HIDE");
            retVal.m_ok = true;
            break;
        }
        case kTDefineMenu:
        {
            tokenList->GetToken();
            LOGSTAT("Defining Menu...");

            mMenuPtr = new CrMenuBar( this );
            if ( mMenuPtr != nil )
            {
                // ParseInput generates all objects in the menu
                // Of course the token list must be full
                retVal = mMenuPtr->ParseInput( tokenList );
                if ( ! retVal.OK() )
                {
                    delete mMenuPtr;
                    mMenuPtr = nil;
                }
            }

            break;
        }
        case kTEndDefineMenu:
        {
            tokenList->GetToken();
            LOGSTAT("Menu Definined.");
            retVal.m_ok = true;
            break;
        }

        case kTTextSelector:
        {
            tokenList->GetToken();
            LOGSTAT("Changing title of window.");
            retVal.m_ok = true;
            mText = tokenList->GetToken();
            SetText( mText );
            break;
        }
        default:
        {
            LOGWARN("CrWindow:ParseInput:default Window cannot recognize token:" + tokenList->PeekToken());
            break;
        }
    }
      LOGSTAT ("Exiting CrWindow::ParseInput");
    return (retVal);
}

void CrWindow::SetGeometry( const CcRect * rect )
{
    CcRect tempRect;
    tempRect.mTop       = rect->mTop;
    tempRect.mLeft      = rect->mLeft;
    tempRect.mBottom    = rect->mBottom;
    tempRect.mRight     = rect->mRight;

//Adjust size adds on the space for menus and borders.
    ((CxWindow*)ptr_to_cxObject)->AdjustSize(&tempRect);

    ((CxWindow*)ptr_to_cxObject)->SetGeometry(tempRect.mTop,
                                           tempRect.mLeft,
                                           tempRect.mBottom,
                                           tempRect.mRight );
}

CRGETGEOMETRY(CrWindow,CxWindow)

CcRect  CrWindow::GetScreenGeometry()
{
    CcRect retVal;
        retVal.Set(     ((CxWindow*)ptr_to_cxObject)->GetScreenTop(),
                        ((CxWindow*)ptr_to_cxObject)->GetScreenLeft(),
                        ((CxWindow*)ptr_to_cxObject)->GetScreenTop()+((CxWindow*)ptr_to_cxObject)->GetHeight(),
                        ((CxWindow*)ptr_to_cxObject)->GetScreenLeft()+((CxWindow*)ptr_to_cxObject)->GetWidth()   );
    return retVal;
}

CcRect CrWindow::CalcLayout(bool recalc)
{
  CcRect childRect;

  if ( mGridPtr != nil )
  {
// Call Calclayout on Child Grid.
    childRect = mGridPtr->CalcLayout(recalc);
  }

  return childRect; //NB. This return value ignored by caller.
}


void    CrWindow::SetText( CcString item )
{
    char theText[256];
    strcpy (theText, item.ToCString() );
    if ( ptr_to_cxObject != nil )
    {
        ((CxWindow*)ptr_to_cxObject)->SetText(theText);
    }
}

void    CrWindow::Show( bool show )
{

    if( show )
    {
        ((CxWindow*)ptr_to_cxObject)->CxShowWindow();

    }
    else
    {
        ((CxWindow*)ptr_to_cxObject)->Hide();
    }
}

void    CrWindow::Align()
{
/*
    if ( mGridPtr != nil )
        mGridPtr->Align();
*/
}

CrGUIElement *  CrWindow::FindObject( CcString Name )
{
    CrGUIElement * theElement = nil;

    if (theElement = CrGUIElement::FindObject( Name )) //Assignment within conditional (OK)
        return theElement;

    if ( mGridPtr != nil )
    {
        if (theElement = mGridPtr->FindObject( Name ))  //Assignment (OK)
            return ( theElement );
    }

    return nil;

}

CrGUIElement *  CrWindow::GetRootWidget()
{
    return this;
}

void CrWindow::CloseWindow()
{
    Cancelled();
}

void CrWindow::ResizeWindow(int newWidth, int newHeight)
{
//Set size of new child grid to this
    CcRect rect ( 0,0, newHeight, newWidth );
    if ( mGridPtr != nil ) mGridPtr->SetGeometry(&rect);
}

void CrWindow::Committed()
{
    SendCommand(mCommitText);
}
void CrWindow::Cancelled()
{
// What if the script has crashed out, and we can't close
// the modal window?
      if (mSafeClose > 6)
      {
#ifdef __CR_WIN__
            MessageBox(NULL,"Script not responding","Closing window",MB_OK);
#endif
            SendCommand( "^^CO DISPOSE " + mName );
      }
    SendCommand(mCancelText);
      mSafeClose ++;
}

void CrWindow::AddToTabGroup(CrGUIElement* tElement)
{
    mTabGroup->AddItem( (void*) tElement );
}

void* CrWindow::GetPrevTabItem(void* pElement)
{
    if( mTabGroup->FindItem(pElement) )
        return mTabGroup->GetNextLoopItem(true);
    else
    {
        mTabGroup->Reset();
        return mTabGroup->GetNextLoopItem(true);
    }
}

void* CrWindow::GetNextTabItem(void* pElement)
{
    if( mTabGroup->FindItem(pElement) )
        return mTabGroup->GetNextLoopItem(false);
    else
    {
        mTabGroup->Reset();
        return mTabGroup->GetNextLoopItem(false);
    }
}


void CrWindow::CrFocus()
{
        ((CxWindow*)ptr_to_cxObject)->Focus();
}

void CrWindow::SetMainMenu(CrMenuBar * menu)
{
    ((CxWindow*)ptr_to_cxObject)->SetMainMenu((CxMenuBar*)menu->GetWidget());
}

void CrWindow::MenuSelected(int id)
{
    CcMenuItem* menuItem = (CcController::theController)->FindMenuItem( id );

    if ( menuItem )
    {
        CcString theCommand = menuItem->command;
        SendCommand(theCommand);
        return;
    }
}

void CrWindow::ToolSelected(int id)
{
    CcTool* tool = (CcController::theController)->FindTool( id );

    if ( tool )
    {
        CcString theCommand = tool->tCommand;
        SendCommand(theCommand);
        return;
    }
}

void CrWindow::FocusToInput(char theChar)
{
    int nChar = (int) theChar;
    if ( ( mCommitSet ) && ( nChar == 13 ) ) //Return key, Commit if set.
    {
        Committed();
    }
    else if ( ( mCancelSet ) && ( nChar == 27 ) ) //Escape key, Cancel if set.
    {
        Cancelled();
    }
    else
    {
            mControllerPtr->FocusToInput(theChar);
    }
}

void CrWindow::SetCommitText(CcString text)
{
    mCommitText = text;
    mCommitSet = true;
}

void CrWindow::SetCancelText(CcString text)
{
    mCancelText = text;
    mCancelSet = true;
}

void CrWindow::SendCommand(CcString theText, bool jumpQueue)
{
//If there is a COMMAND= set for this window
//send this first, unless the text begins with
//a # or ^ symbol.

//Usually the command is set to a script which
//will handle any events generated by the window.
// e.g. in xmodel.scp COMMAND='xmodelhand.scp'

//For certain commands it is useful to bypass this
//mechanism and pass the command straigt to
//CRYSTALS (#) or to GUI (^).

      if ( theText.Len() == 0 ) //It may be that objects or commands have empty strings.
      {
            if ( mCommandSet )
            {
                  mControllerPtr->SendCommand(mCommandText);
            }
            mControllerPtr->SendCommand(theText);
      }
      else
      {
            if (       ( mCommandSet                )
                   &&  (!( theText.Sub(1,1) == '#' ))
                   &&  (!( theText.Sub(1,1) == '^' ))   )
            {
                  mControllerPtr->SendCommand(mCommandText);
            }
            mControllerPtr->SendCommand(theText);
      }
}

void CrWindow::SetCommandText(CcString theText)
{
    mCommandText = theText;
    mCommandSet = true;
}



// Called by objects in the window to request that
// system key information is passed to them
// Currently used by CxChart for Cameron rotation and
// CxEditBox for command line history.

void CrWindow::SendMeSysKeys( CrGUIElement* interestedWindow )
{
      mWindowsWantingSysKeys.AddItem((void*)interestedWindow);
      if ( interestedWindow != nil )
      {
// Make sure the CxWindow is listening for us.
            ((CxWindow*)ptr_to_cxObject)->mWindowWantsKeys = true;
      }
      else
      {
// Make sure the CxWindow is not listening.
            ((CxWindow*)ptr_to_cxObject)->mWindowWantsKeys = false;
      }
}

// Called by CxWindow when a system key is pressed,
// if CxWindow->mWindowWantsKeys is set to true.

void CrWindow::SysKeyPressed ( UINT nChar )
{
      mWindowsWantingSysKeys.Reset();
      CrGUIElement * elem;
      while ( ( elem = (CrGUIElement*)mWindowsWantingSysKeys.GetItemAndMove() ) != nil )
      {
            elem->SysKey ( nChar );
      }
}

void CrWindow::SysKeyReleased ( UINT nChar )
{
      mWindowsWantingSysKeys.Reset();
      CrGUIElement * elem;
      while ( ( elem = (CrGUIElement*)mWindowsWantingSysKeys.GetItemAndMove() ) != nil )
      {
            elem->SysKeyUp ( nChar );
      }
}


void CrWindow::NotifyControl()
{
  (CcController::theController)->RemoveWindowFromList(this);
}

void CrWindow::Redraw()
{
  ((CxWindow*)ptr_to_cxObject)->Redraw();
}

void CrWindow::Enable(bool enable)
{
  ((CxWindow*)ptr_to_cxObject)->CxEnable(enable);
}

void CrWindow::SetTimer()
{
  ((CxWindow*)ptr_to_cxObject)->CxSetTimer();
}

void CrWindow::TimerFired()
{
  CcController::theController->TimerFired();
}
