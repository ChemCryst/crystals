
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
    CcModelBond(int x1,int y1,int z1, int x2, int y2, int z2,
                int r, int g, int b,  int rad,int btype,
                int np, int * ptrs, CcString label, CcString cslabl,
                CcModelDoc* ptr);
    ~CcModelBond();
    void ParseInput(CcTokenList* tokenList);
    void Render(CcModelStyle *style, bool feedback=false);
    void SelfExclude();
    bool m_excluded;
    CcModelAtom *m_atom1, *m_atom2, **m_patms;

    int m_bondtype;
    int m_np;
    bool m_bsym;
    CcString m_slabel;

  private:
    int m_x1,m_y1,m_z1;
    int m_x2,m_y2,m_z2;
    int m_r,m_g,m_b;
    int m_rad;
    float m_length;
    float m_xrot, m_yrot;

};


#endif
