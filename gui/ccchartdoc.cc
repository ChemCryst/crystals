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

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"ccchartdoc.h"
#include	"crchart.h"
#include	"crgraph.h"
#include	"ccchartobject.h"
#include	"cccontroller.h"	

CcChartDoc::CcChartDoc( )
{
	mCommandList = new CcList();
	attachedChart = nil;
	mSelfInitialised = false;
	mGraphPointer = nil;
}

CcChartDoc::~CcChartDoc()
{
	mCommandList->Reset();
	CcChartObject* theItem = (CcChartObject *)mCommandList->GetItem();
	while ( theItem != nil )
	{
		mCommandList->RemoveItem();
		delete theItem;
		theItem = (CcChartObject *)mCommandList->GetItem();
	}
	delete mCommandList;

	if(mGraphPointer != nil)
		delete mGraphPointer;
}

Boolean	CcChartDoc::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = true;
	Boolean hasTokenForMe = true;
	
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
			case kTChartFastPolyF:
			{
				tokenList->GetToken(); // Remove that token!
                        CcChartPoly* item = new CcChartPoly(true);
				item->FastInput(tokenList);
				mCommandList->AddItem(item);
				break;
			}
			case kTChartFastPolyE:
			{
				tokenList->GetToken(); // Remove that token!
                        CcChartPoly* item = new CcChartPoly(false);
				item->FastInput(tokenList);
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
				Boolean storeMe = item->ParseInput(tokenList); //If the pen colour is already set, this object is superfluous.
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
				Boolean north;
				Boolean south;
				Boolean east;
				Boolean west;
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
			case kTGraph:
			{
				tokenList->GetToken();
				mGraphPointer = new CrGraph(this);
				mGraphPointer->ParseInput(tokenList);
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
		mCommandList->Reset();
		CcChartObject* item;
		while ( (item = (CcChartObject*)mCommandList->GetItemAndMove()) != nil )
		{
			item->Draw(attachedChart);
		}
		if(mGraphPointer != nil)
			mGraphPointer->Draw(attachedChart);

		attachedChart->Display();
	}
}

void CcChartDoc::ReadDirections(CcTokenList* tokenList,Boolean * north, Boolean * south, Boolean * east, Boolean * west)
{
	*north = false;
	*south = false;
	*east = false;
	*west = false;
	Boolean readDirections = true;
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

void CcChartDoc::FastText( int x, int y, CcString text )
{
      CcChartText* item = new CcChartText( x, y, text );
      mCommandList->AddItem(item);
}

void CcChartDoc::FastColour( int r, int g, int b )
{
      if ( ( r == current_r) && ( g == current_g ) && ( b == current_b ) )
      {
            return;
      }

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
      if(attachedChart)
            attachedChart->Clear();
}


// The global functions that are called directly from the Fortran,
// they will always direct commands to the current chart i.e.
// whichever one was addressed last using a ^^CH command.

extern "C" {

#ifdef __WINDOWS__
void fastline  ( int x1, int y1, int x2, int y2 );
void fastfelli ( int x,  int y,  int w,  int h  );
void fasteelli ( int x,  int y,  int w,  int h  );
void fastfpoly ( int nv, int * points );
void fastepoly ( int nv, int * points );
void fasttext  ( int x,  int y,  char theText[80] );
void fastcolour( int r,  int g, int b );
void fastclear     ( );
void fastshow      ( );
void complete      ( );
#endif
#ifdef __LINUX__
void fastline_  ( int x1, int y1, int x2, int y2 );
void fastfelli_ ( int x,  int y,  int w,  int h  );
void fasteelli_ ( int x,  int y,  int w,  int h  );
void fastfpoly_ ( int nv, int * points );
void fastepoly_ ( int nv, int * points );
void fasttext_  ( int x,  int y,  char theText[80] );
void fastcolour_( int r,  int g, int b );
void fastclear_     ( );
void fastshow_      ( );
void complete_      ( );
#endif

void fastline  ( int x1, int y1, int x2, int y2 )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->FastLine( x1, y1, x2, y2 );
}

void fastfelli  ( int x, int y, int w, int h )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->FastFElli( x, y, w, h );
}
void fasteelli  ( int x, int y, int w, int h )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->FastEElli( x, y, w, h );
}

void fastfpoly ( int nv, int * points )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->FastFPoly( nv, points );
}
void fastepoly ( int nv, int * points )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->FastEPoly( nv, points );
}

void fasttext  ( int x,  int y,  char theText[80] )
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
            doc->FastText( x,y,text );
}

void fastcolour( int r, int g, int b )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->FastColour( r,g,b );
}

void fastclear ( )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->Clear( );
}

void fastshow ( )
{
      CcChartDoc * doc = (CcController::theController)->mCurrentChartDoc;
      if ( doc )
            doc->DrawView( );
}

void complete ( )
{
// Make sure the command queue is emptied before returning.
      (CcController::theController)->CompleteProcessing();
}

} //extern "C"
