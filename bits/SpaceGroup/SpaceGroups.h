/*
 *  SpaceGroups.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 25 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(__SPACE_GROUPS_H__)
#define __SPACE_GROUPS_H__
#include "Collections.h"
#include "BaseTypes.h"
#include <iostream>
using namespace std;

class SpaceGroup:public MyObject
{
    private:
        char* iSymbols;
    public:
        SpaceGroup(char* pSymbols);
        ~SpaceGroup();
        char* getSymbol();
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, SpaceGroup& pSpaceGroup);

class SGColumn:virtual public Column
{
    private:
        char* iPointGroup;
        ArrayList<SpaceGroup>* iSpaceGroups;
    public:
        SGColumn();
        ~SGColumn();
        void add(char* pSpaceGroup, int pRow);
        SpaceGroup* get(int pIndex);
        int length();
        void setHeading(char* pHeading);
        char* getPointGroup();
};
#endif