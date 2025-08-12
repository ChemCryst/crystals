////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxEditBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.27  2011/04/15 15:05:43  rich
//   Fix event mechanism.
//
//   Revision 1.26  2011/03/04 06:01:10  rich
//   Fix font retreival on wx
//
//   Revision 1.25  2008/09/22 12:31:37  rich
//   Upgrade GUI code to work with latest wxWindows 2.8.8
//   Fix startup crash in OpenGL (cxmodel)
//   Fix atom selection infinite recursion in cxmodlist
//
//   Revision 1.24  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.2  2005/01/12 13:15:56  rich
//   Fix storage and retrieval of font name and size on WXS platform.
//   Get rid of warning messages about missing bitmaps and toolbar buttons on WXS version.
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.23  2004/10/06 13:57:26  rich
//   Fixes for WXS version.
//
//   Revision 1.22  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.21  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.20  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.19  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.18  2002/11/06 10:59:09  rich
//   New function in string to return a double with a specified precision (sig figs)
//   Called from editbox to allow 7 digits of precision.
//
//   Revision 1.17  2001/12/12 14:18:40  ckp2
//   RIC: Mousewheel support! (Guess who's just got a new mouse.)
//   RIC: Also PGUP and PGDOWN and Mousewheel allow the textoutput to be
//   scrolled *even* *if* there is a dialog blocking other input. V. useful
//   as some dialog questions can be better answered after reviewing what
//   has happened in the text output.
//
//   Revision 1.16  2001/07/14 18:43:53  ckp2
//   Bugfix: User could not enter - symbol into numerical input edit boxes. Oops.
//
//   Revision 1.15  2001/06/18 12:48:25  richard
//   Exclude windows beep function from linux version, when editbox reaches
//   its character limit.
//
//   Revision 1.14  2001/06/17 14:43:40  richard
//   CxDestroyWindow function.
//   Get font from winsizes file. (Can be set via "Appearence" menu.)
//
//   Revision 1.13  2001/03/08 15:51:30  richard
//   Limit number of characters if required.
//

#include    "crystalsinterface.h"
#include    <string>
#include    <sstream>
using namespace std;
#include    "cxeditbox.h"
#include    "cccontroller.h"
#include    "cxgrid.h"
#include    "cxwindow.h"
#include    "creditbox.h"
#include    "crtextout.h"
#ifdef CRY_USEWX
 #include <ctype.h> //for proto of iscntrl()
 #include <wx/utils.h> //for wxBell!

// These macros are being defined somewhere. They shouldn't be.

 #ifdef GetCharWidth
  #undef GetCharWidth
 #endif
 #ifdef DrawText
  #undef DrawText
 #endif
#endif


int CxEditBox::mEditBoxCount = kEditBoxBase;


CxEditBox * CxEditBox::CreateCxEditBox( CrEditBox * container, CxGrid * guiParent )
{
//As with all these Cx classes, this is a static funtion. Call it to create an editbox,
//and it will do the initialisation for you.

    CxEditBox   *theEditBox = new CxEditBox( container );
      theEditBox->Create(guiParent, -1, "edit", wxDefaultPosition, wxDefaultSize, wxTE_PROCESS_ENTER);
    return theEditBox;
}
CxEditBox::CxEditBox( CrEditBox * container )
      :BASEEDITBOX()
{
   ptr_to_crObject = container;      //This is the container (CrEditBox)
  mCharsWidth = 50;          //This is the default width if none is specified.
  allowedInput = CXE_TEXT_STRING;  //This is the default allowed input. See header file for other types.
  m_Limit = 32767; //Stupidly long limit for unlimited edit boxes.
  m_IsInput = false;
}

CxEditBox::~CxEditBox()
{
    RemoveEditBox();
}

void CxEditBox::CxDestroyWindow()
{
Destroy();
}

void  CxEditBox::SetText( const string & text )
{
    ostringstream strm;
    string temp;

    if(allowedInput == CXE_INT_NUMBER)        //If we have an integer, read it in then write it out again to check.
    {
      strm << atoi(text.c_str());
      temp = strm.str();
    }
    else if( allowedInput == CXE_REAL_NUMBER) //If we have an real, read it in then write it out again to check.
    {
      strm << atof(text.c_str());
      temp = strm.str();
    }
    else
    {
      temp = text;
    }

//    string::size_type j = temp.find_last_not_of(' ');
//    if ( j != string::npos ) temp.erase(j+1);

    if ( temp.length() > m_Limit )
    {
       temp.erase(m_Limit);
    }
      SetValue( temp.c_str() );
	  mPreviousText = temp;
}


void  CxEditBox::AddText( const string & text )
{
      AppendText(text.c_str());
      SetFocus();
	mPreviousText = GetText(); 
}

CXSETGEOMETRY(CxEditBox)

CXGETGEOMETRIES(CxEditBox)


int CxEditBox::GetIdealWidth()
{
      return mCharsWidth;
}

