
////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr
//   Modified:  30.3.1998 12:23 Uhr

// $Log: not supported by cvs2svn $
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

#include <iostream.h>
#include <iomanip.h>
#include    "crystalsinterface.h"
#include	"crconstants.h"
#include	"cccontroller.h"
//insert your own code here.
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
#include	"ccchartdoc.h"
#include	"ccmodeldoc.h"
#include	"ccquickdata.h"
#include	"ccchartobject.h"
//End of user code.

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

      m_newdir = "";
      m_restart = false;

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
#ifdef __LINUX__
                        cerr << "Back in cccontroller::parseinput\n";
#endif
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
				else                // if ( mCurrentWindow != nil ) No search all windows.
				{
					// Look for the item
					theElement = FindObject( name );
					if(theElement)
						theElement->ParseInput( tokenList );
					else
						LOGWARN( "CcController:ParseInput:Set couldn't find object with name '" + name + "'");
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
                              LOGWARN( "CcController:ParseInput:Rename couldn't find object with name '" + name + "'");
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
			case kTSetStatus:
			{
				tokenList->GetToken();
				status.ParseInput(mCurTokenList);
			}

/*			case kTUnknown:
			{
				//Something has gone wrong.

				//Remove this token so that we don't loop forever. Hopefully we will
				//find our way to a sensible token eventually.
				break;

			}*/
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

//This is a considerable overhead for intensive bits of code, let's
//leave it out for now { 
      int j = 1;
      int clen = cText.Len();

      for ( j = 1; ( j < clen-1 ); j++ )
	{
            if ( cText.Sub(j,j+1) == "^^" )
            {
                  cText = cText.Sub(j,clen);
                  j = clen;
            }
      }

//      // First preflight for misplaced selectors
//      for ( int j=0; (stop != true) && (j < (int)strlen(text)-1); j++ )
//      {
//            if ( strncmp( text + j, "^^", 2) == 0 )
//            {
//                  char buf [256];
//                  strcpy( buf, (char *)(text + j) );
//                  strcpy( text, buf );
//                  stop = true;
//            }
//      }
//

//	TRACE("This is the text after first flight %s \n",text);
	
      if ( cText.Len() >= 4 && cText.Sub(1,2) == "^^" )
	// It is definitely tagged text
	{
		// Get the selector and determine list to use
            if      ( cText.Sub(3,4) == kSWindowSelector ) 
		{
			mCurTokenList = mWindowTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
            else if      ( cText.Sub(3,4) == kSChartSelector ) 
		{
			mCurTokenList = mChartTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
            else if      ( cText.Sub(3,4) == kSModelSelector ) 
		{
			mCurTokenList = mModelTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
            else if      ( cText.Sub(3,4) == kSStatusSelector ) 
		{
			mCurTokenList = mStatusTokenList;
                  ParseLine( cText.Chop(1,4) );
		}
            else if      ( cText.Sub(3,4) == kSControlSelector ) 
		{
			while ( ParseInput( mCurTokenList ) );
		}
            else if      ( cText.Sub(3,4) == kSOneCommand ) 
		{																 //Avoids breaking up (and corrupting) the incoming streams from scripts.
			mTempTokenList = mCurTokenList;
			mCurTokenList  = mQuickTokenList;
                  ParseLine( cText.Chop(1,4) );
			while ( ParseInput( mQuickTokenList ) );
			mCurTokenList  = mTempTokenList;
		}
            else if      ( cText.Sub(3,4) == kSQuerySelector ) 
		{
			mTempTokenList = mCurTokenList;
			mCurTokenList  = mQuickTokenList;
                  ParseLine( cText.Chop(1,4) );
			GetValue( mQuickTokenList ) ;
			mCurTokenList  = mTempTokenList;
			//We must now signal the waiting Crystals thread that it's input is ready.
                  ProcessingComplete();
		}
	}
	else                                             // Simple output text or comment
	{
                  mAppContext->ProcessOutput( cText );
	}

#ifdef __LINUX__
            cerr << "Exiting Tokenize\n";
#endif
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

//      char s[255];
//      strncpy( s, &text[start-1], stop - start );
	
	// *** TODO uppercase ? //This will uppercase all button text etc. Not pleasing. Do it in CcTokenList instead.
//      s[stop - start] = '\0';
	
// Copy the string onto the heap, so that it will hang around.

      CcString * theString = new CcString( text );

// Add it to the tokenlist.

	mCurTokenList->AddItem( theString );

//DEBUG!
//      if ( *theString == "XHELP" ) abort();

}

void	CcController::AddCrystalsCommand( char * line, Boolean jumpQueue)
{

//Pre check for commands which we should handle. (Useful as these can be handled while the crystals thread is busy...)
// 1. Close the main window. (Close the program).
	if(strncmp(line,"_MAIN CLOSE",11) == 0)
	{
		AddInterfaceCommand("^^CO DISPOSE _MAIN ");
            mThisThreadisDead = true;
		return; //Messy at the moment. Need to do this from crystals thread so it can exit cleanly.
	}	
// 2. Input text from the user to crystals (send text and clear the edit box).
	if(strncmp(line,"_MAINTEXTINPUT",14) == 0)
	{
//		AddInterfaceCommand("^^CO SET _MAINTEXTINPUT TEXT '' ");
		((CrEditBox*)mInputWindow)->ClearBox();

//Command history stuff:
		CcString *historyCommand = new CcString ( line + 15 );
		mCommandHistoryList.AddItem( (void*) historyCommand);
		mCommandHistoryList.Reset();
		while ( mCommandHistoryList.ListSize() > 100 ) //Limit the history to 100 items.
		{
			CcString *temp = (CcString*) mCommandHistoryList.GetItem();
			delete temp;
			mCommandHistoryList.RemoveItem();
		}
		mCommandHistoryPosition = 0;
//Send command again, but with the first bit of text removed. (_MAINTEXTINPUT )
		AddCrystalsCommand(line+15); //Ooh, recursion.
		return;
	}
// 3. Allow GUIelements to send commands directly to the interface. Trap them here.
	if(strncmp(line,"^^",2) == 0)
	{
		AddInterfaceCommand(line);
		return;
	}

// 4. Everything else.

/*//Check for _N and insert a new line instead.
//This is now done in SetCommand.
  for ( int j=0; j < (int)strlen( line )-1; j++ )
	{
		if ( *(line + j) == '_' && *(line+j+1) == 'N')
		{
			char buf [256];
			strcpy( buf, (char *)(line + j + 2) ); //buf now contains the text after the _N
			*(line+j) = '\0'; //Null character to end the string.
			AddCrystalsCommand(line); //Ooh, more recursion.
			strcpy( line, buf ); //replace line with buf
			j=0; //reset place counter
		}
	}
*/

//Add this command to the queue to crystals.
#ifdef __WINDOWS__
	WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE );
#endif
	mCrystalsCommandQueue.SetCommand( CcString(line), jumpQueue);
#ifdef __WINDOWS__
	ReleaseMutex( mCrystalsCommandQueueMutex );
	PulseEvent(mCrystalsCommandQueueEmptyEvent );
#endif
}

void	CcController::AddInterfaceCommand( char * line )
{
// This is a critical section between the threads.
// If the interface thread has a lock on the section, then we
// have to wait (using a mutex sync object).

// If the command is a query from the CRYSTALS program ( ^^?? ), then
// we must get a lock on the Crystals Command Queue, so that
// nothing can be read from it, until the answer to the query
// is placed at the top of the queue.

	
#ifdef __WINDOWS__
	WaitForSingleObject( mInterfaceCommandQueueMutex, INFINITE );
#endif
      if(mThisThreadisDead) endthread(0);

	mInterfaceCommandQueue.SetCommand( CcString(line) );
	
#ifdef __WINDOWS__
	ReleaseMutex( mInterfaceCommandQueueMutex );
#endif
	LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Adding: "+CcString(line));

	Boolean stop = false;
	int leng = (int)strlen ( line );
	for ( int j=0; (stop != true) && (j < leng-3); j++ )
	{
		if ( strncmp ( line + j, "^^??", 4 ) == 0 )
		{
			stop = true;
			LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Crystals Output Queue Locked");
                  CompleteProcessing();
                  LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Crystals Output Queue Unlocked");
		}
	}



}

//This is a list of commands for crystals to process
Boolean	CcController::GetCrystalsCommand( char * line )
{
//This is where the Crystals thread will spend most of its time.
//Waiting for the user to do something.

//Wait until the list is free for reading.
#ifdef __WINDOWS__
      WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE );
#endif
	if (mThisThreadisDead) return false;

	while ( ! mCrystalsCommandQueue.GetCommand( line ) )
	{
//The queue is empty, so wait efficiently. Release the mutex first, so that someone else can write to the queue!
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

//Signal the text output that NOECHO has finished. (In case it was ever started.)
      ((CrMultiEdit*)GetTextOutputPlace())->NoEcho(false);
      ((CrMultiEdit*)GetBaseTextOutputPlace())->NoEcho(false);
	return (true);
}

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
                 mAppContext->ChangeDir( m_newdir );
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
                 mAppContext->ChangeDir( m_newdir );
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
//Insert your own code here.
	CrGUIElement * theElement = nil, * theItem;
	
	mWindowList.Reset();
	theItem = (CrGUIElement *)mWindowList.GetItemAndMove();
	
	while ( theItem != nil && theElement == nil )
	{
		theElement = theItem->FindObject( Name );
		theItem = (CrGUIElement *)mWindowList.GetItemAndMove();
	}
		
	return ( theElement );
//End of user code.         
}

void CcController::FocusToInput(char theChar)
{
	int nChar = (int) theChar;
	if( nChar == 13) //Return key, process input.
	{
		((CrEditBox*)mInputWindow)->ReturnPressed();
		mInputWindow->CrFocus();
	}
	else if ( nChar > 31 && nChar < 127 ) //Some keyboard text. Append to command line.
	{
		char theText[256];
		int theLen = ((CxEditBox*)mInputWindow->GetWidget())->GetText(&theText[0]);
		theText[theLen] = theChar;
		theText[theLen+1] = '\0';
		mInputWindow->SetText(CcString(theText));
		mInputWindow->CrFocus();
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

void CcController::RemoveTextOutputPlace()
{
	mTextOutputWindowList.GetLastItem();
	mTextOutputWindowList.RemoveItem();
}

void CcController::RemoveProgressOutputPlace()
{
	mProgressOutputWindowList.GetLastItem();
	mProgressOutputWindowList.RemoveItem();
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
		CcString comm = "^^CO SET _MAINTEXTINPUT TEXT ''";
		AddInterfaceCommand( (char*) comm.ToCString() );
	}
	else
	{
		CcString comm = "^^CO SET _MAINTEXTINPUT TEXT '";
		comm += *temp;
		comm += "'";
		AddInterfaceCommand( (char*) comm.ToCString() );
	}
}

void CcController::OutputToScreen(CcString text)
{
                  mAppContext->ProcessOutput( text );
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


void  CcController::SetProgressText(CcString theText)
{
      CrGUIElement* theElement = nil;
      theElement = GetProgressOutputPlace();
      if (theElement != nil)
      {
            theElement->SetText( theText );
      }

}



