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

/*!
 * @class SpaceGroup 
 * @description Not yet documented.
 * @abstract
*/
class SpaceGroup:public CrystSymmetry
{
    private:
		string iCentering;
        //char* iSymbols;
    public:
		SpaceGroup(string& pSymbols);
		SpaceGroup(const SpaceGroup& pSpaceGroup);
        ~SpaceGroup();

        /*!
         * @function getSymbol 
         * @description Not yet documented.
         * @abstract
         */
        string getSymbol();
		
        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
        std::ostream& SpaceGroup::crystalsOutput(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, SpaceGroup& pSpaceGroup);

/*!
 * @class SpaceGroups 
 * @description Not yet documented.
 * @abstract
*/
class SpaceGroups:public vector<SpaceGroup>
{	
    private:
        char* iBrackets;

        /*!
         * @function addSpaceGroups 
         * @description Not yet documented.
         * @abstract
         */
        void addSpaceGroups(char* pSpaceGroups);
    public:
        SpaceGroups(char* pSpaceGroups);

        /*!
         * @function count 
         * @description Not yet documented.
         * @abstract
         */
        long count();

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ofstream& output(std::ofstream& pStream);
};

std::ofstream& operator<<(std::ofstream& pStream, SpaceGroups& pSpaceGroups);
std::ostream& operator<<(std::ostream& pStream, SpaceGroups& pSpaceGroups);

/*!
 * @class SGColumn 
 * @description Not yet documented.
 * @abstract
*/
class SGColumn:public vector<SpaceGroups*>
{
    private:
        vector<CrystSymmetry> iPointGroup;
    public:
        SGColumn();
        ~SGColumn();

        /*!
         * @function add 
         * @description Not yet documented.
         * @abstract
         */
        void add(char* pSpaceGroup, const size_t pRow);

        /*!
         * @function setPointGroup 
         * @description Not yet documented.
         * @abstract
         */
        void setPointGroup(char* pHeading);

        /*!
         * @function getPointGroup 
         * @description Not yet documented.
         * @abstract
         */
        vector<CrystSymmetry>& getPointGroup();
};
#endif
