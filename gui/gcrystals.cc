// crystals.cpp : Defines the class behaviors for the application.
//

#ifdef __CR_WIN__
#include "stdafx.h"
#include <stdlib.h>
#endif
#ifdef __BOTHWX__
#include <wx/event.h>
#include <wx/app.h>
#endif

#include "crystalsinterface.h"
#include "crystals.h"
#include "crapp.h"
#include "cccontroller.h"

#ifdef __CR_WIN__
#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif
#endif
/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp
#ifdef __CR_WIN__
BEGIN_MESSAGE_MAP(CCrystalsApp, CWinApp)
    //{{AFX_MSG_MAP(CCrystalsApp)
    //}}AFX_MSG_MAP
    // Standard file based document commands
//      ON_COMMAND(ID_FILE_NEW, CWinApp::OnFileNew)
//      ON_COMMAND(ID_FILE_OPEN, CWinApp::OnFileOpen)
//      ON_MESSAGE(WM_STUFFTOPROCESS, OnStuffToProcess )
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp construction

CCrystalsApp::CCrystalsApp()
{
    // TODO: add construction code here,
    // Place all significant initialization in InitInstance
}

/////////////////////////////////////////////////////////////////////////////
// The one and only CCrystalsApp object

CCrystalsApp theApplication;


/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp initialization

BOOL CCrystalsApp::InitInstance()
{
    // Standard initialization
    // If you are not using these features and wish to reduce the size
    //  of your final executable, you should remove from the following
    //  the specific initialization routines you do not need.

#ifdef _AFXDLL
    Enable3dControls();         // Call this when using MFC in a shared DLL
#else
    Enable3dControlsStatic();   // Call this when linking to MFC statically
#endif




// The user can override the ini file settings by setting
// CRYSDIR to the crystals directory, and USECRYSDIR to anything.

      if ( getenv("USECRYSDIR") == nil )
      {
         char buffer[255];
         GetWindowsDirectory( (LPTSTR) &buffer[0], 255 );
         CcString inipath = buffer;
         inipath += "\\WinCrys.ini";

// First free the string
// allocated by MFC at
// CWinApp startup.
// The string is allocated
// before InitInstance is
// called.
         free((void*)m_pszProfileName);

// Change the name of the
// .INI file. The CWinApp destructor
// will free the memory.

         m_pszProfileName=_tcsdup(_T(inipath.ToCString()));
         CcString location =  (LPCTSTR)GetProfileString ( "Setup", "Location", NULL );
         _putenv( ("CRYSDIR="+location+"\\").ToCString() );

      }

    // Parse command line for standard shell commands, DDE, file open
      CCommandLineInfo cmdInfo;
      ParseCommandLine(cmdInfo);

      CcString command = CcString (cmdInfo.m_strFileName.GetBuffer(cmdInfo.m_strFileName.GetLength()));
      CcString directory;
      CcString dscfile;

        if ( command.Length() > 0 )
        {
// we need a directory name.
// look for last slash
            int iptr;
            int ils = -1;
            for ( iptr = 0; iptr < command.Length(); iptr++ )
            {
                  if ( command[iptr] == '\\' ) ils = iptr;
            }
//Check: is there a directory name?
            if ( ils > 0 )
            {
                  directory = command.Sub(1,ils);
            }
//Check: is there a dscfilename?
            if ( ils < command.Length()-1 )
            {
                  dscfile = command.Sub(ils+2,command.Length());
            }
       }


      LoadStandardCursor(IDC_APPSTARTING);

      theCrApp = new CrApp(directory,dscfile);

      LoadStandardCursor(IDC_ARROW);

      return true;
}



BOOL CCrystalsApp::OnIdle(LONG lCount)
{
    // TODO: Add your specialized code here and/or call the base class
    BOOL sysret = CWinApp::OnIdle(lCount);
    BOOL appret = false;

    if (lCount > 10)
    {

        appret = DoCommandTransferStuff();

    }

    //Only stop idle processing if:
    // 1. lCount is high.
    // 2. appret is false (no more interface commands)
    // 3. sysret is false (no more idle processing needed by framework).
    if((lCount > 1000) && (!appret) && (!sysret))
        return false;
    else
        return true;
}

/*
 *
 *void CCrystalsApp::OnStuffToProcess()
 *{
 *      char theLine[255];
 *      while (theCrApp->mController->GetInterfaceCommand(theLine))
 *      {
 *            int theLength;
 *            if(theLength = strlen( theLine )) //Assignment within conditional (OK)
 *            {
 *                  theLine[theLength+1]='\0';
 *                  theCrApp->mController->Tokenize(theLine);
 *            }
 *      }
 *
 *}
 *
 */

int CCrystalsApp::ExitInstance()
{

    delete theCrApp;
    delete (CFrameWnd*)m_pMainWnd;

    return CWinApp::ExitInstance();
}
#endif

#ifdef __BOTHWX__


/////////////////////////////////////////////////////////////////////////////
// The one and only CCrystalsApp object

IMPLEMENT_APP(CCrystalsApp)

/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp initialization

BEGIN_EVENT_TABLE( CCrystalsApp, wxApp )
      EVT_IDLE ( CCrystalsApp::OnIdle )
          EVT_TIMER ( 5241, CCrystalsApp::OnKickTimer )
END_EVENT_TABLE()

bool CCrystalsApp::OnInit()
{

      theCrApp = new CrApp("","crfilev2.dsc");

	  kickTimer = new wxTimer(this, 5241);
      kickTimer->Start(500);      //Call OnKickTimer every 1/2 second while idle.
      return true;
}



void CCrystalsApp::OnIdle(wxIdleEvent & event)
{
    wxApp::OnIdle(event);
    bool sysret = event.MoreRequested();

    
    int appret = DoCommandTransferStuff();


    //Only stop idle processing if:
    // 1. appret is false (no more interface commands)
    // 2. sysret is false (no more idle processing needed by framework).
    if((appret==0) && (!sysret))
    {
        return;
    }
    else
    {
        event.RequestMore();
    }
    return;
}

int CCrystalsApp::OnExit()
{

    delete theCrApp;
    return wxApp::OnExit();
}


void CCrystalsApp::OnKickTimer(wxTimerEvent& event)
{
        for ( int i=0; i<50; i++ )
        {  
           if ( ! DoCommandTransferStuff() ) break;
        }
}

#endif


BOOL CCrystalsApp::DoCommandTransferStuff()
{
    char theLine[255];
    bool appret = false;

    if(theCrApp->mController->GetInterfaceCommand(theLine))
    {
        appret = true;

        int theLength = 0;

        if(theLength = strlen( theLine )) //Assignment within conditional (OK)
        {
            theLine[theLength+1]='\0';
            theCrApp->mController->Tokenize(theLine);
        }
    }


    return appret;
}

