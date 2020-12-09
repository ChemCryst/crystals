// startupdialog.h

#include <wx/wx.h> 
#include <wx/filename.h>
#include <wx/listctrl.h>
#include <wx/config.h>
#include <vector>


class MRUitem {
	public:
		MRUitem(wxFileName f, wxDateTime t);
		wxFileName file;
		wxDateTime time;
		bool exists;
// override < operator - allows vector of these objects to be sorted by stl sort. Note we reverse 
// the sense of the sort to get files with newest dates first in vector.
		inline bool operator < (const MRUitem& other) const
		{
			return (time > other.time);
		};
};

typedef std::vector<MRUitem> MRUlist;

// Load and save list of most recently used files.
// Sort, add, check existence.
class CcMRUFiles
{
	public:
		CcMRUFiles();   // Will load MRU files.
		bool UpdateList(wxListCtrl* tc);  // Clear and re-populate a listctrl.
		MRUitem* GetEntry( long index ); // zero-based index of item in list (MRUitem pair). NULL if invalid index.
		bool RemoveIndex ( long index );
		void StoreMRUFileList();
		void AddFile ( wxFileName f ) ;
		
	private:
		MRUlist mru;  // the list
		void LoadMRUFileList();
	

};


class DemoInfo {
public:
	wxArrayString names, folders, infos;
	void Add( wxString name, wxString folder, wxString info );
};


class WorkshopDialog: public wxDialog
{
public:
	WorkshopDialog ( wxWindow * parent, wxWindowID id, const wxString & title,
	              const wxPoint & pos = wxDefaultPosition,
	              const wxSize & size = wxDefaultSize,
	              long style = wxDEFAULT_DIALOG_STYLE );
	wxStaticText * tc;
	wxListBox* lb;
	DemoInfo demoinfo;  //stores data about demo folders

	wxString directory;

private:
	void ChooseFolder ( long id ); //Find folder based on current entry in list box control
	void OnOpen( wxCommandEvent & event );
	void OnOpenFresh( wxCommandEvent & event );
	void OnCancel( wxCommandEvent & event );
	void ItemSelected( wxCommandEvent & event );
	void ItemActivated( wxCommandEvent & event );

	DECLARE_EVENT_TABLE()
};



class StartUpDialog: public wxDialog
{
public:

	StartUpDialog ( wxWindow * parent, wxWindowID id, const wxString & title,
	              const wxPoint & pos = wxDefaultPosition,
	              const wxSize & size = wxDefaultSize,
	              long style = wxDEFAULT_DIALOG_STYLE );

	wxString directory;
	wxString dscfile;
	wxButton *btnopen, *btncopy, *btnhide;
	CcMRUFiles *cmru;
	wxListCtrl* lc;
	bool mruchanged;


private:

//	void OnOk( wxCommandEvent & event );
	void OnFile( wxCommandEvent & event );
	void OnFolder( wxCommandEvent & event );
	void OnCancel( wxCommandEvent & event );
	void OnOpenSelected( wxCommandEvent & event );
	void OnHideSelected( wxCommandEvent & event );
	void OnCopySelected( wxCommandEvent & event );
	void OnHelp( wxCommandEvent & event );
	void OnWorkshop( wxCommandEvent & event );
	void ItemSelected( wxListEvent & event );
	void ItemDeselected( wxListEvent & event );
	void ItemActivated( wxListEvent & event );
	
	long selectedindex;
	void UpdateListAndButtons();
	void EndAndSave();

	DECLARE_EVENT_TABLE()
};

enum { crID_OpenSelected = 15500, crID_HideSelected, crID_CopySelected, crID_Cancel, 
           crID_Help, crID_Workshop, crID_List, crID_File, crID_Folder, crID_WCancel,
           crID_WOpen, crID_WOpenFresh, crID_WorkList		   };
