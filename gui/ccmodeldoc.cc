////////////////////////////////////////////////////////////////////////

//   CRYSALS Interface      Class CcModelDoc

////////////////////////////////////////////////////////////////////////

//   Filename:  CcModelDoc.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr

//BIG NOTICE: ModelDoc is not a CrGUIElement, it's more like a list
//            of drawing commands.
//            You can attach a CrModel to it and it will then draw
//            itself on that CrModel's drawing area.
//            It does contain a ParseInput routine for parsing the
//            drawing commands. Note again - it is not a CrGUIElement,
//            it has no graphical presence, nor a complimentary Cx- class

// $Log: not supported by cvs2svn $
// Revision 1.50  2012/05/11 10:13:31  rich
// Various patches to wxWidget version to catch up to MFc version.
//
// Revision 1.49  2012/03/23 15:57:43  rich
// Intel support.
//
// Revision 1.48  2011/09/21 09:30:49  rich
// Increase model resolution
//
// Revision 1.47  2011/05/16 10:56:32  rich
// Added pane support to WX version. Added coloured bonds to model.
//
// Revision 1.46  2011/05/10 12:43:00  rich
// Fix "select all" bug
//
// Revision 1.45  2011/03/04 06:02:01  rich
// Use new defines to get correct function signature for update routines.
//
// Revision 1.44  2009/07/23 14:15:42  rich
// Removed all uses of OpenGL feedback buffer - was dreadful slow on some new graphics cards.
//
// Revision 1.43  2008/09/22 12:31:37  rich
// Upgrade GUI code to work with latest wxWindows 2.8.8
// Fix startup crash in OpenGL (cxmodel)
// Fix atom selection infinite recursion in cxmodlist
//
// Revision 1.42  2008/06/04 15:21:57  djw
// More fixes for OpenGL problem.
//
// Revision 1.40  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.1.1.1  2004/12/13 11:16:17  rich
// New CRYSTALS repository
//
// Revision 1.39  2004/11/12 09:11:15  rich
// Finish removing displaylists from the MAC version.
//
// Revision 1.38  2004/11/12 09:09:40  rich
// Fix newly introduced bond label bug.
//
// Revision 1.37  2004/11/11 14:59:08  stefan
// 1. Back to old version as I didn't mean to check these files in last time.
//
// Revision 1.35  2004/11/09 09:45:02  rich
// Removed some old stuff. Don't use displaylists on the Mac version.
//
// Revision 1.34  2004/07/02 09:21:18  rich
// Prevent thread deadlock.
//
// Revision 1.33  2004/06/25 12:49:38  rich
// Avoid deadlocks in mutex.
//
// Revision 1.32  2004/06/25 09:29:18  rich
// Pass strings more efficiently. Fix bug in FlagFrag.
//
// Revision 1.31  2004/06/24 09:12:01  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.30  2004/04/16 12:43:45  rich
// Speed up for  OpenGL rendering: Use new lighting scheme, drop use of
// two sets of displaylists for rendering a 'low res' model while rotating -
// it's faster not too.
//
// Revision 1.29  2003/11/28 10:29:11  rich
// Replace min and max macros with CRMIN and CRMAX. These names are
// less likely to confuse gcc.
//
// Revision 1.28  2003/11/07 10:43:06  rich
// Split the 'part' column in the atom list into 'assembly' and 'group'.
//
// Revision 1.27  2003/10/31 10:44:16  rich
// When an atom is selected in the model window, it is scrolled
// into view in the atom list, if not already in view.
//
// Revision 1.26  2003/05/12 12:01:19  rich
// RIC: Oops; roll back some unintentional check-ins.
//
// Revision 1.24  2003/05/07 12:18:56  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.23  2002/10/02 13:42:00  rich
// Support for more info from GUIBIT (e.g. UEQUIV).
// Ability to act as a source of data for either a MODELWINDOW
// or a MODLIST.
//
// Revision 1.22  2002/07/23 08:25:43  richard
//
// Moved selected, disabled and excluded variables and functions into the base class.
// Added ALL option to DISABLEATOM to enable/disable all atoms.
//
// Revision 1.21  2002/07/18 16:44:34  richard
// Changes to ensure two CrModels can share the same CcModelDoc happily.
//
// Revision 1.20  2002/07/16 14:09:45  richard
// Bug in atom selection fixed: if last digit of two or more character number
// was also last character of the string it would be chopped off by accident.
//
// Revision 1.19  2002/07/04 13:04:44  richard
//
// glPassThrough was causing probs on Latitude notebook. Can only be called in feedback
// mode, which means that it can't be stuck into the display lists which are used
// for drawing aswell. Instead, added feedback logical parameter into all Render calls, when
// true it does a "feedback" render rather than a display list render. Will slow down polygon
// selection a negligble amount.
//
// Revision 1.18  2002/07/03 16:44:05  richard
// Implemented polygon selection in model window.
//
// Improved "genericness" of ccmodelobject class to simplify calls to common
// functions in atom, sphere and donut derived classes.
//
// Revision 1.17  2002/06/28 10:09:53  richard
// Minor gui update enabling vague display of special shapes: ring and sphere.
//
// Revision 1.16  2002/06/25 11:58:09  richard
// Use _F in popup-menu commands to substitute in all atoms in fragment connected
// to clicked-on atom.
//
// Revision 1.15  2002/05/15 17:25:00  richard
// Bug fix.
//
// Revision 1.14  2002/03/13 12:25:45  richard
// Update variable names. Added FASTBOND and FASTATOM routines which can be called
// from the Fortran instead of passing data through the text channel.
//
// Revision 1.13  2002/01/31 15:03:13  ckp2
// RIC: Fix Alexander's OpenGL bug (at last).
//
// Revision 1.12  2001/06/17 15:24:19  richard
//
//
// Lot of functions which used to be called from CxModel and CrModel removed and
// now CcModelDoc does these for itself (lists of selected atoms etc.)
//
// Render groups atoms by drawing style and sends GL attributes only once at beginning
// of each set (e.g. disabled atoms, selected atoms, normal atoms, excluded atoms.)
//
// Revision 1.11  2001/03/08 15:12:17  richard
// Added functions for excluding atoms and bonds, and excluding fragments based on
// known bonding.
//
// Revision 1.10  2001/01/25 17:04:23  richard
// Commented out unused lists of model objects. Triangles and Cells, actually.
//
// Revision 1.9  2000/10/31 15:42:14  ckp2
// Link to atom disabling code.
//
// Revision 1.8  1999/08/25 17:57:41  ckp2
// RIC: Updates from before Glasgow
//
// Revision 1.7  1999/08/03 09:19:18  richard
// RIC: Keep track of number of selected atoms more carefully.
//
// Revision 1.6  1999/06/22 12:57:18  dosuser
// RIC: RenderModel returns a boolean indicating whether anything was drawn.
//
// Revision 1.5  1999/06/13 16:40:32  dosuser
// RIC: No need to keep track of the centre as objects are added. Atoms
// are now centred in XGDBUP. DrawViews and Centre() removed.
// RedrawHighlights() removed. This is done automatically in the atoms
// Render() function. New function RenderModel() is called when
// a Paint event is recieved by CxModel. It calls Render() for each
// of the modelobjects stored in its lists. The argument view lets
// the modelobjects access global settings from the CrModel such as
// RadiusType and Scale. The bool detailed tells the model object
// whether to draw at high or low resolution depending on whether the
// view is currently rotating.
//
// Revision 1.4  1999/04/30 17:09:45  dosuser
// RIC: Changed the ClearHighlights() call before the HighlightAtoms loop
//      to a StartHighlights() before and a FinishHighlights() after.
//
// Revision 1.3  1999/04/26 11:12:39  dosuser
// RIC: Added a bit of code to call Reset() on all views attached to
//      the modeldoc in order that they don't keep pointers to atoms
//      in the modeldoc once it is updated by CRYSTALS.
//



