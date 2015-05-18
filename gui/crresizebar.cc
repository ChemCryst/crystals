////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CrResizeBar.cc
//   Author:    Richard Cooper
//   $Log: not supported by cvs2svn $
//   Revision 1.13  2011/04/21 11:21:28  rich
//   Various WXS improvements.
//
//   Revision 1.12  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/06/29 15:15:30  rich
//   Remove references to unused kTNoMoreToken. Protect against reading
//   an empty list of tokens.
//
//   Revision 1.10  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.9  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.8  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.7  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.6  2002/01/16 14:12:40  ckp2
//   Further fix of resize bar woes.
//
//   Revision 1.5  2002/01/16 10:02:37  ckp2
//   Fix bug where resizing panes makes whole 'resize-control' jump to top
//   left of parent window. Never noticed before because in all cases the resize
//   has been in the top left position anyway.
//
//   Revision 1.4  2001/08/14 10:20:35  ckp2
//   Quirky new feature: Hold down CTRL and click on a resize-bar and the panes
//   will swap sides. Hold down SHIFT and click, and the panes will rotate by 90
//   degrees. Gives more control over screen layout, but is not intuitive as the
//   user can't SEE which panes belong to a given resize bar. Try it and see.
//   The new layout is not stored and will revert to original layout when window
//   is reopened (for the time being).
//
//   Revision 1.3  2001/06/17 15:14:14  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.2  2001/03/16 11:08:00  richard
//   Delete the window's children before deleting the window. Otherwise, the window
//   automatically deletes it's children as it is destroyed, leaving us in confusion.
//
//   Revision 1.1  2001/02/26 12:04:48  richard
//   New resizebar class. A resize control has two panes and the bar between them
//   can be dragged to change their relative sizes. If one of the panes is of fixed
//   width or height in the relevant direction, then the resize-bar contains a button
//   which will show or hide the fixed size item.
//

#include    "crystalsinterface.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    "crconstants.h"
#include    "ccrect.h"
#include    "crresizebar.h"
#include    "crgrid.h"
#include    "cxgrid.h"
#include    "crwindow.h"
#include    "cccontroller.h"
#include    "cxresizebar.h"



CrResizeBar::CrResizeBar( CrGUIElement * mParentPtr )
 : CrGUIElement( mParentPtr )
{
  ptr_to_cxObject = CxResizeBar::CreateCxResizeBar( this, (CxGrid *)(mParentPtr->GetWidget()) );
  m_offset = -1;
  m_type = kTVertical;
  m_firstitem = nil;
  m_seconditem = nil;
  m_firstNonSize = false;
  m_secondNonSize = false;
  m_NonSizePresent = false;
  m_BothNonSize = false;
  m_Reverse = false;
}


