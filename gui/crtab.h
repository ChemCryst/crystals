////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrTab

////////////////////////////////////////////////////////////////////////

//   Filename:  CrTab.h
//   Authors:   Richard Cooper 
//   Created:   23.1.2001 22:18

#ifndef         __CrTab_H__
#define         __CrTab_H__
#include	"crguielement.h"
#include	"cclist.h"

class CcTokenList;
class CrGrid;

class   CrTab : public CrGUIElement
{
  public:
    CrTab( CrGUIElement * mParentPtr );
    ~CrTab();
    Boolean ParseInput( CcTokenList * tokenList );
    void    SetGeometry( const CcRect * rect );
    CcRect  GetGeometry();
    void    CalcLayout();
    void  SetOriginalSizes();
    void    SetText( CcString item );
    CrGUIElement *  FindObject( CcString Name );
    void CrFocus();
    void ChangeTab(int tab);
    void Resize(int newWidth, int newHeight, int origWidth, int origHeight);
    int GetIdealHeight();
    int GetIdealWidth();

    CcList mTabsList;
    int m_tabH;
    int m_nTabs;
    int m_GridH;
    int m_GridW;
    CrGUIElement* m_nRealParent;
    CrGrid* m_currentTab;
};

#define kSCreateTab          "TAB"

enum 
{
 kTCreateTab = 1200 
};



#endif
