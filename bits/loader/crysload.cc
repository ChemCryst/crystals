#include <windows.h>
#include <shlobj.h> // For the SHBrowse stuff.
#include <direct.h> // For the _chdir function.
#include <conio.h>
#include <process.h>

#include <string>
#include <sstream>
using namespace std;



// This program does the following (windows only):
// 1. Queries the registry for the location of the last opened structure.
// 2. Queries the registry for the location of crystals.exe (it looks
//    in two places in case crystals was installed without admin privs).
// 3. Checks (in the registry) if this is the first ever run of CRYSTALS
//    and if so offers link to help file.
// 4. Offers a folder browser to choose a working directory (set to the
//    location found in (1).
// 5. Changes the working directory to the one selected and starts CRYSTALS.

static int __stdcall BrowseCallbackProc(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData);

int WINAPI WinMain ( HINSTANCE hIn, HINSTANCE hPrIn, LPSTR lpCmdLine, int nCmdShow )
{
      string lastPath, location, firstTime;

 // Use the registry to fetch keys.
      string subkey = "Software\\Chem Cryst\\Crystals\\";

      HKEY hkey;
      DWORD dwdisposition, dwtype, dwsize;
      int dwresult = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                              0, NULL,  0, KEY_READ, NULL,
                              &hkey, &dwdisposition );
                              
      if ( dwresult == ERROR_SUCCESS )
      {
         dwtype=REG_SZ;
         dwsize = 1024; // NB limits max key size to 1K of text.
         char buf [ 1024];
      
         dwresult = RegQueryValueEx( hkey, TEXT("Strdir"), 0, &dwtype,
                                  (PBYTE)buf,&dwsize);
         if ( dwresult == ERROR_SUCCESS )  lastPath = string(buf);

         RegCloseKey(hkey);
      }

      dwresult = RegCreateKeyEx( HKEY_LOCAL_MACHINE, subkey.c_str(),
                                   0, NULL,  0, KEY_READ, NULL,
                                   &hkey, &dwdisposition );
                              
      if ( dwresult == ERROR_SUCCESS )
      {
         dwtype=REG_SZ;
         dwsize = 1024; // NB limits max key size to 1K of text.
         char buf [ 1024];
     
         dwresult = RegQueryValueEx( hkey, TEXT("Location"), 0, &dwtype,
                                  (PBYTE)buf,&dwsize);
         if ( dwresult == ERROR_SUCCESS ) location = string(buf);

         RegCloseKey(hkey);
      }

      if ( dwresult != ERROR_SUCCESS )  // Try HK_CURRENT_USER instead.
      {
         dwresult = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                                      0, NULL,  0, KEY_READ, NULL,
                                      &hkey, &dwdisposition );
                              
         if ( dwresult == ERROR_SUCCESS )
         {
            dwtype=REG_SZ;
            dwsize = 1024; // NB limits max key size to 1K of text.
            char buf [ 1024];
     
            dwresult = RegQueryValueEx( hkey, TEXT("Location"), 0, &dwtype,
                                  (PBYTE)buf,&dwsize);
            if ( dwresult == ERROR_SUCCESS ) location = string(buf);
    
            RegCloseKey(hkey);
         }
      }



      dwresult = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                                   0, NULL,  0, KEY_READ|KEY_WRITE, NULL,
                                   &hkey, &dwdisposition );
                              
      if ( dwresult == ERROR_SUCCESS )
      {
         dwtype=REG_SZ;
         dwsize = 1024; // NB limits max key size to 1K of text.
         char buf [ 1024];

         dwresult = RegQueryValueEx( hkey, TEXT("OfferHelp"), 0, &dwtype,
                                  (PBYTE)buf,&dwsize);
         if ( dwresult == ERROR_SUCCESS )  firstTime = string(buf);

         dwtype = REG_SZ;
         dwsize = ( strlen(TEXT("NO")) + 1) * sizeof(TCHAR);
         RegSetValueEx(hkey, TEXT("OfferHelp"), 0, dwtype,
                          (PBYTE)TEXT("NO"), dwsize);
         RegCloseKey(hkey);

         if ( ! ( firstTime == "NO" ) )
         {
            int answer = MessageBox(NULL,
            "This appears to be the first time\nthat you have run CRYSTALS.\nWould you like to see a help file?",
            "CRYSTALS: First time?",
             MB_YESNO|MB_ICONINFORMATION|MB_DEFBUTTON1|MB_APPLMODAL|MB_SETFOREGROUND);

            if ( answer == IDYES )
            {

               string helpdoc = location + "\\manual\\readme.html";

               HINSTANCE ex = ShellExecute( GetDesktopWindow(),
                                   "open",
                                   helpdoc.c_str(),
                                   NULL, NULL, SW_SHOWNORMAL);

               if ( (int)ex == SE_ERR_NOASSOC )
               {
                  ShellExecute( GetDesktopWindow(),
                               "open",
                               "rundll32.exe",
                               (string("shell32.dll,OpenAs_RunDLL ")+helpdoc).c_str(),
                               NULL,  SW_SHOWNORMAL);
               }
               else if ( (int)ex <= 32 )
               {
// Some other failure. Try another method of starting external programs.
                 extern int errno;

                 int result = _spawnlp(_P_WAIT, helpdoc.c_str(), helpdoc.c_str(), NULL);

                 if(result == -1) {
                   ostringstream strm;
                   strm << "(2) Failed to start " << helpdoc << ", errno is:" << errno ;
                   MessageBox(NULL,
                   strm.str().c_str(),
                   "Error", MB_OK|MB_APPLMODAL);
                 }
               }
            }
         }
      }

      BROWSEINFO bi;
      LPITEMIDLIST chosen; //The chosen directory as an IDLIST(?)
      char buffer2[MAX_PATH];
      char title[36] = "Choose a directory to run CRYSTALS";

      bi.hwndOwner = NULL;
      bi.pidlRoot = NULL;
      bi.pszDisplayName = buffer2;
      bi.lpszTitle = (char*)&title;
      bi.ulFlags = BIF_RETURNONLYFSDIRS;
      bi.iImage = NULL;
      bi.lpfn = NULL ;
      bi.lParam = NULL;

      if ( lastPath.length() )
      {
        bi.lpfn = BrowseCallbackProc;
        bi.lParam = (LPARAM)(&lastPath);
      }

      chosen = ::SHBrowseForFolder( &bi );

      if ( chosen  )
      {
          if ( SHGetPathFromIDList(chosen, buffer2))
          {
             string result = string(buffer2);
             _chdir ( result.c_str() );

             location += "\\crystals.exe";

             string locationQ = string("\"") + location + "\"";


             dwresult = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                                     0, NULL,  0, KEY_WRITE, NULL,
                                     &hkey, &dwdisposition );
                              
             if ( dwresult == ERROR_SUCCESS )
             {
               dwtype = REG_SZ;
               dwsize = ( strlen(result.c_str()) + 1) * sizeof(TCHAR);

               RegSetValueEx(hkey, TEXT("Strdir"), 0, dwtype,
                             (PBYTE)result.c_str(), dwsize);
               RegCloseKey(hkey);
             }


             HINSTANCE ex = ShellExecute( GetDesktopWindow(),
                                   "open",
                                   location.c_str(),
                                   NULL, NULL, SW_SHOWNORMAL);

             if ( (int)ex == SE_ERR_NOASSOC )
             {
                 ShellExecute( GetDesktopWindow(),
                               "open",
                               "rundll32.exe",
                               string(string("shell32.dll,OpenAs_RunDLL ")+location).c_str(),
                               NULL,  SW_SHOWNORMAL);
             }
             else if ( (int)ex <= 32 )
             {
// Some other failure. Try another method of starting external programs.
                 extern int errno;
                 int result = _spawnlp(_P_WAIT, location.c_str(), locationQ.c_str(), NULL);

                 if(result == -1) {
                 ostringstream strm;
                 strm << "(4) Failed to start " << location << ", errno is:" << errno;
                 MessageBox(NULL,
                 strm.str().c_str(),
                 "Error", MB_OK|MB_APPLMODAL);
                 }
             }
          }
      }
      return 0;
}


