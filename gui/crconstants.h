////////////////////////////////////////////////////////////////////////

//   Filename:  CrConstants.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.7.1998 10:41 Uhr
//   Modified:  22.7.1998 10:41 Uhr

// $Log: not supported by cvs2svn $
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

#ifndef		__CrConstants_H__
#define		__CrConstants_H__


#define kSAt				"@"
#define	kSCreateButton		"BUTTON"
#define kSCreateWindow		"WINDOW"
#define kSSysOpenFile		"SYSOPENFILE"
#define kSSysSaveFile		"SYSSAVEFILE"
#define kSSysGetDir         "SYSGETDIR"
#define kSSysRestart         "RESTART"
#define kSRestartFile         "FILE"
#define	kSRedirectText		"SENDTEXTTO"
#define	kSRedirectProgress		"SENDPROGRESSTO"
#define kSCreateListBox		"LISTBOX"
#define kSCreateListCtrl	"LISTCTRL"
#define kSCreateDropDown	"DROPDOWN"
#define kSCreateEditBox		"EDITBOX"
#define kSCreateGrid          "GRID"
#define kSCreateMultiEdit	"MULTIEDIT"
#define kSCreateText		"STATIC"
#define kSCreateProgress	"PROGRESS"
#define kSCreateRadioButton	"RADIOBUTTON"
#define kSCreateCheckBox	"CHECKBOX"
#define kSCreateChart		"CHARTWINDOW"
#define kSCreateModel		"MODELWINDOW"
#define kSShowWindow		"SHOW"
#define kSHideWindow		"HIDE"
#define kSDisposeWindow		"DISPOSE"
#define kSEndGrid             "}"
#define kSOpenGrid            "{"
#define kSSet				"SET"
#define kSGetValue			"GETVALUE"
#define kSSendValue			"SENDVALUE"
#define kSState				"STATE"
#define kSOn				"ON"
#define kSOff				"OFF"
#define kSTextColour		"TEXTCOLOUR"
#define kSTextBold			"TEXTBOLD"
#define kSTextItalic		"TEXTITALIC"
#define kSTextUnderline		"TEXTUNDERLINE"
#define kSTextFixedFont		"FIXEDFONT"
#define kSBackLine			"BACKLINE"
#define kSNoEcho			"NOECHO"
#define kSMenu				"MENU"
#define kSEndMenu			"ENDMENU"
#define kSMenuItem			"ITEM"
#define kSMenuSplit			"SPLIT"
#define kSDefineMenu		"DEFINEMENU"
#define kSDefinePopupMenu	"DEFINEPOPUPMENU"
#define kSEndDefineMenu		"ENDDEFINEMENU"
#define	kSMenuDisableCondition	"DISABLEIF"
#define	kSMenuEnableCondition	"ENABLEIF"
#define	kSTitleOnly			"TITLEONLY"
#define kSCreateChartDoc	"CHART"
#define kSChartAttach		"ATTACH"
#define kSChartShow		    "SHOW"
#define kSChartLine			"LINE"
#define kSChartEllipseE		"ELLIE"
#define kSChartEllipseF		"ELLIF"
#define kSChartClear		"CLEAR"
#define	kSChartPolyF		"POLYF"
#define	kSChartPolyE		"POLYE"
#define	kSChartFastPolyF	"FPOLYF"
#define	kSChartFastPolyE	"FPOLYE"
#define kSGraph				"GRAPH"
#define	kSChartText			"TEXT"
#define kSChartColour		"RGB"
#define kSChartFlow			"FLOW"
#define kSChartChoice		"CHOICE"
#define kSChartLink			"LINK"
#define kSChartAction		"ACTION"
#define kSChartN			"N"
#define kSChartS			"S"
#define kSChartE			"E"
#define kSChartW			"W"
#define kSChartHighlight	"HIGHLIGHT"
#define kSSpew                "SPEW"

#define kSWantReturn		"SENDONRETURN"
#define kSIntegerInput		"INTEGER"
#define kSRealInput			"REAL"
#define kSNoInput			"READONLY"
#define kSSetCommitText		"COMMIT"
#define kSSetCancelText		"CANCEL"
#define kSAttachModel		"ATTACH"
#define kSModelShow			"SHOW"
#define kSModelBond			"BOND"
#define kSModelAtom			"ATOM"
#define kSModelCell			"CELL"
#define kSModelTri			"FTRI"
#define kSCreateModelDoc	"MODEL"
#define kSModelClear		"CLEAR"
#define kSSelectAtoms		"SELECT"
#define kSInvert			"INVERT"
#define kSGetItem			"GETITEM"

