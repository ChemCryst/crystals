// startupdialog class

// eventually set this in preferences
#define MAX_RECENT_FILES 200 


#include "startupdialog.h"
#include <wx/stdpaths.h>
#include <list> 
//#include    <iostream>
//#include    <sstream>

// Helper MRUitem
MRUitem::MRUitem( wxFileName f, wxDateTime t ){
	this->file = f;
	this->time = t;
	this->exists = this->file.Exists();
// if file exists, update the modification date
	if ( this->exists ) this->time = this->file.GetModificationTime();
}

// Helper CcMRUFiles - handles list of most recently used files
CcMRUFiles::CcMRUFiles() 
{
	// Load data
	LoadMRUFileList();
	// Sort data
	
}

// return true if any items added, false if empty list.
bool CcMRUFiles::UpdateList(wxListCtrl* lc) {  // Clear and re-populate a listctrl.
	
	if ( !lc ) return false; //check for null pointer
	
	lc->DeleteAllItems();

	MRUlist :: iterator it; 
    for(it = mru.begin(); it != mru.end(); ++it) 
	{
		long int itemindex = lc->InsertItem(lc->GetItemCount(), (*it).file.GetFullName() );
		lc->SetItem(itemindex, 1, (*it).file.GetPath() );
		lc->SetItem(itemindex, 2, (*it).time.FormatISOCombined(' ') );
		if ( !(*it).exists ) {
			lc->SetItemTextColour( itemindex, *wxRED );
		}	
	}
	
	return (mru.size() != 0);
}

//Remove index - return true if item removed, otherwise false (some failure).
bool CcMRUFiles::RemoveIndex( long index ) {
//	std::ostringstream os;
//	os << "Removing " << index ;
//    wxMessageBox("Info",os.str() ,wxOK|wxICON_HAND|wxCENTRE);
	if ( index < 0 || index >= mru.size() ) return false;  // check index against list bounds
	mru.erase( mru.begin() + index );
	return true;
}
MRUitem* CcMRUFiles::GetEntry( long index ) {
	
	MRUitem* ret = NULL;
	if ( index < 0 || index >= mru.size() ) return ret;  // check index against list bounds
	
	return &mru[index];  // return pointer to MRUitem object in MRUlist.
}

void CcMRUFiles::LoadMRUFileList() {
// Load MRU file list from registry, store in mrufiles 

	mru.clear();
		
	wxConfig *config = new wxConfig(wxT("Chem Cryst"));
	config->SetPath("/Crystals/mru");    

//	wxString buf;
//	buf.Printf(wxT("file%d"), mru.size());

    wxString value;
	wxString key;
	long cookie;

	bool bCont = config->GetFirstEntry(key, cookie);
	while ( bCont ) {
		//split value on |
		// String format is "c:/filename/file.dsc|932421" - filename followed by time in seconds (since 1970).
		// future versions can store more info with more | characters. We just use the first two.
		config->Read(key, &value);
		wxArrayString vals = wxSplit( value, '|' );
		wxFileName f(vals[0]);
		time_t ticks = wxAtoi(vals[1]);
		wxDateTime t(ticks);
		MRUitem item ( f, t );  // NB this constructor gets and updates modification time if file exists.
		mru.push_back(item);
		bCont = config->GetNextEntry(key, cookie);
	}


/*	while (config->Read(buf, &value) && !value.empty()) {

		//split value
		wxArrayString vals = wxSplit( value, '|' );
		
		wxFileName f(vals[0]);
		time_t ticks = wxAtoi(vals[1]);
		wxDateTime t(ticks);
		MRUitem item ( f, t );
		mru.push_back(item);
		
        buf.Printf(wxT("file%d"), mru.size());
        value.clear();
	}
*/
	delete config;

	std::sort(mru.begin(), mru.end());   // sort vector of MRUitems into date order (most recent first).

/*	
	wxFileName a(wxT("c:\\Users\\richard.cooper\\Documents\\GitHub\\crystals\\b\\demo\\My_Nket\\crfilev2.dsc"));
	wxFileName b(wxT("c:\\Users\\richard.cooper\\Documents\\GitHub\\crystals\\b\\demo\\shape\\crfilev2.dsc"));
	wxFileName c(wxT("c:\\Users\\richard.cooper\\Documents\\GitHub\\crystals\\b\\demo\\shape\\newaniso.dsc"));
	
	wxDateTime at(6,wxDateTime::Feb,1974,6,10,34,0);
	wxDateTime bt(15,wxDateTime::Oct,1976,11,23,23,0);
	wxDateTime ct(11,wxDateTime::Jan,2004,15,1,44,0);
	
	MRUitem sa ( a, at );
	MRUitem sb ( b, bt );
	MRUitem sc ( c, ct );

	mru.push_back(sa);
	mru.push_back(sb);
	mru.push_back(sc);

	std::sort(mru.begin(), mru.end());
	*/
	return;
}

