////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcChartDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcChartDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr

//BIG NOTICE: ChartDoc is not a CrGUIElement, it's more like a list
//            of drawing commands.
//            You can attach a CrChart to it and it will then draw
//            itself on that CrChart's drawing area.
//            It does contain a ParseInput routine for parsing the
//            drawing commands. Note again - it is not a CrGUIElement,
//            it has no graphical presence, nor a complimentary Cx- class

// $Log: not supported by cvs2svn $
// Revision 1.15  2003/11/13 16:45:26  rich
// Clear chart area before drawing. Gets rid of those bits of Cameron diagram
// that overflowed the previous drawing.
//
// Revision 1.14  2003/05/07 12:18:56  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.13  2002/06/26 11:57:48  richard
// Label mouse fixes.
//
// Revision 1.12  2002/06/25 11:56:43  richard
// Initialise some local variables. Could have been causing Cameron no black bonds bug.
//
// Revision 1.11  2002/04/30 20:13:43  richard
// Get font size right and dependent on window/canvas size.
//
// Revision 1.10  2002/03/16 18:08:22  richard
// Removed old CrGraph class (now obsolete given Steven's work).
// Removed remains of "quickdata" interface (now obsolete, replaced by FASTPOLY etc.)
//
// Revision 1.9  2001/07/16 07:18:27  ckp2
// Prevent the fast calls from Cameron from directly accessing GUI drawing functions.
// These should be from the main thread only.
//
// Revision 1.8  2001/03/08 16:44:01  richard
// General changes - replaced common functions in all GUI classes by macros.
// Generally tidied up, added logs to top of all source files.
//
// Revision 1.7  2001/01/25 16:44:21  richard
// Removed FASTPOLYF and E subroutines, which aren't used.
//
// Revision 1.6  2000/12/13 17:51:24  richard
// Support for Linux.
//


#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccchartdoc.h"
#include    "crchart.h"
#include    "ccchartobject.h"
#include    "cccontroller.h"
#include   <list>
using namespace std;

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif

list<CcChartDoc*> CcChartDoc::sm_ChartDocList;
CcChartDoc* CcChartDoc::sm_CurrentChartDoc = nil;

CcChartDoc::CcChartDoc( )
{
    attachedChart = nil;
    mSelfInitialised = false;
    current_r = -1;
    current_g = -1;
    current_b = -1;
    sm_ChartDocList.push_back(this);
    sm_CurrentChartDoc = this;
}

CcChartDoc::~CcChartDoc()
{
  // Remove from the list of ChartDoc objects.
    sm_ChartDocList.remove(this);
    if ( sm_CurrentChartDoc == this ) sm_CurrentChartDoc = nil;
    for (list<CcChartObject*>::iterator item = mCommandList.begin(); item != mCommandList.end(); item++ )
    {
       delete *item;
    }
}


bool operator==(CcChartDoc* doc, const string& st0)
{
   return( st0 == doc->mName ) ;
}


