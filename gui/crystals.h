// crystals.h : main header file for the CRYSTALS application
//
// $Log: not supported by cvs2svn $
// Revision 1.15  2012/03/26 11:35:46  rich
// New command event for wx.
//
// Revision 1.14  2005/02/07 14:29:56  stefan
// 1. Removed the kick timer and idle functions as I don't believe they are needed anylonger.
// 2. Added my crystals command event/message handler
// 3. Added the id for the event handler
//
// Revision 1.13  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.1.1.1  2004/12/13 11:16:18  rich
// New CRYSTALS repository
//
// Revision 1.12  2003/01/14 10:27:18  rich
// Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
// Revision 1.11  2002/07/29 13:03:47  richard
// Proxy routines avoid loading the real OLEACC.DLL - this file isn't present
// on some older platforms (95/98/NT) unless Active Accessibility is installed.
// Since CRYSTALS uses no Active Accessibility features, this DLL is not required,
// but due to a bug in MFC70.DLL it is always loaded.
//
// Revision 1.10  2002/07/15 12:19:13  richard
// Reorder headers to improve ease of linking.
// Update program to use new standard C++ io libraries.
// Update to use new version of MFC (5.0 with .NET.)
//
// Revision 1.9  2001/03/27 15:15:00  richard
// Added a timer to the main window that is activated as the main window is
// created.
// The timer fires every half a second and causes any messages in the
// CRYSTALS message queue to be processed. This is not the main way that messages
// are found and processed, but sometimes the program just seemed to freeze and
// would stay that way until you moved the mouse. This should (and in fact, does
// seem to) remedy that problem.
// Good good good.
//
// Revision 1.8  2001/03/08 16:44:07  richard
// General changes - replaced common functions in all GUI classes by macros.
// Generally tidied up, added logs to top of all source files.
//
// Revision 1.7  2001/01/25 17:12:28  richard
// Changed from BOOL to bool!
//
// Revision 1.6  2001/01/16 15:35:00  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.5  2000/12/13 18:03:08  richard
// Linux(wxWindows) and Windows(wxWindows) support added.
//

#if !defined(AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_)
#define AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_

#ifdef CRY_USEMFC

  #if _MSC_VER >= 1000
    #pragma once
  #endif // _MSC_VER >= 1000

  #ifndef __AFXWIN_H__
    #error include 'stdafx.h' before including this file for PCH
  #endif

  #include "resource.h"       // main symbols

#else

  #include <wx/app.h>
  #include <wx/timer.h>

#endif

#include <string>

class CcController;

/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp:
// See gcrystals.cpp for the implementation of this class
//

#ifdef CRY_USEMFC
  #define WM_CRYSTALS_COMMAND (WM_USER + 1)

class CCrystalsApp : public CWinApp
{

#else

class CCrystalsApp : public wxApp
{

    wxLocale m_locale;
#endif

public:

//        bool CCrystalsApp::DoCommandTransferStuff();

#ifdef CRY_USEMFC
// Overrides
    public:

    CCrystalsApp();

    virtual BOOL InitInstance();
    virtual BOOL OnIdle(LONG lCount);
	virtual void OnCrystCommand(UINT wp, LONG p);
    virtual int ExitInstance();
    afx_msg LRESULT OnStuffToProcess(WPARAM wp, LPARAM lp);
    DECLARE_MESSAGE_MAP()

#else
//    wxTimer * kickTimer;

//    virtual void Activate(wxActivateEvent& event);
    virtual bool OnInit();
    virtual int OnExit();
    virtual int OnRun();
	virtual void OnCrystCommand(wxEvent & event);
    DECLARE_EVENT_TABLE()

#endif

    protected:
    CcController* theControl;
    
};

#ifdef CRY_USEMFC
   extern CCrystalsApp theApplication;
#else
   DECLARE_APP(CCrystalsApp)
#endif


#ifdef CRY_USEMFC

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

#endif


#endif // !defined(AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_)