void CcMRUFiles::StoreMRUFileList(  ){
	
	// Check size
	if ( mru.size() > MAX_RECENT_FILES ) {
		std::sort(mru.begin(), mru.end());   // if we're going to truncate, sort first so that we drop oldest.
		mru.erase(mru.begin() + MAX_RECENT_FILES, mru.end() ); 
	}
	
	// store mrulist in registry
	wxConfig *config = new wxConfig(wxT("Chem Cryst"));
	config->DeleteGroup("/Crystals/mru"); //remove before replace
	config->SetPath("/Crystals/mru");    
	
	MRUlist :: iterator it; 
    for(it = mru.begin(); it != mru.end(); ++it) 
	{
       wxString buf;
	   wxString val;
       buf.Printf(wxT("file%d"), (int) ( it - mru.begin() ));
	   val = (*it).file.GetFullPath() + wxT("|");
	   val <<  (long) (*it).time.GetTicks();
       config->Write(buf,val);
	} 	

	delete config;

}


void CcMRUFiles::AddFile( wxFileName f ){
	
	// check for duplicates, add to list, store list
	MRUlist :: iterator it; 
    for(it = mru.begin(); it != mru.end(); ++it) 
	{
		if ( (*it).file == f ) return; // Already here. No need to add.
	}
	
	wxDateTime t = wxDateTime::Now(); 
	MRUitem item ( f, t );  // NB this constructor gets and updates modification time if file exists.
	mru.push_back(item);
	
	//No need to sort yet, it gets sorted on loading.
	StoreMRUFileList();
	
}


//                                                                                 //
//=================================================================================//
//                                WorkshopDialog                                   //


BEGIN_EVENT_TABLE(WorkshopDialog, wxDialog)
      EVT_BUTTON( wxID_CANCEL,               WorkshopDialog::OnCancel )
      EVT_BUTTON( crID_WOpen,       	      WorkshopDialog::OnOpen )
      EVT_BUTTON( crID_WOpenFresh,            WorkshopDialog::OnOpenFresh )
	  EVT_LISTBOX( crID_WorkList,  WorkshopDialog::ItemSelected )
	  EVT_LISTBOX_DCLICK( crID_WorkList, WorkshopDialog::ItemActivated )
END_EVENT_TABLE()

void DemoInfo::Add( wxString name, wxString folder, wxString info ) {
	names.Add(name);
	folders.Add(folder);
	infos.Add(info);
	return;
}

WorkshopDialog::WorkshopDialog ( wxWindow * parent, wxWindowID id, const wxString & title,
                           const wxPoint & position, const wxSize & size, long style )
