/*
 *  CrystalSystem.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Thu Dec 05 2002.
 *  Copyright (c) 2002 __MyCompanyName__. All rights reserved.
 *
 */
 
/*** Naming conventions ***
 ** Variable/Constant **
 * These conventions should be followed as closely as possible when coding in the file.
 * All variable names should start with one of the following lower case letters.
 * t - variables which are declared locally to the method/function
 * i - variables which are members of the object.
 * g - variables which are global to the file.
 * p - variables which are parameters to a method/function.
 * k - constants
 *
 * All variables should be have descriptive names which. Should use capitalization in 
 * variable names.
 *
 * e.g.. 
 * double tSomeVariable;   //A variable which is declared inside method.
 * double pSomeParameter   //A variable which is a parameter to a method/function
 *
 ** Classes/Structures/Typedefs **
 * All these should have the first letter as a capital and the first letter of any word 
 * in the name should be a capital letter. All other letters should be lower case.
 * 
 * e.g.
 * class MyClass
 * {
 * 	function name	
 * };
 */
//#include "stdafx.h"
#include "CrystalSystem.h"
#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif
#include <fstream>

#include "StringClasses.h"
#include "MathFunctions.h"
#include "Exceptions.h"
#include <iomanip>
#include "Stats.h"
#include <fcntl.h>
#include <errno.h>

using namespace std;

static regex_t* iHeaderRE  =NULL;
static regex_t* iFirstNumRE  =NULL;
static regex_t* iFirstNSpRE  =NULL;
static regex_t* iTableRE  =NULL;
static regex_t* iTableArgsRE =NULL;

void initCrysRegEx()
{
    if (iHeaderRE == NULL)
    {
        char tHeaderRE[] = "^([[:digit:]]+)\t([hkl0-]{3}[hkl0-]?)\t(\\[[0123456789;. -]+\\])[[:space:]]*$";
            //Checks the format of the header line.
        char tFirstNumRE[] = "([[:digit:]]),?[[:space:]]?"; 
            //Takes the first number of a , delimited list of numbers.
        char tFirstNSpRE[] = "([^\t]+)(\t([^\t].+))?";	
            //Takes the first non-space part of the heading line and returns the point of it in $1
        char tTableRE[] = "([^\t]+)(\t[^\t].*)?";
            //Gets the first non-tab part of the line and returns its placing in $1.
        char tTableArgsRE[] = "([^\t]+)\t([[:digit:]]+), ([[:digit:]]+)";
            //The header line of the table. This contains the name of the system and the number of condition columns and the number of point group columns.
        iHeaderRE  = new regex_t;
        
        iFirstNumRE  = new regex_t;
        iFirstNSpRE  = new regex_t;
        iTableRE  = new regex_t;
        iTableArgsRE = new regex_t;
        regcomp(iHeaderRE, tHeaderRE, REG_EXTENDED);
        regcomp(iFirstNumRE, tFirstNumRE, REG_EXTENDED);
        regcomp(iFirstNSpRE, tFirstNSpRE, REG_EXTENDED);
        regcomp(iTableRE, tTableRE, REG_EXTENDED);
        regcomp(iTableArgsRE, tTableArgsRE, REG_EXTENDED);
    }
}

void deinitRE()
{
    if (iHeaderRE != NULL)
    {
        delete iHeaderRE;
        delete iFirstNumRE;
        delete iFirstNSpRE;
        delete iTableRE;
        delete iTableArgsRE;
        iHeaderRE = NULL;
        iFirstNumRE = NULL;
        iFirstNSpRE = NULL;
        iTableRE = NULL;
        iTableArgsRE = NULL;
    }
}

Region::Region(char* pLine):Matrix<short>(3, 3)
{
    const size_t tMatches = 4;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iHeaderRE, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Region had an invalid format!");
    }
    iName = new char[(int)(tMatch[2].rm_eo - tMatch[2].rm_so +1)];
    iName[(int)(tMatch[2].rm_eo - tMatch[2].rm_so)] = 0;
    strncpy(iName, tMatch[2].rm_so+pLine, (int)tMatch[2].rm_eo - tMatch[2].rm_so);
    char* tTempString = new char[(int)(tMatch[1].rm_eo - tMatch[1].rm_so +1)];
    strncpy(tTempString, (int)tMatch[1].rm_so+pLine, tMatch[1].rm_eo - tMatch[1].rm_so);
    tTempString[(int)(tMatch[1].rm_eo - tMatch[1].rm_so)] = 0;
    iID = strtol(tTempString, NULL, 10);
    delete[] tTempString;
    tTempString = new char[(int)(tMatch[3].rm_eo - tMatch[3].rm_so +1)];
    strncpy(tTempString, (int)tMatch[3].rm_so+pLine, (int)tMatch[3].rm_eo - tMatch[3].rm_so);
    tTempString[(int)(tMatch[3].rm_eo - tMatch[3].rm_so)] = 0;
    MatrixReader tMatrix(tTempString);
    (*(Matrix<short>*)this) = tMatrix;
    delete[] tTempString;
}

