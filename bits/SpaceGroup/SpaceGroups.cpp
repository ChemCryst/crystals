/*
 *  SpaceGroups.cpp
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 25 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
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

std::ostream& SpaceGroup::crystalsOutput(std::ostream& pStream)
{
    const long tSize = (long)strlen(iSymbols);
    char* tSymbol = new char[tSize*2];	//The end result shouldn't be any begger than double the original
    long tUpto = 0;
    char tPrevChar = ' ';
    for (int i = 0; i < tSize; i++)
    {
        if (strchr("12346abcdmnABCIFPR-", iSymbols[i])!=NULL && strchr("12346abcdmnABCIFPR", tPrevChar)!=NULL)
        {
            tSymbol[tUpto] = ' ';
            tUpto++;
        }
        else if (iSymbols[i] == '_')
        {
            i++;
        }
        tSymbol[tUpto] = iSymbols[i];
        tPrevChar = iSymbols[i];
        tUpto ++;
    }
    tSymbol[tUpto] = '\0';
    return pStream << tSymbol;
}

std::ostream& operator<<(std::ostream& pStream, SpaceGroup& pSpaceGroup)
{
    return pSpaceGroup.output(pStream);
}

//These are here to save allocation time. You have to make sure that you don't try and uses them where they might get over written.
static regex_t * gSpaceGroupsFSO =NULL;
static regex_t * gSGBraketsFSO =NULL;
const size_t gMatches = 10;
regmatch_t gMatch[gMatches];

SpaceGroups::SpaceGroups(char* pSpaceGroups):iBrackets(NULL)
{
    if (gSpaceGroupsFSO == NULL)
    {//(([^\\[\\{].+[^\\]\\}]))
        #if defined(_WIN32)
                char tSGBraketsRE[] = "^(([^[{].*[^]}])|(\\[(.+)\\])|(\\{(.+)\\})|(-))$";
        #else
                char tSGBraketsRE[] = "(^([^\\[\\{].*[^]}])|(\\[(.+)\\])|(\\{(.+)\\})|(-)$)";
        #endif
        char tSpaceGroupsRE[] = "([PABCIRF][-123456abcdnm_/]+)(,[[:space:]]+([PABCIRF][-123456abcnm_/]+))?";
        gSGBraketsFSO = new regex_t;
        gSpaceGroupsFSO = new regex_t;
        regcomp(gSGBraketsFSO, tSGBraketsRE, REG_EXTENDED);
        regcomp(gSpaceGroupsFSO, tSpaceGroupsRE, REG_EXTENDED);
    }
    if (regexec(gSGBraketsFSO, pSpaceGroups, gMatches, gMatch, 0))
    {
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
    return (long)size();
}

std::ostream& SpaceGroups::output(std::ostream& pStream)
{
    long tNumber = (long)this->size();
    
    if (iBrackets)
        pStream << iBrackets[0];
    if (tNumber == 0)
        pStream << "-";
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
    long tNumber = (long)this->size();
    
    for (int i = 0; i < tNumber; i++)
    {
        (*this)[i].crystalsOutput(pStream);
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

SGColumn::SGColumn():ArrayList<SpaceGroups>(1), iPointGroup(NULL)
{}

SGColumn::~SGColumn()
{
    int tSize = length();
    
    for (int i = 0; i < tSize; i++)
    {
        SpaceGroups* tSpace = get(i);
        if (tSpace)
        {
            delete tSpace;
        }
    }
}

void SGColumn::add(char* pSpaceGroup,  int pRow)
{
    setWithAdd(new SpaceGroups(pSpaceGroup), pRow);
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
