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
#include "BaseTypes.h"
#include "SpaceGroups.h"
#include "Wrappers.h"
#include "HKLData.h"
#include "Conditions.h"
#include "LaueClasses.h"
#include <fstream>
#include <vector>
#include <map>
#include <set>

using namespace std;
struct ElemStats;

class Region:public Matrix<short>
{
    private:
        char*	iName;
        int 	iID;
    public:
        Region(char* pLines);
        ~Region();
        char* getName();
        int getID();
		bool contains(Matrix<short> &pHKL, LaueGroup &pLaueGroup, Matrix<short>& pResultMatrix);
        std::ostream& output(std::ostream& pStream);
};

class Regions:public vector<Region*>
{
    public:
        Regions();
        ~Regions();
        Matrix<short>* getMatrix(int pIndex);
        char* getName(int pIndex);
        int getID(int pIndex);
        std::ostream& output(std::ostream& pStream);
        char* addRegion(char* pLine);
        void readFrom(filebuf& pFile);
};

std::ostream& operator<<(std::ostream& pStream, Region& pHeader);
std::ostream& operator<<(std::ostream& pStream, Regions& pHeaders);

//This is just my own rapper class for an integer type.
class Index:public Number<signed char>
{
    public:
        Index(signed char pValue);
        Index(const Index& pObject);
        signed char get();
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Index& pIndex);

class Indexs:public vector<Index*>
{
    public:
		Indexs();
        Indexs(signed char pIndex);
		Indexs(const Indexs& pIndexs);
        ~Indexs();
        void addIndex(signed char pIndex);
        signed char getValue(int pIndex);
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Indexs& pIndexs);

class ConditionColumn:virtual public Column
{
    private:
        vector<Index>* iRegionConditions;
        vector<Indexs*>* iConditions;	
    public:
        ConditionColumn();
        ~ConditionColumn();
        void addRegion(signed char pIndex);
        void setRegion(char* pRegion);
        int getRegion(const size_t pIndex);
        vector<Index>* getRegions();
        void addCondition(signed char pIndex, size_t pRow);
        void addEmptyCondition(size_t pRow);
        Indexs* getConditions(size_t pIndex);
        int length();
        int countRegions();
        std::ostream& output(std::ostream& pStream, Regions* pRegions, Conditions* pConditions);
};

class Table:public MyObject
{
    private:
        char* iName;
        vector<ConditionColumn*>* iColumns;	//The conditions. Null means that there is no condition.
        vector<SGColumn> iSGColumn;			//Columns of space groups.
        Regions* iRegions;
        Conditions* iConditions;
	void columnRegions(char* pRegions, size_t pColumn);
        void addLine(char* pLine, size_t pColumn);
        void addCondition(char* pCondition, ConditionColumn* pColumn, size_t pRow);
        void addSpaceGroup(char* pSpaceGroup, SGColumn* pSGColumn, size_t pRow);
    public:
        Table(char* pName, Regions* pRegions, Conditions* pConditions, int pNumColumns, int pNumPointGroups);
        ~Table();
        void addLine(char* pLine);
	void readColumnRegions(char* pRegions);
        void readFrom(filebuf& pFile);
        char* getName();
        vector<Index>* getRegions(int pI) const;
		size_t numSGColumns();
//        int getNumPointGroups();	
        SpaceGroups* getSpaceGroup(int pLineNum, int pPointGroupNum);
        Indexs* getConditions(int pRow, size_t pColumn);
        int numberOfColumns();
        int numberOfRows();
		set<int, ltint>& chiralColumns(set<int, ltint>& pColumnIndeces);
		set<int, ltint>& columnsFor(LaueGroup& pLaueGroup,  set<int, ltint>& pColumnIndeces);
        int dataUsed(signed char pIndices[], const size_t pMax) const;
        int conditionsUsed(signed char pIndices[], const size_t pMax) const;
		bool hasSpaceGroupInColumns(vector<int>& pColumnNums, uint pRowNumber);
        std::ostream& output(std::ostream& pStream);
        std::ofstream& outputLine(int pLineNum, std::ofstream& pStream);
		std::ofstream& outputLine(int pLineNum, std::ofstream& pStream, set<int, ltint>& tPointGroups);
        std::ostream& outputLine(int pLineNum, std::ostream& pStream, int pColumnCount=8);
		std::ostream& outputLine(int pLineNum, std::ostream& pStream, set<int, ltint>& tPointGroups, int pColumnSize);
};

std::ostream& operator<<(std::ostream& pStream, Table& pTable);

class Tables:public map<char*, Table*, ltstr>
{
    private:
        Regions* iRegions;
        Conditions* iConditions;
    public:
        Tables(char* pFileName);
        ~Tables();
        Regions* getRegions();
	    Conditions* getConditions();
        void readFrom(filebuf& pFile);
        Table* findTable(char* pName);
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator <<(std::ostream& pStream, Tables& pTables);

class Stats;

class RowRating:public Float	//The value is the mean value;
{
	private:
		void addConditionRatings(Stats& pStats, Indexs* tIndexs,  Index* pRegionIndex);
		void addRating(const ElemStats* pStats);
	public:
		int iRowNum;	//The number of the row in the table.
		int iTotNumVal;	//Total number of values include in these stats.
		float iSumRat1;	//Sum of rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
		float iSumRat2;	//Sum of rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
		float iSumSqrRat1;	//Sum of square rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
		float iSumSqrRat2;	//Sum of square rating value using on (Averager intensity Non-matched / (Averager intensity Non-matched+Averager intensity matched))
		bool iFiltered;
		RowRating(int pRow, Table& pTable, Stats& pStats);
		RowRating(const RowRating& pRating);
		RowRating& operator=(const RowRating& pRowRating);
};

struct RRlt
{
	bool operator()(const RowRating& s1, const RowRating& s2) const
	{
		return s1 > s2;
	}
};



class RankedSpaceGroups:public multiset<RowRating, RRlt>
{
    protected:
        Table* iTable;			//The table which the rattings have been made for. Reference to the table. Table should never be released by this class.
        bool iChiral;
		LaueGroup iLaueGroup;
        void addToList(RowRating& pRating);
    public:
        RankedSpaceGroups(Table& pTable, Stats& pStats, bool pChiral, LaueGroup& pLaueGroup);
        std::ofstream& output(std::ofstream& pStream);
        std::ostream& output(std::ostream& pStream);
};

/*class CrystalSystemID
{
	protected:
		SystemID iID;
		string iName;
	public:
		CrystalSystemID( pID);
		SystemID systemID();
};*/

std::ostream& operator<<(std::ostream& pStream, RankedSpaceGroups& pRank);
std::ofstream& operator<<(std::ofstream& pStream, RankedSpaceGroups& pRank);
#endif