CrResizeBar::~CrResizeBar()
{

  if ( m_firstitem ) delete m_firstitem;
  if ( m_seconditem ) delete m_seconditem;
  ostringstream strm;
  strm << m_offset;
  (CcController::theController)->StoreKey( mName, strm.str() );
  if ( ptr_to_cxObject )
  {
    ((CxResizeBar*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
    delete (CxResizeBar*)ptr_to_cxObject;
#endif
    ptr_to_cxObject = nil;
  }
}

CRGETGEOMETRY(CrResizeBar,CxResizeBar)

void CrResizeBar::SetGeometry( const CcRect * rect )
{
  int nHeight = rect->mBottom - rect->mTop;
  int nWidth  = rect->mRight - rect->mLeft;
  CcRect firstrect, secondrect, thirdrect;

  if ( !m_NonSizePresent)
  {
    if ( m_type == kTHorizontal ) //   (NB. items arranged vertically)
    {
      firstrect.Set(0,0,(int)(((nHeight-SIZE_BAR)*m_offset)/1000.0f),nWidth);
      secondrect.Set((int)(((nHeight-SIZE_BAR)*m_offset)/1000.0f)+SIZE_BAR,0,nHeight,nWidth);
      thirdrect.Set((int)(((nHeight-SIZE_BAR)*m_offset)/1000.0f),0,(int)(((nHeight-SIZE_BAR)*m_offset)/1000.0f)+SIZE_BAR,nWidth);
    }
    else // (items arranged horizontally)
    {
      firstrect.Set(0,0,nHeight,(int)(((nWidth-SIZE_BAR)*m_offset)/1000.0f));
      secondrect.Set(0,(int)(((nWidth-SIZE_BAR)*m_offset)/1000.0f)+SIZE_BAR,nHeight,nWidth);
      thirdrect.Set(0,(int)(((nWidth-SIZE_BAR)*m_offset)/1000.0f),nHeight,(int)(((nWidth-SIZE_BAR)*m_offset)/1000.0f)+SIZE_BAR);
    }
  }
  else if ( !m_BothNonSize )
  {
    if ( m_type == kTHorizontal ) //   (NB. items arranged vertically)
    {
      if ( m_firstNonSize )
      {
        int fixedHeight = (int)(( m_InitHeight * m_InitOffset ) / 1000.0f );
        if ( m_offset == 0 ) fixedHeight = 0;
        firstrect.Set(0,0,fixedHeight,nWidth);
        secondrect.Set(fixedHeight+SIZE_BAR,0,nHeight,nWidth);
        thirdrect.Set(fixedHeight,0,fixedHeight+SIZE_BAR,nWidth);
      }
      else
      {
        int fixedHeight = (int)(( m_InitHeight * (1000-m_InitOffset) ) / 1000.0f );
        if ( m_offset == 1000 ) fixedHeight = 0;
        firstrect.Set(0,0,nHeight-fixedHeight-SIZE_BAR,nWidth);
        secondrect.Set(nHeight-fixedHeight,0,nHeight,nWidth);
        thirdrect.Set(nHeight-fixedHeight-SIZE_BAR,0,nHeight-fixedHeight,nWidth);
       }
    }
    else // (items arranged horizontally)
    {
      if ( m_firstNonSize )
      {
        int fixedWidth = (int)(( m_InitWidth * m_InitOffset ) / 1000.0f );
        if ( m_offset == 0 ) fixedWidth = 0;
        firstrect.Set(0,0,nHeight,fixedWidth);
        secondrect.Set(0,fixedWidth+SIZE_BAR,nHeight,nWidth);
        thirdrect.Set(0,fixedWidth,nHeight,fixedWidth+SIZE_BAR);
      }
      else
      {
        int fixedWidth = (int)(( m_InitWidth * (1000-m_InitOffset) ) / 1000.0f );
        if ( m_offset == 1000 ) fixedWidth = 0;
        firstrect.Set(0,0,nHeight,nWidth-fixedWidth-SIZE_BAR);
        secondrect.Set(0,nWidth-fixedWidth,nHeight,nWidth);
        thirdrect.Set(0,nWidth-fixedWidth-SIZE_BAR,nHeight,nWidth-fixedWidth);
      }
    }
  }

  if ( m_firstitem ) m_firstitem->SetGeometry(&firstrect);
  if ( m_seconditem ) m_seconditem->SetGeometry(&secondrect);
  ((CxResizeBar*)ptr_to_cxObject)->SetHotRect(&thirdrect);
  ((CxResizeBar*)ptr_to_cxObject)->SetGeometry( rect->mTop,    rect->mLeft,
                                           rect->mBottom, rect->mRight );
}




CcParse CrResizeBar::ParseInput( deque<string> & tokenList )
{
  CcParse retVal(true, mXCanResize, mYCanResize);
  bool hasTokenForMe = true;

// Initialization for the first time
  if( ! mSelfInitialised )
  {
    retVal = CrGUIElement::ParseInputNoText( tokenList );
    mSelfInitialised = true;
    LOGSTAT( "Created ResizeBar " + mName );
    string coffset = (CcController::theController)->GetKey( mName );
    if ( coffset.length() )
    {
      m_offset = atoi( coffset.c_str() );
      m_offset = CRMIN ( m_offset, 1000 );
      m_offset = CRMAX ( m_offset, 0 );
      if ( ( m_offset == 0 ) || ( m_offset == 1000) ) ((CxResizeBar*)ptr_to_cxObject)->AlreadyCollapsed();
    }
    else
    {
      m_offset = -1; //Set later in calclayout.
    }

    switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
    {
      case kTHorizontal:
      {
        tokenList.pop_front(); // Remove that token!
        ((CxResizeBar*)ptr_to_cxObject)->SetType( kTHorizontal );
        m_type = kTHorizontal;
        LOGSTAT( "Setting ResizeBar type: Horizontal" );
        break;
      }
      case kTVertical:
      {
        tokenList.pop_front(); // Remove that token!
                               // Run on into default case...
      }
      default:
      {
        ((CxResizeBar*)ptr_to_cxObject)->SetType( kTVertical );
        m_type = kTVertical;
        LOGSTAT( "Setting ResizeBar type: Vertical" );
        break; // We leave the token in the list and exit the loop
      }
    }

// Optional startgrid token used to line up syntax in scripts nicely.
    if (CcController::GetDescriptor( tokenList.front(), kAttributeClass ) == kTOpenGrid)
                            tokenList.pop_front();
    CcParse* parseVal = new CcParse[2];

    for ( int i = 0; i<2; i++ )
    {
     switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
     {
      case kTItem:
      {
        tokenList.pop_front(); // Remove that token!

        LOGSTAT("Adding Item to resize control. ");
        CrGrid* gridPtr = new CrGrid( this );
        if ( gridPtr != nil )
        {
          tokenList.pop_front();      // remove that token
          parseVal[i] = gridPtr->ParseInput( tokenList );
          if ( i==0 ) m_firstitem = gridPtr;
          else        m_seconditem= gridPtr;
        }
        break;
      }
      default:
      {
        LOGERR ( "Resizebar "+mName+" ITEM instruction not found");
      }
     }
    }
    if ( m_type == kTHorizontal )
    {
      m_firstNonSize  = !(parseVal[0].CanYResize());
      m_secondNonSize = !(parseVal[1].CanYResize());
      m_BothNonSize    = m_firstNonSize && m_secondNonSize;
      m_NonSizePresent = m_firstNonSize || m_secondNonSize;
      ((CxResizeBar*)ptr_to_cxObject)->WillNotResize(m_firstNonSize,m_secondNonSize);
    }
    else
    {
      m_firstNonSize  = !(parseVal[0].CanXResize());
      m_secondNonSize = !(parseVal[1].CanXResize());
      m_BothNonSize    = m_firstNonSize && m_secondNonSize;
      m_NonSizePresent = m_firstNonSize || m_secondNonSize;
      ((CxResizeBar*)ptr_to_cxObject)->WillNotResize(m_firstNonSize,m_secondNonSize);
    }
    retVal= CcParse(parseVal[0].OK() && parseVal[1].OK(),
                 parseVal[0].CanXResize()||parseVal[1].CanXResize(),
                 parseVal[0].CanYResize()||parseVal[1].CanYResize());
    delete [] parseVal;

  }
  else
  {
    LOGERR ( "Resizebar may not be updated after it is created");
  }

// Optional endgrid token used to line up syntax in scripts nicely.
  if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kAttributeClass ) == kTEndGrid)
                            tokenList.pop_front();

  return retVal;
}

