////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcCoord

////////////////////////////////////////////////////////////////////////

//   Filename:  CcCoord.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "cccoord.h"

CcCoord::CcCoord()
{
    Set( 0, 0, 0 );
}

CcCoord::CcCoord( CcCoord &inCoord )
{
    mX  = inCoord.X();
    mY  = inCoord.Y();
    mZ  = inCoord.Z();
}

CcCoord::CcCoord( const int x, const int y, const int z )
{
    Set( x,y,z );
}

CcCoord::~CcCoord()
{
}

void CcCoord::Set( const int x, const int y, const int z )
{
    mX  = x;
    mY  = y;
    mZ  = z;
}

const int   CcCoord::X()
{
    return mX;
}
const int   CcCoord::Y()
{
    return mY;
}
const int   CcCoord::Z()
{
    return mZ;
}
CcCoord& CcCoord::operator=( const CcCoord &inCoord )
{
    if ( this != &inCoord )
    {
        mX  = inCoord.mX;
        mY  = inCoord.mY;
        mZ  = inCoord.mZ;
    }

    return *this;
}