: wxDialog( parent, id, title, position, size, style|wxRESIZE_BORDER)
{
/*	
^^WI     '4. Edit examples'
^^WI     '8. TLS example (Cp* and PF6)'
^^WI     '9. Ru structure (disorder)'
^^WI     '10. ZnGaPO (disorder)'
^^WI     '11. Zurich (disorder)'
^^WI     '13. Peach (large organic)'
^^WI     '14. Keen (twin)'
^^WI     '15. Hex (old test)'
^^WI     '16. Mogul (validations)'
^^WI     '17. Zoltan (BaSiN2)'
^^WI     '18. LLewellyn (Difficult Structure)'
^^WI     '19. Superflip Examples'
*/

	this->directory = wxT("");  // The value to be read back by calling code if wxID_OK is returned.

	
	demoinfo.Add( "Cyclo",  "cyclo",    "Routine small molecule" );
	demoinfo.Add( "NKet",   "nket",    "Routine small molecule" );
	demoinfo.Add( "Ylid",   "ylid",    "Routine small molecule" );
	demoinfo.Add( "Peach",   "peach",    "Medium molecule" );
	demoinfo.Add( "Llewellyn",   "llewellyn",   "Organometallic on symmetry operator" );
	demoinfo.Add( "Penicillin salt",   "kpenv",   "Potassium penicillin (Z'=4)" );
	demoinfo.Add( "Chargeflip examples",   "chargeflip",   "Selection of examples using Superflip" );
	demoinfo.Add( "H atom placing",   "Hydrogen",   "Example placing H on C and N atoms" );
	demoinfo.Add( "SnHMe3 twin",   "twin",    "Twinned organometallic example" );
	demoinfo.Add( "As19a2 twin",   "twin2",    "Twinned organic example" );
	demoinfo.Add( "B10F12 twin",   "twin3",    "Twinned inorganic example" );
	demoinfo.Add( "Keen twin",   "keen",    "Twinned organic salt example" );
	demoinfo.Add( "HKLF5 twin",   "Bruce",    "Non-merohedral twin example" );
	demoinfo.Add( "Disordered enantiomers",   "disorder",   "Molecular solid solution of enantiomers" );
	demoinfo.Add( "SO3 disorder",   "SO3-disorer",   "Conformational disorder in tosylate ion" );
	demoinfo.Add( "Sugar disorder",   "Sugar-disorder",   "Hydroxymethyl disorder " );
	demoinfo.Add( "B10F12 twin",   "twin3",    "Twinned inorganic example" );
	demoinfo.Add( "BaSiN2",   "zoltan",    "Inorganic example" );
	demoinfo.Add( "Cp* and PF6 models",   "shape",    "Large rotational motion present" );
	demoinfo.Add( "ZnGaPO",   "shape2",    "Disordered cyclopentane guest" );
	demoinfo.Add( "Quick",   "quick",    "Low signal to noise data" );
	demoinfo.Add( "Mogul",   "mogul",    "Examples for investigation in Mogul" );
	demoinfo.Add( "Edit examples",   "editor",    "#EDIT examples" );
	demoinfo.Add( "Dimethylcyclohexane",   "example",    "Molecule on symmetry operator" );


	wxBoxSizer   *main     = new wxBoxSizer(wxVERTICAL);

	wxBoxSizer   *wlist   = new wxBoxSizer(wxHORIZONTAL);
	wxBoxSizer   *textp    = new wxBoxSizer(wxHORIZONTAL);
	wxBoxSizer   *listops   = new wxBoxSizer(wxHORIZONTAL);

    this->lb = new wxListBox(this, crID_WorkList, wxDefaultPosition, wxDefaultSize, 0, NULL, wxLB_SINGLE);

	this->tc = new wxStaticText(this, crID_WorkList, demoinfo.infos[0], wxDefaultPosition, wxSize(200,-1));


	wxButton     *btncancel    = new wxButton(this, wxID_CANCEL, wxT("Cancel"));
	wxButton     *btnopen      = new wxButton(this, crID_WOpen, wxT("Open"));
	wxButton     *btnopenfresh = new wxButton(this, crID_WOpenFresh, wxT("Open Fresh"));

	lb->InsertItems(demoinfo.names,0);

    wlist->Add(lb, 1, wxEXPAND);
	textp->Add(tc, 0, wxEXPAND);

	listops->Add(btnopen, 0);
	listops->Add(btnopenfresh, 0);
	listops->Add(btncancel, 0);

    main->Add(wlist, 1, wxEXPAND | wxLEFT | wxRIGHT | wxTOP, 10);
	main->Add(-1, 10);
	main->Add(textp, 0, wxEXPAND | wxLEFT | wxRIGHT | wxTOP, 10 );
	main->Add(-1, 10);
	main->Add(listops, 0, wxALIGN_RIGHT | wxLEFT | wxRIGHT | wxTOP, 10 );
	main->Add(-1, 10);



	SetSizerAndFit(main);

	Centre();

	
}


