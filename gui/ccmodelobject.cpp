#include "crystalsinterface.h"
#include <string>
using namespace std;

#include "cccontroller.h"
#include "ccmodelobject.h"
#include "ccmodeldoc.h"


CcModelObject::CcModelObject(CcModelDoc* pointer)
{
}

CcModelObject::CcModelObject()
{
   m_type = 0;
   m_disabled = false;
   m_selected = false;
   m_excluded = false;
}

CcModelObject::~CcModelObject()
{
}

string CcModelObject::Label()
{
  return m_label;
}

int CcModelObject::Type()
{
  return m_type;
}

bool CcModelObject::Select()
{
    m_selected = !m_selected;
        mp_parent->Select(m_selected);
    return m_selected;
}

void CcModelObject::Select(bool select)
{
    if(m_selected != select)  //Counter in parent must only find out about change.
            mp_parent->Select(select); 
    m_selected = select;
}

bool CcModelObject::IsSelected()
{
    return m_selected;
}

void CcModelObject::Disable(bool select)
{
  m_disabled = select;
  return;
}

void CcModelObject::SendAtom(int style, bool output)
{
  return;
}