CcRect CrResizeBar::CalcLayout(bool recalc)
{
  CcController::debugIndent++;
  LOGSTAT("CrResizeBar: " + mName + " CalcLayout Step 1: Calculating size of both children");

//STEP1 Call calclayout for child elements. Store their sizes.


  int totWidth, totHeight;
  int firstitemWidth, firstitemHeight;
  int seconditemWidth, seconditemHeight;
  int offset;

  if ( m_firstitem == nil )
  {
    firstitemWidth = EMPTY_CELL;
    firstitemHeight = EMPTY_CELL;
  }
  else
  {
    CcController::debugIndent++;
    CcRect rect;
    rect = m_firstitem->CalcLayout(recalc);
    firstitemWidth = rect.Width();
    firstitemHeight = rect.Height();
    CcController::debugIndent--;
  }

  if ( m_seconditem == nil )
  {
    seconditemWidth = EMPTY_CELL;
    seconditemHeight = EMPTY_CELL;
  }
  else
  {
    CcController::debugIndent++;
    CcRect rect;
    rect = m_seconditem->CalcLayout(recalc);
    seconditemWidth = rect.Width();
    seconditemHeight = rect.Height();
    CcController::debugIndent--;
  }

  LOGSTAT("CrResizeBar: " + mName + " CalcLayout Step 2: Setting positions of all children");

  if ( m_type == kTHorizontal ) //   (NB. items arranged vertically)
  {
     totWidth = CRMAX ( firstitemWidth, seconditemWidth );
     firstitemWidth = totWidth;
     seconditemWidth = totWidth;
     totHeight = firstitemHeight + seconditemHeight + SIZE_BAR;
     offset = (int)( 1000.0f * (float) firstitemHeight / (float)totHeight );
  }
  else // (items arranged horizontally)
  {
     totHeight = CRMAX ( firstitemHeight, seconditemHeight );
     firstitemHeight = totHeight;
     seconditemHeight = totHeight;
     totWidth  = firstitemWidth + seconditemWidth + SIZE_BAR;
     offset = (int)(1000.0f *  (float) firstitemWidth / (float)totWidth );
  }

  CcController::debugIndent--;

  if ( recalc )
  {
    m_InitWidth =  totWidth;
    m_InitHeight = totHeight;
    m_InitOffset = offset;
    if ( m_offset < 0 ) m_offset = offset;
  }

  return CcRect( 0,0, totHeight, totWidth );

}

