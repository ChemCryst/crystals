////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcRect

////////////////////////////////////////////////////////////////////////

//   Filename:  CcRect.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   Modified:  11.3.1998 11:36 Uhr

#include	"CrystalsInterface.h"
#include	"CcRect.h"
//Insert your own code here.

//End of user code.          

// OPSignature:  CcRect:CcRect() 
	CcRect::CcRect()
//Insert your own initialization here.

//End of user initialization.         
{
//Insert your own code here.
	Set( 0, 0, 100, 100 );
//End of user code.         
}
// OPSignature:  CcRect:CcRect( CcRect:&inRect ) 
	CcRect::CcRect( CcRect &inRect )
//Insert your own initialization here.

//End of user initialization.         
{
//Insert your own code here.
	mTop	= inRect.Top();
	mLeft	= inRect.Left();
	mBottom	= inRect.Bottom();
	mRight	= inRect.Right();
//End of user code.         
}
// OPSignature:  CcRect:CcRect( int:top  int:left  int:bottom  int:right ) 
	CcRect::CcRect( const int top, const int left, const int bottom, const int right )
//Insert your own initialization here.

//End of user initialization.         
{
//Insert your own code here.
	Set( top, left, bottom, right );
//End of user code.         
}
// OPSignature:  CcRect:~CcRect() 
	CcRect::~CcRect()
{
//Insert your own code here.

//End of user code.         
}
// OPSignature:  CcRect:Set( int:top  int:left  int:bottom  int:right ) 
void	CcRect::Set( const int top, const int left, const int bottom, const int right )
//Insert your own initialization here.

//End of user initialization.         
{
//Insert your own code here.
	mTop	= top;
	mLeft	= left;
	mBottom	= bottom;
	mRight	= right;
//End of user code.         
}
// OPSignature: int CcRect:Top() 
const int	CcRect::Top()
{
//Insert your own code here.
	return mTop;
//End of user code.         
}
// OPSignature: int CcRect:Left() 
const int	CcRect::Left()
{
//Insert your own code here.
	return mLeft;
//End of user code.         
}
// OPSignature: int CcRect:Bottom() 
const int	CcRect::Bottom()
{
//Insert your own code here.
	return mBottom;
//End of user code.         
}
// OPSignature: int CcRect:Right() 
const int	CcRect::Right()
{
//Insert your own code here.
	return mRight;
//End of user code.         
}
// OPSignature: int CcRect:Height() 
const int	CcRect::Height()
{
//Insert your own code here.
	return mBottom - mTop;
//End of user code.         
}
// OPSignature: int CcRect:Width() 
const int	CcRect::Width()
{
//Insert your own code here.
	return mRight - mLeft;
//End of user code.         
}
// OPSignature: CcRect& CcRect:operator=( const CcRect:&inRect ) 
CcRect&	CcRect::operator=( const CcRect &inRect )
{
//Insert your own code here.
	if ( this != &inRect )
	{
		mTop	= inRect.mTop;
		mLeft	= inRect.mLeft;
		mBottom	= inRect.mBottom;
		mRight	= inRect.mRight;
	}
	
	return *this;
//End of user code.         
}
