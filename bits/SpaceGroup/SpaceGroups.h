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
#include <fstream>
#include <vector>
using namespace std;

class SpaceGroup:public MyObject
{
    private:
        char* iSymbols;
    public:
        SpaceGroup(char* pSymbols);
        SpaceGroup(const SpaceGroup& pSpaceGroup);
        ~SpaceGroup();
        char* getSymbol();
        std::ostream& output(std::ostream& pStream);
        std::ostream& SpaceGroup::crystalsOutput(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, SpaceGroup& pSpaceGroup);

class SpaceGroups:private vector<SpaceGroup>
{	
    private:
        char* iBrackets;
        void addSpaceGroups(char* pSpaceGroups);
    public:
        SpaceGroups(char* pSpaceGroups);
        long count();
        std::ostream& output(std::ostream& pStream);
        std::ofstream& output(std::ofstream& pStream);
};

std::ofstream& operator<<(std::ofstream& pStream, SpaceGroups& pSpaceGroups);
std::ostream& operator<<(std::ostream& pStream, SpaceGroups& pSpaceGroups);

class SGColumn:public ArrayList<SpaceGroups>
{
    private:
        char* iPointGroup;
    public:
        SGColumn();
        ~SGColumn();
        void add(char* pSpaceGroup, int pRow);
        void setPointGroup(char* pHeading);
        char* getPointGroup();
};
#endif
