/*
 *  SpaceGroups.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 25 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __SPACE_GROUPS_H__
#define __SPACE_GROUPS_H__
#include "BaseTypes.h"
#include "Symmetry.h"
#include <iostream>
#include <fstream>
#include <vector>
using namespace std;

class SpaceGroup:public CrystSymmetry
{
    private:
		string iCentering;
        //char* iSymbols;
    public:
		SpaceGroup(string& pSymbols);
		SpaceGroup(const SpaceGroup& pSpaceGroup);
        ~SpaceGroup();
        string getSymbol();
        std::ostream& output(std::ostream& pStream);
        std::ostream& SpaceGroup::crystalsOutput(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, SpaceGroup& pSpaceGroup);

class SpaceGroups:public vector<SpaceGroup>
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

class SGColumn:public vector<SpaceGroups*>
{
    private:
        vector<CrystSymmetry> iPointGroup;
    public:
        SGColumn();
        ~SGColumn();
        void add(char* pSpaceGroup, const size_t pRow);
        void setPointGroup(char* pHeading);
        vector<CrystSymmetry>& getPointGroup();
};
#endif
