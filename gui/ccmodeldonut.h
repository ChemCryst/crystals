
#ifndef         __CcModelDonut_H__
#define         __CcModelDonut_H__

class CrModel;
class CcTokenList;
class CcModelDoc;
#include "ccmodelobject.h"

class CcModelStyle;


class CcModelDonut : public CcModelObject
{
  public:
    CcModelDonut(CcModelDoc* parentptr);
    CcModelDonut(CcString label,int x1,int y1,int z1, 
                    int r, int g, int b, int occ,int cov, int vdw,
                    int spare, int flag,
                    int iso, int irad, int idec, int iaz, CcModelDoc* parentptr);

    void Init();
    ~CcModelDonut();

    void Render(CcModelStyle *style, bool feedback=false);
    void Select(bool select);
    void Disable(bool select);
    void SendAtom(int style, Boolean output=false); 

    bool IsSelected();
    bool Select();
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
    int x11;
    int rad;
    int dec;
    int az;
    bool m_selected;
    bool m_disabled;
    bool m_excluded;
};

#endif