#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "ccmodeldoc.h"
#include    "ccmodelobject.h"
//insert your own code here.
#include    "crmodel.h"
#include    "crmodlist.h"
//#include  "ccrect.h"
#include    "cccoord.h"
#include    "cclock.h"
#include    "cccontroller.h"    // for sending commands
#include    "cxmodel.h"

#include <string>
#include <sstream>
#include <algorithm>
#include <iomanip>
using namespace std;

list<CcModelDoc*> CcModelDoc::sm_ModelDocList;
CcModelDoc* CcModelDoc::sm_CurrentModelDoc = nil;
static CcLock m_thread_critical_section(true);


CcModelDoc::CcModelDoc( )
{
    m_nAtoms = 0;
    nSelected = 0;
    sm_ModelDocList.push_back(this);
    sm_CurrentModelDoc = this;
}

CcModelDoc::~CcModelDoc()
{
    for ( list<CrModel*>::const_iterator aview=attachedViews.begin(); aview != attachedViews.end(); aview++)
            (*aview)->DocRemoved();
// Remove from list of ModelDoc objects:
    sm_ModelDocList.remove(this); 
}


bool operator==(CcModelDoc* doc, const string& st0)
{
   return( st0 == doc->mName ) ;
}


bool CcModelDoc::ParseInput(deque<string> &  tokenList )
{
    bool retVal = true;
    bool hasTokenForMe = true;

    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kModelClass ) )
        {
            case kTModelShow:
            {
                tokenList.pop_front(); // Remove that token!
                DrawViews(true);
                break;
            }
            case kTModelAtom:
            {
                tokenList.pop_front(); // Remove that token!
                CcModelAtom item(this);
                item.ParseInput(tokenList);
				item.m_glID = m_glIDs++;
                m_nAtoms++;
                item.id = m_nAtoms;
                m_thread_critical_section.Enter();
                mAtomList.push_back(item);
                m_thread_critical_section.Leave();
                break;
            }
            case kTModelBond:
            {
                tokenList.pop_front(); // Remove that token!
                CcModelBond item(this);
                item.ParseInput(tokenList);
				item.m_glID = m_glIDs++;
                m_thread_critical_section.Enter();
                mBondList.push_back(item);
                m_thread_critical_section.Leave();
                break;
            }
            case kTModelClear:
            {
                tokenList.pop_front(); // Remove that token!
                Clear();
                break;
            }
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }


    return retVal;
}


