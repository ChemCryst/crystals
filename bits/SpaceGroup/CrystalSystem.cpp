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
#include <iomanip>
#include "Stats.h"

using namespace std;

static regex_t* iHeaderRE  =NULL;
static regex_t* iCondRE  =NULL;
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
        char tCondRE[] = "^([[:digit:]]+)\t(([[:alnum:]]|[- =+])+)\t(\\[( *([-+]?[[:digit:]]+(\\.[[:digit:]]+)?) *(;)?)*( *([-+]?[[:digit:]]+(\\.[[:digit:]]+)?) *)\\])\t([[:digit:]]+)[[:space:]]*$";
            //Checks the formoat of a line in the conditons list is the conrrect format.
        char tFirstNumRE[] = "([[:digit:]]),?[[:space:]]?"; 
            //Takes the first number of a , delimited list of numbers.
        char tFirstNSpRE[] = "([^\t]+)(\t([^\t].+))?";	
            //Takes the first non-space part of the heading line and returns the point of it in $1
        char tTableRE[] = "([^\t]+)(\t[^\t].*)?";
            //Gets the first non-tab part of the line and returns its placing in $1.
        char tTableArgsRE[] = "([^\t]+)\t([[:digit:]]+), ([[:digit:]]+)";
            //The header line of the table. This contains the name of the system and the number of condition columns and the number of point group columns.
        iHeaderRE  = new regex_t;
        iCondRE  = new regex_t;
        iFirstNumRE  = new regex_t;
        iFirstNSpRE  = new regex_t;
        iTableRE  = new regex_t;
        iTableArgsRE = new regex_t;
        regcomp(iHeaderRE, tHeaderRE, REG_EXTENDED);
        regcomp(iCondRE, tCondRE, REG_EXTENDED);
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
        delete iCondRE;
        delete iFirstNumRE;
        delete iFirstNSpRE;
        delete iTableRE;
        delete iTableArgsRE;
        iHeaderRE = NULL;
        iCondRE = NULL;
        iFirstNumRE = NULL;
        iFirstNSpRE = NULL;
        iTableRE = NULL;
        iTableArgsRE = NULL;
    }
}

Heading::Heading(char* pLine)
{
    const size_t tMatches = 4;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iHeaderRE, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Heading had an invalid format!");
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
    iMatrix = new MatrixReader(tTempString);
    delete[] tTempString;
}

Heading::~Heading()
{
    delete[] iName;
    delete iMatrix;
}


char* Heading::getName()
{
    return iName;
}

Matrix<float>* Heading::getMatrix()
{
    return iMatrix;
}
  
int Heading::getID()
{
    return iID;
}

std::ostream& Heading::output(std::ostream& pStream)
{
    pStream << iID << "\t" << iName << "\t" << *iMatrix << "\n";
    return pStream;
}

std::ostream& operator<<(std::ostream& pStream, Heading& pHeader)
{
    return pHeader.output(pStream);
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
    delete[] iName;
    delete iMatrix;
}

char* Condition::getName()
{
    return iName;
}

Matrix<float>* Condition::getMatrix()
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

Matrix<float>* Conditions::getMatrix(int pIndex)
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


Headings::Headings()
{
    iHeadings = new ArrayList<Heading>(1);
}

Headings::~Headings()
{
    int iSize = iHeadings->length();
    for (int i = 0; i < iSize; i++)
    {
        Heading* tHeading = iHeadings->remove(i);
        delete tHeading;
    }
    delete iHeadings;
}

int Headings::length()
{
    return iHeadings->length();
}

Matrix<float>* Headings::getMatrix(int pIndex)
{
    Heading* tHeading = iHeadings->get(pIndex);
    
    if (!tHeading)
    {
        throw MyException(kUnknownException, "Heading with that ID doesn't exist.");
    }
    return tHeading->getMatrix();
}

char* Headings::getName(int pIndex)
{
    Heading* tHeading = iHeadings->get(pIndex);
    
    if (!tHeading)
    {
        throw MyException(kUnknownException, "Heading with that ID doesn't exist.");
    }
    return tHeading->getName();
}

int Headings::getID(int pIndex)
{
    Heading* tHeading = iHeadings->get(pIndex);
    
    if (!tHeading)
    {
        throw MyException(kUnknownException, "Heading with that ID doesn't exist.");
    }
    return tHeading->getID();
}

