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
		int m_relativePosition;
		void SetCommandText(CcString theText);
		void SendCommand(CcString theText, Boolean jumpQueue = false);
		void SetCancelText(CcString text);
		void SetCommitText( CcString text);
		void FocusToInput(char theChar);
		Boolean mIsSizeable;
		Boolean mIsModal;
                Boolean mSetSize;
		void MenuSelected(int id);
		CrMenu* mMenuPtr;
		void SetMainMenu(CrMenu* menu);
		void CrFocus();
		// methods
			CrWindow( CxApp * mParentPtr );
			~CrWindow();
//		void *	GetWidget();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
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

		// attributes
		CrGrid *	mGridPtr;
		CcList *	mTabGroup;
	
		int mMinHeight;
		int mMinWidth;

		static CcList mModalWindowStack;
            CrGUIElement* mWindowWantingSysKeys;

private:
	CrGUIElement* m_relativeWinPtr;
	Boolean mCommitSet;
	Boolean mCancelSet;
	Boolean mCommandSet;
	CcString mCommitText;
	CcString mCancelText;
	CcString mCommandText;
};
#endif
