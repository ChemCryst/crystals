
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
    void Init();
    ~CcModelAtom();

    void Render(CcModelStyle *style);
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
    bool spare;

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
