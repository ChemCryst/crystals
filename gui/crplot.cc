////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CrPlot.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:20
//
//   $Log: not supported by cvs2svn $
//   Revision 1.16  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.15  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.14  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.13  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.12  2002/07/18 16:49:49  richard
//   Clear plot window if empty graph (no data points) is created.
//
//   Revision 1.11  2002/03/07 10:46:44  DJWgroup
//   SH: Change to fix reversed y axes; realign text labels.
//
//   Revision 1.10  2002/02/21 15:23:12  DJWgroup
//   SH: 1) Allocate memory for series individually (saves wasted memory if eg. straight line on Fo/Fc plot has only 2 points). 2) Fiddled with axis labels. Hopefully neater now.
//
//   Revision 1.9  2002/02/20 12:05:20  DJWgroup
//   SH: Added class to allow easier passing of mouseover information from plot classes.
//
//   Revision 1.8  2002/02/19 16:34:52  ckp2
//   Menus for plots.
//
//   Revision 1.7  2002/02/18 11:21:13  DJWgroup
//   SH: Update to plot code.
//
//   Revision 1.6  2001/12/13 16:20:32  ckpgroup
//   SH: Cleaned up the key code. Now redraws correctly, although far too often.
//   Some problems with mouse-move when key is enabled. Fine when disabled.
//
//   Revision 1.5  2001/12/12 16:02:26  ckpgroup
//   SH: Reorganised script to allow right-hand y axes.
//   Added floating key if required, some redraw problems.
//
//   Revision 1.4  2001/11/26 18:38:49  ckp2
//
//   RIC: Ensure that GetDataFromPoint always returns a value, even if there is no attached plot.
//
//   Revision 1.3  2001/11/26 14:02:50  ckpgroup
//   SH: Added mouse-over message support - display label and data value for the bar
//   under the pointer.
//
//   Revision 1.2  2001/11/12 16:24:30  ckpgroup
//   SH: Graphical agreement analysis
//
//   Revision 1.1  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crplot.h"
#include    "crgrid.h"
#include    "cxplot.h"
#include    "ccplotdata.h"
#include    "ccrect.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "cccontroller.h"    // for sending commands
#include    "crwindow.h" // for getting cursor keys
#include <string>
#include <sstream>


#ifdef __BOTHWX__
// These macros are being defined somewhere. They shouldn't be.

#ifdef GetCharWidth
 #undef GetCharWidth
#endif
#ifdef DrawText
 #undef DrawText
#endif

#endif


CrPlot::CrPlot( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxPlot::CreateCxPlot( this,
                                (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
    mXCanResize = true;
    mYCanResize = true;
    attachedPlotData = nil;
    m_cmenu = nil;
}

CrPlot::~CrPlot()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxPlot*)ptr_to_cxObject)->CxDestroyWindow(); 
#ifdef __CR_WIN__
        delete (CxPlot*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }

    if(attachedPlotData != nil)
    {
        if (attachedPlotData==CcPlotData::sm_CurrentPlotData)
            CcPlotData::sm_CurrentPlotData = nil;
        delete attachedPlotData;
    }

    if(m_cmenu != nil)
    {
        delete m_cmenu;
        m_cmenu = nil;
    }
}