void WorkshopDialog::OnCancel( wxCommandEvent & event ) {
	EndModal( wxID_CANCEL );
}
void WorkshopDialog::OnOpen( wxCommandEvent & event ) {
	// Store folder - check location
	
	ChooseFolder( lb->GetSelection() );  // Set 'directory' variable based on selection 
	if ( this->directory.length() ) {
		EndModal( wxID_OK );
	} else {
		wxMessageBox("Cannot find demo directory\nRe-install CRYSTALS and try again","Error" ,wxOK|wxICON_HAND|wxCENTRE);
	}
}

void WorkshopDialog::OnOpenFresh( wxCommandEvent & event ) {

	ChooseFolder( lb->GetSelection() ); // Set 'directory' variable based on selection 

	if ( this->directory.length() ) {

		std::list<wxString> todelete;
		todelete.push_back( wxString("crfilev2.dsc") );
		todelete.push_back( wxString("pretwin6.dat") );
		todelete.push_back( wxString("SIR9x.ins") );

		for ( std::list<wxString>::iterator it = todelete.begin(); it != todelete.end(); ++it ){ 
			wxFileName fdsc( directory, *it );  // construct full filename
			if ( fdsc.Exists() ) {
				wxRemoveFile( fdsc.GetFullPath() );  //if it exists, delete it
			}
		}		

		EndModal( wxID_OK );  // Exit dialog with directory set.

	} else {
		wxMessageBox("Cannot find demo directory\nRe-install CRYSTALS and try again","Error" ,wxOK|wxICON_HAND|wxCENTRE);
	}
}
void WorkshopDialog::ItemActivated( wxCommandEvent & event ) {
	long id = lb->GetSelection();
	// Store folder - check location
	ChooseFolder( id );
	if ( this->directory.length() ) {
		EndModal( wxID_OK );
	} else {
		wxMessageBox("Cannot find demo directory\nRe-install CRYSTALS and try again","Error" ,wxOK|wxICON_HAND|wxCENTRE);
	}
}

//Find folder based on current entry in list box control
void WorkshopDialog::ChooseFolder( long id )
{
	this->directory = wxT("");
	
	wxFileName t (wxStandardPaths::Get().GetDataDir() + wxFileName::GetPathSeparator() + "demo" + wxFileName::GetPathSeparator() + demoinfo.folders[id], "" ); //initialize as folder name
	
	if ( t.DirExists() ) {
		this->directory = t.GetPath();
	} else {
		wxFileName t2 (wxStandardPaths::Get().GetUserDataDir() + wxFileName::GetPathSeparator() + "demo" + wxFileName::GetPathSeparator() + demoinfo.folders[id], "" ); //initialize as folder name
		if ( t2.DirExists() ) {
			this->directory = t2.GetPath();
		} else {
			wxFileName t3 (wxStandardPaths::Get().GetConfigDir() + wxFileName::GetPathSeparator() + "demo" + wxFileName::GetPathSeparator() + demoinfo.folders[id], "" ); //initialize as folder name
			if ( t3.DirExists() ) {
				this->directory = t3.GetPath();
			}
		}
	}

}

void WorkshopDialog::ItemSelected( wxCommandEvent & event ) {
	long id = lb->GetSelection();
	this->tc->SetLabel( demoinfo.infos[id] );
	this->directory = demoinfo.folders[id];
}



//                                                                                 //
//=================================================================================//
//                                StartUpDialog                                    //



