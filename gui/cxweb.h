////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxWeb

////////////////////////////////////////////////////////////////////////

//   Filename:  CxWeb.h
//   Authors:   Richard Cooper
//   Created:   04.3.2011 14:41 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1  2011/04/16 06:49:45  rich
//   HTML control
//

#ifndef     __CxButton_H__
#define     __CxButton_H__


#ifdef DEPRECATEDCRY_USEWX

#include    "crguielement.h"

#include "../webconnect/webcontrol.h"
#include <wx/event.h>
#define BASEWEB wxWebControl


class CrWeb;
class CxGrid;

class CxWeb : public BASEWEB
{
// The interface exposed to the CrClass
    public:
		CxWeb(wxWindow* parent, wxWindowID id, const wxPoint& pos, const wxSize& size)
			: wxWebControl(parent,id,pos,size) {};
		void Disable(bool disabled);
        void Focus();

		// methods
        static CxWeb *   CreateCxWeb( CrWeb * container, CxGrid * guiParent );
        void Initialise (CrWeb* container);
        ~CxWeb();
        void CxDestroyWindow();
        void    SetGeometry( int top, int left, int bottom, int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
		
		void SetIdealHeight(int nCharsHigh);
		void SetIdealWidth(int nCharsWide);

		void SetAddress(const string &uri);

        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int mWebCount;
        bool m_lengthStringUsed;
        string m_lengthString;
        bool m_Slim;

        static wxString FindXulRunner(const wxString& xulrunner_dirname);
		static bool InitXULRunner();



// Private machine specific parts:
#ifndef CRY_USEMFC
            DECLARE_EVENT_TABLE()
#endif

			int mIdealWidth;
			int mIdealHeight;

};
 #endif
#endif
