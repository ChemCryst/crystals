
// crystals.cpp : Defines the class behaviors for the application.
//

#include "crystalsinterface.h"
#include "crystals.h"
#include "startupdialog.h"
#include <string>
#include <algorithm>
#include <iostream>

#ifdef __WITH_CRASHRPT__
#include "CrashRpt.h"
#endif
using namespace std;


#include <wx/event.h>
#include <wx/app.h>
#include <wx/config.h>
#ifdef CRY_OSWIN32
  #include <wx/msw/regconf.h>
#endif
#include <wx/clipbrd.h>
#include <wx/stdpaths.h>
#include <wx/filename.h>
#include <wx/log.h>


#include "ccrect.h"
#include "cccontroller.h"

//#include "Stackwalker.h"

extern"C" {
void hdf5_dsc_use_set();
}

void InitCrashReporting();
void DetermineAndSetCrysdir();
bool BrowseDialog(string &directory, string &dscfile);
bool ShowWorkshopDialog(string &directory, string &dscfile);


// The one and only CCrystalsApp object
IMPLEMENT_APP(CCrystalsApp)

// On unix calls to putenv must have non-const strings, and
// the string's memory must not be freed until later.
list<char*> stringlist; // Store strings in this global so memory can be freed at exit.

const wxEventType ccEVT_COMMAND_ADDED = wxNewEventType();



BEGIN_EVENT_TABLE( CCrystalsApp, wxApp )
    EVT_CUSTOM ( ccEVT_COMMAND_ADDED, wxID_ANY, CCrystalsApp::OnCrystCommand )
END_EVENT_TABLE()

#ifdef CRY_OSLINUX
    #include <X11/Xlib.h>
#endif

#if defined(CRY_OSMAC)
	#include <CoreFoundation/CoreFoundation.h>
	#include <Carbon/Carbon.h>
	#include <stdlib.h>
	#include <iostream>
	
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


	InitCrashReporting();


	m_locale.Init(wxLANGUAGE_ENGLISH_US);

    string directory;
    string dscfile;

	DetermineAndSetCrysdir();


// Parse any command line arguments
//
//  crystals.exe [/d] [/hdf5] [ [/browse] | [<dscfilename>] ] 
//
//  /d <ENVVAR> <VALUE>           Sets environment variable ENVVAR to VALUE within the program's environment.
//  /hdf5						  Uses hdf5 container instead of dsc file.
//  [/browse | /workshop]		  Open recently used files/folder dialog, or workshop dialog. Ignores dscfilename if set.
//  [<dscfilename>]				  Filename of dsc to open
//

    bool browsemode = false;
    bool workshopmode = false;

    for ( int i = 1; i < argc; i++ )
    {
      string command = string(argv[i]);
      if ( command == "/d" || command == "-d" )
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
          stringlist.push_back(env);  // Store strings in this global so memory can be freed at exit.
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
      else if (command=="--browse" || command=="/browse")
      {
		browsemode = true;
		workshopmode = false;
      }
      else if (command=="--workshop" || command=="/workshop")
      {
		browsemode = false;
		workshopmode = true;
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

	if ( browsemode ) {
		
		if ( ! BrowseDialog(directory, dscfile) ) {   // pass references, strings get updated.
			return false; // user pressed cancel
		}
	} else if ( workshopmode ) {

		if ( ! ShowWorkshopDialog(directory, dscfile) ) {   // pass references, strings get updated.
			return false; // user pressed cancel
		}
		
	}		


	wxFileName re( directory ,  dscfile ) ;
	CcMRUFiles cmruf;
	cmruf.AddFile( re );

// Create a controller for the program.
    wxLogNull logNo; //suspend logging.
    theControl = new CcController(directory,dscfile);

    return true; // Init complete
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
	// Delete strings in this global.
    list<char*>::iterator s = stringlist.begin();
    while ( s != stringlist.end() )
    {
        delete *s;
        s++;
    }
    return wxApp::OnExit();
  }


void InitCrashReporting() {
	
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

}



void DetermineAndSetCrysdir()
{
	
	
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
	// For CRYSDIR CONCATENATE application directory (GetDataDir), user data (GetUserDataDir), and common app data (GetConfigDir)
	// The first is always used, the second for non-admin installs, the third for admin installed copies.
		std::string crysdir = wxStandardPaths::Get().GetDataDir().ToStdString() + pathsep + "," + wxStandardPaths::Get().GetUserDataDir().ToStdString() + pathsep + "," + wxStandardPaths::Get().GetConfigDir().ToStdString() + pathsep ;
	
		string location;
		location = crysdir.c_str();
		location = location.insert( 0, "CRYSDIR=" );
		char * env = new char[location.size()+1];
		strcpy(env, location.c_str());
		stringlist.push_back(env); // Store strings in this global so memory can be freed at exit.
	
	#ifdef CRY_OSWIN32
		_putenv( env );
	#else
		putenv( env );
	#endif
		}
#endif
}


// Returns false if 'Cancel' was pressed, otherwise returns with directory and dscfile set.
bool BrowseDialog(string &directory, string &dscfile){ 

	StartUpDialog startupdialog ( NULL, -1, _("CRYSTALS launcher"),
	                          wxPoint(100, 100), wxSize(45, 45) );

	if ( startupdialog.ShowModal() != wxID_OK )
		return false;

	directory = startupdialog.directory;
	dscfile = startupdialog.dscfile;
	return true;
}

// Returns false if 'Cancel' was pressed, otherwise returns with directory and dscfile set.
bool ShowWorkshopDialog(string &directory, string &dscfile){ 

	WorkshopDialog wsdialog ( NULL, -1, _("CRYSTALS workshop launcher"),
	                          wxPoint(100, 100), wxSize(45, 45) );

	if ( wsdialog.ShowModal() != wxID_OK )
		return false;

	directory = wsdialog.directory;
	dscfile = _("crfilev2.dsc");
	return true;
}

