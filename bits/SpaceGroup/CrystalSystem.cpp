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

#include "CrystalSystem.h"
#include "regex.h"

Heading::Heading(char* pLine)
{
    char tRegExp[] = "^([[:digit:]]+)\t([hkl0-]{3}[hkl0-]?)\t(\\[[0123456789;. -]+\\])[[:space:]]*$";//This is to check that the line is in the correct format excluding the format of the matrix i self.

    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 4;
    regmatch_t tMatch[4];
    
    bzero(tMatch, sizeof(regmatch_t)*4);
    if (regexec(&tRegEx, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Heading had an invalid format!");
    }
    iName = new char[tMatch[2].rm_eo - tMatch[2].rm_so +1];
    iName[tMatch[2].rm_eo - tMatch[2].rm_so] = 0;
    strncpy(iName, tMatch[2].rm_so+pLine, tMatch[2].rm_eo - tMatch[2].rm_so);
    char* tTempString = new char[tMatch[1].rm_eo - tMatch[1].rm_so +1];
    strncpy(tTempString, tMatch[1].rm_so+pLine, tMatch[1].rm_eo - tMatch[1].rm_so);
    tTempString[tMatch[1].rm_eo - tMatch[1].rm_so] = 0;
    iID = strtol(tTempString, NULL, 10);
    delete[] tTempString;
    tTempString = new char[tMatch[3].rm_eo - tMatch[3].rm_so +1];
    strncpy(tTempString, tMatch[3].rm_so+pLine, tMatch[3].rm_eo - tMatch[3].rm_so);
    tTempString[tMatch[3].rm_eo - tMatch[3].rm_so] = 0;
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

ostream& Heading::output(ostream& pStream)
{
    pStream << iID << "\t" << iName << "\t" << *iMatrix << "\n";
    return pStream;
}

ostream& operator<<(ostream& pStream, Heading& pHeader)
{
    return pHeader.output(pStream);
}

Condition::Condition(char* pLine)
{
    char tRegExp[] = "^([[:digit:]]+)\t(([[:alnum:]]|[ =+-])+)\t(\\[( *([[:digit:]]+(\\.[[:digit:]]+)?) *(;)?)*( *([[:digit:]]+(\\.[[:digit:]]+)?) *)\\])\t([[:digit:]]+)[[:space:]]*$";//This checks to see if the line is in the correct format and get the offsets for all the needed information.
    
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
    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 15;
    regmatch_t tMatch[15];
    
    bzero(tMatch, sizeof(regmatch_t)*15);
    if (regexec(&tRegEx, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Condition had an invalid format!");
    }
    char* tString = new char[tMatch[4].rm_eo-tMatch[4].rm_so+1];	//Get the matrix for the condition
    tString[tMatch[4].rm_eo-tMatch[4].rm_so] = 0;
    strncpy(tString, pLine+tMatch[4].rm_so, tMatch[4].rm_eo-tMatch[4].rm_so);  
    iMatrix = new MatrixReader(tString);
    delete[] tString;
    iName = new char[tMatch[2].rm_eo-tMatch[2].rm_so+1];		//Get the name of the condition
    iName[tMatch[2].rm_eo-tMatch[2].rm_so] = 0;
    strncpy(iName, pLine+tMatch[2].rm_so, tMatch[2].rm_eo-tMatch[2].rm_so);  
    iID = strtol(pLine+tMatch[1].rm_so, NULL, 10);			//Get the id of the condition
    iMult = strtod(pLine+tMatch[12].rm_so, NULL);			//Get the multiplier 
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

ostream& Condition::output(ostream& pStream)
{
    pStream << iID << "\t" << iName << "\t" << *iMatrix << " " << iMult << "\n";
    return pStream;
}

ostream& operator<<(ostream& pStream, Condition& pCondition)
{
    return pCondition.output(pStream);
}

Conditions::Conditions()
{
    iConditions = new ArrayList<Condition>(1);

 /*   while ((tNext = strchr(tPrev, '\n'))!=NULL)
    {
        char tString[tNext-tPrev+1];
        tString[tNext-tPrev] = 0;
        strncpy(tString, tPrev, tNext-tPrev);
        Condition* tCondition = new Condition(tString);
        iConditions->setWithAdd(tCondition, tCondition->getID());
        tPrev = tNext+1;
    }*/
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
        try
        {
            tCondition = new Condition(pLine);
        }
        catch (MyException e)
        {
             tNext = NULL;
        }
    }
    else
    {
        try
        {
            char tString[(int)(tNext-pLine)+1];
            tString[(int)(tNext-pLine)] = 0;
            strncpy(tString, pLine, (int)(tNext-pLine));
            tCondition = new Condition(tString);
            tNext++;
        }
        catch (MyException e)
        {
             tNext = NULL;
        }
    }
    iConditions->setWithAdd(tCondition, tCondition->getID());
    return tNext;
}

ostream& Conditions::output(ostream& pStream)
{
    int tSize = iConditions->length();
    for (int i = 0; i < tSize; i++)
    {
        Condition* tCondition = iConditions->get(i);
        if (tCondition)
        {
            cout << *tCondition << "\n";
        }
        else
        {
            cout << "null\n";
        }
    }
    return pStream;
}


ostream& operator<<(ostream& pStream, Conditions& pConditions)
{
    return pConditions.output(pStream);
}


Headings::Headings()
{
    iHeadings = new ArrayList<Heading>(1);
/*    char* tNext;
    char* tPrev = pLines;
    while ((tNext = strchr(tPrev, '\n'))!=NULL)
    {
        char tString[tNext-tPrev+1];
        tString[tNext-tPrev] = 0;
        strncpy(tString, tPrev, tNext-tPrev);
        Heading* tHeading = new Heading(tString);
        iHeadings->setWithAdd(tHeading, tHeading->getID());
        tPrev = tNext+1;
    }*/
}

Headings::~Headings()
{
    int iSize = iHeadings->length();
    for (int i = 0; i < iSize; i++)
    {
        iHeadings->remove(i);
    }
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

ostream& Headings::output(ostream& pStream)
{
    int tSize = iHeadings->length();
    for (int i = 0; i < tSize; i++)
    {
        Heading* tHeading = iHeadings->get(i);
        if (tHeading)
        {
            cout << *tHeading << "\n";
        }
        else
        {
            cout << "null\n";
        }
    }
    return pStream;
}

char* Headings::addHeading(char* pLine)	//Returns the point which the line at the start of this string finishs
{
    char* tNext = strchr(pLine, '\n');
    Heading* tHeading;
    if (tNext == NULL)
    {
        try
        {
            tHeading = new Heading(pLine);
        }
        catch (MyException e)
        {
             tNext = NULL;
        }
    }
    else
    {
        try
        {
            char tString[(int)(tNext-pLine)+1];
            tString[(int)(tNext-pLine)] = 0;
            strncpy(tString, pLine, (int)(tNext-pLine));
            tHeading = new Heading(tString);
            tNext++;
        }
        catch (MyException e)
        {
            tNext = NULL;
        }
    }
    iHeadings->setWithAdd(tHeading, tHeading->getID());
    return tNext;
}


ostream& operator<<(ostream& pStream, Headings& pHeaders)
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

ostream& Index::output(ostream& pStream)
{
    return pStream << iValue;
}

ostream& operator<<(ostream& pStream, Index& pIndex)
{
    return pIndex.output(pStream);
}

Indexs::Indexs(signed char pIndex)
{
    iIndexs = new ArrayList<Index>(1);
    iIndexs->set(new Index(pIndex), 0);
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

ostream& Indexs::output(ostream& pStream)
{
    int tCount = iIndexs->length();
    for (int i = 0; i < tCount;  i++)
    {
        pStream << *(iIndexs->get(i));
        if (i < tCount -1)
        {
            pStream << " ";
        }
    }
    return pStream;
}

ostream& operator<<(ostream& pStream, Indexs& pIndexs)
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
        if (tValue)
        {
            delete tValue;
        }
    }
    Indexs* tValue2;
    for (int i = 0; i < tSize; i++)
    {
        tValue2 = iConditions->remove(i);
        if (tValue2)
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

Indexs* ConditionColumn::getCondition(int pIndex)
{
    return iConditions->get(pIndex);
}

void ConditionColumn::setHeading(char* pHeading)
{
    char tRegExp[] = "([[:digit:]]),?[[:space:]]?";
    int tOffset = 0;
    
    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 3;
    regmatch_t tMatch[3];
    
    bzero(tMatch, sizeof(regmatch_t)*3);
    while (!regexec(&tRegEx, pHeading+tOffset, tMatches, tMatch, 0))
    {
        int pIndex = strtol(pHeading+tOffset, NULL, 10);
        addHeading((signed char)pIndex);
        tOffset += tMatch[0].rm_eo;
        bzero(tMatch, sizeof(regmatch_t)*3);
    }
}

int ConditionColumn::getHeading(const int pIndex)
{
    return iHeadingConditions->get(pIndex)->get();
}

int ConditionColumn::countHeadings()
{
    return iHeadingConditions->length();
}

int ConditionColumn::countCondition()
{
    return iConditions->length();
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

ostream& SpaceGroup::output(ostream& pStream)
{
    return pStream << iSymbols;
}

ostream& operator<<(ostream& pStream, SpaceGroup& pSpaceGroup)
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
}

void SpaceGroups::add(char* pSpaceGroup,  int pRow)
{
    iSpaceGroups->setWithAdd(new SpaceGroup(pSpaceGroup), pRow);
}

SpaceGroup* SpaceGroups::get(int pIndex)
{
    return iSpaceGroups->get(pIndex);
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
    iName = new char[strlen(pName)+1];
    strcpy(iName, pName);
    iHeadings = pHeadings;
    iConditions = pConditions;
    iColumns = new ArrayList<ConditionColumn>(pNumColumns);
    for (int i = 0; i < pNumColumns; i++)
    {
        iColumns->add(new ConditionColumn());
    }
    iSpaceGroups = new ArrayList<SpaceGroups>(pNumPointGroups);
    for (int i = 0; i < pNumColumns; i++)
    {
        iSpaceGroups->add(new SpaceGroups());
    }
}
        
Table::~Table()
{
    delete[] iName;
    
    int tSize = iSpaceGroups->length();
    for (int i = 0; i<tSize; i++)
    {
        SpaceGroups* tGroups = iSpaceGroups->remove(i);
        if (tGroups)
        {
            delete tGroups;
        }
    }
    tSize = iColumns->length();
    for (int i = 0; i<tSize; i++)
    {
        ConditionColumn* tConditions = iColumns->remove(i);
        if (tConditions)
        {
            delete tConditions;
        }
    }
    delete iColumns;
    delete iSpaceGroups;
}

void Table::columnHeadings(char* pHeadings, int pColumn)
{
    char tRegExp[] = "([^\t]+)\t?([^\t].+)?";
    
    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 3;
    regmatch_t tMatch[3];
    
    bzero(tMatch, sizeof(regmatch_t)*3);
    if (regexec(&tRegEx, pHeadings, tMatches, tMatch, 0))
    {
        return;
    }
    char* tString = new char[tMatch[1].rm_eo-tMatch[1].rm_so+1];
    tString[tMatch[1].rm_eo-tMatch[1].rm_so] = 0;
    strncpy(tString, pHeadings+tMatch[1].rm_so, tMatch[1].rm_eo-tMatch[1].rm_so);	//get the first element on the line
    if (pColumn < iColumns->length())
    {
        iColumns->get(pColumn)->setHeading(tString);
    }
    else
    {
        iSpaceGroups->get(pColumn-iColumns->length())->setHeading(tString);
    }
    delete[] tString;
    if (tMatch[2].rm_so==-1)
    {
        return;
    }
    columnHeadings(pHeadings+tMatch[2].rm_so, pColumn+1);
}

void Table::readColumnHeadings(char* pHeadings)
{
    columnHeadings(pHeadings, 0);
}

void Table::addLine(char* pLine, int pColumn)
{
    char tRegExp[] = "([^\t]+\t?)([^\t].+)?";
    
    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 3;
    regmatch_t tMatch[3];
    
    bzero(tMatch, sizeof(regmatch_t)*3);
    if (regexec(&tRegEx, pLine, tMatches, tMatch, 0))
    {
        return;
    }
    char* tString = new char[tMatch[1].rm_eo-tMatch[1].rm_so+1];
    tString[tMatch[1].rm_eo-tMatch[1].rm_so] = 0;
    strncpy(tString, pLine+tMatch[1].rm_so, tMatch[1].rm_eo-tMatch[1].rm_so);	//Get the first element in the line
    int pRow = iColumns->get(0)->countCondition();	//Get the row which we are at.
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
    addLine(pLine+tMatch[1].rm_eo , pColumn+1);
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

ostream& Table::outputLine(int pLineNum, ostream& pStream)
{
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSpaceGroups->length();
    for (int i = 0; i < tLengthConditions; i++)
    {
        Indexs* tIndexs = iColumns->get(i)->getCondition(pLineNum);
        if (tIndexs == NULL)
        {
            pStream << "- ";
        }
        else
        {
           pStream << *(tIndexs) << " ";
        }
    }
    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        SpaceGroups* tSpaceGroups = iSpaceGroups->get(i);
        SpaceGroup* tSpaceGroup = tSpaceGroups->get(pLineNum);
        pStream << *(tSpaceGroup) << " ";
        pStream << "\t";
    }
    pStream << "\n";
    return pStream;
}

ostream& Table::output(ostream& pStream)
{	
    int tLengthConditions = iColumns->length();
    int tLengthSpaceGroup = iSpaceGroups->length();
    for (int i = 0; i < tLengthConditions; i++)
    {
        int tHeadingNumber = iColumns->get(i)->countHeadings();
        for (int j = 0; j < tHeadingNumber; j ++)
        {
            pStream << iColumns->get(i)->getHeading(j) << " ";
        }
        
    }
    for (int i = 0; i < tLengthSpaceGroup; i++)
    {
        pStream << iSpaceGroups->get(i)->getPointGroup() << " ";
        pStream << "\t";
    }
    pStream << "\n";
    if (tLengthConditions > 0)
    {
        int tNumOfLines = iColumns->get(0)->countCondition();
        for (int i =0; i < tNumOfLines; i++)
        {
            pStream << outputLine(i, pStream);
        }
    }
    return pStream;
}

ostream& operator<<(ostream& pStream, Table& pTable)
{
    return pTable.output(pStream);
}