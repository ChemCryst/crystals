////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrTab

////////////////////////////////////////////////////////////////////////

//   Filename:  CrTab.h
//   Authors:   Richard Cooper
//   Created:   23.1.2001 22:18

#ifndef         __CrTab_H__
#define         __CrTab_H__
#include    "crguielement.h"
#include <list>
using namespace std;

class CrGrid;

class CcTabData
{
  public:
    string tabName;
    string tabText;
    CrGrid*  tabGrid;
};


class   CrTab : public CrGUIElement
{
  public:

    CrTab( CrGUIElement * mParentPtr );
    ~CrTab();

    CcParse ParseInput( deque<string> & tokenList );
    CcRect  GetGeometry();
    CcRect CalcLayout(bool recalculate=false);
    void SetGeometry( const CcRect * rect );
    void SetText( const string &item );
    void CrFocus();
    void ChangeTab(int tab);
    int GetIdealHeight();
    int GetIdealWidth();
    CrGUIElement *  FindObject( const string & Name );

  private:

    list<CrGrid*> mTabsList;
    int m_nTabs;
    CrGrid* m_currentTab;
};

#define kSCreateTab          "TAB"

enum
{
 kTCreateTab = 1200
};



#endif