// Attributes
#define kSDefault			"DEFAULT"
#define kSInform			"INFORM"
#define kSIgnore			"IGNORE"
#define kSOutline			"OUTLINE"
#define	kSDisabled			"DISABLED"
#define kSAlignExpand		"EXPAND"
#define kSAlignRight		"RIGHT"
#define kSAlignBottom		"BOTTOM"
#define kSModal				"MODAL"
#define kSZoom				"ZOOM"
#define kSSize				"SIZE"
#define kSClose				"CLOSE"
#define kSChars				"CHARS"
#define kSComplete			"COMPLETE"
#define kSWidth				"WIDTH"
#define kSAppend			"APPEND"
#define kSGetPolygonArea	"GETAREA"
#define kSGetCursorKeys       "CURSORKEYS"
#define kSIsoView			"ISO"
#define kSNoEdge			"NOEDGE"
#define	kSRadiusType		"RADTYPE"
#define	kSRadiusScale		"RADSCALE"
#define	kSVDW				"VDW"
#define     kSThermal               "THERMAL"
#define	kSCovalent			"COV"
#define kSSelectAction		"MOUSEACTION"
#define kSSendLine			"SENDLINE"
#define kSSendIndex			"SENDINDEX"
#define kSGetAction			"GETFORMAT"
#define kSSelect			"SELECTATOM"
#define kSAppendTo			"APPENDATOM"
#define kSSendA				"SENDATOM"
#define kSSendB				"SPLITATOM"
#define kSSendC				"HEADERATOM"
#define kSSendD				"HEADERSPLITATOM"
#define kSSendCAndSelect	"SENDANDSELECT"
#define kSSetCommandText	"COMMAND"
#define kSSetStatus			"STATSET"
#define kSUnSetStatus		"STATUNSET"
#define kSAddToList			"ADDTOLIST"
#define kSCheckValue		"CHECKVALUE"
#define kSSetSelection        "SELECTION"

#define kSPosition			"POSITION"
#define kSRightOf			"RIGHTOF"
#define kSLeftOf			"LEFTOF"
#define kSAbove				"ABOVE"
#define kSBelow				"BELOW"
#define kSCascade			"CASCADE"
#define kSCentred			"CENTRED"


// Row selectors
#define kSNumberOfColumns	"NCOLS"
#define kSNumberOfRows		"NROWS"

// Attribute selectors
#define kSCallback			"CALLBACK"
#define kSVisibleLines		"VISLINES"
#define kSAlign				"ALIGN"
#define	kSTextSelector		"TEXT"
#define kSNull				"NULL"

#define	kSYes				"YES"
#define	kSNo				"NO"
#define kSAll				"ALL"

#define	kSRow				"ROW"
#define	kSColumn			"COL"

//Graph keywords
#define kSVerticalBar		"VBAR"
#define kSHorizontalBar		"HBAR"
#define kSDataByLabel		"DATABYLABEL"
#define kSDataBySeries		"DATABYSERIES"
#define kSNSeries			"NSERIES"
#define kSData				"DATA"
#define kSAxisScale			"YSCALE"
#define kSLinear			"LINEAR"
#define kSLog				"LOG"
#define kSExp				"EXP"


#define kSQExists			"EXISTS"
#define kSQListtext			"LISTTEXT"
#define kSQText				"TEXT"
#define kSQListrow			"LISTROW"
#define kSQListitem			"LISTITEM"
#define kSQNselected		"NSELECTED"
#define kSQSelected			"SELECTED"
#define kSQState			"STATE"


//Command types
#define kSWindowSelector	"WI"
#define kSChartSelector		"CH"
#define kSOneCommand		"CO"
#define kSControlSelector	"CR"
#define kSModelSelector		"GR"
#define kSStatusSelector	"ST"
#define kSQuerySelector		"??"

