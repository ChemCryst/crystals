////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr

// $Log: not supported by cvs2svn $
// Revision 1.34  2001/08/14 10:17:58  ckp2
// The new facility for autoclosing windows when scripts crash out needs to
// make sure the deleted window is not left as the mCurrentWindow.
//
// Revision 1.33  2001/07/16 07:20:41  ckp2
// Much cleaner thread sync.
//
// Revision 1.31  2001/07/03 13:24:27  ckp2
// Fixed race condition in queue critical sections. CRYSTALS now waits (up to 1 second)
// to be signalled that something has been added to the queue instead of looping frantically.
//
// Revision 1.30  2001/06/18 12:27:31  richard
// Include errno.h for the linux version.
//
// Revision 1.29  2001/06/17 15:30:06  richard
// ScriptsExited function loops through window list and closes any MODAL windows
// without the STAYOPEN attribute. (Prevents that problem where scripts crash
// and leave a window open blocking the input.)
//
// Revision 1.28  2001/03/27 15:14:58  richard
// Added a timer to the main window that is activated as the main window is
// created.
// The timer fires every half a second and causes any messages in the
// CRYSTALS message queue to be processed. This is not the main way that messages
// are found and processed, but sometimes the program just seemed to freeze and
// would stay that way until you moved the mouse. This should (and in fact, does
// seem to) remedy that problem.
// Good good good.
//
// Revision 1.27  2001/03/23 11:35:07  richard
// Don't set mCurrentWindow pointer if window fails to be created.
//
// Revision 1.26  2001/03/21 16:58:43  richard
// If ShellExectue fails to launch a program of file, then have a go with the
// old spawnvp method instead. As a knock on effect this fixes the Cameron PRINT command
// and the scripts FILEDELETE operator.
//
// Revision 1.25  2001/03/08 16:44:02  richard
// General changes - replaced common functions in all GUI classes by macros.
// Generally tidied up, added logs to top of all source files.
//
// Revision 1.24  2001/03/08 14:57:19  richard
// Moved all CXAPP and CRAPP functions into this class, to try to make the
// whole thing more understandable. This one class has one instance, and it
// holds all the information about the windows which are open. It also recieves
// the commands from CRYSTALS and messages from the GUI.
// Also some new classes for updating the toolbar, and buttons, and windows based on the old ENABLEIF, DISABLEIF status flags.
// Layout code majorly overhauled.
//
// Revision 1.23  2001/01/25 16:49:48  richard
// Tidied error messages. Introduced debug indent to show structure of
// windows as the are created and shown.
// Remove old quickdata method and static object.
// Rename RESTART command FILE attribute to NEWFILE to prevent clash
// with bitmap FILE attribute.
//
// Revision 1.22  2001/01/18 12:15:56  richard
// Fix command history. Caret only goes to end for AddText calls to
// EDITBOX, stays at begining for SetText calls.
// Command history no longer records empty lines (hooray).
//
// Revision 1.21  2001/01/16 15:34:54  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.20  2000/12/13 18:52:01  richard
// Linux support. Optimise instruction parsing (a bit) for a faster GUI.
//
// Revision 1.19  2000/11/03 10:49:29  csduser
// RIC: New bitmap control
//
// Revision 1.18  2000/09/20 12:50:36  ckp2
// Support for new TEXTOUT control.
//
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
#include    "ccstring.h"
#include    "crconstants.h"
#include    "crgrid.h"
#include    "cclock.h"
#include    "cccontroller.h"
#include    "crwindow.h"
#include    "cxgrid.h" //to delete its static font pointer.
#include    "crbutton.h"
#include    "creditbox.h"
#include    "cctokenlist.h"
#include    "cccommandqueue.h"
#include    "cxeditbox.h"
#include    "crmultiedit.h"
#include    "crtextout.h"
#include    "ccchartdoc.h"
#include    "ccmodeldoc.h"
#include    "ccquickdata.h"
#include    "ccchartobject.h"
#include    "crgraph.h"
#include    "crprogress.h"
#include    "ccmenuitem.h"
#include    "crtoolbar.h"
#include <iostream.h>
#include <iomanip.h>



#ifdef __CR_WIN__
  #include <afxwin.h>
  #include <shlobj.h> // For the SHBrowse stuff.
  #include <direct.h> // For the _chdir function.
  CWinThread * CcController::mCrystalsThread = nil;
  CWinThread * CcController::mGUIThread = nil;
#endif

#ifdef __LINUX__
  #include <stdio.h>
  #include <unistd.h>
  #include <errno.h>
  #define F77_STUB_REQUIRED
  #include "ccthread.h"
  #include <wx/cmndata.h>
  #include <wx/fontdlg.h>
  #include <wx/filedlg.h>
  #include <wx/dirdlg.h>
  #include <wx/mimetype.h>
  #include <wx/utils.h>
  CcThread * CcController::mCrystalsThread = nil;
#endif

#ifdef __WINMSW__
  #include <stdio.h>
  #include <direct.h>
  #include <wx/cmndata.h>
  #include <wx/fontdlg.h>
  #include <wx/filedlg.h>
  #include <wx/dirdlg.h>
  #include <wx/mimetype.h>
  #include <wx/utils.h>
  CcThread * CcController::mCrystalsThread = nil;
#endif


#include "fortran.h"




#ifdef __CR_WIN__
CFont* CcController::mp_font = nil;
CFont* CcController::mp_inputfont = nil;
/*
HANDLE mInterfaceCommandQueueMutex;
HANDLE mCrystalsCommandQueueMutex;
HANDLE mCrystalsCommandQueueEmptyEvent;
HANDLE mLockCrystalsQueueDuringQueryMutex;
HANDLE mCrystalsThreadIsLocked;
*/
#include <process.h>
#endif

static CcLock m_Crystals_Commands_CS(true);
static CcLock m_Interface_Commands_CS(true);

static CcLock m_Crystals_Thread_Alive(true);
static CcLock m_Protect_Completing_CS(true);

static CcLock m_Crystals_Command_Added_CS(false);


#ifdef __BOTHWX__
#include <wx/settings.h>
wxFont* CcController::mp_inputfont = nil;
#include <wx/msgdlg.h>
#endif

CcController* CcController::theController = nil;
int CcController::debugIndent = 0;

