/*
 *  Stats.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed Feb 19 2003.
 *  Copyright (c) 2003 . All rights reserved.
 *
 */

#include "Stats.h"
#include "MathFunctions.h"
#include "Collections.h"

//Average Int
static float AbsentAIM = 0.00834789;
static float AbsentAISD = 0.01289479;
static float PresentAIM = 0.49585336;
static float PresentAISD = 0.16645043;
//Num Int < 3sigma
static float Absent3SM = 0.00360566;
static float Absent3SSD = 0.00859224;
static float Present3SM = 0.63777005;
static float Present3SSD = 0.21934966;

float Stats::evaluationFunction(float pX, float AbsentM, float AbsentSD, float PresentM, float PresentSD)
{
    return 1-cumlNormal(pX, AbsentM, AbsentSD)-cumlNormal(pX, PresentM, PresentSD);
}

Stats::Stats(Headings* pHeadings, Conditions* pConditions)
{
    iHeadings = pHeadings;
    iConditions = pConditions;
    iStats = new ElemStats[pHeadings->length()*pConditions->length()];
    iTotalNum = 0; 
    iTotalIntensity = 0;
}

Stats::~Stats()
{
    delete[] iStats;
}

void Stats::addReflectionRows(int pColumn, Reflection* pReflection, Matrix<float>* pHKLM)	//Goes through the rows down the specified Column adding the reflection to the stats.
{
    int tCCount = iConditions->length();    //Cache lengths of the table.
    for (int i= 0; i < tCCount; i++)
    {
        Matrix<float>* tMultiMat = NULL;
        tMultiMat = iConditions->getMatrix(i);
        Matrix<float> tMatrix = (*tMultiMat)*(*pHKLM);
     /*   cout << *tMultiMat << "\n";
        cout << *pHKLM << "\n";
        cout << tMatrix << "\n";*/
        ElemStats* tStats = &(iStats[(pColumn*tCCount)+i]);
        if (((int)tMatrix.getValue(0)) % ((int)iConditions->getMult(i)) != 0)
        {
            tStats->tNonMTotInt += pReflection->i;	//Total intensity non-matched.
            tStats->tNumNonM ++;	//Number non-matched
            if (pReflection->i/pReflection->iSE >= 3)
            {
                tStats->tNumNonMLsInt ++;	//Number Int<3*sigma non-matched
            }
            else
            {
                tStats->tNumNonMGrInt ++;
            }
        }
        else
        {
            tStats->tMTotInt += pReflection->i;	//Total intensity matched. 
            tStats->tNumM ++;	//Number matched
        }
    }
}

ElemStats* Stats::getElem(int pHeadIndex, int pCondIndex)
{
    int tCCount = iConditions->length();    //Cache lengths of the table.
    return &(iStats[(pHeadIndex*tCCount)+pCondIndex]);
}

void Stats::addReflection(Reflection* pReflection)
{
    iTotalNum ++;
    iTotalIntensity += pReflection->i;	
    int tHCount = iHeadings->length();			//Cache lengths of the table.
    Matrix<float>* tHKLMat = pReflection->getHKL();	//Get the HKL matrix from the reflection.
    Matrix<float>* tMultiMat = NULL;			// Matrix pointer to be used generaly when needed.
    for (int i = 0; i < tHCount; i++)			//Go through Columns in the table.
    {
        tMultiMat = iHeadings->getMatrix(i);
        Matrix<float> tResult(1, 3);
        tResult = (*tMultiMat)*(*tHKLMat);	//Multiply the two matrices to see if this reflection satisfy the condition
   //     cout << (*tHKLMat) <<"\n" << tResult << "\n";
        if (tResult == (*tHKLMat))	//if this condition is satisfy then...
        {
            addReflectionRows(i, pReflection, tHKLMat);
            if (i == 4 && tHKLMat->getValue(1)!=0 && tHKLMat->getValue(2)!=0)
            {
                cout << *tHKLMat << "==\n";
                cout << tResult << "\n";
            }   
        }
    }
}

