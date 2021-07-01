////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CxIcon.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.6  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.5  2001/06/17 14:41:05  richard
//   CxDestroyWindow function.
//   Icons not available under wx - replace with text strings for now - could eventually
//   use bitmaps instead.
//
//   Revision 1.4  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//


#include    "crystalsinterface.h"
#include    "crconstants.h" //unusual, but used for kTIcon<Type>.
#include    "cxicon.h"
#include    <wx/artprov.h>
#include    "cxgrid.h"
#include    "cricon.h"
#include    "cccontroller.h"

#define kIconBase 56000

CxIcon *    CxIcon::CreateCxIcon( CrIcon * container, CxGrid * guiParent )
{
      CxIcon      *theText = new CxIcon( container );
      theText->Create(guiParent, -1);
      return theText;
}

CxIcon::CxIcon( CrIcon * container )
      :BASETEXT()
{
    ptr_to_crObject = container;
    mWidth = 10;
	mHeight = 10;
    mbOkToDraw = false;
}

CxIcon::~CxIcon()
{
}

void CxIcon::CxDestroyWindow()
{
Destroy();
}


//wx Message Table
BEGIN_EVENT_TABLE(CxIcon, wxWindow)
      EVT_PAINT( CxIcon::OnPaint )
END_EVENT_TABLE()

void CxIcon::OnPaint(wxPaintEvent & evt)
{
  wxPaintDC dc(this);
  if (!mbOkToDraw) return;
  dc.DrawBitmap(mbitmap,0,0,false);
}


CXSETGEOMETRY(CxIcon)
CXGETGEOMETRIES(CxIcon)


int   CxIcon::GetIdealWidth()
{
    return mWidth;
}

int   CxIcon::GetIdealHeight()
{
    return mHeight;
}

void CxIcon::SetHelpText( const string &text )
{
    SetToolTip(text);
}

void CxIcon::SetIconType( int iIconId )
{
      switch ( iIconId )
      {
            case kTIconInfoSmall:
			     mbitmap = wxArtProvider::GetIcon( wxART_INFORMATION, wxART_OTHER, wxSize(16,16) );
                 break;
            case kTIconInfo:
			     mbitmap = wxArtProvider::GetIcon( wxART_INFORMATION );
                 break;
            case kTIconWarnSmall:
			     mbitmap = wxArtProvider::GetIcon( wxART_WARNING, wxART_OTHER, wxSize(16,16) );
                 break;
            case kTIconWarn:
			     mbitmap = wxArtProvider::GetIcon( wxART_WARNING );
                 break;
            case kTIconErrorSmall:
			     mbitmap = wxArtProvider::GetIcon( wxART_ERROR, wxART_OTHER, wxSize(16,16) );
                 break;
            case kTIconError:
			     mbitmap = wxArtProvider::GetIcon( wxART_ERROR );
                 break;
            case kTIconQuerySmall:
			     mbitmap = wxArtProvider::GetIcon( wxART_QUESTION, wxART_OTHER, wxSize(16,16) );
				 break;
            case kTIconQuery:
            default:
			     mbitmap = wxArtProvider::GetIcon( wxART_QUESTION );
                 break;
      }
	  
      mWidth = mbitmap.GetWidth();
      mHeight = mbitmap.GetHeight();
      mbOkToDraw = true;
  
	  return;
}
