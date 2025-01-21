////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMenu

////////////////////////////////////////////////////////////////////////

#include    "crystalsinterface.h"
#include    <string>
#include    <sstream>
#include <stdint.h>
using namespace std;
#include    "cccontroller.h"
#include    "crmenu.h"
#include    "cxmenu.h"


int CxMenu::mMenuCount = kMenuBase;
CxMenu *    CxMenu::CreateCxMenu( CrMenu * container, CxMenu * guiParent, bool popup )
{
    wxImage::AddHandler(new wxPNGHandler);  // For handling PNGs.
    CxMenu  *theMenu = new CxMenu( container );
    return theMenu;
}

CxMenu::CxMenu( CrMenu * container )
:BASEMENU()
{
    ptr_to_crObject = container;
}

CxMenu::~CxMenu()
{
}

//To do: Add by position

int CxMenu::AddMenu(CxMenu * menuToAdd, const string & text, int position)
{
      int id = CrMenu::FindFreeMenuId();
      Append( id, text.c_str(), menuToAdd);
      ostringstream strm;
      strm <<  "cxmenu " << (uintptr_t)this << " adding submenu called " << text;
      LOGSTAT ( strm.str() );
      return id;
}

int CxMenu::AddItem(const string & text, const string & iconfile, int position)
{
      int id = CrMenu::FindFreeMenuId();
      wxMenuItem* item = new wxMenuItem( this, id,  wxString(text.c_str()) );

      if ( iconfile.length() > 0 ) {

		  string crysdir ( getenv("CRYSDIR") );
		  if ( crysdir.length() > 0 ) {
			  int nEnv = (CcController::theController)->EnvVarCount( crysdir );
			  int i = 0;
			  bool noLuck = true;
			  while ( noLuck && i < nEnv )
			  {
				  string dir = (CcController::theController)->EnvVarExtract( crysdir, i );
				  i++;
		#ifdef CRY_OSWIN32
				  string file = dir + "script\\" + iconfile;
		#else
				  string file = dir + "script/" + iconfile;
		#endif

	//             wxMessageBox(file,"CcController");


		//  	LOGERR("Adding script dir icon");
				  struct stat buf;
				  if ( stat(file.c_str(),&buf)==0 ) {
                    wxImage myimage ( file.c_str(), wxBITMAP_TYPE_ANY );
                    if ( ! myimage.HasAlpha() ) {  //If no transparency, assume 0,0 pixel is background colour and remove it.
                        unsigned char tr = myimage.GetRed(0,0);
                        unsigned char tg = myimage.GetGreen(0,0);
                        unsigned char tb = myimage.GetBlue(0,0);
                        wxColour ncol = wxSystemSettings::GetColour(wxSYS_COLOUR_3DLIGHT);
                        for (int x = 0; x < myimage.GetWidth(); ++x ) {
                            for (int y = 0; y < myimage.GetHeight(); ++y ) {
                                if ( myimage.GetRed(x,y) == tr ) {
                                    if ( myimage.GetGreen(x,y) == tg ) {
                                        if ( myimage.GetBlue(x,y) == tb ) {
                                            myimage.SetRGB(x,y,ncol.Red(),ncol.Green(),ncol.Blue());
                                        }
                                    }
                                }
                            }
                        }
                    }
					wxBitmap mymap ( myimage, -1 );
					if( mymap.Ok() )
					  noLuck = false;
					  item->SetBitmap(mymap);
				  }
			  }
		  }
	  }
	  
	  Append(item);
//	  Append( id, wxString(text.c_str()), wxString("") );
	  
      ostringstream strm;
      strm << "cxmenu " << (uintptr_t)this << " adding item called " << text ;
      LOGSTAT (strm.str());
    return id;
}

int CxMenu::AddItem(int position)
{
      int id = CrMenu::FindFreeMenuId();
      AppendSeparator();
    return id;
}


void CxMenu::SetText(const string & theText, int id)
{
      SetLabel( id, theText.c_str() );
}

void CxMenu::SetTitle(const string & theText, CxMenu* ptr)
{
      wxMenu::SetTitle( theText.c_str() );
}

void CxMenu::PopupMenuHere(int x, int y, void *window)
{
// This is handled by the window class. But that's easy:
      ((wxWindow*)window)->PopupMenu(this, x, y);
}

void CxMenu::EnableItem( int id, bool enable )
{
         Enable( id, enable );
}
