////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.h
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
//   Revision 1.8  2001/06/17 14:29:33  richard
//   Destroy window function. Fix resize bug in wx version.
//
//   Revision 1.7  2001/03/08 16:44:11  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxText_H__
#define     __CxText_H__
#include    "crguielement.h"

#ifdef __BOTHWX__
#include <wx/stattext.h>
#define BASETEXT wxStaticText
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASETEXT CStatic
#endif

class CrText;
class CxGrid;
//End of user code.

class CxText : public BASETEXT
{
    public:
        // methods
        static CxText * CreateCxText( CrText * container, CxGrid * guiParent );
            CxText( CrText * container );
            ~CxText();
        void    SetText( const string & text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddText();
        static void RemoveText();
        void    SetVisibleChars( int count );
        void CxDestroyWindow();

        // attributes
        CrGUIElement *  ptr_to_crObject;

    protected:
        // methods

        // attributes
        static int  mTextCount;
        int mCharsWidth;

		#ifdef __CR_WIN__
  protected:
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