std::ostream& Headings::output(std::ostream& pStream)
{
    int tSize = iHeadings->length();
    for (int i = 0; i < tSize; i++)
    {
        Heading* tHeading = iHeadings->get(i);
        if (tHeading)
        {
            std::cout << *tHeading << "\n";
        }
        else
        {
            std::cout << "null\n";
        }
    }
    return pStream;
}

char* Headings::addHeading(char* pLine)	//Returns the point which the line at the start of this string finishs
{
    char* tNext = strchr(pLine, '\n');
    Heading* tHeading = NULL;
    if (tNext == NULL)
    {
        tHeading = new Heading(pLine);
    }
    else
    {
        char *tString = new char[(int)(tNext-pLine)+1];
        tString[(int)(tNext-pLine)] = 0;
        strncpy(tString, pLine, (int)(tNext-pLine));
        tHeading = new Heading(tString);
        tNext++;
		delete[] tString;
    }
    iHeadings->setWithAdd(tHeading, tHeading->getID());
    return tNext;
}

void Headings::readFrom(filebuf& pFile)
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
                    addHeading(tLine);
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

std::ostream& operator<<(std::ostream& pStream, Headings& pHeaders)
{
    return pHeaders.output(pStream);
}

Index::Index(signed char pValue)
{
    iValue = pValue;
}
        
Index::Index(Index& pObject)
{
    *this = pObject;
}

signed char Index::get()
{
    return iValue;
}

void Index::set(signed char pValue)
{
    iValue = pValue;
}

Index& Index::operator=(Index& pObject)
{
    iValue = pObject.iValue;
    return *this;
}

bool Index::operator<(Index& pObject)
{
    return iValue < pObject.iValue;
}

bool Index::operator>(Index& pObject)
{
    return iValue > pObject.iValue;
}

bool Index::operator==(Index& pObject)
{
    return iValue == pObject.iValue;
}

std::ostream& Index::output(std::ostream& pStream)
{
    return pStream << (int)iValue;
}

std::ostream& operator<<(std::ostream& pStream, Index& pIndex)
{
    return pIndex.output(pStream);
}

Indexs::Indexs(signed char pIndex)
{
    iIndexs = new ArrayList<Index>(1);
    iIndexs->add(new Index(pIndex));
}

void Indexs::addIndex(signed char pIndex)
{
    iIndexs->add(new Index(pIndex));
}

int Indexs::number()
{
    return iIndexs->length();
}

Index* Indexs::getIndex(int pIndex)
{
    return iIndexs->get(pIndex);
}

signed char Indexs::getValue(int pIndex)
{
    return iIndexs->get(pIndex)->get();
}

Indexs::~Indexs()
{
    int tCount = iIndexs->length();
    for (int i = 0; i < tCount;  i++)
    {
        Index* tTemp = iIndexs->remove(i);
        if (tTemp)
        {
            delete tTemp;
        }
    }
    delete iIndexs;
}

