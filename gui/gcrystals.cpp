
// crystals.cpp : Defines the class behaviors for the application.
//

#include "crystalsinterface.h"
#include "crystals.h"
#include <string>
#include <algorithm>
#include <iostream>

#ifdef __WITH_CRASHRPT__
#include "CrashRpt.h"
#endif
using namespace std;


#ifdef CRY_USEMFC
  #include "stdafx.h"
  #include <cstdlib>
#else
  #include <wx/event.h>
  #include <wx/app.h>
  #include <wx/config.h>
  #ifdef CRY_OSWIN32
    #include <wx/msw/regconf.h>
  #endif
  #include <wx/clipbrd.h>
  #include <wx/stdpaths.h>
  #include <wx/filename.h>

#endif


#include "ccrect.h"
#include "cccontroller.h"

//#include "Stackwalker.h"

extern"C" {
void hdf5_dsc_use_set();
}


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
  #ifdef CRY_OSLINUX
    #include <X11/Xlib.h>
  #endif

#if defined(CRY_OSMAC)
#include <CoreFoundation/CoreFoundation.h>
  #include <Carbon/Carbon.h>
  #include <stdlib.h>
  #include <iostream>


std::string GetExePath() {
#ifdef CRY_OSLINUX
  // Code taken from: http://www.gamedev.net/community/forums/topic.asp?topic_id=459511
  std::string path = "";
  pid_t pid = getpid();
  char buf[20] = {0};
  sprintf(buf,"%d",pid);
  std::string _link = "/proc/";
  _link.append( buf );
  _link.append( "/exe");
  char proc[512];
  int ch = readlink(_link.c_str(),proc,512);
  if (ch != -1) {
    proc[ch] = 0;
    path = proc;
    std::string::size_type t = path.find_last_of("/");
    path = path.substr(0,t);
  }

  std::string crysdir = path + string("/");
  return crysdir;
#else
  std::string crysdir = wxStandardPaths::GetDataDir().ToStdString();
  return crysdir;
#endif
}



wxString macWorkingDir()
  {
    wxDirDialog dlg(NULL, "Choose directory to run CRYSTALS", wxGetCwd(),
                    wxDD_DEFAULT_STYLE );

    if ( dlg.ShowModal() == wxID_OK )
    {
        return dlg.GetPath();
    } else {
        exit(0);
    }

}


void macSetCRYSDIR(string pPath)
	{
    string tResources = "CRYSDIR=" + pPath + "/";
    char * writable = new char[tResources.size() + 1];
    std::copy(tResources.begin(), tResources.end(), writable);
    writable[tResources.size()] = '\0'; // don't forget the terminating 0
    // This will leak this much memory - but only once per program instance.
    putenv(writable);
}

/*void CCrystalsApp::MacOpenFile(const wxString & fileName )
	    {
    if ( fileName.length() > 0 )
		{
        // we need a directory name. Look for last slash
        string::size_type ils = fileName.find_last_of('/');
        //Check: is there a directory name?
        if ( ils != string::npos )
            m_directory = fileName.substr(0,ils);
        //Check: is there a dscfilename?
        int remain = fileName.length() - ils - 1;
        if ( remain > 0 )
            m_dscfile = fileName.substr(ils+1,remain);
		}

//    wxMessageBox("open",fileName);
    }
*/
  void macSetCRYSDIR(const char* pPath)
  {
    string tResources = pPath;
    tResources = "CRYSDIR=" + tResources + "/Crystals_Resources/";
    char * writable = new char[tResources.size() + 1];
    std::copy(tResources.begin(), tResources.end(), writable);
    writable[tResources.size()] = '\0'; // don't forget the terminating 0
    putenv(writable);
  }
#endif
class BriefMessageBox;

class MyBriefMessageTimer :  public wxTimer   // Used by BriefMessageBox.  Notify() kills the BriefMessageBox when the timer 'fires'
{
	public:
		void Setup( wxDialog* ptrtobox ){ p_box = ptrtobox; }
	protected:
		void Notify(){ p_box->EndModal( wxID_CANCEL ); }
		wxDialog* p_box;
};
class BriefMessageBox : wxDialog // Displays a message dialog for a defined time only
{
public:
BriefMessageBox( wxString Message, double secondsdisplayed = -1, wxString Caption = wxEmptyString );
protected:
MyBriefMessageTimer BriefTimer;
};
const int DEFAULT_BRIEFMESSAGEBOX_TIME = 5;

