/*
 *  SpaceGroups.cpp
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 25 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
//#include "stdafx.h"
#include "SpaceGroups.h"

SpaceGroup::SpaceGroup(char* pSymbols)
{
    iSymbols = new char[strlen(pSymbols)+1];
    strcpy(iSymbols, pSymbols);
}

SpaceGroup::~SpaceGroup()
{
    delete[] iSymbols;
}

char* SpaceGroup::getSymbol()
{
    return iSymbols;
}

std::ostream& SpaceGroup::output(std::ostream& pStream)
{
    return pStream << iSymbols;
}

std::ostream& operator<<(std::ostream& pStream, SpaceGroup& pSpaceGroup)
{
    return pSpaceGroup.output(pStream);
}

SGColumn::SGColumn()
{
    iPointGroup = NULL;
    iSpaceGroups = new ArrayList<SpaceGroup>(1);
}

SGColumn::~SGColumn()
{
    int tSize = iSpaceGroups->length();
    
    for (int i = 0; i < tSize; i++)
    {
        SpaceGroup* tSpace = iSpaceGroups->get(i);
        if (tSpace)
        {
            delete tSpace;
        }
    }
    delete iSpaceGroups;
}

void SGColumn::add(char* pSpaceGroup,  int pRow)
{
    iSpaceGroups->setWithAdd(new SpaceGroup(pSpaceGroup), pRow);
}

SpaceGroup* SGColumn::get(int pIndex)
{
    return iSpaceGroups->get(pIndex);
}

int SGColumn::length()
{
    return iSpaceGroups->length();
}

void SGColumn::setHeading(char* pHeading)
{
    if (iPointGroup)
    {
        delete[] iPointGroup;
    }
    iPointGroup = new char[strlen(pHeading)+1];
    strcpy(iPointGroup, pHeading);
}

char* SGColumn::getPointGroup()
{
    return iPointGroup;
}