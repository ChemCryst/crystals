////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGrid.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:59 Uhr
//   Modified:  30.3.1998 11:49 Uhr

#ifndef		__CrGrid_H__
#define		__CrGrid_H__
#include	"crguielement.h"
//insert your own code here.
#include	"cclist.h"
class CxGroupBox;
class CcTokenList;
//End of user code.         
 
class	CrGrid : public CrGUIElement
{
	public:
		void CrFocus();
		int GetIdealHeight();
		int GetIdealWidth();
		void Resize(int newWidth, int newHeight, int origWidth, int origHeight);
		// methods
			CrGrid( CrGUIElement * mParentPtr );
			~CrGrid();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
            void  SetOriginalSizes();
		void	SetText( CcString item );
		Boolean	GridComplete();
		Boolean	InitElement( CrGUIElement * element, CcTokenList * tokenList, int xpos, int ypos );
		void	Align();
		int	GetHeightOfRow( int row );
		int	GetWidthOfColumn( int col );
		CrGUIElement *	FindObject( CcString Name );
            void SendCommand(CcString theText, Boolean jumpQueue);
            void SetCommandText(CcString theText);
		
		// attributes
		int	mColumns;
		int	mRows;
		
	protected:
		// methods
		Boolean	SetPointer( int xpos, int ypos, CrGUIElement * ptr );
		CrGUIElement *	GetPointer( int xpos, int ypos );
		
		// attributes
		CcList	mItemList;
		Boolean	mGridComplete;
		CrGrid *	mActiveSubGrid;
		CrGUIElement **	mTheGrid;
		CxGroupBox *	mOutlineWidget;

            Boolean mCommandSet;
            CcString mCommandText;


};

#define	kSCreateButton		"BUTTON"
#define kSAt			"@"
#define kSCreateListBox		"LISTBOX"
#define kSCreateListCtrl	"LISTCTRL"
#define kSCreateDropDown	"DROPDOWN"
#define kSCreateEditBox		"EDITBOX"
#define kSCreateMultiEdit	"MULTIEDIT"
#define kSCreateTextOut         "TEXTOUT"
#define kSCreateText		"STATIC"
#define kSCreateIcon          "ICON"
#define kSCreateProgress	"PROGRESS"
#define kSCreateRadioButton	"RADIOBUTTON"
#define kSCreateCheckBox	"CHECKBOX"
#define kSCreateChart		"CHARTWINDOW"
#define kSCreateModel		"MODELWINDOW"
#define kSEndGrid             "}"
#define kSOpenGrid            "{"
#define kSOutline		"OUTLINE"
#define kSAlignExpand		"EXPAND"
#define kSAlignRight		"RIGHT"
#define kSAlignBottom		"BOTTOM"

enum 
{
 kTCreateButton = 1100, 
 kTAt,		
 kTCreateListBox,
 kTCreateListCtrl,
 kTCreateDropDown,	
 kTCreateEditBox,	
 kTCreateMultiEdit,	
 kTCreateTextOut, 
 kTCreateText,		
 kTCreateIcon,          
 kTCreateProgress,	
 kTCreateRadioButton,	
 kTCreateCheckBox,	
 kTCreateChart,		
 kTCreateModel,		
 kTEndGrid,      
 kTOpenGrid,     
 kTOutline,	
 kTAlignExpand,	
 kTAlignRight,	
 kTAlignBottom
}; 



#endif