Region::~Region()
{
    delete[] iName;
}


char* Region::getName()
{
    return iName;
}

int Region::getID()
{
    return iID;
}

bool Region::contains(Matrix<short> &pHKL, LaueGroup &pLaueGroup, Matrix<short>& pResultMatrix)
{
	Matrix<short> tMatrixResult;
	Matrix<short> tNewHKLResult;
	Matrix<short> tWorkHKL(pHKL);
	Matrix<short> tZero(1, 3, 0);
	
	uint tNumMat = pLaueGroup.numberOfMatrices();
	
	for (int i = 0; i < 2; i++)
	{
		for (uint i = 0; i < tNumMat; i++)
		{ 
			tNewHKLResult = pLaueGroup.getMatrix(i) * pHKL;
			tMatrixResult = (*this) * tNewHKLResult;	//Multiply the two matrices to see if this reflection satisfy the condition
			if (tMatrixResult == tNewHKLResult)
			{
				pResultMatrix = tNewHKLResult;
				return true;
			}
		}
		tZero.sub(pHKL, tWorkHKL);
	}
	return false;
}

std::ostream& Region::output(std::ostream& pStream)
{
    pStream << iID << "\t" << iName << "\t" << (*(Matrix<short>*)this) << "\n";
    return pStream;
}

std::ostream& operator<<(std::ostream& pStream, Region& pHeader)
{
    return pHeader.output(pStream);
}

Regions::Regions():vector<Region*>()
{}

Regions::~Regions()
{
	vector<Region*>::iterator tIter;
	
    for (tIter = begin(); tIter != end(); tIter++)
    {
        Region* tRegion = *tIter;
		if (tRegion)
			delete tRegion;
    }
}

Matrix<short>* Regions::getMatrix(int pIndex)
{
    Region* tRegion = (*this)[pIndex];
    if (!tRegion)
    {
        throw MyException(kUnknownException, "Region with that ID doesn't exist.");
    }
    return tRegion;
}

char* Regions::getName(int pIndex)
{
    Region* tRegion = (*this)[pIndex];
    
    if (!tRegion)
    {
        throw MyException(kUnknownException, "Region with that ID doesn't exist.");
    }
    return tRegion->getName();
}

int Regions::getID(int pIndex)
{
    Region* tRegion = (*this)[pIndex];
    
    if (!tRegion)
    {
        throw MyException(kUnknownException, "Region with that ID doesn't exist.");
    }
    return tRegion->getID();
}

std::ostream& Regions::output(std::ostream& pStream)
{
    int tSize = size();
    for (int i = 0; i < tSize; i++)
    {
        Region* tRegion = (*this)[i];
        if (tRegion)
        {
            std::cout << *tRegion << "\n";
        }
        else
        {
            std::cout << "null\n";
        }
    }
    return pStream;
}

char* Regions::addRegion(char* pLine)	//Returns the point which the line at the start of this string finishs
{
    char* tNext = strchr(pLine, '\n');
    Region* tRegion = NULL;
    if (tNext == NULL)
    {
        tRegion = new Region(pLine);
    }
    else
    {
        char *tString = new char[(int)(tNext-pLine)+1];
        tString[(int)(tNext-pLine)] = 0;
        strncpy(tString, pLine, (int)(tNext-pLine));
        tRegion = new Region(tString);
        tNext++;
		delete[] tString;
    }
	if (size() < (size_t)tRegion->getID()+1)
	{
		resize(tRegion->getID()+1);
	}
	if ((*this)[tRegion->getID()])
	{
		delete tRegion;
	}
	else
	{
		(*this)[tRegion->getID()] = tRegion;
	}
    return tNext;
}

void Regions::readFrom(filebuf& pFile)
{
    char tHeaderLine[] = "ID	Name	Matrix";
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
                addRegion(tLine);
        }
        catch (MyException eE)
        {
            char tError[255];
            sprintf(tError, "On line %d", tLineNum);
            eE.addError(tError);
            throw eE;
        }
        tLineNum ++;
    }
    while (!tFile.eof() && strlen(tLine)>0);
}

std::ostream& operator<<(std::ostream& pStream, Regions& pHeaders)
{
    return pHeaders.output(pStream);
}

ConditionColumn::ConditionColumn()
{
    iRegionConditions = new ArrayList<Index>(1);
    iConditions = new ArrayList<Indexs>(1);
}

ConditionColumn::~ConditionColumn()
{
    int tSize = iRegionConditions->length();
    
    Index* tValue;
    for (int i = 0; i < tSize; i++)
    {
        tValue = iRegionConditions->remove(i);
        if (tValue !=NULL)
        {
            delete tValue;
        }
    }
    Indexs* tValue2;
    tSize = iConditions->length();
    for (int i = 0; i < tSize; i++)
    {
        tValue2 = iConditions->remove(i);
        if (tValue2!=NULL)
        {
            delete tValue2;
        }
    }
    delete iConditions;
    delete iRegionConditions;
}