BEGIN_EVENT_TABLE(StartUpDialog, wxDialog)
      EVT_BUTTON( crID_File,             StartUpDialog::OnFile )
      EVT_BUTTON( crID_Help,             StartUpDialog::OnHelp )
      EVT_BUTTON( crID_Folder,           StartUpDialog::OnFolder )
      EVT_BUTTON( wxID_CANCEL,           StartUpDialog::OnCancel )
      EVT_BUTTON( crID_OpenSelected,     StartUpDialog::OnOpenSelected )
      EVT_BUTTON( crID_CopySelected,     StartUpDialog::OnCopySelected )
      EVT_BUTTON( crID_HideSelected,     StartUpDialog::OnHideSelected )
      EVT_BUTTON( crID_Workshop,         StartUpDialog::OnWorkshop )
	  EVT_LIST_ITEM_SELECTED( crID_List, StartUpDialog::ItemSelected )
	  EVT_LIST_ITEM_DESELECTED( crID_List, StartUpDialog::ItemDeselected )
	  EVT_LIST_ITEM_ACTIVATED( crID_List, StartUpDialog::ItemActivated )
END_EVENT_TABLE()


StartUpDialog::StartUpDialog ( wxWindow * parent, wxWindowID id, const wxString & title,
                           const wxPoint & position, const wxSize & size, long style )
: wxDialog( parent, id, title, position, size, style|wxRESIZE_BORDER)
{

	this->selectedindex = -1;
	this->mruchanged = false;

	wxBoxSizer   *panel   = new wxBoxSizer(wxVERTICAL);

	wxBoxSizer   *helpops   = new wxBoxSizer(wxHORIZONTAL);
	wxBoxSizer   *mrulist   = new wxBoxSizer(wxHORIZONTAL);
	wxBoxSizer   *genops    = new wxBoxSizer(wxHORIZONTAL);
	wxBoxSizer   *listops   = new wxBoxSizer(wxHORIZONTAL);

//	wxTextCtrl   *tc2       = new wxTextCtrl(this, wxID_ANY, wxT(""), wxPoint(-1, -1), wxSize(200, 250), wxTE_MULTILINE);
    this->lc        = new wxListCtrl(this, crID_List, wxDefaultPosition, wxDefaultSize, wxLC_REPORT|wxLC_SINGLE_SEL);
	this->lc->AppendColumn(wxT("File"));
	this->lc->AppendColumn(wxT("Path"));
	this->lc->AppendColumn(wxT("Modified"));
		
	wxButton     *btnhelp   = new wxButton(this, crID_Help, wxT("Help"));
	wxButton     *btnwork   = new wxButton(this, crID_Workshop, wxT("Workshops"));
	wxButton     *btnfile   = new wxButton(this, crID_File, wxT("Browse..."));
	wxButton     *btnfold   = new wxButton(this, crID_Folder, wxT("Browse for Folder..."));
	wxButton     *btncancel = new wxButton(this, wxID_CANCEL, wxT("Cancel"));

	btnopen   = new wxButton(this, crID_OpenSelected, wxT("Open selected"));
	btncopy   = new wxButton(this, crID_CopySelected, wxT("Open a copy"));
	btnhide   = new wxButton(this, crID_HideSelected, wxT("Hide selected"));
	

    mrulist->Add(lc, 1, wxEXPAND);

	helpops->Add(btnwork,0, wxALIGN_RIGHT);
	helpops->Add(btnhelp,0, wxALIGN_RIGHT);

	genops->Add(btnfile, 0, wxALIGN_LEFT);
	genops->Add(btnfold, 0, wxALIGN_LEFT);
	genops->AddStretchSpacer();
	genops->Add(btncancel, 0, wxALIGN_RIGHT);

	listops->Add(btnopen, 0);
	listops->Add(btncopy, 0);
	listops->Add(btnhide, 0);

	panel->Add(helpops, 0, wxALIGN_RIGHT | wxLEFT | wxRIGHT | wxTOP, 10 );
    panel->Add(mrulist, 1, wxEXPAND | wxLEFT | wxRIGHT | wxTOP, 10);
	panel->Add(listops, 0, wxALIGN_RIGHT | wxLEFT | wxRIGHT | wxTOP, 10 );
	panel->Add(-1, 10);
	panel->Add(genops, 0, wxEXPAND | wxLEFT | wxRIGHT | wxTOP, 10 );
	panel->Add(-1, 10);

//	panel->SetSizerAndFit(vbox);
	SetSizerAndFit(panel);

	Centre();


// Load list of files from storage
	this->cmru = new CcMRUFiles();
	
	UpdateListAndButtons();

// Set column widths.
	this->lc->SetColumnWidth(0,wxLIST_AUTOSIZE);
	this->lc->SetColumnWidth(1,wxLIST_AUTOSIZE);
	this->lc->SetColumnWidth(2,wxLIST_AUTOSIZE);
	long tw = lc->GetColumnWidth(0) + lc->GetColumnWidth(1) + lc->GetColumnWidth(2);
	long list = lc->GetSize().GetWidth();
	long ww = this->GetSize().GetWidth();
	
	this->SetSize( ww + tw - list,  this->GetSize().GetHeight());
	
}

