////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxMultiEdit
////////////////////////////////////////////////////////////////////////
//   Filename:  CxMultiEdit.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.26  2008/09/22 12:31:37  rich
//   Upgrade GUI code to work with latest wxWindows 2.8.8
//   Fix startup crash in OpenGL (cxmodel)
//   Fix atom selection infinite recursion in cxmodlist
//
//   Revision 1.25  2005/01/23 10:20:24  rich
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
//   Revision 1.24  2004/09/17 14:03:54  rich
//   Better support for accessing text in Multiline edit control from scripts.
//
//   Revision 1.23  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.22  2004/05/17 13:44:56  rich
//   Fixed Linux build.
//
//   Revision 1.21  2004/05/13 17:21:43  rich
//   Fix build problem following today's checkins.
//
//   Revision 1.20  2004/05/13 09:14:49  rich
//   Re-invigorate the MULTIEDIT control. Currently not used, but I have
//   something in mind for it.
//
//   Revision 1.19  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.18  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.17  2001/06/17 14:34:05  richard
//
//   CxDestroyWindow function.
//
//   Revision 1.16  2001/03/08 16:44:10  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#include    "crystalsinterface.h"
#include    <string>
#include    <wx/utils.h>
using namespace std;

#include    "cxmultiedit.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "crmultiedit.h"
#include    "crgrid.h"

enum
{
    MARGIN_LINE_NUMBERS,
    MARGIN_FOLD
};
// These macros are being defined somewhere. They shouldn't be.

 #ifdef GetCharWidth
  #undef GetCharWidth
 #endif
 #ifdef DrawText
  #undef DrawText
 #endif


int CxMultiEdit::mMultiEditCount = kMultiEditBase;

CxMultiEdit *   CxMultiEdit::CreateCxMultiEdit( CrMultiEdit * container, CxGrid * guiParent )
{
        CxMultiEdit *theMEdit = new CxMultiEdit (container);
       theMEdit->Create(guiParent, -1, wxPoint(0,0), wxSize(10,10), 0 , "CRYSTALS Editor");
        theMEdit->Init();
        return theMEdit;
}

CxMultiEdit::CxMultiEdit( CrMultiEdit * container )
: BASEMULTIEDIT ()
{
      ptr_to_crObject = container;
      mIdealHeight = 30;
      mIdealWidth  = 70;
      mHeight = 40;
      lastsearch = "";
      lastflags = 0;
      m_dlgFind =
      m_dlgReplace = NULL;

}

wxBEGIN_EVENT_TABLE(CxMultiEdit, wxStyledTextCtrl)
    EVT_FIND(wxID_ANY, CxMultiEdit::OnFindDialog)
    EVT_FIND_NEXT(wxID_ANY, CxMultiEdit::OnFindDialog)
    EVT_FIND_REPLACE(wxID_ANY, CxMultiEdit::OnFindDialog)
    EVT_FIND_REPLACE_ALL(wxID_ANY, CxMultiEdit::OnFindDialog)
    EVT_FIND_CLOSE(wxID_ANY, CxMultiEdit::OnFindDialog)
wxEND_EVENT_TABLE()



CxMultiEdit::~CxMultiEdit()
{
      RemoveMultiEdit();
}

void CxMultiEdit::CxDestroyWindow()
{
    Destroy();
}

void CxMultiEdit::FindDialog()
{

    if ( m_dlgReplace )
    {
        wxDELETE(m_dlgReplace);
    }
    else
    {
        m_dlgReplace = new wxFindReplaceDialog
                           (
                            this,
                            &m_findData,
                            "Find and replace dialog",
                            wxFR_REPLACEDIALOG
                           );

        m_dlgReplace->Show(true);
    }

}

