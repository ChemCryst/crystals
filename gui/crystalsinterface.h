////////////////////////////////////////////////////////////////////////

//   Filename:  CrystalsInterface.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   27.2.1998 14:11 Uhr
//   Modified:  27.2.1998 14:11 Uhr

#ifndef		__CrystalsInterface_H__
#define		__CrystalsInterface_H__

#include	"ccstring.h"

void errorlog( CcString outStr );

// Instructions


enum {
	kButtonBase			=	40000,
	kListBoxBase		=	41000,
	kDropDownBase		=	42000,
	kEditBoxBase		=	43000,
	kGridBase			=	44000,
	kGroupBoxBase		=	45000,
	kMultiEditBase		=	46000,
	kTextBase			=	47000,
	kCheckBoxBase		=	48000,
	kRadioButtonBase	=	49000,
	kWindowBase			=	50000,
	kMenuBase			=	51000,
	kChartBase			=	52000,
	kModelBase			=	53000,
	kProgressBase		=	54000,
	kListCtrlBase		=	55000
};

#define	kNoAlignment		0
#define kExpand				1
#define kRightAlign			2
#define kBottomAlign		4

#define kModal				1
#define kZoom				2
#define kClose				4
#define kSize				8

#define EMPTY_CELL			10

#define max(a, b)  (((a) > (b)) ? (a) : (b))
#define min(a, b)  (((a) < (b)) ? (a) : (b))
#define NOTUSED(a) //Compares a to itself, optimiser will remove this.(?)

#ifdef __POWERPC__
typedef void AppContext;
#endif

#ifdef __MOTO__
#include <Types.h>
typedef void AppContext;
#endif


#ifdef __LINUX__
typedef bool Boolean;
#define nil 0
//#define TRUE true
//#define FALSE false
#define UINT uint
#include <wx/file.h>
#include <wx/memory.h>
#include <stdio.h>
#include <iostream.h>
#include <iomanip.h>
#define TRACE WXTRACE
#endif

#ifdef __WINDOWS__
#include "stdafx.h"
#include "crystals.h"
typedef bool Boolean;
#define nil NULL
#endif


#define CRLEFT    0
#define CRRIGHT   1
#define CRUP      2
#define CRDOWN    3
#define CRINSERT  4
#define CRDELETE  5
#define CREND     6
#define CRESCAPE  7
#define CRCONTROL 8
#define CRSHIFT   9

#define COVALENT	1
#define VDW       2
#define THERMAL   3
#define SPARE     4



#define LOGERRORS    //        Log errors         (LOGERR macro)
#define LOGWARNINGS  //        Log warnings       (LOGWARN macro)
// #undef  LOGSTATUS    //(Don't) Log lots of things (LOGSTAT macro)
#define  LOGSTATUS    //Log lots of things (LOGSTAT macro)


#ifdef _DEBUG
#ifdef __WINDOWS__
	#include <afxwin.h> //Needed for TRACE debugger macro.
	#define new DEBUG_NEW //Needed for debugger to track heap allocations.
#endif
	#ifdef LOGERRORS
		#define LOGERR(a) ( (CcController::theController)->LogError(a,0) )
	#else
		#define LOGERR(a)
	#endif
	#ifdef LOGWARNINGS 
		#define LOGWARN(a) ( (CcController::theController)->LogError(a,1) )
	#else
		#define LOGWARN(a)
	#endif
	#ifdef LOGSTATUS
		#define LOGSTAT(a) ( (CcController::theController)->LogError(a,2) )
	#else
		#define LOGSTAT(a)
	#endif

      #define TEXTOUT(a) ( (CcController::theController)->Tokenize((char*)CcString(a).ToCString()) )
#else
	#define LOGERR(a)
	#define LOGWARN(a)
	#define LOGSTAT(a)
      #define TEXTOUT(a)
#endif


#endif
