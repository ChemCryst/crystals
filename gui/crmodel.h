////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModel.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   10.6.1998 13:06 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.23  2011/05/16 10:56:32  rich
//   Added pane support to WX version. Added coloured bonds to model.
//
//   Revision 1.22  2009/09/04 09:25:46  rich
//   Added support for Show/Hide H from model toolbar
//   Fixed atom picking after model update in extra model windows.
//
//   Revision 1.21  2009/07/23 14:15:42  rich
//   Removed all uses of OpenGL feedback buffer - was dreadful slow on some new graphics cards.
//
//   Revision 1.20  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.19  2004/11/09 09:45:03  rich
//   Removed some old stuff. Don't use displaylists on the Mac version.
//
//   Revision 1.18  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.17  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.16  2002/09/27 14:51:36  rich
//   Move definition of ATTACH token into crconstants.
//
//   Revision 1.15  2002/07/04 13:04:44  richard
//
//   glPassThrough was causing probs on Latitude notebook. Can only be called in feedback
//   mode, which means that it can't be stuck into the display lists which are used
//   for drawing aswell. Instead, added feedback logical parameter into all Render calls, when
//   true it does a "feedback" render rather than a display list render. Will slow down polygon
//   selection a negligble amount.
//
//   Revision 1.14  2002/03/13 12:26:26  richard
//   One new popupmenu for clicking on bonds.
//
//   Revision 1.13  2002/02/19 16:34:52  ckp2
//   Menus for plots.
//
//   Revision 1.12  2001/09/07 14:39:06  ckp2
//
//   New modelwindow function lets the user choose a background bitmap to
//   display behind the model. David is correct; I've been to too many
//   conferences. But it's too late now, I've done it.
//
//   Revision 1.11  2001/06/17 15:06:48  richard
//   Rename member variables so that they are prefixed "m_".
//   Moved a lot of code over into CcModelDoc - such as sending lists of atoms
//   to the scripts. The ModelDoc holds the lists so is a simpler place to do this.
//   This removed a lot of pointless "call throughs" from CxModel to CcModelDoc.
//
//   Revision 1.10  2001/03/08 15:41:48  richard
//   Can switch between rotate mode, selection (box) mode. Can also select a fragment
//   based on a single atom name, and you can zoom in on selected atoms (exclude unselected).
//

#ifndef     __CrModel_H__
#define     __CrModel_H__
#include    "crguielement.h"
class CcModelDoc;
class CcModelAtom;
class CcModelObject;
class CrMultiEdit;
class CrMenu;
class Cc2DAtom;
#define CR_SELECT   1
#define CR_SENDA    2
#define CR_SENDB    3
#define CR_SENDC    4
#define CR_SENDD    5
#define CR_APPEND   6
#define CR_SENDC_AND_SELECT 7
#define CR_INSERTIN 8

class CxModel;

#define BONDSTYLE_BLACK 0
#define BONDSTYLE_HALFPARENTELEMENT 1
#define BONDSTYLE_HALFPARENTPART 2

class   CcModelStyle
{
public:
   int radius_type;
   float radius_scale;
   int normal_res;
   bool showh;
   int bond_style;
   CxModel* m_modview;
};

class   CrModel : public CrGUIElement
{
  public:
// Called from controller or grid:
            CrModel( CrGUIElement * mParentPtr );
            ~CrModel();
    void    GetValue();
	void    GetValue(deque<string> &  tokenList);
	int     GetIdealWidth();
    int     GetIdealHeight();
    void    CrFocus();
    CcParse ParseInput( deque<string> & tokenList );
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry();
    CcRect  CalcLayout(bool recalculate=false);
    void    SetText( const string &text );
    void    SysKey ( UINT nChar );
    void    SysKeyUp ( UINT nChar );

// Called from CxModel:
    bool RenderModel();
    bool RenderAtoms(bool feedback=false);
    bool RenderBonds(bool feedback=false);
	CcRect FindModel2DExtent(float * mat);
	std::list<Cc2DAtom> AtomCoords2D(float * mat);
	