bool CxMultiEdit::Find(wxString &text, int flags){
    
    if (text.length() == 0 ) return false;


    
    int found = FindText(	GetCurrentPos(), 
                                    GetLength(), 
                                    text,   
                                    (flags&wxFR_WHOLEWORD)?wxSTC_FIND_WHOLEWORD:0 | (flags&wxFR_MATCHCASE)?wxSTC_FIND_MATCHCASE:0 );

    if ( found == wxSTC_INVALID_POSITION ) {  // Try from start
                found = FindText(	0, 
                                    GetCurrentPos(), 
                                    text, 
                                    (flags&wxFR_WHOLEWORD)?wxSTC_FIND_WHOLEWORD:0 | (flags&wxFR_MATCHCASE)?wxSTC_FIND_MATCHCASE:0  );
    }                

//    wxLogMessage("Find %s %d %d",text, flags, found);


    if ( found == wxSTC_INVALID_POSITION ) {   //Not found anywhere
            wxBell();
            if ( m_dlgReplace )  m_dlgReplace->RequestUserAttention();
        return false;
    } else {
                ShowPosition(found);
                SetSelection(found, found+text.length() );
    }
    
    return true;
}

bool CxMultiEdit::Replace(wxString &text, wxString &replace, int flags){   //First call does a search and highlights.
                                                                           //Subsequent calls replace current highlight and move to next position.
    
    if (text.length() == 0 ) return false;

// Check if current selection is search text:

    if ( text == GetStringSelection() ) {  // yes - replace
        
            ReplaceSelection(replace);
            
    }
        
// Find and highlight next example
    return Find ( text, flags );
}

//First call does a search and highlights.
//Subsequent calls replace current highlight and move to next position.
bool CxMultiEdit::ReplaceAll(wxString &text, wxString &replace, int flags) {   
    while ( Replace( text, replace, flags) );
   
    return true;
}

 
void CxMultiEdit::FindNext(){   //Repeat last search

        Find(lastsearch, lastflags);
    
}
 
void CxMultiEdit::OnFindDialog(wxFindDialogEvent& event)
{
    wxEventType type = event.GetEventType();

    if ( type == wxEVT_FIND || type == wxEVT_FIND_NEXT )
    {
        lastsearch = event.GetFindString();
        lastflags = event.GetFlags();
        Find(lastsearch, lastflags);
    }
    else if ( type == wxEVT_FIND_REPLACE )
    {
        lastsearch = event.GetFindString();
        lastflags = event.GetFlags();
        wxString replace = event.GetReplaceString();
        Replace(lastsearch, replace, lastflags);
    }
    else if ( type == wxEVT_FIND_REPLACE_ALL )
    {
        lastsearch = event.GetFindString();
        lastflags = event.GetFlags();
        wxString replace = event.GetReplaceString();
        ReplaceAll(lastsearch, replace , lastflags);
    }
    else if ( type == wxEVT_FIND_CLOSE )
    {
        wxFindReplaceDialog *dlg = event.GetDialog();

//        int idMenu;
        if ( dlg == m_dlgFind )
        {
            m_dlgFind = NULL;
        }
        else if ( dlg == m_dlgReplace )
        {
            m_dlgReplace = NULL;
        }
        dlg->Destroy();
    }
    else
    {
        wxLogError("Unknown find dialog event!");
    }
}
    

// Part of the IInputControl interface - insert text at cursor.
// If some text is selected, replace it.
void CxMultiEdit::InsertText(const string text) {

	ReplaceSelection("");
	long pos = GetInsertionPoint();
	bool insertspacebefore = false;
	bool insertspaceafter = false;
	int spb = 0;
	int spa = 0;

	if ( pos ) {
		spb = GetCharAt(pos-1);
	}

	if ( pos != GetLastPosition()) {
		spa = GetCharAt(pos);
	}

//    ostringstream strm;
//    strm << "Chars before and after" << spb << " and " << spa;
//	LOGERR(strm.str());

	if (( spb != 32 ) && ( spb != 10 ) && ( spb !=13 ) && ( spb !=0 ) ) {
		insertspacebefore = true;
	}
	if (( spa != 32 ) && ( spa != 10 ) && ( spa !=13 ) && ( spa !=0 ) ) {
		insertspaceafter = true;
	}
	
	string in = string(insertspacebefore?" ":"") + text + string(insertspaceafter?" ":"");

	wxStyledTextCtrl::InsertText(pos, in);
	SetCurrentPos(pos + in.length());
	SetInsertionPoint(pos + in.length());
	GotoPos(pos + in.length());
}

