////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrPlot

////////////////////////////////////////////////////////////////////////

//   Filename:  CrPlot.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   09.11.2001 23:20
//
//   $Log: not supported by cvs2svn $
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
#include    "cctokenlist.h"
#include    "crmenu.h"
#include    "ccmenuitem.h"
#include    "cccontroller.h"    // for sending commands
#include    "crwindow.h" // for getting cursor keys

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
}

CcParse CrPlot::ParseInput( CcTokenList * tokenList )
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
        Boolean hasTokenForMe = true;
        while (hasTokenForMe)
        {
            switch ( tokenList->GetDescriptor(kAttributeClass) )
            {
                case kTNumberOfRows:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxPlot*)ptr_to_cxObject)->SetIdealHeight( chars );
                    LOGSTAT( "Setting Plot Lines Height: " + theString );
                    break;
                }
                case kTNumberOfColumns:
                {
                    tokenList->GetToken(); // Remove that token!
                    CcString theString = tokenList->GetToken();
                    int chars = atoi( theString.ToCString() );
                    ((CxPlot*)ptr_to_cxObject)->SetIdealWidth( chars );
                    LOGSTAT( "Setting Plot Chars Width: " + theString );
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

    Boolean hasTokenForMe = true;
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting Plot Text: " + mText );
                break;
            }

			case kTPlotPrint:
            { 
                tokenList->GetToken(); 
                ((CxPlot*)ptr_to_cxObject)->PrintPicture(); 
                break; 
            } 

			case kTPlotSave:
            {
                tokenList->GetToken();	// "PLOTSAVE"
                int w = atoi( tokenList->GetToken().ToCString() );
                int h = atoi( tokenList->GetToken().ToCString() );
                ((CxPlot*)ptr_to_cxObject)->MakeMetaFile(w,h);
                break;
            }
      case kTDefinePopupMenu:
      {
        tokenList->GetToken();
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
        tokenList->GetToken();
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

void CrPlot::SetText( CcString text )
{
    char theText[256];
    strcpy( theText, text.ToCString() );
    ( (CxPlot *)ptr_to_cxObject)->SetText( theText );
}


void CrPlot::DrawEllipse(int x, int y, int w, int h, Boolean fill)
{
    ((CxPlot*)ptr_to_cxObject)->DrawEllipse(x,y,w,h,fill);
}

void CrPlot::DrawRect(int x1, int y1, int x2, int y2, Boolean fill)
{
    int temp[10];
    temp[0] = x1; temp[1] = y1;
    temp[2] = x1; temp[3] = y2;
    temp[4] = x2; temp[5] = y2;
    temp[6] = x2; temp[7] = y1;
    temp[8] = x1; temp[9] = y1;
    DrawPoly(5,&temp[0],fill);
}

void CrPlot::DrawPoly(int nVertices, int * vertices, Boolean fill)
{
    ((CxPlot*)ptr_to_cxObject)->DrawPoly(nVertices, vertices, fill);
}

//STEVE added a justification parameter
//RICHARD added a fontsize
void CrPlot::DrawText(int x, int y, CcString text, int param, int fontsize)
{
    ((CxPlot*)ptr_to_cxObject)->DrawText(x, y, text, param, fontsize);
}

CcPoint CrPlot::GetTextArea(int size, CcString text, int param)
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

void CrPlot::CreateKey(int numser, CcString* names, int** col)
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
    CcMenuItem* menuItem = (CcController::theController)->FindMenuItem( id );

    if ( menuItem )
    {
        CcString theCommand = menuItem->command;
        SendCommand(theCommand);
        return;
    }

    LOGERR("CrPlot:MenuSelected Plot cannot find menu item id = " + CcString(id));
    return;
}
