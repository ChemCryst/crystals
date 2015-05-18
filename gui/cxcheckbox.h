////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxCheckBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxCheckBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.9  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.8  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.7  2001/06/17 14:45:02  richard
//   CxDestroyWindow function.
//
//   Revision 1.6  2001/03/08 16:44:08  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxCheckBox_H__
#define     __CxCheckBox_H__
//Insert your own code here.
#include    "crguielement.h"

/*#ifdef __POWERPC__
class LStdCheckBox;
#endif*/

#ifdef __MOTO__
#include    <LStdControl.h>;
#endif

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASECHECKBOX CButton
#else
 #include <wx/checkbox.h>
 #define BASECHECKBOX wxCheckBox
#endif


class CrCheckBox;
class CxGrid;
//End of user code.

class CxCheckBox : public BASECHECKBOX
{
    public:
        void Focus();
        // methods
        static CxCheckBox * CreateCxCheckBox( CrCheckBox * container, CxGrid * guiParent );
            CxCheckBox( CrCheckBox * container);
            ~CxCheckBox();
//      void    BoxClicked();
        void    SetText( const string & text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        void CxDestroyWindow();
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        void    SetBoxState( bool inValue );
        void    Disable(bool disabled);
        bool GetBoxState();

        // attributes
        CrGUIElement *  ptr_to_crObject;
    protected:
        static int  mCheckBoxCount;


#ifdef CRY_USEMFC
        afx_msg void BoxClicked();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);

        DECLARE_MESSAGE_MAP()
#else
        void BoxClicked(wxCommandEvent & e);
        void OnChar(wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif


};
#endif
