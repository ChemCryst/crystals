////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModel.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   10.6.1998 13:06 Uhr
//   Modified:  10.6.1998 13:06 Uhr

#ifndef		__CrModel_H__
#define		__CrModel_H__
#include	"crguielement.h"
//Insert your own code here.
class CcModelDoc;
class CcTokenList;
class CcModelAtom;
class CrMenu;
//End of user code.         
#define CR_SELECT	1
#define CR_SENDA	2
#define CR_SENDB	3
#define CR_SENDC	4
#define CR_SENDD	5
#define CR_APPEND	6
#define CR_SENDC_AND_SELECT	7

class	CrModel : public CrGUIElement
{
	public:

            CcModelAtom* LitAtom();
            int RadiusType();
            float RadiusScale();
            void RenderModel(Boolean detailed);
            void SendAtom(CcModelAtom* atom, Boolean output = false);
            void GetValue();
            CcModelAtom* GetSelectedAtoms (int * nSelected);

            void Update();

            void PrepareToGetAtoms();
            void MenuSelected(int id);
            void ContextMenu(int x, int y, CcString atomname = "", int nSelected = 0, CcString* atomNames = nil);
            CcModelAtom* GetModelAtom();
            void DocRemoved();
            void LMouseClick(int x, int y);
            int GetIdealWidth();
            int GetIdealHeight();
            void CrFocus();
            CrModel( CrGUIElement * mParentPtr );
            ~CrModel();
            Boolean ParseInput( CcTokenList * tokenList );
            void    SetGeometry( const CcRect * rect );
            CcRect  GetGeometry();
            void    CalcLayout();
            void    SetText( CcString text );
            void    SysKey ( UINT nChar );
            void    SysKeyUp ( UINT nChar );

            CcModelDoc* mAttachedModelDoc;
            int m_AtomSelectAction;
            int m_AtomGetAction;
            CrMenu* popupMenu1;
            CrMenu* popupMenu2;
            CrMenu* popupMenu3;

            int m_NormalRes;
            int m_QuickRes;
};

// CrModel
#define kSDefinePopupMenu	"DEFINEPOPUPMENU"
#define kSAttachModel		"ATTACH"
#define kSModelShow		"SHOW"
#define kSModelBond		"BOND"
#define kSModelAtom		"ATOM"
#define kSModelCell		"CELL"
#define kSModelTri		"FTRI"
#define kSModelClear		"CLEAR"
#define	kSRadiusType		"RADTYPE"
#define	kSRadiusScale		"RADSCALE"
#define	kSVDW			"VDW"
#define kSThermal               "THERMAL"
#define	kSCovalent		"COV"
#define kSSelectAction		"MOUSEACTION"
#define kSSelect		"SELECTATOM"
#define kSAppendTo		"APPENDATOM"
#define kSSendA			"SENDATOM"
#define kSSendB			"SPLITATOM"
#define kSSendC			"HEADERATOM"
#define kSSendD			"HEADERSPLITATOM"
#define kSSendCAndSelect	"SENDANDSELECT"
#define kSCheckValue		"CHECKVALUE"
#define kSNRes                "NRES"
#define kSQRes                "QRES"
#define kSStyle               "STYLE"
#define kSStyleSmooth         "SMOOTH"
#define kSStyleLine           "LINE"
#define kSStylePoint          "POINT"
#define kSAutoSize            "AUTOSIZE"
#define kSHover               "HOVER"
#define kSShading             "SHADING"


enum
{
 kTDefinePopupMenu = 1400,
 kTAttachModel,
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
 kTShading      
};




#endif
