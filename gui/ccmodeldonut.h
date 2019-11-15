
#ifndef         __CcModelDonut_H__
#define         __CcModelDonut_H__

class CrModel;
class CcModelDoc;
#include "ccmodelobject.h"

class CcModelStyle;


class CcModelDonut : public CcModelObject
{
  public:
    CcModelDonut(CcModelDoc* parentptr);
    CcModelDonut(string label,int x1,int y1,int z1, 
                    int r, int g, int b, int occ,int cov, int vdw,
                    int spare, int flag,
                    int iso, int irad, int idec, int iaz, 
                    float fx, float fy, float fz,
                    const string & elem, int serial, int refflag,
                    int assembly, int group, float ueq, float fspare, int isflg,
                    CcModelDoc* parentptr);

    void Init();
    ~CcModelDonut();

    void Render(CcModelStyle *style, bool feedback=false);
    void SendAtom(int style, bool output=false); 

    int X();
    int Y();
    int Z();
    int R();
    int Radius(CcModelStyle * style);
    CcPoint Get2DCoord(float * mat);
    void ParseInput(deque<string> & tokenList);

  public:

    int x, y, z;
    int occ;
    int covrad, vdwrad, sparerad;
    int x11;
    int rad;
    int dec;
    int az;
    float frac_x, frac_y, frac_z;
    float m_ueq;
    float m_spare;
    int m_serial;
    int m_refflag;
    int m_assembly;
    int m_group;
    int m_isflg;
    string m_elem;
    string m_sflags;
};

#endif
