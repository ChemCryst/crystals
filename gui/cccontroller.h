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
#include	"cclist.h"
#include	"cccommandqueue.h"
#include	"ccstatus.h"
#include "ccrect.h"	// added by ClassView
#include <stdio.h> //For FILE definition
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
            Boolean m_Completing;

		CcStatus status;

		static CcController* theController;
		void FocusToInput(char theChar);
		CrGUIElement* FindObject( CcString Name );
		// methods
			CcController( CxApp * appContext );
			~CcController();
		Boolean	ParseInput( CcTokenList * tokenList );
            Boolean     ParseLine( CcString text );
		void	SendCommand( CcString command , Boolean jumpQueue = false);
		void	Tokenize( char * text );
		Boolean	IsSpace( char c );
		Boolean	IsDelimiter( char c );
            void  AppendToken( CcString text );
		void	AddCrystalsCommand( char * line , Boolean jumpQueue = false);
		Boolean	GetCrystalsCommand( char * line );
		void	AddInterfaceCommand( char * line );
		Boolean	GetInterfaceCommand( char * line );
            Boolean     GetInterfaceCommand( CcString * line );
		void	LogError( CcString errString , int level);
            void  SetProgressText(CcString theText);       
            void CompleteProcessing();
            void ProcessingComplete();

		// attributes
		
		CxApp *	mAppContext;
		CrWindow *	mCurrentWindow;
		CrGUIElement *	mInputWindow;
		CrGUIElement *	mTextWindow;
		CrGUIElement *	mProgressWindow;
            CcString m_newdir;
            Boolean m_restart;

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
