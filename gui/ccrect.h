////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcRect

////////////////////////////////////////////////////////////////////////

//   Filename:  CcRect.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   Modified:  11.3.1998 11:36 Uhr

#ifndef		__CcRect_H__
#define		__CcRect_H__
//Insert your own code here.

//End of user code.         
 
class	CcRect
{
	public:
		// methods
			CcRect();
                  CcRect( const CcRect & inRect );
                  CcRect( CcString inGeom );
			CcRect( const int top, const int left, const int bottom, const int right );
			~CcRect();
		void	Set( const int top, const int left, const int bottom, const int right );
		const int	Top();
		const int	Left();
		const int	Bottom();
		const int	Right();
		const int	Height();
		const int	Width();
		CcRect&	operator=( const CcRect &inRect );
            CcString AsString();

		// attributes
		int	mTop;
		int	mLeft;
		int	mBottom;
		int	mRight;		
		
};
#endif
