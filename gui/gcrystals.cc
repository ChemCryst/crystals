// crystals.cpp : Defines the class behaviors for the application.
//

#include "crystalsinterface.h"
#include "crystals.h"
#include <string>
#include <iostream>
using namespace std;


#ifdef __CR_WIN__
  #include "stdafx.h"
  #include <cstdlib>
#endif

#ifdef __BOTHWX__
  #include <wx/event.h>
  #include <wx/app.h>
  #include <wx/config.h>
#endif

#ifdef __WXMSW__
  #include <wx/msw/regconf.h>
#endif

#include "ccrect.h"
#include "cccontroller.h"

//#include "Stackwalker.h"

#ifdef __CR_WIN__
  #ifdef __CRDEBUG__
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

  // CCrystalsApp
  BEGIN_MESSAGE_MAP(CCrystalsApp, CWinApp)
	  ON_THREAD_MESSAGE(WM_CRYSTALS_COMMAND, CCrystalsApp::OnCrystCommand)
  END_MESSAGE_MAP()

  // CCrystalsApp construction

  CCrystalsApp::CCrystalsApp()
  {
  }

  // The one and only CCrystalsApp object
  CCrystalsApp theApplication;

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
  // CRYSDIR to the crystals directory.
 
    if ( getenv("CRYSDIR") == nil )
    {

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

      location = location.insert( 0, "CRYSDIR=" );
      _putenv( location.c_str() );

    }

    string directory = "";
    string dscfile = "";
	
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
         string command = __argv[i];

         if ( command.length() > 0 )
         {
// we need a directory name. Look for last slash
           string::size_type ils = command.find_last_of('\\');
//Check: is there a directory name?
           if ( ils != string::npos )
                directory = command.substr(0,ils);
//Check: is there a dscfilename?
           int remain = command.length() - ils - 1;
           if ( remain > 0 )
                dscfile = command.substr(ils+1,remain);
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
 
  void CCrystalsApp::OnCrystCommand(UINT wp, LONG p)
  {
	theControl->DoCommandTransferStuff();
  }
  
  LRESULT CCrystalsApp::OnStuffToProcess(WPARAM wp, LPARAM)
  {
    theControl->DoCommandTransferStuff();
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
  // The one and only CCrystalsApp object
  IMPLEMENT_APP(CCrystalsApp)

  // On unix calls to putenv must have non-const strings, and
  // the string's memory must not be freed until later.
  list<char*> stringlist;

//	DEFINE_EVENT_TYPE(ccEVT_COMMAND_ADDED)
	const wxEventType ccEVT_COMMAND_ADDED = wxNewEventType();
	
	
//#define wxID_ANY -1



/*#if wxCHECK_VERSION(2, 5, 3)
#define EVT_CC_COMMAND_ADDED(id, fn) \
    DECLARE_EVENT_TABLE_ENTRY( \
        ccEVT_COMMAND_ADDED, id, wxID_ANY, \
        (wxObjectEventFunction)(wxEventFunction) wxStaticCastEvent( wxCommandEventFunction, &fn ), \
        (wxObject *) NULL \
    ),
#else
#define wxID_ANY -1
#define EVT_CC_COMMAND_ADDED(id, fn) \
    DECLARE_EVENT_TABLE_ENTRY( \
        ccEVT_COMMAND_ADDED, id, -1, \
        (wxObjectEventFunction)(wxEventFunction) (wxCommandEventFunction)&fn, \
        (wxObject *) NULL \
    ),
#endif
*/

  // CCrystalsApp initialization
//  EVT_TIMER ( 5241, CCrystalsApp::OnKickTimer )
//  BEGIN_EVENT_TABLE( CCrystalsApp, wxApp )
	//  EVT_CC_COMMAND_ADDED (wxID_ANY, CCrystalsApp::OnCrystCommand )
  //END_EVENT_TABLE()
  BEGIN_EVENT_TABLE( CCrystalsApp, wxApp )
	  EVT_CUSTOM ( ccEVT_COMMAND_ADDED, wxID_ANY, CCrystalsApp::OnCrystCommand )
//          EVT_ACTIVATE_APP( CCrystalsApp::Activate )
  END_EVENT_TABLE()

/*void CCrystalsApp::Activate(wxActivateEvent& event) {

  stringstream s;
  s << "App " << (int)this;
  if ( event.GetActive() )
     s << "activated ";
  else
    s << " deactivated ";
  s << "id = " << event.GetId();
  LOGERR(s.str());

}
*/
  #ifdef __WXGTK__
    #include <X11/Xlib.h>
  #endif

#if defined(__WXMAC__)
  #include <Carbon/Carbon.h>
  #include <stdlib.h>
  #include <iostream>

  const string macWorkingDir()
  {
   NavDialogCreationOptions tDialogOptions;
   NavDialogRef tDialog; 
   NavReplyRecord tReply;

   if (NavGetDefaultDialogCreationOptions(&tDialogOptions) == noErr)
    {
      tDialogOptions.windowTitle = CFSTR("Select Working Directory");
      tDialogOptions.actionButtonLabel = CFSTR("Choose");

      if (NavCreateChooseFolderDialog(&tDialogOptions, NULL, 
				      NULL, NULL, &tDialog) == noErr)
	{
	  NavDialogRun(tDialog);
	  NavUserAction tUserAction = NavDialogGetUserAction(tDialog);
	  if (tUserAction != kNavUserActionCancel && 
	      tUserAction != kNavUserActionNone)
	    {
	      NavDialogGetReply(tDialog, &tReply);
	      SInt32 tCount;
	      UInt8  tPath[PATH_MAX];
	      if (tReply.validRecord && 
		  AECountItems(&(tReply.selection), &tCount) == noErr && 
		  tCount == 1)  //1 Directory was chosen 
		{
		  FSRef tFolder;
		  DescType tType;
		  AEKeyword tKeyWord;
		  Size tSize;
	      
		  AEGetNthPtr(&(tReply.selection), 1, typeFSRef, &tKeyWord, &tType,
			      (DescType*)&tFolder, sizeof(tFolder), &tSize); 
		  FSRefMakePath(&tFolder, tPath, PATH_MAX);
		}
	      NavDisposeReply(&tReply);
	      return string((char*)tPath);
	    }
	  exit(0);
	}

    }
   std::cerr << "There was an error when setting up the working directly dialog.\n";
   exit(0);
   return string();
  }

  void macSetCRYSDIR(const char* pPath)
  {
    string tResources = pPath;
    tResources = "CRYSDIR=" + tResources + "/Crystals_Resources/";
    putenv(tResources.c_str()); 
  }
#endif    

  bool CCrystalsApp::OnInit()
  {
    m_locale.Init(wxLANGUAGE_ENGLISH_US);
   
    string directory;
    string dscfile;


#if defined(__WXMAC__)
    UInt8 tPath[PATH_MAX];
    if (getenv("FINDER") != NULL)
      {
 	directory = macWorkingDir();
	directory += "/";
      }
    CFURLGetFileSystemRepresentation(CFBundleCopyResourcesDirectoryURL(CFBundleGetMainBundle()), true, tPath, PATH_MAX); 
    if (getenv("CRYSDIR") == NULL)
    {
      macSetCRYSDIR((char*)tPath);
    }
#else
    if ( getenv("CRYSDIR") == nil )
    {
 // Use the registry to fetch keys.
      string location;
      wxString str;
      wxConfig * config = new wxConfig("Chem Cryst");
      if ( config->Read("Crystals/Crysdir", &str ) ) {
        location = str.c_str();
      }
      delete config;
      location = location.insert( 0, "CRYSDIR=" );
      char * env = new char[location.size()+1];
      strcpy(env, location.c_str());
      stringlist.push_back(env);
#ifdef __BOTHWIN__      
      _putenv( env );
#else     
      putenv( env );
#endif      
    }
#endif

//    MessageBox(NULL,_T("Press OK to start"),_T("Pause for debug"),MB_OK);

    for ( int i = 1; i < argc; i++ )
    {
      string command = string(argv[i]);
      if ( command == "/d" )
      {
        if ( i + 2 >= argc )
        {
//             MessageBox(NULL,"/d requires two arguments - envvar and value!","Command line error",MB_OK);
        }
        else
        {
          string envvar = string(argv[i+1]);
          envvar += "=";
          envvar += argv[i+2];
          char * env = new char[envvar.size()+1];
          strcpy(env, envvar.c_str());
          stringlist.push_back(env);
#if defined (__BOTHWIN__)
          _putenv( env );
#else
          putenv( env );
#endif
          i = i + 2;
        }
      }
      else
      {
        string command = string(argv[i]);
        if ( command.length() > 0 )
        {
// we need a directory name. Look for last slash
          string::size_type ils = command.find_last_of('/');
//Check: is there a directory name?
          if ( ils != string::npos )
            directory = command.substr(0,ils);
//Check: is there a dscfilename?
          int remain = command.length() - ils - 1;
          if ( remain > 0 )
            dscfile = command.substr(ils+1,remain);
        }
      }

      std::cerr << "DSCfile to be opened: " << dscfile << "\n";
      std::cerr << "Working directory:    " << directory << "\n";

    }
    theControl = new CcController(directory,dscfile);
   // kickTimer = new wxTimer(this, 5241);
   // kickTimer->Start(500);      //Call OnKickTimer every 1/2 second while idle.
    return true;
  }

  void CCrystalsApp::OnCrystCommand(wxEvent & event)
  {
	theControl->DoCommandTransferStuff();
  }

  int CCrystalsApp::OnExit()
  {
    delete theControl;
    list<char*>::iterator s = stringlist.begin();
    while ( s != stringlist.end() )
    {
        delete *s;
        s++;
    }
    return wxApp::OnExit();
  }

#endif






#ifdef __CR_WIN__

  // Remove dependency of new MFC library on OLEACC.DLL, by 
  // providing our own proxy functions, which do nothing if 
  // OLEACC.DLL cannot be loaded.

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
