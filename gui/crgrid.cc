////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGrid.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:59 Uhr
//   $Log: not supported by cvs2svn $
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
#include        "cctokenlist.h"
#include        "cccontroller.h"
#include        "crbutton.h"
#include        "crlistbox.h"
#include        "crlistctrl.h"
#include        "crmodlist.h"
#include        "crdropdown.h"
#include        "crmultiedit.h"
#include        "crtextout.h"
#include        "creditbox.h"
#include        "crtext.h"
#include        "cricon.h"
#include        "crprogress.h"
#include        "crcheckbox.h"
#include        "crchart.h"
#include        "crplot.h"
#include        <GL/glu.h>
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
  m_TheGrid = nil;
  mTabStop = false;
  m_Rows = 0;
  m_Columns = 0;
  m_CommandSet = false;
  m_CommandText = "";

  m_ContentWidth = 0;
  m_ContentHeight = 0;
  m_InitContentWidth = 0;
  m_InitContentHeight = 0;

  m_InitialColWidths = 0;
  m_InitialRowHeights = 0;
  m_ColCanResize = 0;
  m_RowCanResize = 0;

}

CrGrid::~CrGrid()
{
  m_ItemList.Reset();
  CrGUIElement * theItem = (CrGUIElement *)m_ItemList.GetItem();
  while ( theItem != nil )
  {
    delete theItem;
    m_ItemList.RemoveItem();
    theItem = (CrGUIElement *)m_ItemList.GetItem();
  }
  if ( m_OutlineWidget != nil )
  {
    delete (CxGroupBox*)m_OutlineWidget;
    m_OutlineWidget = nil;
  }

  if ( ptr_to_cxObject != nil )
  {
    ((CxGrid*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
    delete (CxGrid*)ptr_to_cxObject;
#endif
    ptr_to_cxObject = nil;
  }


  delete [] m_TheGrid;
  delete [] m_InitialColWidths;
  delete [] m_InitialRowHeights;
  delete [] m_ColCanResize;
  delete [] m_RowCanResize;

}

CcParse CrGrid::ParseInput( CcTokenList * tokenList )
{
  CcParse retVal(false, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;
  CcString theString;

// Initialization for the first time

  if( ! mSelfInitialised )
  {
    CcController::debugIndent ++;
    retVal = CrGUIElement::ParseInputNoText( tokenList );
    LOGSTAT( "Created Grid " + mName );

    while ( hasTokenForMe )
    {
      switch ( tokenList->GetDescriptor(kAttributeClass) )
      {
        case kTNumberOfRows:
        {
          tokenList->GetToken(); // Remove the keyword
          theString = tokenList->GetToken();
          m_Rows = atoi( theString.ToCString() );
          LOGSTAT( "Setting Grid Rows: " + theString );
          break;
        }
        case kTNumberOfColumns:
        {
          tokenList->GetToken(); // Remove the keyword
          theString = tokenList->GetToken();
          m_Columns = atoi( theString.ToCString() );
          LOGSTAT( "Setting Grid Columns: " + theString );
          break;
        }
        case kTSetCommandText:
        {
          tokenList->GetToken(); // Remove that token!
          SetCommandText( tokenList->GetToken() );
          break;
        }
        case kTOutline:
        {
          tokenList->GetToken(); // Remove that token!
          m_OutlineWidget = CxGroupBox::CreateCxGroupBox( this, (CxGrid *)GetWidget() );
          mText = tokenList->GetToken();
          SetText( mText );
          LOGSTAT( "Setting Grid outline" );
          break;
        }
        case kTAlignIsolate:
        {
          tokenList->GetToken(); // Remove that token!
          mAlignment += kIsolate;
          LOGSTAT( "Setting Grid alignment ISOLATE" );
          break;
        }
        case kTAlignRight:
        {
          tokenList->GetToken(); // Remove that token!
          mAlignment += kRightAlign;
          LOGSTAT( "Setting Grid alignment RIGHT" );
          break;
        }
        case kTAlignBottom:
        {
          tokenList->GetToken(); // Remove that token!
          mAlignment += kBottomAlign;
          LOGSTAT( "Setting Grid alignment BOTTOM" );
          break;
        }

        case kTOpenGrid:
        {
          tokenList->GetToken();
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

    m_TheGrid = (CrGUIElement **) new int [ m_Rows * m_Columns ];
    m_InitialColWidths = new int [ m_Columns ];
    m_InitialRowHeights = new int [ m_Rows ];
    m_ColCanResize = new bool [ m_Columns ];
    m_RowCanResize = new bool [ m_Rows ];

    int i;
    for (i = 0; i < m_Rows*m_Columns; i++) m_TheGrid[i] = nil;
    for (i = 0; i < m_Columns; i++)
    {
      m_InitialColWidths[i] = EMPTY_CELL;
      m_ColCanResize[i] = false;
    }
    for (i = 0; i < m_Rows; i++)
    {
      m_InitialRowHeights[i] = EMPTY_CELL;
      m_RowCanResize[i] = false;
    }

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

  if( tokenList->GetDescriptor( kInstructionClass ) == kTNoMoreToken ) return true;

// This is either the end of this grid, the start of a new sub grid or
// a sub element.

  hasTokenForMe = true;

  while ( hasTokenForMe )
  {
    switch ( tokenList->GetDescriptor( kInstructionClass ) )
    {
      case kTEndGrid:                                         // End this grid.
      {
        tokenList->GetToken();
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
        tokenList->GetToken();
        CcString theString;
        theString = tokenList->GetToken();              // the next must be the row number
        int ypos = atoi( theString.ToCString() );
        theString = tokenList->GetToken();              // the next must be the col number
        int xpos = atoi( theString.ToCString() );

        if ( m_GridComplete )  //There shouldn't be any stuff being added now.
        {
           LOGERR("Attempt to add to a completed grid. Ignoring.");
           tokenList->GetToken();  //Remove the next instruction
           tokenList->GetToken();  //and at least two
           tokenList->GetToken();  //of its arguments.
           break;
        }
        switch ( tokenList->GetDescriptor( kInstructionClass ) )
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
          case kTCreateListBox:                           // Create a ListBox
          {
            CrListBox * listPtr = new CrListBox( this );
            if ( listPtr != nil )
              retVal = InitElement( listPtr, tokenList, xpos, ypos );
            break;
          }
#ifdef __CR_WIN__
//The ListCtrl is not yet supported
// under linux due to lack of demand.
          case kTCreateListCtrl:                    // Create a List Control
          {
            CrListCtrl * listPtr = new CrListCtrl( this );
            if ( listPtr != nil )
              retVal = InitElement( listPtr, tokenList, xpos, ypos );
            break;
          }
#endif
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
            // Remove the token for safety.
            CcString badtoken = tokenList->GetToken();
            //Moan
            LOGWARN("CrGrid:ParseInput:default No command after @location in grid:" + badtoken );
          }
        }
        break;
      }  // End of kTAt switch.
      default:
      {
        // No handler
        // Remove the token for safety.
        CcString badtoken = tokenList->GetToken();
        //Moan
        LOGWARN("CrGrid:ParseInput:default No Handler for current command:" + badtoken );
        CcController::debugIndent --;
        hasTokenForMe = false;
      }
    }
  }
  return (retVal);
}



void CrGrid::SetGeometry( const CcRect * rect )
{
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

  LOGSTAT("CrGrid: " + mName + " Total size, h: "+CcString(totHeight)+" w: "+CcString(totWidth) );
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

  return CcRect( 0,0, totHeight, totWidth);
}


void    CrGrid::SetText( CcString item )
{
  char theText[256];
  strcpy( theText, item.ToCString() );

  if (m_OutlineWidget != nil ) m_OutlineWidget->SetText( theText );
}

CcParse CrGrid::InitElement( CrGUIElement * element, CcTokenList * tokenList, int xpos, int ypos)
{
  tokenList->GetToken(); //This is the element type (e.g. BUTTON). Remove it.

  if(element->mTabStop) ((CrWindow*)GetRootWidget())->AddToTabGroup(element);

  CcParse retVal(false);

  if ( this->SetPointer ( xpos, ypos, element ))
  {
// Parse the item specific stuff
    retVal = element->ParseInput( tokenList );
  }

  if ( retVal.OK() )
  {
    m_ItemList.AddItem( element );
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

CrGUIElement *  CrGrid::FindObject( CcString Name )
{
  CrGUIElement * theElement = nil, * theItem;
  m_ItemList.Reset();
  theItem = (CrGUIElement *)m_ItemList.GetItemAndMove();
  while ( theItem != nil && theElement == nil )
  {
    theElement = theItem->FindObject( Name );
    theItem = (CrGUIElement *)m_ItemList.GetItemAndMove();
  }
  return ( theElement );
}

bool CrGrid::SetPointer( int xpos, int ypos, CrGUIElement * ptr )
{
  if ((xpos > m_Columns) || (ypos > m_Rows))
  {
    LOGERR("Position of element out of range of grid size");
    return false;
  }
  if ( *( m_TheGrid + ((xpos-1)+(ypos-1)*m_Columns) ) != nil )
  {
    LOGERR("Position of element clashes with existing element");
    return false;
  }

  *(m_TheGrid + ( (xpos-1) + (ypos-1) * m_Columns)) = ptr;
  return true;
}

CrGUIElement *  CrGrid::GetPointer( int xpos, int ypos )
{
  return *(m_TheGrid + (xpos-1 + (ypos-1) * m_Columns));
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


void CrGrid::SendCommand(CcString theText, bool jumpQueue)
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

 if ( theText.Len() == 0 ) //It may be that objects or commands have empty strings.
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
 else if ((m_CommandSet)&&(!(theText.Sub(1,1)=='#'))&&(!(theText.Sub(1,1)=='^'))   )
 {
     mControllerPtr->SendCommand(m_CommandText);
     mControllerPtr->SendCommand(theText);
 }
 else
 {
   mParentElementPtr->SendCommand(theText, jumpQueue); //Keep passing the text up the tree.
 }
}

void CrGrid::SetCommandText(CcString theText)
{
  m_CommandText = theText;
  m_CommandSet = true;
}

void CrGrid::CrShowGrid(bool state)
{
  ((CxGrid*)ptr_to_cxObject)->CxShowWindow(state);
}