enum {
	kTCreateButton	= 100,
	kTCreateWindow,
	kTCreateListCtrl,
      kTSysGetDir,
      kTSysRestart,
      kTRestartFile,
	kTSysOpenFile,
	kTSysSaveFile,
	kTRedirectText,
	kTRedirectProgress,
	kTCreateListBox,
	kTCreateDropDown,
	kTCreateEditBox,
	kTCreateGrid,
	kTCreateMultiEdit,
	kTCreateText,
	kTCreateProgress,
	kTCreateRadioButton,
	kTCreateCheckBox,
	kTCreateChart,
	kTCreateModel,
	kTShowWindow,
	kTHideWindow,
	kTDisposeWindow,
	kTEndGrid,
	kTSet,
	kTGetValue,
	kTNoMoreToken,
	kTTextColour,
	kTTextBold,
	kTTextItalic,
	kTTextUnderline,
	kTTextFixedFont,
	kTBackLine,
	kTNoEcho,
	kTMenu,
	kTEndMenu,
	kTMenuItem,
	kTMenuSplit,
	kTDefineMenu,
	kTDefinePopupMenu,
	kTEndDefineMenu,
	kTCreateChartDoc,
	kTChartAttach,
	kTChartShow,
	kTChartLine,
	kTChartEllipseE,
	kTChartEllipseF,
	kTChartClear,
	kTChartPolyF,
	kTChartPolyE,
	kTChartText,
	kTChartFastPolyF,
	kTChartFastPolyE,
	kTChartColour,
	kTChartFlow,
	kTChartChoice,
	kTChartLink,
	kTChartAction,
	kTChartN,
	kTChartS,
	kTChartE,
	kTChartW,
	kTChartHighlight,	
	kTGetPolygonArea,
      kTGetCursorKeys,
      kTIsoView,
	kTAppend,
	kTWantReturn,
	kTSetCommitText,
	kTSetCancelText,
	kTAttachModel,
	kTModelShow,
	kTModelBond,
	kTModelAtom,
	kTModelCell,
	kTModelClear,
	kTCreateModelDoc,
	kTRadiusType,
	kTRadiusScale,
	kTVDW,
      kTThermal,
	kTCovalent,
	kTSelectAction,
	kTGetAction,
	kTSelect,
	kTAppendTo,
	kTSendA,
	kTSendB,
	kTSendC,
	kTSendD,
	kTSendCAndSelect,
	kTSetCommandText,
	kTSetStatus,
	kTUnSetStatus,
	kTNoEdge,
	kTGraph,
	kTModelTri,
	kTIntegerInput,
	kTRealInput,
	kTNoInput,
	kTSelectAtoms,
	kTGetItem,
	kTPosition,
	kTRightOf,
	kTLeftOf,
	kTAbove,
	kTBelow,
	kTCascade,
	kTCentred,
	kTAddToList,
      kTSetSelection,
      kTSendValue,
	kTCheckValue,
	kTInvert,
	kTSendLine,
	kTSendIndex,
      kTAt,
      kTOpenGrid,
      kTSpew
};

enum {
		kTQExists = 1,
		kTQListtext,
		kTQText,
		kTQListrow,
		kTQListitem,
		kTQNselected,
		kTQSelected,
		kTQState
};

enum {
		kTData = 1,
		kTVerticalBar,
		kTHorizontalBar,
		kTDataByLabel,
		kTDataBySeries,
		kTNSeries,
		kTAxisScale,
		kTLinear,
		kTLog,
		kTExp
};


enum {
	kLogicalClass	=	1,
	kInstructionClass,
	kAttributeClass,
	kPositionClass,
	kChartClass,
	kModelClass,
	kStatusClass,
	kGraphClass,
	kPositionalClass,
	kQueryClass
};


enum {
	CR_MENUITEM	=	1,
	CR_SUBMENU,
	CR_SPLIT
};
// Type constants
enum {
	kTUnknown = 0,
	
	kTYes,
	kTNo,

	kTAll,
	
	kTNull,
	
	kTRow,
	kTColumn,
	kTCallback,
	kTDisabled,
//	kTAlignSelector,
	kTVisibleLines,
	kTTextSelector,
	kTEnabledSelector,
	kTState,
	kTChars,
	kTWidth,
	kTComplete,
	
	kTNumberOfRows,
	kTNumberOfColumns,
	
	kTDefault,
	kTInform,
	kTIgnore,
	kTOutline,
	kTAlignExpand,
	kTAlignRight,
	kTAlignBottom,
	kTOn,
	kTOff,
	
	kTModal,
	kTZoom,
	kTSize,
	kTClose,
	kTMenuDisableCondition,
	kTMenuEnableCondition,
	kTTitleOnly
};

#endif
