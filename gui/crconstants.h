////////////////////////////////////////////////////////////////////////

//   Filename:  CrConstants.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.7.1998 10:41 Uhr

// $Log: not supported by cvs2svn $
// Revision 1.18  2002/09/27 14:51:36  rich
// Move definition of ATTACH token into crconstants.
//
// Revision 1.17  2002/07/25 16:00:13  richard
//
// Resize dropdown listbox if number of items changes.
//
// Revision 1.16  2002/03/16 18:08:23  richard
// Removed old CrGraph class (now obsolete given Steven's work).
// Removed remains of "quickdata" interface (now obsolete, replaced by FASTPOLY etc.)
//
// Revision 1.15  2002/02/19 16:34:52  ckp2
// Menus for plots.
//
// Revision 1.14  2001/10/10 12:44:50  ckp2
// The PLOT classes!
//
// Revision 1.13  2001/03/08 15:31:50  richard
// Moved some token definitions here so that they can be shared between classes.
//
// Revision 1.12  2000/09/28 17:17:17  ckp2
// New constant for DISABLING atoms
//
// Revision 1.11  2000/09/20 12:53:03  ckp2
// Moved kS and kTEmpty defs into here, as they are also used by TEXTOUT
//
// Revision 1.10  1999/06/13 14:33:46  dosuser
// RIC: All tokens which are specific to a single GUI object have been
// moved into the header file for that object. All that is left are the
// shared tokens e.g. YES, NO, NULL, ALL etc.
//
// Revision 1.9  1999/06/03 17:38:34  dosuser
// RIC: Added support for ICON guielement. You can say e.g.
// @ 1,2 ICON IC QUERY
// and you will get a question mark icon at that point in the grid.
// Options other than QUERY are: WARN, ERROR, INFO
//
// Revision 1.8  1999/05/28 17:53:11  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.7  1999/05/13 17:53:06  dosuser
// RIC: Added kSSysRestart=RESTART and kSRestartFile=FILE
//
// Revision 1.6  1999/05/11 16:15:27  dosuser
// RIC: Added token SYSGETDIR and supporting functions for getting a
//      directory from the user via a common dialog.
//
// Revision 1.5  1999/05/07 16:02:29  dosuser
// RIC: Added GetCursorKeys tokens.
//
// Revision 1.4  1999/04/28 13:57:29  dosuser
// RIC: Added kS/kTSpew for multiedit.
//      Added kS/kTThermal for cx / cr model as a new 'size' option.
//
// Revision 1.3  1999/04/26 12:19:44  dosuser
// RIC: Added kT/kSSetSelection for CrListBox to use.
//

#ifndef     __CrConstants_H__
#define     __CrConstants_H__

// General purpose
#define kSAttachModel       "ATTACH"
#define kSState     "STATE"
#define kSOn        "ON"
#define kSOff       "OFF"
#define kSEndDefineMenu "ENDDEFINEMENU"
#define kSSetCommitText "COMMIT"
#define kSSetCancelText "CANCEL"
#define kSSelectAtoms   "SELECT"
#define kSDisableAtoms  "DISABLEATOM"
#define kSInvert    "INVERT"
#define kSInform    "INFORM"
#define kSIgnore    "IGNORE"
#define kSDisabled  "DISABLED"
#define kSChars     "CHARS"
#define kSSetCommandText    "COMMAND"
#define kSAddToList "ADDTOLIST"
#define kSSetSelection  "SELECTION"
#define kSNumberOfColumns   "NCOLS"
#define kSNumberOfRows  "NROWS"
#define kSVisibleLines  "VISLINES"
#define kSAlign     "ALIGN"
#define kSTextSelector  "TEXT"
#define kSNull      "NULL"
#define kSYes       "YES"
#define kSNo        "NO"
#define kSAll       "ALL"
#define kSRow       "ROW"
#define kSColumn    "COL"
#define kSCreateGrid            "GRID"
#define kSEmpty                "EMPTY"
#define kSMenuDisableCondition  "DISABLEIF"
#define kSMenuEnableCondition   "ENABLEIF"
#define kSMenuSplit     "SPLIT"
#define kSItem          "ITEM"
#define kSEndGrid             "}"
#define kSOpenGrid            "{"
#define kSRemove   "REMOVE"


// Query types:
#define kSQExists   "EXISTS"
#define kSQListtext "LISTTEXT"
#define kSQText     "TEXT"
#define kSQListrow  "LISTROW"
#define kSQListitem "LISTITEM"
#define kSQNselected    "NSELECTED"
#define kSQSelected "SELECTED"
#define kSQState    "STATE"
#define kSHorizontal  "HORIZONTAL"
#define kSVertical    "VERTICAL"
#define kSBoth    "BOTH"
#define kSDefinePopupMenu   "DEFINEPOPUPMENU"

#define kSSave   "EDITSAVE"



enum
{
 kTState = 200,
 kTOn,
 kTOff,
 kTEndDefineMenu,
 kTSetCommitText,
 kTSetCancelText,
 kTSelectAtoms,
 kTDisableAtoms,
 kTInvert,
 kTInform,
 kTIgnore,
 kTDisabled,
 kTChars,
 kTSetCommandText,
 kTAddToList,
 kTSetSelection,
 kTNumberOfColumns,
 kTNumberOfRows,
 kTVisibleLines,
 kTAlign,
 kTTextSelector,
 kTNull,
 kTYes,
 kTNo,
 kTAll,
 kTRow,
 kTColumn,
 kTQExists,
 kTQListtext,
 kTQText,
 kTQListrow,
 kTQListitem,
 kTQNselected,
 kTQSelected,
 kTQState,
 kTCreateGrid,
 kTEmpty,
 kTMenuDisableCondition,
 kTMenuEnableCondition,
 kTMenuSplit,
 kTItem,
 kTEndGrid,
 kTOpenGrid,
 kTHorizontal,
 kTVertical,
 kTBoth,
 kTDefinePopupMenu,
 kTRemove,
 kTAttachModel,
 kTSave
};




enum {
    kLogicalClass   =   1,
    kInstructionClass,
    kAttributeClass,
    kPositionClass,
    kChartClass,
    kModelClass,
    kStatusClass,
    kPositionalClass,
    kQueryClass,
    kPlotClass
};


enum
{
 kTUnknown = 0,
 kTNoMoreToken
};

#endif
