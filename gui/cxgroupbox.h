////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGroupBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGroupBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 16:18 Uhr

#ifndef     __CxGroupBox_H__
#define     __CxGroupBox_H__
#include    "crguielement.h"

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEGROUPBOX CButton
#endif

#ifdef __BOTHWX__
#include <wx/statbox.h>
#define BASEGROUPBOX wxStaticBox
#endif

class CrGrid;
class CxGrid;
class CxGroupBox;

class CxGroupBox : public BASEGROUPBOX
{
    public:
        // methods
        static CxGroupBox * CreateCxGroupBox( CrGrid * container, CxGrid * guiParent );
            CxGroupBox( CrGrid * container );
            ~CxGroupBox();
        void    SetText( char * text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        static int AddGroupBox( void) { mGroupBoxCount++; return mGroupBoxCount; };
        static void RemoveGroupBox( void) { mGroupBoxCount--; };

        // attributes
        static int mGroupBoxCount;
};
#endif
