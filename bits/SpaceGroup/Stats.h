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
        void outputHeadings(std::ostream& pStream, signed char pColumnsToPrint[], int pNumOfColums);
        void outputRow(int pRow, std::ostream& pStream, signed char pColumnsToPrint[], int pNumOfColums, int pColumnWidth=12, int pOtherColumns=8);
        static float evaluationFunction(float pX, float AbsentM, float AbsentSD, float PresentM, float PresentSD);
        void handleFilteredData(int pColumns[], int pNumColumns);
        int numberOfOutElementValues();
        std::ostream& outputElementValue(std::ostream& pStream, ElemStats* pStats , int pValues);
    public:
        Stats(Headings* pHeadings, Conditions* pConditions);
        ~Stats();
        bool filtered();
        void addReflectionRows(int pColumn, Reflection* pReflection, Matrix<short>* pHKLM);
        void addReflection(Reflection* tReflection);
        void calProbs();			//Calculates all the probabilites for all the cells.
        ElemStats* getElem(int pHeadIndex, int pCondIndex);
        std::ostream& output(std::ostream& pStream, Table& pTable);
        std::ofstream& output(std::ofstream& pStream, Table& pTable);
};

#endif