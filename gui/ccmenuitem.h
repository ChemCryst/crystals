//
// CcMenuItem.h: interface for the CcMenuItem class.
//

#if !defined(AFX_RMENUITEM_H__BC60CBE3_FE64_11D1_B74B_883007C10000__INCLUDED_)
#define AFX_RMENUITEM_H__BC60CBE3_FE64_11D1_B74B_883007C10000__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif

class CrMenu;
class CcMenuItem  
{
public:
        CrMenu* parent;
        void SetText(CcString theText);
        void SetTitle(CcString theText);
        CcMenuItem(CrMenu* parentptr);
        virtual ~CcMenuItem();
        int type;
        int id;
        CcString name;
        CcString text;
        CcString originaltext;
        CcString command;
        CcString originalcommand;
        CrMenu* ptr;
        int disable;
        int enable;
};

#endif 
