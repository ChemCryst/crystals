////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcRect

////////////////////////////////////////////////////////////////////////

//   Filename:  CcRect.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   $Log: not supported by cvs2svn $

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
                  CcRect( CcString inGeom );
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
        CcRect& operator=( const CcRect &inRect );
            CcString AsString();

#ifdef __CR_WIN__
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
