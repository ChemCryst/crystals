////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CcCoord
////////////////////////////////////////////////////////////////////////
//   Filename:  CcCoord.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.2  2001/03/08 16:44:04  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CcCoord_H__
#define     __CcCoord_H__

class   CcCoord
{
    public:
        // methods
            CcCoord();
            CcCoord( CcCoord &inCoord );
            CcCoord( const int x, const int y, const int z );
            ~CcCoord();
        void    Set( const int x, const int y, const int z );
        const int   X();
        const int   Y();
        const int   Z();
        CcCoord&    operator=( const CcCoord &inCoord );

        // attributes
        int mX;
        int mY;
        int mZ;
};

#endif