bool CcChartDoc::ParseInput( deque<string> & tokenList )
{
    bool retVal = true;
    bool hasTokenForMe = true;

    if( ! mSelfInitialised )
    {
        mName = string(tokenList.front());  // Make a copy of the string.
        tokenList.pop_front();
        mSelfInitialised = true;
    }

    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor(tokenList.front(), kChartClass) )
        {
            case kTChartAttach:
            {
                tokenList.pop_front(); // Remove that token!
                string chartName(tokenList.front()); tokenList.pop_front();
                attachedChart = (CrChart*)(CcController::theController)->FindObject(chartName);
                if(attachedChart != nil)
                    attachedChart->Attach(this);
                break;
            }
            case kTChartShow:
            {
                tokenList.pop_front(); // Remove that token!
                DrawView();
                break;
            }
            case kTChartLine:
            {
                tokenList.pop_front(); // Remove that token!
                CcChartLine * item = new CcChartLine();
                item->ParseInput(tokenList);
                mCommandList.push_back(item);
                break;
            }
            case kTChartEllipseF:
            {
                tokenList.pop_front(); // Remove that token!
                CcChartEllipse * item = new CcChartEllipse(true);
                item->ParseInput(tokenList);
                mCommandList.push_back(item);
                break;
            }
            case kTChartEllipseE:
            {
                tokenList.pop_front(); // Remove that token!
                CcChartEllipse * item = new CcChartEllipse(false);
                item->ParseInput(tokenList);
                mCommandList.push_back(item);
                break;
            }
            case kTChartPolyF:
            {
                tokenList.pop_front(); // Remove that token!
                CcChartPoly * item = new CcChartPoly(true);
                item->ParseInput(tokenList);
                mCommandList.push_back(item);
                break;
            }
            case kTChartPolyE:
            {
                tokenList.pop_front(); // Remove that token!
                CcChartPoly * item =new CcChartPoly(false);
                item->ParseInput(tokenList);
                mCommandList.push_back(item);
                break;
            }
            case kTChartText:
            {
                tokenList.pop_front(); // Remove that token!
                CcChartText * titem = new CcChartText;
                titem->ParseInput(tokenList);
                mCommandList.push_back(titem);
                break;
            }
            case kTChartColour:
            {
                tokenList.pop_front(); // Remove that token!
                CcChartColour * citem = new CcChartColour ;
                bool storeMe = citem->ParseInput(tokenList); //If the pen colour is already set, this object is superfluous.
                if (storeMe)
                    mCommandList.push_back(citem);
                else
                    delete citem;
                break;
            }
            case kTChartClear:
            {
                tokenList.pop_front(); // Remove that token!
                        Clear();
                break;
            }
            case kTChartFlow:
            {
                tokenList.pop_front();
                bool north;
                bool south;
                bool east;
                bool west;
                switch ( CcController::GetDescriptor(tokenList.front(), kChartClass) )
                {
                    case kTChartChoice:
                    {
                        tokenList.pop_front();
                        ReadDirections(tokenList, &north, &south, &east, &west);
                        //Add the commands to draw the flow chart object.
                        //joins:
                        CcChartLine * item = new CcChartLine;
                        if(west)
                        {
                            item->Init(0,1200,240,1200);
                            mCommandList.push_back(item);
                        }
                        if(north)
                        {
                            item->Init(1200,0,1200,240);
                            mCommandList.push_back(item);
                        }
                        if(east)
                        {
                            item->Init(2160,1200,2400,1200);
                            mCommandList.push_back(item);
                        }
                        if(south)
                        {
                            item->Init(1200,2160,1200,2400);
                            mCommandList.push_back(item);
                        }
                        //diamond edges:
                        item = new CcChartLine;
                        item->Init(240,1200,1200,240);
                        mCommandList.push_back(item);
                        item = new CcChartLine;
                        item->Init(1200,240,2160,1200);
                        mCommandList.push_back(item);
                        item = new CcChartLine;
                        item->Init(2160,1200,1200,2160);
                        mCommandList.push_back(item);
                        item = new CcChartLine;
                        item->Init(1200,2160,240,1200);
                        mCommandList.push_back(item);
                        CcChartText * ttem = new CcChartText;
                        ttem->Init(480, 1000, 1920, 1400, tokenList.front());
                        tokenList.pop_front();
                        mCommandList.push_back(ttem);
                        break;
                    }
                    case kTChartAction:
                    {
                        tokenList.pop_front();
                        ReadDirections(tokenList, &north, &south, &east, &west);
                        //Add the commands to draw the flow chart object.
                        //joins:
                        CcChartLine * item = new CcChartLine;
                        if(west)
                        {
                            item->Init(0,1200,480,1200);
                            mCommandList.push_back(item);
                        }
                        if(north)
                        {
                            item->Init(1200,0,1200,480);
                            mCommandList.push_back(item);
                        }
                        if(east)
                        {
                            item->Init(1920,1200,2400,1200);
                            mCommandList.push_back(item);
                        }
                        if(south)
                        {
                            item->Init(1200,1920,1200,2400);
                            mCommandList.push_back(item);
                        }
                        //box edges:
                        item = new CcChartLine;
                        item->Init(480,480,1920,480);
                        mCommandList.push_back(item);
                        item = new CcChartLine;
                        item->Init(1920,480,1920,1920);
                        mCommandList.push_back(item);
                        item = new CcChartLine;
                        item->Init(1920,1920,480,1920);
                        mCommandList.push_back(item);
                        item = new CcChartLine;
                        item->Init(480,1920,480,480);
                        mCommandList.push_back(item);
                        CcChartText * tItem = new CcChartText;
                        tItem->Init(500, 1000, 1900, 1400, tokenList.front());
                        tokenList.pop_front();
                        mCommandList.push_back(tItem);
                        break;
                    }
                    case kTChartLink:
                    {
                        tokenList.pop_front();
                        ReadDirections(tokenList, &north, &south, &east, &west);
                        CcChartLine * item = new CcChartLine;
                        if(west)
                        {
                            item->Init(0,1200,1200,1200);
                            mCommandList.push_back(item);
                        }
                        if(north)
                        {
                            item->Init(1200,0,1200,1200);
                            mCommandList.push_back(item);
                        }
                        if(east)
                        {
                            item->Init(2400,1200,1200,1200);
                            mCommandList.push_back(item);
                        }
                        if(south)
                        {
                            item->Init(1200,2400,1200,1200);
                            mCommandList.push_back(item);
                        }
                        break;
                    }
                }
                break;
            }
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    return retVal;
}

