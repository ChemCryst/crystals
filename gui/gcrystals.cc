// crystals.cpp : Defines the class behaviors for the application.
//

#ifdef __CR_WIN__
#include "stdafx.h"
#include <cstdlib>
#endif
#ifdef __BOTHWX__
#include <wx/event.h>
#include <wx/app.h>
#endif

#include "crystalsinterface.h"
#include "crystals.h"
#include <string>
using namespace std;

#include "ccrect.h"
#include "cccontroller.h"

//#include "Stackwalker.h"

#ifdef __CR_WIN__

#ifdef _DEBUG
//#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/*
static struct _test
{
  _test()
  {
    InitAllocCheck(ACOutput_XML);
  }

  ~_test()
  {
    DeInitAllocCheck();
  }
} _myLeakFinder;
*/


/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp
BEGIN_MESSAGE_MAP(CCrystalsApp, CWinApp)
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

    InitCommonControls();

    CWinApp::InitInstance();

// The user can override the ini file settings by setting
// CRYSDIR to the crystals directory, and USECRYSDIR to anything.

      if ( getenv("USECRYSDIR") == nil )
      {

#ifdef __CR_WIN__
 // Use the registry to fetch keys.
      string location;
      string subkey = "Software\\Chem Cryst\\Crystals\\";
      HKEY hkey;
      DWORD dwdisposition, dwtype, dwsize;
      int dwresult = RegCreateKeyEx( HKEY_LOCAL_MACHINE, subkey.c_str(),
                     0, NULL,  0, KEY_READ, NULL, &hkey, &dwdisposition );
      if ( dwresult == ERROR_SUCCESS )
      {
         dwtype=REG_SZ;
         dwsize = 1024; // NB limits max key size to 1K of text.
         char buf [ 1024];
         dwresult = RegQueryValueEx( hkey, TEXT("Crysdir"), 0, &dwtype,
                                     (PBYTE)buf,&dwsize);
         if ( dwresult == ERROR_SUCCESS )  location = string(buf);
         RegCloseKey(hkey);
      }

      if ( dwresult != ERROR_SUCCESS )  // Try HK_CURRENT_USER instead
      {
         dwresult = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                     0, NULL,  0, KEY_READ, NULL, &hkey, &dwdisposition );
         if ( dwresult == ERROR_SUCCESS )
         {
            dwtype=REG_SZ;
            dwsize = 1024; // NB limits max key size to 1K of text.
            char buf [ 1024];
            dwresult = RegQueryValueEx( hkey, TEXT("Crysdir"), 0, &dwtype,
                                     (PBYTE)buf,&dwsize);
            if ( dwresult == ERROR_SUCCESS )  location = string(buf);
            RegCloseKey(hkey);
         }
      }

#else
         char buffer[255];
         GetWindowsDirectory( (LPTSTR) &buffer[0], 255 );
         string inipath = buffer;
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

         m_pszProfileName=_tcsdup(_T(inipath.c_str()));
         string location =  (LPCTSTR)GetProfileString ( "Setup", "Crysdir", NULL );
#endif
         location = location.insert( 0, "CRYSDIR=" );
         _putenv( location.c_str() );

      }

    // Parse command line for standard shell commands, DDE, file open
//      CCommandLineInfo cmdInfo;
//      ParseCommandLine(cmdInfo);

      string directory;
      string dscfile;


      for ( int i = 1; i < __argc; i++ )
      {
         string command = __argv[i];

         if ( command == "/d" )
         {
           if ( i + 2 >= __argc )
           {
             MessageBox(NULL,"/d requires two arguments - envvar and value!","Command line error",MB_OK);
           }
           else
           {
             string envvar = __argv[i+1];
             string value  = __argv[i+2];
             _putenv( (envvar+"="+value).c_str() );
             i = i + 2;
           }
         }
         else
         {
//           string command = string (cmdInfo.m_strFileName.GetBuffer(cmdInfo.m_strFileName.GetLength()));
           string command = __argv[i];

           if ( command.length() > 0 )
           {
// we need a directory name. Look for last slash
             string::size_type iptr;
             string::size_type ils = -1;
             for ( iptr = 0; iptr < command.length(); iptr++ )
             {
                  if ( command[iptr] == '\\' ) ils = iptr;
             }
//Check: is there a directory name?
             if ( ils > 0 )
             {
                  directory = command.substr(0,ils);
             }
//Check: is there a dscfilename?
             if ( ils < command.length()-1 )
             {
                  dscfile = command;
                  dscfile.erase(0,ils+1);
             }
           }

         }
      }

      LoadStandardCursor(IDC_APPSTARTING);

      theControl = new CcController(directory,dscfile);

      LoadStandardCursor(IDC_ARROW);

      return true;
}



BOOL CCrystalsApp::OnIdle(LONG lCount)
{

    if ( CWinApp::OnIdle(lCount) ) return TRUE; // Allow system processing first.

    if ( theControl->DoCommandTransferStuff() ) return TRUE;

    return FALSE;

}


LRESULT CCrystalsApp::OnStuffToProcess(WPARAM wp, LPARAM)
{
  theControl->DoCommandTransferStuff();
//  LOGSTAT ( "Stuff To Process" );
  return 0;
}


