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
typedef struct ElemStats;

class Heading:public MyObject
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
        std::ostream& Heading::output(std::ostream& pStream);
};

class Headings:public MyObject
{
    private:
        ArrayList<Heading>* iHeadings;
    public:
        Headings();
        ~Headings();
        Matrix<float>* getMatrix(int pIndex);
        char* getName(int pIndex);
        int getID(int pIndex);
        std::ostream& output(std::ostream& pStream);
        char* addHeading(char* pLine);
        void readFrom(filebuf& pFile);
        int length();
};

std::ostream& operator<<(std::ostream& pStream, Heading& pHeader);
std::ostream& operator<<(std::ostream& pStream, Headings& pHeaders);

class Condition:public MyObject
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
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Condition& pCondition);

class Conditions:public MyObject
{
    private:
        ArrayList<Condition>* iConditions;
    public:
        Conditions();
        ~Conditions();
        char* getName(int pIndex);
        float getMult(int pIndex);
        Matrix<float>* getMatrix(int pIndex);
        std::ostream& output(std::ostream& pStream);
        char* addCondition(char* pLine);
        void readFrom(filebuf& pFile);
        int length();
};

std::ostream& operator<<(std::ostream& pStream, Conditions& pConditions);

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
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Index& pIndex);

class Indexs:public MyObject
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
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Indexs& pIndexs);

class Column:public MyObject
{
    public:
        void setHeading(char* pHeading);
};

class ConditionColumn:virtual public Column
{
    private:
        ArrayList<Index>* iHeadingConditions;
        ArrayList<Indexs>* iConditions;	
    public:
        ConditionColumn();
        ~ConditionColumn();
        void addHeading(signed char pIndex);
        void setHeading(char* pHeading);
        int getHeading(const int pIndex);
        ArrayList<Index>* getHeadings();
        void addCondition(signed char pIndex, int pRow);
        void addEmptyCondition(int pRow);
        Indexs* getConditions(int pIndex);
        int countCondition();
        int countHeadings();
        std::ostream& output(std::ostream& pStream, Headings* pHeadings, Conditions* pConditions);
};

class SpaceGroup:public MyObject
{
    private:
        char* iSymbols;
    public:
        SpaceGroup(char* pSymbols);
        ~SpaceGroup();
        char* getSymbol();
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, SpaceGroup& pSpaceGroup);

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
        int length();
        void setHeading(char* pHeading);
        char* getPointGroup();
};

class Table:public MyObject
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
        char* getName();
        ArrayList<Index>* getHeadings(int pI);
        std::ostream& output(std::ostream& pStream);
        std::ostream& outputLine(int pLineNum, std::ostream& pStream);
        std::ostream& outputLine(int pLineNum, std::ostream& pStream, int tPointGroups[]);
        int getNumPointGroups();	//Needs doing
        SpaceGroup* getSpaceGroup(int pLineNum, int pPointGroupNum);
        Indexs* getConditions(int pRow, int pColumn);
        int numberOfColumns();
        int numberOfRows();
        int chiralPointGroups(int pPointGroupIndeces[]);
};

std::ostream& operator<<(std::ostream& pStream, Table& pTable);

class Tables:public MyObject
{
    private:
        ArrayList<Table>* iTables;
        Headings* iHeadings;
        Conditions* iConditions;
    public:
        Tables(char* pFileName);
        //Tables(Headings* pHeadings, Conditions* pConditions);
        ~Tables();
        Headings* getHeadings();
	Conditions* getConditions();
        void addTable(Table* pTable);
        void readFrom(filebuf& pFile);
        Table* findTable(char* pName);
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator <<(std::ostream& pStream, Tables& pTables);

class Stats;

class RankedSpaceGroups:public MyObject
{
    private:
        typedef struct RowRating
        {
            int iRowNum;	//The number of the row in the table.
            int iTotNumVal;	//Total number of values include in these stats.
            float iSumRat1;	//Sum of rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
            float iSumRat2;	//Sum of rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
            float iSumSqrRat1;	//Sum of square rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
            float iSumSqrRat2;	//Sum of square rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
            float iMean;
            bool iFiltered;
        } RowRating;
        
        LList<RowRating> iRatingList;	//The order list of rows.
        RowRating* iRatings;		//Space to store the ratings
        Table* iTable;			//The table which the rattings have been made for. Reference to the table. Table should never be released by this class.
        bool iChiral;
        
        static void calcRowRating(RowRating* pRating, int pRow, Table& pTable, Stats& pStats);
        static void addConditionRatings(RowRating* pRating, Stats& pStats, Indexs* tIndexs,  Index* pHeadingIndex);
        static void addRating(RowRating* pRating, const ElemStats* pStats);
        void addToList(RowRating* pRating);
    public:
        RankedSpaceGroups(Table& pTable, Stats& pStats, bool pChiral);
        ~RankedSpaceGroups();
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, RankedSpaceGroups& pRank);
#endif