void CcModelDoc::Clear()
{
    m_thread_critical_section.Enter();
    mAtomList.clear();
    mBondList.clear();
    mSphereList.clear();
    mDonutList.clear();
    m_thread_critical_section.Leave();
    m_nAtoms = 0;
    nSelected = 0;
	m_glIDs = 1;
    (CcController::theController)->status.SetNumSelectedAtoms( 0 );
}

void CcModelDoc::AddModelView(CrModel * aView)
{
        ostringstream strm;
        strm << attachedViews.size() << " " << (uintptr_t) aView << " " << (uintptr_t) this;
	LOGSTAT ( "Adding CrModel View to list in CcModelDoc. Current list size: " + strm.str() );
    attachedViews.remove(aView);    // Ensure only exists once in list.
    attachedViews.push_back(aView);
	strm.str("");
        strm << attachedViews.size();
	LOGSTAT ( "New list size: " + strm.str());
    aView->Update(true);
}

void CcModelDoc::AddModelView(CrModList * aView)
{
    attachedLists.remove(aView);
    attachedLists.push_back(aView);
    aView->Update(0);
}

void CcModelDoc::ApplyIndexColour( GLuint indx ) {
     for ( list<CrModel*>::const_iterator aview=attachedViews.begin(); aview != attachedViews.end(); aview++)
      (*aview)->ApplyIndexColour( indx );
 };

void CcModelDoc::SendInsertText(string s) {
     for ( list<CrModel*>::const_iterator aview=attachedViews.begin(); aview != attachedViews.end(); aview++)
      (*aview)->SendInsertText( s );
}


void CcModelDoc::DrawViews(bool rescaled)
{
    for ( list<CrModel*>::const_iterator aview=attachedViews.begin(); aview != attachedViews.end(); aview++)
            (*aview)->Update(rescaled);
    for ( list<CrModList*>::const_iterator alist=attachedLists.begin(); alist != attachedLists.end(); alist++)
            (*alist)->Update(mAtomList.size());
}