int CCrystalsApp::ExitInstance()
{

    int exit = theControl->m_ExitCode;

    delete theControl;
    delete (CFrameWnd*)m_pMainWnd;

    return exit;
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

#include <X11/Xlib.h>

bool CCrystalsApp::OnInit()
{

//      XInitThreads();

      string directory;
      string dscfile;


      for ( int i = 1; i < argc; i++ )
      {
         string command = argv[i];

         if ( command == "/d" )
         {
           if ( i + 2 >= argc )
           {
//             MessageBox(NULL,"/d requires two arguments - envvar and value!","Command line error",MB_OK);
           }
           else
           {
             string envvar = argv[i+1];
             string value  = argv[i+2];
             putenv( (char*) (envvar+"="+value).c_str() );
             i = i + 2;
           }
         }
         else
         {
           string command = argv[i];
           if ( command.length() > 0 )
           {
// we need a directory name. Look for last slash
             int iptr;
             int ils = -1;
             for ( iptr = 0; iptr < command.length(); iptr++ )
             {
                  if ( command[iptr] == '/' ) ils = iptr;
             }
//Check: is there a directory name?
             if ( ils > 0 )
             {
                  directory = command.substr(0,ils);
             }
//Check: is there a dscfilename?
             if ( ils < command.length()-1 )
             {
                  dscfile = command;
                  dscfile.erase(0,ils+1);
             }
           }

         }
      }



      theControl = new CcController(directory,dscfile);

      kickTimer = new wxTimer(this, 5241);
      kickTimer->Start(500);      //Call OnKickTimer every 1/2 second while idle.
      return true;
}

void CCrystalsApp::OnIdle(wxIdleEvent & event)
{
    wxApp::OnIdle(event);
    bool sysret = event.MoreRequested();


    bool appret;

    for ( int i=0; i<25; i++ )
    {
       if ( ! (appret = theControl->DoCommandTransferStuff()) ) break;
    }


    //Only stop idle processing if:
    // 1. appret is false (no more interface commands)
    // 2. sysret is false (no more idle processing needed by framework).
    if((!appret) && (!sysret))
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

    delete theControl;
    return wxApp::OnExit();
}


void CCrystalsApp::OnKickTimer(wxTimerEvent& event)
{
        for ( int i=0; i<25; i++ )
        {
           if ( ! theControl->DoCommandTransferStuff() ) break;
        }
}

#endif

#ifdef __CR_WIN__

//Remove dependency of new MFC library on OLEACC.DLL, by providing our own 
//proxy functions, which do nothing if OLEACC.DLL cannot be loaded.


extern "C" LRESULT _stdcall AccessibleObjectFromWindow(HWND hwnd, DWORD dwId, 
                                                       REFIID riid, void **ppvObject)
{
    COleaccProxy::Init();
    return COleaccProxy::m_pfnAccessibleObjectFromWindow ? 
       COleaccProxy::m_pfnAccessibleObjectFromWindow(hwnd, dwId, riid, ppvObject) : 0;
}

extern "C" LRESULT _stdcall CreateStdAccessibleObject(HWND hwnd, LONG idObject, 
                                                      REFIID riid, void** ppvObject)
{
    COleaccProxy::Init();
    return COleaccProxy::m_pfnCreateStdAccessibleObject ? 
       COleaccProxy::m_pfnCreateStdAccessibleObject(hwnd, idObject, riid, ppvObject) : 0;
}

extern "C" LRESULT _stdcall LresultFromObject(REFIID riid, WPARAM wParam, LPUNKNOWN punk)
{
    COleaccProxy::Init();
    return COleaccProxy::m_pfnLresultFromObject ? 
       COleaccProxy::m_pfnLresultFromObject(riid, wParam, punk) : 0;
}

HMODULE COleaccProxy::m_hModule = NULL;
BOOL COleaccProxy::m_bFailed = FALSE;

pfnAccessibleObjectFromWindow COleaccProxy::m_pfnAccessibleObjectFromWindow = NULL;
pfnCreateStdAccessibleObject COleaccProxy::m_pfnCreateStdAccessibleObject = NULL;
pfnLresultFromObject COleaccProxy::m_pfnLresultFromObject = NULL;

COleaccProxy::COleaccProxy(void)
{
}

COleaccProxy::~COleaccProxy(void)
{
}

void COleaccProxy::Init(void)
{
    if (!m_hModule && !m_bFailed)
    {
        m_hModule = ::LoadLibrary(_T("oleacc.dll"));
        if (!m_hModule)
        {
            m_bFailed = TRUE;
            return;
        }

        m_pfnAccessibleObjectFromWindow
             = (pfnAccessibleObjectFromWindow)::GetProcAddress(m_hModule, 
                                                          _T("AccessibleObjectFromWindow"));
        m_pfnCreateStdAccessibleObject
             = (pfnCreateStdAccessibleObject)::GetProcAddress(m_hModule, 
                                                          _T("CreateStdAccessibleObject"));
        m_pfnLresultFromObject = (pfnLresultFromObject)::GetProcAddress(m_hModule, 
                                                          _T("LresultFromObject"));
    }
}
#endif
