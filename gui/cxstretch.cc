////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $
//   Revision 1.1  2001/02/26 12:07:05  richard
//   New stretch class. Probably the simplest class ever written, it has no functionality
//   except that it can be put in a grid of non-resizing items, and it will make that
//   row, column or both appear to be able to resize, thus spreading out fixed size items.
//

#include    "crystalsinterface.h"
#include    "cxstretch.h"
#include    "cxgrid.h"
//#include    "cccontroller.h"
#include    "crstretch.h"

int CxStretch::mStretchCount = kStretchBase;
CxStretch *    CxStretch::CreateCxStretch( CrStretch * container, CxGrid * guiParent )
{
    CxStretch  *theStretch = new CxStretch( container );
#ifdef __CR_WIN__
    theStretch->Create(NULL,"Stretch", WS_CHILD| WS_VISIBLE, CRect(0,0,20,20), guiParent, mStretchCount++, NULL);
#endif
#ifdef __BOTHWX__
    theStretch->Create(guiParent,-1,wxPoint(0,0),wxSize(20,20));
#endif
    return theStretch;
}

CxStretch::CxStretch( CrStretch * container )
  :BASESTRETCH()
{
    ptr_to_crObject = container;
}

CxStretch::~CxStretch() { }

void CxStretch::CxDestroyWindow()
{
  #ifdef __CR_WIN__
DestroyWindow();
#endif
#ifdef __BOTHWX__
Destroy();
#endif
}


CXSETGEOMETRY(CxStretch)

CXGETGEOMETRIES(CxStretch)

int CxStretch::GetIdealWidth()  { return EMPTY_CELL; }

int CxStretch::GetIdealHeight() { return EMPTY_CELL; }
