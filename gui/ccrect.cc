////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcRect

////////////////////////////////////////////////////////////////////////

//   Filename:  CcRect.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   Modified:  11.3.1998 11:36 Uhr

#include	"crystalsinterface.h"
#include	"ccrect.h"


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

CcRect::CcRect( const int top, const int left, const int bottom, const int right )
{
	Set( top, left, bottom, right );
}

CcRect::~CcRect()
{
}

void	CcRect::Set( const int top, const int left, const int bottom, const int right )
{
	mTop	= top;
	mLeft	= left;
	mBottom	= bottom;
	mRight	= right;
}

const int	CcRect::Top()
{
	return mTop;
}

const int	CcRect::Left()
{
	return mLeft;
}

const int	CcRect::Bottom()
{
	return mBottom;
}

const int	CcRect::Right()
{
	return mRight;
}

const int	CcRect::Height()
{
	return mBottom - mTop;
}

const int	CcRect::Width()
{
	return mRight - mLeft;
}

CcRect&	CcRect::operator=( const CcRect &inRect )
{
	if ( this != &inRect )
	{
		mTop	= inRect.mTop;
		mLeft	= inRect.mLeft;
		mBottom	= inRect.mBottom;
		mRight	= inRect.mRight;
	}
	
	return *this;
}