void CcModelDoc::EnsureVisible(CcModelAtom* va)
{
    for ( list<CrModList*>::const_iterator alist=attachedLists.begin(); alist != attachedLists.end(); alist++)
            (*alist)->EnsureVisible(va);
}


void CcModelDoc::RemoveView(CrModel * aView)
{
    attachedViews.remove(aView);
}

void CcModelDoc::Select(bool selected)
{
    if (selected)   nSelected++;
    else            nSelected--;
//Update the status flag.
    (CcController::theController)->status.SetNumSelectedAtoms( nSelected );
}


void CcModelDoc::SelectAtomByLabel(const string & atomname, bool select)
{

   CcModelObject* item = FindAtomByLabel(atomname);
   if(item)
   {
      item->Select(select);
      DrawViews();
   }
}

void CcModelDoc::DisableAtomByLabel(const string & atomname, bool select)
{
    CcModelObject* item = FindAtomByLabel(atomname);

    if(item)
    {
      if ( item->Type() == CC_ATOM )
      {
        ((CcModelAtom*)item)->Disable(select);
      }
      else if ( item->Type() == CC_SPHERE )
      {
        ((CcModelSphere*)item)->Disable(select);
      }
      else if ( item->Type() == CC_DONUT )
      {
        ((CcModelDonut*)item)->Disable(select);
      }
      DrawViews();
    }
}


void CcModelDoc::DisableAllAtoms(bool select)
{
  m_thread_critical_section.Enter();
  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
            (*atom).Disable(select);
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
            (*sphere).Disable(select);
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
            (*donut).Disable(select);
  m_thread_critical_section.Leave();
  DrawViews();

}


CcModelObject* CcModelDoc::FindAtomByLabel(const string & atomname)
{
  CcModelObject* ratom = nil;
  string nAtomname = Compress(atomname);

  m_thread_critical_section.Enter();
  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
  {
        if((*atom).Label() == nAtomname) ratom = &(*atom);
  }
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
  {
        if((*sphere).Label() == nAtomname) ratom = &(*sphere);
  }
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
  {
        if((*donut).Label() == nAtomname) ratom = &(*donut);
  }
  m_thread_critical_section.Leave();
  return ratom;
}

CcModelAtom* CcModelDoc::FindAtomByPosn(int posn)  //posn is zero based, but id is 1 based.
{
  CcModelAtom* ret = nil;
  m_thread_critical_section.Enter();
  if ( posn >= (int) mAtomList.size() ) posn = (int) mAtomList.size();
  list<CcModelAtom>::iterator atom=mAtomList.begin();
  for (;atom!=mAtomList.end();++atom) {
	  if ( atom->id - 1 == posn ) {
		  ret = &(*atom);
		  break;
	  }
  }
  m_thread_critical_section.Leave();
  return ret;
}



void CcModelDoc::SelectAllAtoms(bool select)
{
  m_thread_critical_section.Enter();
  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
            (*atom).Select(select);
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
            (*sphere).Select(select);
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
            (*donut).Select(select);
  m_thread_critical_section.Leave();

  DrawViews();

  if ( select )
    (CcController::theController)->status.SetNumSelectedAtoms( mAtomList.size() + mSphereList.size() + mDonutList.size() );
  else
    (CcController::theController)->status.SetNumSelectedAtoms( 0 );

}

int CcModelDoc::NumSelected()
{
    return nSelected;
}

string CcModelDoc::Compress(const string & atomname)
{
    string::size_type charstart = 1, charend = 1;
    string::size_type numbstart = 1, numbend = 1;
//Find first non-space
    charstart = atomname.find_first_not_of(" ");
//Find next space, parenthesis, or number.
    charend = atomname.find_first_of(" 0123456789()",charstart);
//Find first number.
    numbstart = atomname.find_first_of("0123456789",charend);
//Find next non-number.
    numbend = atomname.find_first_not_of("0123456789",numbstart);
//Build string in CRYSTALS format.
    string result;
    result = atomname.substr(charstart,charend-charstart);
    result += "(";
    result += atomname.substr(numbstart,numbend-numbstart);
    result += ")";
    return result;
}

