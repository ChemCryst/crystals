////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CxIcon.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.6  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.5  2001/06/17 14:41:06  richard
//   CxDestroyWindow function.
//   Icons not available under wx - replace with text strings for now - could eventually
//   use bitmaps instead.
//
//   Revision 1.4  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef           __CxIcon_H__
#define           __CxIcon_H__
#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASETEXT CStatic
#else
 #include <wx/stattext.h>
 #include <wx/icon.h>
 #define BASETEXT wxStaticText
#endif


class CrIcon;
class CxGrid;

class CxIcon : public BASETEXT
{
    public:
        // methods
            static CxIcon *   CreateCxIcon( CrIcon * container, CxGrid * guiParent );
                  CxIcon( CrIcon * container );
                  ~CxIcon();
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddText();
        static void RemoveText();
        void CxDestroyWindow();
        void    SetVisibleChars( int count );
            void SetIconType( int iIconId );

        // attributes
        CrGUIElement *  ptr_to_crObject;

    protected:
        // methods

        // attributes
        static int  mTextCount;
        int mCharsWidth;
};
#endif
