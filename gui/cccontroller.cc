
////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr
//   Modified:  30.3.1998 12:23 Uhr

// $Log: not supported by cvs2svn $
// Revision 1.17  2000/07/04 14:41:21  ckp2
// Gui changes since last year.
// Mainly chart handling for multiple charts in one window.
// Some Cx files only changed to split long lines to make inclusion
// into "the thesis" more automatic.
// New GUIMENU.SSR has more "right-click" options and swapped panes for model
// and text output.
//
// Revision 1.16  1999/07/30 20:17:59  richard
// RIC: Added Focus instruction to give the specified window or object
// the users input focus.
// RIC: Added FontIncrease instruction for changing the font size. Follow
// with YES to increase, or NO to decrease the current font size in the
// current output window.
//
// Revision 1.15  1999/07/02 17:59:10  richard
// RIC: Added a boolean m_Wait which is true while CRYSTALS is off processing
// things. It isn't actually used by anything though.
//
// Revision 1.14  1999/06/23 19:51:44  dosuser
// RIC: Added code to postmessage on adding stuff to the interface command
// queue. Didn't work very well, so I commented it out again.
// RIC: No need to use CcController::theController pointer from within
// the CcController class!
// RIC: Checks for ^^ in Tokenize and ^^?? in AddInterfaceCommand have
// been revised to only check the first 6 characters rather than the
// whole string (This allows for accidental extra spaces, while not going
// over the top.)
//
// Revision 1.13  1999/06/22 12:55:42  dosuser
// RIC: Added GetKeyValue and SetKeyValue to ParseInput function + supporting
// subroutines. They allow a key (single word) to be stored in a global file
// followed by a value (any text). This is used to save window size and
// position, but can also be used by for example TIPS.SCP to remember whether
// the user really wants to see tips at startup.
// RIC: SetProgressText changed slightly. It now calls switch text in
// the ProgressBar class. The progress bar remembers what it said before
// the call to SwitchText and pops it back up when you call SwitchText with
// a NULL pointer.
//
// Revision 1.12  1999/06/13 16:31:57  dosuser
// RIC: Added GetInputPlace(), SetInputPlace() and RemoveInputPlace()
// for dynamically changing the Input Window. Check for TEXTINPUT on
// SET command and look up the relevant object using GetInputPlace().
// Added RedirectInput token, to change the input object. Probably
// not needed though, as the token INPUT on an EDITBOX command will
// do the trick.
// Changed char * to CcString for AddCrystalsCommand and AddInterfaceCommand.
// No longer necessary to check for _MAINTEXTINPUT in AddCrystalsCommand,
// since the CrEditBox now knows if it is the input source and will send
// text and clear itself as appropriate.
// All references to mInputWindow changed to GetInputPlace().
// RemoveTextOutputPlace() and RemoveProgressOutputPlace() changed so
// that they search for the object being destroyed and remove it from
// the appropriate list. This is better then popping it off the end
// of the list as it allows the text to be redirected back to the
// main window before the new window is destroyed, without leaking
// memory. See #SCRIPT XHELP1 and 2 for an example of this.
// OutputToScreen function never used, removed.
// Added StoreSize routine to store a key and a rectangle in the
// winsizes.ini file in the script directory.
// Added GetSize routine to get a rectangle from the winsizes.ini
// file given a key.
// CcController specific tokens moved into the header file.
//
// Revision 1.11  1999/06/07 19:51:00  dosuser
// RIC: The ChangeDir function that used to be a member function of CxApp,
// is now a global function.
//
// Revision 1.10  1999/06/06 19:43:48  dosuser
// RIC: Added new method of adding chart objects to the chartdoc. Objects
// can be added by direct function calls rather than by passing ^^CH
// commands to the interface. Another function, complete(), accessed from
// the Fortran by calling GUWAIT() blocks until all ^^ commands have
// been processed. This allows mixing of ^^CH commands with direct function
// calls provided GUWAIT() is called after ^^CH commands. Cameron updates
// pictures much much faster.
//
// Revision 1.9  1999/06/03 16:53:15  dosuser
// RIC: Fixed an error that was lopping the last character off
// any Interface command before it was processed.
//
// Revision 1.8  1999/06/03 14:35:49  dosuser
// RIC: Changed ParseLine and ParseInput to use CcStrings rather than
// char*'s. Same for ProcessOutput. Changed TRUE and FALSE to
// true and false.
//
// Revision 1.7  1999/05/28 17:52:00  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.6  1999/05/13 17:46:00  dosuser
// RIC: Fixed argument passing to endthread( long )
//      Added SysRestart token and a member variable to store the
//      path of the directory to restart in.
//      Moved Mutex to after the thread status check otherwise it is never
//      released when the function returns.
//
// Revision 1.5  1999/05/11 16:15:10  dosuser
// RIC: Added token SYSGETDIR and supporting functions for getting a
//      directory from the user via a common dialog.
//
// Revision 1.4  1999/04/30 16:56:49  dosuser
// RIC: Added SetProgressText(CcString Text) to allow the model window to
//      display atom names in the current progress/status bar.
//

#include    "crystalsinterface.h"
#include	"crconstants.h"
#include	"cccontroller.h"

#include	"crwindow.h"
#include	"crgrid.h"
#include	"cxgrid.h" //to delete its static font pointer.
#include	"crbutton.h"
#include	"creditbox.h"
#include	"cctokenlist.h"
#include	"cccommandqueue.h"
#include	"cxapp.h"
#include	"cxeditbox.h"
#include	"crmultiedit.h"
#include        "crtextout.h"
#include	"ccchartdoc.h"
#include	"ccmodeldoc.h"
#include	"ccquickdata.h"
#include	"ccchartobject.h"
#include        "crgraph.h"
#include    "crprogress.h"
#include <iostream.h>
#include <iomanip.h>

#ifdef __WINDOWS__
HANDLE mInterfaceCommandQueueMutex;
HANDLE mCrystalsCommandQueueMutex;
HANDLE mCrystalsCommandQueueEmptyEvent;
HANDLE mLockCrystalsQueueDuringQueryMutex;
HANDLE mCrystalsThreadIsLocked;
#endif
#ifdef __LINUX__
#include <wx/thread.h>
#include <wx/settings.h>
static wxMutex mInterfaceCommandQueueMutex;
static wxMutex mCrystalsCommandQueueMutex;
static wxMutex mCrystalsCommandQueueEmptyEvent;
static wxMutex mLockCrystalsQueueDuringQueryMutex;
static wxMutex mCrystalsThreadIsLocked;
#endif



CcController* CcController::theController = nil;	
//DWORD CcController::threadID = 0L; 

extern "C" {
void  endthread(            long theExitcode );
}

