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
#include "Exceptions.h"
#include <iostream>
#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif

SpaceGroup::SpaceGroup(char* pSymbols)
{
    iSymbols = new char[strlen(pSymbols)+1];
    strcpy(iSymbols, pSymbols);
}

SpaceGroup::SpaceGroup(const SpaceGroup& pSpaceGroup)
{
    iSymbols = new char[strlen(pSpaceGroup.iSymbols)+1];
    strcpy(iSymbols, pSpaceGroup.iSymbols);
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

//char* iBrackets;
//These are here to save allocation time. You have to make sure that you don't try and uses them where they might get over written.
static regex_t * gSpaceGroupsFSO =NULL;
static regex_t * gSGBraketsFSO =NULL;
const size_t gMatches = 8;
regmatch_t gMatch[gMatches];

SpaceGroups::SpaceGroups(char* pSpaceGroups)
{
    iBrackets = NULL;
    if (gSpaceGroupsFSO == NULL)
    {
        char tSGBraketsRE[] = "(^([^\\[\\{].*[^]}])$)|(^\\[(.+)\\]$)|(^\\{(.+)\\}$)|(-)";
        char tSpaceGroupsRE[] = "([PABCIRF][-123456abcdnm_/]+)(,[[:space:]]+([PABCIRF][-123456abcnm_/]+))?";
        gSGBraketsFSO = new regex_t;
        gSpaceGroupsFSO = new regex_t;
        regcomp(gSGBraketsFSO, tSGBraketsRE, REG_EXTENDED);
        regcomp(gSpaceGroupsFSO, tSpaceGroupsRE, REG_EXTENDED);
    }
    
    if (regexec(gSGBraketsFSO, pSpaceGroups, gMatches, gMatch, 0))
    {
        cout << pSpaceGroups << "\n";
        cout.flush();
        throw MyException(kUnknownException, "SpaceGroups where in bad format.");
    }
    if (gMatch[2].rm_so > -1)
    {
        char * tSubString = new char[(long)(gMatch[2].rm_eo - gMatch[2].rm_so)+1];
        tSubString[(long)(gMatch[2].rm_eo - gMatch[2].rm_so)] = '\0';
        strncpy(tSubString, pSpaceGroups+(long)(gMatch[2].rm_so), (long)(gMatch[2].rm_eo - gMatch[2].rm_so));
        addSpaceGroups(tSubString);
        delete[] tSubString;
    }
    else if (gMatch[3].rm_so > -1)
    {
        iBrackets = new char[3];
        strcpy(iBrackets, "[]");
        char * tSubString = new char[(long)(gMatch[4].rm_eo - gMatch[4].rm_so)+1];
        tSubString[(long)(gMatch[4].rm_eo - gMatch[4].rm_so)] = '\0';
        strncpy(tSubString, pSpaceGroups+(long)(gMatch[4].rm_so), (long)(gMatch[4].rm_eo - gMatch[4].rm_so));
        addSpaceGroups(tSubString);
        delete[] tSubString;
    }
    else if(gMatch[5].rm_so > -1)
    {
        iBrackets = new char[3];
        strcpy(iBrackets, "{}");
        char * tSubString = new char[(long)(gMatch[6].rm_eo - gMatch[6].rm_so)+1];
        tSubString[(long)(gMatch[6].rm_eo - gMatch[6].rm_so)] = '\0';
        strncpy(tSubString, pSpaceGroups+(long)(gMatch[6].rm_so), (long)(gMatch[6].rm_eo - gMatch[6].rm_so));
        addSpaceGroups(tSubString);
        delete[] tSubString;
    }
    else if(gMatch[7].rm_so > -1)
    {
    
    }
}

void SpaceGroups::addSpaceGroups(char* pSpaceGroups)
{
    char * tSpaceGroup;
    
    if (regexec(gSpaceGroupsFSO, pSpaceGroups, gMatches, gMatch, 0))
    {
         cout << pSpaceGroups << "\n";
        cout.flush();
        throw MyException(kUnknownException, "Space groups where in bad format.");
    }
    tSpaceGroup = new char[gMatch[1].rm_eo - gMatch[1].rm_so+1];
    tSpaceGroup[gMatch[1].rm_eo - gMatch[1].rm_so] = '\0';
    strncpy(tSpaceGroup, pSpaceGroups+(long)gMatch[1].rm_so, gMatch[1].rm_eo - gMatch[1].rm_so);
    SpaceGroup tSpaceGroupObj(tSpaceGroup);
    insert(end(), tSpaceGroupObj);
    delete[] tSpaceGroup;
    if ((long)gMatch[2].rm_so > -1)
    {
        addSpaceGroups(pSpaceGroups+gMatch[3].rm_so);
    }
}

long SpaceGroups::count()
{
    return size();
}

std::ostream& SpaceGroups::output(std::ostream& pStream)
{
    int tNumber = size();
    
    if (iBrackets)
        pStream << iBrackets[0];
    for (int i = 0; i < tNumber; i++)
    {
        
        pStream << (*this)[i];
        if (i+1 < tNumber)
            pStream << ", ";
    }
    if (iBrackets)
        pStream << iBrackets[1];
    return pStream;
}

std::ofstream& SpaceGroups::output(std::ofstream& pStream)
{
    int tNumber = size();
    
    for (int i = 0; i < tNumber; i++)
    {
        pStream << (*this)[i];
        if (i+1 < tNumber)
            pStream << "\n";
    }
    return pStream;
}

std::ofstream& operator<<(std::ofstream& pStream, SpaceGroups& pSpaceGroups)
{
    return pSpaceGroups.output(pStream);
}

std::ostream& operator<<(std::ostream& pStream, SpaceGroups& pSpaceGroups)
{
    return pSpaceGroups.output(pStream);
}

SGColumn::SGColumn()
{
    iPointGroup = NULL;
    iSpaceGroups = new ArrayList<SpaceGroups>(1);
}

SGColumn::~SGColumn()
{
    int tSize = iSpaceGroups->length();
    
    for (int i = 0; i < tSize; i++)
    {
        SpaceGroups* tSpace = iSpaceGroups->get(i);
        if (tSpace)
        {
            delete tSpace;
        }
    }
    delete iSpaceGroups;
}

void SGColumn::add(char* pSpaceGroup,  int pRow)
{
    iSpaceGroups->setWithAdd(new SpaceGroups(pSpaceGroup), pRow);
}

SpaceGroups* SGColumn::get(int pIndex)
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