void ConditionColumn::addRegion(signed char pIndex)
{
    iRegionConditions->add(new Index(pIndex));
}

void ConditionColumn::addCondition(signed char pIndex, int pRow)
{
    Indexs* tIndexs = iConditions->get(pRow);
    if (tIndexs==NULL)
    {
        iConditions->setWithAdd(new Indexs(pIndex), pRow);
    }
    else
    {
        tIndexs->addIndex(pIndex);
    }
}

void ConditionColumn::addEmptyCondition(int pRow)
{
    iConditions->setWithAdd(NULL, pRow);
}

void ConditionColumn::setRegion(char* pRegion)
{
    int tOffset = 0;
    const size_t tMatches = 3;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*3);
    while (!regexec(iFirstNumRE, pRegion+tOffset, tMatches, tMatch, 0))
    {
        int pIndex = strtol(pRegion+tOffset, NULL, 10);
        addRegion((signed char)pIndex);
        tOffset += (int)tMatch[0].rm_eo;
        bzero(tMatch, sizeof(regmatch_t)*3);
    }
}

int ConditionColumn::getRegion(const int pIndex)
{
    return iRegionConditions->get(pIndex)->get();
}

ArrayList<Index>* ConditionColumn::getRegions()
{
    return iRegionConditions;
}

int ConditionColumn::countRegions()
{
    return iRegionConditions->length();
}

int ConditionColumn::length()
{
    return iConditions->length();
}

Indexs* ConditionColumn::getConditions(int pIndex)
{
    return iConditions->get(pIndex);
}

std::ostream& ConditionColumn::output(std::ostream& pStream, Regions* pRegions, Conditions* pConditions)
{
    int tNumConditions = iConditions->length();
    int tNumHeader = iRegionConditions->length();
    
    for (int i = 0; i < tNumHeader; i++)
    {
        pStream << pRegions->getName(getRegion(i));
        if (i+1 != tNumHeader)
        {
            pStream << ", ";
        }
    }
    pStream << "\n\n";
    for (int i = 0; i <= tNumConditions; i++)
    {
        Indexs*  tConditions = iConditions->get(i);
        if (tConditions)
        {
            tConditions->output(pStream);
        }
        else
        {
            pStream << "-";
        }
        pStream << "\n";
    }
    return pStream;
}

Index::Index(signed char pValue):Number<signed char>(pValue)
{}
        
Index::Index(Index& pObject):Number<signed char>(pObject)
{}

signed char Index::get()
{
    return value();
}

std::ostream& Index::output(std::ostream& pStream)
{
    return pStream << (int)iValue;
}

std::ostream& operator<<(std::ostream& pStream, Index& pIndex)
{
    return pIndex.output(pStream);
}

Indexs::Indexs(signed char pIndex):vector<Index*>()
{
    push_back(new Index(pIndex));
}

void Indexs::addIndex(signed char pIndex)
{
    push_back(new Index(pIndex));
}

signed char Indexs::getValue(int pIndex)
{
    return (*this)[pIndex]->get();
}

Indexs::~Indexs()
{
	vector<Index*>::iterator tIter;
	
    for (tIter = begin(); tIter != end(); tIter++)
    {
        Index* tIndex = *tIter;
		if (tIndex)
			delete tIndex;
	}
}

std::ostream& Indexs::output(std::ostream& pStream)
{
    int tCount = size();
    char* tString = new char[tCount*2+3];
    tString[0] = '\0';
    for (int i = 0; i < tCount;  i++)
    {
        if (i+1==tCount)
        {
            sprintf(tString, "%s%d", tString, (*this)[i]->get());
        }
        else
        {
            sprintf(tString, "%s%d ", tString, (*this)[i]->get());
        }
    }
    pStream << tString;
    delete tString;
    return pStream;
}

std::ostream& operator<<(std::ostream& pStream, Indexs& pIndexs)
{
    return pIndexs.output(pStream);
}

Table::Table(char* pName, Regions* pRegions, Conditions* pConditions, int pNumColumns, int pNumPointGroups)
{
    iName = new char[strlen(pName)+1];	//Allocate enought space for the name
    strcpy(iName, pName);	//Copy the name into the classes storage
    String::upcase(iName);	//Make sure that the name is in upper case
    iRegions = pRegions;	//Keep a reference to the headers
    iConditions = pConditions;	//Keep a reference to the conditions
    iColumns = new ArrayList<ConditionColumn>(pNumColumns);	//Allocate the space for the condition columns of the table
    for (int i = 0; i < pNumColumns; i++)
    {
        iColumns->add(new ConditionColumn());	//Allocate and initalise the condition columns
    }
    iSGColumn = new ArrayList<SGColumn>(pNumPointGroups);  //Allocate the space for the space group columns of the table
    for (int i = 0; i < pNumPointGroups; i++)
    {
        iSGColumn->add(new SGColumn());	//Allocate and initalise the space group columns
    }
}
        
