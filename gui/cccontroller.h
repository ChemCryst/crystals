////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.27  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.26  2002/07/19 08:08:17  richard
//   Remove backwards incompatibilty of new std C++ library.
//
//   Revision 1.25  2002/07/18 16:57:52  richard
//   Upgrade to use standard c++ library, rather than old C libraries.
//
//   Revision 1.24  2002/03/16 18:08:23  richard
//   Removed old CrGraph class (now obsolete given Steven's work).
//   Removed remains of "quickdata" interface (now obsolete, replaced by FASTPOLY etc.)
//
//   Revision 1.23  2002/03/13 12:30:25  richard
//   Speed up search for ^^ symbols.
//   Introduce new ^^ command: ^^CW - like ^^CR it causes execution of anything
//   built up in the current list of commands, but it also forces the CRYSTALS thread
//   to wait until the execution is complete.
//   Added function to OpenDirDialog to get the last structure directory used out
//   of the ini file.
//
//   Revision 1.22  2001/10/10 12:44:49  ckp2
//   The PLOT classes!
//
//   Revision 1.21  2001/07/16 07:21:42  ckp2
//   New Completing() function to check if CRYSTALS has requested an immediate answer
//   to a query (^^?? format).
//
//   Revision 1.20  2001/06/17 15:30:06  richard
//   ScriptsExited function loops through window list and closes any MODAL windows
//   without the STAYOPEN attribute. (Prevents that problem where scripts crash
//   and leave a window open blocking the input.)
//
//   Revision 1.19  2001/03/27 15:14:59  richard
//   Added a timer to the main window that is activated as the main window is
//   created.
//   The timer fires every half a second and causes any messages in the
//   CRYSTALS message queue to be processed. This is not the main way that messages
//   are found and processed, but sometimes the program just seemed to freeze and
//   would stay that way until you moved the mouse. This should (and in fact, does
//   seem to) remedy that problem.
//   Good good good.
//
//   Revision 1.18  2001/03/08 16:44:03  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//
//   Revision 1.17  2001/03/08 14:57:19  richard
//   Moved all CXAPP and CRAPP functions into this class, to try to make the
//   whole thing more understandable. This one class has one instance, and it
//   holds all the information about the windows which are open. It also recieves
//   the commands from CRYSTALS and messages from the GUI.
//   Also some new classes for updating the toolbar, and buttons, and windows based on the old ENABLEIF, DISABLEIF status flags.
//   Layout code majorly overhauled.
//

#ifndef     __CcController_H__
#define     __CcController_H__

#include    "cclist.h"
#include    "cccommandqueue.h"
#include    "ccstatus.h"
#include    "ccrect.h"
#include    "crystals.h"
#include    <cstdio> //For FILE definition


#ifdef __CR_WIN__
#include <afxwin.h>
#endif

#ifdef __BOTHWX__
#include <wx/thread.h>
#include <wx/app.h>
#include "crystals.h"
#include "ccthread.h"
#endif


class CcPlotData;
class CcChartDoc;
class CcModelDoc;
class CrWindow;
class CcTokenList;
class CrGUIElement;
class CcMenuItem;
class CcTool;
class CrButton;

class   CcController
{
  public:
    CcController( CcString directory, CcString dscfile );
    ~CcController();

    void GetValue (CcTokenList * tokenlist);

    CcRect GetScreenArea();

    CcModelDoc* CreateModelDoc(CcString name);
    CcModelDoc* FindModelDoc(CcString name);

    int FindFreeMenuId();
    void AddMenuItem( CcMenuItem * menuitem );
    void RemoveMenuItem( CcMenuItem * menuitem );
    void RemoveMenuItem ( CcString menuitemname );
    CcMenuItem* FindMenuItem( int id );
    CcMenuItem* FindMenuItem( CcString name );

    int FindFreeToolId();
    void AddTool( CcTool * tool );
    void RemoveTool( CcTool * tool );
    void RemoveTool ( CcString toolname );
    CcTool* FindTool( int id );
    CcTool* FindTool( CcString name );

    void AddDisableableWindow( CrWindow * aWindow );
    void RemoveDisableableWindow ( CrWindow * aWindow );

    void AddDisableableButton( CrButton * aButton );
    void RemoveDisableableButton ( CrButton * aButton );


    CrGUIElement* GetTextOutputPlace();
    CrGUIElement* GetBaseTextOutputPlace();
    void SetTextOutputPlace(CrGUIElement* outputPane);
    void RemoveTextOutputPlace(CrGUIElement* output);

    CrGUIElement* GetProgressOutputPlace();
    void RemoveProgressOutputPlace(CrGUIElement* output);
    void SetProgressOutputPlace(CrGUIElement* outputPane);
    void SetProgressText(CcString * theText);

    CrGUIElement* GetInputPlace();
    void RemoveInputPlace(CrGUIElement* input);
    void SetInputPlace(CrGUIElement* inputPane);

    void RemoveWindowFromList(CrWindow* window);

    CrGUIElement* FindObject( CcString Name );

    void AddHistory( CcString theText );

    void ReLayout();
    void History(Boolean up);
    void FocusToInput(char theChar);

    Boolean ParseInput( CcTokenList * tokenList );
    Boolean ParseLine( CcString text );
    void    SendCommand( CcString command , Boolean jumpQueue = false);
    void    Tokenize( CcString text );
    Boolean IsSpace( char c );
    Boolean IsDelimiter( char c );
    void  AppendToken( CcString text );

