////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrModList

////////////////////////////////////////////////////////////////////////

//   Filename:  CrModList.h
//   Authors:   Richard Cooper

#ifndef     __CrModList_H__
#define     __CrModList_H__
#include    "crguielement.h"
#include    "cctokenlist.h"

class CcModelDoc;
class CrMenu;

class   CrModList : public CrGUIElement
{
    public:
        void SendValue(CcString message);
        int GetIdealHeight();
        int GetIdealWidth();
        int m_cols;
        CrModList( CrGUIElement * mParentPtr );
        ~CrModList();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    SetText( CcString item );
        void    GetValue();
        void    GetValue( CcTokenList * tokenList );
        void CrFocus();
        void DocToList();
        void AddRow ( int id, CcString * rowOfStrings, bool s, bool d);
        void DocRemoved();
        void Update(int newsize);
        void    MenuSelected(int id);
        void SelectAtomByPosn (int id, bool select);
        void ContextMenu(int x, int y, int iitem, int mtype);
    private:
        CcModelDoc* m_ModelDoc;
        CrMenu *m_popupMenu1, *m_popupMenu2, *m_popupMenu3;

};
#endif
