
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
    CcModelAtom(CcModelDoc* parentptr);
    void Init();
    ~CcModelAtom();

    void Render(CrModel* view, bool detailed);
    void Select(bool select);
    void Disable(bool select);

    bool IsSelected();
    bool Select();
    int X();
    int Y();
    int Z();
    int R();
    CcString Label();
    void ParseInput(CcTokenList* tokenList);
  public:
    bool spare;

//    int mIndex;
//    int ox, oy, oz;
    int x, y, z;
    int r, g, b;
    int id;
    int occ;
    int covrad, vdwrad, sparerad;
//    int uflag;
    int x11, x12, x13, x21, x22, x23, x31, x32, x33;
    CcString label;
    bool m_selected;
    bool m_disabled;
    bool m_IsADP;
    bool m_excluded;
};

class CcModelAtomPtr
{
  public:
    CcModelAtom* atom;
};

#endif