    void  AddCrystalsCommand( CcString line , Boolean jumpQueue = false);
    Boolean GetCrystalsCommand( char * line );
    void  AddInterfaceCommand( CcString line );
    Boolean GetInterfaceCommand( char * line );
//    Boolean GetInterfaceCommand( CcString * line );

    void LogError( CcString errString , int level);

    bool Completing();
    void CompleteProcessing();
    void ProcessingComplete();

    void UpdateToolBars();
    void ScriptsExited();

    void StoreKey( CcString key, CcString value );
    CcString GetKey( CcString key );


    void OpenFileDialog(CcString* filename, CcString extensionFilter, CcString extensionDescription, Boolean titleOnly);
    void SaveFileDialog(CcString* filename, CcString defaultName, CcString extensionFilter, CcString extensionDescription);
    void OpenDirDialog(CcString* result);
    void ChooseFont();

    void StartCrystalsThread();
    void  ProcessOutput(CcString theLine);

    void     ChangeDir (CcString newDir);

    int      EnvVarCount( CcString dir );
    CcString EnvVarExtract ( CcString dir, int i );

    void TimerFired();
    bool DoCommandTransferStuff();

// attributes

    CcChartDoc* mCurrentChartDoc;
    Boolean mThisThreadisDead;
    Boolean m_Completing;
    CcStatus status;

    static CcController* theController;
    static int debugIndent;

    CrWindow *      mCurrentWindow;
    CrGUIElement *  mInputWindow;
    CrGUIElement *  mTextWindow;
    CrGUIElement *  mProgressWindow;
    CcString m_newdir;
    Boolean m_restart;
    Boolean m_Wait;
    CcList  mChartList;

#ifdef __CR_WIN__
    static CWinThread *mCrystalsThread;
    static CWinThread *mGUIThread;
    static CFont* mp_font;
    static CFont* mp_inputfont;
#endif
#ifdef __BOTHWX__
    static CcThread *mCrystalsThread;
    static wxFont* mp_inputfont;
#endif



  protected:
    CcTokenList *   mQuickTokenList;
    CcTokenList *   mWindowTokenList;
    CcTokenList *   mPlotTokenList;
    CcTokenList *   mChartTokenList;
    CcTokenList *   mModelTokenList;
    CcTokenList *   mStatusTokenList;
    CcTokenList *   mTempTokenList;
    CcTokenList *   mCurTokenList;

    CrWindow *      mModelWindow;
    FILE *  mErrorLog;

    CcList  mWindowList;
    CcList  mTextOutputWindowList;
    CcList  mProgressOutputWindowList;
    CcList  mInputWindowList;

    CcList  mMenuItemList;
    int     m_next_id_to_try;

    CcList  mToolList;
    int     m_next_tool_id_to_try;

    CcList  mDisableableWindowsList;
    CcList  mDisableableButtonsList;

    CcList mCommandHistoryList;
    int mCommandHistoryPosition;

    CcCommandQueue  mCrystalsCommandQueue;
    CcCommandQueue  mInterfaceCommandQueue;
};


extern "C" {

  // new style API for FORTRAN
  // FORCALL() macro adds on _ to end of word for linux version.

  void  ciflushbuffer  (    long *theLength,    char * theLine  );
  void  endthread      (  long theExitcode                  );

  void  FORCALL(cinextcommand)  (    long *theStatus,    char theLine[80]);
  void  FORCALL(ciendthread)    (  long theExitcode                  );
  void  FORCALL(newdata)        (    int isize,      int* id         );
  void  FORCALL(datain)         ( int id, int *data, int offset, int nwords );
  void  FORCALL(callccode)      (  char *theLine                     );
  void  FORCALL(guexec)         (  char *theLine                     );

  void crystals( void );

}




#define kSSysOpenFile      "SYSOPENFILE"
#define kSSysSaveFile      "SYSSAVEFILE"
#define kSSysGetDir        "SYSGETDIR"
#define kSSysRestart       "RESTART"
#define kSRestartFile      "NEWFILE"
#define kSRedirectText     "SENDTEXTTO"
#define kSRedirectProgress "SENDPROGRESSTO"
#define kSRedirectInput    "GETINPUTFROM"
#define kSCreateWindow     "WINDOW"
#define kSDisposeWindow    "DISPOSE"
#define kSSet          "SET"
#define kSRenameObject     "RENAME"
#define kSGetValue     "GETVALUE"
#define kSTitleOnly    "TITLEONLY"
#define kSGetKeyValue      "GETKEY"
#define kSSetKeyValue      "SETKEY"

#define kSWindowSelector    "WI"
#define kSChartSelector     "CH"
#define kSPlotSelector      "PL"
#define kSOneCommand        "CO"
#define kSControlSelector   "CR"
#define kSModelSelector     "GR"
#define kSStatusSelector    "ST"
#define kSQuerySelector     "??"
#define kSWaitControlSelector "CW"

#define kSFocus               "FOCUS"
#define kSFontSet             "FONT"

#define kSSafeSet             "SAFESET"
#define kSOpenGroup           "["
#define kSCloseGroup           "]"

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
 kTGetKeyValue,
 kTSetKeyValue,
 kTFocus,
 kTFontSet,
 kTSafeSet,
 kTOpenGroup,
 kTCloseGroup
};




#endif