// This callback sets the last path used if found in the registry.

int __stdcall BrowseCallbackProc(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData)
{
  string* rp = (string*)(lpData);
  if (uMsg == BFFM_INITIALIZED)
  {
     (void)SendMessage(hwnd, BFFM_SETSELECTION, TRUE, (LPARAM)(LPCTSTR)rp->c_str() );
  }
  return 0;
}


//Work around for deployment on old Win95 platforms.

//Remove dependency of new MFC library on OLEACC.DLL, by providing our own 
//proxy functions, which do nothing if OLEACC.DLL cannot be loaded.

typedef LRESULT (_stdcall *pfnAccessibleObjectFromWindow)(HWND hwnd, DWORD dwId, 
                                                    REFIID riid, void **ppvObject);
typedef LRESULT (_stdcall *pfnCreateStdAccessibleObject)(HWND hwnd, LONG idObject, 
                                                    REFIID riid, void** ppvObject);
typedef LRESULT (_stdcall *pfnLresultFromObject)(REFIID riid, WPARAM wParam, 
                                                    LPUNKNOWN punk);

class COleaccProxy
{
public:
    COleaccProxy(void);
    virtual ~COleaccProxy(void);

private:
    static HMODULE m_hModule;
    static BOOL m_bFailed;
    
public:
    static void Init(void);
    static pfnAccessibleObjectFromWindow m_pfnAccessibleObjectFromWindow;
    static pfnCreateStdAccessibleObject m_pfnCreateStdAccessibleObject;
    static pfnLresultFromObject m_pfnLresultFromObject;
};




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
        m_hModule = ::LoadLibrary("oleacc.dll");
        if (!m_hModule)
        {
            m_bFailed = TRUE;
            return;
        }

        m_pfnAccessibleObjectFromWindow
             = (pfnAccessibleObjectFromWindow)::GetProcAddress(m_hModule, 
                                                          "AccessibleObjectFromWindow");
        m_pfnCreateStdAccessibleObject
             = (pfnCreateStdAccessibleObject)::GetProcAddress(m_hModule, 
                                                          "CreateStdAccessibleObject");
        m_pfnLresultFromObject = (pfnLresultFromObject)::GetProcAddress(m_hModule, 
                                                          "LresultFromObject");
    }
}
