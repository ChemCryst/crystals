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

#define kNumberOfOutputValues 7

typedef struct ElemStats
{
    float tNonMTotInt;	//Total intensity non-matched.
    float tMTotInt;	//Total intensity matched. 
    int tNumNonM;	//Number non-matched
    int tNumM;		//Number matched
    int tNumNonMLsInt;	//Number Int<3*sigma non-matched
    int tNumNonMGrInt;	//Number Int>=3*sigma non-matched
    float tRating1;
    float tRating2; 
    bool iFiltered;
    bool iShouldDo;
}ElemStats;

class Stats:public MyObject
{
    private:
        Headings* iHeadings;
        Conditions* iConditions;
        int iTotalNum;
        float iTotalIntensity;
        ElemStats* iStats;	//Cells of the stats.
        bool iFiltered;
        void outputHeadings(std::ostream& pStream, const signed char pColumnsToPrint[], const int pNumOfColums);
        void outputRow(int pRow, std::ostream& pStream, const signed char pColumnsToPrint[], const int pNumOfColums, const int pColumnWidth=12, const int pOtherColumns=8);
        static float evaluationFunction(float pX, float AbsentM, float AbsentSD, float PresentM, float PresentSD);
        void handleFilteredData(int pColumns[], int pNumColumns);
        int numberOfOutElementValues() const;
        std::ostream& outputElementValue(std::ostream& pStream, ElemStats* pStats , int pValues);
        void setShouldDos(Headings* pHeadings, Conditions* pConditions);
    public:
        Stats(Headings* pHeadings, Conditions* pConditions);
        ~Stats();
      //  bool filtered() const;
        void addReflectionRows(const int pColumn, Reflection* pReflection, Matrix<short>* pHKLM);
        void addReflection(Reflection* tReflection);
        void calProbs();			//Calculates all the probabilites for all the cells.
        ElemStats* getElem(const int pHeadIndex, const int pCondIndex) const;
        std::ostream& output(std::ostream& pStream, const Table& pTable);
        std::ofstream& output(std::ofstream& pStream, const Table& pTable);
};

#endif