CcController::CcController( CxApp * appContext )
{

//Things
	mAppContext = appContext;
	mErrorLog = nil;
      mThisThreadisDead = false;
      m_Completing = false;

      //m_newdir = "";
      m_restart = false;

      m_Wait = false;

//Docs. (A doc is attached to a window (or vice versa), and holds and manages all the data)
	mCurrentChartDoc = nil;
	mCurrentModelDoc = nil;

//Current window pointers. Used to direct streams of input to the correct places (if for some reason the stream has been interuppted.)
	mCurrentWindow = nil;   //The current window. GetValue will search in this window first.
	mInputWindow = nil;     //The users input window. Focus goes here when keys are pressed.
//	mModelWindow = nil; NOTUSED
	mTextWindow = nil;      //The current place for normal text to be sent. The routine that writes checks this first, and sends elsewhere if the window has gone.
	mProgressWindow = nil;

//Token list pointers.
	mCurTokenList = nil;    //The current token list, could be for charts, model, windows etc.
	mTempTokenList = nil;   //Stores the current token list when 'quick' commands are jumping the input queue.

//Lists
	mModelTokenList = new CcTokenList(); //Tokens for a model window.
	mChartTokenList = new CcTokenList(); //Tokens for a chart (graphics) window.
	mStatusTokenList = new CcTokenList(); //Tokens for the status object.
	mQuickTokenList = new CcTokenList();  //Tokens for immediate processing.
	mWindowTokenList = new CcTokenList(); //Tokens for defining or changing windows.

	mQuickData = new CcQuickData();  //An object to hold large blocks of information that is quicker to pass directly from the FORTRAN rather than through the TokenList processing channels.

// Initialize the static pointers in classes for accessing this controller object.
	CrGUIElement::mControllerPtr = this;
	CcController::theController = this;
//      CcController::threadID = GetCurrentThreadId();
#ifdef __WINDOWS__
// Win32 specific: Set up MUTEXES for synchronising threads.
// ie. Only one thread at a time can access the command and interface queues to prevent corruption.
// (as long as they use them!) See {Add/Get}InterfaceCommand and {Add/Get}CrystalsCommand.
      mInterfaceCommandQueueMutex        = CreateMutex(NULL, false, NULL);
      mCrystalsCommandQueueMutex         = CreateMutex(NULL, false, NULL);
      mLockCrystalsQueueDuringQueryMutex = CreateMutex(NULL, false, NULL);
      mCrystalsThreadIsLocked            = CreateMutex(NULL, false, NULL);
	WaitForSingleObject( mLockCrystalsQueueDuringQueryMutex, INFINITE ); //We want this all the time.

      mCrystalsCommandQueueEmptyEvent    = CreateEvent(NULL, true, false, NULL);

#endif

#ifdef __LINUX__

#endif

	mCrystalsCommandQueue.AddNewLines(true); //Make the crystals queue interpret _N as a new line.

	mCommandHistoryPosition = 0;
}

CcController::~CcController()       //The destructor. Delete all the heap objects.
{
	CrWindow * theWindow;
	
	mWindowList.Reset();
	theWindow = (CrWindow *)mWindowList.GetItem();
	
	while ( theWindow != nil )
	{
		delete theWindow;
		mWindowList.RemoveItem();
		theWindow = (CrWindow *)mWindowList.GetItem();
	}

	delete mWindowTokenList;
	delete mChartTokenList;
	delete mQuickTokenList;
	delete mModelTokenList;
	delete mStatusTokenList;
	delete mQuickData;	

	mModelDocList.Reset();
	CcModelDoc* theItem ;
	while ( ( theItem = (CcModelDoc *)mModelDocList.GetItem() ) != nil )
	{
		mModelDocList.RemoveItem();
		delete theItem;
	}
	
	CcString *temp;
	while ( mCommandHistoryList.ListSize() > 0 ) //Delete the history items.
	{
		temp = (CcString*) mCommandHistoryList.GetItem();
		delete temp;
		mCommandHistoryList.RemoveItem();
	}

#ifdef __WINDOWS__
      delete (CxGrid::mp_font);
#endif

}