void StartUpDialog::UpdateListAndButtons(){
	// Populate the list control
	if ( this->cmru->UpdateList(this->lc) ) {
		// ensure first item is selected
		this->lc->SetItemState(lc->GetTopItem() , wxLIST_STATE_SELECTED , wxLIST_STATE_SELECTED);
		this->selectedindex = 0;
	} else {
		// no entries, disable selection action buttons
		this->btnopen->Enable(false);
		this->btncopy->Enable(false);
		this->btnhide->Enable(false);
	}

}


void StartUpDialog::EndAndSave() {
	cmru->StoreMRUFileList();
	EndModal(wxID_OK);
}


void StartUpDialog::OnOpenSelected( wxCommandEvent & event ) {
	// Set dir and dsc
	MRUitem *mrudata = this->cmru->GetEntry(this->selectedindex);
	if ( mrudata && mrudata->exists ) {
		this->directory = ( mrudata->file.GetPath() + wxFileName::GetPathSeparator() ).ToStdString();
		this->dscfile = mrudata->file.GetFullName().ToStdString();
		EndAndSave();

	}
}

void StartUpDialog::OnCopySelected( wxCommandEvent & event ) {
	// New file dialog
	// Copy file
	// Set dir and dsc
	MRUitem *mrudata = this->cmru->GetEntry(this->selectedindex);
	if ( mrudata && mrudata->exists ) {

		wxString dir =  mrudata->file.GetPath();
		wxString extension = wxT("CRYSTALS DSC file (*.dsc)|*.dsc");
		wxString initName = wxT("copy") + wxDateTime::Now().Format(wxT("%y%m%d-%H%M")) + wxT(".dsc");

		wxFileDialog fileDialog ( this,
								  "Save file as",
								  dir,
								  initName,
								  extension,
								  wxFD_SAVE|wxFD_OVERWRITE_PROMPT );

		if (fileDialog.ShowModal() == wxID_OK )
		{
			wxString pathname = fileDialog.GetPath();
			//copy file.
			wxCopyFile( mrudata->file.GetFullPath(), pathname );
			wxFileName newdsc(pathname);
			if ( newdsc.Exists() ) {
				this->directory = ( newdsc.GetPath() + wxFileName::GetPathSeparator()) .ToStdString();
				this->dscfile   = newdsc.GetFullName().ToStdString();
				EndAndSave();
			} else {
				wxMessageBox("Failed to copy file","Error" ,wxOK|wxICON_HAND|wxCENTRE);
			}
		}
	} 
}

void StartUpDialog::OnHideSelected( wxCommandEvent & event ) {
	// Remove entry from list
	if ( this->cmru->RemoveIndex( this->selectedindex ) ){
		UpdateListAndButtons(); // refresh list.
	}
	mruchanged = true;
}

void StartUpDialog::OnHelp( wxCommandEvent & event ) {
	wxLaunchDefaultBrowser(wxT("http://www.xtl.ox.ac.uk/crystalsmanual.html"));
}

