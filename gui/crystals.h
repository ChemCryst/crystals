// crystals.h : main header file for the CRYSTALS application
//
// $Log: not supported by cvs2svn $
// Revision 1.5  2000/12/13 18:03:08  richard
// Linux(wxWindows) and Windows(wxWindows) support added.
//

#if !defined(AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_)
#define AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_

#ifdef __CR_WIN__

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
    #error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

#endif
#ifdef __BOTHWX__

#include <wx/app.h>
#include <wx/timer.h>

#endif


// #define WM_STUFFTOPROCESS ( WM_USER + 100 )

/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp:
// See gcrystals.cpp for the implementation of this class
//
class CrApp;

#ifdef __CR_WIN__
class CCrystalsApp : public CWinApp
{
#endif
#ifdef __BOTHWX__
class CCrystalsApp : public wxApp
{
#endif

public:

        BOOL CCrystalsApp::DoCommandTransferStuff();

#ifdef __CR_WIN__
// Overrides
    public:

    CCrystalsApp();
	virtual BOOL InitInstance();
    virtual BOOL OnIdle(LONG lCount);
    virtual int ExitInstance();

    DECLARE_MESSAGE_MAP()

#endif
#ifdef __BOTHWX__
    wxTimer * kickTimer;

    virtual bool OnInit();
    virtual int OnExit();
    virtual void OnIdle(wxIdleEvent & event);
    void OnKickTimer(wxTimerEvent & evt);

    
    DECLARE_EVENT_TABLE()

#endif

	protected:
    CrApp* theCrApp;
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_)