Boolean	CcController::ParseInput( CcTokenList * tokenList )
{

	Boolean retVal = false;
	int infiniteLoopCheck = 0;
	int infiniteLoopCheck2 = -999999;

	while (tokenList->ListSize() > 0) //don't return until the list is empty
	{
		infiniteLoopCheck = tokenList->ListSize();
		if(infiniteLoopCheck == infiniteLoopCheck2) //if the list size has remained the same during one iteration of this loop...
		{
			CcString badToken = tokenList->GetToken(); //remove the unrecognised token.
			LOGWARN("CcController::ParseInput:infiniteLoopCheck Getting nowhere with this token: " + badToken);
		}
		infiniteLoopCheck2 = infiniteLoopCheck;
		
		switch ( tokenList->GetDescriptor( kInstructionClass ) )
		{
			case kTCreateWindow:
			{
				LOGSTAT("CcController: Creating window");
				CrWindow * wPtr = new CrWindow( mAppContext );
				mCurrentWindow = wPtr;
				if ( wPtr != nil )
				{
					tokenList->GetToken(); //remove token.
					retVal = wPtr->ParseInput( tokenList );
					if ( retVal )
						mWindowList.AddItem( wPtr );
					else
						delete wPtr;
				}
				break;
			}
			case kTDisposeWindow:
			{
				tokenList->GetToken(); 				// remove that token
				CcString theWindow = tokenList->GetToken();
				LOGSTAT("CcController: Disposing window " + theWindow);
				CrGUIElement* mWindowToClose = FindObject(theWindow); //Find window by name.

				CrWindow * wPtr = nil;
				if ( mWindowToClose != nil )
				{
					mWindowList.Reset();

					// Find window in the list
					while ( ( wPtr = ( CrWindow *)mWindowList.GetItem() ) != nil
							&& wPtr != mWindowToClose )
					{
						mWindowList.GetItemAndMove();
					}
					
					// Remove it
					if ( wPtr == mWindowToClose )
					{
						mWindowList.RemoveItem();
						mWindowList.Reset();

						// Set current - we want stack behaviour, so take tha last
						CrWindow * tempWin = (CrWindow *)mWindowList.GetItemAndMove();
						
						while ( tempWin != nil )
						{
							mCurrentWindow = tempWin;
							tempWin = (CrWindow *)mWindowList.GetItemAndMove();
						}
						
						delete wPtr;
					}
				}
				break;

			}
			case kTGetValue:
			{
				LOGSTAT("CcController: Getting Value");
				// remove that token
				tokenList->GetToken();
				
				CcString name = tokenList->GetToken();	// Get the name of the object
				CrGUIElement * theElement;
				if ( mCurrentWindow != nil )
				{
					// Look for the item in current window first.
					 theElement = mCurrentWindow->FindObject( name );
				}

				if ( theElement == nil )
				{
					// Look for the element everywhere.
					theElement = FindObject ( name );
				}

				if ( theElement != nil )
				{
					theElement->GetValue();
				}
				else
				{
                              SendCommand("FALSE",true); //This can be used to check if an object exists.
					LOGWARN( "CcController:ParseInput:GetValue couldn't find object with name '" + name + "'");
				}
				break;

			}
			case kTSet:
			{
				// remove that token
				tokenList->GetToken();
				
				CcString name = tokenList->GetToken();	// Get the name of the object
				LOGSTAT("CcController: Setting Value of " + name);
				CrGUIElement* theElement = nil;

				if (name == "TEXTOUTPUT")
				{
					theElement = GetTextOutputPlace();
					if(theElement != GetBaseTextOutputPlace() )
					{
						tokenList->Lock(); //Prevents the tokenList from emptying as it is read.
						GetBaseTextOutputPlace()->ParseInput( tokenList );  
						tokenList->UnLock(); //Restores the tokenList and allows emptying.
					}
					theElement->ParseInput( tokenList );
				}
				else if (name == "PROGOUTPUT")
				{
					theElement = GetProgressOutputPlace();
					theElement->ParseInput( tokenList );
				}
                                else if (name == "TEXTINPUT")
				{
                                        theElement = GetInputPlace();
					theElement->ParseInput( tokenList );
				}
				else                // if ( mCurrentWindow != nil ) No search all windows.
				{
					// Look for the item
					theElement = FindObject( name );
					if(theElement)
						theElement->ParseInput( tokenList );
					else
                                        {
                                                CrGraph * theGraph = nil, * theItem;
                                                mGraphList.Reset();
                                                theItem = (CrGraph *)mGraphList.GetItemAndMove();
                                                while ( theItem != nil && theGraph == nil )
                                                {
                                                           theGraph = theItem->FindObject( name );
                                                           theItem = (CrGraph *)mGraphList.GetItemAndMove();
                                                }
                                                if ( theGraph )
                                                           theGraph->ParseInput( tokenList );
                                                else
                                                {

                                                   CcChartDoc * theChart = nil, * theCItem;
                                                   mChartList.Reset();
                                                   theCItem = (CcChartDoc *)mChartList.GetItemAndMove();
                                                   while ( theCItem != nil && theChart == nil )
                                                   { 
                                                           theChart = theCItem->FindObject( name );
                                                           theCItem = (CcChartDoc *)mChartList.GetItemAndMove();
                                                   }
                                                   if ( theChart )
                                                           theChart->ParseInput( tokenList );
                                                   else
                                                             LOGWARN( "CcController:ParseInput:Set couldn't find object with name '" + name + "'");
                                                }
                                        }
				}
				break;
			}
                  case kTFocus:
			{
				// remove that token
				tokenList->GetToken();
				
				CcString name = tokenList->GetToken();	// Get the name of the object
				LOGSTAT("CcController: Setting Value of " + name);
				CrGUIElement* theElement = nil;

				if (name == "TEXTOUTPUT")
				{
					theElement = GetTextOutputPlace();
                              theElement->CrFocus();
				}
				else if (name == "PROGOUTPUT")
				{
					theElement = GetProgressOutputPlace();
                              theElement->CrFocus();
				}
                        else if (name == "TEXTINPUT")
				{
                              theElement = GetInputPlace();
                              theElement->CrFocus();
				}
				else                // if ( mCurrentWindow != nil ) No search all windows.
				{
					// Look for the item
					theElement = FindObject( name );
					if(theElement)
                                    theElement->CrFocus();
					else
                                    LOGWARN( "CcController:ParseInput:Focus couldn't find object with name '" + name + "'");
				}
				break;
			}
                        case kTRenameObject:
			{
				// remove that token
				tokenList->GetToken();
				
				CcString name = tokenList->GetToken();	// Get the name of the object
                                LOGSTAT("CcController: About to rename: " + name);
				CrGUIElement* theElement = nil;

                        // Look for the item
                                theElement = FindObject( name );
                                if(theElement)
                                      theElement->Rename( tokenList->GetToken() );
                                else
                                {
                                      CcChartDoc * theChart = nil, * theCItem;
                                      mChartList.Reset();
                                      theCItem = (CcChartDoc *)mChartList.GetItemAndMove();
                                      while ( theCItem != nil && theChart == nil )
                                      { 
                                            theChart = theCItem->FindObject( name );
                                            theCItem = (CcChartDoc *)mChartList.GetItemAndMove();
                                      }
                                      if ( theChart )
                                            theChart->Rename( tokenList->GetToken() );
                                      else
                                      {
                                              CrGraph * theGraph = nil, * theItem;
                                              mGraphList.Reset();
                                              theItem = (CrGraph *)mGraphList.GetItemAndMove();
                                              while ( theItem != nil && theGraph == nil )
                                              {
                                                    theGraph = theItem->FindObject( name );
                                                    theItem = (CrGraph *)mGraphList.GetItemAndMove();
                                              }
                                              if ( theGraph )
                                                    theGraph->Rename( tokenList->GetToken() );
                                              else
                                                    LOGWARN( "CcController:ParseInput:Rename couldn't find object with name '" + name + "'");
                                      }
                                }
                                break;
			}
			case kTCreateChartDoc:
			{
				tokenList->GetToken(); //remove token
				CcChartDoc* cPtr = new CcChartDoc();
				cPtr->ParseInput( tokenList );
				mCurrentChartDoc = cPtr;
				break;
			}
			case kTCreateModelDoc:
			{
				tokenList->GetToken(); //remove token
				CcString modelName = tokenList->GetToken();
				CcModelDoc* aModelDoc = FindModelDoc(modelName);
				if (aModelDoc == nil)
				{
					CcModelDoc* cPtr = new CcModelDoc();
					mCurrentModelDoc = cPtr;
					mCurrentModelDoc->mName = modelName;
					mModelDocList.AddItem(mCurrentModelDoc);
				}
				else
				{
					mCurrentModelDoc = aModelDoc;
					mCurrentModelDoc->Clear();
				}
				mCurrentModelDoc->ParseInput( tokenList );
				break;
			}
			case kTSysOpenFile: //Display OpenFileDialog and send result back to the Script.
			{
				tokenList->GetToken();    // remove that token
				CcString result;
				CcString extension = tokenList->GetToken();	// Get the extension
				CcString description = tokenList->GetToken();	// Get the extension description
				if ( tokenList->GetDescriptor(kAttributeClass) == kTTitleOnly)
				{	
                              mAppContext->OpenFileDialog(&result, extension, description, true);
					tokenList->GetToken(); //Remove token
				}
				else
				{
                              mAppContext->OpenFileDialog(&result, extension, description, false);
				}
				SendCommand(result);
				break;
			}
                  case kTSysSaveFile: //Display SaveFileDialog and send result back to the Script.
			{
				tokenList->GetToken();    // remove that token
				CcString result;
				CcString defName = tokenList->GetToken();	// Get the default file name.
				CcString extension = tokenList->GetToken();	// Get the extension.
				CcString description = tokenList->GetToken();	// Get the extension description.

				mAppContext->SaveFileDialog(&result, defName, extension, description);
				SendCommand(result);
				break;
			}
                  case kTSysGetDir: //Display GetDirDialog and send result back to the Script.
			{
				tokenList->GetToken();    // remove that token
				CcString result;
                        mAppContext->OpenDirDialog(&result);
				SendCommand(result);
				break;
			}
                  case kTSysRestart: //Crystals has closed down, restart in specified directory.
			{
				tokenList->GetToken();    // remove that token
                        m_newdir = tokenList->GetToken();
                        m_restart = true;
                        if (tokenList->GetDescriptor( kAttributeClass )==kTRestartFile)
                        {
                              tokenList->GetToken();    // remove that token
                              CcString newdsc = "CRDSC=" + tokenList->GetToken();
#ifdef __WINDOWS__
                              _putenv( (LPCTSTR) newdsc.ToCString() );
#endif
#ifdef __LINUX__
                              putenv(  newdsc.ToCString() );
#endif
                        }
                        break;
			}
			case kTRedirectText:
			{
				tokenList->GetToken();
				CcString textWindow = tokenList->GetToken();
				CrGUIElement * theElement = FindObject( textWindow );
				if ( theElement != nil )
					SetTextOutputPlace(theElement);
				else
					LOGWARN( "CcController:ParseInput:RedirectText couldn't find object with name '" + textWindow + "'");
				break;
			}
			case kTRedirectProgress:
			{
				tokenList->GetToken();
				CcString progressWindow = tokenList->GetToken();
				CrGUIElement * theElement = FindObject( progressWindow );
				if ( theElement != nil )
					SetProgressOutputPlace(theElement);
				else
					LOGWARN( "CcController:ParseInput:RedirectProgress couldn't find object with name '" + progressWindow + "'");
				break;
			}
                  case kTRedirectInput:
			{
				tokenList->GetToken();
                        CcString inputWindow = tokenList->GetToken();
                        CrGUIElement * theElement = FindObject( inputWindow );
				if ( theElement != nil )
                              SetInputPlace(theElement);
				else
                              LOGWARN( "CcController:ParseInput:RedirectInput couldn't find object with name '" + inputWindow + "'");
				break;
			}
                  case kTGetKeyValue:
			{
				tokenList->GetToken();
                        CcString val = GetKey( tokenList->GetToken() );
                        SendCommand(val);
                        break;
			}
                  case kTSetKeyValue:
			{
				tokenList->GetToken();
                        CcString key = tokenList->GetToken();
                        CcString val = tokenList->GetToken();
                        StoreKey( key, val );
                        break;
			}
			case kTSetStatus:
			{
				tokenList->GetToken();
				status.ParseInput(mCurTokenList);
                        break;
			}
                  case kTFontIncrease:
                        {
                        tokenList->GetToken();
                        Boolean increase = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                        tokenList->GetToken(); // Remove that token!

                        int size = 100;
                        CcString cgeom = GetKey( "FontSize" );
                        if ( cgeom.Len() )
                            size = atoi( cgeom.ToCString() );

                        size = max ( size + ( increase? 10:-10 ), 0 );
//                        CrTextOut* theElement = (CrTextOut*)GetTextOutputPlace();
  //                      if ( theElement !=nil )
    //                        theElement->SetFontHeight( size );
      //                  StoreKey( "FontSize", CcString ( size ) );

                        break;
			}

/*			case kTUnknown:
 *                 {
 *                       //Something has gone wrong.
 *
 *                       //Remove this token so that we don't loop forever. Hopefully we will
 *                       //find our way to a sensible token eventually.
 *                       break;
 *
 *                 }
 */
                  default:
			{
				// This is not a known instruction for Controller.
				// Pass it on to the current window.
				if ( tokenList == mWindowTokenList )
				{
					if ( mCurrentWindow != nil )
					{
						LOGSTAT("CcController:ParseInput Passing tokenlist to window");
						retVal = mCurrentWindow->ParseInput( tokenList );
					}
				}
				else if ( tokenList == mChartTokenList )
				{
					if ( mCurrentChartDoc != nil )
					{
						LOGSTAT("CcController:ParseInput:default Passing tokenlist to chart");
						retVal = mCurrentChartDoc->ParseInput( tokenList );
					}
				}
				else if ( tokenList == mModelTokenList )
				{
					if ( mCurrentModelDoc != nil )
					{
						LOGSTAT("CcController:ParseInput:default Passing tokenlist to model");
						retVal = mCurrentModelDoc->ParseInput( tokenList );
					}
				}
				else if ( tokenList == mStatusTokenList )
				{
						LOGSTAT("CcController:ParseInput:default Passing tokenlist to status handler");
						status.ParseInput( tokenList );
				}
				else
				{
					CcString theToken = tokenList->GetToken();
					LOGWARN("CcController:ParseInput:default found an unknown command = '" + theToken +
						 "', attempting to continue");
				}
				break;
			}
		} //end case
	} //end of while loop


	return (retVal);

}

