////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModList

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModList.h
//   Authors:   Richard Cooper

#ifndef     __CrModList_H__
#define     __CrModList_H__
#include    "crguielement.h"

#include <vector>
#include <string>
using namespace std;

class CcModelDoc;
class CrMenu;
class CcModelAtom;

class   CrModList : public CrGUIElement
{
    public:
        void SendValue(const string & message);
        int GetIdealHeight();
        int GetIdealWidth();
        int m_cols;
        CrModList( CrGUIElement * mParentPtr );
        ~CrModList();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    SetText( const string &item );
        void    GetValue();
        void    GetValue( deque<string> & tokenList );
        void CrFocus();
        void DocToList();
        void AddRow ( int id, vector<string> & rowOfStrings, bool s, bool d);
        void DocRemoved();
        void Update(int newsize);
        void    MenuSelected(int id);
        void SelectAtomByPosn (int id, bool select);
        void ContextMenu(int x, int y, int iitem, int mtype);
        void EnsureVisible(CcModelAtom* va);
    private:
        CcModelDoc* m_ModelDoc;
        CrMenu *m_popupMenu1, *m_popupMenu2, *m_popupMenu3;

};
#endif
