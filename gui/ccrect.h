////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcRect

////////////////////////////////////////////////////////////////////////

//   Filename:  CcRect.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.7  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.6  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.5  2001/06/17 15:19:09  richard
//   MidX() and MidY() return midpoints of rectangle.
//
//   Revision 1.4  2001/03/08 15:20:51  richard
//   New function .Contains(x,y) true if point is within rectangle.
//   New function .Native() returns GUI specific rectangle - CRect or wxRect.
//   New function .Sort() returns a rectangle ensuring mLeft<mRight and mTop<mBottom by
//   swapping them if necessary.
//

#ifndef     __CcRect_H__
#define     __CcRect_H__
//Insert your own code here.

//End of user code.

class   CcRect
{
    public:
        // methods
            CcRect();
            CcRect( const CcRect & inRect );
            CcRect( const string & inGeom );
            CcRect( const int top, const int left, const int bottom, const int right );
            ~CcRect();
        void    Set( const int top, const int left, const int bottom, const int right );
                bool Contains(int x, int y);
        const int   Top();
        const int   Left();
        const int   Bottom();
        const int   Right();
        const int   Height();
        const int   Width();
        const int   MidX();
        const int   MidY();
        CcRect& operator=( const CcRect &inRect );
            string AsString();

#ifdef CRY_USEMFC
                CRect Native();
#endif
        // attributes
        int mTop;
        int mLeft;
        int mBottom;
        int mRight;
        CcRect Sort();
};
#endif
