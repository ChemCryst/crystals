////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr
//   Modified:  30.3.1998 12:23 Uhr

#ifndef		__CcController_H__
#define		__CcController_H__
//Insert your own code here.
#include	"CcList.h"
#include	"CcCommandQueue.h"
#include	"CcStatus.h"
#include "CcRect.h"	// Added by ClassView
//End of user code.         
class CcChartDoc;
class CcModelDoc;
class CrWindow; 
class CcTokenList;
class CxApp;
class CrGUIElement;
class CcQuickData;

class	CcController
{
	public:
		void GetValue (CcTokenList * tokenlist);
		void OutputToScreen(CcString text);
		void History(Boolean up);
		CcRect GetScreenArea();
		CcModelDoc* CreateModelDoc(CcString name);
		CcModelDoc* FindModelDoc(CcString name);
		void RemoveTextOutputPlace();
		void RemoveProgressOutputPlace();
		CrGUIElement* GetTextOutputPlace();
		CrGUIElement* GetBaseTextOutputPlace();
		void SetTextOutputPlace(CrGUIElement* outputPane);
		CrGUIElement* GetProgressOutputPlace();
		void SetProgressOutputPlace(CrGUIElement* outputPane);
		CcChartDoc* mCurrentChartDoc;
		CcModelDoc* mCurrentModelDoc;
		CcQuickData* mQuickData;
		Boolean mThisThreadisDead;

		CcStatus status;

		static CcController* theController;
		void FocusToInput(char theChar);
		CrGUIElement* FindObject( CcString Name );
		// methods
			CcController( CxApp * appContext );
			~CcController();
		Boolean	ParseInput( CcTokenList * tokenList );
		Boolean	ParseLine( char * text );
		void	SendCommand( CcString command , Boolean jumpQueue = false);
		void	Tokenize( char * text );
		Boolean	IsSpace( char c );
		Boolean	IsDelimiter( char c );
		void	AppendToken( char * text, int start, int stop );
		void	AddCrystalsCommand( char * line , Boolean jumpQueue = false);
		Boolean	GetCrystalsCommand( char * line );
		void	AddInterfaceCommand( char * line );
		Boolean	GetInterfaceCommand( char * line );
		void	LogError( CcString errString , int level);
		
		CxApp *	mAppContext;
		CrWindow *	mCurrentWindow;
		CrGUIElement *	mInputWindow;
		CrGUIElement *	mTextWindow;
		CrGUIElement *	mProgressWindow;
		// attributes
		
	protected:
		// methods
		
		// attributes
		CcTokenList *	mQuickTokenList;
		CcTokenList *	mWindowTokenList;
		CcTokenList *	mChartTokenList;
		CcTokenList *	mModelTokenList;
		CcTokenList *	mStatusTokenList;

		CcTokenList *	mTempTokenList;
		CcTokenList *	mCurTokenList;

		CrWindow *	mModelWindow;
		FILE *	mErrorLog;

		CcList	mWindowList;
		CcList  mTextOutputWindowList;
		CcList  mProgressOutputWindowList;
		CcList  mModelDocList;

		CcList mCommandHistoryList;
		int mCommandHistoryPosition;
		
		CcCommandQueue	mCrystalsCommandQueue;
		CcCommandQueue  mInterfaceCommandQueue;

};
#endif
