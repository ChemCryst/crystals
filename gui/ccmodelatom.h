
#ifndef		__CcModelAtom_H__
#define		__CcModelAtom_H__

class CrModel;
class CcTokenList;
class CcModelDoc;
#include "ccmodelobject.h"

class CcModelStyle;


class CcModelAtom : public CcModelObject
{
  public:
    CcModelAtom(CcModelDoc* parentptr);
    CcModelAtom(CcString label,int x1,int y1,int z1, 
                    int r, int g, int b, int occ,int cov, int vdw,
                    int spare, int flag,
                    int u1,int u2,int u3,int u4,int u5,
                    int u6,int u7,int u8,int u9,
                    CcModelDoc* parentptr);

    void Init();
    ~CcModelAtom();

    void Render(CcModelStyle *style, bool feedback=false);
    void Select(bool select);
    bool Select();
    void Disable(bool select);
    void SendAtom(int style, Boolean output=false); 

    bool IsSelected();
    int X();
    int Y();
    int Z();
    int R();
    void ParseInput(CcTokenList* tokenList);

  public:
    int x, y, z;
    int r, g, b;
    int id;
    int occ;
    int covrad, vdwrad, sparerad;
    int x11, x12, x13, x21, x22, x23, x31, x32, x33;
    bool m_selected;
    bool m_disabled;
    bool m_IsADP;
    bool m_excluded;
};

#endif
