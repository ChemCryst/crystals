////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcRect

////////////////////////////////////////////////////////////////////////

//   Filename:  CcRect.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.12  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.11  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.10  2003/11/28 10:29:11  rich
//   Replace min and max macros with CRMIN and CRMAX. These names are
//   less likely to confuse gcc.
//
//   Revision 1.9  2003/05/07 12:18:56  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
//   Revision 1.8  2001/06/17 15:19:09  richard
//   MidX() and MidY() return midpoints of rectangle.
//
//   Revision 1.7  2001/03/08 15:20:50  richard
//   New function .Contains(x,y) true if point is within rectangle.
//   New function .Native() returns GUI specific rectangle - CRect or wxRect.
//   New function .Sort() returns a rectangle ensuring mLeft<mRight and mTop<mBottom by
//   swapping them if necessary.
//



#include    "crystalsinterface.h"


#include    <string>
#include    <sstream>
using namespace std;


#include        "ccrect.h"



CcRect::CcRect()
{
    Set( 0, 0, 100, 100 );
}

CcRect::CcRect( const CcRect &inRect )
{
      mTop  = inRect.mTop;
      mLeft = inRect.mLeft;
      mBottom     = inRect.mBottom;
      mRight      = inRect.mRight;
}

CcRect::CcRect( const string & geomString )
{
      istringstream s (geomString);
      s >> mTop >> mLeft >> mBottom >> mRight;    
}



string CcRect::AsString()
{
      ostringstream strm;
      strm << mTop << " " << mLeft << " " << mBottom << " " << mRight;
      return strm.str();
}


CcRect::CcRect( const int top, const int left, const int bottom, const int right )
{
    Set( top, left, bottom, right );
}

CcRect::~CcRect()
{
}

void    CcRect::Set( const int top, const int left, const int bottom, const int right )
{
    mTop    = top;
    mLeft   = left;
    mBottom = bottom;
    mRight  = right;
}

const int   CcRect::Top()
{
    return mTop;
}

const int   CcRect::Left()
{
    return mLeft;
}

const int   CcRect::Bottom()
{
    return mBottom;
}

const int   CcRect::Right()
{
    return mRight;
}

const int   CcRect::Height()
{
    return mBottom - mTop;
}

const int   CcRect::Width()
{
    return mRight - mLeft;
}

CcRect& CcRect::operator=( const CcRect &inRect )
{
    if ( this != &inRect )
    {
        mTop    = inRect.mTop;
        mLeft   = inRect.mLeft;
        mBottom = inRect.mBottom;
        mRight  = inRect.mRight;
    }

    return *this;
}

bool CcRect::Contains(int x, int y)
{
  return ( 
               (  ((x<=mRight)&&(x>=mLeft))  ||  ((x>=mRight)&&(x<=mLeft))  )
           &&  (  ((y<=mBottom)&&(y>=mTop))  ||  ((y>=mBottom)&&(y<=mTop))  )
         );
}


#ifdef CRY_USEMFC
CRect CcRect::Native()
{
  return CRect( mLeft, mTop, mRight, mBottom );
}
#endif



CcRect CcRect::Sort()
{
 return CcRect( CRMIN(mTop,mBottom), CRMIN(mLeft,mRight),
                CRMAX(mTop,mBottom), CRMAX(mLeft,mRight) );

}

const int CcRect::MidX()
{
  return ( mLeft + mRight ) / 2;
}

const int CcRect::MidY()
{
  return ( mTop + mBottom ) / 2;
}