// Used for template insertion - insert text as a whole line after this one
// unless cursor is at start of line, in which case insert it here...
void CxMultiEdit::InsertLine(const string text) {

	long pos = GetInsertionPoint();
	int line = LineFromPosition(pos);
    int inspos = PositionFromLine(line);
	
	if ( inspos != pos ) inspos = PositionFromLine(line+1);  // not at start, go to next line

	wxStyledTextCtrl::InsertText(inspos, text);
	SetCurrentPos(pos + text.length());
	SetInsertionPoint(inspos + text.length());
	GotoPos(inspos + text.length());
}

void  CxMultiEdit::SetText( const string & cText )
{
// Add the text.
      AppendText(cText.c_str());

//Now scroll the text so that the last line is at the bottom of the screen.
//i.e. so that the line at lastline-firstvisline is the first visible line.
      ShowPosition ( GetLastPosition () );
}


int CxMultiEdit::GetNLines()
{
    return GetNumberOfLines();
}

int CxMultiEdit::GetIdealWidth()
{
    return mIdealWidth;
}
int CxMultiEdit::GetIdealHeight()
{
    return mIdealHeight;
}

void CxMultiEdit::SetIdealHeight(int nCharsHigh)
{
      mIdealHeight = nCharsHigh * GetCharHeight();
}

void CxMultiEdit::SetIdealWidth(int nCharsWide)
{
      mIdealWidth = nCharsWide * GetCharWidth();
}


CXSETGEOMETRY(CxMultiEdit)

CXGETGEOMETRIES(CxMultiEdit)



void CxMultiEdit::Focus()
{
    SetFocus();
}




bool CxMultiEdit::CxIsModified()
{
	return IsModified();
}

void CxMultiEdit::Spew()
{
//Send all text to crystals a line at a time.
    char theLine[80];
    int line = 0;
    for (int i=0; i<GetNumberOfLines(); i++)
    {
       wxString aline = GetLineText(i);
       int cp = CRMIN ( aline.length(), 80 );
       strcpy ( (char*)&theLine, aline.c_str() );
       theLine[cp]='\0';
       string sline = string( theLine );
       string::size_type cut;
       string delimiters = "\r\n\0";
       while ( ( cut = sline.find_first_of(delimiters) ) < sline.length() )
       {
          sline = sline.substr(0,cut);
       }
       ((CrMultiEdit*)ptr_to_crObject)->SendCommand( sline );
       line++;
    }
}


void CxMultiEdit::Empty()
{
      Clear();
}

void CxMultiEdit::SetFontHeight( int height )
{


}

void CxMultiEdit::Init()
{

    SetMarginWidth (MARGIN_LINE_NUMBERS, 50);
    StyleSetForeground (wxSTC_STYLE_LINENUMBER, wxColour (75, 75, 75) );
    StyleSetBackground (wxSTC_STYLE_LINENUMBER, wxColour (220, 220, 220));
    SetMarginType (MARGIN_LINE_NUMBERS, wxSTC_MARGIN_NUMBER);

	SetEdgeColumn(80);
	SetEdgeMode(wxSTC_EDGE_BACKGROUND);
	SetWordChars(" ");
    wxFont f =  wxSystemSettings::GetFont( wxSYS_ANSI_FIXED_FONT );
    StyleSetFont 	(  wxSTC_STYLE_DEFAULT, f);

#ifdef CRY_OSWIN32 
	SetEOLMode(wxSTC_EOL_CRLF);
#endif


}


void CxMultiEdit::SaveAs(string filename)
{
    SaveFile( filename.c_str() );
}
void CxMultiEdit::Load(string filename)
{
        ClearAll();
        LoadFile( filename.c_str() );
        ClearSelections();
}
