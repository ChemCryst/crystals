/*
 *  CrystalSystem.h
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
#ifndef __CRYSTAL_SYSTEM_H__
#define __CRYSTAL_SYSTEM_H__
#include "Matrices.h"
#include "Collections.h"
#include "HKLData.h"
#include <fstream>
using namespace std;

class Heading
{
    private:
        Matrix<float>* iMatrix;
        char*	iName;
        int 	iID;
    public:
        Heading(char* pLines);
        ~Heading();
        Matrix<float>* getMatrix();
        char* getName();
        int getID();
        ostream& Heading::output(ostream& pStream);
};

class Headings
{
    private:
        ArrayList<Heading>* iHeadings;
    public:
        Headings();
        ~Headings();
        Matrix<float>* getMatrix(int pIndex);
        char* getName(int pIndex);
        int getID(int pIndex);
        ostream& output(ostream& pStream);
        char* addHeading(char* pLine);
        void readFrom(filebuf& pFile);
        int length();
};

ostream& operator<<(ostream& pStream, Heading& pHeader);
ostream& operator<<(ostream& pStream, Headings& pHeaders);

class Condition
{
    private:
        Matrix<float>* iMatrix;
        char* iName;
        int iID;
        float iMult;
    public:
        Condition(char* pLine);
        ~Condition();
        char* getName();
        Matrix<float>* getMatrix();
        float getMult();
        int getID();
        ostream& output(ostream& pStream);
};

ostream& operator<<(ostream& pStream, Condition& pCondition);

class Conditions
{
    private:
        ArrayList<Condition>* iConditions;
    public:
        Conditions();
        ~Conditions();
        char* getName(int pIndex);
        float getMult(int pIndex);
        Matrix<float>* getMatrix(int pIndex);
        ostream& output(ostream& pStream);
        char* addCondition(char* pLine);
        void readFrom(filebuf& pFile);
        int length();
};

ostream& operator<<(ostream& pStream, Conditions& pConditions);

//This is just my own rapper class for an integer type.
class Index
{
    private:
        signed char iValue;
    public:
        Index(signed char pValue);
        Index(Index& pObject);
        signed char get();
        void set(signed char pValue);
        Index& operator=(Index& pObject);
        bool operator<(Index& pObject);
        bool operator>(Index& pObject);
        bool operator==(Index& pObject);
        ostream& output(ostream& pStream);
};

ostream& operator<<(ostream& pStream, Index& pIndex);

class Indexs
{
    private:
        ArrayList<Index>* iIndexs;
    public:
        Indexs(signed char pIndex);
        ~Indexs();
        void addIndex(signed char pIndex);
        int number();
        Index* getIndex(int pIndex);
        int getValue(int pIndex);
        ostream& output(ostream& pStream);
};

ostream& operator<<(ostream& pStream, Indexs& pIndexs);

class Column
{
    public:
        void setHeading(char* pHeading);
};

class ConditionIndexs:public Indexs
{
    private:
        Matrix<float>* iStats;	//[Total intensity non-matched, Total intensity matched, Total intensity, Number non-matched, Number matched, Number of Int>3*sigma non-matched, Number of Int<=3*sigma non-matched]
    public:
        ConditionIndexs(signed char pValue);
        ConditionIndexs(ConditionIndexs& pObject);
        void addReflection(Reflection* pReflection, Conditions* pCondtions);
        ostream& output(ostream& pStream);
        ostream& output(ostream& pStream,  Conditions* pConditions);
};

/* to be implemented */
class ConditionColumn:virtual public Column
{
    private:
        ArrayList<Index>* iHeadingConditions;
        ArrayList<ConditionIndexs>* iConditions;	
    public:
        ConditionColumn();
        ~ConditionColumn();
        void addHeading(signed char pIndex);
        void setHeading(char* pHeading);
        int getHeading(const int pIndex);
        void addCondition(signed char pIndex, int pRow);
        void addEmptyCondition(int pRow);
        ConditionIndexs* getCondition(int pIndex);
        int countCondition();
        int countHeadings();
        void addReflection(Reflection* pReflection, Headings* pHeadings, Conditions* pConditions);
        ostream& output(ostream& pStream, Headings* pHeadings, Conditions* pConditions);
};

class SpaceGroup
{
    private:
        char* iSymbols;
    public:
        SpaceGroup(char* pSymbols);
        ~SpaceGroup();
        char* getSymbol();
        ostream& output(ostream& pStream);
};

ostream& operator<<(ostream& pStream, SpaceGroup& pSpaceGroup);

class SpaceGroups:virtual public Column
{
    private:
        char* iPointGroup;
        ArrayList<SpaceGroup>* iSpaceGroups;
    public:
        SpaceGroups();
        ~SpaceGroups();
        void add(char* pSpaceGroup, int pRow);
        SpaceGroup* get(int pIndex);
        void setHeading(char* pHeading);
        char* getPointGroup();
};

class Table
{
    private:
        char* iName;
        ArrayList<ConditionColumn>* iColumns;	//The conditions. Null means that there is no condition.
        ArrayList<SpaceGroups>* iSpaceGroups;	//Columns of space groups.
        Headings* iHeadings;
        Conditions* iConditions;
	void columnHeadings(char* pHeadings, int pColumn);
        void addLine(char* pLine, int pColumn);
        void addCondition(char* pCondition, ConditionColumn* pColumn, int pRow);
        void addSpaceGroup(char* pSpaceGroup, SpaceGroups* pSpaceGroups, int pRow);
    public:
        Table(char* pName, Headings* pHeadings, Conditions* pConditions, int pNumColumns, int pNumPointGroups);
        ~Table();
        void addLine(char* pLine);
	void readColumnHeadings(char* pHeadings);
        void readFrom(filebuf& pFile);
        void addReflection(Reflection* pReflection);
        char* getName();
        ostream& output(ostream& pStream);
        ostream& outputLine(int pLineNum, ostream& pStream);
        ostream& outputColumn(ostream& pStream, int pColumn, Headings* pHeadings, Conditions* pConditions);
};

ostream& operator<<(ostream& pStream, Table& pTable);

class Tables
{
    private:
        ArrayList<Table>* iTables;
        Headings* iHeadings;
        Conditions* iConditions;
    public:
        Tables(Headings* pHeadings, Conditions* pConditions);
        ~Tables();
        void addTable(Table* pTable);
        void readFrom(filebuf& pFile);
        Table* findTable(char* pName);
        ostream& output(ostream& pStream);
};

ostream& operator <<(ostream& pStream, Tables& pTables);

class RankedSpaceGroups
{
    private:
        typedef struct RowRating
        {
            int iRowNum;
            int iTotNumVal;	//Total number of values include in these stats.
            float iSumRat1;	//Sum of rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
            float iSumRat2;	//Sum of rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
            float iSumSqrRat1;	//Sum of square rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
            float iSumSqrRat2;	//Sum of square rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
        } RowRating;
        
        LList<RowRating> iRatings;
};
#endif