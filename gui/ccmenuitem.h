//
// CcMenuItem.h: interface for the CcMenuItem class.
//

#if !defined(AFX_RMENUITEM_H__BC60CBE3_FE64_11D1_B74B_883007C10000__INCLUDED_)
#define AFX_RMENUITEM_H__BC60CBE3_FE64_11D1_B74B_883007C10000__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif

#include <string>
#include <deque>
using namespace std;

class CrMenu; 
class CcMenuItem  
{
public:
        CrMenu* parent;
        void SetText(string theText);
        void SetTitle(string theText);
        CcMenuItem(CrMenu* parentptr);
        virtual ~CcMenuItem();
        int type;
        int id;
        string name;
        string text;
        string originaltext;
        string command;
        string originalcommand;
        CrMenu* ptr;
        int disable;
        int enable;
        bool ParseInput( deque<string> & tokenList );
};
#endif 
