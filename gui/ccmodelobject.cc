#include "crystalsinterface.h"
#include "CcController.h"
#include "CcModelObject.h"


CcModelObject::CcModelObject()
{
}

CcModelObject::~CcModelObject()
{
}

void CcModelObject::Centre(int x, int y, int z)
{
NOTUSED(x);   //This is an overridable function.
NOTUSED(y);   //The default does nothing.
NOTUSED(z);
}