CcController::CcController( CcString directory, CcString dscfile )
{

//Things
    mErrorLog = nil;
    mThisThreadisDead = false;
    m_Completing = false;

    m_restart = false;

    m_Wait = false;

    m_next_id_to_try = kMenuBase;
    m_next_tool_id_to_try = kToolButtonBase;

    mCrystalsThread = nil;

//Docs. (A doc is attached to a window (or vice versa), and holds and manages all the data)
    mCurrentChartDoc = nil;
    mCurrentModelDoc = nil;

//Current window pointers. Used to direct streams of input to the correct places (if for some reason the stream has been interuppted.)
    mCurrentWindow = nil;   //The current window. GetValue will search in this window first.
    mInputWindow = nil;     //The users input window. Focus goes here when keys are pressed.
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


// Initialize the static pointers in classes for accessing this controller object.
    CrGUIElement::mControllerPtr = this;
    CcController::theController = this;
    CcController::debugIndent = 0;

// Win32 specific: Set up MUTEXES for synchronising threads.
// ie. Only one thread at a time can access the command and interface queues to prevent corruption.
// (as long as they use them!) See {Add/Get}InterfaceCommand and {Add/Get}CrystalsCommand.
#ifdef __CR_WIN__
/*
      mInterfaceCommandQueueMutex        = CreateMutex(NULL, false, NULL);
      mCrystalsCommandQueueMutex         = CreateMutex(NULL, false, NULL);
      mLockCrystalsQueueDuringQueryMutex = CreateMutex(NULL, false, NULL);
      mCrystalsThreadIsLocked            = CreateMutex(NULL, false, NULL);
      WaitForSingleObject( mLockCrystalsQueueDuringQueryMutex, INFINITE ); //We want this all the time.
      mCrystalsCommandQueueEmptyEvent    = CreateEvent(NULL, true, false, NULL);
*/
      mGUIThread = AfxGetThread();
#endif
    mCrystalsCommandQueue.AddNewLines(true); //Make the crystals queue interpret _N as a new line.
    mCommandHistoryPosition = 0;

    if ( directory.Length() )
    {
      if ( directory.Sub(1,1) == """" ) directory.Chop(1,1);
      ChangeDir( directory );
    }

 // Setup initial windows
    CrGUIElement * theElement = nil;

// Must call Tokenize directly when working in this thread. (Not AddInterfaceCommand,
// as this delays window creation until OnIdle is called).
// This sets up the command line window, and the main text output window.
// Source an external menu definition file - "GUIMENU.SRT"

    FILE * file;
    char charline[256];
    CcString crysdir ( getenv("CRYSDIR") );
    if ( crysdir.Length() == 0 )
    {
      cerr << "You must set CRYSDIR before running crystals.\n";
      return;
    }

    int nEnv = EnvVarCount( crysdir );
    int i = 0;
    bool noLuck = true;

    while ( noLuck )
    {
      CcString dir = EnvVarExtract( crysdir, i );
      i++;

#ifdef __BOTHWIN__
      CcString buffer = dir + "\\guimenu.srt" ;
#endif
#ifdef __LINUX__
      CcString buffer = dir + "guimenu.srt" ;
#endif

      if( file = fopen( buffer.ToCString(), "r" ) ) //Assignment witin conditional - OK
      {
        while ( ! feof( file ) )
        {
          if ( fgets( charline, 256, file ) ) Tokenize(charline);
        }
        fclose( file );
        noLuck = false;
      }
      else
      {
        if ( i >= nEnv )
        {
          //Last resort, there is no external file. Default window defined here:
          Tokenize("^^WI WINDOW _MAIN 'Crystals' MODAL STAYOPEN SIZE CANCEL='_MAIN CLOSE' GRID ");
          Tokenize("^^WI _MAINGRID NROWS=2 NCOLS=1 { @ 1,1 GRID _SUBGRID NROWS=1 NCOLS=3 ");
          Tokenize("^^WI { @ 1,2 TEXTOUT _MAINTEXTOUTPUT '(C)1999 CCL, Oxford.' NCOLS=95 ");
          Tokenize("^^WI NROWS=20 IGNORE DISABLED=YES FIXEDFONT=YES } @ 2,1 PROGRESS ");
          Tokenize("^^WI _MAINPROGRESS 'guimenu.srt NOT FOUND' CHARS=20 } SHOW ");
          Tokenize("^^CR  ");
          LOGSTAT ( "Back from tokenizing all \n") ;
          noLuck = false;
        }
      }
    }

// Find the main window and let the framework know what it is. (Without a
// main window, the program will be terminated, as the framework assumes it has closed)
    theElement = FindObject( "_MAIN" );
    if ( theElement == nil )
    {
      LOGERR ("Failed to get main window");
#ifdef __CR_WIN__
      MessageBox(NULL,"Failed to create and find main Window","CcController",MB_OK);
      ASSERT(0);
#endif
    }
    ((CrWindow*)theElement)->SetTimer(); //Start timer events - a sort of
                                         //pacemaker for the GUI to stop
                                         //it freezing up so often ;)

#ifdef __CR_WIN__
    AfxGetApp()->m_pMainWnd = (CWnd*)(theElement->GetWidget());
#endif
#ifdef __BOTHWX__
    wxGetApp().SetTopWindow((wxWindow*)(theElement->GetWidget()));
#endif
    LOGSTAT ( "Main window found\n") ;

//Find the output window. Needed by CcController so that text can be sent to it.
    CrGUIElement* outputWindow;
    theElement = FindObject( "_MAINTEXTOUTPUT" );
    if ( theElement == nil )
    {
      LOGERR("Failed to get main text output");
#ifdef __CR_WIN__
      MessageBox(NULL,"Failed to create main text output Window","CcController",MB_OK);
      ASSERT(0);
#endif
    }

    outputWindow = theElement;
    SetTextOutputPlace(outputWindow);
    LOGSTAT ( "Text Output window found\n") ;

//Find the progress window. Needed by CcController so that messages can be sent to it.
    CrGUIElement* progressWindow;
    theElement = FindObject( "_MAINPROGRESS" );
    if ( theElement == nil )
    {
      LOGERR("Failed to get progress window");
#ifdef __CR_WIN__
      MessageBox(NULL,"Failed to create progress Window","CcController",MB_OK);
      ASSERT(0);
#endif
    }

    progressWindow = theElement;
    SetProgressOutputPlace(progressWindow);
    LOGSTAT ( "Progress/status window found\n") ;

// If specified on the command line, set the CRDSC environment variable,
// regardless of whether it is already set...

#ifdef __CR_WIN__
    LOGSTAT ( "Setting CRDSC to " + dscfile + "\n") ;
    if ( dscfile.Length() > 1 )
    {
      if ( dscfile.Sub(dscfile.Length(),dscfile.Length()) == """" ) dscfile.Chop(dscfile.Length(),dscfile.Length());
      _putenv( ("CRDSC="+dscfile).ToCString() );

//For info, put DSC name in the title bar.
      Tokenize("^^CO SET _MAIN TEXT 'Crystals - " + dscfile + "'");
      Tokenize("^^CO SET _MT_DIR TEXT '" +dscfile + "'");
    }
#endif


// If the CRDSC variable is set, leave it's value the same.
// Otherwise, set it to the default value of CRFILEV2.DSC
    char enva[6] = "CRDSC";
    char* envv;

#ifdef __CR_WIN__
    envv = getenv( (LPCTSTR) enva );
#endif
#ifdef __BOTHWX__
    envv = getenv( enva );
#endif

    if ( envv == NULL )
    {
#ifdef __BOTHWIN__
       _putenv( "CRDSC=crfilev2.dsc" );
#endif
#ifdef __LINUX__
       putenv( "CRDSC=crfilev2.dsc" );
#endif
       Tokenize("^^CO SET _MAIN TEXT 'Crystals - crfilev2.dsc'");
       Tokenize("^^CO SET _MT_DIR TEXT 'crfilev2.dsc'");
    }

    LOGSTAT( "Starting Crystals Thread" );
    
	StartCrystalsThread();

    LOGSTAT ( "Crystals thread started.\n") ;
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

#ifdef __CR_WIN__
      delete (CcController::mp_font);
      delete (CcController::mp_inputfont);
#endif

    if(mCrystalsThread != nil)
    {
#ifdef __CR_WIN__
      DWORD threadStatus;
      GetExitCodeThread(mCrystalsThread->m_hThread,&threadStatus);
      if(threadStatus == STILL_ACTIVE)
      {
         //Its a bit messy, deleting a thread which is still running,
         //but its too late now anyway...
         delete mCrystalsThread;
      }
#endif
   }

}

Boolean CcController::ParseInput( CcTokenList * tokenList )
{
    CcController::debugIndent = 0;

    CcParse retVal(false, false, false);
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
                CrWindow * wPtr = new CrWindow();
                if ( wPtr != nil )
                {
                    tokenList->GetToken(); //remove token.
                    retVal = wPtr->ParseInput( tokenList );
                    if ( retVal.OK() )
					{
                        mWindowList.AddItem( wPtr );
		                mCurrentWindow = wPtr;
					}
                    else
                        delete wPtr;
                }
                break;
            }
            case kTDisposeWindow:
            {
                tokenList->GetToken();              // remove that token
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
                        mCurrentWindow = (CrWindow *)mWindowList.GetLastItem();
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

                CcString name = tokenList->GetToken();  // Get the name of the object
                CrGUIElement * theElement;
                if ( mCurrentWindow )
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

                CcString name = tokenList->GetToken();  // Get the name of the object
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
                    if ( theElement ) theElement->ParseInput( tokenList );
                }
                else if (name == "TEXTINPUT")
                {
                                        theElement = GetInputPlace();
                    theElement->ParseInput( tokenList );
                }
                else
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

                CcString name = tokenList->GetToken();  // Get the name of the object
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
                else
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

                CcString name = tokenList->GetToken();  // Get the name of the object
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
                CcString extension = tokenList->GetToken(); // Get the extension
                CcString description = tokenList->GetToken();   // Get the extension description
                if ( tokenList->GetDescriptor(kAttributeClass) == kTTitleOnly)
                {
                    OpenFileDialog(&result, extension, description, true);
                    tokenList->GetToken(); //Remove token
                }
                else
                {
                    OpenFileDialog(&result, extension, description, false);
                }
                SendCommand(result);
                break;
            }
            case kTSysSaveFile: //Display SaveFileDialog and send result back to the Script.
            {
                tokenList->GetToken();    // remove that token
                CcString result;
                CcString defName = tokenList->GetToken();   // Get the default file name.
                CcString extension = tokenList->GetToken(); // Get the extension.
                CcString description = tokenList->GetToken();   // Get the extension description.

                SaveFileDialog(&result, defName, extension, description);
                SendCommand(result);
                break;
            }
            case kTSysGetDir: //Display GetDirDialog and send result back to the Script.
            {
                tokenList->GetToken();    // remove that token
                CcString result;
                OpenDirDialog(&result);
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
#ifdef __CR_WIN__
                              _putenv( (LPCTSTR) newdsc.ToCString() );
#endif
#ifdef __BOTHWX__
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
            case kTFontSet:
            {
                tokenList->GetToken();
                ChooseFont();
                break;
            }

            default:
            {
                // This is not a known instruction for Controller.
                // Pass it on to the current window.
                if ( tokenList == mWindowTokenList )
                {
                    if ( mCurrentWindow )
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


    return (retVal.OK());

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
//      stop = i-1;
        stop = i-1;

        // add item to token list
            AppendToken(text.Sub(start,stop) );

    }
    return true; // *** for now
}

void    CcController::SendCommand( CcString command , Boolean jumpQueue)
{
    LOGSTAT("CcController:SendCommand received command '" + command + "'");
    char* theLine = (char*)command.ToCString();
    AddCrystalsCommand(theLine, jumpQueue);
}

void    CcController::Tokenize( CcString cText )
{

//    CcString cText = text;
    int clen = cText.Len();
    Boolean tagged = false;
    int chop = 0;

// Look out for lines where the ^^ are misplaced.

    if ( clen >= 4 )
    {
        if ( cText[2] == '^' ) { chop = 6; tagged = true; }
        if ( cText[1] == '^' ) { chop = 5; tagged = true; }
        if ( cText[0] == '^' ) { chop = 4; tagged = true; }
    }

    if ( tagged && (clen >= chop) )   // It is definitely tagged text
    {
        CcString selector = cText.Sub(chop-1,chop); // Get the selector and determine list to use
        if ( selector == kSWindowSelector )
        {
            mCurTokenList = mWindowTokenList;
            ParseLine( cText.Chop(1,chop) );
        }
        else if      ( selector == kSChartSelector )
        {
            mCurTokenList = mChartTokenList;
            ParseLine( cText.Chop(1,chop) );
        }
        else if      ( selector == kSModelSelector )
        {
            mCurTokenList = mModelTokenList;
            ParseLine( cText.Chop(1,chop) );
        }
        else if      ( selector == kSStatusSelector )
        {
            mCurTokenList = mStatusTokenList;
            ParseLine( cText.Chop(1,chop) );
        }
        else if      ( selector == kSControlSelector )
        {
            while ( ParseInput( mCurTokenList ) );
        }
        else if      ( selector == kSOneCommand )
        {                                                                                                                                //Avoids breaking up (and corrupting) the incoming streams from scripts.
            mTempTokenList = mCurTokenList;
            mCurTokenList  = mQuickTokenList;
            ParseLine( cText.Chop(1,chop) );
            while ( ParseInput( mQuickTokenList ) );
            mCurTokenList  = mTempTokenList;
        }
        else if      ( selector == kSQuerySelector )
        {
            mTempTokenList = mCurTokenList;
            mCurTokenList  = mQuickTokenList;
            ParseLine( cText.Chop(1,chop) );
            GetValue( mQuickTokenList ) ;
            mCurTokenList  = mTempTokenList;
//We must now signal the waiting Crystals thread that it's input is ready.
            ProcessingComplete();
        }
        else                                             // Simple output text or comment
        {
            ProcessOutput( cText ); // Useful to see mistakes in ^^ format.
        }
    }
    else                                             // Simple output text or comment
    {
            ProcessOutput( cText );
    }
}

void CcController::CompleteProcessing()
{

// This function is called by the CRYSTALS thread and
// will not return until the interface has processed all
// pending commands in the command queue.

   m_Protect_Completing_CS.Enter();
   LOGSTAT("-----------Output queue locked." );
   m_Completing = true;
   m_Protect_Completing_CS.Leave();
}



void CcController::ProcessingComplete()
{
// This is called by the interface to signal that it has finished
// processing all pending commands in the command queue.

   m_Protect_Completing_CS.Enter();
   LOGSTAT("-----------Output queue released." );
   m_Completing=false;
   m_Protect_Completing_CS.Leave();
}

bool CcController::Completing()
{
   m_Protect_Completing_CS.Enter();
   bool temp = m_Completing;
   m_Protect_Completing_CS.Leave();
   return temp;
}    

Boolean CcController::IsSpace( char c )
{
    return (   c == ' '
            || c == '\t'
            || c == '\r'
            || c == '\n'
            || c == '='
            || c == ',' );
}

Boolean CcController::IsDelimiter( char c )
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

    m_Crystals_Commands_CS.Enter();

    mCrystalsCommandQueue.SetCommand( line, jumpQueue);
    if (jumpQueue) ProcessingComplete();

    m_Crystals_Commands_CS.Leave();

    m_Crystals_Command_Added_CS.Signal();


}