void CcModelDoc::InvertSelection()
{
  int i = 0;
  m_thread_critical_section.Enter();
  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
            if ( (*atom).Select() ) i++;
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
            if ( (*sphere).Select() ) i++;
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
            if ( (*donut).Select() ) i++;
  m_thread_critical_section.Leave();
  (CcController::theController)->status.SetNumSelectedAtoms( i );
  DrawViews();

}

void CcModelDoc::DocToList( CrModList* ml )
{
  m_thread_critical_section.Enter();
  if ( ! mAtomList.empty()  )
  {
    vector<string> row;
    row.reserve(13);

    ml->StartUpdate();

    for ( list<CcModelAtom>::iterator atom=mAtomList.begin();
                                      atom != mAtomList.end();
                                      atom++)
    {
      row.clear();
      ostringstream strm;
      strm << (*atom).id;
      row.push_back( strm.str() );
      row.push_back( (*atom).m_elem);
      strm.str(""); strm << (*atom).m_serial;
      row.push_back( strm.str() );
      strm.str(""); strm << setprecision(3) << fixed << (*atom).frac_x;
      row.push_back( strm.str() );
      strm.str(""); strm << (*atom).frac_y;
      row.push_back( strm.str() );
      strm.str(""); strm << (*atom).frac_z;
      row.push_back( strm.str() );
      strm.str(""); strm << (float)(*atom).occ/1000.0f;
      row.push_back( strm.str() );
      row.push_back(  (*atom).m_IsADP ? "Aniso" : "Iso" );
      strm.str(""); strm << (*atom).m_ueq;
      row.push_back( strm.str() );
      strm.str(""); strm << (*atom).m_spare;
      row.push_back( strm.str() );
      strm.str(""); strm << (*atom).m_refflag;
      row.push_back( strm.str() );
      strm.str(""); strm << (*atom).m_assembly;
      row.push_back( strm.str() );
      strm.str(""); strm << (*atom).m_group;
      row.push_back( strm.str() );

      ml -> AddRow((*atom).id,            row,
                   (*atom).IsSelected(),
                   (*atom).m_disabled || (*atom).m_excluded);
    }
    ml->EndUpdate();

  }
  m_thread_critical_section.Leave();
  
}

bool CcModelDoc::RenderModel( CcModelStyle * style )
{
   bool retval = false;

   int nRes = (int) ( 5000.0 / mAtomList.size() );
   nRes = CRMIN ( 15, nRes );
   nRes = CRMAX ( 15,  nRes ); //Was 4. Not needed?
   style->normal_res = nRes;

   retval |= RenderBonds(style,false);
   retval |= RenderExcluded(style);
   retval |= RenderAtoms(style,false);

   return retval;
}

CcRect CcModelDoc::FindModel2DExtent(float * mat, CcModelStyle * style) {
	CcRect extent(0,0,0,0);
	bool extentinit = false;
	for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
	{


//not excluded
		if ( !((*atom).m_excluded) ) {
			CcPoint c = (*atom).GetAtom2DCoord(mat);
			int extra = (*atom).Radius(style);
			if ( !extentinit ){
				extentinit = true;
				extent.mRight = c.X() + extra;
				extent.mLeft = c.X() - extra;
				extent.mTop = c.Y() - extra;
				extent.mBottom = c.Y() + extra;
			} else {
				if ( c.X() + extra > extent.Right() ) extent.mRight = c.X() + extra;
				if ( c.X() - extra < extent.Left() ) extent.mLeft = c.X() - extra;
				if ( c.Y() + extra > extent.Bottom() ) extent.mBottom = c.Y() + extra;
				if ( c.Y() - extra < extent.Top() ) extent.mTop = c.Y() - extra;
			}
		}
	}
	return extent;
}

std::list<Cc2DAtom> CcModelDoc::AtomCoords2D(float * mat) {
	std::list<Cc2DAtom> ret;
	for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
	{
//not excluded
		if ( !((*atom).m_excluded) ) {
			Cc2DAtom a((*atom).GetAtom2DCoord(mat), (*atom).m_glID);
			ret.push_back(a);
		}
	}
	return ret;
}