int CxEditBox::GetIdealHeight()
{
      int cx, cy;
      GetTextExtent( "Some text", &cx, &cy ) ;
      return cy + 5;
}

string CxEditBox::GetText()
{
      char theText[255];
      wxString wtext = GetValue();
      int textlen = wtext.length();
      strcpy(theText, wtext.c_str());

//If the allowed input is a number, check it before returning.
//It should be a number, if it isn't 0 or 0.0 will be returned.
    if(allowedInput == CXE_INT_NUMBER)
    {
        int number = atoi(theText);
        sprintf(theText,"%-d",number);
    }
    else if( allowedInput == CXE_REAL_NUMBER)
    {
        double number = atof(theText);
        sprintf(theText,"%-f",number);
    }
    return string( theText );
}

void    CxEditBox::SetVisibleChars( int count )
{
      mCharsWidth = count * GetCharWidth();
}

void    CxEditBox::EditChanged()
{
    ((CrEditBox*)ptr_to_crObject)->BoxChanged();  //Inform container that the text has changed.
}

//wx Message Table
BEGIN_EVENT_TABLE(CxEditBox, BASEEDITBOX)
      EVT_CHAR( CxEditBox::OnChar )
      EVT_KEY_DOWN( CxEditBox::OnKeyDown )
      EVT_KEY_UP( CxEditBox::OnKeyUp )
END_EVENT_TABLE()


void CxEditBox::Focus()
{
    SetFocus();
    SetInsertionPoint( GetLineLength(0) );  //Place caret at end of text.

}


void CxEditBox::OnChar( wxKeyEvent & event )
{
      int nChar = event.GetKeyCode();

      if ( nChar == 9 )
    {
             bool shifted = event.m_shiftDown;
             ptr_to_crObject->NextFocus(shifted);
      }
    else if ( allowedInput == CXE_READ_ONLY )
    {
        return;
    }
      else if ( nChar == 13 ) //RETURN.
    {
        ((CrEditBox*)ptr_to_crObject)->ReturnPressed();
    }
    else
    {
//Block unwanted keypresses...
        char c = (char) nChar;
        
		if(( nChar > 127 ) || iscntrl( nChar )) //It it a control char (delete, arrow keys), let it through
        {
			event.Skip();
            return;
        }
        if( allowedInput != CXE_TEXT_STRING ) //It's not text (it's a number).
        {
            if (((c < '0') || (c > '9')) && (c != '.') && ( c != '-')) {wxBell(); return;} //If it is non numeric, and not '.', then ignore.
        }

        if( allowedInput == CXE_INT_NUMBER ) //It's an integer.
        {
            if ( c == '.' ) {wxBell(); return;} //If it's a dot, ignore.
        }

        event.Skip();
        return;
    }
}
void CxEditBox::OnKeyUp( wxKeyEvent & event )
{
    int nChar = event.GetKeyCode();

	if ( allowedInput != CXE_READ_ONLY )
    {
		if ( mPreviousText != GetText() ) {
			mPreviousText = GetText();
            EditChanged();
		}
    }

	event.Skip();

    return;
}



void CxEditBox::Disable(bool disable)
{
      if(disable)
            Enable(false);
    else
            Enable(true);
}

void CxEditBox::SetInputType(int type)
{
    allowedInput = type;  //See header file for the three types. The default
                          // is to allow text. It can be changed to REAL or INT.
}

void CxEditBox::ClearBox()
{
      Clear();
}

void CxEditBox::OnKeyDown ( wxKeyEvent & event )
{
            switch (event.GetKeyCode())
            {
                  case WXK_UP:
                        ((CrEditBox*)ptr_to_crObject)->SysKey( CRUP );
                        break;
                  case WXK_DOWN:
                        ((CrEditBox*)ptr_to_crObject)->SysKey( CRDOWN );
                        break;
                  default:
                        event.Skip();
                        break;
            }
}

void CxEditBox::LimitChars(string::size_type limit)
{
   m_Limit = limit;

}

void CxEditBox::IsInputPlace()
{
   if (CcController::mp_inputfont == nil)
   {
    wxFont* pFont = new wxFont(12,wxFONTFAMILY_MODERN,wxFONTSTYLE_NORMAL,wxFONTWEIGHT_NORMAL);
 #ifndef _WINNT
    *pFont = wxSystemSettings::GetFont( wxSYS_ANSI_FIXED_FONT );
 #else
   *pFont = wxSystemSettings::GetFont( wxDEVICE_DEFAULT_FONT );
 #endif  // !_WINNT
    string temp;
    temp = (CcController::theController)->GetKey( "MainFontInfo" );
    if ( temp.length() ) pFont->SetNativeFontInfo( temp.c_str() );
    CcController::mp_inputfont = pFont;
   }
   else
   {
     SetFont(*CcController::mp_inputfont);
   }
   m_IsInput = true;
}

void CxEditBox::UpdateFont()
{
     SetFont(*CcController::mp_inputfont);
}
