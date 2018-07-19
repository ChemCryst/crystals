////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGrid.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:59 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.32  2011/05/16 10:56:32  rich
//   Added pane support to WX version. Added coloured bonds to model.
//
//   Revision 1.31  2011/04/18 08:17:57  rich
//   MFC patches.
//
//   Revision 1.30  2011/04/16 07:09:51  rich
//   Web control
//
//   Revision 1.29  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.28  2004/06/29 15:15:30  rich
//   Remove references to unused kTNoMoreToken. Protect against reading
//   an empty list of tokens.
//
//   Revision 1.27  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.26  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.25  2004/05/21 14:00:18  rich
//   Implement LISTCTRL on Linux. Some extra functionality still missing,
//   such as clicking column headers to sort.
//
//   Revision 1.24  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.23  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.22  2003/01/15 14:06:29  rich
//   Some fail-safe code in the GUI. In the event of a creation of a window failing don't
//   allow the rest of the windows to be corrupted.
//
//   Revision 1.21  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.20  2002/10/02 13:43:17  rich
//   New ModList class added.
//
//   Revision 1.19  2002/07/23 08:27:02  richard
//
//   Extra parameter during GRID creation: "ISOLATE" - grid won't expand when the
//   window resizes, even if it contains objects which might like to expand.
//
//   Revision 1.18  2002/05/14 17:04:49  richard
//   Changes to include new GUI control HIDDENSTRING.
//
//   Revision 1.17  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//
//   Revision 1.16  2001/06/17 15:14:13  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.15  2001/03/23 11:35:53  richard
//   Initialise some pointers to zero to avoid crash if grid fails
//   to initialise and then gets deleted.
//
//   Revision 1.14  2001/03/08 15:36:03  richard
//   Completely re-written the window sizing and layout code. Now much simpler.
//   Calclayout works out and returns the size of a GUI object, so that the
//   calling window knows what size to make itself initially. The setgeom call then
//   actaully sets the sizes. During resize the difference between
//   the available size and the original size is used to calculate how much
//   to expand or shrink each object.
//

#include        "crystalsinterface.h"
#include        "crconstants.h"
#include        "crgrid.h"
#include        "cxgrid.h"
#include        "cccontroller.h"
#include        "crbutton.h"
#include        "crlistbox.h"
#include        "crlistctrl.h"
#include        "crmodlist.h"
#include        "crdropdown.h"
#include        "crmultiedit.h"
#include        "crtextout.h"
#include        "creditbox.h"
#include        "crslider.h"
#include        "crtext.h"
#include        "cricon.h"
#include        "crprogress.h"
#include        "crcheckbox.h"
#include        "crchart.h"
#include        "crplot.h"
#ifdef CRY_OSMAC
#include        <OpenGL/glu.h>
#else
#include        <GL/glu.h>
#endif
#include        "crmodel.h"
#include        "crradiobutton.h"
#include        "crwindow.h"
#include        "ccrect.h"
#include        "cxgroupbox.h"
#include        "crbitmap.h"
#include        "crtab.h"
#include        "crtoolbar.h"
#include        "crstretch.h"
#include        "crresizebar.h"
#include        "crhidden.h"
#include        "crweb.h"

#include <string>
#include <sstream>


CrGrid::CrGrid( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
  m_GridComplete = false;
  m_ActiveSubGrid = nil;
  m_OutlineWidget = nil;
  mXCanResize = false;
  mYCanResize = false;

  // We have to create a GUI representation of the grid only, if we
  // need to outline it
  ptr_to_cxObject = CxGrid::CreateCxGrid( this, (CxGrid *)(mParentPtr->GetWidget()) );
  mTabStop = false;
  m_Rows = 0;
  m_Columns = 0;
  m_CommandSet = false;
  m_CommandText = "";

  m_ContentWidth = 0;
  m_ContentHeight = 0;
  m_InitContentWidth = 0;
  m_InitContentHeight = 0;
  m_IsPane = false;
}

