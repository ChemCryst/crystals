
#ifndef		__CcModelObject_H__
#define		__CcModelObject_H__

class CrModel;
class CcTokenList;
class CcController;
#include "CcCoord.h"

class CcModelObject
{
	public:
		virtual void Centre(int x, int y, int z);
		CcModelObject();
		virtual ~CcModelObject();
		virtual void Draw(CrModel* ModelToDrawOn) = 0;
		virtual CcCoord ParseInput(CcTokenList* tokenList) = 0;
};

#include	"CcModelAtom.h"
#include	"CcModelBond.h"
#include	"CcModelCell.h"
#include	"CcModelTri.h"

#endif