BriefMessageBox::BriefMessageBox( wxString Message, double secondsdisplayed /*= -1*/, wxString Caption /*= wxEmptyString*/ ) : wxDialog( NULL, -1, Caption )
{
	wxStaticBox* staticbox = new wxStaticBox( this, -1, wxT("") );
	wxStaticBoxSizer *textsizer = new wxStaticBoxSizer( staticbox, wxHORIZONTAL );
	textsizer->Add( CreateTextSizer( Message ), 1, wxCENTRE | wxALL, 10 );

	wxBoxSizer *mainsizer = new wxBoxSizer( wxHORIZONTAL );
	mainsizer->Add( textsizer, 1, wxCENTER | wxALL, 20 );

	SetSizer( mainsizer ); mainsizer->Fit( this );
	Centre( wxBOTH | wxCENTER_FRAME);

	BriefTimer.Setup(this);

	double length;
	if ( secondsdisplayed <= 0 )    // Minus number means default, and zero would mean infinite which we don't want here
		length = DEFAULT_BRIEFMESSAGEBOX_TIME;
	else length = secondsdisplayed;

	BriefTimer.Start( (int)(length * 1000), wxTIMER_ONE_SHOT );  // Start timer as one-shot.  *1000 gives seconds

	ShowModal();
}



  bool CCrystalsApp::OnInit()
  {

#ifdef __WITH_CRASHRPT__

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

  string vers = STR( CRYSVNVER );
  vers.erase ( std::remove(vers.begin(), vers.end(), ':'), vers.end());
  string vers2 =  "Crystals " + vers +  " Error Report";
//  tstring vers2;

  // Define CrashRpt configuration parameters
  CR_INSTALL_INFOA info;
  memset(&info, 0, sizeof(CR_INSTALL_INFO));
  info.cb = sizeof(CR_INSTALL_INFO);
  info.pszAppName = "Crystals";
  info.pszAppVersion = vers2.c_str();
  info.pszEmailSubject = vers2.c_str();
  info.pszEmailTo = "richard.cooper@chem.ox.ac.uk";
  info.pszUrl = "http://crystals.xtl.org.uk/tools/crashrpt.php";
  info.uPriorities[CR_HTTP] = 3;  // First try send report over HTTP
  info.uPriorities[CR_SMTP] = 2;  // Second try send report over SMTP
  info.uPriorities[CR_SMAPI] = 1; // Third try send report over Simple MAPI
  // Install all available exception handlers
  info.dwFlags |= CR_INST_ALL_POSSIBLE_HANDLERS;
  // Restart the app on crash
  info.dwFlags |= CR_INST_APP_RESTART;
  info.dwFlags |= CR_INST_SEND_QUEUED_REPORTS;
  info.pszRestartCmdLine = "";
  // Define the Privacy Policy URL
  info.pszPrivacyPolicyURL = "http://crytals.xtl.org.uk/tools/privacypolicy.html";

  // Install crash reporting
  int nResult = crInstallA(&info);
  if(nResult!=0)

  {
	  TCHAR szErrorMsg[256];
	  crGetLastErrorMsg(szErrorMsg, 256);
      BriefMessageBox(wxString(szErrorMsg));
  }
//    // Something goes wrong. Get error message.
//    TCHAR szErrorMsg[512] = _T("");
//    crGetLastErrorMsg(szErrorMsg, 512);
//    _tprintf_s(_T("%s\n"), szErrorMsg);
//    return 1;
//  }

#endif



	m_locale.Init(wxLANGUAGE_ENGLISH_US);

    string directory;
    string dscfile;


#if defined(CRY_OSMAC)
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
	//Find CRYSDIR from local executable path.

	  std::string pathsep = string(wxString(wxFileName::GetPathSeparator()).ToStdString());
//      std::string crysdir = wxStandardPaths::Get().GetDataDir().ToStdString() + pathsep;
// For CRYSDIR CONCATENATE application directory (GetDataDir), user data (GetUserDataDir), and common app data (GetConfigDir)
// The first is always used, the second for non-admin installs, the third for admin installed copies.
      std::string crysdir = wxStandardPaths::Get().GetDataDir().ToStdString() + pathsep + "," + wxStandardPaths::Get().GetUserDataDir().ToStdString() + pathsep + "," + wxStandardPaths::Get().GetConfigDir().ToStdString() + pathsep ;



// // Use the registry to fetch keys.
      string location;
//      wxString str;
//      wxConfig * config = new wxConfig("Chem Cryst");
//      if ( config->Read("Crystals/Crysdir", &str ) ) {
          location = crysdir.c_str();
//      }
//      delete config;
      location = location.insert( 0, "CRYSDIR=" );
      char * env = new char[location.size()+1];
      strcpy(env, location.c_str());
      stringlist.push_back(env);
#ifdef CRY_OSWIN32
      _putenv( env );
#else
      putenv( env );
#endif
    }
#endif

//    MessageBox(NULL,_T("Press OK to start"),_T("Pause for debug"),MB_OK);
// Parse any command line arguments

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
#if defined (CRY_OSWIN32)
          _putenv( env );
#else
          putenv( env );
#endif
          i = i + 2;
        }
      }
      else if (command=="--hdf5" || command=="/hdf5")
      {
        hdf5_dsc_use_set();
      }
      else
      {
        string command = string(argv[i]);

        if ( command.length() > 0 )
        {
// we need a directory name. Look for last slash or back slash
          string::size_type ils = command.find_last_of("/\\");
//Check: is there a directory name?
          if ( ils != string::npos )
            directory = command.substr(0,ils);
//Check: is there a dscfilename?
          int remain = command.length() - ils - 1;
          if ( remain > 0 )
            dscfile = command.substr(ils+1,remain);

        }
        std::cerr << "DSCfile to be opened: " << dscfile << "\n";
        std::cerr << "Working directory:    " << directory << "\n";
      }
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



  int CCrystalsApp::OnRun()
  {

	int bRun;
	int bExit=0;
	while(!bExit)
	{
		bRun= wxApp::OnRun();
		bExit=1;
	}


     wxTheClipboard->Flush();

#ifdef __WITH_CRASHRPT__
	// Uninstall CrashRpt here...
    crUninstall();
#endif

	return bRun;
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
