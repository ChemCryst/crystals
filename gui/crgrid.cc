////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGrid.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:59 Uhr
//   Modified:  30.3.1998 11:49 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crgrid.h"
#include	"cxgrid.h"
#include	"cctokenlist.h"
#include	"cccontroller.h"
#include	"crbutton.h"
#include	"crlistbox.h"
#include	"crlistctrl.h"
#include	"crdropdown.h"
#include	"crmultiedit.h"
#include        "crtextout.h"
#include	"creditbox.h"
#include	"crtext.h"
#include    "cricon.h"
#include	"crprogress.h"
#include	"crcheckbox.h"
#include	"crchart.h"
#include	"crmodel.h"
#include	"crradiobutton.h"
#include	"crwindow.h"
#include	"ccrect.h"
#include	"cxgroupbox.h"
#include        "crbitmap.h"



CrGrid::CrGrid( CrGUIElement * mParentPtr )
	:	CrGUIElement( mParentPtr )
{
	mGridComplete = false;
	mActiveSubGrid = nil;
	mOutlineWidget = nil;
	// We have to create a GUI representation of the grid only, if we
	// need to outline it
	mWidgetPtr = CxGrid::CreateCxGrid( this, (CxGrid *)(mParentPtr->GetWidget()) );
	mTheGrid = nil;
	mTabStop = false;
	mRows = 0;
	mColumns = 0;
	mCommandSet = false;
      mCommandText = "";
}

CrGrid::~CrGrid()
{
	CrGUIElement * theItem;
	
	mItemList.Reset();
	theItem = (CrGUIElement *)mItemList.GetItem();
	
	while ( theItem != nil )
	{
		delete theItem;
		mItemList.RemoveItem();
		theItem = (CrGUIElement *)mItemList.GetItem();
	}
	
	if ( mOutlineWidget != nil )
	{
		delete (CxGroupBox*)mOutlineWidget;
		mOutlineWidget = nil;
	}
	if ( mWidgetPtr != nil )
	{
		delete (CxGrid*)mWidgetPtr;
		mWidgetPtr = nil;
	}


	delete [] mTheGrid;
}

