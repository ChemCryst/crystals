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
   m_type = 0;
}

CcModelObject::~CcModelObject()
{
}

CcString CcModelObject::Label()
{
  return m_label;
}

int CcModelObject::Type()
{
  return m_type;
}

void CcModelObject::Select(bool select)
{
  return;
}

bool CcModelObject::Select()
{
  return false;
}

bool CcModelObject::IsSelected()
{
  return false;
}

void CcModelObject::SendAtom(int style, Boolean output)
{
  return;
}
