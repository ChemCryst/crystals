////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr
//   Modified:  30.3.1998 12:23 Uhr

// $Log: not supported by cvs2svn $
// Revision 1.4  1999/04/30 16:56:49  dosuser
// RIC: Added SetProgressText(CcString Text) to allow the model window to
//      display atom names in the current progress/status bar.
//

#include	"crystalsinterface.h"
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

HANDLE mInterfaceCommandQueueMutex;
HANDLE mCrystalsCommandQueueMutex;
HANDLE mCrystalsCommandQueueEmptyEvent;
HANDLE mLockCrystalsQueueDuringQueryMutex;
HANDLE mCrystalsThreadIsLocked;

CcController* CcController::theController = nil;	

extern "C" {
void	ciendthread(		long *theExitcode );
}

CcController::CcController( CxApp * appContext )
{

//Things
	mAppContext = appContext;
	mErrorLog = nil;
	mThisThreadisDead = FALSE;

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
	
// Win32 specific: Set up MUTEXES for synchronising threads.
// ie. Only one thread at a time can access the command and interface queues to prevent corruption.
// (as long as they use them!) See {Add/Get}InterfaceCommand and {Add/Get}CrystalsCommand.
	mInterfaceCommandQueueMutex        = CreateMutex(NULL, FALSE, NULL);
	mCrystalsCommandQueueMutex         = CreateMutex(NULL, FALSE, NULL);
	mLockCrystalsQueueDuringQueryMutex = CreateMutex(NULL, FALSE, NULL);
	mCrystalsThreadIsLocked            = CreateMutex(NULL, FALSE, NULL);

	WaitForSingleObject( mLockCrystalsQueueDuringQueryMutex, INFINITE ); //We want this all the time.

	mCrystalsCommandQueueEmptyEvent    = CreateEvent(NULL, TRUE, FALSE, NULL);

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

	delete (CxGrid::mp_font);

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
					mAppContext->OpenFileDialog(&result, extension, description, TRUE);
					tokenList->GetToken(); //Remove token
				}
				else
				{
					mAppContext->OpenFileDialog(&result, extension, description, FALSE);
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

Boolean	CcController::ParseLine( char * text )
{

	int start = 0, stop = 0, i;
	Boolean inSpace = true;
	Boolean inDelimiter = false;
	
	for (i=1;i< (int)strlen( text ) + 1; i++ )
	{
		if ( inDelimiter )
		{
			if ( IsDelimiter( text[i-1] ) )  // end of item
			{
				stop = i;
				AppendToken(text, start, stop ) ;// add item to token list

				// init values
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
					stop = i;
					// add item to token list
					AppendToken(text, start, stop );
				
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
		stop = i;

		// add item to token list
		AppendToken(text, start, stop );
	}
	return true; // *** for now
//End of user code.         
}

void	CcController::SendCommand( CcString command , Boolean jumpQueue)
{
	LOGSTAT("CcController:SendCommand received command '" + command + "'");
	TRACE("Sending command %s ",command.ToCString());
	char* theLine = (char*)command.ToCString();
	AddCrystalsCommand(theLine, jumpQueue);
}

void	CcController::Tokenize( char * text )
{
	Boolean proc = false, stop = false;
	
//This is a considerable overhead for intensive bits of code, let's
//leave it out for now { 

	// First preflight for misplaced selectors
	for ( int j=0; (stop != true) && (j < (int)strlen(text)-1); j++ )
	{
		if ( strncmp( text + j, "^^", 2) == 0 )
//			*(text + j)		== '^'
//			&&	*(text + j + 1) == '^')
		{
			char buf [256];
			strcpy( buf, (char *)(text + j) );
			strcpy( text, buf );
			stop = true;
		}
	}


//	TRACE("This is the text after first flight %s \n",text);
	
	if ( strlen( text ) >= 4 && strncmp( text, "^^", 2 ) == 0 )
	// It is definitely tagged text
	{
		// Get the selector and determine list to use
		if       ( strncmp( (char *)(text + 2), kSWindowSelector, 2 ) == 0 )  //Windows
		{
			mCurTokenList = mWindowTokenList;
			ParseLine( (char *)(text + 4) );
		}
		else if  ( strncmp( (char *)(text + 2), kSChartSelector, 2 ) == 0 )   //Charts (ChartDoc)
		{
			mCurTokenList = mChartTokenList;
			ParseLine( (char *)(text + 4) );
		}
		else if  ( strncmp( (char *)(text + 2), kSModelSelector, 2 ) == 0 )   //Models (ModelDoc)
		{
			mCurTokenList = mModelTokenList;
			ParseLine( (char *)(text + 4) );
		}
		else if  ( strncmp( (char *)(text + 2), kSStatusSelector, 2 ) == 0 )  //Status (CcStatus)
		{
			mCurTokenList = mStatusTokenList;
			ParseLine( (char *)(text + 4) );
		}
		else if ( strncmp( (char *)(text + 2), kSControlSelector, 2 ) == 0 )  //CR closes any input stream.
		{
			while ( ParseInput( mCurTokenList ) );
		}
		else if  ( strncmp( (char *)(text + 2), kSOneCommand, 2 ) == 0 ) //Quick one liner commands, usually from Crystals itself rather than scripts.
		{																 //Avoids breaking up (and corrupting) the incoming streams from scripts.
			mTempTokenList = mCurTokenList;
			mCurTokenList  = mQuickTokenList;
			ParseLine( (char *)(text + 4) );
			while ( ParseInput( mQuickTokenList ) );
			mCurTokenList  = mTempTokenList;
		}
		else if  ( strncmp( (char *)(text + 2), kSQuerySelector, 2 ) == 0 )  //Windows
		{
			mTempTokenList = mCurTokenList;
			mCurTokenList  = mQuickTokenList;
			ParseLine( (char *)(text + 4) );
			GetValue( mQuickTokenList ) ;
			mCurTokenList  = mTempTokenList;
			//We must now signal the waiting Crystals thread that it's input is ready.
			ReleaseMutex( mLockCrystalsQueueDuringQueryMutex ); //We always hold this. Crystals thread is waiting for it.
			WaitForSingleObject( mCrystalsThreadIsLocked, INFINITE ); //Crystals thread gets the mLCQDQMutex, releases it, then releases this one.
			WaitForSingleObject( mLockCrystalsQueueDuringQueryMutex, INFINITE ); //We want this back.
			ReleaseMutex( mCrystalsThreadIsLocked ); //Crystals thread needs this next time.
		}	
	}
	else                                             // Simple output text or comment
	{
			long len = strlen( text );
			mAppContext->ProcessOutput( &len, text );
	}
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

void	CcController::AppendToken( char * text, int start, int stop )
{

	char s[255];
	strncpy( s, &text[start-1], stop - start );
	
	// *** TODO uppercase ? //This will uppercase all button text etc. Not pleasing. Do it in CcTokenList instead.
	s[stop - start] = '\0';
	
	CcString * theString = new CcString( s );	
	mCurTokenList->AddItem( theString );

}

void	CcController::AddCrystalsCommand( char * line, Boolean jumpQueue)
{

//Pre check for commands which we should handle. (Useful as these can be handled while the crystals thread is busy...)
// 1. Close the main window. (Close the program).
	if(strncmp(line,"_MAIN CLOSE",11) == 0)
	{
		AddInterfaceCommand("^^CO DISPOSE _MAIN ");
		mThisThreadisDead = TRUE;
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
	WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE );
	mCrystalsCommandQueue.SetCommand( CcString(line), jumpQueue);
	ReleaseMutex( mCrystalsCommandQueueMutex );
	PulseEvent(mCrystalsCommandQueueEmptyEvent );
//End of user code.         
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

	
	WaitForSingleObject( mInterfaceCommandQueueMutex, INFINITE );

	if(mThisThreadisDead) ciendthread(0);

	mInterfaceCommandQueue.SetCommand( CcString(line) );
	
	ReleaseMutex( mInterfaceCommandQueueMutex );

	LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Adding: "+CcString(line));

	Boolean stop = false;
	int leng = (int)strlen ( line );
	for ( int j=0; (stop != true) && (j < leng-3); j++ )
	{
		if ( strncmp ( line + j, "^^??", 4 ) == 0 )
		{
			stop = true;
			LOGSTAT("!!!Crystals thread: CcController:AddInterfaceCommand: Crystals Output Queue Locked");
			WaitForSingleObject( mCrystalsThreadIsLocked, INFINITE );
//This MUTEX is not normally owned. It stops the interface thread from
//reclaiming the LockCrystalsQueue...Mutex before this thread gets it.
			if(mThisThreadisDead) ciendthread(0);

//We (CRYSTALS) must wait here until the answer to this query has been put at the front
//of the command queue.
			WaitForSingleObject( mLockCrystalsQueueDuringQueryMutex, INFINITE );
//This MUTEX is always held by the interface thread. It is released
//temporarily by the interface thread after processing a ^^?? instruction.
//It is reclaimed once the mCrystalsThreadIsLocked mutex is released by this thread.
			if(mThisThreadisDead) ciendthread(0);

			ReleaseMutex( mLockCrystalsQueueDuringQueryMutex ); //Release and continue
			ReleaseMutex( mCrystalsThreadIsLocked );            //Release to allow the interface thread to continue.
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
	WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE ); 

	if (mThisThreadisDead) return false;

	while ( ! mCrystalsCommandQueue.GetCommand( line ) )
	{
//The queue is empty, so wait efficiently. Release the mutex first, so that someone else can write to the queue!
		ReleaseMutex( mCrystalsCommandQueueMutex );

	    //WaitForSingleObject( mCrystalsCommandQueueEmptyEvent, INFINITE ); //Sometimes we miss the pulseevent, so don't wait forever (just wait efficiently).
		WaitForSingleObject( mCrystalsCommandQueueEmptyEvent, 500 ); //Wait for event, or for 500ms, whichever is sooner.
		if (mThisThreadisDead) return false;
//The writer has signalled us (or we got bored of waiting) now get the mutex and read the queue.
		WaitForSingleObject( mCrystalsCommandQueueMutex, INFINITE );
		if (mThisThreadisDead) return false;
	}
	ReleaseMutex( mCrystalsCommandQueueMutex );

	if (mThisThreadisDead) return false;

	LOGSTAT("!!!Crystals thread: Got command: "+ CcString(line));

//Signal the text output that NOECHO has finished. (In case it was ever started.)
	((CrMultiEdit*)GetTextOutputPlace())->NoEcho(FALSE);
	((CrMultiEdit*)GetBaseTextOutputPlace())->NoEcho(FALSE);
	return (true);
}

Boolean	CcController::GetInterfaceCommand( char * line )
{
	//This routine gets called repeatedly by the Idle loop.
	//It needn't be highly optimised even though it is high on
	//the profile count list.
	WaitForSingleObject( mInterfaceCommandQueueMutex, INFINITE );

	DWORD threadStatus;
	CWinThread *temp = CxApp::mCrystalsThread;
	if(temp != nil)
	GetExitCodeThread(temp->m_hThread,&threadStatus);
	if(threadStatus != STILL_ACTIVE)
	{
		mThisThreadisDead = TRUE;
		strcpy(line,"^^CO DISPOSE _MAIN ");
		return (true);
	}

	
	
	
	if ( ! mInterfaceCommandQueue.GetCommand( line ) )
	{
		strcpy( line, "" );
		ReleaseMutex( mInterfaceCommandQueueMutex );
		return (false);
	}
	else
	{
		CcString temp = CcString(line);
		LOGSTAT("CcController:GetInterfaceCommand Getting this command: "+temp);
		ReleaseMutex( mInterfaceCommandQueueMutex );
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
	RECT screenRect;
	SystemParametersInfo( SPI_GETWORKAREA, 0, &screenRect, 0 );

	CcRect retVal;
	retVal.Set( screenRect.top,
				screenRect.left,
				screenRect.bottom,
				screenRect.right);

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
			long len = text.Length();
			mAppContext->ProcessOutput( &len, (char*) text.ToCString() );
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
