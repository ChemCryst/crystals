////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcModelDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcModelDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.26  2011/05/17 14:43:31  rich
//   Remove class name from declaration.
//
//   Revision 1.25  2009/07/23 14:15:42  rich
//   Removed all uses of OpenGL feedback buffer - was dreadful slow on some new graphics cards.
//
//   Revision 1.24  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.23  2004/11/09 09:45:02  rich
//   Removed some old stuff. Don't use displaylists on the Mac version.
//
//   Revision 1.22  2004/06/25 09:29:18  rich
//   Pass strings more efficiently. Fix bug in FlagFrag.
//
//   Revision 1.21  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.20  2003/11/07 10:43:06  rich
//   Split the 'part' column in the atom list into 'assembly' and 'group'.
//
//   Revision 1.19  2003/10/31 10:44:16  rich
//   When an atom is selected in the model window, it is scrolled
//   into view in the atom list, if not already in view.
//
//   Revision 1.18  2003/08/13 16:01:41  rich
//   Comment out windows header on Linux ver.
//
//   Revision 1.17  2003/05/07 12:18:56  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.16  2002/10/02 13:42:00  rich
//   Support for more info from GUIBIT (e.g. UEQUIV).
//   Ability to act as a source of data for either a MODELWINDOW
//   or a MODLIST.
//
//   Revision 1.15  2002/07/23 08:25:43  richard
//
//   Moved selected, disabled and excluded variables and functions into the base class.
//   Added ALL option to DISABLEATOM to enable/disable all atoms.
//
//   Revision 1.14  2002/07/18 16:44:34  richard
//   Changes to ensure two CrModels can share the same CcModelDoc happily.
//
//   Revision 1.13  2002/07/04 13:04:44  richard
//
//   glPassThrough was causing probs on Latitude notebook. Can only be called in feedback
//   mode, which means that it can't be stuck into the display lists which are used
//   for drawing aswell. Instead, added feedback logical parameter into all Render calls, when
//   true it does a "feedback" render rather than a display list render. Will slow down polygon
//   selection a negligble amount.
//
//   Revision 1.12  2002/06/28 10:09:53  richard
//   Minor gui update enabling vague display of special shapes: ring and sphere.
//
//   Revision 1.11  2002/06/25 11:58:09  richard
//   Use _F in popup-menu commands to substitute in all atoms in fragment connected
//   to clicked-on atom.
//
//   Revision 1.10  2002/03/13 12:25:45  richard
//   Update variable names. Added FASTBOND and FASTATOM routines which can be called
//   from the Fortran instead of passing data through the text channel.
//
//   Revision 1.9  2001/06/17 15:24:20  richard
//
//
//   Lot of functions which used to be called from CxModel and CrModel removed and
//   now CcModelDoc does these for itself (lists of selected atoms etc.)
//
//   Render groups atoms by drawing style and sends GL attributes only once at beginning
//   of each set (e.g. disabled atoms, selected atoms, normal atoms, excluded atoms.)
//
//   Revision 1.8  2001/03/08 15:12:17  richard
//   Added functions for excluding atoms and bonds, and excluding fragments based on
//   known bonding.
//

//BIG NOTICE: ModelDoc is not a CrGUIElement, it's more like a list
//            of drawing commands.
//            You can attach a CrModel to it and it will then draw
//            itself on that CrModel's drawing area.
//            It does contain a ParseInput routine for parsing the
//            drawing commands. Note again - it is not a CrGUIElement,
//            it has no graphical presence, nor a complimentary Cx- class

#ifndef     __CcModelDoc_H__
#define     __CcModelDoc_H__

#ifdef __CR_WIN__
#include <GL/glu.h>
#include <GL/gl.h>
#endif
#ifdef __BOTHWX__
#include <wx/glcanvas.h>
//#include <windows.h>
#include <GL/glu.h>
#endif

#include <string>
#include <list>
using namespace std;

#include "ccpoint.h"
#include "ccmodelatom.h"
#include "ccmodelbond.h"
#include "ccmodelsphere.h"
#include "ccmodeldonut.h"

class CrModel;
class CcRect;
class CrModList;
class CcModelStyle;
class CcModelDoc;

