////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcChartDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcChartDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

//BIG NOTICE: ChartDoc is not a CrGUIElement, it's more like a list
//            of drawing commands.
//            You can attach a CrChart to it and it will then draw
//            itself on that CrChart's drawing area.
//            It does contain a ParseInput routine for parsing the
//            drawing commands. Note again - it is not a CrGUIElement,
//            it has no graphical presence, nor a complimentary Cx- class

#ifndef		__CcChartDoc_H__
#define		__CcChartDoc_H__


#include "ccstring.h"	// Added by ClassView
class CcTokenList;
class CrChart;
class CcList;
class CrGraph;

class CcChartDoc
{
	public:
		void DrawView();
		CcChartDoc();
		~CcChartDoc();
		Boolean	ParseInput( CcTokenList * tokenList );

            void FastLine( int x1, int y1, int x2, int y2 );
            void FastFElli( int x, int y, int w, int h );
            void FastEElli( int x, int y, int w, int h );
            void FastFPoly( int nv, int * points );
            void FastEPoly( int nv, int * points );
            void FastText( int x, int y, CcString text );
            void FastColour( int r, int g, int b );

            void Clear();
            CcChartDoc * FindObject( CcString Name );
            void Rename( CcString newName );

	private:
		CrGraph* mGraphPointer;
		void ReadDirections( CcTokenList* tokenList, Boolean *north,Boolean *south,Boolean *east,Boolean *west);
		Boolean mSelfInitialised;
		CcString mName;
		CrChart* attachedChart;
		CcList* mCommandList;
            int current_r;
            int current_g;
            int current_b;
};

#define kSChartAttach		"ATTACH"
#define kSChartShow		"SHOW"
#define kSChartLine		"LINE"
#define kSChartEllipseE		"ELLIE"
#define kSChartEllipseF		"ELLIF"
#define kSChartClear		"CLEAR"
#define	kSChartPolyF		"POLYF"
#define	kSChartPolyE		"POLYE"
#define	kSChartFastPolyF	"FPOLYF"
#define	kSChartFastPolyE	"FPOLYE"
#define kSGraph			"GRAPH"
#define	kSChartText		"TEXT"
#define kSChartColour		"RGB"
#define kSChartFlow		"FLOW"
#define kSChartChoice		"CHOICE"
#define kSChartLink		"LINK"
#define kSChartAction		"ACTION"
#define kSChartN		"N"
#define kSChartS		"S"
#define kSChartE		"E"
#define kSChartW		"W"

enum
{
 kTChartAttach = 300, 
 kTChartShow,	
 kTChartLine,	
 kTChartEllipseE,
 kTChartEllipseF,
 kTChartClear,	
 kTChartPolyF,	
 kTChartPolyE,	
 kTChartFastPolyF,
 kTChartFastPolyE,
 kTGraph,	
 kTChartText,	
 kTChartColour,	
 kTChartFlow,	
 kTChartChoice,	
 kTChartLink,	
 kTChartAction,	
 kTChartN,	
 kTChartS,	
 kTChartE,	
 kTChartW	
};

#endif