Boolean     CcController::ParseLine( CcString text )
{

      int start = 1, stop = 1, i;
	Boolean inSpace = true;
	Boolean inDelimiter = false;

      int clen = text.Len();

      for (i=1; i <= clen; i++ )
	  {
		if ( inDelimiter )
		{
			if ( IsDelimiter( text[i-1] ) )  // end of item
			{
                        stop = i-1;
// we could have an empty string ie. '' so check before crashing the program.
						if ( stop < start )
						{
	                        AppendToken("") ;// add item to token list
						}
						else
						{
							AppendToken(text.Sub(start,stop) ) ;// add item to token list
						}
// Reset values
				start = stop = 0;
				inDelimiter = false;
				inSpace = true;
			}
		}
		else
		{
			if ( IsSpace( text[i-1] ) )
			{
				if ( ! inSpace )
				// end of item
				{
                              stop = i-1;
					// add item to token list
                              AppendToken(text.Sub(start,stop) );
				
					// init values
					start = stop = 0;
					inSpace = true;
				}
			}
			else if ( IsDelimiter( text[i-1] ) )
			{
				start = i+1;
				stop = 0;
				inDelimiter = true;
			}
			else if ( inSpace )
			// start of item
			{
				start = i;
				stop = 0;
				inSpace = false;
			}
		}
	}
	
	// Check for last item
	if ( ! inSpace && start != 0 )
	{
//		stop = i-1;
		stop = i-1;

		// add item to token list
            AppendToken(text.Sub(start,stop) );

	}
	return true; // *** for now
//End of user code.         
}

void	CcController::SendCommand( CcString command , Boolean jumpQueue)
{
	LOGSTAT("CcController:SendCommand received command '" + command + "'");
//      TRACE("Sending command %s ",command.ToCString());
	char* theLine = (char*)command.ToCString();
	AddCrystalsCommand(theLine, jumpQueue);
}