bool CcModelDoc::RenderAtoms( CcModelStyle * style, bool feedback)
{
   bool ret = false;
   m_thread_critical_section.Enter();
   if ( !( mAtomList.empty() && mSphereList.empty() && mDonutList.empty() ) ) {

// Render atoms last if 'TINY' style (transparent).
// Render q peaks last  - might be transparent.

     for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); ++sphere) {
       (*sphere).Render(style, feedback);
     }
     for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   ++donut) {
       (*donut).Render(style, feedback);
     }
// Non Q atoms
	 for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     ++atom) {
	    if ((*atom).Label().length() == 0 || (*atom).Label()[0] != 'Q' ) {
		   (*atom).Render(style, feedback);
	    }
     }
// Q atoms
	 for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     ++atom) {
	    if ((*atom).Label().length() > 0 && (*atom).Label()[0] == 'Q' ) {
			(*atom).Render(style, feedback);
		}
     }
	 ret = true;
   }
   m_thread_critical_section.Leave();
   return ret;
}



bool CcModelDoc::RenderBonds( CcModelStyle * style, bool feedback )
{
   bool ret = false;
   m_thread_critical_section.Enter();

   if ( ! mBondList.empty() ) {
     for ( list<CcModelBond>::iterator bond=mBondList.begin();    bond != mBondList.end();   bond++) {
       if ( !((*bond).m_excluded) ) {
         (*bond).Render(style,feedback);
       }
     }
	 ret = true;
   }
   m_thread_critical_section.Leave();
   return ret;
}

bool CcModelDoc::RenderExcluded( CcModelStyle * style )
{
   m_thread_critical_section.Enter();
   if ( mAtomList.empty() && mBondList.empty() && mSphereList.empty() && mDonutList.empty() )
   {
     m_thread_critical_section.Leave();
     return false;
   }
       
   glPolygonMode(GL_FRONT, GL_POINT);
   glPolygonMode(GL_BACK, GL_POINT);
   for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
   {
     if ( (*atom).m_excluded )
     {
       (*atom).Render(style);
     }
   }
   for ( list<CcModelBond>::iterator bond=mBondList.begin();    bond != mBondList.end();   bond++)
   {
     if ( (*bond).m_excluded )
     {
       (*bond).Render(style);
     }
   }
   glPolygonMode(GL_FRONT, GL_FILL);
   glPolygonMode(GL_BACK, GL_FILL);
   m_thread_critical_section.Leave();
   return true;
}


void CcModelDoc::FlagFrag(const string & atomname)
{
// Set spare to false for all atoms

   m_thread_critical_section.Enter();
   if ( ! mAtomList.empty() )
     for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
        (*atom).spare = false;

   if ( ! mSphereList.empty() )
     for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
        (*sphere).spare = false;

   if ( ! mDonutList.empty() )
     for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
        (*donut).spare = false;
   m_thread_critical_section.Leave();

   int nChanged=0;

   if ( CcModelObject * oitem = FindAtomByLabel(atomname) )
   {
     oitem->spare = true;  // Set spare to true for the passed in atom.
     nChanged = 1;
   }

// Loop setting spare to true for any atoms bonded to other atoms
// that also have spare true, until no more changes.

   m_thread_critical_section.Enter();
   while ( nChanged )
   {
     nChanged = 0;

     if ( ! mBondList.empty() )
       for ( list<CcModelBond>::iterator bond=mBondList.begin();    bond != mBondList.end();   bond++)
         if ( (*bond).m_patms.size() >= 2 )
           if (( (*bond).m_patms[0]->spare ) && ( ! (*bond).m_patms[1]->spare ))
           {
              (*bond).m_patms[1]->spare = true;
              nChanged++;
           }
           else if (( (*bond).m_patms[1]->spare ) && ( ! (*bond).m_patms[0]->spare ))
           {
              (*bond).m_patms[0]->spare = true;
              nChanged++;
           }
   }
   m_thread_critical_section.Leave();

}


void CcModelDoc::SelectFrag(const string & atomname, bool select)
{
   FlagFrag ( atomname );

   m_thread_critical_section.Enter();
// Select or unselect all spare-flagged atoms.

  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
      if ( (*atom).spare ) (*atom).Select(select);
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
      if ( (*sphere).spare ) (*sphere).Select(select);
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
      if ( (*donut).spare ) (*donut).Select(select);
  m_thread_critical_section.Leave();
  DrawViews();
}


