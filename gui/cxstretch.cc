////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $

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
    theStretch->Create(guiParent, -1, "Stretch");
#endif
    return theStretch;
}

CxStretch::CxStretch( CrStretch * container )
  :BASESTRETCH()
{
    ptr_to_crObject = container;
}

CxStretch::~CxStretch() { }

CXSETGEOMETRY(CxStretch)

CXGETGEOMETRIES(CxStretch)

int CxStretch::GetIdealWidth()  { return EMPTY_CELL; }

int CxStretch::GetIdealHeight() { return EMPTY_CELL; }