Boolean	CrGrid::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = false;
	Boolean hasTokenForMe = true;
	CcString theString;
	
	// Initialization for the first time
	if( ! mSelfInitialised )
	{	
		LOGSTAT("*** Grid *** Initing...");

		retVal = CrGUIElement::ParseInputNoText( tokenList );

		LOGSTAT( "*** Created Grid        " + mName );

		while ( hasTokenForMe )
		{
			switch ( tokenList->GetDescriptor(kAttributeClass) )
			{
				case kTNumberOfRows:
				{
					tokenList->GetToken(); // Remove the keyword
					theString = tokenList->GetToken();
					mRows = atoi( theString.ToCString() );
					LOGSTAT( "Setting Grid Rows: " + theString );
					break;
				}
				case kTNumberOfColumns:
				{
					tokenList->GetToken(); // Remove the keyword
					theString = tokenList->GetToken();
					mColumns = atoi( theString.ToCString() );
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
					mOutlineWidget = CxGroupBox::CreateCxGroupBox( this, (CxGrid *)GetWidget() );
					mText = tokenList->GetToken();
					SetText( mText );
					LOGSTAT( "Setting Grid outline" );
					break;
				}
				case kTAlignExpand:
				{
					tokenList->GetToken(); // Remove that token!
					mAlignment += kExpand;
					LOGSTAT( "Setting Grid alignment EXPAND" );
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
		mTheGrid = (CrGUIElement **) new int [ mRows * mColumns ];
		for (int i = 0; i < mRows*mColumns; i++)
			mTheGrid[i] = nil;
	
		mSelfInitialised = true;
	}
	// End of Init, now comes the general parser

	// If a child grid is incomplete pass the tokenlist straight down.
	//(This is rare, but it is possible for tokenLists to become fragmented
	//if some other command accidentally causes them to be processed before
	//they are complete.)

	if(mActiveSubGrid != nil)
	{
		// Sub Grid exists, testing for completeness...
		if (!mActiveSubGrid->GridComplete())
		{
			// Sub Grid incomplete passing tokenList...
			return retVal = mActiveSubGrid->ParseInput(tokenList);
		}
		else
		{
			mActiveSubGrid = nil;
		}
	}

	if( tokenList->GetDescriptor( kInstructionClass ) == kTNoMoreToken )
		return true;

	// This is either the end of this grid, the start of a new sub grid or
	// a sub element.

	switch ( tokenList->GetDescriptor( kInstructionClass ) )
	{
		case kTEndGrid:						// End this grid.
		{
			tokenList->GetToken();
			mGridComplete = true;
			LOGSTAT("CrGrid:ParseInput:EndGrid Grid closed");
			retVal = true;
			break;
		}
		case kTAt:
		{
			tokenList->GetToken();	
			CcString theString;
			theString = tokenList->GetToken();		// the next must be the row number
                  int ypos = atoi( theString.ToCString() );
			theString = tokenList->GetToken();		// the next must be the col number
                  int xpos = atoi( theString.ToCString() );
			switch ( tokenList->GetDescriptor( kInstructionClass ) )
			{
				case kTCreateGrid:					// Create a sub grid.
				{
					CrGrid * gridPtr = new CrGrid( this );
					if ( gridPtr != nil )
					{
						mActiveSubGrid = gridPtr;
						retVal = InitElement( gridPtr, tokenList, xpos, ypos );
					}
					break;
				}
				case kTCreateButton:				// Create a button
				{
					CrButton * buttPtr = new CrButton( this );
					if ( buttPtr != nil )
						retVal = InitElement( buttPtr, tokenList, xpos, ypos );
					break;
				}
				case kTCreateListBox:				// Create a ListBox
				{
					CrListBox * listPtr = new CrListBox( this );
					if ( listPtr != nil )
						retVal = InitElement( listPtr, tokenList, xpos, ypos );
					break;
				}
#ifdef __WINDOWS__
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
				case kTCreateDropDown:				// Create a DropDown
				{
					CrDropDown * dropDownPtr = new CrDropDown( this );
					if ( dropDownPtr != nil )
						retVal = InitElement( dropDownPtr, tokenList, xpos, ypos );
					break;
				}
				case kTCreateMultiEdit:				// Create a MultiEdit field
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
				case kTCreateEditBox:				// Create an edit box
				{
					CrEditBox * editBoxPtr = new CrEditBox( this );
					if ( editBoxPtr != nil )
						retVal = InitElement( editBoxPtr, tokenList, xpos, ypos );
					break;
				}
				case kTCreateText:					// Create a caption
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
				case kTCreateProgress:					// Create a progress bar
				{
					CrProgress * progressPtr = new CrProgress( this );
					if ( progressPtr != nil )
						retVal = InitElement( progressPtr, tokenList, xpos, ypos );
					break;
				}
				case kTCreateRadioButton:			// Create a Radio button
				{
					CrRadioButton * radioButtPtr = new CrRadioButton( this );
					if ( radioButtPtr != nil )
					{
						retVal = InitElement( radioButtPtr, tokenList, xpos, ypos );
//                                    ( (CxGrid *)mWidgetPtr )->AddRadioButton( (CxRadioButton *)radioButtPtr->GetWidget() );
					}
					break;
				}
				case kTCreateCheckBox:				// Create a CheckBox
				{
					CrCheckBox * checkBoxPtr = new CrCheckBox( this );
					if ( checkBoxPtr != nil )
						retVal = InitElement( checkBoxPtr, tokenList, xpos, ypos );
					break;
				}
				case kTCreateChart:				    // Create a Chart
				{
					CrChart * chartPtr = new CrChart( this );
					if ( chartPtr != nil )
						retVal = InitElement( chartPtr, tokenList, xpos, ypos );
					break;
				}
				case kTCreateModel:				    // Create a Chart
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
				default:
				{
					// No instruction following @ location
					// Remove the token for safety.
					CcString badtoken = tokenList->GetToken();
					//Moan
					LOGWARN("CrGrid:ParseInput:default No command after @location in grid:" + badtoken );
				}
			}

			break;		
		}
		
		default:
		{
			// No handler
			// Remove the token for safety.
			CcString badtoken = tokenList->GetToken();
			//Moan
			LOGWARN("CrGrid:ParseInput:default No Handler for current command:" + badtoken );
		}
	}
	return (retVal);
}

void	CrGrid::SetGeometry( const CcRect * rect )
{
	((CxGrid*)mWidgetPtr)->SetGeometry(	rect->mTop,
										rect->mLeft,
										rect->mBottom,
										rect->mRight );
	if ( mOutlineWidget != nil )
		mOutlineWidget->SetGeometry(	0,
										0,
										rect->mBottom - rect->mTop,
										rect->mRight - rect->mLeft );
	
}
CcRect	CrGrid::GetGeometry()
{
	CcRect retVal( 
			((CxGrid*)mWidgetPtr)->GetTop(), 
			((CxGrid*)mWidgetPtr)->GetLeft(),
			((CxGrid*)mWidgetPtr)->GetTop()+((CxGrid*)mWidgetPtr)->GetHeight(),
			((CxGrid*)mWidgetPtr)->GetLeft()+((CxGrid*)mWidgetPtr)->GetWidth()   );
	return retVal;
}

void	CrGrid::CalcLayout()
{
	LOGSTAT("CrGrid: CalcLayout Step 1: Calculating size of all children");
	
//STEP1 Call calclayout for child elements.
	int xp, yp;
	CrGUIElement *vtemp;
	
	for ( xp = 1; xp <= mColumns ; xp++)
	{
		for ( yp = 1; yp <= mRows ; yp++)
		{
			vtemp = GetPointer(xp,yp);
			if (vtemp != nil)
				((CrGUIElement*)vtemp)->CalcLayout();
		}
	}
	LOGSTAT("CrGrid: CalcLayout Step 2: find max height");

//STEP2 Loop along each row and find the maxHeight. Set height to this.
	int runningTotalHeight = 0;
	if(mOutlineWidget) runningTotalHeight += 2*EMPTY_CELL;
	for ( yp = 1; yp <= mRows ; yp++)
	{
		int maxHeight = GetHeightOfRow( yp );
		
		//We have now established maxHeight for this row
		//Now go back and set the height and position of all these elements.
		for ( xp = 1; xp <= mColumns ; xp++)
		{
			vtemp = GetPointer(xp,yp);
			if ( vtemp != nil )
			{
				CcRect rect;
				rect = vtemp->GetGeometry();
				CcRect newrect(runningTotalHeight,
							   rect.Left(),				// This specifies not to redraw the thing yet.
							   runningTotalHeight+maxHeight,
							   rect.Right() );
				vtemp->SetGeometry(&newrect);
			}
		}
		runningTotalHeight += maxHeight;
	}
	if(mOutlineWidget) runningTotalHeight += EMPTY_CELL;
	LOGSTAT("CrGrid: CalcLayout Step 3");

//STEP3 Loop down each column and find the maxWidth. Set width to this.

	int runningTotalWidth = 0;
	if(mOutlineWidget) runningTotalWidth += EMPTY_CELL;
	for ( xp = 1; xp <= mColumns ; xp++)
	{
		int maxWidth = GetWidthOfColumn( xp );
		//We have now established maxWidth for this column
		//Now go back and set the width and position of all these elements.
		for ( yp = 1; yp <= mRows ; yp++)
		{
			vtemp = GetPointer(xp,yp);
			if ( vtemp != nil )
			{
				CcRect rect;
				rect = vtemp->GetGeometry();
				CcRect newrect (rect.Top(),
								runningTotalWidth,
								rect.Bottom(),
								runningTotalWidth+maxWidth	);
				vtemp->SetGeometry(&newrect);
			}
		}
		runningTotalWidth += maxWidth;
	}

	if(mOutlineWidget) runningTotalWidth += EMPTY_CELL;
	
	LOGSTAT("CrGrid: CalcLayout Step 4");

//STEP4 Set Size to total size of children when placed.
	CcRect theRect, oldRect;
	theRect.Set(0,0,runningTotalHeight,runningTotalWidth);		
	SetGeometry( &theRect );

}

void  CrGrid::SetOriginalSizes()
{
// Call SetOriginalSizes() for child elements.
	int xp, yp;
	CrGUIElement *vtemp;
	
	for ( xp = 1; xp <= mColumns ; xp++)
	{
		for ( yp = 1; yp <= mRows ; yp++)
		{
			vtemp = GetPointer(xp,yp);
			if (vtemp != nil)
                        ((CrGUIElement*)vtemp)->SetOriginalSizes();
		}
	}
}

void	CrGrid::SetText( CcString item )
{
	char theText[256];
	strcpy( theText, item.ToCString() );

	if (mOutlineWidget != nil )
		mOutlineWidget->SetText( theText );
}

Boolean	CrGrid::GridComplete()
{
	return mGridComplete;
}

Boolean	CrGrid::InitElement( CrGUIElement * element, CcTokenList * tokenList, int xpos, int ypos)
{
	tokenList->GetToken(); //This is the element type (e.g. BUTTON). Remove it.
	
	if(!mXCanResize) mXCanResize = element->mXCanResize; // if an element in the grid can
	if(!mYCanResize) mYCanResize = element->mYCanResize; // resize, then the grid can aswell.
//BUT if the element is a grid, it doesn't yet know if it can resize!!!!
//This is why things in non-top level grids often don't resize.

	if(element->mTabStop)
		( (CrWindow*)GetRootWidget() )->AddToTabGroup(element);

	this->SetPointer ( xpos, ypos, element );

	// Parse the item specific stuff
	Boolean retVal = element->ParseInput( tokenList );
	if ( retVal )
		mItemList.AddItem( element );
	else
		delete element;
	
	return retVal;

}

void	CrGrid::Align()
{

	CcRect rect, newrect, gridRect;
	Boolean done = false;
	CrGUIElement * vtemp;
	
	if ( mAlignment &  kExpand )
	{
//		if ( doAdjust )
//		{
//			SetGeometry( &newrect );
			
			// If we have an outline widget we have to adjust that too
//			if ( mOutlineWidget != nil )
//				mOutlineWidget->SetGeometry(	0,
//												0,
//												newrect.Height(),
//												newrect.Width() );
//		}
		done = false;
	}

	if ( mAlignment & kRightAlign )
	{
		int xp, yp;
		
		gridRect = GetGeometry();
		int totalWidth = 0;
		for ( xp = 1; xp <= mColumns ; xp++)
		{
			totalWidth += GetWidthOfColumn( xp );
		}

		int delta = gridRect.Width() - totalWidth;
		
		for ( xp = 1; xp <= mColumns ; xp++)
		{
			for ( yp = 1; yp <= mRows ; yp++)
			{
				vtemp = GetPointer(xp,yp);
				if ( vtemp != nil )
				{
					rect = vtemp->GetGeometry();
					newrect = CcRect(	rect.Top()    - gridRect.Top(),
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
		for ( yp = 1; yp <= mRows ; yp++)
		{
			totalHeight += GetHeightOfRow( yp );
		}

		int delta = gridRect.Height() - totalHeight;
		
		for ( yp = 1; yp <= mRows ; yp++)
		{
			for ( xp = 1; xp <= mColumns ; xp++)
			{
				vtemp = GetPointer(xp,yp);
				if ( vtemp != nil )
				{
					rect = vtemp->GetGeometry();
					newrect = CcRect(	rect.Top()    - gridRect.Top()    + delta,
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
		
		for ( yp = 1; yp <= mRows ; yp++)
		{
			for ( xp = 1; xp <= mColumns ; xp++)
			{
				vtemp = GetPointer(xp,yp);
				if ( vtemp != nil )
					vtemp->Align();
			}
		}
	}
}

int	CrGrid::GetHeightOfRow( int row )
{
	CrGUIElement * elemPtr;
	int maxHeight = EMPTY_CELL, xp;
	for ( xp = 1; xp <= mColumns ; xp++)
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

int	CrGrid::GetWidthOfColumn( int col )
{
	CrGUIElement * elemPtr;
	int maxWidth = EMPTY_CELL, yp;
	for ( yp = 1; yp <= mRows ; yp++)
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

CrGUIElement *	CrGrid::FindObject( CcString Name )
{
	CrGUIElement * theElement = nil, * theItem;
	
	mItemList.Reset();
	theItem = (CrGUIElement *)mItemList.GetItemAndMove();
	
	while ( theItem != nil && theElement == nil )
	{
		theElement = theItem->FindObject( Name );
		theItem = (CrGUIElement *)mItemList.GetItemAndMove();
	}
		
	return ( theElement );
}

Boolean	CrGrid::SetPointer( int xpos, int ypos, CrGUIElement * ptr )
{
      if ((xpos > mColumns) || (ypos > mRows))
      {
            LOGWARN("Position of element out of range of grid size");
            return false;
      }
	*(mTheGrid + ( (xpos-1) + (ypos-1) * mColumns)) = ptr;
	return true;
}

CrGUIElement *	CrGrid::GetPointer( int xpos, int ypos )
{
	return *(mTheGrid + (xpos-1 + (ypos-1) * mColumns));
}

void CrGrid::Resize(int newWidth, int newHeight, int origWidth, int origHeight)
{
	int xp, yp;
	CrGUIElement *vtemp;
	int resizeableWidth = 0;
	int resizeableHeight = 0;
	int * colWidths = new int[mColumns];
	int * rowHeights= new int[mRows];

//Find out the width of each resizeable column
	
	for ( xp = 1; xp <= mColumns ; xp++)
	{
		int tempMaxWidth = 0;
		for ( yp = 1; yp <= mRows ; yp++)
		{
			vtemp = GetPointer(xp,yp);
			if (vtemp != nil)
			{
				if( ((CrGUIElement*)vtemp)->mXCanResize ) 
				{
					tempMaxWidth = max( tempMaxWidth,((CrGUIElement*)vtemp)->GetIdealWidth() );
				}
			}
		}
		colWidths[xp-1] =  tempMaxWidth;
		resizeableWidth += tempMaxWidth;
	}
	
//Find out the height of each resizeable row
	for ( yp = 1; yp <= mRows ; yp++)
	{
		int tempMaxHeight = 0;
		for ( xp = 1; xp <= mColumns ; xp++)
		{
			vtemp = GetPointer(xp,yp);
			if (vtemp != nil)
			{
				if( ((CrGUIElement*)vtemp)->mYCanResize ) 
				{
					tempMaxHeight = max( tempMaxHeight,((CrGUIElement*)vtemp)->GetIdealHeight() );
				}
			}
		}
		rowHeights[yp-1] =  tempMaxHeight;
		resizeableHeight += tempMaxHeight;
	}


//Adjust each element to take up the available space.
	for ( xp = 1; xp <= mColumns ; xp++)
	{
		for ( yp = 1; yp <= mRows ; yp++)
		{
			if (colWidths[xp-1] || rowHeights[yp-1])
			{
				vtemp = GetPointer(xp,yp);
				if (vtemp != nil)
				{
					int newColWidth  = int( (float)colWidths[xp-1] *(((float)(newWidth -origWidth) /(float)resizeableWidth) +1.0) );
					int newRowHeight = int( (float)rowHeights[yp-1]*(((float)(newHeight-origHeight)/(float)resizeableHeight)+1.0) );
					((CrGUIElement*)vtemp)->Resize(newColWidth,newRowHeight,colWidths[xp-1],rowHeights[yp-1]);
				}
			}
		}
	}


	delete colWidths;
	delete rowHeights;
}

int CrGrid::GetIdealWidth()
{
	int xp, yp;
	CrGUIElement *vtemp;
	int resizeableWidth = 0;

//Find out the total resizeable width of grid
	
	for ( xp = 1; xp <= mColumns ; xp++)	//loop each column
	{
		int tempMaxWidth = 0;
		for ( yp = 1; yp <= mRows ; yp++)   //loop each row
		{
			vtemp = GetPointer(xp,yp);
			if (vtemp != nil)
			{
				if( ((CrGUIElement*)vtemp)->mXCanResize ) 
				{
					tempMaxWidth = max( tempMaxWidth,((CrGUIElement*)vtemp)->GetIdealWidth() );
				}
			}
		} //end loop each row
		resizeableWidth += tempMaxWidth;
	} //end loop each column

	return resizeableWidth;
}
int CrGrid::GetIdealHeight()
{
	int xp, yp;
	CrGUIElement *vtemp;
	int resizeableHeight = 0;

//Find out the total resizeable width of grid
	
	for ( yp = 1; yp <= mRows ; yp++)   //loop each row
	{
		int tempMaxHeight = 0;
		for ( xp = 1; xp <= mColumns ; xp++)	//loop each column
		{
			vtemp = GetPointer(xp,yp);
			if (vtemp != nil)
			{
				if( ((CrGUIElement*)vtemp)->mYCanResize ) 
				{
					tempMaxHeight = max( tempMaxHeight,((CrGUIElement*)vtemp)->GetIdealHeight() );
				}
			}
		} //end loop each row
		resizeableHeight += tempMaxHeight;
	} //end loop each column

	return resizeableHeight;
}

void CrGrid::CrFocus()
{

}


void CrGrid::SendCommand(CcString theText, Boolean jumpQueue)
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
            if ( mCommandSet )
            {
                  mControllerPtr->SendCommand(mCommandText);
                  mControllerPtr->SendCommand(theText);
            }
            else
            {
                  mParentElementPtr->SendCommand(theText, jumpQueue); //Keep passing the text up the tree.
            }
      }
      else
      {
            if (       ( mCommandSet                )
                   &&  (!( theText.Sub(1,1) == '#' ))
                   &&  (!( theText.Sub(1,1) == '^' ))   )
            {
                  mControllerPtr->SendCommand(mCommandText);
                  mControllerPtr->SendCommand(theText);
            }
            else
            {
                  mParentElementPtr->SendCommand(theText, jumpQueue); //Keep passing the text up the tree.
            }
      }
}

void CrGrid::SetCommandText(CcString theText)
{
	mCommandText = theText;
	mCommandSet = true;
}
