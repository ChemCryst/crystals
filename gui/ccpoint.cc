////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPoint

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPoint.cc
//   Authors:   Richard Cooper 
//   Created:   26.5.1999 1:42 Hours

#include	"crystalsinterface.h"
#include    "ccpoint.h"

CcPoint::CcPoint()
{
      Set( 0, 0 );
}

CcPoint::CcPoint( const CcPoint &inPoint )
{
      x = inPoint.x;
      y = inPoint.y;
}
CcPoint::CcPoint( const int inX, const int inY )
{
      x = inX;
      y = inY;
}

CcPoint::~CcPoint()
{
}

void  CcPoint::Set( const int inX, const int inY )
{
      x  = inX;
      y  = inY;
}
const int   CcPoint::X()
{
      return x;
}

const int   CcPoint::Y()
{
      return y;
}

CcPoint& CcPoint::operator=( const CcPoint &inPoint )
{
      if ( this != &inPoint )
	{
            x  = inPoint.x;
            y  = inPoint.y;
	}
	return *this;
}
