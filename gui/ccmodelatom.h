
#ifndef		__CcModelAtom_H__
#define		__CcModelAtom_H__

class CrModel;
class CcTokenList;
class CcModelDoc;
//#include "crystalsinterface.h"
#include "ccmodelobject.h"

class CcModelAtom : public CcModelObject
{
	public:
            void Render(CrModel* view, Boolean detailed);
		void Select(Boolean select);
		Boolean IsSelected();
		Boolean Select();
		int X();
		int Y();
		int Z();
		int R();
		CcString Label();
		CcModelAtom(CcModelDoc* parentptr);
		CcModelAtom();
		~CcModelAtom();
            void ParseInput(CcTokenList* tokenList);
		CcModelDoc* parent;

		int mIndex;
		int ox, oy, oz;
		int x, y, z;
		int r, g, b;
		int id;
		int occ;
            int covrad, vdwrad, sparerad;
		int uflag;
            int x11, x12, x13, x21, x22, x23, x31, x32, x33;
		CcString label;
		Boolean m_selected;
};

#endif
