
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
		void Draw(CrModel* ModelToDrawOn);
		void Centre(int nx, int ny, int nz);
		CcCoord ParseInput(CcTokenList* tokenList);
	private:
		int x1,y1,z1;
		int x2,y2,z2;
		int ox1,oy1,oz1;
		int ox2,oy2,oz2;
		int r,g,b;
		int rad;
};

#endif