void CcChartDoc::DrawView()
{
    if(attachedChart)
    {
        attachedChart->Clear();

        for (list<CcChartObject*>::iterator item = mCommandList.begin(); item != mCommandList.end(); item++ )
        {
            (*item)->Draw(attachedChart);
        }
        attachedChart->Display();
    }
    current_r = -1;
    current_g = -1;
    current_b = -1;

}

void CcChartDoc::ReadDirections(deque<string> & tokenList,bool * north, bool * south, bool * east, bool * west)
{
    *north = false;
    *south = false;
    *east = false;
    *west = false;
    bool readDirections = true;
    while ( readDirections )
    {
        switch ( CcController::GetDescriptor(tokenList.front(), kChartClass) )
        {
            case kTChartN:
                tokenList.pop_front();
                *north = true;
                break;
            case kTChartS:
                tokenList.pop_front();
                *south = true;
                break;
            case kTChartE:
                tokenList.pop_front();
                *east = true;
                break;
            case kTChartW:
                tokenList.pop_front();
                *west = true;
                break;
            default:
                readDirections = false;
                break;
        }
    }
}

//////////////////////////////////////////////////////
// Because updating Cameron pictures using the normal
// ^^CH commands can be very slow for big structures,
// we provided a direct interface here. This means
// more Fortran -> C++ interfaces, so the old calls
// have been left commented in the Cameron code
// should this interface prove unusable in the future.
//////////////////////////////////////////////////////

//////////////////////////////////////////////////////
// In order to mix old style (^^CH) commands and direct
// calls to the CcChartDoc from the Fortran, you must
// call GUWAIT after sending any ^^CH commands, before
// calling a direct function. This allows the interface
// to 'catch-up' with CRYSTALS, so that the direct calls
// insert objects at the correct spot in the drawing list.
//////////////////////////////////////////////////////////


void CcChartDoc::FastLine( int x1, int y1, int x2, int y2 )
{
      CcChartLine * item = new CcChartLine(x1,y1,x2,y2);
      mCommandList.push_back(item);
}

void CcChartDoc::FastFElli( int x, int y, int w, int h )
{
      CcChartEllipse * item = new CcChartEllipse(true,x,y,w,h);
      mCommandList.push_back(item);
}

void CcChartDoc::FastEElli( int x, int y, int w, int h )
{
      CcChartEllipse * item = new CcChartEllipse(false,x,y,w,h);
      mCommandList.push_back(item);
}

void CcChartDoc::FastFPoly( int nv, int * points )
{
      CcChartPoly * item = new CcChartPoly( true, nv, points );
      mCommandList.push_back(item);
}

void CcChartDoc::FastEPoly( int nv, int * points )
{
      CcChartPoly * item = new CcChartPoly( false, nv, points );
      mCommandList.push_back(item);
}

void CcChartDoc::FastText( int x, int y, string text, int fs )
{
      int xoffs = 0;
      int yoffs = 0;

      CcChartText * item = new CcChartText;

      if ( fs > 0 )
      {
         yoffs = fs * 5;
         xoffs = yoffs * 10;
         item->Init(x-xoffs, y-yoffs, x+xoffs, y+yoffs, text );
      }
      else
      {
         yoffs = -fs * 10;
         xoffs = yoffs * 10;
         item->Init(x, y, x+xoffs, y+yoffs, text , false );
      }

      mCommandList.push_back(item);
}

void CcChartDoc::FastColour( int r, int g, int b )
{
      if ( ( r == current_r) && ( g == current_g ) && ( b == current_b ) )
      {
            return;
      }

      current_r = r;
      current_g = g;
      current_b = b;

      CcChartColour * item = new CcChartColour(r,g,b);
      mCommandList.push_back(item);
}

void CcChartDoc::Clear()
{
      for (list<CcChartObject*>::iterator item = mCommandList.begin(); item != mCommandList.end(); item++ )
      {
         delete *item;
      }

      mCommandList.clear();
      current_r = -1;
      current_g = -1;
      current_b = -1;

//Don't actually clear yet -- reduce flickering + not supposed to call GUI functions
//from the crystals thread. (which we may be in right now...)
//      if(attachedChart)
//            attachedChart->Clear();
}


