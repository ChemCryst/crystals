////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.6  2002/07/25 16:00:13  richard
//
//   Resize dropdown listbox if number of items changes.
//
//   Revision 1.5  2002/03/05 12:12:58  ckp2
//   Enhancements to listbox for my List 28 project.
//
//   Revision 1.4  2001/03/08 16:44:05  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CrListBox_H__
#define     __CrListBox_H__
#include    "crguielement.h"

class   CrListBox : public CrGUIElement
{
    public:
        void CrFocus();
        // methods
            CrListBox( CrGUIElement * mParentPtr );
            ~CrListBox();
        CcParse ParseInput( deque<string> & tokenList );
        void    SetGeometry( const CcRect * rect );
        CcRect  GetGeometry();
        CcRect CalcLayout(bool recalculate=false);
        void    SetText( const string &item );
        void    GetValue();
        void    GetValue( deque<string> & tokenlist);
        void    Selected ( int item );
        void    Committed( int item );

        // attributes

};


#endif
