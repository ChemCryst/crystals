////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrEditBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.6  2001/03/08 15:32:43  richard
//   Limit=n token prevents user entering more than n characters.
//

#ifndef     __CrEditBox_H__
#define     __CrEditBox_H__
#include    "crguielement.h"

class CcTokenList;

class   CrEditBox : public CrGUIElement
{
    public:
        void ClearBox();
            void SysKey ( UINT nChar );
        void AddText(CcString theText);
        void ReturnPressed();
        void CrFocus();
        int GetIdealWidth();
        // methods
            CrEditBox( CrGUIElement * mParentPtr );
            ~CrEditBox();
        CcParse ParseInput( CcTokenList * tokenList );
        void    SetText( CcString text );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    GetValue();
        void    GetValue(CcTokenList* tokenList);
        void    BoxChanged();
        // attributes

private:
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
