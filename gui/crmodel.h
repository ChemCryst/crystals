////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModel.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   10.6.1998 13:06 Uhr
//   $Log: not supported by cvs2svn $
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
class CcTokenList;
class CcModelAtom;
class CcModelObject;
class CrMenu;
#define CR_SELECT   1
#define CR_SENDA    2
#define CR_SENDB    3
#define CR_SENDC    4
#define CR_SENDD    5
#define CR_APPEND   6
#define CR_SENDC_AND_SELECT 7


class   CcModelStyle
{
public:
   int radius_type;
   float radius_scale;
   int normal_res;
   int quick_res;
   Boolean high_res;
};

class   CrModel : public CrGUIElement
{
  public:
// Called from controller or grid:
            CrModel( CrGUIElement * mParentPtr );
            ~CrModel();
    void    GetValue();
    int     GetIdealWidth();
    int     GetIdealHeight();
    void    CrFocus();
    CcParse ParseInput( CcTokenList * tokenList );
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry();
    CcRect  CalcLayout(bool recalculate=false);
    void    SetText( CcString text );
    void    SysKey ( UINT nChar );
    void    SysKeyUp ( UINT nChar );

// Called from CxModel:
    Boolean RenderModel(Boolean detailed);
    void    MenuSelected(int id);
    void    ContextMenu(int x, int y, CcString atomname = "", bool selection = false);
    int     GetSelectionAction();
    CcModelObject * FindObjectByGLName(GLuint name);

// General purpose:
    void    Update();
    void    SelectFrag(CcString atomname, bool select);

// Called from CcModelDoc:
    void    DocRemoved();


// Attributes:
    CcModelStyle m_style; //only public 'til I fix CxModel to use GL_SELECT

  private:

// Attributes:
    CcModelDoc* m_ModelDoc;
    CrMenu*     m_popupMenu1;
    CrMenu*     m_popupMenu2;
    CrMenu*     m_popupMenu3;
    int         m_AtomSelectAction;
};




// CrModel
#define kSAttachModel       "ATTACH"
#define kSModelShow         "SHOW"
#define kSModelBond         "BOND"
#define kSModelAtom         "ATOM"
#define kSModelCell         "CELL"
#define kSModelTri          "FTRI"
#define kSModelClear        "CLEAR"
#define kSRadiusType        "RADTYPE"
#define kSRadiusScale       "RADSCALE"
#define kSVDW               "VDW"
#define kSThermal           "THERMAL"
#define kSSpare             "SPARE"
#define kSCovalent          "COV"
#define kSSelectAction      "MOUSEACTION"
#define kSSelect            "SELECTATOM"
#define kSAppendTo          "APPENDATOM"
#define kSSendA             "SENDATOM"
#define kSSendB             "SPLITATOM"
#define kSSendC             "HEADERATOM"
#define kSSendD             "HEADERSPLITATOM"
#define kSSendCAndSelect    "SENDANDSELECT"
#define kSCheckValue        "CHECKVALUE"
#define kSNRes              "NRES"
#define kSQRes              "QRES"
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

enum
{
 kTAttachModel=1400,
 kTModelShow,
 kTModelBond,
 kTModelAtom,
 kTModelCell,
 kTModelTri,
 kTModelClear,
 kTRadiusType,
 kTRadiusScale,
 kTVDW,
 kTThermal,
 kTSpare,
 kTCovalent,
 kTSelectAction,
 kTSelect,
 kTAppendTo,
 kTSendA,
 kTSendB,
 kTSendC,
 kTSendD,
 kTSendCAndSelect,
 kTCheckValue,
 kTNRes,
 kTQRes,
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
 kTLoadBitmap
};




#endif
