////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWeb

////////////////////////////////////////////////////////////////////////

//   Filename:  cxweb.cc
//   Authors:   Richard Cooper 
//   Created:   04.3.2011 14:31 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1  2011/04/16 06:49:45  rich
//   HTML control
//

#include    "crystalsinterface.h"


#ifdef DEPRECATEDCRY_USEWX

// The whole file. WX only.

#include    <string>
using namespace std;
#include    "cccontroller.h"
#include    "cxweb.h"
//insert your own code here.
#include    "cxgrid.h"
#include    "crweb.h"


#ifdef CRY_USEMFC
#include    <afxwin.h>
#endif

#ifdef CRY_USEWX
#include    <wx/gdicmn.h>
#include <wx/stdpaths.h>
#include <wx/filename.h>
#include <wx/dir.h>
#include    <wx/event.h>
#endif

int CxWeb::mWebCount = kWebBase;

CxWeb * CxWeb::CreateCxWeb( CrWeb * container, CxGrid * guiParent )
{
    CxWeb *theStdWeb = new CxWeb(guiParent,-1,wxPoint(0,0),wxSize(300,700));
	theStdWeb->Initialise(container);
	//theStdWeb->InitXULRunner();
	wxString m_uri_home = wxT("http://www.xtl.ox.ac.uk/");
    // set the DOM content loaded flag
//    m_dom_contentloaded = false;
    // open the home location
    theStdWeb->OpenURI(m_uri_home);


    return theStdWeb;
}

void CxWeb::Initialise(CrWeb* container)
{
     ptr_to_crObject = (CrGUIElement*)container;
     mIdealHeight = 300;
     mIdealWidth  = 700;
}

CxWeb::~CxWeb()
{
    mWebCount--;
}

void CxWeb::CxDestroyWindow()
{
#ifdef CRY_USEMFC
DestroyWindow();
#endif
#ifdef CRY_USEWX
Destroy();
#endif
}


CXSETGEOMETRY(CxWeb)
CXGETGEOMETRIES(CxWeb)


int CxWeb::GetIdealWidth()
{
    return mIdealWidth;
}

int CxWeb::GetIdealHeight()
{
    return mIdealHeight;
}


void CxWeb::SetAddress(const string &uri) {
	OpenURI(uri);
}

void CxWeb::SetIdealHeight(int nCharsHigh)
{
#ifdef CRY_USEMFC
      mIdealHeight = nCharsHigh * mHeight;
#endif
#ifdef CRY_USEWX
      mIdealHeight = nCharsHigh * GetCharHeight();
#endif
}

void CxWeb::SetIdealWidth(int nCharsWide)
{
#ifdef CRY_USEMFC
    CClientDC cdc(this);
    TEXTMETRIC textMetric;
    cdc.GetTextMetrics(&textMetric);
      int owidth = textMetric.tmAveCharWidth;
      mIdealWidth = nCharsWide * owidth;
#endif
#ifdef CRY_USEWX
      mIdealWidth = nCharsWide * GetCharWidth();
#endif
}



#ifdef CRY_USEWX
//wx Message Map
BEGIN_EVENT_TABLE(CxWeb, wxWebControl)
END_EVENT_TABLE()
#endif

void CxWeb::Focus()
{
    SetFocus();
}


void CxWeb::Disable(bool disabled)
{
#ifdef CRY_USEMFC
    if(disabled)
            EnableWindow(false);
    else
            EnableWindow(true);
#endif
#ifdef CRY_USEWX
    if(disabled)
            Enable(false);
    else
            Enable(true);
#endif
}


bool CxWeb::InitXULRunner()
{
        // Locate the XULRunner engine; the following call will look for 
        // a directory named "xr"
	    wxString xulrunner_path = CxWeb::FindXulRunner(wxT("xr"));
        if (xulrunner_path.IsEmpty())
        {
//            wxMessageBox(wxT("Could not find xulrunner directory"));
            return false;
        }    
    
        // Locate some common paths and initialize the control with
        // the plugin paths; add these common plugin directories to 
        // MOZ_PLUGIN_PATH
        wxString program_files_dir;
        ::wxGetEnv(wxT("ProgramFiles"), &program_files_dir);
        if (program_files_dir.Length() == 0 || program_files_dir.Last() != '\\')
            program_files_dir += wxT("\\");

        wxString dir = program_files_dir;
        dir += wxT("Mozilla Firefox\\plugins");
        wxWebControl::AddPluginPath(dir);

        // to install the flash plugin automatically, if it exists, 
        // add a path to the flash location; for example, on windows,
        // if the system directory is given by system_dir, then, we have:
        //
        // wxString dir2 = system_dir;
        // dir2 += wxT("Macromed\\Flash");
        // wxWebControl::AddPluginPath(dir2);

        // Finally, initialize the engine; Calling wxWebControl::InitEngine()
        // is very important and has to be made before using wxWebControl.  
        // It instructs wxWebConnect where the xulrunner directory is.
        wxWebControl::InitEngine(xulrunner_path);

        return true;
    }
    
wxString CxWeb::FindXulRunner(const wxString& xulrunner_dirname)
	{
        // get the location of this executable
        wxString exe_path = wxStandardPaths::Get().GetExecutablePath();
        wxString path_separator = wxFileName::GetPathSeparator();
        exe_path = exe_path.BeforeLast(path_separator[0]);
        exe_path += path_separator;

        wxString path;

        // first, check <exe_path>/<xulrunner_path>
        path = exe_path + xulrunner_dirname;
        if (wxDir::Exists(path))
            return path;
  
        // next, check <exe_path>/../<xulrunner_path>
        path = exe_path + wxT("..") + path_separator + xulrunner_dirname;
        if (wxDir::Exists(path))
            return path;

        // finally, check <exe_path>/../../<xulrunner_path>
        path = exe_path + wxT("..") + path_separator + wxT("..") + path_separator + xulrunner_dirname;
        if (wxDir::Exists(path))
            return path;

        return wxEmptyString;
    }

























#endif
