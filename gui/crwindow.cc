////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CrWindow.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:26 Uhr
//   Modified:  30.3.1998 12:11 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crwindow.h"
#include	"crgrid.h"
#include	"crmenu.h"
#include	"ccmenuitem.h"
#include	"cccontroller.h"
#include	"cxwindow.h"
#include	"ccrect.h"
#include	"cxapp.h"

CcList CrWindow::mModalWindowStack;

CrWindow::CrWindow( CxApp * mParentPtr )
	:	CrGUIElement( (CrGUIElement *)mParentPtr )
{
	// For the window we don't generate the GUI equivalent immediately
	// because we have to find the attributes first
	mWidgetPtr = nil;
	mGridPtr = nil;
	mMenuPtr = nil;
      mOrigWidth = -1; 
      mOrigHeight= -1; 
	mTabGroup = new CcList();
	mTabStop = false;
	mIsModal = false;
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
}


CrWindow::~CrWindow()
{
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
	if ( mWidgetPtr != nil )
	{
		delete (CxWindow*)mWidgetPtr;
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


//      if(mIsModal)
//            if(mModalWindowStack.GetLastItem())
//            {
//                  mModalWindowStack.RemoveItem();
//            }
	
	delete mTabGroup;
}

Boolean	CrWindow::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = false;
	Boolean hasTokenForMe = true;

	// Initialization for the first time
	if( !mSelfInitialised )
	{
		int attributes = 0;
		
		LOGSTAT("*** Window *** Initing...");

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
                                case kTKeep:
                                {
                                      tokenList->GetToken();
                                      m_Keep = true;
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
		mWidgetPtr = CxWindow::CreateCxWindow( this, modalParent, attributes );

		SetText( mText );
		
		LOGSTAT( "*** Created Window      " + mName );
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
			LOGSTAT("Creating Grid...");

			mGridPtr = new CrGrid( this );
			if ( mGridPtr != nil )
			{
				// remove that token
				tokenList->GetToken();
				
				// ParseInput generates all objects in the window
				// Of course the token list must be full
				retVal = mGridPtr->ParseInput( tokenList );
				if ( ! retVal )
				{
					delete mGridPtr;
					mGridPtr = nil;
				}
			}
			break;
		}
		case kTShowWindow:
		{
			tokenList->GetToken();
			
			//First call CalcLayout() on all children. (Should only be one).
			this->CalcLayout();

                  SetOriginalSizes();
                  
			//First call Align() on all children. (Should only be one).
			this->Align();
			

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
				CcRect newPosn;
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


				((CxWindow*)mWidgetPtr)->SetGeometry(	newPosn.Top(),
                                                                  newPosn.Left(),
                                                                  newPosn.Bottom(),
                                                                  newPosn.Right() );
                  }


                  if ( m_Keep )
                  {
// Get the old size out of a file...
                        CcString cgeom = (CcController::theController)->GetKey( mName );
                        CcRect oldSize(0,0,0,0);
                        if ( cgeom.Len() )
                            oldSize = CcRect( cgeom );

                        if (( oldSize.Height() > 10) && ( oldSize.Width() > 10 ))
                              ((CxWindow*)mWidgetPtr)->SetGeometry(oldSize.mTop,
                                                                   oldSize.mLeft,
                                                                   oldSize.mBottom,
                                                                   oldSize.mRight );
// Direct call to the CxWindow::SetGeometry, avoids the AdjustSize call
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
			retVal = true;
			break;
		}
		case kTHideWindow:
		{
			tokenList->GetToken();
			
			// Hide self
			this->Show(false);

			LOGSTAT( "Window '" + mName + "' obeys HIDE");
			retVal = true;
			break;
		}
		case kTDefineMenu:
		{
//June1999. The port to wxWindows requires that the MenuBar
//in a window be a different type of object from the actual
//pull-down menus. Makes sense really. So we will pass a flag
//to the CrMenu constructor so that it can contain a CxMenuBar
//instead of a CxMenu.
			tokenList->GetToken();
			LOGSTAT("Defining Menu...");

                  mMenuPtr = new CrMenu( this, MENU_BAR );
			if ( mMenuPtr != nil )
			{
				// ParseInput generates all objects in the menu
				// Of course the token list must be full
				retVal = mMenuPtr->ParseInput( tokenList );
				if ( ! retVal )
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
			retVal = true;
			break;
		}

            case kTTextSelector:
            {
			tokenList->GetToken();
                  LOGSTAT("Changing title of window.");
			retVal = true;
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

#ifdef __LINUX__
      cerr << "Exiting CrWindow::ParseInput";
#endif

	return (retVal);
}

void	CrWindow::SetGeometry( const CcRect * rect )
{
	CcRect tempRect;
	tempRect.mTop		= rect->mTop;
	tempRect.mLeft		= rect->mLeft;
	tempRect.mBottom	= rect->mBottom;
	tempRect.mRight		= rect->mRight;

//Adjust size adds on the space for menus and borders.
	((CxWindow*)mWidgetPtr)->AdjustSize(&tempRect);

      ((CxWindow*)mWidgetPtr)->SetGeometry(tempRect.mTop,
                                           tempRect.mLeft,
                                           tempRect.mBottom,
                                           tempRect.mRight );
}

CcRect	CrWindow::GetGeometry()
{
	CcRect retVal;
	retVal.Set(	((CxWindow*)mWidgetPtr)->GetTop(), 
                        ((CxWindow*)mWidgetPtr)->GetLeft(),
                        ((CxWindow*)mWidgetPtr)->GetTop()+((CxWindow*)mWidgetPtr)->GetHeight(),
                        ((CxWindow*)mWidgetPtr)->GetLeft()+((CxWindow*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

CcRect  CrWindow::GetScreenGeometry()
{
	CcRect retVal;
        retVal.Set(     ((CxWindow*)mWidgetPtr)->GetScreenTop(), 
                        ((CxWindow*)mWidgetPtr)->GetScreenLeft(),
                        ((CxWindow*)mWidgetPtr)->GetScreenTop()+((CxWindow*)mWidgetPtr)->GetHeight(),
                        ((CxWindow*)mWidgetPtr)->GetScreenLeft()+((CxWindow*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void	CrWindow::CalcLayout()
{
	if ( mGridPtr != nil )
	{
		// STEP1 Call calclayout for child grid.
		mGridPtr->CalcLayout();
	
		// STEP2 Set Size to size of child grid.
		CcRect theRect;
		theRect = mGridPtr->GetGeometry();
		SetGeometry( &theRect );
	}
}

void  CrWindow::SetOriginalSizes()
{
	if ( mGridPtr != nil )
	{
            mGridPtr->SetOriginalSizes();
	}

      CcRect theRect;
      theRect = mGridPtr->GetGeometry();

      mOrigWidth = theRect.Width();
      mOrigHeight= theRect.Height();

}

void	CrWindow::SetText( CcString item )
{
	char theText[256];
	strcpy (theText, item.ToCString() );
	if ( mWidgetPtr != nil )
	{
		((CxWindow*)mWidgetPtr)->SetText(theText);
	}
}

void	CrWindow::Show( Boolean show )
{

	if( show )
	{
		((CxWindow*)mWidgetPtr)->CxShowWindow();
			
	}
	else
	{
		((CxWindow*)mWidgetPtr)->Hide();
	}
}

void	CrWindow::Align()
{

	if ( mGridPtr != nil )
		mGridPtr->Align();
}

CrGUIElement *	CrWindow::FindObject( CcString Name )
{
	CrGUIElement * theElement = nil;
	
	if (theElement = CrGUIElement::FindObject( Name )) //Assignment within conditional (OK)
		return theElement;

	if ( mGridPtr != nil )
	{
		if (theElement = mGridPtr->FindObject( Name ))	//Assignment (OK)
			return ( theElement );
	}

	return nil;

}

CrGUIElement *	CrWindow::GetRootWidget()
{
	return this;
}

void CrWindow::CloseWindow()
{
	Cancelled();
}

void CrWindow::ResizeWindow(int newWidth, int newHeight)
{

    if ( mOrigWidth > 0 )
    {

//Set size of new child grid to this
	if ( mGridPtr != nil )
            mGridPtr->Resize(newWidth, newHeight, mOrigWidth, mOrigHeight);

//Finally re-calculate positions and draw the window
	CalcLayout();
    }
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
#ifdef __WINDOWS__
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
		((CxWindow*)mWidgetPtr)->Focus();	
}

void CrWindow::SetMainMenu(CrMenu * menu)
{
	TRACE("**** This is the Main Window SetMainMenu call\n");
	((CxWindow*)mWidgetPtr)->SetMainMenu((CxMenu*)menu->GetWidget());	
}

void CrWindow::MenuSelected(int id)
{
	CcMenuItem* menuItem = nil; 
	if (menuItem = mMenuPtr->FindItembyID( id )) //Assignment.
	{
		CcString theCommand = menuItem->command;
		SendCommand(theCommand);
	}
	else
	{
		LOGERR("CrWindow:MenuSelected Window cannot find menu item. id = " + CcString(id));
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

void CrWindow::SendCommand(CcString theText, Boolean jumpQueue)
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
            ((CxWindow*)mWidgetPtr)->mWindowWantsKeys = true;
      }
      else
      {
// Make sure the CxWindow is not listening.
            ((CxWindow*)mWidgetPtr)->mWindowWantsKeys = false;
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