std::ostream& Indexs::output(std::ostream& pStream)
{
    int tCount = iIndexs->length();
    char* tString = new char[tCount*2+3];
    tString[0] = '\0';
    for (int i = 0; i < tCount;  i++)
    {
        if (i+1==tCount)
        {
            sprintf(tString, "%s%d", tString, iIndexs->get(i)->get());
        }
        else
        {
            sprintf(tString, "%s%d ", tString, iIndexs->get(i)->get());
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
        
ConditionColumn::ConditionColumn()
{
    iHeadingConditions = new ArrayList<Index>(1);
    iConditions = new ArrayList<Indexs>(1);
}

ConditionColumn::~ConditionColumn()
{
    int tSize = iHeadingConditions->length();
    
    Index* tValue;
    for (int i = 0; i < tSize; i++)
    {
        tValue = iHeadingConditions->remove(i);
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
    delete iHeadingConditions;
}

void ConditionColumn::addHeading(signed char pIndex)
{
    iHeadingConditions->add(new Index(pIndex));
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

void ConditionColumn::setHeading(char* pHeading)
{
    int tOffset = 0;
    const size_t tMatches = 3;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*3);
    while (!regexec(iFirstNumRE, pHeading+tOffset, tMatches, tMatch, 0))
    {
        int pIndex = strtol(pHeading+tOffset, NULL, 10);
        addHeading((signed char)pIndex);
        tOffset += (int)tMatch[0].rm_eo;
        bzero(tMatch, sizeof(regmatch_t)*3);
    }
}

int ConditionColumn::getHeading(const int pIndex)
{
    return iHeadingConditions->get(pIndex)->get();
}

ArrayList<Index>* ConditionColumn::getHeadings()
{
    return iHeadingConditions;
}

int ConditionColumn::countHeadings()
{
    return iHeadingConditions->length();
}

int ConditionColumn::length()
{
    return iConditions->length();
}

Indexs* ConditionColumn::getConditions(int pIndex)
{
    return iConditions->get(pIndex);
}

std::ostream& ConditionColumn::output(std::ostream& pStream, Headings* pHeadings, Conditions* pConditions)
{
    int tNumConditions = iConditions->length();
    int tNumHeader = iHeadingConditions->length();
    
    for (int i = 0; i < tNumHeader; i++)
    {
        pStream << pHeadings->getName(getHeading(i));
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

SpaceGroups::SpaceGroups()
{
    iPointGroup = NULL;
    iSpaceGroups = new ArrayList<SpaceGroup>(1);
}

SpaceGroups::~SpaceGroups()
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

void SpaceGroups::add(char* pSpaceGroup,  int pRow)
{
    iSpaceGroups->setWithAdd(new SpaceGroup(pSpaceGroup), pRow);
}

SpaceGroup* SpaceGroups::get(int pIndex)
{
    return iSpaceGroups->get(pIndex);
}

int SpaceGroups::length()
{
    return iSpaceGroups->length();
}

void SpaceGroups::setHeading(char* pHeading)
{
    if (iPointGroup)
    {
        delete[] iPointGroup;
    }
    iPointGroup = new char[strlen(pHeading)+1];
    strcpy(iPointGroup, pHeading);
}

char* SpaceGroups::getPointGroup()
{
    return iPointGroup;
}

Table::Table(char* pName, Headings* pHeadings, Conditions* pConditions, int pNumColumns, int pNumPointGroups)
{
    iName = new char[strlen(pName)+1];	//Allocate enought space for the name
    strcpy(iName, pName);	//Copy the name into the classes storage
    String::upcase(iName);		//Make sure that the name is in upper case
    iHeadings = pHeadings;	//Keep a reference to the headers
    iConditions = pConditions;	//Keep a reference to the conditions
    iColumns = new ArrayList<ConditionColumn>(pNumColumns);	//Allocate the space for the condition columns of the table
    for (int i = 0; i < pNumColumns; i++)
    {
        iColumns->add(new ConditionColumn());	//Allocate and initalise the condition columns
    }
    iSpaceGroups = new ArrayList<SpaceGroups>(pNumPointGroups);  //Allocate the space for the space group columns of the table
    for (int i = 0; i < pNumPointGroups; i++)
    {
        iSpaceGroups->add(new SpaceGroups());	//Allocate and initalise the space group columns
    }
}
        
Table::~Table()
{
    delete[] iName;	//Release the space used by the name
    
    int tSize = iSpaceGroups->length();	//Find the number of space group columns
    for (int i = 0; i<tSize; i++)	//Go though each deallocating the memory which they use up
    {
        SpaceGroups* tGroups = iSpaceGroups->remove(i);
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
    delete iSpaceGroups;  //Deallocate the arrays which stored the columns
}

void Table::columnHeadings(char* pHeadings, int pColumn)
{
    const size_t tMatches = 4;
    regmatch_t tMatch[tMatches];
    
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iFirstNSpRE, pHeadings, tMatches, tMatch, 0))
    {
        return;
    }
    char* tString = new char[(int)(tMatch[1].rm_eo-tMatch[1].rm_so+1)];
    tString[(int)(tMatch[1].rm_eo-tMatch[1].rm_so)] = 0;
    strncpy(tString, pHeadings+(int)tMatch[1].rm_so, (int)tMatch[1].rm_eo-tMatch[1].rm_so);	//get the first element on the line
    if (pColumn < iColumns->length())
    {
        iColumns->get(pColumn)->setHeading(tString);
    }
    else
    {
        int tSpaceGroupLen = pColumn-iColumns->length();
        
        if (iSpaceGroups->length()<=tSpaceGroupLen)
        {
            throw MyException(kUnknownException, "Table heading has bad format.");
        }
        iSpaceGroups->get(tSpaceGroupLen)->setHeading(tString);
    }
    delete[] tString;
    if (tMatch[2].rm_so==-1)
    {
        return;
    }
    columnHeadings(pHeadings+tMatch[3].rm_so, pColumn+1);
}

void Table::readColumnHeadings(char* pHeadings)
{
    columnHeadings(pHeadings, 0);
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
        addSpaceGroup(tString, iSpaceGroups->get(pColumn-iColumns->length()), pRow);
    }
    addLine(pLine+(int)tMatch[1].rm_eo , pColumn+1);
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

void Table::addSpaceGroup(char* pSpaceGroup, SpaceGroups* pSpaceGroups, int pRow)
{
    pSpaceGroups->add(pSpaceGroup, pRow);
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
    return iSpaceGroups->length();
}

SpaceGroup* Table::getSpaceGroup(int pLineNum, int pPointGroupNum)
{
    SpaceGroups* tGroups = iSpaceGroups->get(pPointGroupNum);
    if (tGroups)
    {
            return tGroups->get(pLineNum);
    }
    return NULL;
}

ArrayList<Index>* Table::getHeadings(int pI)
{
    return iColumns->get(pI)->getHeadings();
}
        
void Table::readFrom(filebuf& pFile)
{
	std::istream tFile(&pFile);
    char tLine[255];
    do
    {
        tFile.getline(tLine, 255);
        String::trim(tLine);
    }while (!tFile.eof() && emptyLine(tLine));
    while (!tFile.eof() && strlen(tLine)>0)
    {
        addLine(tLine);
        tFile.getline(tLine, 255);
        String::trim(tLine);
    }
}

std::ofstream& Table::outputLine(int pLineNum, std::ofstream& pStream)
{
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSpaceGroups->length();
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
    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        SpaceGroups* tSpaceGroups = iSpaceGroups->get(i);
        SpaceGroup* tSpaceGroup = tSpaceGroups->get(pLineNum);
        pStream << *(tSpaceGroup) << "\n";
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
    for (int i = 0; tPointGroups[i]!=-1; i++)
    {
        SpaceGroups* tSpaceGroups = iSpaceGroups->get(tPointGroups[i]);
        SpaceGroup* tSpaceGroup = tSpaceGroups->get(pLineNum);
        pStream << *(tSpaceGroup) << "\n";
    }
    return pStream;
}

std::ostream& Table::outputLine(int pLineNum, std::ostream& pStream, int pColumnSize)
{
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSpaceGroups->length();
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
        SpaceGroups* tSpaceGroups = iSpaceGroups->get(i);
        SpaceGroup* tSpaceGroup = tSpaceGroups->get(pLineNum);
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
        SpaceGroups* tSpaceGroups = iSpaceGroups->get(tPointGroups[i]);
        SpaceGroup* tSpaceGroup = tSpaceGroups->get(pLineNum);
        pStream << setw(pColumnSize) << *(tSpaceGroup) << " ";
    }
    pStream << "\n";
    return pStream;
}

std::ostream& Table::output(std::ostream& pStream)
{	
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSpaceGroups->length();
    
    pStream << iName << "\n";
    for (int i = 0; i < tLengthConditions; i++)
    {
        int tHeadingNumber = iColumns->get(i)->countHeadings();
        for (int j = 0; j < tHeadingNumber; j ++)
        {
            pStream << iColumns->get(i)->getHeading(j) << "\t";
        }
    }
    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        pStream << iSpaceGroups->get(i)->getPointGroup() << "\t";
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
    return iSpaceGroups->get(0)->length();
}

int Table::chiralPointGroups(int pPointGroupIndeces[])
{
	int tPointGroups = this->getNumPointGroups();
	int tIndecesPoint = 0;
	for (int i = 0; i< tPointGroups; i++)
	{
		char* tPointGroup = iSpaceGroups->get(i)->getPointGroup();
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

int Table::dataUsed(signed char pIndices[], int pMax)
{
    int tNumColumns = iColumns->length();
    TreeSet<signed char> tIndices;
    
    for (int i = 0; i < tNumColumns; i++)
    {
        ArrayList<Index>* tIndexs = iColumns->get(i)->getHeadings();
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

int Table::conditionsUsed(signed char pIndices[], int pMax)
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
                int tNumIndices = tIndexs->number();
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

Tables::Tables(char* pFileName)
{
    filebuf tFile;
    initCrysRegEx();
    if (tFile.open(pFileName, std::ios::in) == NULL)
    {
        throw FileException(errno);
    }
    iConditions = new Conditions();
    iHeadings = new Headings();
    iHeadings->readFrom(tFile);
    iConditions->readFrom(tFile);
    iTables = new ArrayList<Table>(1);
    readFrom(tFile);
    tFile.close(); 
}
        
Tables::~Tables()
{
    int tNumTables = iTables->length();
    
    for (int i = 0; i < tNumTables; i++)
    {
        Table* tTable = iTables->remove(i);
        if (tTable)
        {
            delete tTable;
        }
    }
    delete iHeadings;
    delete iConditions;
    delete iTables;
    deinitRE();
}

Headings* Tables::getHeadings()
{
    return iHeadings;
}

Conditions* Tables::getConditions()
{
    return iConditions;
}

void Tables::addTable(Table* pTable)
{
	iTables->add(pTable);
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
                tTable = new Table(tSystemName, iHeadings, iConditions, tNumOfCondCols, tNumOfSGCols); 
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
                    tTable->readColumnHeadings(tLine);
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
            addTable(tTable);
        }
    }
}

/* Returns name which was found in pName*/
Table* Tables::findTable(char* pName)
{
    int tNumber = iTables->length();
    Table* tTable; 
    bool tFound = false;
    
    for (int i = 0; i < tNumber; i++)
    {
        tTable = iTables->get(i);
        if (tTable)
        {
            char* tName = tTable->getName();
            String::upcase(pName);
            if (strcmp(pName, tName) == 0)
            {
                tFound = true;
                break;
            }
        }	
    }
    if (tFound == false)
    {
        pName[0] = 0;
        return NULL;
    }
    return tTable;
}

std::ostream& Tables::output(std::ostream& pStream)
{
    int tNumTables = iTables->length();
    
    for (int i = 0; i < tNumTables; i++)
    {
        Table* tTable = iTables->get(i);
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

void RankedSpaceGroups::calcRowRating(RowRating* pRatings, int pRow, Table& pTable, Stats& pStats)
{
    int tCount = pTable.numberOfColumns(); 
    
    for (int i = 0; i < tCount; i++)
    {
        ArrayList<Index>* tHeadings = pTable.getHeadings(i);
        int tHCount = tHeadings->length();
        for (int j =0; j < tHCount; j++)
        {
            Indexs* tIndexs = pTable.getConditions(pRow, i);
            addConditionRatings(pRatings, pStats, tIndexs, tHeadings->get(j));
        }
    }
}

void RankedSpaceGroups::addConditionRatings(RowRating* pRating, Stats& pStats, Indexs* tIndexs, Index* pHeadingIndex)
{
    if (tIndexs)
    {
        int tCount = tIndexs->number();
        for (int i = 0; i < tCount; i++)
        {
            int tRow = tIndexs->getValue(i);
            const ElemStats* tElement = pStats.getElem(pHeadingIndex->get(), tRow);
            addRating(pRating, tElement);
        }
    }
    else
    {
        pRating->iTotNumVal++;
    }
}

void RankedSpaceGroups::addRating(RowRating* pRating, const ElemStats* pStats)
{
    pRating->iTotNumVal++;
    pRating->iSumRat1 += pStats->tRating1;
    pRating->iSumRat2 += pStats->tRating2;
    pRating->iSumSqrRat1 += sqr(pStats->tRating1);
    pRating->iSumSqrRat2 += sqr(pStats->tRating2);
    pRating->iFiltered |= pStats->iFiltered ;
}

bool hasChiralSpaceGroup(int pPGroupNumbers[], Table& pTable, int pRow)
{
    int i = 0;
    while (pPGroupNumbers[i] > -1)
    {
        SpaceGroup* tSpaceGroup = pTable.getSpaceGroup(pRow, pPGroupNumbers[i]);
        String tSymbol(tSpaceGroup->getSymbol());
        tSymbol.trim();
        if (tSymbol.cmp("-") != 0)
        {
            return true;
        }
        i++;
    }
    return false;
}

RankedSpaceGroups::RankedSpaceGroups(Table& pTable, Stats& pStats, bool pChiral)	//Chiral still needs handling. Needs doing
{
    iRatings = new RowRating[pTable.numberOfRows()];		//Allocate space for all the ratings.s
    const int tPGroupNumber = pTable.getNumPointGroups();
    int* tPGroupNumbers = new int[tPGroupNumber+1];	//The end of this list is identifed by an index of -1
    iChiral = pChiral;
    
    pTable.chiralPointGroups(tPGroupNumbers);
    int tCount = pTable.numberOfRows();
    for (int i = 0; i < tCount; i++)
    {
        if (!iChiral || (pChiral && hasChiralSpaceGroup(tPGroupNumbers, pTable, i)))
        {
		iRatings[i].iRowNum = i;
		iRatings[i].iTotNumVal = 0;
		iRatings[i].iSumRat1 = 0;
		iRatings[i].iSumRat2 = 0;
		iRatings[i].iSumSqrRat1 = 0;
		iRatings[i].iSumSqrRat2 = 0;
		iRatings[i].iMean= 0;
                iRatings[i].iFiltered = false;
		calcRowRating(&(iRatings[i]), i, pTable, pStats);
                addToList(&(iRatings[i]));	//Add the rating for the current row into the order list of rows.
        }
    }
    iTable = &pTable;
	delete tPGroupNumbers;
}

void RankedSpaceGroups::addToList(RowRating* pRating)
{
    RowRating* tCurrentRat;
    int tCounter = 0;
        
    iRatingList.reset();
    pRating->iMean = (pRating->iSumRat1+pRating->iSumRat2)/(2*pRating->iTotNumVal);
    if (pRating->iFiltered)
    {
        pRating->iMean += 1;	//If we think that this has been filtered then we try and move it to the top
    }
    tCurrentRat = iRatingList.next();
    while (tCurrentRat != NULL && tCurrentRat->iMean > pRating->iMean)
    {
        tCurrentRat = iRatingList.next();
        tCounter++;
    }
    iRatingList.insert(pRating, tCounter);
}

RankedSpaceGroups::~RankedSpaceGroups()
{
    delete[] iRatings;
}

std::ofstream& RankedSpaceGroups::output(std::ofstream& pStream)	//Used when outputing the ranked space groups to a file.
{
    pStream << "RESULTS " << iRatingList.count() << "\n";
    RowRating* tCurrentRating;
    const int tPNum = iTable->getNumPointGroups();
    int* tPointGroups = new int[tPNum];
    
    if (iChiral)
    {
        iTable->chiralPointGroups(tPointGroups);
    }
    iRatingList.reset();
    while ((tCurrentRating = iRatingList.next()) != NULL)
    {
        pStream << tCurrentRating->iMean << "\n";
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
    delete tPointGroups;
    return pStream;
}

std::ostream& RankedSpaceGroups::output(std::ostream& pStream)
{
    RowRating* tCurrentRating;
    const int tPNum = iTable->getNumPointGroups();
    int* tPointGroups = new int[tPNum];
    
    if (iChiral)
    {
        iTable->chiralPointGroups(tPointGroups);
    }
    pStream << "A '*' indicates that the row has been promoted because it seems that the data has been previously filtered for the centering.\n\n";
     
    iRatingList.reset();
    while ((tCurrentRating = iRatingList.next()) != NULL)
    {
        pStream << setw(3) << tCurrentRating->iRowNum << " " << setprecision(4) << setw(9) << tCurrentRating->iMean << " ";
        if (tCurrentRating->iFiltered)
            pStream << " * ";
        else
            pStream << " + ";
        if (iChiral)
            iTable->outputLine(tCurrentRating->iRowNum, pStream, tPointGroups);	//Output only set point group list.
        else
            iTable->outputLine(tCurrentRating->iRowNum, pStream);
    }
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