Table::~Table()
{
    delete[] iName;	//Release the space used by the name
    
    int tSize = iSGColumn->length();	//Find the number of space group columns
    for (int i = 0; i<tSize; i++)	//Go though each deallocating the memory which they use up
    {
        SGColumn* tGroups = iSGColumn->remove(i);
        if (tGroups)	//Make sure that there is some memory to be deallocated
        {
            delete tGroups;
        }
    }
    tSize = iColumns->length(); //Find the number of condition columns to be deallocated.
    for (int i = 0; i<tSize; i++) //Run though each condition column deallocating as you go.
    {
        ConditionColumn* tConditions = iColumns->remove(i); 
        if (tConditions)	//Make sure that there is some memory to be deallocated.
        {
            delete tConditions;
        }
    }
    delete iColumns;	//Deallocate the arrays which stored the columns
    delete iSGColumn;  //Deallocate the arrays which stored the columns
}

void Table::columnRegions(char* pRegions, int pColumn)
{
    const size_t tMatches = 4;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iFirstNSpRE, pRegions, tMatches, tMatch, 0))
    {
        return;
    }
    char* tString = new char[(int)(tMatch[1].rm_eo-tMatch[1].rm_so+1)];
    tString[(int)(tMatch[1].rm_eo-tMatch[1].rm_so)] = 0;
    strncpy(tString, pRegions+(int)tMatch[1].rm_so, (int)tMatch[1].rm_eo-tMatch[1].rm_so);	//get the first element on the line
    if (pColumn < iColumns->length())
    {
        iColumns->get(pColumn)->setRegion(tString);
    }
    else
    {
        int tSpaceGroupLen = pColumn-iColumns->length();
        
        if (iSGColumn->length()<=tSpaceGroupLen)
        {
            throw MyException(kUnknownException, "Table heading has bad format.");
        }
        iSGColumn->get(tSpaceGroupLen)->setPointGroup(tString);
    }
    delete[] tString;
    if (tMatch[2].rm_so==-1)
    {
        return;
    }
    columnRegions(pRegions+tMatch[3].rm_so, pColumn+1);
}

void Table::readColumnRegions(char* pRegions)
{
    columnRegions(pRegions, 0);
}

void Table::addLine(char* pLine, int pColumn)
{
    const size_t tMatches = 3;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iTableRE, pLine, tMatches, tMatch, 0))
    {
        return;
    }
    char* tString = new char[(int)(tMatch[1].rm_eo-tMatch[1].rm_so+1)];
    tString[(int)tMatch[1].rm_eo-tMatch[1].rm_so] = 0;
    strncpy(tString, pLine+(int)tMatch[1].rm_so, (int)tMatch[1].rm_eo-tMatch[1].rm_so);	//Get the first element in the line
    int pRow = iColumns->get(0)->length();	//Get the row which we are at.
    if (pColumn != 0)
    {
        pRow --;
    }
    if (pColumn < iColumns->length())
    {
        addCondition(tString, iColumns->get(pColumn), pRow);
    }
    else
    {
        addSpaceGroup(tString, iSGColumn->get(pColumn-iColumns->length()), pRow);
    }
    addLine(pLine+(int)tMatch[1].rm_eo , pColumn+1);
    delete tString;
}


void Table::addCondition(char* pCondition, ConditionColumn* pColumn, int pRow)
{
    char* tNextNumber;
    long tNumber = strtol(pCondition, &tNextNumber, 10);
    
    if (tNextNumber == pCondition)
    {
        if (pCondition[0] == '-')
        {
            pColumn->addEmptyCondition(pRow);
        }
        return;
    }
    pColumn->addCondition((signed char)tNumber, pRow);
    if (tNextNumber[0] == 0)
    {
        return;
    }
    addCondition(tNextNumber+1, pColumn, pRow);
}

void Table::addSpaceGroup(char* pSpaceGroup, SGColumn* pSGColumn, int pRow)
{
    pSGColumn->add(pSpaceGroup, pRow);
}
        
void Table::addLine(char* pLine)
{
    addLine(pLine, 0);
}

#include <ctype.h>

bool emptyLine(char* pLine)
{
    int i = 0;
    while (pLine[i] != 0)
    {
        if (!isspace(pLine[i]))
        {
            return false;
        }
    }
    return true;
}

char* Table::getName()
{
    return iName;
}

int Table::getNumPointGroups()
{
    return iSGColumn->length();
}

SpaceGroups* Table::getSpaceGroup(int pLineNum, int pPointGroupNum)
{
    SGColumn* tGroups = iSGColumn->get(pPointGroupNum);
    if (tGroups)
    {
            return tGroups->get(pLineNum);
    }
    return NULL;
}

