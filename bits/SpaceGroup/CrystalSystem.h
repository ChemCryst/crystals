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

#ifdef _WIN32
#include "PCPort.h"
#endif

using namespace std;
struct ElemStats;

/*!
 * @class Region 
 * @description Not yet documented.
 * @abstract
*/
class Region:public Matrix<short>
{
    private:
        char*	iName;
        int 	iID;
    public:
        Region(char* pLines);
        ~Region();

        /*!
         * @function getName 
         * @description Not yet documented.
         * @abstract
         */
        char* getName();

        /*!
         * @function getID 
         * @description Not yet documented.
         * @abstract
         */
        int getID();

		/*!
		 * @function contains 
		 * @description Not yet documented.
		 * @abstract
		 */
		bool contains(Matrix<short> &pHKL, LaueGroup &pLaueGroup, Matrix<short>& pResultMatrix);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
};

/*!
 * @class Regions 
 * @description Not yet documented.
 * @abstract
*/
class Regions:public vector<Region*>
{
    public:
        Regions();
        ~Regions();

        /*!
         * @function getMatrix 
         * @description Not yet documented.
         * @abstract
         */
        Matrix<short>* getMatrix(const size_t pIndex);

        /*!
         * @function getName 
         * @description Not yet documented.
         * @abstract
         */
        char* getName(const size_t pIndex);

        /*!
         * @function getID 
         * @description Not yet documented.
         * @abstract
         */
        int getID(int pIndex);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);

        /*!
         * @function addRegion 
         * @description Not yet documented.
         * @abstract
         */
        char* addRegion(char* pLine);

        /*!
         * @function readFrom 
         * @description Not yet documented.
         * @abstract
         */
        void readFrom(filebuf& pFile);
};

std::ostream& operator<<(std::ostream& pStream, Region& pHeader);
std::ostream& operator<<(std::ostream& pStream, Regions& pHeaders);
 
/*!
 * @class Index 
 * @description A wrapper class for an integer type.
 * @abstract This is could be replaced with a typedef.
*/
class Index:public Number<signed char>
{
    public:
        Index(signed char pValue);
        Index(const Index& pObject);
        signed char get();

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Index& pIndex);

/*!
 * @class Indexs 
 * @description Not yet documented.
 * @abstract
*/
class Indexs:public vector<Index*>
{
    public:
		Indexs();
        Indexs(signed char pIndex);
		Indexs(const Indexs& pIndexs);
        ~Indexs();

        /*!
         * @function addIndex 
         * @description Not yet documented.
         * @abstract
         */
        void addIndex(signed char pIndex);
        signed char getValue(int pIndex);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Indexs& pIndexs);

/*!
 * @class ConditionColumn 
 * @description Not yet documented.
 * @abstract
*/
class ConditionColumn:virtual public Column
{
    private:
        vector<Index>* iRegionConditions;
        vector<Indexs*>* iConditions;	
    public:
        ConditionColumn();
        ~ConditionColumn();

        /*!
         * @function addRegion 
         * @description Not yet documented.
         * @abstract
         */
        void addRegion(signed char pIndex);

        /*!
         * @function setRegion 
         * @description Not yet documented.
         * @abstract
         */
        void setRegion(char* pRegion);

        /*!
         * @function getRegion 
         * @description Not yet documented.
         * @abstract
         */
        int getRegion(const size_t pIndex);

        /*!
         * @function getRegions 
         * @description Not yet documented.
         * @abstract
         */
        vector<Index>* getRegions();

        /*!
         * @function addCondition 
         * @description Not yet documented.
         * @abstract
         */
        void addCondition(signed char pIndex, size_t pRow);

        /*!
         * @function addEmptyCondition 
         * @description Not yet documented.
         * @abstract
         */
        void addEmptyCondition(size_t pRow);

        /*!
         * @function getConditions 
         * @description Not yet documented.
         * @abstract
         */
        Indexs* getConditions(size_t pIndex);

        /*!
         * @function length 
         * @description Not yet documented.
         * @abstract
         */
        size_t length();

        /*!
         * @function countRegions 
         * @description Not yet documented.
         * @abstract
         */
        size_t countRegions();

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream, Regions* pRegions, Conditions* pConditions);
};

/*!
 * @class Table 
 * @description Not yet documented.
 * @abstract
*/
class Table:public MyObject
{
    private:
        char* iName;
        vector<ConditionColumn*>* iColumns;	//The conditions. Null means that there is no condition.
        vector<SGColumn> iSGColumn;			//Columns of space groups.
        Regions* iRegions;
        Conditions* iConditions;

	/*!
	 * @function columnRegions 
	 * @description Not yet documented.
	 * @abstract
	 */
	void columnRegions(char* pRegions, size_t pColumn);

        /*!
         * @function addLine 
         * @description Not yet documented.
         * @abstract
         */
        void addLine(char* pLine, size_t pColumn);

        /*!
         * @function addCondition 
         * @description Not yet documented.
         * @abstract
         */
        void addCondition(char* pCondition, ConditionColumn* pColumn, size_t pRow);

        /*!
         * @function addSpaceGroup 
         * @description Not yet documented.
         * @abstract
         */
        void addSpaceGroup(char* pSpaceGroup, SGColumn* pSGColumn, size_t pRow);
    public:
        Table(char* pName, Regions* pRegions, Conditions* pConditions, int pNumColumns, int pNumPointGroups);
        ~Table();

        /*!
         * @function addLine 
         * @description Not yet documented.
         * @abstract
         */
        void addLine(char* pLine);

