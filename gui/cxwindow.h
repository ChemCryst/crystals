////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWindow.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 16:45 Uhr

#ifndef		__CxWindow_H__
#define		__CxWindow_H__
//Insert your own code here.
#include	"crguielement.h"
#include	"crwindow.h"
#include	"cxbutton.h"

#ifdef __POWERPC__
#include	<LWindow.h>
#include	<LTabGroup.h>
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#endif

//End of user code.         
class CxMenu; 
//class	CxWindow : public CDialog
class	CxWindow : public CFrameWnd
//class	CxWindow : public CWnd
{
	public:
		void AdjustSize( CcRect * clientSize );
		void OnMenuSelected(int nID);
		void SetMainMenu(CxMenu* menu);
		void Focus();
		void Hide();
		// methods
		static CxWindow *	CreateCxWindow( CrWindow * container, void * parentWindow, int attributes );
			CxWindow( CrWindow * container, int sizeable );
		virtual	~CxWindow();
		void	SetText( char * text );
		void	CxShowWindow();
		void	SetGeometry( int top, int left, int bottom, int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
//		LTabGroup *	GetTabCommander();
//		Boolean	HandleKeyPress( const EventRecord	&inKeyEvent );
		void	SetDefaultButton( CxButton * inButton );
		// attributes
		CrGUIElement *	mWidget;
//		LTabGroup	* mTabGroup;
		CxButton * mDefaultButton;

//PRIVATE MS WINDOWS SPECIFIC FUNCTIONS AND OVERRIDES

//Overrides
/*	void OnOK();
	void OnCancel();
	CWnd* GetNextDlgTabItem(CWnd* pWndCtl, BOOL bPrevious = FALSE) const;
*/
	BOOL PreCreateWindow(CREATESTRUCT& cs);
//Message handlers
	afx_msg void OnClose();
	afx_msg void OnSize(UINT nType, int cx, int cy);
	afx_msg void OnGetMinMaxInfo(MINMAXINFO FAR* lpMMI);
	afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnUpdateMenuItem(CCmdUI* pCmdUI);
	afx_msg LRESULT OnMyNcPaint(WPARAM wparam, LPARAM lparam);


	DECLARE_MESSAGE_MAP()
private:
	Boolean mSizeable;
	static int mWindowCount;
protected:
	CWnd* mParentWnd;
	Boolean mProgramResizing;
};
#endif
