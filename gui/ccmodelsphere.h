
#ifndef         __CcModelSphere_H__
#define         __CcModelSphere_H__

class CrModel;
class CcModelDoc;
class CcPoint;
#include "ccmodelobject.h"

class CcModelStyle;


class CcModelSphere : public CcModelObject
{
  public:
    CcModelSphere(CcModelDoc* parentptr);
    CcModelSphere(string label,int x1,int y1,int z1, 
                    int r, int g, int b, int occ,int cov, int vdw,
                    int spare, int flag,
                    int iso, int irad, 
                    float frac_x, float frac_y, float frac_z,
                    const string & elem, int serial, int refflag,
                    int assembly, int group, float ueq, float fspare, int isflg,
                    CcModelDoc* parentptr);

    void Init();
    ~CcModelSphere();

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
    float frac_x, frac_y, frac_z;
    int occ;
    int covrad, vdwrad, sparerad;
    int x11;
    int rad;
    float m_ueq;
    float m_spare;

    int m_serial;
    int m_refflag;
    int m_assembly;
    int m_group;
    int m_nbonds;
    int m_nQbonds;
    int m_isflg;
    string m_elem;
    string m_sflags;

    
};

#endif
