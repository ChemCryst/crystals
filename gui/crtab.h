////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrTab

////////////////////////////////////////////////////////////////////////

//   Filename:  CrTab.h
//   Authors:   Richard Cooper
//   Created:   23.1.2001 22:18

#ifndef         __CrTab_H__
#define         __CrTab_H__
#include    "crguielement.h"
#include    "cclist.h"

class CcTokenList;
class CrGrid;

class CcTabData
{
  public:
    CcString tabName;
    CcString tabText;
    CrGrid*  tabGrid;
};


class   CrTab : public CrGUIElement
{
  public:

    CrTab( CrGUIElement * mParentPtr );
    ~CrTab();

    CcParse ParseInput( CcTokenList * tokenList );
    CcRect  GetGeometry();
    CcRect CalcLayout(bool recalculate=false);
    void SetGeometry( const CcRect * rect );
    void SetText( CcString item );
    void CrFocus();
    void ChangeTab(int tab);
    int GetIdealHeight();
    int GetIdealWidth();
    CrGUIElement *  FindObject( CcString Name );

  private:

    CcList mTabsList;
    int m_nTabs;
    CrGrid* m_currentTab;
};

#define kSCreateTab          "TAB"

enum
{
 kTCreateTab = 1200
};



#endif
