/*
 *  Stats.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed Feb 19 2003.
 *  Copyright (c) 2003 . All rights reserved.
 *
 */

#ifndef __STATS_H__
#define __STATS_H__

#include "CrystalSystem.h"
#include "Conditions.h"

#define kNumberOfOutputValues 8

typedef struct ElemStats
{
    float tNonMTotInt;	//Total intensity non-matched.
    float tMTotInt;	//Total intensity matched. 
    int tNumNonM;	//Number non-matched
    int tNumM;		//Number matched
    int tNumNonMLsInt;	//Number Int<3*sigma non-matched
    int tNumNonMGrInt;	//Number Int>=3*sigma non-matched
	int tNumMLsInt;	//Number Int<3*sigma non-matched
    int tNumMGrInt;	//Number Int>=3*sigma non-matched
    float tRating1;
    float tRating2; 
    bool iFiltered;
    bool iShouldDo;
}ElemStats;

class Stats:public MyObject
{
    private:
        Regions* iRegions;
        Conditions* iConditions;
        int iTotalNum;
        float iTotalIntensity;
        ElemStats* iStats;	//Cells of the stats.
        bool iFiltered;
        void outputRegions(std::ostream& pStream, const signed char pColumnsToPrint[], const size_t pNumOfColums);
        void outputRow(const size_t pRow, std::ostream& pStream, const signed char pColumnsToPrint[], const size_t pNumOfColums, const size_t pColumnWidth=13, const size_t pOtherColumns=8);
        
        void handleFilteredData(int pColumns[], size_t pNumColumns);
        int numberOfOutElementValues() const;
        std::ostream& outputElementValue(std::ostream& pStream, ElemStats* pStats , int pValues);
        void setShouldDos(Regions* pRegions, Conditions* pConditions);
    public:
        Stats(Regions* pRegions, Conditions* pConditions);
        ~Stats();
      //  bool filtered() const;
        void addReflectionRows(const size_t pColumn, Reflection* pReflection, Matrix<short> &pHKL);
        void addReflection(Reflection* tReflection, LaueGroup &pLaueGroup);
		void addReflections(HKLData &pHKLs, LaueGroup &pLaueGroup);
        void calProbs();			//Calculates all the probabilites for all the cells.
        ElemStats* getElem(const size_t pHeadIndex, const size_t pCondIndex) const;
        std::ostream& output(std::ostream& pStream, const Table& pTable);
        std::ofstream& output(std::ofstream& pStream, const Table& pTable);
		static float evaluationFunction(float pX, float AbsentM, float AbsentSD, float PresentM, float PresentSD);
};

#endif
