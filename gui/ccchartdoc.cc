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

#ifdef __BOTHWX__
#include <wx/thread.h>
#endif

CcChartDoc::CcChartDoc( )
{
    mCommandList = new CcList();
    attachedChart = nil;
    mSelfInitialised = false;
        (CcController::theController)->mChartList.AddItem(this);
    current_r = -1;
    current_g = -1;
    current_b = -1;

}

CcChartDoc::~CcChartDoc()
{
        (CcController::theController)->mChartList.FindItem(this);
        (CcController::theController)->mChartList.RemoveItem();

    mCommandList->Reset();
    CcChartObject* theItem = (CcChartObject *)mCommandList->GetItem();
    while ( theItem != nil )
    {
        mCommandList->RemoveItem();
        delete theItem;
        theItem = (CcChartObject *)mCommandList->GetItem();
    }
    delete mCommandList;

}

bool CcChartDoc::ParseInput( CcTokenList * tokenList )
{
    bool retVal = true;
    bool hasTokenForMe = true;

    if( ! mSelfInitialised )
    {
        mName = tokenList->GetToken();
        mSelfInitialised = true;
    }

    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kChartClass) )
        {
            case kTChartAttach:
            {
                tokenList->GetToken(); // Remove that token!
                CcString chartName = tokenList->GetToken();
                attachedChart = (CrChart*)(CcController::theController)->FindObject(chartName);
                if(attachedChart != nil)
                    attachedChart->Attach(this);
                break;
            }
            case kTChartShow:
            {
                tokenList->GetToken(); // Remove that token!
                DrawView();
                break;
            }
            case kTChartLine:
            {
                tokenList->GetToken(); // Remove that token!
                CcChartLine* item = new CcChartLine();
                item->ParseInput(tokenList);
                mCommandList->AddItem(item);
                break;
            }
            case kTChartEllipseF:
            {
                tokenList->GetToken(); // Remove that token!
                        CcChartEllipse* item = new CcChartEllipse(true);
                item->ParseInput(tokenList);
                mCommandList->AddItem(item);
                break;
            }
            case kTChartEllipseE:
            {
                tokenList->GetToken(); // Remove that token!
                        CcChartEllipse* item = new CcChartEllipse(false);
                item->ParseInput(tokenList);
                mCommandList->AddItem(item);
                break;
            }
            case kTChartPolyF:
            {
                tokenList->GetToken(); // Remove that token!
                        CcChartPoly* item = new CcChartPoly(true);
                item->ParseInput(tokenList);
                mCommandList->AddItem(item);
                break;
            }
            case kTChartPolyE:
            {
                tokenList->GetToken(); // Remove that token!
                        CcChartPoly* item = new CcChartPoly(false);
                item->ParseInput(tokenList);
                mCommandList->AddItem(item);
                break;
            }
            case kTChartText:
            {
                tokenList->GetToken(); // Remove that token!
                CcChartText* item = new CcChartText();
                item->ParseInput(tokenList);
                mCommandList->AddItem(item);
                break;
            }
            case kTChartColour:
            {
                tokenList->GetToken(); // Remove that token!
                CcChartColour* item = new CcChartColour();
                bool storeMe = item->ParseInput(tokenList); //If the pen colour is already set, this object is superfluous.
                if (storeMe)
                    mCommandList->AddItem(item);
                else
                    delete item;
                break;
            }
            case kTChartClear:
            {
                tokenList->GetToken(); // Remove that token!
                        Clear();
                break;
            }
            case kTChartFlow:
            {
                tokenList->GetToken();
                bool north;
                bool south;
                bool east;
                bool west;
                CcString flowtext = "";
                switch ( tokenList->GetDescriptor(kChartClass) )
                {
                    case kTChartChoice:
                    {
                        tokenList->GetToken();
                        ReadDirections(tokenList, &north, &south, &east, &west);
                        flowtext = tokenList->GetToken();
                        //Add the commands to draw the flow chart object.
                        //joins:
                        CcChartLine* item;
                        if(west)
                        {
                            item = new CcChartLine();
                            item->Init(0,1200,240,1200);
                            mCommandList->AddItem(item);
                        }
                        if(north)
                        {
                            item = new CcChartLine();
                            item->Init(1200,0,1200,240);
                            mCommandList->AddItem(item);
                        }
                        if(east)
                        {
                            item = new CcChartLine();
                            item->Init(2160,1200,2400,1200);
                            mCommandList->AddItem(item);
                        }
                        if(south)
                        {
                            item = new CcChartLine();
                            item->Init(1200,2160,1200,2400);
                            mCommandList->AddItem(item);
                        }
                        //diamond edges:
                        item = new CcChartLine();
                        item->Init(240,1200,1200,240);
                        mCommandList->AddItem(item);
                        item = new CcChartLine();
                        item->Init(1200,240,2160,1200);
                        mCommandList->AddItem(item);
                        item = new CcChartLine();
                        item->Init(2160,1200,1200,2160);
                        mCommandList->AddItem(item);
                        item = new CcChartLine();
                        item->Init(1200,2160,240,1200);
                        mCommandList->AddItem(item);
                        CcChartText* tItem = new CcChartText();
                        tItem->Init(480, 1000, 1920, 1400, flowtext);
                        mCommandList->AddItem(tItem);
                        break;
                    }
                    case kTChartAction:
                    {
                        tokenList->GetToken();
                        ReadDirections(tokenList, &north, &south, &east, &west);
                        flowtext = tokenList->GetToken();
                        //Add the commands to draw the flow chart object.
                        //joins:
                        CcChartLine* item;
                        if(west)
                        {
                            item = new CcChartLine();
                            item->Init(0,1200,480,1200);
                            mCommandList->AddItem(item);
                        }
                        if(north)
                        {
                            item = new CcChartLine();
                            item->Init(1200,0,1200,480);
                            mCommandList->AddItem(item);
                        }
                        if(east)
                        {
                            item = new CcChartLine();
                            item->Init(1920,1200,2400,1200);
                            mCommandList->AddItem(item);
                        }
                        if(south)
                        {
                            item = new CcChartLine();
                            item->Init(1200,1920,1200,2400);
                            mCommandList->AddItem(item);
                        }
                        //box edges:
                        item = new CcChartLine();
                        item->Init(480,480,1920,480);
                        mCommandList->AddItem(item);
                        item = new CcChartLine();
                        item->Init(1920,480,1920,1920);
                        mCommandList->AddItem(item);
                        item = new CcChartLine();
                        item->Init(1920,1920,480,1920);
                        mCommandList->AddItem(item);
                        item = new CcChartLine();
                        item->Init(480,1920,480,480);
                        mCommandList->AddItem(item);
                        CcChartText* tItem = new CcChartText();
                        tItem->Init(500, 1000, 1900, 1400, flowtext);
                        mCommandList->AddItem(tItem);
                        break;
                    }
                    case kTChartLink:
                    {
                        tokenList->GetToken();
                        ReadDirections(tokenList, &north, &south, &east, &west);
                        CcChartLine* item;
                        if(west)
                        {
                            item = new CcChartLine();
                            item->Init(0,1200,1200,1200);
                            mCommandList->AddItem(item);
                        }
                        if(north)
                        {
                            item = new CcChartLine();
                            item->Init(1200,0,1200,1200);
                            mCommandList->AddItem(item);
                        }
                        if(east)
                        {
                            item = new CcChartLine();
                            item->Init(2400,1200,1200,1200);
                            mCommandList->AddItem(item);
                        }
                        if(south)
                        {
                            item = new CcChartLine();
                            item->Init(1200,2400,1200,1200);
                            mCommandList->AddItem(item);
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
        mCommandList->Reset();
        CcChartObject* item;
        while ( (item = (CcChartObject*)mCommandList->GetItemAndMove()) != nil )
        {
            item->Draw(attachedChart);
        }

        attachedChart->Display();
    }
    current_r = -1;
    current_g = -1;
    current_b = -1;

}

void CcChartDoc::ReadDirections(CcTokenList* tokenList,bool * north, bool * south, bool * east, bool * west)
{
    *north = false;
    *south = false;
    *east = false;
    *west = false;
    bool readDirections = true;
    while ( readDirections )
    {
        switch ( tokenList->GetDescriptor(kChartClass) )
        {
            case kTChartN:
                tokenList->GetToken();
                *north = true;
                break;
            case kTChartS:
                tokenList->GetToken();
                *south = true;
                break;
            case kTChartE:
                tokenList->GetToken();
                *east = true;
                break;
            case kTChartW:
                tokenList->GetToken();
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
      CcChartLine* item = new CcChartLine(x1,y1,x2,y2);
      mCommandList->AddItem(item);
}

void CcChartDoc::FastFElli( int x, int y, int w, int h )
{
      CcChartEllipse* item = new CcChartEllipse(true,x,y,w,h);
      mCommandList->AddItem(item);
}

void CcChartDoc::FastEElli( int x, int y, int w, int h )
{
      CcChartEllipse* item = new CcChartEllipse(false,x,y,w,h);
      mCommandList->AddItem(item);
}

void CcChartDoc::FastFPoly( int nv, int * points )
{
      CcChartPoly* item = new CcChartPoly ( true, nv, points );
      mCommandList->AddItem(item);
}

void CcChartDoc::FastEPoly( int nv, int * points )
{
      CcChartPoly* item = new CcChartPoly ( false, nv, points );
      mCommandList->AddItem(item);
}

void CcChartDoc::FastText( int x, int y, CcString text, int fs )
{
      int xoffs = 0;
      int yoffs = 0;

      CcChartText* item = new CcChartText();

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

      mCommandList->AddItem(item);
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

      CcChartColour* item = new CcChartColour(r,g,b);
      mCommandList->AddItem(item);
}

void CcChartDoc::Clear()
{
      mCommandList->Reset();
      CcChartObject* theItem = (CcChartObject *)mCommandList->GetItem();
      while ( theItem != nil )
      {
            mCommandList->RemoveItem();
            delete theItem;
            theItem = (CcChartObject *)mCommandList->GetItem();
      }


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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcString text = theText;
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
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


CcChartDoc *  CcChartDoc::FindObject( CcString Name )
{
    if ( Name == mName )
        return this;
    else
        return nil;
}


void CcChartDoc::Rename( CcString newName )
{
      LOGSTAT("Renaming object: " + mName + " to " + newName );
      mName = newName;
}
