////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListCtrl.h
//   Authors:   Richard Cooper

#ifndef     __CrListCtrl_H__
#define     __CrListCtrl_H__
#include    "crguielement.h"
#include    "cctokenlist.h"

class   CrListCtrl : public CrGUIElement
{
    public:
        void SendValue(CcString message);
        int GetIdealHeight();
        int GetIdealWidth();
        int m_cols;
        CrListCtrl( CrGUIElement * mParentPtr );
        ~CrListCtrl();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    SetText( CcString item );
        void    GetValue();
        void    GetValue( CcTokenList * tokenList );
        void CrFocus();
};

#define kSSortColumn     "SORTCOL"

enum
{
 kTSortColumn = 850
};

#endif