string CcModelDoc::FragAsString( const string & atomname, string delimiter )
{
  string result;
  FlagFrag ( atomname );

  m_thread_critical_section.Enter();
  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
        if ( (*atom).spare ) result += (*atom).Label() + delimiter;
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
        if ( (*sphere).spare ) result += (*sphere).Label() + delimiter;
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
        if ( (*donut).spare ) result += (*donut).Label() + delimiter;
  m_thread_critical_section.Leave();
  return result;
}



string CcModelDoc::SelectedAsString( string delimiter )
{
  string result;

  m_thread_critical_section.Enter();
  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
        if ( (*atom).IsSelected() ) result += (*atom).Label() + delimiter;
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
        if ( (*sphere).IsSelected() ) result += (*sphere).Label() + delimiter;
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
        if ( (*donut).IsSelected() ) result += (*donut).Label() + delimiter;
   m_thread_critical_section.Leave();
  return result;
}



void CcModelDoc::SendAtoms( int style, bool sendonly )
{
  m_thread_critical_section.Enter();
  for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
        if ( (*atom).IsSelected() ) (*atom).SendAtom (style, sendonly);
  for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
        if ( (*sphere).IsSelected() ) (*sphere).SendAtom (style, sendonly);
  for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
        if ( (*donut).IsSelected() ) (*donut).SendAtom (style, sendonly);
   m_thread_critical_section.Leave();
}

void CcModelDoc::ZoomAtoms( bool doZoom )
{
  m_thread_critical_section.Enter();
  if ( ! mAtomList.empty() )
    for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
      if ( (*atom).IsSelected() )  (*atom).m_excluded = false;
      else                         (*atom).m_excluded = doZoom;

  if ( ! mSphereList.empty() )
    for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
        if ( (*sphere).IsSelected() )  (*sphere).m_excluded = false;
        else                           (*sphere).m_excluded = doZoom;

  if ( ! mDonutList.empty() )
    for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
        if ( (*donut).IsSelected() ) (*donut).m_excluded = false;
        else                         (*donut).m_excluded = doZoom;

  if ( ! mBondList.empty() )
     for ( list<CcModelBond>::iterator bond=mBondList.begin();    bond != mBondList.end();   bond++)
       (*bond).SelfExclude();
  m_thread_critical_section.Leave();

}

CcModelObject * CcModelDoc::FindObjectByGLName(GLuint name)
{

// These could be speeded up by breaking on a hit.

  CcModelObject * ratom = nil;
  m_thread_critical_section.Enter();
  if ( ! mAtomList.empty() )
    for ( list<CcModelAtom>::iterator atom=mAtomList.begin();       atom != mAtomList.end();     atom++)
        if ( (*atom).m_glID == name )  { 
              ratom = &(*atom);
              break;
        } 

  if ( ! mBondList.empty() && !ratom )
    for ( list<CcModelBond>::iterator bond=mBondList.begin();    bond != mBondList.end();   bond++)
        if ( (*bond).m_glID == name )  {
              ratom = &(*bond);
              break;
        } 

  if ( ! mSphereList.empty() && !ratom)
    for ( list<CcModelSphere>::iterator sphere=mSphereList.begin(); sphere != mSphereList.end(); sphere++)
       if ( (*sphere).m_glID == name )  {
              ratom = &(*sphere);
              break;
        } 

  if ( ! mDonutList.empty() && !ratom)
    for ( list<CcModelDonut>::iterator donut=mDonutList.begin();    donut != mDonutList.end();   donut++)
        if ( (*donut).m_glID == name )  {
              ratom = &(*donut);
              break;
        } 

  m_thread_critical_section.Leave();
  return ratom;
}



void CcModelDoc::FastBond(int x1,int y1,int z1, int x2, int y2, int z2,
                          int r, int g, int b,  int rad,int btype,
                          int np, int * ptrs, const string & label, const string & cslabl)
{

        CcModelBond item (x1,y1,z1,x2,y2,z2,
                      r, g, b,  rad, btype,
                      np, ptrs, label, cslabl, this);
		item.m_glID = m_glIDs++;
        m_thread_critical_section.Enter();
        mBondList.push_back(item);
        m_thread_critical_section.Leave();
}

