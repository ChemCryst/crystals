
#ifndef		__CcModelAtom_H__
#define		__CcModelAtom_H__

class CrModel;
class CcTokenList;
class CcModelDoc;
//#include "crystalsinterface.h"
#include "CcModelObject.h"

class CcModelAtom : public CcModelObject
{
	public:
		void Select(Boolean select);
		Boolean IsSelected();
		int Vdw();
		void Highlight(CrModel* aView);
		Boolean Select();
		int X();
		int Y();
		int Z();
		int R();
		CcString Label();
		int mIndex;
		void Centre(int nx, int ny, int nz);
		CcModelAtom(CcModelDoc* parentptr);
		CcModelAtom();
		~CcModelAtom();
		void Draw(CrModel* ModelToDrawOn);
		CcCoord ParseInput(CcTokenList* tokenList);
	private:
		CcModelDoc* parent;
		int ox, oy, oz;
		int x, y, z;
		int r, g, b;
		int id;
		int occ;
		int covrad, vdwrad;
		int uflag;
		int u1, u2, u3, u4, u5, u6;
		CcString label;
		Boolean m_selected;
};

#endif