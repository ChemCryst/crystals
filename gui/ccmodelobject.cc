#include "crystalsinterface.h"
#include "ccstring.h"
#include "cccontroller.h"
#include "ccmodelobject.h"
#include "ccmodeldoc.h"


CcModelObject::CcModelObject(CcModelDoc* pointer)
{
}

CcModelObject::CcModelObject()
{
   type = 0;
}

CcModelObject::~CcModelObject()
{
}

CcString CcModelObject::Label()
{
  return label;
}

int CcModelObject::Type()
{
  return type;
}