    void    MenuSelected(int id);
    void    ContextMenu(int x, int y, string atomname = "", int selection = 1, string atom2="");
    int     GetSelectionAction();
    CcModelObject * FindObjectByGLName(GLuint name);

// General purpose:
    void    Update(bool rescale);
    void    SelectFrag(string atomname, bool select);

// Called from CcModelDoc:
    void    DocRemoved();
    void    ApplyIndexColour( GLuint indx );
    void    SendInsertText( string s );

// Attributes:
    CcModelStyle m_style; //only public 'til I fix CxModel to use GL_SELECT

  private:

// Attributes:
    CrMultiEdit* m_InsertWindow;
    CcModelDoc* m_ModelDoc;
    CrMenu     *m_popupMenu1, *m_popupMenu2, *m_popupMenu3,
               *m_popupMenu4;
    int         m_AtomSelectAction;
};




// CrModel
#define kSModelShow         "SHOW"
#define kSModelBond         "BOND"
#define kSModelAtom         "ATOM"
#define kSModelCell         "CELL"
#define kSModelTri          "FTRI"
#define kSModelClear        "CLEAR"
#define kSRadiusType        "RADTYPE"
#define kSRadiusScale       "RADSCALE"
#define kSBondStyle         "BONDSTYLE"
#define kSNormal            "NORMAL"
#define kSElement           "ELEMENT"
#define kSPart              "PART"
#define kSVDW               "VDW"
#define kSThermal           "THERMAL"
#define kSSpare             "SPARE"
#define kSCovalent          "COV"
#define kSTiny              "TINY"
#define kSSelectAction      "MOUSEACTION"
#define kSSelect            "SELECTATOM"
#define kSAppendTo          "APPENDATOM"
#define kSSendA             "SENDATOM"
#define kSSendB             "SPLITATOM"
#define kSSendC             "HEADERATOM"
#define kSSendD             "HEADERSPLITATOM"
#define kSSendCAndSelect    "SENDANDSELECT"
#define kSInsertIn          "INSERTIN"
#define kSCheckValue        "CHECKVALUE"
#define kSNRes              "NRES"
#define kSStyle             "STYLE"
#define kSStyleSmooth       "SMOOTH"
#define kSStyleLine         "LINE"
#define kSStylePoint        "POINT"
#define kSAutoSize          "AUTOSIZE"
#define kSHover             "HOVER"
#define kSShading           "SHADING"
#define kSRotateTool        "MODROTATE"
#define kSSelectTool        "MODSELECT"
#define kSSelectRect        "RECT"
#define kSSelectPoly        "POLY"
#define kSZoomSelected      "ZOOMATOMS"
#define kSSelectFrag        "SELFRAG"
#define kSLoadBitmap        "LOADBITMAP"
#define kSShowH             "SHOWH"

enum
{
 kTModelShow=1400,
 kTModelBond,
 kTModelAtom,
 kTModelCell,
 kTModelTri,
 kTModelClear,
 kTRadiusType,
 kTRadiusScale,
 kTBondStyle,
 kTVDW,
 kTThermal,
 kTSpare,
 kTCovalent,
 kTTiny,
 kTNormal,
 kTElement,
 kTPart,
 kTSelectAction,
 kTSelect,
 kTAppendTo,
 kTSendA,
 kTSendB,
 kTSendC,
 kTSendD,
 kTSendCAndSelect,
 kTInsertIn,
 kTCheckValue,
 kTNRes,
 kTStyle,
 kTStyleSmooth,
 kTStyleLine,
 kTStylePoint,
 kTAutoSize,
 kTHover,
 kTShading,
 kTSelectTool,
 kTSelectRect,
 kTSelectPoly,
 kTRotateTool,
 kTZoomSelected,
 kTSelectFrag,
 kTLoadBitmap,
 kTShowH
};




#endif
