////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcModelDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcModelDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 11:25 Uhr

//BIG NOTICE: ModelDoc is not a CrGUIElement, it's more like a list
//            of drawing commands.
//            You can attach a CrModel to it and it will then draw
//            itself on that CrModel's drawing area.
//            It does contain a ParseInput routine for parsing the
//            drawing commands. Note again - it is not a CrGUIElement,
//            it has no graphical presence, nor a complimentary Cx- class

#ifndef		__CcModelDoc_H__
#define		__CcModelDoc_H__

#ifdef __CR_WIN__
#include <GL/glu.h>
#include <GL/gl.h>
#endif
#ifdef __BOTHWX__
#include <wx/glcanvas.h>
#include <GL/glu.h>
#endif

#include "ccstring.h"	// added by classview
#include "cclist.h"	// added by classView
class CcTokenList;
class CrModel;
class CcList;
class CcModelAtom;

class CcModelDoc
{
	public:
            Boolean RenderModel( CrModel* view, Boolean detailed );
		void InvertSelection();
		CcString Compress(CcString atomname);
		void SelectAllAtoms(Boolean select);
		void SelectAtomByLabel(CcString atomname, Boolean select);
                void DisableAtomByLabel(CcString atomname, Boolean select);
		CcModelAtom* FindAtomByLabel(CcString atomname);
		void PrepareToGetAtoms();
		void Select(Boolean selected);
		void HighlightView(CrModel* aView);
		CcModelAtom* GetModelAtom();
		void RemoveView(CrModel* aView);
		void DrawViews();
		void AddModelView(CrModel* aView);
		void Clear();
		CcModelDoc();
		~CcModelDoc();
		Boolean	ParseInput( CcTokenList * tokenList );


		CcString mName;
		CcList attachedViews;
	private:
		int nSelected;
		int m_nAtoms;
		int m_TotX;
		int m_TotY;
		int m_TotZ;
		CcList* mAtomList;
		CcList* mBondList;
		CcList* mCellList;
		CcList* mTriList;
};

#endif
