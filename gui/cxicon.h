////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CxIcon.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.4  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef           __CxIcon_H__
#define           __CxIcon_H__
#include    "crguielement.h"

#ifdef __BOTHWX__
#include <wx/stattext.h>
#define BASETEXT wxStaticText
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASETEXT CStatic
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
