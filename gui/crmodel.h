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
		void SendAtom(CcModelAtom* atom, Boolean output = false);
		int m_AtomSelectAction;
		int m_AtomGetAction;
		void GetValue();
		CcModelAtom* GetSelectedAtoms (int * nSelected);
		void UpdateHighlights();
		void PrepareToGetAtoms();
		void MenuSelected(int id);
		CrMenu* popupMenu1;
		CrMenu* popupMenu2;
		CrMenu* popupMenu3;
		void ContextMenu(int x, int y, CcString atomname = "", int nSelected = 0, CcString* atomNames = nil);
		void HighlightAtom(CcModelAtom* theAtom);
		void ClearHighlights();
		void ReDrawHighlights();
		CcModelAtom* GetModelAtom();
		void DrawBond(int x1,int y1,int z1,int x2,int y2,int z2,int r,int g,int b,int rad);
		void DrawTri(int x1, int y1, int z1, int x2, int y2, int z2, int x3, int y3, int z3, int r, int g, int b, Boolean fill);
		void Start();
		void DrawAtom(int x, int y, int z, int r, int g, int b, int cov, int vdw);
		void DocRemoved();
		void LMouseClick(int x, int y);
		void Clear();
		int GetIdealWidth();
		int GetIdealHeight();
//		void Attach(CcModelDoc* doc);
		CcModelDoc* mAttachedModelDoc;
		void ReDrawView();
		void Display();
		void CrFocus();
		CrModel( CrGUIElement * mParentPtr );
		~CrModel();
		Boolean	ParseInput( CcTokenList * tokenList );
		void	SetGeometry( const CcRect * rect );
		CcRect	GetGeometry();
		void	CalcLayout();
		void	SetText( CcString text );
};
#endif