ArrayList<Index>* Table::getRegions(int pI) const
{
    return iColumns->get(pI)->getRegions();
}
        
void Table::readFrom(filebuf& pFile)
{
    int tLineNum = 1;
    std::istream tFile(&pFile);
    char tLine[255];
    do
    {
        tFile.getline(tLine, 255);
        String::trim(tLine);
        tLineNum++;
    }while (!tFile.eof() && emptyLine(tLine));
    while (!tFile.eof() && strlen(tLine)>0)
    {
        try
        {
            addLine(tLine);
            tFile.getline(tLine, 255);
            String::trim(tLine);
            tLineNum++;
        }
        catch (MyException eE)
        {
            char tError[255];
            sprintf(tError, "On line %d", tLineNum);
            eE.addError(tError);
            throw eE;
        }
    }
}

std::ofstream& Table::outputLine(int pLineNum, std::ofstream& pStream)
{
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSGColumn->length();
    for (int i = 0; i < tLengthConditions; i++)
    {
        Indexs* tIndexs = iColumns->get(i)->getConditions(pLineNum);
        if (tIndexs == NULL)
        {
            pStream << "-\n";
        }
        else
        {
           pStream << *(tIndexs) << "\n";
        }
    }
    long tNumSGs = 0;
    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        SGColumn* tSGColumn = iSGColumn->get(i);
        SpaceGroups* tSpaceGroups = tSGColumn->get(pLineNum);
        tNumSGs += tSpaceGroups->count();
    }
    pStream << "SPACEGROUPS " << tNumSGs << "\n";

    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        SGColumn* tSGColumn = iSGColumn->get(i);
        SpaceGroups* tSpaceGroups = tSGColumn->get(pLineNum);
        if (tSpaceGroups->count() > 0)
            pStream << *(tSpaceGroups) << "\n";
    }
    return pStream;
}

std::ofstream& Table::outputLine(int pLineNum, std::ofstream& pStream, int tPointGroups[])
{
    int tLengthConditions = iColumns->length();
    for (int i = 0; i < tLengthConditions; i++)
    {
        Indexs* tIndexs = iColumns->get(i)->getConditions(pLineNum);
        if (tIndexs == NULL)
        {
            pStream << "-\n";
        }
        else
        {
           pStream << *(tIndexs) << "\n";
        }
    }
    long tNumSGs = 0;
    for (int i = 0; tPointGroups[i]!=-1; i++)
    {
        SGColumn* tSGColumn = iSGColumn->get(tPointGroups[i]);
        SpaceGroups* tSpaceGroups = tSGColumn->get(pLineNum);
        tNumSGs += tSpaceGroups->count();
    }
    pStream << "SPACEGROUPS " << tNumSGs << "\n";
    for (int i = 0; tPointGroups[i]!=-1; i++)
    {
        SGColumn* tSGColumn = iSGColumn->get(tPointGroups[i]);
        SpaceGroups* tSpaceGroups = tSGColumn->get(pLineNum);
        if (tSpaceGroups->count() > 0)
            pStream << *(tSpaceGroups) << "+ \n";
    }
    return pStream;
}

std::ostream& Table::outputLine(int pLineNum, std::ostream& pStream, int pColumnSize)
{
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSGColumn->length();
    for (int i = 0; i < tLengthConditions; i++)
    {
        Indexs* tIndexs = iColumns->get(i)->getConditions(pLineNum);
        if (tIndexs == NULL)
        {
            pStream << setw(pColumnSize) << "-" << " ";
        }
        else
        {
           pStream << setw(pColumnSize) << *(tIndexs) << " ";
        }
    }
    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        SGColumn* tSGColumn = iSGColumn->get(i);
        SpaceGroups* tSpaceGroup = tSGColumn->get(pLineNum);
        pStream << setw(pColumnSize) << *(tSpaceGroup) << " ";
    }
    pStream << "\n";
    return pStream;
}

std::ostream& Table::outputLine(int pLineNum, std::ostream& pStream, int tPointGroups[], int pColumnSize)
{
    int tLengthConditions = iColumns->length();
    for (int i = 0; i < tLengthConditions; i++)
    {
        Indexs* tIndexs = iColumns->get(i)->getConditions(pLineNum);
        if (tIndexs == NULL)
        {
            pStream << setw(pColumnSize) <<  "-";
        }
        else
        {
           pStream << setw(pColumnSize) << *(tIndexs);
        }
    }
    for (int i = 0; tPointGroups[i]!=-1; i++)
    {
        SGColumn* tSGColumn = iSGColumn->get(tPointGroups[i]);
        SpaceGroups* tSpaceGroup = tSGColumn->get(pLineNum);
        pStream << setw(pColumnSize) << *(tSpaceGroup) << " ";
    }
    pStream << "\n";
    return pStream;
}