CrGrid::~CrGrid()
{
  list<CrGUIElement*>::iterator crgi = m_ItemList.begin();

  for ( ; crgi != m_ItemList.end(); crgi++ )
  {
     delete *crgi;
  }

  m_ItemList.clear();

  if ( m_OutlineWidget != nil )
  {
    delete (CxGroupBox*)m_OutlineWidget;
    m_OutlineWidget = nil;
  }

  if ( ptr_to_cxObject != nil )
  {
    ((CxGrid*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
    delete (CxGrid*)ptr_to_cxObject;
#endif
    ptr_to_cxObject = nil;
  }
}

CcParse CrGrid::ParseInput( deque<string> & tokenList )
{
  CcParse retVal(false, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;
  string theString;

// Initialization for the first time

  if( ! mSelfInitialised )
  {
    CcController::debugIndent ++;
    retVal = CrGUIElement::ParseInputNoText( tokenList );
    LOGSTAT( "Created Grid " + mName );

    while ( hasTokenForMe && ! tokenList.empty() )
    {
      switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
      {
        case kTNumberOfRows:
        {
          tokenList.pop_front(); // Remove the keyword
          m_Rows = atoi( tokenList.front().c_str() );
          LOGSTAT( "Setting Grid Rows: " + tokenList.front() );
          tokenList.pop_front();
          break;
        }
        case kTNumberOfColumns:
        {
          tokenList.pop_front(); // Remove the keyword
          m_Columns = atoi( tokenList.front().c_str() );
          LOGSTAT( "Setting Grid Columns: " + tokenList.front() );
          tokenList.pop_front();
          break;
        }
        case kTSetCommandText:
        {
          tokenList.pop_front(); // Remove SetCommandText token!
          SetCommandText( tokenList.front() );
          tokenList.pop_front(); // Remove text token
          break;
        }
        case kTPane:
        {
          tokenList.pop_front(); // Remove SetCommandText token!
#ifdef CRY_USEWX
		  unsigned int position;
		  switch ( CcController::GetDescriptor( tokenList.front(), kPanePositionClass ) )
          {
			case kTRight:
				position = wxRIGHT;
				break;
 			case kTLeft:
				position = wxLEFT;
				break;
			case kTTop:
				position = wxTOP;
				break;
			case kTBottom:
				position = wxBOTTOM;
				break;
			case kTCentre:
				position = wxCENTRE;
				break;
			default:
				LOGWARN("CrGrid:ParseInput:default No pane location after PANE in grid:" + tokenList.front() );
				position = wxLEFT;
				break;
		  }
          tokenList.pop_front(); // Remove the position keyword
		  string framename = tokenList.front();
		  CrWindow* wframe = NULL;
		  if ( framename == GetRootWidget()->mName ) {
		     wframe = (CrWindow*)GetRootWidget();
		  } else {
             wframe = (CrWindow*) (CcController::theController)->FindObject(framename);
		  }
          tokenList.pop_front();
		  if ( wframe ) { 
			wframe->SetPane(ptr_to_cxObject, position, mText);
			m_IsPane = true;
		  } else {
		     LOGWARN("No window named: " + framename );
		  }
#endif
          break;
        }
        case kTOutline:
        {
          tokenList.pop_front(); // Remove that token!
          m_OutlineWidget = CxGroupBox::CreateCxGroupBox( this, (CxGrid *)GetWidget() );
          mText = string(tokenList.front());
          tokenList.pop_front();
          SetText( mText );
          LOGSTAT( "Setting Grid outline" );
          break;
        }
        case kTAlignIsolate:
        {
          tokenList.pop_front(); // Remove that token!
          mAlignment += kIsolate;
          LOGSTAT( "Setting Grid alignment ISOLATE" );
          break;
        }
        case kTAlignRight:
        {
          tokenList.pop_front(); // Remove that token!
          mAlignment += kRightAlign;
          LOGSTAT( "Setting Grid alignment RIGHT" );
          break;
        }
        case kTAlignBottom:
        {
          tokenList.pop_front(); // Remove that token!
          mAlignment += kBottomAlign;
          LOGSTAT( "Setting Grid alignment BOTTOM" );
          break;
        }

        case kTOpenGrid:
        {
          tokenList.pop_front();
          //No break,
          //end of initialsing token input for this grid.
        }
        default:
        {
          hasTokenForMe = false;
          break; // We leave the token in the list and exit the loop
        }
      }
    }

// Create the array holding the elements

    m_TheGrid.resize(m_Rows);
    for ( vector<vector<CrGUIElement*> >::iterator vv= m_TheGrid.begin(); vv != m_TheGrid.end(); vv++ )
        (*vv).resize(m_Columns);

    m_InitialColWidths.resize( m_Columns, EMPTY_CELL );
    m_InitialRowHeights.resize( m_Rows, EMPTY_CELL );
    m_ColCanResize.resize( m_Columns, false );
    m_RowCanResize.resize( m_Rows, false );

    for (int i = 0; i < m_Rows; i++) 
       for ( int j = 0; j < m_Columns; j++)
          m_TheGrid[i][j] = nil;

    mSelfInitialised = true;
  }
// End of Init, now comes the general parser

// If a child grid is incomplete pass the tokenlist straight down.
//(This is rare, but it is possible for tokenLists to become fragmented
//if some other command accidentally causes them to be processed before
//they are complete.)

  if(m_ActiveSubGrid != nil)
  {
    if (!m_ActiveSubGrid->GridComplete()) // Sub Grid exists, testing for completeness...
    {
      return retVal = m_ActiveSubGrid->ParseInput(tokenList); // Sub Grid incomplete passing tokenList...
    }
    else
    {
      m_ActiveSubGrid = nil;
    }
  }

  if ( tokenList.empty() ) return true;

// This is either the end of this grid, the start of a new sub grid or
// a sub element.

  hasTokenForMe = true;

  while ( hasTokenForMe && ! tokenList.empty() )
  {
    switch ( CcController::GetDescriptor( tokenList.front(), kInstructionClass ) )
    {
      case kTEndGrid:                                         // End this grid.
      {
        tokenList.pop_front();
        m_GridComplete = true;
        LOGSTAT("CrGrid:ParseInput:EndGrid Grid closed");
        if ( mAlignment &  kIsolate )
           retVal = CcParse(true,false,false);
        else
           retVal = CcParse(true,mXCanResize,mYCanResize);
        hasTokenForMe = false;
        CcController::debugIndent --;
        break;
      }
      case kTAt:
      {
        tokenList.pop_front();
        int ypos = atoi( tokenList.front().c_str() );
        tokenList.pop_front();
        int xpos = atoi( tokenList.front().c_str() );
        tokenList.pop_front();

        if ( m_GridComplete )  //There shouldn't be any stuff being added now.
        {
           LOGERR("Attempt to add to a completed grid. Ignoring.");
           tokenList.pop_front();  //Remove the next instruction
           tokenList.pop_front();  //and at least two
           tokenList.pop_front();  //of its arguments.
           break;
        }
        switch ( CcController::GetDescriptor( tokenList.front(), kInstructionClass ) )
        {
          case kTCreateGrid:                                      // Create a sub grid.
          {
            CrGrid * gridPtr = new CrGrid( this );
            if ( gridPtr != nil )
            {
              m_ActiveSubGrid = gridPtr;
              retVal = InitElement( gridPtr, tokenList, xpos, ypos );
            }
            break;
          }
          case kTCreateButton:                            // Create a button
          {
            CrButton * buttPtr = new CrButton( this );
            if ( buttPtr != nil )
              retVal = InitElement( buttPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateWeb:                            // Create a web control
          {
#ifdef DEPRECATEDCRY_USEWX
            CrWeb * webPtr = new CrWeb( this );
            if ( webPtr != nil )
              retVal = InitElement( webPtr, tokenList, xpos, ypos );
#endif
            break;
          }
          case kTCreateListBox:                           // Create a ListBox
          {
            CrListBox * listPtr = new CrListBox( this );
            if ( listPtr != nil )
              retVal = InitElement( listPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateListCtrl:                    // Create a List Control
          {
            CrListCtrl * listPtr = new CrListCtrl( this );
            if ( listPtr != nil )
              retVal = InitElement( listPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateModList:                    // Create a List Control
          {
            CrModList * listPtr = new CrModList( this );
            if ( listPtr != nil )
              retVal = InitElement( listPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateDropDown:                          // Create a DropDown
          {
            CrDropDown * dropDownPtr = new CrDropDown( this );
            if ( dropDownPtr != nil )
              retVal = InitElement( dropDownPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateMultiEdit:                         // Create a MultiEdit field
          {
            CrMultiEdit * multiEditPtr = new CrMultiEdit( this );
            if ( multiEditPtr != nil )
              retVal = InitElement( multiEditPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateTextOut:                         // Create a TextOut field
          {
            CrTextOut * TextOutPtr = new CrTextOut( this );
            if ( TextOutPtr != nil )
              retVal = InitElement( TextOutPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateEditBox:                           // Create an edit box
          {
            CrEditBox * editBoxPtr = new CrEditBox( this );
            if ( editBoxPtr != nil )
              retVal = InitElement( editBoxPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateSlider:                            // Create a slider
          {
            CrSlider * sliderPtr = new CrSlider( this );
            if ( sliderPtr != nil )
              retVal = InitElement( sliderPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateText:                                      // Create a caption
          {
            CrText * texttPtr = new CrText( this );
            if ( texttPtr != nil )
              retVal = InitElement( texttPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateIcon:                              // Create a caption
          {
            CrIcon * iconPtr = new CrIcon( this );
            if ( iconPtr != nil )
              retVal = InitElement( iconPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateProgress:                                  // Create a progress bar
          {
            CrProgress * progressPtr = new CrProgress( this );
            if ( progressPtr != nil )
              retVal = InitElement( progressPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateRadioButton:                       // Create a Radio button
          {
            CrRadioButton * radioButtPtr = new CrRadioButton( this );
            if ( radioButtPtr != nil )
            {
              retVal = InitElement( radioButtPtr, tokenList, xpos, ypos );
            }
            break;
          }
          case kTCreateCheckBox:                          // Create a CheckBox
          {
            CrCheckBox * checkBoxPtr = new CrCheckBox( this );
            if ( checkBoxPtr != nil )
              retVal = InitElement( checkBoxPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateChart:                                 // Create a Chart
          {
            CrChart * chartPtr = new CrChart( this );
            if ( chartPtr != nil )
              retVal = InitElement( chartPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreatePlot:                                 // Create a Plot
          {
            CrPlot * plotPtr = new CrPlot( this );
            if ( plotPtr != nil )
              retVal = InitElement( plotPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateModel:                                 // Create a Model
          {
            CrModel * modelPtr = new CrModel( this );
            if ( modelPtr != nil )
              retVal = InitElement( modelPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateBitmap:                                 // Create a Bitmap
          {
            CrBitmap * bitPtr = new CrBitmap( this );
            if ( bitPtr != nil )
              retVal = InitElement( bitPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateTabCtrl:                                 // Create a Tab control
          {
            CrTab * tabPtr = new CrTab( this );
            if ( tabPtr != nil )
              retVal = InitElement( tabPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateToolBar:                                 // Create a Toolbar
          {
            CrToolBar * toolPtr = new CrToolBar( this );
            if ( toolPtr != nil )
              retVal = InitElement( toolPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateStretch:                                 // Create a Stretch
          {
            CrStretch * sPtr = new CrStretch( this );
            if ( sPtr != nil )
              retVal = InitElement( sPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateHidden:                                 // Create a Hidden String
          {
            CrHidden * hPtr = new CrHidden( this );
            if ( hPtr != nil )
              retVal = InitElement( hPtr, tokenList, xpos, ypos );
            break;
          }
          case kTCreateResize:                                 // Create a Resize control
          {
            CrResizeBar * barPtr = new CrResizeBar( this );
            if ( barPtr != nil )
            {
               retVal = InitElement( barPtr, tokenList, xpos, ypos );
            }
            break;
          }
          default:
          {
            // No valid instruction following @ location
            // Remove the token for safety. //Moan
            LOGWARN("CrGrid:ParseInput:default No command after @location in grid:" + tokenList.front() );
            tokenList.pop_front();
          }
        }
        break;
      }  // End of kTAt switch.
      default:
      {
        // No handler
        // Remove the token for safety.
        //Moan
        LOGWARN("CrGrid:ParseInput:default No Handler for current command:" + tokenList.front() );
        tokenList.pop_front();
        CcController::debugIndent --;
        hasTokenForMe = false;
      }
    }
  }
  return (retVal);
}


void  CrGrid::ResizeGrid( int w, int h ) {
  if ( m_IsPane ) {
 	if ( ((CrWindow*)GetRootWidget())->m_Shown ) {
        CcRect rect = GetGeometry();
 		rect.mBottom = rect.mTop+h;
		rect.mRight = rect.mLeft+w;
		GridSetGeometry(&rect);
	}
  }
}



void CrGrid::SetGeometry( const CcRect * rect )
{
  if ( !m_IsPane ) {
    GridSetGeometry(rect);
  }
}


void CrGrid::GridSetGeometry( const CcRect * rect ) {
	
	

  ((CxGrid*)ptr_to_cxObject)->SetGeometry( rect->mTop,    rect->mLeft,
                                           rect->mBottom, rect->mRight );
  if ( m_OutlineWidget != nil )
  {
    m_OutlineWidget->SetGeometry( 0, 0, rect->mBottom - rect->mTop, rect->mRight - rect->mLeft );
  }

  int xp, yp;
  CrGUIElement *vtemp;
  int* ColWidths = new int [ m_Columns ];
  int* RowHeights = new int [ m_Rows ];
  int runTotHeight = 0;  int runTotWidth = 0;
  if(m_OutlineWidget) runTotWidth += EMPTY_CELL;

  float deltaWidth = (float)((rect->mRight - rect->mLeft)  - m_InitWidth);
  float deltaHeight = (float)((rect->mBottom - rect->mTop) - m_InitHeight);

//Share out the available space between all resizeable elements.

  for ( xp = 0; xp < m_Columns ; xp++)
  {
    ColWidths[xp] = m_InitialColWidths[xp];
    if ( m_ColCanResize[xp] ) ColWidths[xp] += (int)((float)ColWidths[xp]*((deltaWidth/m_resizeableWidth)));
    ColWidths[xp] = CRMAX ( ColWidths[xp], EMPTY_CELL ); //Limit
  }
  for ( yp = 0; yp < m_Rows ; yp++)
  {
    RowHeights[yp] = m_InitialRowHeights[yp];
    if ( m_RowCanResize[yp] ) RowHeights[yp] += (int)((float)RowHeights[yp]*((deltaHeight/m_resizeableHeight)));
    RowHeights[yp] = CRMAX ( RowHeights[yp], EMPTY_CELL ); //Limit
  }

//Call SetGeometry on all children.

  for ( xp = 1; xp <= m_Columns ; xp++)
  {
    runTotHeight=0;
    if(m_OutlineWidget) runTotHeight += 2*EMPTY_CELL;
    for ( yp = 1; yp <= m_Rows ; yp++)
    {
      if ( ( vtemp = GetPointer(xp,yp) ) )
      {
        CcRect newRect(runTotHeight, runTotWidth, runTotHeight+ RowHeights[yp-1], runTotWidth + ColWidths[xp-1]);
        CcController::debugIndent++;
        ((CrGUIElement*)vtemp)->SetGeometry(&newRect);
        CcController::debugIndent--;
      }
      runTotHeight += RowHeights[yp-1];
    }
    runTotWidth += ColWidths[xp-1];
  }

  delete [] ColWidths;
  delete [] RowHeights;
}

CRGETGEOMETRY(CrGrid,CxGrid)

CcRect CrGrid::CalcLayout(bool recalc)
{
  int totHeight = 0; int totWidth = 0; int xp, yp;
  CrGUIElement *vtemp;
  int*  ColWidths = new int [ m_Columns ];
  int*  RowHeights = new int [ m_Rows ];

  CcController::debugIndent++;
  LOGSTAT("CrGrid: " + mName + " CalcLayout: Calculating sizes of all children");

// Initialise column widths and heights.
  for (xp = 0; xp < m_Columns; xp++) { ColWidths[xp]  = EMPTY_CELL; };
  for (yp = 0; yp < m_Rows; yp++)    { RowHeights[yp] = EMPTY_CELL; };

// Call calclayout for child elements. Store their sizes.
  for ( xp = 1; xp <= m_Columns ; xp++)
  {
    for ( yp = 1; yp <= m_Rows ; yp++)
    {
      if ( ( vtemp = GetPointer(xp,yp) ) == nil ) continue;  //(Skip loop).

      CcController::debugIndent++;
      CcRect rect;
      rect = ((CrGUIElement*)vtemp)->CalcLayout(recalc);
      ColWidths[xp-1] = CRMAX ( ColWidths[xp-1], rect.Width() );
      RowHeights[yp-1] = CRMAX ( RowHeights[yp-1], rect.Height() );
      CcController::debugIndent--;
    }
  }

// Add up heights and widths
  for (xp = 0; xp < m_Columns; xp++) { totWidth  += ColWidths[xp];  };
  for (yp = 0; yp < m_Rows; yp++)    { totHeight += RowHeights[yp]; };

// If there is an outline, add some space for it.
  if(m_OutlineWidget) { totHeight += 3*EMPTY_CELL; totWidth += 2*EMPTY_CELL; }

  ostringstream strm;
  strm << "CrGrid: " << mName << " Total size, h: "<< totHeight <<" w: " << totWidth;
  LOGSTAT( strm.str() );
  CcController::debugIndent--;

  if ( recalc )
  {
    m_InitContentWidth = totWidth; m_InitContentHeight = totHeight;
    m_resizeableWidth = 0;         m_resizeableHeight = 0;

    for ( xp = 0; xp < m_Columns ; xp++)
    {
      m_InitialColWidths[xp] = ColWidths[xp];
      if ( m_ColCanResize[xp] ) m_resizeableWidth += (float)ColWidths[xp];
    }
    for ( yp = 0; yp < m_Rows ; yp++)
    {
      m_InitialRowHeights[yp] = RowHeights[yp];
      if ( m_RowCanResize[yp] ) m_resizeableHeight += (float)RowHeights[yp] ;
    }

    m_InitWidth = totWidth;
    m_InitHeight = totHeight;
  }

  delete [] ColWidths;
  delete [] RowHeights;

  if ( m_IsPane ) {
	  ((CrWindow*)GetRootWidget())->SetPaneMin(ptr_to_cxObject,totWidth,totHeight);
  }

  return CcRect( 0,0, totHeight, totWidth);
}


void    CrGrid::SetText( const string &item )
{
  if (m_OutlineWidget != nil ) m_OutlineWidget->SetText( item );
}

CcParse CrGrid::InitElement( CrGUIElement * element, deque<string> & tokenList, int xpos, int ypos)
{
  tokenList.pop_front(); //This is the element type (e.g. BUTTON). Remove it.

  if(element->mTabStop) ((CrWindow*)GetRootWidget())->AddToTabGroup(element);

  CcParse retVal(false);

  if ( this->SetPointer ( xpos, ypos, element ))
  {
    m_ItemList.push_back( element );  // Add now so that FindObject searches from sibling elements can work OK.
// Parse the item specific stuff
    retVal = element->ParseInput( tokenList );
  }

  if ( retVal.OK() )
  {
//    m_ItemList.push_back( element );
    m_ColCanResize[xpos-1] = m_ColCanResize[xpos-1] || retVal.CanXResize();
    m_RowCanResize[ypos-1] = m_RowCanResize[ypos-1] || retVal.CanYResize();
    mXCanResize = mXCanResize || retVal.CanXResize();
    mYCanResize = mYCanResize || retVal.CanYResize();

    if ( retVal.CanXResize() ) LOGSTAT ( "CrGrid: "+element->mName+" can resize in X" );
    else LOGSTAT ( "CrGrid: "+element->mName+" can not resize in X" );
    if ( retVal.CanYResize() ) LOGSTAT ( "CrGrid: "+element->mName+" can resize in Y" );
    else LOGSTAT ( "CrGrid: "+element->mName+" can not resize in Y" );
  }
  else
  {
    m_ItemList.remove(element);
    delete element;
  }

  return retVal;
}

void    CrGrid::Align()
{
/*
    CcRect rect, newrect, gridRect;
    bool done = false;
    CrGUIElement * vtemp;

//    if ( mAlignment &  kIsolate )
//    {
//      if ( doAdjust )
//      {
//        SetGeometry( &newrect );
//
//// If we have an outline widget we have to adjust that too
//        if ( m_OutlineWidget != nil )
//             m_OutlineWidget->SetGeometry(0,0,newrect.Height(),newrect.Width() );
//      }
//      done = false;
//    }

  if ( mAlignment & kRightAlign )
  {
    int xp, yp;
    gridRect = GetGeometry();
    int totalWidth = 0;
    for ( xp = 1; xp <= m_Columns ; xp++)
    {
      totalWidth += GetWidthOfColumn( xp );
    }
    int delta = gridRect.Width() - totalWidth;

    for ( xp = 1; xp <= m_Columns ; xp++)
    {
      for ( yp = 1; yp <= m_Rows ; yp++)
      {
        vtemp = GetPointer(xp,yp);
        if ( vtemp != nil )
        {
          rect = vtemp->GetGeometry();
          newrect = CcRect(   rect.Top()    - gridRect.Top(),
                              rect.Left()   - gridRect.Left()    + delta,
                              rect.Bottom() - gridRect.Top(),
                              rect.Right()  - gridRect.Left()    + delta );
          vtemp->SetGeometry( &newrect );
          vtemp->Align();
        }
      }
    }
    done = true;
  }

  if ( mAlignment & kBottomAlign )
  {
    int xp, yp;
    gridRect = GetGeometry();
    int totalHeight = 0;
    for ( yp = 1; yp <= m_Rows ; yp++)
    {
      totalHeight += GetHeightOfRow( yp );
    }
    int delta = gridRect.Height() - totalHeight;

    for ( yp = 1; yp <= m_Rows ; yp++)
    {
      for ( xp = 1; xp <= m_Columns ; xp++)
      {
        vtemp = GetPointer(xp,yp);
        if ( vtemp != nil )
        {
          rect = vtemp->GetGeometry();
          newrect = CcRect(   rect.Top()    - gridRect.Top()    + delta,
                              rect.Left()   - gridRect.Left(),
                              rect.Bottom() - gridRect.Top()    + delta,
                              rect.Right()  - gridRect.Left() );
          vtemp->SetGeometry( &newrect );
          vtemp->Align();
        }
      }
    }
    done = true;
  }

  if ( ! done )
  {
    int xp, yp;
    for ( yp = 1; yp <= m_Rows ; yp++)
    {
      for ( xp = 1; xp <= m_Columns ; xp++)
      {
        vtemp = GetPointer(xp,yp);
        if ( vtemp != nil ) vtemp->Align();
      }
    }
  }
*/
}

int CrGrid::GetHeightOfRow( int row )
{
  CrGUIElement * elemPtr;
  int maxHeight = EMPTY_CELL, xp;
  for ( xp = 1; xp <= m_Columns ; xp++)
  {
    elemPtr = GetPointer(xp,row);
    CcRect rect(0,0,EMPTY_CELL,EMPTY_CELL);
    if ( elemPtr != nil )
        rect = elemPtr->GetGeometry();
    if (rect.Height() > maxHeight)
            maxHeight = rect.Height();
  }
  return maxHeight;
}

int CrGrid::GetWidthOfColumn( int col )
{
  CrGUIElement * elemPtr;
  int maxWidth = EMPTY_CELL, yp;
  for ( yp = 1; yp <= m_Rows ; yp++)
  {
    elemPtr = GetPointer(col,yp);
    CcRect rect(0,0,EMPTY_CELL,EMPTY_CELL);
    if ( elemPtr != nil )
        rect = elemPtr->GetGeometry();
    if (rect.Width() > maxWidth)
            maxWidth = rect.Width();
  }
  return maxWidth;
}

CrGUIElement *  CrGrid::FindObject( const string & Name )
{
  CrGUIElement* theElement;

  list<CrGUIElement*>::iterator crgi = m_ItemList.begin();
  for ( ; crgi != m_ItemList.end(); crgi++ )
  {
    theElement = (*crgi)->FindObject( Name );
    if ( theElement ) return theElement;
  }
  return nil;
}

bool CrGrid::SetPointer( int xpos, int ypos, CrGUIElement * ptr )
{
  if ((xpos > m_Columns) || (ypos > m_Rows))
  {
    LOGERR("Position of element out of range of grid size");
    return false;
  }
  if ( m_TheGrid[ypos-1][xpos-1] != nil )
  {
    LOGERR("Position of element clashes with existing element");
    return false;
  }

  m_TheGrid[ypos-1][xpos-1] = ptr;
  return true;
}

CrGUIElement *  CrGrid::GetPointer( int xpos, int ypos )
{
  return m_TheGrid[ypos-1][xpos-1];
}


int CrGrid::GetIdealWidth()
{
  int resizeableWidth = 0;
  for ( int xp = 0; xp < m_Columns; xp++ )
  {
    if ( m_ColCanResize[xp] ) resizeableWidth += m_InitialColWidths[xp] ;
  }
  return resizeableWidth;
}
int CrGrid::GetIdealHeight()
{
  int resizeableHeight = 0;
  for ( int yp = 0; yp < m_Rows; yp++ )
  {
    if ( m_RowCanResize[yp] ) resizeableHeight += m_InitialRowHeights[yp] ;
  }
  return resizeableHeight;
}

void CrGrid::CrFocus()
{

}


void CrGrid::SendCommand(const string & theText, bool jumpQueue)
{
//If there is a COMMAND= set for this window
//send this first, unless the text begins with
//a # or ^ symbol.

//Usually the command is set to a script which
//will handle any events generated by the window.
// e.g. in xmodel.scp COMMAND='xmodelhand.scp'

//For certain commands it is useful to bypass this
//mechanism and pass the command straight to
//CRYSTALS (#) or to GUI (^).

 if ( theText.length() == 0 ) //It may be that objects or commands have empty strings.
 {                         //in which case it would be bad to check the text at position(1).
   if ( m_CommandSet )
   {
     mControllerPtr->SendCommand(m_CommandText);
     mControllerPtr->SendCommand(theText);
   }
   else
   {
     mParentElementPtr->SendCommand(theText, jumpQueue); //Keep passing the text up the tree.
   }
 }
 else if ((m_CommandSet)&&(!(theText[0]=='#'))&&(!(theText[0]=='^'))   )
 {
     mControllerPtr->SendCommand(m_CommandText);
     mControllerPtr->SendCommand(theText);
 }
 else
 {
   mParentElementPtr->SendCommand(theText, jumpQueue); //Keep passing the text up the tree.
 }
}

void CrGrid::SetCommandText(const string & theText)
{
  m_CommandText = theText;
  m_CommandSet = true;
}

void CrGrid::CrShowGrid(bool state)
{
  ((CxGrid*)ptr_to_cxObject)->CxShowWindow(state);
}
