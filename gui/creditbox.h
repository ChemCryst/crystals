////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrEditBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.8  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.7  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.6  2001/03/08 15:32:43  richard
//   Limit=n token prevents user entering more than n characters.
//

#ifndef     __CrEditBox_H__
#define     __CrEditBox_H__
#include    "crguielement.h"
#include    <deque>
using namespace std;

class   CrEditBox : public CrGUIElement
{
    public:
        void ClearBox();
        void SysKey ( UINT nChar );
        void AddText(string theText);
        void ReturnPressed();
        void CrFocus();
        int GetIdealWidth();
        // methods
            CrEditBox( CrGUIElement * mParentPtr );
            ~CrEditBox();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetText( const string &text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue();
        void    GetValue( deque<string> & tokenList);
        void    BoxChanged();
        // attributes

private:
    void AddHistory( const string & theText );
    void History(bool up);
//    static deque<string> mCommandHistoryDeq;
//    static int mCommandHistoryPosition;

    bool mSendOnReturn;
    bool m_IsInput;
};

#define kSIsInput   "INPUT"
#define kSWantReturn    "SENDONRETURN"
#define kSIntegerInput  "INTEGER"
#define kSRealInput "REAL"
#define kSNoInput   "READONLY"
#define kSAppend    "APPEND"
#define kSLimit     "LIMIT"

enum
{
 kTIsInput = 800,
 kTWantReturn,
 kTIntegerInput,
 kTRealInput,
 kTNoInput,
 kTAppend,
 kTLimit
};


#endif