	/*!
	 * @function readColumnRegions 
	 * @description Not yet documented.
	 * @abstract
	 */
	void readColumnRegions(char* pRegions);

        /*!
         * @function readFrom 
         * @description Not yet documented.
         * @abstract
         */
        void readFrom(filebuf& pFile);

        /*!
         * @function getName 
         * @description Not yet documented.
         * @abstract
         */
        char* getName();

        /*!
         * @function getRegions 
         * @description Not yet documented.
         * @abstract
         */
        vector<Index>* getRegions(const size_t  pI) const;

		/*!
		 * @function numSGColumns 
		 * @description Not yet documented.
		 * @abstract
		 */
		size_t numSGColumns();
//        int getNumPointGroups();	

        /*!
         * @function getSpaceGroup 
         * @description Not yet documented.
         * @abstract
         */
        SpaceGroups* getSpaceGroup(const size_t  pLineNum, const size_t  pPointGroupNum);

        /*!
         * @function getConditions 
         * @description Not yet documented.
         * @abstract
         */
        Indexs* getConditions(const size_t  pRow, const size_t pColumn);

        /*!
         * @function numberOfColumns 
         * @description Not yet documented.
         * @abstract
         */
        size_t numberOfColumns();

        /*!
         * @function numberOfRows 
         * @description Not yet documented.
         * @abstract
         */
        size_t numberOfRows();

		/*!
		 * @function chiralColumns 
		 * @description Not yet documented.
		 * @abstract
		 */
		set<int, ltint>& chiralColumns(set<int, ltint>& pColumnIndeces);

		/*!
		 * @function columnsFor 
		 * @description Not yet documented.
		 * @abstract
		 */
		set<int, ltint>& columnsFor(LaueGroup& pLaueGroup,  set<int, ltint>& pColumnIndeces);

        /*!
         * @function dataUsed 
         * @description Not yet documented.
         * @abstract
         */
        size_t dataUsed(signed char pIndices[], const size_t pMax) const;

        /*!
         * @function conditionsUsed 
         * @description Not yet documented.
         * @abstract
         */
        size_t conditionsUsed(signed char pIndices[], const size_t pMax) const;

		/*!
		 * @function hasSpaceGroupInColumns 
		 * @description Not yet documented.
		 * @abstract
		 */
		bool hasSpaceGroupInColumns(vector<int>& pColumnNums, uint pRowNumber);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);

        /*!
         * @function outputLine 
         * @description Not yet documented.
         * @abstract
         */
        std::ofstream& outputLine(const size_t pLineNum, std::ofstream& pStream);

		/*!
		 * @function outputLine 
		 * @description Not yet documented.
		 * @abstract
		 */
		std::ofstream& outputLine(const size_t pLineNum, std::ofstream& pStream, set<int, ltint>& tPointGroups);

        /*!
         * @function outputLine 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& outputLine(const size_t pLineNum, std::ostream& pStream, const size_t pColumnCount=8);

		/*!
		 * @function outputLine 
		 * @description Not yet documented.
		 * @abstract
		 */
		std::ostream& outputLine(const size_t pLineNum, std::ostream& pStream, set<int, ltint>& tPointGroups, const size_t pColumnSize);
};

std::ostream& operator<<(std::ostream& pStream, Table& pTable);

/*!
 * @class Tables 
 * @description Not yet documented.
 * @abstract
*/
class Tables:public map<char*, Table*, ltstr>
{
    private:
        Regions* iRegions;
        Conditions* iConditions;
    public:
        Tables(char* pFileName);
        ~Tables();

        /*!
         * @function getRegions 
         * @description Not yet documented.
         * @abstract
         */
        Regions* getRegions();

	    /*!
	     * @function getConditions 
	     * @description Not yet documented.
	     * @abstract
	     */
	    Conditions* getConditions();

        /*!
         * @function readFrom 
         * @description Not yet documented.
         * @abstract
         */
        void readFrom(filebuf& pFile);

        /*!
         * @function findTable 
         * @description Not yet documented.
         * @abstract
         */
        Table* findTable(char* pName);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator <<(std::ostream& pStream, Tables& pTables);

/*!
 * @class Stats 
 * @description Not yet documented.
 * @abstract
*/
class Stats;

/*!
 * @class RowRating 
 * @description Not yet documented.
 * @abstract
*/
class RowRating:public Float	//The value is the mean value;
{
	private:

		/*!
		 * @function addConditionRatings 
		 * @description Not yet documented.
		 * @abstract
		 */
		void addConditionRatings(Stats& pStats, Indexs* tIndexs,  Index* pRegionIndex);

		/*!
		 * @function addRating 
		 * @description Not yet documented.
		 * @abstract
		 */
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



/*!
 * @class RankedSpaceGroups 
 * @description Not yet documented.
 * @abstract
*/
class RankedSpaceGroups:public multiset<RowRating, RRlt>
{
    protected:
        Table* iTable;			//The table which the rattings have been made for. Reference to the table. Table should never be released by this class.
        bool iChiral;
		LaueGroup iLaueGroup;

        /*!
         * @function addToList 
         * @description Not yet documented.
         * @abstract
         */
        void addToList(RowRating& pRating);
    public:
        RankedSpaceGroups(Table& pTable, Stats& pStats, bool pChiral, LaueGroup& pLaueGroup);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ofstream& output(std::ofstream& pStream);

        /*!
         * @function output 
         * @description Not yet documented.
         * @abstract
         */
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, RankedSpaceGroups& pRank);
std::ofstream& operator<<(std::ofstream& pStream, RankedSpaceGroups& pRank);
#endif
