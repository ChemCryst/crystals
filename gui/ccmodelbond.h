
#ifndef		__CcModelBond_H__
#define		__CcModelBond_H__

class CrModel;
class CcTokenList;
//#include "crystalsinterface.h"
#include "ccmodelobject.h"

class CcModelBond : public CcModelObject
{
	public:
		Boolean fill;
		CcModelBond();
		~CcModelBond();
            void ParseInput(CcTokenList* tokenList);
            void Render(CrModel* view, Boolean detailed);

	private:
		int x1,y1,z1;
		int x2,y2,z2;
		int ox1,oy1,oz1;
		int ox2,oy2,oz2;
		int r,g,b;
		int rad;
		float length;
		float xrot, yrot;
};

#endif