void  CcController::AddInterfaceCommand( CcString line )
//------------------------------------------------------
{
/*  This is a critical section between the threads.
 *  If the interface thread has a lock on the section, then we
 *  have to wait (using a mutex sync object).

 *  If the command is a query from the CRYSTALS program ( ^^?? ), then
 *  we must get a lock on the Crystals Command Queue, so that
 *  nothing can be read from it, until the answer to the query
 *  is placed at the top of the queue.
 */

  for ( int j = 1; j < min ( line.Length()-3, 6 ); j++ )
  {
    if ( line.Sub(j,j+3).Compare("^^??",4) )
    {
      CompleteProcessing();
// Nothing can be read back from queue until this query is answered.
      break;
    }
  }

  m_Interface_Commands_CS.Enter();

  if(mThisThreadisDead) endthread(0);

  mInterfaceCommandQueue.SetCommand( line );

  LOGSTAT("-----------CRYSTALS has put: " + line );

  m_Interface_Commands_CS.Leave();

#ifdef __CR_WIN__
      if ( mGUIThread ) PostThreadMessage( mGUIThread->m_nThreadID, WM_STUFFTOPROCESS, NULL, NULL );
#endif
}





Boolean CcController::GetCrystalsCommand( char * line )
//-----------------------------------------------------
{
//This is where the Crystals thread will spend most of its time.
//Waiting for the user to do somethine.

//Wait until the list is free for reading.

    m_Crystals_Commands_CS.Enter();

    if (mThisThreadisDead) return false;

    while ( Completing() || !mCrystalsCommandQueue.GetCommand( line ) )
    {
// The queue is empty or locked so wait efficiently. 
// Release the mutex for a while, so that someone else can write to the queue!
        m_Wait = false;
//        LOGSTAT ("-----------Queue locked or empty..");
       m_Crystals_Commands_CS.Leave();
        if (mThisThreadisDead) return false;


        m_Crystals_Command_Added_CS.Wait(1000);

//The writer has signalled us (or we got bored of waiting) now get the mutex and read the queue.

        m_Crystals_Commands_CS.Enter();
    }

    LOGSTAT("-----------Crystals thread: Got command: "+ CcString(line));

    m_Crystals_Commands_CS.Leave();

    if (mThisThreadisDead) return false;

    if (CcString(line) == "#DIENOW") endthread(0);

    m_Wait = true;

    return (true);
}




