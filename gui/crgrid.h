////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGrid.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:59 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.17  2011/04/16 07:09:51  rich
//   Web control
//
//   Revision 1.16  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.15  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.14  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.13  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.12  2002/10/02 13:43:17  rich
//   New ModList class added.
//
//   Revision 1.11  2002/07/23 08:27:02  richard
//
//   Extra parameter during GRID creation: "ISOLATE" - grid won't expand when the
//   window resizes, even if it contains objects which might like to expand.
//
//   Revision 1.10  2002/05/14 17:04:49  richard
//   Changes to include new GUI control HIDDENSTRING.
//
//   Revision 1.9  2001/10/10 12:44:50  ckp2
//   The PLOT classes!
//
//   Revision 1.8  2001/03/08 15:36:04  richard
//   Completely re-written the window sizing and layout code. Now much simpler.
//   Calclayout works out and returns the size of a GUI object, so that the
//   calling window knows what size to make itself initially. The setgeom call then
//   actaully sets the sizes. During resize the difference between
//   the available size and the original size is used to calculate how much
//   to expand or shrink each object.
//

#ifndef     __CrGrid_H__
#define     __CrGrid_H__
#include    "crguielement.h"
#include   <list>
#include   <vector>

class CxGroupBox;

class   CrGrid : public CrGUIElement
{
  public:
    CrGrid( CrGUIElement * mParentPtr );
    ~CrGrid();

    CcParse ParseInput( deque<string> &  tokenList );
    void CrFocus();
    int GetIdealHeight();
    int GetIdealWidth();
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry();
    CcRect CalcLayout(bool recalculate=false);

	
    void    SetText( const string &item );
    bool    GridComplete() {  return m_GridComplete; } ;
    CcParse InitElement( CrGUIElement * element, deque<string> & tokenList, int xpos, int ypos );
    void    Align();
    int     GetHeightOfRow( int row );
    int     GetWidthOfColumn( int col );
    CrGUIElement *  FindObject( const string & Name );
    void    SendCommand(const string & theText, bool jumpQueue);
    void    SetCommandText(const string & theText);
    void    CrShowGrid(bool state);
    CrGUIElement *  GetPointer( int xpos, int ypos );
    void    ResizeGrid( int w, int h );
	void 	GridSetGeometry( const CcRect * rect );

    int     m_Columns;
    int     m_Rows;


  protected:
    bool SetPointer( int xpos, int ypos, CrGUIElement * ptr );

    list<CrGUIElement*> m_ItemList;
    bool m_GridComplete;
    CrGrid *        m_ActiveSubGrid;
    vector < vector < CrGUIElement * > > m_TheGrid;
    CxGroupBox *    m_OutlineWidget;
    bool m_CommandSet;
    string m_CommandText;

    vector<int> m_InitialColWidths;
    vector<int> m_InitialRowHeights;
    vector<bool> m_ColCanResize;
    vector<bool> m_RowCanResize;

    int m_InitContentWidth;
    int m_ContentWidth;
    int m_InitContentHeight;
    int m_ContentHeight;
    float m_resizeableWidth;
    float m_resizeableHeight;
	bool m_IsPane;
};

#define kSCreateButton      "BUTTON"
#define kSAt            "@"
#define kSCreateListBox     "LISTBOX"
#define kSCreateListCtrl    "LISTCTRL"
#define kSCreateModList    "MODLIST"
#define kSCreateDropDown    "DROPDOWN"
#define kSCreateEditBox     "EDITBOX"
#define kSCreateSlider      "SLIDER"
#define kSCreateMultiEdit   "MULTIEDIT"
#define kSCreateTextOut         "TEXTOUT"
#define kSCreateText        "STATIC"
#define kSCreateIcon          "ICON"
#define kSCreateProgress    "PROGRESS"
#define kSCreateRadioButton "RADIOBUTTON"
#define kSCreateCheckBox    "CHECKBOX"
#define kSCreateChart       "CHARTWINDOW"
#define kSCreatePlot       "PLOTWINDOW"
#define kSCreateModel       "MODELWINDOW"
#define kSOutline       "OUTLINE"
#define kSAlignIsolate       "ISOLATE"
#define kSAlignRight        "RIGHT"
#define kSAlignBottom       "BOTTOM"
#define kSCreateBitmap          "BITMAP"
#define kSCreateTabCtrl         "TABCTRL"
#define kSCreateToolBar         "TOOLBAR"
#define kSCreateResize          "RESIZE"
#define kSCreateStretch          "STRETCH"
#define kSCreateHidden          "HIDDENSTRING"
#define kSCreateWeb         "WEB"
#define kSRight         "RIGHT"
#define kSBottom        "BOTTOM"
#define kSTop           "TOP"
#define kSLeft          "LEFT"
#define kSCentre        "CENTRE"
#define kSPane        "PANE"

enum
{
 kTCreateButton = 1100,
 kTAt,
 kTCreateListBox,
 kTCreateListCtrl,
 kTCreateModList,
 kTCreateDropDown,
 kTCreateEditBox,
 kTCreateSlider,
 kTCreateMultiEdit,
 kTCreateTextOut,
 kTCreateText,
 kTCreateIcon,
 kTCreateProgress,
 kTCreateRadioButton,
 kTCreateCheckBox,
 kTCreateChart,
 kTCreateModel,
 kTOutline,
 kTAlignIsolate,
 kTAlignRight,
 kTAlignBottom,
 kTCreateBitmap,
 kTCreateTabCtrl,
 kTCreateToolBar,
 kTCreateResize,
 kTCreateStretch,
 kTCreatePlot,
 kTCreateHidden,
 kTCreateWeb,
 kTRight,
 kTBottom,
 kTTop,
 kTLeft,
 kTCentre,
 kTPane
};



#endif
