/*
 *  Conditions.cpp
 *  Space Groups
 *
 *  Created by Stefan on Tue Jul 15 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#include "Conditions.h"
#include "CrystalSystem.h"
#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif
#include "StringClasses.h"

static regex_t* iCondRE  =NULL;

void initConRegEx()
{
    if (iCondRE == NULL)
    {
        char tCondRE[] = "^([[:digit:]]+)\t(([[:alnum:]]|[- =+])+)\t(\\[( *([-+]?[[:digit:]]+(\\.[[:digit:]]+)?) *(;)?)*( *([-+]?[[:digit:]]+(\\.[[:digit:]]+)?) *)\\])\t([[:digit:]]+)[[:space:]]*$";
            //Checks the formoat of a line in the conditons list is the conrrect format.
        iCondRE  = new regex_t;
        regcomp(iCondRE, tCondRE, REG_EXTENDED);
    }
}

void deleteConRegEx()
{
    if (iCondRE)
    {
        delete iCondRE;
        iCondRE = NULL;
    }
}

Condition::Condition(char* pLine)
{
/* Match Index 	Description
     * 0 	 	Line
     * 1		Index of string
     * 2 		Name of condition
     * 3		Vector for condition
     * 4		Bits and peaces
     * 5		"
     * 6		"
     * 7		"
     * 8		"
     * 9		Multiplier for condition
     */
    const size_t tMatches = 15;
    regmatch_t tMatch[tMatches];
    initConRegEx();
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iCondRE, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Condition had an invalid format!");
    }
    char* tString = new char[(int)(tMatch[4].rm_eo-tMatch[4].rm_so+1)];	//Get the matrix for the condition
    tString[(int)(tMatch[4].rm_eo-tMatch[4].rm_so)] = 0;
    strncpy(tString, pLine+(int)tMatch[4].rm_so, (int)tMatch[4].rm_eo-tMatch[4].rm_so);  
    iMatrix = new MatrixReader(tString);
    delete[] tString;
    iName = new char[(int)(tMatch[2].rm_eo-tMatch[2].rm_so+1)];		//Get the name of the condition
    iName[(int)(tMatch[2].rm_eo-tMatch[2].rm_so)] = 0;
    strncpy(iName, pLine+(int)tMatch[2].rm_so, (int)tMatch[2].rm_eo-tMatch[2].rm_so);  
    iID = strtol((const char*)(pLine+tMatch[1].rm_so), NULL, 10);			//Get the id of the condition
    iMult = (float)strtod((const char*)(pLine+tMatch[12].rm_so), NULL);			//Get the multiplier 
}

Condition::~Condition()
{
    deleteConRegEx();
    delete[] iName;
    delete iMatrix;
}

char* Condition::getName()
{
    return iName;
}

Matrix<short>* Condition::getMatrix()
{
    return iMatrix;
}

float Condition::getMult()
{
    return iMult;
}
        
int Condition::getID()
{
    return iID;
}

std::ostream& Condition::output(std::ostream& pStream)
{
    pStream << iID << "\t" << iName << "\t" << *iMatrix << " " << iMult << "\n";
    return pStream;
}

std::ostream& operator<<(std::ostream& pStream, Condition& pCondition)
{
    return pCondition.output(pStream);
}

Conditions::Conditions()
{
    iConditions = new ArrayList<Condition>(1);
}

Conditions::~Conditions()
{
    int iSize = iConditions->length();
    for (int i = 0; i < iSize; i++)
    {
        Condition* tCondition = iConditions->remove(i);
        if (tCondition)
        {
            delete tCondition;
        }
    }
    delete iConditions;
}

char* Conditions::getName(int pIndex)
{
    Condition* tCondition = iConditions->get(pIndex);
    
    if (!tCondition)
    {
        throw MyException(kUnknownException, "Condition with that ID doesn't exist.");
    }
    return tCondition->getName();
}

Matrix<short>* Conditions::getMatrix(int pIndex)
{
    Condition* tCondition = iConditions->get(pIndex);
    
    if (!tCondition)
    {
        throw MyException(kUnknownException, "Condition with that ID doesn't exist.");
    }
    return tCondition->getMatrix();
}

float Conditions::getMult(int pIndex)
{
    Condition* tCondition = iConditions->get(pIndex);
    
    if (!tCondition)
    {
        throw MyException(kUnknownException, "Condition with that ID doesn't exist.");
    }
    return tCondition->getMult();
}

char* Conditions::addCondition(char* pLine)	//Returns the point which the line at the start of this string finishs
{
    char* tNext = strchr(pLine, '\n');
    Condition* tCondition;
    if (tNext == NULL)
    {
           tCondition = new Condition(pLine);
    }
    else
    {
        char *tString = new char[(int)(tNext-pLine)+1];
        tString[(int)(tNext-pLine)] = 0;
        strncpy(tString, pLine, (int)(tNext-pLine));
        tCondition = new Condition(tString);
        tNext++;
        delete[] tString;
    }
    iConditions->setWithAdd(tCondition, tCondition->getID());
    return tNext;
}

void Conditions::readFrom(filebuf& pFile)
{
    char tHeaderLine[] = "ID	Name	Vector	Multiplier";
	std::istream tFile(&pFile);
    char tLine[255];
    int tLineNum = 0;
    
    do
    {
        tFile.getline(tLine, 255);
        String::trim(tLine);
    }while (strstr(tLine, tHeaderLine) == NULL && !tFile.eof());
    do
    {
        tFile.getline(tLine, 255);
        String::trim(tLine);
        try
        {
            if (tLine[0] != '\0')
                    addCondition(tLine);
        }
        catch (MyException& eE)
        {
            char tText[255];
            sprintf(tText, "On line %d", tLineNum);
            eE.addError(tText);
            throw eE;
        }
        tLineNum++;
    }
    while (!tFile.eof() && strlen(tLine)>0);
}

int Conditions::length()
{
    return iConditions->length();
}

std::ostream& Conditions::output(std::ostream& pStream)
{
    int tSize = iConditions->length();
    for (int i = 0; i < tSize; i++)
    {
        Condition* tCondition = iConditions->get(i);
        if (tCondition)
        {
            std::cout << *tCondition << "\n";
        }
        else
        {
            std::cout << "null\n";
        }
    }
    return pStream;
}


std::ostream& operator<<(std::ostream& pStream, Conditions& pConditions)
{
    return pConditions.output(pStream);
}

