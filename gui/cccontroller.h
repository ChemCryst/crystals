////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr
//   Modified:  30.3.1998 12:23 Uhr

#ifndef		__CcController_H__
#define		__CcController_H__

#include	"cclist.h"
#include	"cccommandqueue.h"
#include	"ccstatus.h"
#include    "ccrect.h"     // added by ClassView
#include    <stdio.h> //For FILE definition

class CcChartDoc;
class CcModelDoc;
class CrWindow; 
class CcTokenList;
class CxApp;
class CrGUIElement;
class CcQuickData;
class CcMenuItem;

class	CcController
{
	public:
		void GetValue (CcTokenList * tokenlist);
		void History(Boolean up);
		CcRect GetScreenArea();

		CcModelDoc* CreateModelDoc(CcString name);
		CcModelDoc* FindModelDoc(CcString name);

            void RemoveTextOutputPlace(CrGUIElement* output);
            void RemoveProgressOutputPlace(CrGUIElement* output);
            void RemoveInputPlace(CrGUIElement* input);
            void RemoveWindowFromList(CrWindow* window);

		CrGUIElement* GetTextOutputPlace();
            CrGUIElement* GetInputPlace();
		CrGUIElement* GetBaseTextOutputPlace();
		CrGUIElement* GetProgressOutputPlace();

		void SetTextOutputPlace(CrGUIElement* outputPane);
            void SetInputPlace(CrGUIElement* inputPane);
		void SetProgressOutputPlace(CrGUIElement* outputPane);

            void AddHistory( CcString theText );

		CcChartDoc* mCurrentChartDoc;
		CcModelDoc* mCurrentModelDoc;
		CcQuickData* mQuickData;
		Boolean mThisThreadisDead;
            Boolean m_Completing;

		CcStatus status;

		static CcController* theController;
//            static DWORD threadID;
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
            void  AddCrystalsCommand( CcString line , Boolean jumpQueue = false);
		Boolean	GetCrystalsCommand( char * line );
            void  AddInterfaceCommand( CcString line );
		Boolean	GetInterfaceCommand( char * line );
            Boolean     GetInterfaceCommand( CcString * line );
		void	LogError( CcString errString , int level);
            void  SetProgressText(CcString * theText);       
            void CompleteProcessing();
            void ProcessingComplete();

            void StoreKey( CcString key, CcString value );
            CcString GetKey( CcString key );

            int FindFreeMenuId();
            void AddMenuItem( CcMenuItem * menuitem );
            void RemoveMenuItem( CcMenuItem * menuitem );
            void RemoveMenuItem ( CcString menuitemname );
            CcMenuItem* FindMenuItem( int id );
            CcMenuItem* FindMenuItem( CcString name );

		// attributes
		
		CxApp *	mAppContext;
		CrWindow *	mCurrentWindow;
		CrGUIElement *	mInputWindow;
		CrGUIElement *	mTextWindow;
		CrGUIElement *	mProgressWindow;
            CcString m_newdir;
            Boolean m_restart;
            Boolean m_Wait;
                CcList  mGraphList;
                CcList  mChartList;

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
                CcList  mInputWindowList;
                CcList  mModelDocList;

                CcList  mMenuItemList;
                int     m_next_id_to_try;

		CcList mCommandHistoryList;
		int mCommandHistoryPosition;
		
		CcCommandQueue	mCrystalsCommandQueue;
		CcCommandQueue  mInterfaceCommandQueue;


};

#define kSSysOpenFile	   "SYSOPENFILE"
#define kSSysSaveFile	   "SYSSAVEFILE"
#define kSSysGetDir        "SYSGETDIR"
#define kSSysRestart       "RESTART"
#define kSRestartFile      "FILE"
#define	kSRedirectText	   "SENDTEXTTO"
#define	kSRedirectProgress "SENDPROGRESSTO"
#define kSRedirectInput    "GETINPUTFROM"
#define kSCreateWindow	   "WINDOW"
#define kSDisposeWindow	   "DISPOSE"
#define kSSet		   "SET"
#define kSRenameObject     "RENAME"
#define kSGetValue	   "GETVALUE"
#define	kSTitleOnly	   "TITLEONLY"
#define kSGetKeyValue      "GETKEY"
#define kSSetKeyValue      "SETKEY"

#define kSWindowSelector	"WI"
#define kSChartSelector		"CH"
#define kSOneCommand		"CO"
#define kSControlSelector	"CR"
#define kSModelSelector		"GR"
#define kSStatusSelector	"ST"
#define kSQuerySelector		"??"

#define kSFocus               "FOCUS"
#define kSFontIncrease        "INCFONTSIZE"

enum
{
 kTSysOpenFile = 400,
 kTSysSaveFile,	   
 kTSysGetDir,       
 kTSysRestart,       
 kTRestartFile,     
 kTRedirectText,	   
 kTRedirectProgress, 
 kTRedirectInput,    
 kTCreateWindow,	   
 kTDisposeWindow,	   
 kTSet,		   
 kTRenameObject,     
 kTGetValue,	   
 kTTitleOnly,	   
 kTWindowSelector,	
 kTChartSelector,		
 kTOneCommand,		
 kTControlSelector,	
 kTModelSelector,		
 kTStatusSelector,	
 kTQuerySelector,
 kTGetKeyValue,
 kTSetKeyValue,
 kTFocus,
 kTFontIncrease

};




#endif
