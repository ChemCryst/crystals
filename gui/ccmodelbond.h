
#ifndef		__CcModelBond_H__
#define		__CcModelBond_H__

class CrModel;
class CcTokenList;
//#include "crystalsinterface.h"
#include "ccmodelobject.h"

class CcModelAtom;
class CcModelStyle;

class CcModelBond : public CcModelObject
{
  public:
    CcModelBond(CcModelDoc* pointer);
    ~CcModelBond();
    void ParseInput(CcTokenList* tokenList);
    void Render(CcModelStyle *style);
    void SelfExclude();
    bool m_excluded;
    CcModelAtom *atom1, *atom2;

  private:
    int x1,y1,z1;
    int x2,y2,z2;
    int r,g,b;
    int rad;
    float length;
    float xrot, yrot;
};


#endif