// The global functions that are called directly from the Fortran,
// they will always direct commands to the current chart i.e.
// whichever one was addressed last using a ^^CH command.

extern "C" {

#ifdef __CR_WIN__
void fastline  ( int x1, int y1, int x2, int y2 );
void fastfelli ( int x,  int y,  int w,  int h  );
void fasteelli ( int x,  int y,  int w,  int h  );
void fastfpoly ( int nv, int * points );
void fastepoly ( int nv, int * points );
void fasttext  ( int x,  int y,  char theText[80], int fs );
void fastcolour( int r,  int g, int b );
void fastclear     ( );
void fastshow      ( );
void complete      ( );
#endif
#ifdef __BOTHWX__
void fastline_  ( int x1, int y1, int x2, int y2 );
void fastfelli_ ( int x,  int y,  int w,  int h  );
void fasteelli_ ( int x,  int y,  int w,  int h  );
void fastfpoly_ ( int nv, int * points );
void fastepoly_ ( int nv, int * points );
void fasttext_  ( int x,  int y,  char theText[80], int fs );
void fastcolour_( int r,  int g, int b );
void fastclear_     ( );
void fastshow_      ( );
void complete_      ( );
#endif

#ifdef __CR_WIN__
void fastline  ( int x1, int y1, int x2, int y2 )
#endif
#ifdef __BOTHWX__
void fastline_  ( int x1, int y1, int x2, int y2 )
#endif
{
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->FastLine( x1, y1, x2, y2 );
}

#ifdef __CR_WIN__
void fastfelli  ( int x, int y, int w, int h )
#endif
#ifdef __BOTHWX__
void fastfelli_  ( int x, int y, int w, int h )
#endif
{
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->FastFElli( x, y, w, h );
}
#ifdef __CR_WIN__
void fasteelli  ( int x, int y, int w, int h )
#endif
#ifdef __BOTHWX__
void fasteelli_  ( int x, int y, int w, int h )
#endif
{
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->FastEElli( x, y, w, h );
}

#ifdef __CR_WIN__
void fastfpoly ( int nv, int * points )
#endif
#ifdef __BOTHWX__
void fastfpoly_ ( int nv, int * points )
#endif
{
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->FastFPoly( nv, points );
}
#ifdef __CR_WIN__
void fastepoly ( int nv, int * points )
#endif
#ifdef __BOTHWX__
void fastepoly_ ( int nv, int * points )
#endif
{
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->FastEPoly( nv, points );
}

#ifdef __CR_WIN__
void fasttext  ( int x,  int y,  char theText[80], int fs )
#endif
#ifdef __BOTHWX__
void fasttext_  ( int x,  int y,  char theText[80], int fs )
#endif
{
      theText[80] = '\0';
      for ( int i = 80; i >= 0; i-- )
      {
            if ( (theText[i]==' ') || (theText[i]=='\0') )
                  theText[i] = '\0';
            else
                  i = -1;
      }
      string text = theText;
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->FastText( x,y,text, fs );
}

#ifdef __CR_WIN__
void fastcolour( int r, int g, int b )
#endif
#ifdef __BOTHWX__
void fastcolour_( int r, int g, int b )
#endif
{
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->FastColour( r,g,b );
}

#ifdef __CR_WIN__
void fastclear ( )
#endif
#ifdef __BOTHWX__
void fastclear_ ( )
#endif
{
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->Clear( );
}

#ifdef __CR_WIN__
void fastshow ( )
#endif
#ifdef __BOTHWX__
void fastshow_ ( )
#endif
{
#ifdef __BOTHWX__
      ::wxMutexGuiEnter();
#endif
      CcChartDoc * doc = CcChartDoc::sm_CurrentChartDoc;
      if ( doc )
            doc->DrawView( );
#ifdef __BOTHWX__
      ::wxMutexGuiLeave();
#endif
}

#ifdef __CR_WIN__
void complete ( )
#endif
#ifdef __BOTHWX__
void complete_ ( )
#endif
{
// Make sure the command queue is emptied before returning.
      (CcController::theController)->CompleteProcessing();
}

} //extern "C"


CcChartDoc *  CcChartDoc::FindObject( const string & Name )
{
    if ( Name == mName )
        return this;
    else
        return nil;
}


void CcChartDoc::Rename( string newName )
{
      LOGSTAT("Renaming object: " + mName + " to " + newName );
      mName = newName;
}
