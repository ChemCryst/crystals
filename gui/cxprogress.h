////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CxProgress.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.9  2001/06/17 14:33:30  richard
//   CxDestroyWindow function. wx support.
//
//   Revision 1.8  2001/03/08 16:44:10  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxProgress_H__
#define     __CxProgress_H__

#include    "crguielement.h"
#include    <string>
using namespace std;

#ifdef __BOTHWX__
#include <wx/gauge.h>
#include <wx/stattext.h>
#define BASEPROGRESS wxGauge
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASEPROGRESS CProgressCtrl
#endif

class CrProgress;
class CxGrid;
//End of user code.

class CxProgress : public BASEPROGRESS
{
    public:
        void SetProgress (int complete);
        // methods
        static CxProgress * CreateCxProgress( CrProgress * container, CxGrid * guiParent );
            CxProgress( CrProgress * container );
            ~CxProgress();
        void    SetText( const string & text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int  AddProgress();
        static void RemoveProgress();
        void    SetVisibleChars( int count );
        void  SwitchText ( const string & text );
        void CxDestroyWindow();


        // attributes
        CrGUIElement *  ptr_to_crObject;
        string m_oldText;

    protected:
        // methods

        // attributes
        static int  mProgressCount;
        int mCharsWidth;
private:
#ifdef __CR_WIN__
            CStatic* m_TextOverlay;
#endif
#ifdef __BOTHWX__
            wxStaticText* m_TextOverlay;
#endif

};
#endif