Boolean CcController::GetInterfaceCommand( char * line )
//------------------------------------------------------
{
    //This routine gets called repeatedly by the Idle loop.
    //It needn't be highly optimised even though it is high on
    //the profile count list.


  if( mCrystalsThread )
  {
#ifdef __CR_WIN__
    DWORD threadStatus;
    GetExitCodeThread(mCrystalsThread->m_hThread,&threadStatus);
    if(threadStatus != STILL_ACTIVE)
#endif
#ifdef __BOTHWX__
    if ( ! (m_Crystals_Thread_Alive.IsLocked()) )
#endif
    {
      if ( m_restart )
      {
        ChangeDir( m_newdir );
        StartCrystalsThread();
        m_restart = false;
        return (false);
      }

      mThisThreadisDead = true;
      strcpy(line,"^^CO DISPOSE _MAIN ");
      return (true);
    }
  }

  m_Interface_Commands_CS.Enter();

  if ( ! mInterfaceCommandQueue.GetCommand( line ) )
  {
    strcpy( line, "" );
// If CRYSTALS has nothing more to say, the we'd better make sure that the
// queue of commands for CRYSTALS isn't locked:
    if ( Completing() ) {
       LOGSTAT ( "Unlocking the output queue for safety reasons");
       ProcessingComplete();
    }
    m_Interface_Commands_CS.Leave();
    return (false);
  }
  else
  {
    CcString temp = CcString(line);
    LOGSTAT("GUI gets: "+temp);
    m_Interface_Commands_CS.Leave();
    return (true);
  }
}