void Stats::outputRow(int pRow, ostream& pStream)
{
    int tHCount = iHeadings->length();
    int tCCount = iConditions->length();
    char* tName = iConditions->getName(pRow);
    
    pStream << tName << "\t";
    if (strlen(tName) <	8)
    {
        cout << "\t";
    }
    for (int i = 0; i < tHCount; i++)
    {
        pStream << "| NMAI: " << iStats[i*tCCount+pRow].tNonMTotInt/iStats[i*tCCount+pRow].tNumNonM << "\t";	//Total intensity non-matched.
    }
    pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        pStream << "| MAI: " << iStats[i*tCCount+pRow].tMTotInt/iStats[i*tCCount+pRow].tNumM << "\t";	//Total intensity matched. 
    }
    pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        printf("| Rat1: %0.4f\t", iStats[i*tCCount+pRow].tRating1);	
    }
    /*pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        float tValue1 = iStats[i*tCCount+pRow].tNonMTotInt/iStats[i*tCCount+pRow].tNumNonM;
        float tValue2 = iStats[i*tCCount+pRow].tMTotInt/iStats[i*tCCount+pRow].tNumM;
        printf("| Rat1: %0.4f\t", tValue1/(tValue2+tValue1));	//Total intensity matched. 
    }*/
    pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        pStream << "| NLI: " << iStats[i*tCCount+pRow].tNumNonMLsInt << "\t";	//Number Int<3*sigma non-matched
    }
    pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        pStream << "| NGEI: " << iStats[i*tCCount+pRow].tNumNonMGrInt << "\t";
    }
    pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        pStream << "| NNMa: " << iStats[i*tCCount+pRow].tNumNonM << "\t";
    }
    pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        pStream << "| NumM: " << iStats[i*tCCount+pRow].tNumM << "\t";
    }
    pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        printf("| Rat2: %0.4f\t", (float)iStats[i*tCCount+pRow].tRating2);	
    }
   /* pStream << "\n\t\t";
    for (int i = 0; i < tHCount; i++)
    {
        printf("| Rat2: %0.4f\t", (float)iStats[i*tCCount+pRow].tNumNonMLsInt/((float)iStats[i*tCCount+pRow].tNumNonMGrInt+(float)iStats[i*tCCount+pRow].tNumNonMLsInt));	
    }*/
}

void Stats::outputHeadings(ostream& pStream)
{
    int tHCount = iHeadings->length();
    pStream << "\t";
    for (int i = 0; i < tHCount; i++)
    {
        pStream << "\t|\t" << iHeadings->getName(i);
    }
    pStream << "\n";
}

void Stats::calProbs()
{
    int tTotalNum = iConditions->length() * iHeadings->length();
    for (int i = 0; i < tTotalNum; i ++)
    {
        ElemStats* tCurrentStat = &(iStats[i]);
        float tValue1 = iStats[i].tNonMTotInt/iStats[i].tNumNonM;
        float tValue2 = iStats[i].tMTotInt/iStats[i].tNumM;
        tValue1 = tValue1/(tValue2+tValue1);			//Calculate Ave int non-matched over total.
        
        tCurrentStat->tRating1 = evaluationFunction(tValue1, AbsentAIM, AbsentAISD, PresentAIM, PresentAISD);
        
        tValue1 = (float)iStats[i].tNumNonMLsInt/((float)iStats[i].tNumNonMGrInt+(float)iStats[i].tNumNonMLsInt);
        
        tCurrentStat->tRating2= evaluationFunction(tValue1, Absent3SM, Absent3SSD, Present3SM, Present3SSD);
    }
}

ostream& Stats::output(ostream& pStream)
{
    cout << "Total: " << iTotalNum <<"\n";
    cout << "Average Int: " << iTotalIntensity/iTotalNum << "\n";
    //Print headings
    outputHeadings(pStream);
    //Print rows
    int tCCount = iConditions->length();
    for (int i = 0; i < tCCount; i++)
    {
        outputRow(i, pStream);
        pStream << "\n\n";
    }
    return pStream;
}

ostream& operator<<(ostream& pStream, Stats& pStats)
{
    return pStats.output(pStream);
}