std::ostream& Table::output(std::ostream& pStream)
{	
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSGColumn->length();
    
    pStream << iName << "\n";
    for (int i = 0; i < tLengthConditions; i++)
    {
        int tRegionNumber = iColumns->get(i)->countRegions();
        for (int j = 0; j < tRegionNumber; j ++)
        {
            pStream << iColumns->get(i)->getRegion(j) << "\t";
        }
    }
    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        pStream << iSGColumn->get(i)->getPointGroup() << "\t";
        pStream << "\t";
    }
    pStream << "\n";
    if (tLengthConditions > 0)
    {
        int tNumOfLines = iColumns->get(0)->length();
        for (int i =0; i < tNumOfLines; i++)
        {
            outputLine(i, pStream);
        }
    }
    return pStream;
}

Indexs* Table::getConditions(int pRow, int pColumn)
{
    ConditionColumn* tColumn = iColumns->get(pColumn);
    if (tColumn)
    {
        return tColumn->getConditions(pRow);
    }
    return NULL;
}

int Table::numberOfColumns()
{
    return iColumns->length();
}

int Table::numberOfRows()
{
    return iSGColumn->get(0)->length();
}

int Table::chiralPointGroups(int pPointGroupIndeces[])
{
	int tPointGroups = this->getNumPointGroups();
	int tIndecesPoint = 0;
	for (int i = 0; i< tPointGroups; i++)
	{
		char* tPointGroup = iSGColumn->get(i)->getPointGroup();
		//Is it a chiral point group
		if (tPointGroup != NULL && strchr(tPointGroup, '-')==NULL && strchr(tPointGroup, 'm')==NULL)
		{
			pPointGroupIndeces[tIndecesPoint] = i;
			tIndecesPoint++;
		}
	}
	pPointGroupIndeces[tIndecesPoint] = -1;
	return tIndecesPoint;
}

int Table::dataUsed(signed char pIndices[], const int pMax) const
{
    int tNumColumns = iColumns->length();
    TreeSet<signed char> tIndices;
    
    for (int i = 0; i < tNumColumns; i++)
    {
        ArrayList<Index>* tIndexs = iColumns->get(i)->getRegions();
        int tNumIndex = tIndexs->length();
        for (int j = 0; j < tNumIndex; j ++)
        {
            signed char tIndexValue = tIndexs->get(j)->get();
            tIndices.add(tIndexValue);
        }
    }
    Iterator<signed char>* tIterator = tIndices.createIterator();
    int j = 0;
    tIterator->reset();
    while (tIterator->hasNext() && j < pMax)
    {
        pIndices[j] = *tIterator->next();
        j++;
    }
    if (j < pMax)
    {
        pIndices[j] = -1;
    }
    delete tIterator;
    return j; 
}

int Table::conditionsUsed(signed char pIndices[], const int pMax) const
{
    int tNumColumns = iColumns->length();
    TreeSet<signed char> tIndices;
    
    for (int i = 0; i < tNumColumns; i++)
    {
        ConditionColumn* tColumn = iColumns->get(i);
        int tLength = tColumn->length();
        for (int j = 0; j < tLength; j++)
        {
            Indexs* tIndexs = tColumn->getConditions(j);
            if (tIndexs)
            {
                int tNumIndices = tIndexs->size();
                for (int k = 0; k < tNumIndices; k++)
                {
                    signed char tIndex = tIndexs->getValue(k);
                    tIndices.add(tIndex);
                }
            }
        }
    }
    Iterator<signed char>* tIterator = tIndices.createIterator();
    int j = 0;
    tIterator->reset();
    while (tIterator->hasNext() && j < pMax)
    {
        pIndices[j] = *tIterator->next();
        j++;
    }
    if (j < pMax)
    {
        pIndices[j] = -1;
    }
    delete tIterator;
    return j;
}

std::ostream& operator<<(std::ostream& pStream, Table& pTable)
{
    return pTable.output(pStream);
}

Tables::Tables(char* pFileName):map<char*, Table*, ltstr>()
{
    filebuf tFile;
    initCrysRegEx();
    if (tFile.open(pFileName, std::ios::in) == NULL)
    {
        throw FileException(errno);
    }
    iConditions = new Conditions();
    iRegions = new Regions();
    iRegions->readFrom(tFile);
    iConditions->readFrom(tFile);
    readFrom(tFile);
    tFile.close(); 
}
        
Tables::~Tables()
{	
	while (!empty())
	{
		Table* tTable = (*begin()).second;
		erase(begin());
        if (tTable)
        {
            delete tTable;
        }
	}
    delete iRegions;
    delete iConditions;
    deinitRE();
}

Regions* Tables::getRegions()
{
    return iRegions;
}

Conditions* Tables::getConditions()
{
    return iConditions;
}

