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
#include "Symmetry.h"
#include "StringClasses.h"

SpaceGroup::SpaceGroup(string& pSymbols):CrystSymmetry(pSymbols, 1), iCentering("P")
{
	iCentering = pSymbols.substr(0, 1);
}

SpaceGroup::SpaceGroup(const SpaceGroup& pSpaceGroup):CrystSymmetry(pSpaceGroup), iCentering(pSpaceGroup.iCentering)
{}

SpaceGroup::~SpaceGroup()
{
}

string SpaceGroup::getSymbol()
{
    return iCentering + (*this);
}

std::ostream& SpaceGroup::output(std::ostream& pStream)
{
    return pStream << getSymbol();
}

std::ostream& SpaceGroup::crystalsOutput(std::ostream& pStream)
{
	string tOldSymbol = getSymbol();
    const size_t tSize = tOldSymbol.length();
    char* tSymbol = new char[tSize*2];	//The end result shouldn't be any bigger than double the original
    long tUpto = 0;
    char tPrevChar = ' ';
    for (size_t i = 0; i < tSize; i++)
    {
        if (strchr("12346abcdmnABCIFPR-", tOldSymbol[i])!=NULL && strchr("12346abcdmnABCIFPR", tPrevChar)!=NULL)
        {
            tSymbol[tUpto] = ' ';
            tUpto++;
        }
        else if (tOldSymbol[i] == '_')
        {
            i++;
        }
        tSymbol[tUpto] = tOldSymbol[i];
        tPrevChar = tOldSymbol[i];
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
    if (regexec(gSpaceGroupsFSO, pSpaceGroups, gMatches, gMatch, 0))
    {
        throw MyException(kUnknownException, "Space groups where in bad format.");
    }
	string tSymbols(pSpaceGroups+(long)gMatch[1].rm_so, pSpaceGroups+(long)gMatch[1].rm_eo);
    SpaceGroup tSpaceGroupObj(tSymbols);
    insert(end(), tSpaceGroupObj);
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

SGColumn::SGColumn():ArrayList<SpaceGroups>(1), iPointGroup(vector<CrystSymmetry>())
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

void SGColumn::setPointGroup(char* pHeading)
{	
	Regex tPoinGroupRE("[[:space:]]*([^,]*)([[:space:]]*,[[:space:]]*(.*)[[:space:]]*)?"); //Reg exp for pulling the point groups apart
	string tPointGroups = pHeading;
	regmatch_t tMatches[4];
	
	iPointGroup.clear();
	tMatches[0].rm_so = 0;
	tMatches[0].rm_eo = tPointGroups.length();
	while (tMatches[0].rm_so != tMatches[0].rm_eo)
	{
		tPoinGroupRE.exec(tPointGroups, 4, tMatches, REG_STARTEND);
		string tPointGroup(tPointGroups, tMatches[1].rm_so, tMatches[1].rm_eo -tMatches[1].rm_so);
		CrystSymmetry tSymmetry(tPointGroup);
		iPointGroup.push_back(tSymmetry);
		tMatches[0].rm_so = tMatches[3].rm_so;
		tMatches[0].rm_eo = tMatches[3].rm_eo;
	} 
 }

vector<CrystSymmetry>& SGColumn::getPointGroup()
{
    return iPointGroup;
}
