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
        void outputHeadings(std::ostream& pStream);
        void outputRow(int pRow, std::ostream& pStream);
        static float evaluationFunction(float pX, float AbsentM, float AbsentSD, float PresentM, float PresentSD);
        void handleFilteredData(int pColumns[], int pNumColumns);
    public:
        Stats(Headings* pHeadings, Conditions* pConditions);
        ~Stats();
        bool filtered();
        void addReflectionRows(int pColumn, Reflection* pReflection, Matrix<float>* pHKLM);
        void addReflection(Reflection* tReflection);
        void calProbs();			//Calculates all the probabilites for all the cells.
        ElemStats* getElem(int pHeadIndex, int pCondIndex);
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Stats& pStats);

#endif