void tableAttributesLine(char* pLine, char* pSystemName, int *pNumOfCondCols, int *pNumOfSGCols)
{
    const size_t tMatches = 4;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iTableArgsRE, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Table has bad format!");
    }
    *pNumOfCondCols = strtol(pLine+tMatch[2].rm_so, NULL, 10);
    *pNumOfSGCols = strtol(pLine+tMatch[3].rm_so, NULL, 10);
    pSystemName[(int)(tMatch[1].rm_eo-tMatch[1].rm_so)] = 0;
    strncpy(pSystemName, pLine+(int)tMatch[1].rm_so, (int)tMatch[1].rm_eo-tMatch[1].rm_so);
}

void Tables::readFrom(filebuf& pFile)
{
    std::istream tFile(&pFile);
    char tLine[255];
 
    while (!tFile.eof())
    {
        tFile.getline(tLine, 255);
        String::trim(tLine);
        if (!emptyLine(tLine))
        {
            char tSystemName[255]; // This it either monoclinic orthorombic etc. 
            int tNumOfCondCols, tNumOfSGCols;
            Table* tTable;
            
            try
            {
                tableAttributesLine(tLine, tSystemName, &tNumOfCondCols, &tNumOfSGCols);
                tTable = new Table(tSystemName, iRegions, iConditions, tNumOfCondCols, tNumOfSGCols); 
            }
            catch (MyException eE)
            {
                char tError[255];
                sprintf(tError, "In Table %s", tSystemName);
                eE.addError(tError);
                throw eE;
            }
            tFile.getline(tLine, 255);
            String::trim(tLine);
            if (!emptyLine(tLine))
            {
                try
                {
                    tTable->readColumnRegions(tLine);
                    tTable->readFrom(pFile);
                }
                catch (MyException eE)
                {
                    char tError[255];
                    sprintf(tError, "In Table %s", tSystemName);
                    eE.addError(tError);
                    throw eE;
                }
            }
            (*this)[tTable->getName()] = tTable;
        }
    }
}

/* Returns name which was found in pName*/
Table* Tables::findTable(char* pName)
{
    return (*this)[pName];
}

std::ostream& Tables::output(std::ostream& pStream)
{
	map<char*, Table*, ltstr>::iterator tIter;
	
    for (tIter = begin(); tIter != end(); tIter++)
    {
        Table* tTable = (*tIter).second;
        if (tTable)
        {
            pStream << *tTable;
        }
    }
    return pStream;
}

std::ostream& operator <<(std::ostream& pStream, Tables& pTables)
{
    return pTables.output(pStream);
};

bool hasChiralSpaceGroup(int pPGroupNumbers[], Table& pTable, int pRow)
{
    int i = 0;
    while (pPGroupNumbers[i] > -1)
    {
        SpaceGroups* tSpaceGroups = pTable.getSpaceGroup(pRow, pPGroupNumbers[i]);
        if (tSpaceGroups->count() == 0)
        {
            return false;
        }
        i++;
    }
    return true;
}

RankedSpaceGroups::RankedSpaceGroups(Table& pTable, Stats& pStats, bool pChiral):iChiral(pChiral)
{	
    int* tPGroupNumbers =  NULL;
   
    if (iChiral)  	//If this is a chiral structure then get the information for filtering the list.
    {
        const int tPGroupNumber = pTable.getNumPointGroups();
        tPGroupNumbers = new int[tPGroupNumber+1];	//The end of this list is identifed by an index of -1
        pTable.chiralPointGroups(tPGroupNumbers);
    }
    int tCount = pTable.numberOfRows();
    for (int i = 0; i < tCount; i++)
    {
        if (!iChiral)
        {
            RowRating iRating(i, pTable, pStats);
            addToList(iRating);	//Add the rating for the current row into the order list of rows.
        }
        else if(hasChiralSpaceGroup(tPGroupNumbers, pTable, i))
        {
            RowRating iRating(i, pTable, pStats);
            addToList(iRating);	//Add the rating for the current row into the order list of rows.
        }
    }
    iTable = &pTable;
    delete tPGroupNumbers;
}

RankedSpaceGroups::RowRating::RowRating(int pRow, Table& pTable, Stats& pStats):Float(0)
{
    int tCount = pTable.numberOfColumns(); 
    
    iRowNum = pRow;
    iTotNumVal = 0;
    iSumRat1 = 0;
    iSumRat2 = 0;
    iSumSqrRat1 = 0;
    iSumSqrRat2 = 0;
    iFiltered = false;
    
    for (int i = 0; i < tCount; i++)
    {
        ArrayList<Index>* tRegions = pTable.getRegions(i);
        int tHCount = tRegions->length();
        for (int j =0; j < tHCount; j++)
        {
            Indexs* tIndexs = pTable.getConditions(pRow, i);
            addConditionRatings(pStats, tIndexs, tRegions->get(j));
        }
    }
    iValue = (iSumRat1+iSumRat2)/(2*iTotNumVal);
    iValue += iFiltered?1:0;
}