void CrResizeBar::SetText ( const string &cText )
{
  LOGERR ( "Resizebar doesn't have TEXT in it: " + cText);
}


int CrResizeBar::GetIdealWidth()
{
    return (int) ( EMPTY_CELL );
}
int CrResizeBar::GetIdealHeight()
{
    return (int) ( EMPTY_CELL );
}

void CrResizeBar::CrFocus()
{
}


void CrResizeBar::MoveResizeBar(int offset)
{
// The variable m_offset should run from 0 to +1000.
   m_offset = CRMIN ( offset, 1000 );
   m_offset = CRMAX ( m_offset, 0 );

// Set new sizes
   CcRect child    = GetGeometry();
#ifdef CRY_USEMFC
   CcRect parent   = mParentElementPtr->GetGeometry();
#else
   CcRect parent   = mParentElementPtr->GetGeometry();
//   CcRect parent   = CcRect(0,0,0,0);
#endif
   CcRect relative;

   relative.Set(child.Top()  - parent.Top(),
                child.Left() - parent.Left(),
                child.Bottom()-parent.Top(),
                child.Right()- parent.Left());

   SetGeometry(&relative);

// Force repaint of entire window.
   ((CrWindow*)GetRootWidget())->Redraw();
}


CrGUIElement *  CrResizeBar::FindObject( const string & Name )
{
  CrGUIElement * theElement = nil;

  if ( m_firstitem ) theElement = m_firstitem->FindObject( Name );
  if ( !theElement && m_seconditem ) theElement = m_seconditem->FindObject( Name );
  return ( theElement );
}

void CrResizeBar::Collapse(bool collapse)
{
   if ( m_firstNonSize ) MoveResizeBar ( collapse ? 0    : m_InitOffset );
   else                  MoveResizeBar ( collapse ? 1000 : m_InitOffset );
}

void CrResizeBar::SwapPanes()
{
   m_Reverse = !m_Reverse;
   CrGUIElement* gtemp = m_firstitem;
   m_firstitem = m_seconditem;
   m_seconditem = gtemp;
   bool btemp = m_firstNonSize;
   m_firstNonSize  = m_secondNonSize;
   m_secondNonSize = btemp;
   ((CxResizeBar*)ptr_to_cxObject)->WillNotResize(m_firstNonSize,m_secondNonSize);
   m_InitOffset = 1000 - m_InitOffset;
   MoveResizeBar(1000-m_offset);
}

void CrResizeBar::SwapOrient()
{
   m_Rotate = !m_Rotate;
   if ( m_type == kTHorizontal ) m_type = kTVertical;
   else                          m_type = kTHorizontal;

   ((CxResizeBar*)ptr_to_cxObject)->SetType ( m_type );

   CalcLayout ( true );

   MoveResizeBar(m_offset);
}