void    CcController::LogError( CcString errString , int level )
{
    if ( mErrorLog == nil )
    {
        mErrorLog = fopen( "Script.log", "w+" );
    }
    if ( level == 1 ) //Warning mark with stars.
    {
        errString = " WARNING: " + errString;
        ProcessOutput( "{E " + errString );
    }
    else if (level == 0) //Serious error mark with XXXX's
    {
        errString = " ERROR: " + errString;
        ProcessOutput( "{E " + errString );
    }
    for ( int i = 0; i < CcController::debugIndent; i++)
    {
      fprintf( mErrorLog, "  ");
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
#ifdef __CR_WIN__
    RECT screenRect;
    SystemParametersInfo( SPI_GETWORKAREA, 0, &screenRect, 0 );

    retVal.Set( screenRect.top,
                screenRect.left,
                screenRect.bottom,
                screenRect.right);
#endif
#ifdef __BOTHWX__
      retVal.mTop = 0;
      retVal.mLeft = 0;
      retVal.mBottom = wxSystemSettings::GetSystemMetric(wxSYS_SCREEN_Y);
      retVal.mRight =  wxSystemSettings::GetSystemMetric(wxSYS_SCREEN_X);

//      cerr << "Screen Area: " << retVal.mRight << "," << retVal.mBottom << "\n";
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
    CcString *theCommand = (CcString*) mCommandHistoryList.GetItem();
    CrEditBox *theEditBox = (CrEditBox*) GetInputPlace();

    if (theCommand == nil)
    {
            theEditBox->SetText("");
    }
    else
    {
            theEditBox->SetText("");
            theEditBox->AddText(*theCommand);
    }
}

void CcController::GetValue(CcTokenList * tokenList)
{
    LOGSTAT("CcController: Getting Value");

    CcString name = tokenList->GetToken();  // Get the name of the object
    CrGUIElement * theElement = nil;

    if ( mCurrentWindow )
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
  FILE * szfile;
  FILE * tempf;
  char * tempn;
  char buffer[256];
//  char filen[256];
  CcString readFile;
  CcString writeFile;


  CcString crysdir ( getenv("CRYSDIR") );
  if ( crysdir.Length() == 0 )
     cerr << "You must set CRYSDIR before running crystals.\n";
  else
  {
    int nEnv = EnvVarCount( crysdir );

    int i = 0;
    bool noLuck = true;

    while ( noLuck )
    {
      CcString dir = EnvVarExtract( crysdir, i );
      i++;
#ifdef __BOTHWIN__
      dir += "script\\winsizes.ini";
#endif
#ifdef __LINUX__
      dir += "/script/winsizes.ini";
#endif
      szfile = fopen( dir.ToCString(), "r" );
      if ( szfile != NULL )
      {
        noLuck = false;
        readFile = dir;
        fclose ( szfile );
      }
      else if ( i >= nEnv )
      {
        readFile = ""; //Assume doesn't exist.
		noLuck = false;
      }
    }

    i = 0;
    noLuck = true;
    while ( noLuck )
    {
      CcString dir = EnvVarExtract( crysdir, i );
      i++;
#ifdef __BOTHWIN__
      dir += "script\\winsizes.ini";
#endif
#ifdef __LINUX__
      dir += "/script/winsizes.ini";
#endif
      szfile = fopen( dir.ToCString(), "a+" ); //Use "a+" as "w+" would empty file, and "r+" fails in no file.
      if ( szfile != NULL )
      {
        noLuck = false;
        writeFile = dir;
        fclose ( szfile );
      }
      else if ( i >= nEnv )
      {
        LOGERR ( "Could not open "+dir+" for writing: "+CcString(strerror( errno ))+" No more CRYSDIRs to try. ");
        return;
      }
      else
      {
        LOGSTAT ( "Couldn't open "+dir+" for writing: "+CcString(strerror( errno ))+" - Retrying with next CRYSDIR directory"   );
      }
    }

  }



  if ( readFile.Length() )
  {

// Get a name for a temp file.

    if ( ( tempn = tmpnam( NULL ) ) == NULL )
    {
      LOGERR ( "Could not get name for temp file." );
      return;
    }

// Open the temp file.

    if ( ( tempf = fopen ( tempn, "a+" ) ) == NULL )
    {
      LOGERR ( "Could not get open temp file: " + CcString ( tempn )  );
      return;
    }

// Open winsizes for reading.
    if( (szfile = fopen( readFile.ToCString(), "r" )) == NULL ) //Assignment witin conditional - OK
    {
      LOGERR ( "(second) Could not open "+readFile+" for reading." );
      return;
    }


// Copy winsizes to the temp file.

    while ( ! feof( szfile ) )
    {
      if ( fgets( buffer, 256, szfile ) )
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
    fclose( szfile );
    rewind( tempf );
  }

// Open winsizes for writing.

  if( (szfile = fopen( writeFile.ToCString(), "w" )) == NULL ) //Assignment witin conditional - OK
  {
    LOGERR ( "(second) Could not open "+writeFile+" for writing" );
    return;
  }

  if ( readFile.Length() )
  {

// Copy the file back

    int doBreak = 0;
    while ( ! feof( tempf ) )
    {
      if ( fgets( buffer, 256, tempf ))  fputs ( buffer, szfile );
      else if ( doBreak > 10 )           break;
      else                               doBreak++;
    }
    fclose ( tempf );
    remove ( tempn );

  }

// Add this key on to the end.

  sprintf(buffer, "%s %s", key.ToCString(), value.ToCString());
  fputs ( buffer, szfile );
  fputs ( "\n", szfile );
  fclose ( szfile );

  return;

}

CcString CcController::GetKey( CcString key )
{
  FILE * szfile;
  char buffer[256];
  CcString value;

  CcString crysdir ( getenv("CRYSDIR") );
  if ( crysdir.Length() == 0 )
     cerr << "You must set CRYSDIR before running crystals.\n";
  else
  {
    int nEnv = EnvVarCount( crysdir );
    int i = 0;
    bool noLuck = true;
    while ( noLuck )
    {
      CcString dir = EnvVarExtract( crysdir, i );
      i++;
#ifdef __BOTHWIN__
      dir += "\\script\\winsizes.ini";
#endif
#ifdef __LINUX__
      dir += "/script/winsizes.ini";
#endif
      szfile = fopen( dir.ToCString(), "r" );
      if ( szfile != NULL )
      {
        noLuck = false;
      }
      else if ( i >= nEnv )
      {
        return value;
      }
    }

    while ( ! feof( szfile ) )
    {
      if ( fgets( buffer, 256, szfile ) != NULL )
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
    fclose( szfile );
  }

  return value;

}

void CcController::AddHistory( CcString theText )
{
      if ( theText.Len() == 0 ) return;
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

//
// The controller keeps a list (mMenuItemList) of all the items
// that are in the menus. This finds the next free id.
// m_next_id_to_try is the next id to check if is free. It gets reset to
// kMenuBase when it reaches 5000.
// If the number of menu items reaches 5000, the program aborts
// with an error message.

int CcController::FindFreeMenuId()
{

    m_next_id_to_try++;
    int starting_try = m_next_id_to_try;

    while (1)
    {

       Boolean pointerfree = true;
       mMenuItemList.Reset();     //To the beginning
       CcMenuItem* theItem;

       while ( ( theItem = (CcMenuItem *)mMenuItemList.GetItemAndMove() ) != nil )
       {

          if ( theItem->id  == m_next_id_to_try )
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

void CcController::AddMenuItem( CcMenuItem * menuitem )
{
      mMenuItemList.AddItem( (void*) menuitem );
      if ( mMenuItemList.ListSize() > 5000 )
      {
         //error
         cerr << "More than 5000 menu items. Rethink or recompile.\n";
      }
}

CcMenuItem* CcController::FindMenuItem ( int id )
{

   mMenuItemList.Reset();     //To the beginning
   CcMenuItem* theItem;
   while ( ( theItem = (CcMenuItem *)mMenuItemList.GetItemAndMove() ) != nil )
   {
      if ( theItem->id  == id )
      {
         return theItem;
      }
   }
  return nil;
}

CcMenuItem* CcController::FindMenuItem ( CcString name )
{

   mMenuItemList.Reset();     //To the beginning
   CcMenuItem* theItem;
   while ( ( theItem = (CcMenuItem *)mMenuItemList.GetItemAndMove() ) != nil )
   {
      if ( theItem->name  == name )
      {
         return theItem;
      }
   }
  return nil;
}

void CcController::RemoveMenuItem ( CcMenuItem * menuitem )
{
   mMenuItemList.Reset();     //To the beginning
   CcMenuItem* theItem = (CcMenuItem *)mMenuItemList.GetItem();
   while ( theItem != nil )
   {
      if ( theItem  == menuitem )
      {
         mMenuItemList.RemoveItem();
//         delete theItem;
         break;
      }
      theItem = (CcMenuItem *)mMenuItemList.MoveAndGetItem();
   }
}

void CcController::RemoveMenuItem ( CcString menuitemname )
{
   mMenuItemList.Reset();     //To the beginning
   CcMenuItem* theItem = (CcMenuItem *)mMenuItemList.GetItem();
   while ( theItem != nil )
   {
      if ( theItem->name  == menuitemname )
      {
         mMenuItemList.RemoveItem();
  //       delete theItem;
         break;
      }
      theItem = (CcMenuItem *)mMenuItemList.MoveAndGetItem();
   }
}



//
// The controller keeps a list (mToolList) of all the items
// that are in the toolbars. This finds the next free id.
// m_next_tool_id_to_try is the next id to check if is free. It
// gets reset to kToolButtonBase when it reaches 5000.
// If the number of toolss reaches 5000, the program aborts
// with an error message.

int CcController::FindFreeToolId()
{

    m_next_tool_id_to_try++;
    int starting_try = m_next_tool_id_to_try;

    while (1)
    {

       Boolean pointerfree = true;
       mToolList.Reset();     //To the beginning
       CcTool* theItem;

       while ( ( theItem = (CcTool *)mToolList.GetItemAndMove() ) != nil )
       {

          if ( theItem->CxID  == m_next_tool_id_to_try )
          {
             pointerfree = false;
             m_next_tool_id_to_try++;

             if ( m_next_tool_id_to_try > ( kToolButtonBase + 5000 ) )
             {
//Reset id pointer to start:
                m_next_tool_id_to_try = kToolButtonBase;
             }
             if ( m_next_tool_id_to_try == starting_try )
             {
//No more free id's:
                 return -1;
             }
             break;
          }
       }

       if ( pointerfree ) return m_next_tool_id_to_try;

    }

}

void CcController::AddTool( CcTool * tool )
{
      mToolList.AddItem( (void*) tool );
      if ( mToolList.ListSize() > 5000 )
      {
         //error
         cerr << "More than 5000 toolbar items. Rethink or recompile.\n";
      }
}

CcTool* CcController::FindTool ( int id )
{

   mToolList.Reset();     //To the beginning
   CcTool* theItem;
   while ( ( theItem = (CcTool *)mToolList.GetItemAndMove() ) != nil )
   {
      if ( theItem->CxID  == id )
      {
         return theItem;
      }
   }
  return nil;
}

CcTool* CcController::FindTool ( CcString name )
{

   mToolList.Reset();     //To the beginning
   CcTool* theItem;
   while ( ( theItem = (CcTool *)mToolList.GetItemAndMove() ) != nil )
   {
      if ( theItem->tName  == name )
      {
         return theItem;
      }
   }
  return nil;
}

void CcController::RemoveTool ( CcTool * tool )
{
   mToolList.Reset();     //To the beginning
   CcTool* theItem = (CcTool *)mToolList.GetItem();
   while ( theItem != nil )
   {
      if ( theItem  == tool )
      {
         mToolList.RemoveItem();
//         delete theItem;
         break;
      }
      theItem = (CcTool *)mToolList.MoveAndGetItem();
   }
}

void CcController::RemoveTool ( CcString toolname )
{
   mToolList.Reset();     //To the beginning
   CcTool* theItem = (CcTool *)mToolList.GetItem();
   while ( theItem != nil )
   {
      if ( theItem->tName  == toolname )
      {
         mToolList.RemoveItem();
  //       delete theItem;
         break;
      }
      theItem = (CcTool *)mToolList.MoveAndGetItem();
   }
}


void CcController::UpdateToolBars()
{
  // Unlike menus, the toolbars don't recieve events telling them
  // to update during idle time.
  // So we'll do it from here.

   mToolList.Reset();     //To the beginning
   CcTool* theItem;
   while ( ( theItem = (CcTool *)mToolList.GetItemAndMove() ) != nil )
   {
     if ( theItem->tTool )
        theItem->tTool->CxEnable(status.ShouldBeEnabled(theItem->tEnableFlags,theItem->tDisableFlags), theItem->CxID);
   }

   mDisableableWindowsList.Reset();
   CrWindow* aWindow;
   while ( ( aWindow = (CrWindow* )mDisableableWindowsList.GetItemAndMove() ))
   {
     aWindow->Enable(status.ShouldBeEnabled(aWindow->wEnableFlags,aWindow->wDisableFlags));
   }

   mDisableableButtonsList.Reset();
   CrButton* aButton;
   while ( ( aButton = (CrButton* )mDisableableButtonsList.GetItemAndMove() ))
   {
     aButton->Enable(status.ShouldBeEnabled(aButton->bEnableFlags,aButton->bDisableFlags));
   }

}

void CcController::ScriptsExited()
{
  //Use this fact to close any modal windows that don't
  //have the STAYOPEN property. (This means that the script
  //has terminated incorrectly without closing the window).

  CrWindow * theWindow;

  mWindowList.Reset();
  theWindow = (CrWindow *)mWindowList.GetItemAndMove();

  while ( theWindow != nil )
  {
      if ( theWindow->mIsModal && !theWindow->mStayOpen )
      {
         if ( theWindow == mCurrentWindow ) mCurrentWindow=nil;
         delete theWindow;
         mWindowList.RemoveItem();
      }
      theWindow = (CrWindow *)mWindowList.GetItemAndMove();
  }

}


void CcController::AddDisableableWindow( CrWindow * aWindow )
{
      mDisableableWindowsList.AddItem( (void*) aWindow );
      if ( mDisableableWindowsList.ListSize() > 5000 )
      {
         //error
         LOGERR ( "mDisableableWindowsList (CcController) has exceeded 5000 items - possible memory leak...");
      }
}

void CcController::RemoveDisableableWindow ( CrWindow * aWindow )
{
   mDisableableWindowsList.Reset();     //To the beginning
   CrWindow* theItem = (CrWindow *)mDisableableWindowsList.GetItem();
   while ( theItem != nil )
   {
      if ( theItem  == aWindow )
      {
         mDisableableWindowsList.RemoveItem();
         break;
      }
      theItem = (CrWindow *)mDisableableWindowsList.MoveAndGetItem();
   }
}




void CcController::AddDisableableButton( CrButton * aButton )
{
      mDisableableButtonsList.AddItem( (void*) aButton );
      if ( mDisableableButtonsList.ListSize() > 5000 )
      {
         //error
         LOGERR ( "mDisableableButtonsList (CcController) has exceeded 5000 items - possible memory leak...");
      }
}

void CcController::RemoveDisableableButton ( CrButton * aButton )
{
   mDisableableButtonsList.Reset();     //To the beginning
   CrButton* theItem = (CrButton *)mDisableableButtonsList.GetItem();
   while ( theItem != nil )
   {
      if ( theItem  == aButton )
      {
         mDisableableButtonsList.RemoveItem();
//         delete theItem;
         break;
      }
      theItem = (CrButton *)mDisableableButtonsList.MoveAndGetItem();
   }
}






void CcController::ReLayout()
{
  CcRect gridRect;
  mWindowList.Reset();
  CrWindow * theItem = (CrWindow *)mWindowList.GetItemAndMove();
  while ( theItem != nil )
  {
    gridRect = theItem -> mGridPtr -> GetGeometry();
    theItem -> CalcLayout(true);
    theItem -> ResizeWindow(gridRect.Width(),gridRect.Height());
    theItem -> Redraw();
    theItem = (CrWindow *)mWindowList.GetItemAndMove();
  }
  return;
}




#ifdef __CR_WIN__
UINT CrystalsThreadProc( LPVOID arg );
SUBROUTINE CRYSTL();
UINT CrystalsThreadProc( LPVOID arg )
{
    m_Crystals_Thread_Alive.Enter(); //Will be owned whole time crystals thread is running.
    CRYSTL();
    return 0;
}
#endif

#ifdef __LINUX__
int CrystalsThreadProc( void* arg );
SUBROUTINE_F77 crystl_();
int CrystalsThreadProc( void * arg )
{
    m_Crystals_Thread_Alive.Enter(); //Will be owned whole time crystals thread is running.
    crystl_();
    return 0;
}
#endif

#ifdef __WINMSW__
UINT CrystalsThreadProc( void* arg );
SUBROUTINE CRYSTL();
UINT CrystalsThreadProc( void * arg )
{
    m_Crystals_Thread_Alive.Enter(); //Will be owned whole time crystals thread is running.
    CRYSTL();
    return 0;
}
#endif


void CcController::StartCrystalsThread()
{

//************************************************************//
//                                                            //
//    V.Important. Start the CRYSTALS (FORTRAN) thread.       //
//    This returns a pointer which is stored so we can        //
//             kill it later if we want!                      //
//                                                            //

   int arg = 6;

#ifdef __CR_WIN__
   mCrystalsThread = AfxBeginThread(CrystalsThreadProc,&arg);
#endif
#ifdef __BOTHWX__
   mCrystalsThread = new CcThread();
   mCrystalsThread->Create();
   mCrystalsThread->Run();
#endif

//                                                            //
//                                                            //
//                                                            //
//                                                            //
//************************************************************//

}


//  Append the contents of the buffer to the output

void CcController::ProcessOutput( CcString line )
{
    CrGUIElement* element = GetTextOutputPlace();
    if( element != nil ) element->SetText(line);
    if( element != GetBaseTextOutputPlace() )
    {
        //Always log text to the base window. It is the only permanent visible record.
        (CcController::theController)->GetBaseTextOutputPlace()->SetText(line);
    }
}


void CcController::OpenFileDialog(CcString* result, CcString extensionFilter, CcString extensionDescription, Boolean titleOnly)
{
#ifdef __CR_WIN__
    CString pathname, filename, filetitle;

    CString extension = CString(extensionDescription.ToCString()) + "|" + CString(extensionFilter.ToCString()) + "||" ;

      CFileDialog fileDialog (      true,                   //TRUE for open, FALSE for save
                                NULL,               //The default extension for the filename
                                NULL,               //The initial filename displayed
                                OFN_HIDEREADONLY|OFN_NOCHANGEDIR|OFN_FILEMUSTEXIST, //some flags
                                extension,    //all the extensions allowed
                                NULL);              //The parent window of this window

    if (fileDialog.DoModal() == IDOK )
    {
        pathname = fileDialog.GetPathName();

        if(titleOnly)
        {
            filename = fileDialog.GetFileName();
            filetitle = fileDialog.GetFileTitle();
            CString pathandtitle = pathname.Left(pathname.Find(filename)) + filetitle;
            pathname = pathandtitle;
        }
    }
    else
    {
        pathname = "CANCEL";
    }

    *result = CcString(pathname.GetBuffer(256));
#endif
#ifdef __BOTHWX__
    wxString pathname, filename, filetitle;

    wxString extension = wxString(extensionDescription.ToCString()) + "|" + wxString(extensionFilter.ToCString())  ;

    wxString cwd = wxGetCwd(); //This filedialog changes the working dir. Save it.

    wxFileDialog fileDialog ( wxGetApp().GetTopWindow(),
                              "Choose a file",
                              "",
                              "",
                              extension,
                              wxOPEN  );





    if (fileDialog.ShowModal() == wxID_OK )
    {
        pathname = fileDialog.GetPath();

        if(titleOnly)
        {
            wxString pathandtitle = pathname.BeforeLast('.');
            pathname = pathandtitle;
        }
    }
    else
    {
        pathname = "CANCEL";
    }

    wxSetWorkingDirectory(cwd);

    *result = CcString(pathname.c_str());
#endif
}

void CcController::SaveFileDialog(CcString* result, CcString defaultName, CcString extensionFilter, CcString extensionDescription)
{

#ifdef __CR_WIN__
    CString pathname, filename, filetitle;

    CString extension = CString(extensionDescription.ToCString()) + "|" + CString(extensionFilter.ToCString()) + "||" ;
    CString initName  = CString(defaultName.ToCString());


      CFileDialog fileDialog (      false,                        //TRUE for open, FALSE for save
                                NULL,               //The default extension for the filename
                                initName,           //The initial filename displayed
                                OFN_HIDEREADONLY|OFN_NOCHANGEDIR|OFN_OVERWRITEPROMPT, //some flags
                                extension,    //all the extensions allowed
                                NULL);              //The parent window of this window

    if (fileDialog.DoModal() == IDOK )
    {
        pathname = fileDialog.GetPathName();
    }
    else
    {
        pathname = "CANCEL";
    }

    *result = CcString(pathname.GetBuffer(256));
#endif

#ifdef __BOTHWX__
    wxString pathname, filename, filetitle;
    wxString extension = wxString(extensionDescription.ToCString()) + "|" + wxString(extensionFilter.ToCString())  ;
    wxString initName = wxString(defaultName.ToCString());

    wxString cwd = wxGetCwd(); //This filedialog changes the working dir. Save it.

    wxFileDialog fileDialog ( wxGetApp().GetTopWindow(),
                              "Save file as",
                              "",
                              initName,
                              extension,
                              wxSAVE|wxOVERWRITE_PROMPT );





    if (fileDialog.ShowModal() == wxID_OK )
    {
        pathname = fileDialog.GetPath();
    }
    else
    {
        pathname = "CANCEL";
    }

    wxSetWorkingDirectory(cwd);

    *result = CcString(pathname.c_str());
#endif

}

void CcController::OpenDirDialog(CcString* result)
{
#ifdef __CR_WIN__

      CString pathname;

      BROWSEINFO bi;
      LPITEMIDLIST chosen; //The chosen directory as an IDLIST(?)
      char buffer[MAX_PATH];
      char title[36] = "Choose a directory to run CRYSTALS";

      bi.hwndOwner = NULL;
      bi.pidlRoot = NULL;
      bi.pszDisplayName = buffer;
      bi.lpszTitle = (char*)&title;
      bi.ulFlags = BIF_RETURNONLYFSDIRS;
      bi.lpfn = NULL;
      bi.lParam = NULL;
      bi.iImage = NULL;

      chosen = ::SHBrowseForFolder( &bi );

      if ( chosen  )
      {
          if ( SHGetPathFromIDList(chosen, buffer))
          {
             *result = CcString(buffer);
          }
          else
          {
             *result = "CANCEL";
          }

      }
      else
      {
            *result = "CANCEL";
      }
#endif
#ifdef __BOTHWX__
    wxString pathname;
    wxString cwd = wxGetCwd(); //This dir dialog changes the working dir. Save it.

    wxDirDialog dirDialog ( wxGetApp().GetTopWindow(),"Choose a directory");

    if (dirDialog.ShowModal() == wxID_OK )
    {
        pathname = dirDialog.GetPath();
    }
    else
    {
        pathname = "CANCEL";
    }
    wxSetWorkingDirectory(cwd);
    *result = CcString(pathname.c_str());
#endif
}



void CcController::ChangeDir (CcString newDir)
{
#ifdef __BOTHWIN__
      _chdir ( newDir.ToCString());
#endif
#ifdef __LINUX__
      chdir ( newDir.ToCString());
#endif
}


void CcController::ChooseFont()
{
#ifdef __CR_WIN__
  LOGFONT lf;
  if ( CcController::mp_inputfont != NULL )
  {
    CcController::mp_inputfont->GetLogFont( &lf );
  }
  else
  {
#ifndef _WINNT
    HFONT hSysFont = ( HFONT )GetStockObject( ANSI_FIXED_FONT );
#else
    HFONT hSysFont = ( HFONT )GetStockObject( DEVICE_DEFAULT_FONT );
#endif  // !_WINNT
    CFont* pFont = CFont::FromHandle( hSysFont );
    pFont->GetLogFont( &lf );
  }

  CFontDialog fd(&lf,CF_SCREENFONTS);

  if ( fd.DoModal() == IDOK )
  {

    if( CcController::mp_inputfont ) delete( CcController::mp_inputfont );
    CcController::mp_inputfont = new CFont;
    CcController::mp_inputfont->CreateFontIndirect( &lf );
    (CcController::theController)->StoreKey( "MainFontHeight", CcString(lf.lfHeight) );
    (CcController::theController)->StoreKey( "MainFontWidth", CcString(lf.lfWidth) );
    (CcController::theController)->StoreKey( "MainFontFace", CcString(lf.lfFaceName) );

    (CcController::theController)->ReLayout();
  }
#endif
#ifdef __BOTHWX__

  wxFontData data;
  wxFont* pFont = new wxFont(12,wxMODERN,wxNORMAL,wxNORMAL);

  if ( CcController::mp_inputfont == NULL )
  {
#ifndef _WINNT
    *pFont = wxSystemSettings::GetSystemFont( wxSYS_ANSI_FIXED_FONT );
#else
    *pFont = wxSystemSettings::GetSystemFont( wxDEVICE_DEFAULT_FONT );
#endif  // !_WINNT
   }
   else
   {
     *pFont = *CcController::mp_inputfont;
   }

   data.SetInitialFont(*pFont);

   wxWindow* top = wxGetApp().GetTopWindow();

   wxFontDialog fd( top, &data );

   if ( fd.ShowModal() == wxID_OK )
   {
     wxFontData newdata = fd.GetFontData();
     *pFont = newdata.GetChosenFont();
     (CcController::theController)->StoreKey( "InputFontHeight", CcString(CcController::mp_inputfont->GetPointSize()) );
     (CcController::theController)->StoreKey( "InputFontFace", CcString(CcController::mp_inputfont->GetFaceName()) );
   }
#endif

}


int CcController::EnvVarCount( CcString dir )
{
// Find the number of commas + 1 in the string.

   int nCommas = 1;
   for ( int i = 0; i < dir.Length(); i++ )
   {
     if ( dir[i] == ',' ) nCommas++;
   }
   return nCommas;
}
CcString CcController::EnvVarExtract ( CcString dir, int i )
{
// Find string following the i th comma.

   int j;
   int nCommas = 0;

// Find posn of ith comma.

   for ( j = 0; j < dir.Length(); j++ )
   {
     if ( nCommas == i ) break;
     if ( dir[j] == ',' ) nCommas++;
   }

   int firstPos = max(1,j+1);

// Find posn of ith+1 comma.

   for ( j = j+1; j < dir.Length(); j++ )
   {
     if ( dir[j] == ',' ) break;
   }

   int lastPos = min(dir.Length(),j);

   firstPos = min (firstPos,lastPos);
   lastPos = max (firstPos,lastPos);

   return dir.Sub(firstPos,lastPos);

}


void CcController::TimerFired()
{
  DoCommandTransferStuff();
}


bool CcController::DoCommandTransferStuff()
{
  char theLine[255];
  bool appret = false;

  if( GetInterfaceCommand(theLine) )
  {
    appret = true;
    int theLength = 0;

    if(theLength = strlen( theLine )) //Assignment within conditional (OK)
    {
      theLine[theLength+1]='\0';
      Tokenize(theLine);
    }
  }
  return appret;
}




//////////////////////////////
//   STATIC C FUNCTIONS     //
//////////////////////////////


extern "C" {

  // new style API for FORTRAN
  // FORCALL() macro adds on _ to end of word for linux version.


  void FORCALL(callccode) ( char* theLine)
  {
      long thelength = 80;
      char * str = new char[81];
      memcpy(str,theLine,80);
      *(str+80) = '\0';
      ciflushbuffer(&thelength, str);
      delete [] str;
  }

  void FORCALL(guexec) ( char* theLine)
  {
    CcString line(theLine);
// Trim any weird characters off the end of the line.
    line = line.Sub(1,line.Length()-5);

    bool bWait = false;
    bool bRest = false;
    int sFirst,eFirst,sRest,eRest;

// Find first non-space.

    for ( sFirst = 0; sFirst < line.Length(); sFirst++ )
    {
      if ( line[sFirst] != ' ' ) break;
    }

// Check for + symbol (signifies 'wait')

    if ( line[sFirst] == '+' )
    {
       bWait = true;

// Find next non space ( in case + is seperated from first word ).

       for ( sFirst++ ; sFirst < line.Length(); sFirst++ )
       {
          if ( line [sFirst] != ' ' ) break;
       }
    }

// sFirst now points to the beginning of the command.

// Find next space ( after the first word )

    for ( eFirst = sFirst; eFirst < line.Length(); eFirst++ )
    {
		if ( line [eFirst] == ' ' ) break;
    }

// Find next non space 

    for ( sRest = eFirst; sRest < line.Length(); sRest++ )
    {
       if ( line [sRest] != ' ' ) break;
    }

// Find last non space

    for ( eRest = line.Length()-1; eRest > eFirst; eRest-- )
    {
       if ( line [eRest] != ' ' ) break;
    }


//NB [] notation is zero based; Sub(a,b) call is one based.

    CcString firstTok = line.Sub(sFirst+1,eFirst);
    CcString restLine = "";

    if ( sRest <= eRest )
    {
      bRest = true;
      eRest = max ( eRest, sRest );          // ensure positive length
      sRest = min ( sRest+1, line.Length()); // convert to valid 1-based index.
      eRest = min ( eRest+1, line.Length()); // convert to valid 1-based index.
      restLine = line.Sub(sRest,eRest);
    }

#ifdef __CR_WIN__

    if ( bWait )
    {
// Launch with ShellExecute function. Then wait for app.

      SHELLEXECUTEINFO si;

      si.cbSize       = sizeof(si);
      si.fMask        = SEE_MASK_NOCLOSEPROCESS|SEE_MASK_FLAG_NO_UI ;
      si.hwnd         = GetDesktopWindow();
      si.lpVerb       = "open";
      si.lpFile       = firstTok.ToCString();
      si.lpParameters = ( (bRest)? restLine.ToCString() : NULL );
      si.lpDirectory  = NULL;
      si.nShow        = SW_SHOWNORMAL;

      int err = (int)ShellExecuteEx ( & si );

      if ( (int)si.hInstApp == SE_ERR_NOASSOC )
      {
        CcString newparam = CcString("shell32.dll,OpenAs_RunDLL ")+firstTok+( (bRest) ? CcString(" ")+restLine : CcString("") ) ;
        si.lpFile       = "rundll32.exe";
        si.lpParameters = newparam.ToCString();
        si.fMask        = SEE_MASK_NOCLOSEPROCESS; //Don't mask errors for this call.
        ShellExecuteEx ( & si );
// It is not possible to wait for rundll32's spawned process, so
// we just pop up a message box, to hold this app here.
        AfxGetApp()->m_pMainWnd->MessageBox("CRYSTALS is waiting.\nClick OK when external application has exited.",
                                            "#SPAWN: Waiting",MB_OK);

        CcController::theController->ProcessOutput( " ");
        CcController::theController->ProcessOutput( "     {0,2 Waiting for {2,0 " + firstTok + " {0,2 to finish... ");
        CcController::theController->ProcessOutput( " ");
        WaitForSingleObject( si.hProcess, INFINITE );

      }
      else if ( (int)si.hInstApp <= 32 )
      {

// Some other failure. Try another method of starting external programs.

        CcController::theController->ProcessOutput( "{I Failed to start " + firstTok + ", (security or not found?) trying another method.");
        extern int errno;
        char * str = new char[81];
        memcpy(str,line.Sub(sFirst+1,-1).ToCString(),80);
        *(str+80) = '\0';

        char* args[10];       // This allows a maximum of 9 command line arguments

        char seps[] = " \t";
        char *token = strtok( str, seps );
        args[0] = token;
        for (int i = 1; (( token != NULL ) && ( i < 10 )); i++ )
        {
          token = strtok( NULL, seps );
          args[i] = token;
        }

        int result = _spawnvp(_P_WAIT, args[0], args);
  
        if ( result == -1 )  //Start failed
        {
          CcController::theController->ProcessOutput( "{I Failed again to start " + firstTok + ", errno is:" + CcString(errno)+" trying a command shell.");
          for (i = 7; i>=0; i--)
          {
             args[i+2] = args[i];
          }

          OSVERSIONINFO o;
          o.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
          GetVersionEx(&o);
  
          if (o.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS) args[0] = "command.com";
          else  args[0] = "cmd.exe";

          args[1] = "/c";
          result = _spawnvp(_P_WAIT, args[0], args);
          if ( result != 0 ) TEXTOUT ( "{I Failed yet again. Errno is:" + CcString(errno) + ". Giving up.");
        }
        delete [] str;

      }
      else
      {
        CcController::theController->ProcessOutput( " ");
        CcController::theController->ProcessOutput( "     {0,2 Waiting for {2,0 " + firstTok + " {0,2 to finish... ");
        CcController::theController->ProcessOutput( " ");
        WaitForSingleObject( si.hProcess, INFINITE );
      }


    }
    else
    {
// Launch with ShellExecute function. There is no waiting for apps to finish.
      HINSTANCE ex = ShellExecute( GetDesktopWindow(),
                                   "open",
                                   firstTok.ToCString(),
                                   ( (bRest)? restLine.ToCString() : NULL ),
                                   NULL,
                                   SW_SHOWNORMAL);
      if ( (int)ex == SE_ERR_NOASSOC )
      {
         ShellExecute( GetDesktopWindow(),
                       "open",
                       "rundll32.exe",
                       CcString(CcString("shell32.dll,OpenAs_RunDLL ")+firstTok).ToCString(),
                       NULL,
                       SW_SHOWNORMAL);
      }
      else if ( (int)ex <= 32 )
      {
// Some other failure. Try another method of starting external programs.
        CcController::theController->ProcessOutput( "{I Failed to start " + firstTok + ", (security or not found?) trying another method.");
        extern int errno;
        char * str = new char[81];
        memcpy(str,line.Sub(sFirst+1,-1).ToCString(),80);
        *(str+80) = '\0';

        char* args[10];       // This allows a maximum of 9 command line arguments

        char seps[] = " \t";
        char *token = strtok( str, seps );
        args[0] = token;
        for ( int i = 1; (( token != NULL ) && ( i < 10 )); i++ )
        {
          token = strtok( NULL, seps );
          args[i] = token;
        }

        int result = _spawnvp(_P_WAIT, args[0], args);
  
        if ( result == -1 )  //Start failed
        {
          CcController::theController->ProcessOutput( "{I Failed again to start " + firstTok + ", errno is:" + CcString(errno)+" trying a command shell.");
          for (i = 7; i>=0; i--)
          {
             args[i+2] = args[i];
          }

          OSVERSIONINFO o;
          o.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
          GetVersionEx(&o);
  
          if (o.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS) args[0] = "command.com";
          else  args[0] = "cmd.exe";

          args[1] = "/c";
          result = _spawnvp(_P_WAIT, args[0], args);
          if ( result != 0 ) TEXTOUT ( "{I Failed yet again. Errno is:" + CcString(errno) + ". Giving up.");
        }
        delete [] str;

      }

    }
#endif

#ifdef __BOTHWX__

// Attempt to launch as a command...

    if ( bWait )
    {
        CcController::theController->ProcessOutput( " ");
        CcController::theController->ProcessOutput( "     {0,2 Waiting for {2,0 " + firstTok + " {0,2 to finish... ");
        CcController::theController->ProcessOutput( " ");
        wxEnableTopLevelWindows(FALSE);
    }

    long result = ::wxExecute(line.Sub(sFirst+1,eRest).ToCString(), bWait);

    if ( bWait ) wxEnableTopLevelWindows(TRUE);

    if ( bWait )
    {
      if ( result != -1 ) return;
    }                                                              
    else
    {
      if ( result != 0 ) return;
    }

    CcController::theController->ProcessOutput( "     {0,2 Failed. Retrying.              ");

// FAILURE - maybe a filename, not a program
// try getting the program associated with the filename.

    wxString fullname(firstTok.ToCString());
    wxString path;
    wxString name;
    wxString extension;
    wxString command;
    ::wxSplitPath(firstTok.ToCString(),&path,&name,&extension);

    wxFileType * filetype = wxTheMimeTypesManager->GetFileTypeFromExtension(extension);

    if ( filetype && filetype->GetOpenCommand(&command,
                                  wxFileType::MessageParameters(fullname,_T("")) ) )
    {
        if ( bWait )
        {
            CcController::theController->ProcessOutput( " ");
            CcController::theController->ProcessOutput( "     {0,2 Waiting for {2,0 " + firstTok + " {0,2 to finish... ");
            CcController::theController->ProcessOutput( " ");
            wxEnableTopLevelWindows(FALSE);
        }
        long result = ::wxExecute(command, bWait);
        if ( bWait )
        {
          wxEnableTopLevelWindows(TRUE);
          if ( result != -1 ) return;
        }                                                              
        else
        {
          if ( result != 0 ) return;
        }
        CcController::theController->ProcessOutput( "     {0,2 Failed to execute associated command.      ");
        return;
    }

    CcController::theController->ProcessOutput( "     {0,2 Failed to find associated command. Trying shell" );
    CcController::theController->ProcessOutput( "     {0,2 "+line.Sub(sFirst+1,eRest) );

    ::wxShell(line.Sub(sFirst+1,eRest).ToCString());

    return;

#endif

  }


  void ciflushbuffer( long *theLength, char * theLine )
  {
      *(theLine + *theLength) = '\0';
      (CcController::theController)->AddInterfaceCommand( theLine );
//  #ifdef __CR_WIN__
//      AfxGetMainWnd()->PostMessage(WM_TIMER); //Force idle processing to (re)start so
//  #endif                                          //that the GetInterfaceCommand is called.
  }

  void FORCALL(cinextcommand) ( long *theStatus, char *theLine )
  {
      NOTUSED(theStatus);

          if((CcController::theController)->GetCrystalsCommand( theLine ))
      {
          int ilen = strlen(theLine);

                  for (int j = ilen; j<80; j++)   //Pad with blanks.
          {
              *(theLine + j) = ' ';
          }
          *(theLine+80) = '\0';

      }
      else
      {
         endthread ( 0 );
      }
  }

  void    FORCALL(ciendthread) (long theExitcode )
  {
        m_Crystals_Thread_Alive.Leave(); //Will be owned whole time crystals thread is running.
        endthread ( theExitcode );
  }

  void endthread ( long theExitcode )
  {
        if ( theExitcode == 1000 ) //This means crystals wants re-starting
        {
        // perhaps empty out the interface queue checking for RESTART command.
        }
        else if ( theExitcode > 0 )
        {
  #ifdef __CR_WIN__
           MessageBox(NULL,"Closing","Crystals ends in error",MB_OK|MB_TOPMOST|MB_TASKMODAL|MB_ICONHAND);
  #endif
  #ifdef __BOTHWX__
           wxMessageBox("Closing","Crystals ends in error",wxOK|wxICON_HAND);
  #endif
        }

  #ifdef __CR_WIN__
        AfxEndThread((UINT) theExitcode);
  #endif
  #ifdef __BOTHWX__
        (CcController::theController)->mCrystalsThread->CcEndThread( theExitcode );
  #endif

  }

  void FORCALL(newdata) (int isize, int* id)
  {
      CcQuickData* newdatablock = new CcQuickData(isize);
      *id = (int)newdatablock;
      return;
  }

  void FORCALL(datain) (int id, int *data, int offset, int nwords)
  {
      CcQuickData* olddatablock = (CcQuickData*) id;
      olddatablock->AddData(data,offset,nwords);
  }


} // end of C functions



