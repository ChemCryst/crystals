////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrWindow

////////////////////////////////////////////////////////////////////////

//   Filename:  CrWindow.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:26 Uhr
//   Modified:  30.3.1998 12:11 Uhr

#ifndef		__CrWindow_H__
#define		__CrWindow_H__
#include	"crguielement.h"
//insert your own code here.
#include	"cctokenlist.h"
#include	"crgrid.h"
#include "ccstring.h"	// added by classview

class CxApp;
class CrMenu;
//End of user code.         
 
class	CrWindow : public CrGUIElement
{
	public:
		void SetCommandText(CcString theText);
		void SendCommand(CcString theText, Boolean jumpQueue = false);
		void SetCancelText(CcString text);
		void FocusToInput(char theChar);
		void SetCommitText( CcString text);
		void MenuSelected(int id);
		void SetMainMenu(CrMenu* menu);
		void CrFocus();

            int mSafeClose;
		int m_relativePosition;
            Boolean m_Keep;
		Boolean mIsSizeable;
		Boolean mIsModal;
		CrMenu* mMenuPtr;
            int mOrigHeight;
            int mOrigWidth;

// methods
            CrWindow( CxApp * mParentPtr );
            ~CrWindow();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
            void  SetOriginalSizes();
		void	ResizeWindow(int newWidth, int newHeight);
		void	SetText( CcString item );
		void	Show( Boolean show );
		void	Align();
		CrGUIElement *	FindObject( CcString Name );
		CrGUIElement *	GetRootWidget();
		void AddToTabGroup(CrGUIElement* tElement);
		void* GetPrevTabItem(void* pElement);
		void* GetNextTabItem(void* pElement);
		void* FindTabItem(void* pElement);
            void  SendMeSysKeys( CrGUIElement* interestedWindow );
//Callbacks
		void CloseWindow();
		void Committed();
		void Cancelled();

            void SysKeyPressed ( UINT nChar );
            void SysKeyReleased ( UINT nChar );

		// attributes
		CrGrid *	mGridPtr;
		CcList *	mTabGroup;
	
		static CcList mModalWindowStack;
            CcList mWindowsWantingSysKeys;

private:
	CrGUIElement* m_relativeWinPtr;
	Boolean mCommitSet;
	Boolean mCancelSet;
	Boolean mCommandSet;
	CcString mCommitText;
	CcString mCancelText;
	CcString mCommandText;
};

#define kSCreateModelDoc	"MODEL"
#define kSCreateChartDoc	"CHART"
#define kSShowWindow		"SHOW"
#define kSHideWindow		"HIDE"
#define kSDefineMenu		"DEFINEMENU"
#define kSModal			"MODAL"
#define kSZoom			"ZOOM"
#define kSSize			"SIZE"
#define kSClose			"CLOSE"
#define kSPosition	"POSITION"
#define kSRightOf	"RIGHTOF"
#define kSLeftOf	"LEFTOF"
#define kSAbove		"ABOVE"
#define kSBelow		"BELOW"
#define kSCascade	"CASCADE"
#define kSCentred	"CENTRED"
#define kSKeep                "KEEP"

enum
{
 kTCreateModelDoc = 1600,
 kTCreateChartDoc,
 kTShowWindow,	
 kTHideWindow,	
 kTDefineMenu,	
 kTModal,	
 kTZoom,		
 kTSize,		
 kTClose,	
 kTPosition,	
 kTRightOf,	
 kTLeftOf,	
 kTAbove,	
 kTBelow,	
 kTCascade,	
 kTCentred,	
 kTKeep         
};


#endif