void RankedSpaceGroups::RowRating::addConditionRatings(Stats& pStats, Indexs* tIndexs, Index* pRegionIndex)
{
    if (tIndexs)
    {
        int tCount = tIndexs->size();
        for (int i = 0; i < tCount; i++)
        {
            int tRow = tIndexs->getValue(i);
            const ElemStats* tElement = pStats.getElem(pRegionIndex->get(), tRow);
            addRating(tElement);
        }
    }
    else
    {
        iTotNumVal++;
    }
}

void RankedSpaceGroups::RowRating::addRating(const ElemStats* pStats)
{
    iTotNumVal++;
    iSumRat1 += pStats->tRating1;
    iSumRat2 += pStats->tRating2;
    iSumSqrRat1 += sqr(pStats->tRating1);
    iSumSqrRat2 += sqr(pStats->tRating2);
    iFiltered |= pStats->iFiltered ;
}

RankedSpaceGroups::RowRating& RankedSpaceGroups::RowRating::operator=(const RowRating& pRowRating)
{
    (Float)(*this) = (Float)pRowRating;
    iRowNum = pRowRating.iRowNum;
    iTotNumVal = pRowRating.iTotNumVal;
    iSumRat1 = pRowRating.iSumRat1;
    iSumRat2 = pRowRating.iSumRat2;
    iSumSqrRat1 = pRowRating.iSumSqrRat1;
    iSumSqrRat2 = pRowRating.iSumSqrRat2;
    iFiltered = pRowRating.iFiltered;
    return *this;
}

void RankedSpaceGroups::addToList(RowRating& pRating)
{
    iSortedRatings.add(pRating);
}

std::ofstream& RankedSpaceGroups::output(std::ofstream& pStream)	//Used when outputing the ranked space groups to a file.
{
    Iterator<RowRating>* tRatingIter = iSortedRatings.createIterator();
    RowRating* tCurrentRating;
        
    pStream << "RESULTS " << iSortedRatings.count() << "\n";
    const int tPNum = iTable->getNumPointGroups();
    int* tPointGroups = new int[tPNum];
    
    if (iChiral)
    {
        iTable->chiralPointGroups(tPointGroups);
    }
    tRatingIter->reset();
    while ((tCurrentRating = tRatingIter->next()) != NULL)
    {
        pStream << "SCORE " << tCurrentRating->value() << "\n";
        pStream << "PROMOTED ";
        if (tCurrentRating->iFiltered)
            pStream << "YES\n";
        else
            pStream << "NO\n";
        if (iChiral)
            iTable->outputLine(tCurrentRating->iRowNum, pStream, tPointGroups);
        else
            iTable->outputLine(tCurrentRating->iRowNum, pStream);
    }
    delete tRatingIter;
    delete tPointGroups;
    return pStream;
}

std::ostream& RankedSpaceGroups::output(std::ostream& pStream)
{
    Iterator<RowRating>* tRatingIter = iSortedRatings.createIterator();
    RowRating* tCurrentRating;
    const int tPNum = iTable->getNumPointGroups();
    int* tPointGroups = new int[tPNum];
    
    if (iChiral)
    {
        iTable->chiralPointGroups(tPointGroups);
    }
    pStream << "A '*' indicates that the row has been promoted because it seems that the data has been previously filtered for the centering.\n\n";
     
    tRatingIter->reset();
    while ((tCurrentRating = tRatingIter->next()) != NULL)
    {
        pStream << setw(3) << tCurrentRating->iRowNum << " " << setprecision(4) << setw(9) << tCurrentRating->value() << " ";
        if (tCurrentRating->iFiltered)
            pStream << " * ";
        else
            pStream << " + ";
        if (iChiral)
            iTable->outputLine(tCurrentRating->iRowNum, pStream, tPointGroups);	//Output only set point group list.
        else
            iTable->outputLine(tCurrentRating->iRowNum, pStream);
    }
    delete tRatingIter;
    delete tPointGroups;
    return pStream;
}

std::ostream& operator<<(std::ostream& pStream, RankedSpaceGroups& pRank)
{
    return pRank.output(pStream);
}

std::ofstream& operator<<(std::ofstream& pStream, RankedSpaceGroups& pRank)
{
    return pRank.output(pStream);
}

/*class CrystalSystem
{
	protected:
		CrystalSystemID iID;
		string iName;
		list<LaueGroups*> iLaueGroups;
		Table* iTables;
	public:
		CrystalSystem::CrystalSystem(Table* pTable,   
		bool CrystalSystem::contains(LaueGroup* )
		{
			
		}
};

class CrystalSystems:protected list<CrystalSystem*>
{
	public:
		CrystalSystems(char* pFileName);
		static CrystalSystems* defaultObject();
		CrystalSystem* crystalSystemForLaueGroup(LaueGroup*);
};*/