CcParse CrPlot::ParseInput( deque<string> & tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Plot *** Initing...");

        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created Plot      " + mName );

        //Init only parsing
        bool hasTokenForMe = true;
        while (hasTokenForMe && ! tokenList.empty())
        {
            switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
            {
                case kTNumberOfRows:
                {
                    tokenList.pop_front(); // Remove that token!
                    ((CxPlot*)ptr_to_cxObject)->SetIdealHeight( atoi( tokenList.front().c_str() ) );
                    LOGSTAT( "Setting Plot Lines Height: " + tokenList.front() );
                    tokenList.pop_front(); // Remove that token!
                    break;
                }
                case kTNumberOfColumns:
                {
                    tokenList.pop_front(); // Remove that token!
                    ((CxPlot*)ptr_to_cxObject)->SetIdealWidth( atoi( tokenList.front().c_str() ) );
                    LOGSTAT( "Setting Plot Chars Width: " + tokenList.front() );
                    tokenList.pop_front();
                    break;
                }
                default:
                {
                    hasTokenForMe = false;
                    break; // We leave the token in the list and exit the loop
                }
            }
        }
    }
    // End of Init, now comes the general parser

    bool hasTokenForMe = true;
    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTTextSelector:
            {
                tokenList.pop_front(); // Remove that token!
                mText = string(tokenList.front());
                tokenList.pop_front();
                SetText( mText );
                LOGSTAT( "Setting Plot Text: " + mText );
                break;
            }

            case kTPlotPrint:
            { 
                tokenList.pop_front(); 
                ((CxPlot*)ptr_to_cxObject)->PrintPicture(); 
                break; 
            } 

            case kTPlotSave:
            {
                tokenList.pop_front();  // "SAVE"
                int w = atoi( tokenList.front().c_str() );
                tokenList.pop_front();
                int h = atoi( tokenList.front().c_str() );
                tokenList.pop_front();
                string name = string(tokenList.front());
                tokenList.pop_front();
                ((CxPlot*)ptr_to_cxObject)->MakeMetaFile(w,h,name);
                break;
            }
      case kTDefinePopupMenu:
      {
        tokenList.pop_front();
        LOGSTAT("Defining Popup Plot Menu...");
        m_cmenu = new CrMenu( this, POPUP_MENU );
        if ( m_cmenu != nil )
        {
// ParseInput generates all objects in the menu
           CcParse menuP = m_cmenu->ParseInput( tokenList );
           if ( ! menuP.OK() )
           {
             delete m_cmenu;
             m_cmenu = nil;
           }
        }
        break;
      }
      case kTEndDefineMenu:
      {
        tokenList.pop_front();
        LOGSTAT("Popup Plot Menu Defined.");
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

CRSETGEOMETRY(CrPlot,CxPlot)
CRGETGEOMETRY(CrPlot,CxPlot)
CRCALCLAYOUT(CrPlot,CxPlot)

void CrPlot::CrFocus()
{
    ((CxPlot*)ptr_to_cxObject)->Focus();
}

void CrPlot::SetText( const string &text )
{
    ( (CxPlot *)ptr_to_cxObject)->SetText( text );
}


void CrPlot::DrawEllipse(int x, int y, int w, int h, bool fill)
{
    ((CxPlot*)ptr_to_cxObject)->DrawEllipse(x,y,w,h,fill);
}

void CrPlot::DrawRect(int x1, int y1, int x2, int y2, bool fill)
{
    int temp[10];
    temp[0] = x1; temp[1] = y1;
    temp[2] = x1; temp[3] = y2;
    temp[4] = x2; temp[5] = y2;
    temp[6] = x2; temp[7] = y1;
    temp[8] = x1; temp[9] = y1;
    DrawPoly(5,&temp[0],fill);
}

void CrPlot::DrawPoly(int nVertices, int * vertices, bool fill)
{
    ((CxPlot*)ptr_to_cxObject)->DrawPoly(nVertices, vertices, fill);
}

//STEVE added a justification parameter
//RICHARD added a fontsize
void CrPlot::DrawText(int x, int y, string text, int param, int fontsize)
{
    ((CxPlot*)ptr_to_cxObject)->DrawText(x, y, text, param, fontsize);
}

CcPoint CrPlot::GetTextArea(int size, string text, int param)
{
    return ((CxPlot*)ptr_to_cxObject)->GetTextArea(size,text,param);
}

// STEVE changed cx plot to accept a line thickness
void CrPlot::DrawLine(int thickness, int x1, int y1, int x2, int y2)
{
    ( (CxPlot *)ptr_to_cxObject)->DrawLine(thickness, x1, y1, x2, y2);
}

void CrPlot::Clear()
{
    ((CxPlot*)ptr_to_cxObject)->Clear();
    ((CxPlot*)ptr_to_cxObject)->Display();
}

// STEVE added this function
void CrPlot::SetColour(int r, int g, int b)
{
    ((CxPlot*)ptr_to_cxObject)->SetColour(r,g,b);
}

void CrPlot::Display()
{
    ( (CxPlot *)ptr_to_cxObject)->Display();
}

// redraw the view. If print==true, the background rectangle is not drawn (save ink for printing)
void CrPlot::ReDrawView(bool print)
{
    if(attachedPlotData)
        attachedPlotData->DrawView(print);
}

void CrPlot::Attach(CcPlotData * doc)
{
    //If there is already an attached Plot, (and it's not the same as the new one) delete it.
    if( (attachedPlotData) && (doc != attachedPlotData) )
        delete attachedPlotData;
    attachedPlotData = doc;
}

int CrPlot::GetIdealWidth()
{
    return ((CxPlot*)ptr_to_cxObject)->GetIdealWidth();
}
int CrPlot::GetIdealHeight()
{
    return ((CxPlot*)ptr_to_cxObject)->GetIdealHeight();
}

PlotDataPopup CrPlot::GetDataFromPoint(CcPoint* point)
{
    if(attachedPlotData) return attachedPlotData->GetDataFromPoint(point);
    else
    {
        PlotDataPopup null;
        return null;
    }
}

void CrPlot::CreateKey(int numser, string* names, int** col)
{
    ((CxPlot*)ptr_to_cxObject)->CreateKey(numser, names, col);
}

void CrPlot::ContextMenu(CcPoint * xy, int x1, int y1)
{
    if ( !m_cmenu ) return;
    if(!attachedPlotData) return;

    PlotDataPopup data = attachedPlotData->GetDataFromPoint(xy);

    if (data.m_Valid == true)
    {
        m_cmenu->Substitute(data);
        if ( ptr_to_cxObject ) m_cmenu->Popup(x1,y1,(void*)ptr_to_cxObject);
    }
}

void CrPlot::MenuSelected(int id)
{
    CcMenuItem* menuItem = CrMenu::FindMenuItem( id );

    if ( menuItem )
    {
        string theCommand = menuItem->command;
        SendCommand(theCommand);
        return;
    }

    ostringstream strm;
    strm << "CrPlot:MenuSelected Plot cannot find menu item id = " << id ;
    LOGERR(strm.str());
    return;
}

void CrPlot::FlipGraph(bool flip)
{
    ((CxPlot*)ptr_to_cxObject)->FlipGraph(flip);
}
