// crystals.h : main header file for the CRYSTALS application
//

#if !defined(AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_)
#define AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CCrystalsApp:
// See crystals.cpp for the implementation of this class
//
class CrApp;

class CCrystalsApp : public CWinApp
{
public:
	CCrystalsApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CCrystalsApp)
	public:
	virtual BOOL InitInstance();
	virtual BOOL OnIdle(LONG lCount);
	virtual int ExitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CCrystalsApp)
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
protected:
	CrApp* theCrApp;
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Developer Studio will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_CRYSTALS_H__DEE5F4C5_D4B0_11D1_B74B_0080C8372E35__INCLUDED_)
