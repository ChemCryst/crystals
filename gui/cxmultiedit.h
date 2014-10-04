////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   5.3.1998 13:51 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.18  2004/09/17 14:03:54  rich
//   Better support for accessing text in Multiline edit control from scripts.
//
//   Revision 1.17  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.16  2004/05/13 09:14:49  rich
//   Re-invigorate the MULTIEDIT control. Currently not used, but I have
//   something in mind for it.
//
//   Revision 1.15  2003/05/07 12:18:58  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.14  2001/06/17 14:34:05  richard
//
//   CxDestroyWindow function.
//
//   Revision 1.13  2001/03/08 16:44:10  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxMultiEdit_H__
#define     __CxMultiEdit_H__

#include "crystalsinterface.h"
#include "ciinputcontrol.h"

#ifdef __BOTHWX__
//#include <wx/textctrl.h>
 #include <wx/stc/stc.h>
#define BASEMULTIEDIT wxStyledTextCtrl
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEMULTIEDIT CRichEditCtrl
#endif

class CrMultiEdit;
class CxGrid;
class CrGUIElement;
//End of user code.

class CxMultiEdit : public BASEMULTIEDIT, public IInputControl
{
    public:
        void Empty();
        void Spew();
		bool CxIsModified();
        void Focus();

// methods
        static CxMultiEdit * CreateCxMultiEdit( CrMultiEdit * container, CxGrid * guiParent );
                        CxMultiEdit( CrMultiEdit * container );
                        ~CxMultiEdit();

        void            SetText( const string & cText );
        void            SetIdealWidth(int nCharsWide);
        void            SetIdealHeight(int nCharsHigh);
        void            SetFontHeight( int height );
        int             GetNLines();
        void            CxDestroyWindow();
        int             GetIdealWidth();
        int             GetIdealHeight();
        int             GetTop();
        int             GetWidth();
        int             GetHeight();
        int             GetLeft();
        void            SetGeometry(int top, int left, int bottom, int right );

        void            SaveAs(string filename);
        void            Load(string filename);

		void			InsertText(const string text);
    private:
        static int      AddMultiEdit( void) { mMultiEditCount++; return mMultiEditCount; };
        static void     RemoveMultiEdit( void) { mMultiEditCount--; };
        void Init();

        // attributes
        static int      mMultiEditCount;

        // attributes
        CrMultiEdit *   ptr_to_crObject;
        int             mIdealHeight;
        int             mIdealWidth;
        int             mHeight;

#ifdef __CR_WIN__

        static DWORD CALLBACK MyStreamOutCallback(DWORD dwCookie, LPBYTE pbBuff, LONG cb, LONG *pcb);

        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
    public:
        void OnChar(wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif

};
#endif
