// crystals.h : main header file for the CRYSTALS application
//
// $Log: not supported by cvs2svn $
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

class CcController;

/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp:
// See gcrystals.cpp for the implementation of this class
//

#ifdef __CR_WIN__
class CCrystalsApp : public CWinApp
{
#endif
#ifdef __BOTHWX__
class CCrystalsApp : public wxApp
{
#endif

public:

        bool CCrystalsApp::DoCommandTransferStuff();

#ifdef __CR_WIN__
// Overrides
    public:

    CCrystalsApp();
    virtual BOOL InitInstance();
    virtual BOOL OnIdle(LONG lCount);
    virtual int ExitInstance();
    afx_msg LRESULT OnStuffToProcess(WPARAM wp, LPARAM lp);
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
    CcController* theControl;
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_)