void	CcController::Tokenize( char * text )
{
	Boolean proc = false, stop = false;

      CcString cText = text;

      int j = 1;
      int clen = cText.Len();
      Boolean tagged = false;

// Look out for lines where the ^^ are misplaced.
      for ( j = 1; ( j < min ( clen-1, 6 ) ); j++ )
	{
            if ( cText.Sub(j,j+1) == "^^" )
            {
                  cText = cText.Sub(j,clen);
                  j = clen;
                  tagged = true;
            }
      }

      if ( cText.Len() >= 4 && tagged )
	// It is definitely tagged text
	  {
		  CcString selector = cText.Sub(3,4);
		// Get the selector and determine list to use
        if      ( selector == kSWindowSelector ) 
		{
			mCurTokenList = mWindowTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
        else if      ( selector == kSChartSelector ) 
		{
			mCurTokenList = mChartTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
        else if      ( selector == kSModelSelector ) 
		{
			mCurTokenList = mModelTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
        else if      ( selector == kSStatusSelector ) 
		{
			mCurTokenList = mStatusTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
        else if      ( selector == kSControlSelector ) 
		{
			while ( ParseInput( mCurTokenList ) );
		}
        else if      ( selector == kSOneCommand ) 
		{																 //Avoids breaking up (and corrupting) the incoming streams from scripts.
			mTempTokenList = mCurTokenList;
			mCurTokenList  = mQuickTokenList;
                  ParseLine( cText.Chop(1,4) );
			while ( ParseInput( mQuickTokenList ) );
			mCurTokenList  = mTempTokenList;
		}
        else if      ( selector == kSQuerySelector ) 
		{
			mTempTokenList = mCurTokenList;
			mCurTokenList  = mQuickTokenList;
                  ParseLine( cText.Chop(1,4) );
			GetValue( mQuickTokenList ) ;
			mCurTokenList  = mTempTokenList;
			//We must now signal the waiting Crystals thread that it's input is ready.
                  ProcessingComplete();
		}
        else                                             // Simple output text or comment
        {
                        mAppContext->ProcessOutput( cText ); // Useful to see mistakes in ^^ format.
        }
	}
	else                                             // Simple output text or comment
	{
                  mAppContext->ProcessOutput( cText );
	}
}

void CcController::CompleteProcessing()
{

// This function is called by the CRYSTALS thread and
// will not return until the interface has processed all
// pending commands in the command queue.

#ifdef __WINDOWS__
			WaitForSingleObject( mCrystalsThreadIsLocked, INFINITE );
#endif
//This MUTEX is not normally owned. It stops the interface thread from
//reclaiming the LockCrystalsQueue...Mutex before this thread gets it.
                  if(mThisThreadisDead) endthread(0);

                  m_Completing = true;

//We (CRYSTALS) must wait here until the answer to this query has been put at the front
//of the command queue.
#ifdef __WINDOWS__
			WaitForSingleObject( mLockCrystalsQueueDuringQueryMutex, INFINITE );
#endif
//This MUTEX is always held by the interface thread. It is released
//temporarily by the interface thread after processing a ^^?? instruction.
//It is reclaimed once the mCrystalsThreadIsLocked mutex is released by this thread.
                  if(mThisThreadisDead) endthread(0);

#ifdef __WINDOWS__
			ReleaseMutex( mLockCrystalsQueueDuringQueryMutex ); //Release and continue
			ReleaseMutex( mCrystalsThreadIsLocked );            //Release to allow the interface thread to continue.
#endif
}



void CcController::ProcessingComplete()
{
// This is called by the interface to signal that it has finished
// processing all pending commands in the command queue.

                  m_Completing=false;
#ifdef __WINDOWS__
                  ReleaseMutex( mLockCrystalsQueueDuringQueryMutex ); // (1) We always hold this. Crystals thread is waiting for it.

                  WaitForSingleObject( mCrystalsThreadIsLocked, INFINITE ); // (2) Crystals thread gets the mLCQDQMutex, releases it, then releases this one.

                  WaitForSingleObject( mLockCrystalsQueueDuringQueryMutex, INFINITE ); // (3) We want this back.

                  ReleaseMutex( mCrystalsThreadIsLocked ); // (4) Crystals thread needs this next time.
#endif

// This is a complicated bit of thread handshaking!
// CRYSTALS is paused in the function above, CompleteProcessing(),
// CRYSTALS has got hold of the mCrystalsThreadisLocked mutex.
// CRYSTALS is waiting for the mLockCrystalsQueueDuringQueryMutex mutex,
// which is held by this thread.
// Now that we've finished processing, we release the
// mLockCrystalsQueueDuringQueryMutex mutex. (1).
// We then have to wait for the mCrystalsThreadisLocked mutex (2), this
// is to ensure that it is CRYSTALS that gets the
// mLockCrystalsQueueDuringQueryMutex mutex, before we reclaim it at (3).
// Once CRYSTALS has got the mLockCrystalsQueueDuringQueryMutex it
// immediately releases it, and also the mCrystalsThread is locked
// mutex, so that we can continue to (4).
//
//             CRYSTALS                INTERFACE (US)
//        --------------------     ---------------------
//           Obtain mCTIL
//        Waiting for mLCQDQM
//                                  (Finish processing.)
//                                    Release mLCQDQM
//                                   Waiting for mCTIL
//          Obtain mLCQDQM
//         Release mLCQDQM
//          Release mCTIL
//        (Continue running.)
//                                      Obtain mCTIL
//                                     Obtain mLCQDQM
//                                      Release mCTIL
//
}

Boolean	CcController::IsSpace( char c )
{
	return (   c == ' '
			|| c == '\t'
			|| c == '\r'
			|| c == '\n'
			|| c == '=' 
			|| c == ',' );
}

Boolean	CcController::IsDelimiter( char c )
{
	//   ' is the delimiter.
#define kQuoteChar 39
	return ( c == kQuoteChar ) ;
}

void  CcController::AppendToken( CcString text  )
{
// Copy the string onto the heap, so that it will hang around.

      CcString * theString = new CcString( text );

// Add it to the tokenlist.

	mCurTokenList->AddItem( theString );
}

void  CcController::AddCrystalsCommand( CcString line, Boolean jumpQueue)
{
      CrEditBox * theInput = ( CrEditBox * ) GetInputPlace();
      CcString inpName = theInput->mName;

//Pre check for commands which we should handle. (Useful as these can be handled while the crystals thread is busy...)
// 1. Close the main window. (Close the program).
      if( line.Length() > 10 )
      {
         if( line.Sub(1,11) == "_MAIN CLOSE")
         {
		AddInterfaceCommand("^^CO DISPOSE _MAIN ");
            mThisThreadisDead = true;
		return; //Messy at the moment. Need to do this from crystals thread so it can exit cleanly.
         }
      }
// 2. Allow GUIelements to send commands directly to the interface. Trap them here.
      if( line.Length() >= 4 )
      {
         if( line.Sub(1,2) == "^^")
         {
              AddInterfaceCommand(line);
              return;
         }
      }

// 3. Everything else.

//Add this command to the queue to crystals.
#ifdef __WINDOWS__
	WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE );
#endif

      mCrystalsCommandQueue.SetCommand( line, jumpQueue);

#ifdef __WINDOWS__
	ReleaseMutex( mCrystalsCommandQueueMutex );
	PulseEvent(mCrystalsCommandQueueEmptyEvent );
#endif
}

void  CcController::AddInterfaceCommand( CcString line )
{
/*  This is a critical section between the threads.
 *  If the interface thread has a lock on the section, then we
 *  have to wait (using a mutex sync object).

 *  If the command is a query from the CRYSTALS program ( ^^?? ), then
 *  we must get a lock on the Crystals Command Queue, so that
 *  nothing can be read from it, until the answer to the query
 *  is placed at the top of the queue.
 */
	
#ifdef __WINDOWS__
	WaitForSingleObject( mInterfaceCommandQueueMutex, INFINITE );
#endif
      if(mThisThreadisDead) endthread(0);

      mInterfaceCommandQueue.SetCommand( line );
	
#ifdef __WINDOWS__
	ReleaseMutex( mInterfaceCommandQueueMutex );
#endif
      LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Adding: " + line );


      for ( int j = 1; j < min ( line.Length()-3, 6 ); j++ )
      {
            if ( line.Sub(j,j+3) == "^^??" )
            {
                  j = line.Length();
			LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Crystals Output Queue Locked");
                  CompleteProcessing();
                  LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Crystals Output Queue Unlocked");
            }
      }


//      PostThreadMessage( CcController::threadID, WM_STUFFTOPROCESS, NULL, NULL );
}

//This is a list of commands for crystals to process
Boolean	CcController::GetCrystalsCommand( char * line )
{
//This is where the Crystals thread will spend most of its time.
//Waiting for the user to do somethine.

//Wait until the list is free for reading.
#ifdef __WINDOWS__
      WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE );
#endif
	if (mThisThreadisDead) return false;

	while ( ! mCrystalsCommandQueue.GetCommand( line ) )
	{
//The queue is empty, so wait efficiently. Release the mutex first, so that someone else can write to the queue!
            m_Wait = false;
#ifdef __WINDOWS__
		ReleaseMutex( mCrystalsCommandQueueMutex );
	    //WaitForSingleObject( mCrystalsCommandQueueEmptyEvent, INFINITE ); //Sometimes we miss the pulseevent, so don't wait forever (just wait efficiently).
		WaitForSingleObject( mCrystalsCommandQueueEmptyEvent, 500 ); //Wait for event, or for 500ms, whichever is sooner.
#endif
            if (mThisThreadisDead) return false;
//The writer has signalled us (or we got bored of waiting) now get the mutex and read the queue.
#ifdef __WINDOWS__
		WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE );
#endif
            if (mThisThreadisDead) return false;
	}
#ifdef __WINDOWS__
	ReleaseMutex( mCrystalsCommandQueueMutex );
#endif

	if (mThisThreadisDead) return false;

	LOGSTAT("!!!Crystals thread: Got command: "+ CcString(line));

    if (CcString(line) == "#DIENOW") endthread(0);

//Signal the text output that NOECHO has finished. (In case it was ever started.)
//      ((CrTextOut*)GetTextOutputPlace())->NoEcho(false);
//      ((CrTextOut*)GetBaseTextOutputPlace())->NoEcho(false);

      m_Wait = true;

	return (true);
}


// Introducing the global function ChangeDir:
void ChangeDir(CcString dir);
// Implemented in the CxApp source file.

Boolean	CcController::GetInterfaceCommand( char * line )
{
	//This routine gets called repeatedly by the Idle loop.
	//It needn't be highly optimised even though it is high on
	//the profile count list.

#ifdef __WINDOWS__
	DWORD threadStatus;
	CWinThread *temp = CxApp::mCrystalsThread;
#endif
#ifdef __LINUX__
      int threadStatus;
      wxThread *temp = CxApp::mCrystalsThread;
#endif

	if(temp != nil)

#ifdef __WINDOWS__
	GetExitCodeThread(temp->m_hThread,&threadStatus);
      if(threadStatus != STILL_ACTIVE)
#endif
#ifdef __LINUX__
      if ( ! (temp->IsAlive()) )
#endif
      {
            if ( m_restart )
            {
                 ChangeDir( m_newdir );
                 mAppContext->StartCrystalsThread();
                 m_restart = false;
                 return (false);
            }

            mThisThreadisDead = true;
		strcpy(line,"^^CO DISPOSE _MAIN ");
		return (true);
	}

	
#ifdef __WINDOWS__
      WaitForSingleObject( mInterfaceCommandQueueMutex, INFINITE );
#endif 
	
	if ( ! mInterfaceCommandQueue.GetCommand( line ) )
	{
		strcpy( line, "" );
            if ( m_Completing )
            {
                  ProcessingComplete();
            }

#ifdef __WINDOWS__
		ReleaseMutex( mInterfaceCommandQueueMutex );
#endif
            return (false);
	}
	else
	{
		CcString temp = CcString(line);
		LOGSTAT("CcController:GetInterfaceCommand Getting this command: "+temp);
#ifdef __WINDOWS__
		ReleaseMutex( mInterfaceCommandQueueMutex );
#endif
            return (true);
	}
}

Boolean     CcController::GetInterfaceCommand( CcString * line )
{
	//This routine gets called repeatedly by the Idle loop.
	//It needn't be highly optimised even though it is high on
	//the profile count list.

#ifdef __WINDOWS__
	DWORD threadStatus;
	CWinThread *temp = CxApp::mCrystalsThread;
#endif
#ifdef __LINUX__
      int threadStatus;
      wxThread *temp = CxApp::mCrystalsThread;
#endif

	if(temp != nil)

#ifdef __WINDOWS__
	GetExitCodeThread(temp->m_hThread,&threadStatus);
      if(threadStatus != STILL_ACTIVE)
#endif
#ifdef __LINUX__
      if ( ! (temp->IsAlive()) )
#endif
      {
            if ( m_restart )
            {
                 ChangeDir( m_newdir );
                 mAppContext->StartCrystalsThread();
                 m_restart = false;
                 return (false);
            }

            mThisThreadisDead = true;
            *line = "^^CO DISPOSE _MAIN ";
		return (true);
	}

	
#ifdef __WINDOWS__
      WaitForSingleObject( mInterfaceCommandQueueMutex, INFINITE );
#endif 
	
	if ( ! mInterfaceCommandQueue.GetCommand( line ) )
	{
//            strcpy( line, "" );
             *line = "";
#ifdef __WINDOWS__
		ReleaseMutex( mInterfaceCommandQueueMutex );
#endif
            return (false);
	}
	else
	{
            LOGSTAT("CcController:GetInterfaceCommand Getting this command: "+ *line);
#ifdef __WINDOWS__
		ReleaseMutex( mInterfaceCommandQueueMutex );
#endif
            return (true);
	}
}

void	CcController::LogError( CcString errString , int level )
{
	if ( mErrorLog == nil )
	{
		mErrorLog = fopen( "Script.log", "w+" );
	}
	if ( level == 1 ) //Warning mark with stars.
	{
		errString = "**** Warning: " + errString;
	}
	else if (level == 0) //Serious error mark with XXXX's
	{
		errString = "XXXX Error: " + errString;
	}
	fprintf( mErrorLog, "%s\n", errString.ToCString() );
	fflush( mErrorLog );

      #ifdef __LINUX__
            cerr << errString.ToCString() << "\n";
      #endif
}


CrGUIElement* CcController::FindObject(CcString Name)
{

	CrGUIElement * theElement = nil, * theItem;
	
	mWindowList.Reset();
	theItem = (CrGUIElement *)mWindowList.GetItemAndMove();
	
	while ( theItem != nil && theElement == nil )
	{
		theElement = theItem->FindObject( Name );
		theItem = (CrGUIElement *)mWindowList.GetItemAndMove();
	}

                            
	return ( theElement );
}

void CcController::FocusToInput(char theChar)
{
	int nChar = (int) theChar;
	if( nChar == 13) //Return key, process input.
	{
            ((CrEditBox*)GetInputPlace())->ReturnPressed();
            GetInputPlace()->CrFocus();
	}
	else if ( nChar > 31 && nChar < 127 ) //Some keyboard text. Append to command line.
	{
		char theText[256];
            int theLen = ((CxEditBox*)(GetInputPlace()->GetWidget()))->GetText(&theText[0]);
		theText[theLen] = theChar;
		theText[theLen+1] = '\0';
            GetInputPlace()->SetText(CcString(theText));
            GetInputPlace()->CrFocus();
	}
}

void CcController::SetTextOutputPlace(CrGUIElement * outputPane)
{
	mTextOutputWindowList.AddItem((void*)outputPane);
	mTextWindow = outputPane;
}

CrGUIElement* CcController::GetTextOutputPlace()
{
	CrGUIElement* retVal;

	while ((retVal = (CrGUIElement*) mTextOutputWindowList.GetLastItem()) == nil)
	{
		mTextOutputWindowList.RemoveItem();
		if (mTextOutputWindowList.ListSize() <= 0)
			return nil;
	}
	mTextWindow = retVal;
	return retVal;
}

CrGUIElement* CcController::GetBaseTextOutputPlace()
{
	mTextOutputWindowList.Reset();
	CrGUIElement* retVal = (CrGUIElement*) mTextOutputWindowList.GetItem();
	return retVal;
}

void CcController::SetProgressOutputPlace(CrGUIElement * outputPane)
{
	mProgressOutputWindowList.AddItem((void*)outputPane);
	if(mProgressWindow != nil)
		mProgressWindow->SetText(" ");
	mProgressWindow = outputPane;

}

CrGUIElement* CcController::GetProgressOutputPlace()
{
	CrGUIElement* retVal;

	while ((retVal = (CrGUIElement*) mProgressOutputWindowList.GetLastItem()) == nil)
	{
		mProgressOutputWindowList.RemoveItem();
		if (mProgressOutputWindowList.ListSize() <= 0)
			return nil;
	}
	mProgressWindow = retVal;
	return retVal;
}

void CcController::SetInputPlace(CrGUIElement * inputPane)
{
      mInputWindowList.AddItem((void*)inputPane);
      mInputWindow = inputPane;

}

CrGUIElement* CcController::GetInputPlace()
{
	CrGUIElement* retVal;
      while ((retVal = (CrGUIElement*) mInputWindowList.GetLastItem()) == nil)
	{
            mInputWindowList.RemoveItem();
            if (mInputWindowList.ListSize() <= 0)
			return nil;
	}
      mInputWindow = retVal;
	return retVal;
}




void CcController::RemoveTextOutputPlace(CrGUIElement* output)
{
      while ( mTextOutputWindowList.FindItem((void*) output) )
      {
            mTextOutputWindowList.RemoveItem();
      }
}

void CcController::RemoveProgressOutputPlace(CrGUIElement* output)
{
      while ( mProgressOutputWindowList.FindItem((void*) output) )
      {
            mProgressOutputWindowList.RemoveItem();
      }
      mProgressWindow = nil;

}

void CcController::RemoveInputPlace(CrGUIElement* input)
{
      while ( mInputWindowList.FindItem((void*) input) )
      {
            mInputWindowList.RemoveItem();
      }
}

void CcController::RemoveWindowFromList(CrWindow* window)
{
// CxWindows can be destroyed by the framework, when their parent
// windows are destroyed. This bypasses our normal destruction
// method, so to be safe, all dying windows call this function
// to 'de-register' themselves from the Controller's list.

      while ( mWindowList.FindItem((void*) window) )
      {
            mWindowList.RemoveItem();
      }
}



CcModelDoc* CcController::FindModelDoc(CcString name)
{
	mModelDocList.Reset();
	CcModelDoc* aModelDoc = nil;
	while ( ( aModelDoc = (CcModelDoc*)mModelDocList.GetItemAndMove() ) != nil ) 
	{
		if(aModelDoc->mName == name)  return aModelDoc;
	}
	return nil;
}

CcModelDoc* CcController::CreateModelDoc(CcString name)
{
	CcModelDoc* modelDoc;
	modelDoc = FindModelDoc(name);
	if ( modelDoc == nil )
	{
		modelDoc = new CcModelDoc();
		mCurrentModelDoc = modelDoc;
		mCurrentModelDoc->mName = name;
		mModelDocList.AddItem(mCurrentModelDoc);
	}
	return modelDoc;
}

CcRect CcController::GetScreenArea()
{
	CcRect retVal;
#ifdef __WINDOWS__
	RECT screenRect;
	SystemParametersInfo( SPI_GETWORKAREA, 0, &screenRect, 0 );

	retVal.Set( screenRect.top,
				screenRect.left,
				screenRect.bottom,
				screenRect.right);
#endif
#ifdef __LINUX__
      wxSystemSettings ss;
      retVal.mTop = 0;
      retVal.mLeft = 0;
      retVal.mBottom = ss.GetSystemMetric(wxSYS_SCREEN_Y);
      retVal.mRight = ss.GetSystemMetric(wxSYS_SCREEN_X);

      cerr << "Screen Area: " << retVal.mRight << "," << retVal.mBottom << "\n";
#endif
	return retVal;
}

void CcController::History(Boolean up)
{
	if (up)
		mCommandHistoryPosition ++;
	else
		mCommandHistoryPosition --;

	int listSize = mCommandHistoryList.ListSize();

	mCommandHistoryPosition = min ( mCommandHistoryPosition, listSize );
	mCommandHistoryPosition = max ( mCommandHistoryPosition, 0 );

	mCommandHistoryList.Reset();
	for ( int i = 0; i < listSize - mCommandHistoryPosition; i++ )
	{
		mCommandHistoryList.GetItemAndMove();
	}
	CcString *temp = (CcString*) mCommandHistoryList.GetItem();

	if (temp == nil)
	{
            GetInputPlace()->SetText("");
	}
	else
	{
            GetInputPlace()->SetText(*temp);
	}
}

void CcController::GetValue(CcTokenList * tokenList)
{
	LOGSTAT("CcController: Getting Value");
	
	CcString name = tokenList->GetToken();	// Get the name of the object
	CrGUIElement * theElement;

	if ( mCurrentWindow != nil )
	{
		// Look for the item in current window first.
		 theElement = mCurrentWindow->FindObject( name );
	}

	if ( theElement == nil )
	{
		// Look for the element everywhere.
		theElement = FindObject ( name );
	}
	
//If this is an EXISTS query, then send either TRUE or FALSE
//If this is another query pass control to object, or if it doesn't exist, return ERROR.

	if( tokenList->GetDescriptor(kQueryClass) == kTQExists )
	{
		tokenList->GetToken(); //Remove token.

		if ( theElement != nil )
			SendCommand("TRUE",true); //This is used to check if an object exists.
		else
			SendCommand("FALSE",true); //This is used to check if an object exists.
	}
	else
	{
		if ( theElement != nil )
			theElement->GetValue(tokenList);
		else
		{
			SendCommand("ERROR",true);
			LOGWARN( "CcController:GetValue couldn't find object with name '" + name + "'");
		}

	}
}


void  CcController::SetProgressText(CcString * theText)
{
      CrProgress* theElement = nil;
      theElement = (CrProgress*) GetProgressOutputPlace();
      if (theElement != nil)
      {
            theElement->SwitchText( theText );
      }

}


void CcController::StoreKey( CcString key, CcString value )
{
	FILE * file;
      FILE * tempf;
      char * tempn;
      char buffer[256];
      char filen[256];

      char* crysdir = getenv("CRYSDIR") ;
      if ( crysdir == nil )
            cerr << "You must set CRYSDIR before running crystals.\n";
      else
      {
         int icrysdir = strlen( crysdir ) ;
         strcpy ( &filen[0], crysdir ) ;
#ifdef __WINDOWS__
         strcpy ( &filen[0]+icrysdir, "\\script\\winsizes.ini" ) ;
#endif
#ifdef __LINUX__
         strcpy ( &filen[0]+icrysdir, "/guimenu.srt/winsizes.ini" ) ;
#endif
      }

// Open the
// winsizes file
// for reading.
      if( (file = fopen( filen, "r" )) == NULL ) //Assignment witin conditional - OK
	{
            LOGERR ( "Could not open winsizes.ini for reading. Assume does not exist." );
            if( (file = fopen( filen, "w" )) == NULL ) //Assignment witin conditional - OK
            {
                  LOGERR ( "Could not open winsizes.ini for writing." );
                  return;
            }
            // We open it for writing, assuming it doesn't exist,
            // and simply write this key and size into it.
      }
      else
      {
// Get a name
// for a temp
// file.
            if ( ( tempn = tmpnam( NULL )) == NULL )
            {
                  LOGERR ( "Could not get name for temp file." );
                  return;
            }
// Open the
// temp file.
            if ( ( tempf = fopen ( tempn, "a+" ) ) == NULL )
            {
                  LOGERR ( "Could not get open temp file: " + CcString ( tempn )  );
                  return;
            }
// Copy winsizes
// to the temp
// file.
            while ( ! feof( file ) )
            {
                  if ( fgets( buffer, 256, file ) != NULL )
                  {
                        CcString ccbuf = buffer;
                        if ( ccbuf.Length() > key.Length() )
						{
							if (!(key == ccbuf.Sub( 1, key.Length() )))
							{
                              fputs ( buffer, tempf);
							}
						}
				  }
            }
            fclose( file );
            rewind( tempf );
// Re-open 
// winsizes for
// writing.
            if( (file = fopen( filen, "w" )) == NULL ) //Assignment witin conditional - OK
            {
                  LOGERR ( "Could not open winsizes.ini for writing" );
                  return;
            }
// Copy the
// file back
            while ( ! feof( tempf ) )
            {
                  if ( fgets( buffer, 256, tempf ) != NULL )
                  {
                        fputs ( buffer, file );
                  }
            }
            fclose ( tempf );
            remove ( tempn );
      }
// Add this key
// on to the
// end.
      sprintf(buffer, "%s %s",
                      key.ToCString(),
                      value.ToCString());
      fputs ( buffer, file );
      fputs ( "\n", file );
      fclose ( file );

      return;

}

CcString CcController::GetKey( CcString key )
{
	FILE * file;
      char buffer[256];
      CcString value;

      char* crysdir = getenv("CRYSDIR") ;
      if ( crysdir == nil )
      {
            cerr << "You must set CRYSDIR before running crystals.\n";
      }
      else
      {
         int icrysdir = strlen( crysdir ) ;
         strcpy ( &buffer[0], crysdir ) ;
#ifdef __WINDOWS__
         strcpy ( &buffer[0]+icrysdir, "\\script\\winsizes.ini" ) ;
#endif
#ifdef __LINUX__
         strcpy ( &buffer[0]+icrysdir, "/guimenu.srt/winsizes.ini" ) ;
#endif
      }

      if( file = fopen( buffer, "r" ) ) //Assignment witin conditional - OK
	{
		while ( ! feof( file ) )
		{
			if ( fgets( buffer, 256, file ) != NULL )
                  {
                        CcString ccbuf = buffer;
						if ( key.Length() < ccbuf.Length() )
						{
							if ( key == ccbuf.Sub( 1, key.Length() ) )
							{
		                          value = ccbuf.Chop(1,key.Length()+1);
// NB value includes the new line, chop it off.
			                      value = value.Chop( value.Length(), value.Length() );
				            }
						}
                  }
		}
		fclose( file );
	}

      return value;

}

void CcController::AddHistory( CcString theText )
{
      CcString *historyCommand = new CcString ( theText );
      mCommandHistoryList.AddItem( (void*) historyCommand);
      mCommandHistoryList.Reset();
      while ( mCommandHistoryList.ListSize() > 100 ) //Limit the history to 100 items.
      {
            CcString *temp = (CcString*) mCommandHistoryList.GetItem();
            delete temp;
            mCommandHistoryList.RemoveItem();
      }
      mCommandHistoryPosition = 0;
}