void StartUpDialog::OnWorkshop( wxCommandEvent & event ) {

	WorkshopDialog * ws = new WorkshopDialog( this, -1, _("CRYSTALS workshop launcher"),
	                          wxPoint(100, 100), wxSize(45, 45) );

	if ( ws->ShowModal() == wxID_OK ) {
		// Get Folder from dialog
		this->directory = ws->directory;		
		this->dscfile = "crfilev2.dsc";
		wxMessageBox( this->directory, "Let's go" );
		EndAndSave();
	}	
	
	delete ws;
}
void StartUpDialog::OnFile( wxCommandEvent & event ) {
	// Open this file
	// TODO: Allow opening of .cif and .hkl files. Q. what to do if crfilev2.dsc exists in that location? Check and ask?
	// What if the location is not writeable? For non .dsc files, ask a supplementary folder question?
	// Need to pass info into a crystals script (via CRINIT variable, or similar)?


//	wxString extension = wxT("CRYSTALS DSC file (*.dsc)|*.dsc|SHELX file (*.ins;*.res)|*.ins;*.res");
	wxString extension = wxT("CRYSTALS DSC file (*.dsc)|*.dsc");

    wxString cwd = wxGetCwd(); //Start in the current working directory

    wxFileDialog fileDialog ( this,
                              "Choose a CRYSTALS file",
                              cwd,
                              "",
                              extension,
                              wxFD_OPEN  );

    if (fileDialog.ShowModal() == wxID_OK )
    {
		wxFileName f(fileDialog.GetPath());
		this->directory = ( f.GetPath() + wxFileName::GetPathSeparator() ).ToStdString();
		this->dscfile = f.GetFullName().ToStdString();
		EndAndSave();
    }

}
void StartUpDialog::OnFolder( wxCommandEvent & event ) {
	// Start in folder
	// TODO: set default location in preferences
    wxString pathname;
    wxDirDialog dirDialog ( this,
                            "Choose a directory",
                             pathname,
                             wxDD_NEW_DIR_BUTTON);
    if (dirDialog.ShowModal() == wxID_OK )
    {
		this->directory = dirDialog.GetPath().ToStdString();
		this->dscfile = "crfilev2.dsc";
		EndAndSave();
    }

	
}

void StartUpDialog::OnCancel( wxCommandEvent & event ) {
	if ( this->mruchanged ) {
		// give user chance to save changes to MRU list
		wxMessageDialog *dial = new wxMessageDialog(this, 
		wxT("Save changes to recently used file list?"), wxT("Question"), 
		wxYES_NO | wxNO_DEFAULT | wxICON_QUESTION);
		if ( dial->ShowModal() == wxID_YES ) {
			cmru->StoreMRUFileList();
		}
	}
	EndModal( wxID_CANCEL );
	
}

void StartUpDialog::ItemActivated( wxListEvent & event ) {
	this->selectedindex = event.GetIndex();
	MRUitem *mrudata = this->cmru->GetEntry(this->selectedindex);
	if ( mrudata && mrudata->exists ) {
		this->directory = ( mrudata->file.GetPath() + wxFileName::GetPathSeparator() ).ToStdString();
		this->dscfile = mrudata->file.GetFullName().ToStdString();
		EndAndSave();
	} else {
		::wxBell();
	} 		
}


void StartUpDialog::ItemSelected( wxListEvent & event ) {
	
	this->selectedindex = event.GetIndex();
	MRUitem *mrudata = this->cmru->GetEntry(this->selectedindex);

	if ( mrudata ) {
		if ( mrudata->exists ) {
			btnopen->Enable(true);
			btncopy->Enable(true);
		} else {
			btnopen->Enable(false);
			btncopy->Enable(false);
		}
		btnhide->Enable(true);
	}
}

void StartUpDialog::ItemDeselected( wxListEvent & event ) {
	btnopen->Enable(false);
	btncopy->Enable(false);
	btnhide->Enable(false);
}


