////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcModelDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcModelDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
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
#include <windows.h>
#include <GL/glu.h>
#endif

#include "ccstring.h"   // added by classview
#include "cclist.h" // added by classView                      
class CcTokenList;
class CrModel;
class CrModList;
class CcList;
class CcModelAtom;
class CcModelSphere;
class CcModelDonut;
class CcModelObject;
class CcModelStyle;
class CcModelDoc;

class CcModelDoc
{
    public:

        bool RenderModel( CcModelStyle *style, bool feedback=false );
        void DocToList( CrModList* ml );
        void InvertSelection();
        CcString Compress(CcString atomname);
        void SelectAllAtoms(bool select);
        void SelectAtomByLabel(CcString atomname, bool select);
        void DisableAllAtoms(bool select);
        void DisableAtomByLabel(CcString atomname, bool select);
        CcModelObject* FindAtomByLabel(CcString atomname);
        CcModelAtom* FindAtomByPosn(int posn);

        void FastBond(int x1,int y1,int z1, int x2, int y2, int z2,
                          int r, int g, int b,  int rad,int btype,
                          int np, int * ptrs, CcString label, CcString cslabl);

        void FastAtom(CcString label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,float cov, int vdw,
                          int spare, int flag,
                          float u1,float u2,float u3,float u4,float u5,
                          float u6,float u7,float u8,float u9,
                          float fx, float fy, float fz,
                          CcString elem, int serial, int refflag,
                          int part, float ueq, float fspare);

        void FastSphere(CcString label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag,
                          int iso, int irad);

        void FastDonut(CcString label,int x1,int y1,int z1,
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag,
                          int iso, int irad, int idec, int iaz);

        void ExcludeBonds();

        CcModelObject * FindObjectByGLName(GLuint name);

        CcString SelectedAsString( CcString delimiter = " " );
        CcString FragAsString    ( CcString atomname, CcString delimiter = " ");
        void     FlagFrag ( CcString atomname );
        void SendAtoms( int style, bool sendonly=false );
        void ZoomAtoms( bool doZoom );


        void SelectFrag(CcString atomname, bool select);
        void Select(bool selected);
        void HighlightView(CrModel* aView);
        void RemoveView(CrModel* aView);
        void DrawViews(bool rescaled = false);
        void AddModelView(CrModel* aView);
        void AddModelView(CrModList* aView);
        void Clear();
        CcModelDoc();
        ~CcModelDoc();
        bool ParseInput( CcTokenList * tokenList );


        int NumSelected();

        CcString mName;
        CcList attachedViews;
        CcList attachedLists;

        static CcList  sm_ModelDocList;
        static CcModelDoc* sm_CurrentModelDoc;


    private:
        int nSelected;
        int m_nAtoms;
        int m_TotX;
        int m_TotY;
        int m_TotZ;
        bool m_glIDsok;
        CcList* mAtomList;
        CcList* mBondList;
        CcList* mSphereList;
        CcList* mDonutList;
//                CcList* mCellList;
//                CcList* mTriList;
};

#endif