void CcModelDoc::FastAtom(const string & label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,float cov, int vdw,
                          int spare, int flag,
                          float u1,float u2,float u3,float u4,float u5,
                          float u6,float u7,float u8,float u9,
                          float frac_x, float frac_y, float frac_z,
                          const string & elem, int serial, int refflag,
                          int assembly, int group, float ueq, float fspare)

{
    m_thread_critical_section.Enter();
        CcModelAtom item(label,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          u1,u2,u3,u4,u5,u6,u7,u8,u9,frac_x,
                          frac_y,frac_z,elem,serial,refflag,
                          assembly, group, ueq,fspare,this);
        m_nAtoms++;
        item.id = m_nAtoms + mDonutList.size() + mSphereList.size();
		item.m_glID = m_glIDs++;
        mAtomList.push_back(item);
    m_thread_critical_section.Leave();

}

void CcModelDoc::FastSphere(const string & label,int x1,int y1,int z1, 
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag, int iso, int irad)
{
        m_thread_critical_section.Enter();
            CcModelSphere item(label,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          iso,irad,this);
            mSphereList.push_back(item);
        m_thread_critical_section.Leave();

}

void CcModelDoc::FastDonut(const string & label,int x1,int y1,int z1,
                          int r, int g, int b, int occ,int cov, int vdw,
                          int spare, int flag, int iso, int irad, int idec, int iaz)
{
    m_thread_critical_section.Enter();
        CcModelDonut item(label,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          iso,irad,idec,iaz,this);
		item.m_glID = m_glIDs++;
        mDonutList.push_back(item);
    m_thread_critical_section.Leave();
}



extern "C" {

//declarations:

void fastbond  (int x1,int y1,int z1, int x2, int y2, int z2,
                int r, int g, int b,  int rad,int btype,
                int np, int * ptrs, char label[80], char slabel[80] );
void fastatom  (char* elem,int serial,char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,float cov, int vdw,
                int spare, int flag, float u1,float u2,float u3,float u4,float u5,
                float u6,float u7,float u8,float u9, float fx, float fy, float fz,
                int refflag, int assembly, int group, float ueq, float fspare);
void fastsphere  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad);
void fastdonut  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad, int idec, int iaz);
}

//implementations:

void fastbond  (int x1,int y1,int z1, int x2, int y2, int z2,
                int r, int g, int b,  int rad,int btype,
                int np, int * ptrs,
                char label[80], char slabel[80] )
{
      string clabel = label;
      LOGSTAT ( "-----------Fastbond added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastBond(x1,y1,z1,x2,y2,z2,r,g,b,rad,btype,
                                         np,ptrs,clabel,slabel);
}

void fastatom  (char* elem,int serial,char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,float cov, int vdw,
                int spare, int flag, float u1,float u2,float u3,float u4,float u5,
                float u6,float u7,float u8,float u9, float fx, float fy, float fz,
                int refflag, int assembly, int group, float ueq, float fspare)
{
      string clabel = label;
      string celem  = elem;
      LOGSTAT ( "-----------Fastatom added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastAtom(clabel,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,
                          u1,u2,u3,u4,u5,u6,u7,u8,u9,fx,fy,fz,
                          celem,serial,refflag,assembly,group,ueq, fspare) ;

}

void fastsphere  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad)
{
      string clabel = label;
      LOGSTAT ( "-----------Fastsphere added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastSphere(clabel,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,iso,irad) ;

}

	void fastdonut  (char* label,int x1,int y1,int z1, 
                int r, int g, int b, int occ,int cov, int vdw,
                int spare, int flag, int iso, int irad, int idec, int iaz)
{
      string clabel = label;
      LOGSTAT ( "-----------Fastdonut added:" + clabel );
      if ( CcModelDoc::sm_CurrentModelDoc )
            CcModelDoc::sm_CurrentModelDoc->FastDonut(clabel,x1,y1,z1, 
                          r,g,b,occ,cov,vdw,spare,flag,iso,irad,idec,iaz) ;

}