class Cc2DAtom
{
  public:
	CcPoint p;
	GLuint id;
    Cc2DAtom(CcPoint p_in, GLuint id_in ) {
		p = p_in;
		id = id_in;
	};
};



class CcModelDoc
{
    public:
        bool RenderModel( CcModelStyle *style );   // Called by CrModel
        bool RenderAtoms( CcModelStyle * style, bool feedback );
        bool RenderBonds( CcModelStyle * style, bool feedback );
        bool RenderExcluded( CcModelStyle * style );
     	CcRect FindModel2DExtent(float * mat, CcModelStyle * style);
	std::list<Cc2DAtom> AtomCoords2D(float * mat);
        void DocToList( CrModList* ml );                                // Called by CrModList
        void InvertSelection();                                         // Called by CrModel
        void SelectAllAtoms(bool select);                               // Called by CrModel
        void SelectAtomByLabel(const string & atomname, bool select);           // Called by CrModel
        void DisableAllAtoms(bool select);                              // Called by CrModel
        void DisableAtomByLabel(const string & atomname, bool select);          // Called by CrModel
        CcModelObject* FindAtomByLabel(const string & atomname);         // Called by CrModel & CcModelBond
        CcModelAtom* FindAtomByPosn(int posn);          // Called by CrModList & CcModelBond

        void FastBond(int x1,int y1,int z1, int x2, int y2, int z2,
                          int r, int g, int b,  int rad,int btype,
                          int np, int * ptrs, const string & label, const string & cslabl);

        void FastAtom(const string & label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,float cov, int vdw,
                          int spare, int flag,
                          float u1,float u2,float u3,float u4,float u5,
                          float u6,float u7,float u8,float u9,
                          float fx, float fy, float fz,
                          const string &  elem, int serial, int refflag,
                          int assembly, int group, float ueq, float fspare);

        void FastSphere(const string & label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag,
                          int iso, int irad);

        void FastDonut(const string & label,int x1,int y1,int z1,
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag,
                          int iso, int irad, int idec, int iaz);


        CcModelObject * FindObjectByGLName(GLuint name);            // Called by CrModel

        void Clear();                                               // Called by CrModel
        string SelectedAsString( string delimiter = " " );          // Called by CrMenu
        string FragAsString    ( const string & atomname, string delimiter = " "); // Called by CrMenu
        void SendAtoms( int style, bool sendonly=false );           // Called by CrModel
        void ZoomAtoms( bool doZoom );                              // Called by CrModel
        void SelectFrag(const string & atomname, bool select);              // Called by CrModel
        void RemoveView(CrModel* aView);                            // Called by CrModel
        void DrawViews(bool rescaled = false);                      // Called by CrModList, ModelAtom, ModelBond etc.
        void AddModelView(CrModel* aView);                          // Called by CrModel
        void AddModelView(CrModList* aView);                        // Called by CrModList
        CcModelDoc();
        ~CcModelDoc();
        bool ParseInput( deque<string> & tokenList );                 // Called by CcController

        friend bool operator==(CcModelDoc* doc, const string& st0); // Called by CcController

        int NumSelected();                                          // Called by CrModList
        void EnsureVisible(CcModelAtom* va);                        // Called by CcModelAtom, Bond etc.

        void Select(bool selected);                                 // Called by CcModelAtom, Donut etc.

        list <CrModel*> attachedViews;          
        list <CrModList*> attachedLists;
        static list<CcModelDoc*> sm_ModelDocList;
        static CcModelDoc* sm_CurrentModelDoc;
        string mName;

        void    ApplyIndexColour( GLuint indx );
        void    SendInsertText( string s );

	protected:

    private:
        void     FlagFrag ( const string & atomname );
        string Compress(const string & atomname);
        
		GLuint m_glIDs;
        int nSelected;
        int m_nAtoms;
        int m_TotX;
        int m_TotY;
        int m_TotZ;
  
        list<CcModelAtom> mAtomList;
        list<CcModelBond> mBondList;
        list<CcModelSphere> mSphereList;
        list<CcModelDonut> mDonutList;
};

#endif
