/*
 *  Stats.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed Feb 19 2003.
 *  Copyright (c) 2003 . All rights reserved.
 *
 */
//#include "stdafx.h"
#include "Stats.h"
#include "MathFunctions.h"
#include "Collections.h"
#include "StringClasses.h"
#include <iomanip>
#include <math.h>

//Average Int
static float AbsentAIM = 0.00834789f;
static float AbsentAISD = 0.01289479f;
static float PresentAIM = 0.49585336f;
static float PresentAISD = 0.16645043f;
//Num Int < 3sigma
static float Absent3SM = 0.00360566f;
static float Absent3SSD = 0.00859224f;
static float Present3SM = 0.63777005f;
static float Present3SSD = 0.21934966f;

Stats::Stats(Headings* pHeadings, Conditions* pConditions):iHeadings(pHeadings), iConditions(pConditions)
{
    iStats = new ElemStats[pHeadings->length()*pConditions->length()];
    bzero((void*)iStats, sizeof(ElemStats)*pHeadings->length()*pConditions->length());
    setShouldDos(pHeadings, pConditions);
    iTotalNum = 0; 
    iTotalIntensity = 0;
}

Stats::~Stats()
{
    delete[] iStats;
}

float Stats::evaluationFunction(float pX, float AbsentM, float AbsentSD, float PresentM, float PresentSD)
{
    return 1-cumlNormal(pX, AbsentM, AbsentSD)-cumlNormal(pX, PresentM, PresentSD);
}

void Stats::setShouldDos(Headings* pHeadings, Conditions* pConditions)
{
    int tHeadingCount = pHeadings->length();
    int tCondCount = pConditions->length();
    
    for (int i = 0; i < tCondCount; i++)	//Conditions
    {
        Matrix<short>* tConditionMat = pConditions->getMatrix(i);
        for (int j = 0; j < tHeadingCount; j++) //Headings.
        {
            Matrix<short>* tHeadingMat = pHeadings->getMatrix(j);
            Matrix<short> tResult(3, 1);
            Matrix<short> tZeros(3, 1, (short)0);
            tConditionMat->mul(*tHeadingMat, tResult);
            iStats[(j*tCondCount)+i].iShouldDo = !tZeros.operator==(tResult);
        }
    }
}

void Stats::addReflectionRows(int pColumn, Reflection* pReflection, Matrix<short>* pHKLM)	//Goes through the rows down the specified Column adding the reflection to the stats.
{
    static Matrix<short> tMatrix(1, 1);
    
    int tCCount = iConditions->length();    //Cache lengths of the table.
    for (int i= 0; i < tCCount; i++)
    {
        Matrix<short>* tMultiMat = NULL;
        tMultiMat = iConditions->getMatrix(i);
        tMultiMat->mul(*pHKLM, tMatrix);
        ElemStats* tStats = &(iStats[(pColumn*tCCount)+i]);
        if (((int)tMatrix.getValue(0)) % ((int)iConditions->getMult(i)) != 0)
        {
            tStats->tNonMTotInt += (float)pReflection->i;	//Total intensity non-matched.
            tStats->tNumNonM ++;	//Number non-matched
            if (pReflection->i/pReflection->iSE >= 3)
            {
                tStats->tNumNonMGrInt ++;	//Number Int>=3*sigma non-matched
            }
            else
            {
                tStats->tNumNonMLsInt ++;
            }
        }
        else
        {
            tStats->tMTotInt += (float)pReflection->i;	//Total intensity matched. 
            tStats->tNumM ++;	//Number matched
        }
    }
}

ElemStats* Stats::getElem(const int pHeadIndex, const int pCondIndex) const
{
    int tCCount = iConditions->length();    //Cache lengths of the table.
    return &(iStats[(pHeadIndex*tCCount)+pCondIndex]);
}

void Stats::addReflection(Reflection* pReflection)
{
    static Matrix<short> tResult(1, 3);
    iTotalNum ++;
    iTotalIntensity += (float)pReflection->i;	
    int tHCount = iHeadings->length();			//Cache lengths of the table.
    Matrix<short>* tHKLMat = pReflection->getHKL();	//Get the HKL matrix from the reflection.
    Matrix<short>* tMultiMat = NULL;			// Matrix pointer to be used generally when needed.
    for (int i = 0; i < tHCount; i++)			//Go through Columns in the table.
    {
        tMultiMat = iHeadings->getMatrix(i);
        tMultiMat->mul(*tHKLMat, tResult);	//Multiply the two matrices to see if this reflection satisfy the condition
        if (tResult == (*tHKLMat))	//if this condition is satisfy then...
        {
            addReflectionRows(i, pReflection, tHKLMat);
        }
    }
}

inline int Stats::numberOfOutElementValues() const
{
    return kNumberOfOutputValues;
}

std::ostream& Stats::outputElementValue(std::ostream& pStream, ElemStats* pStats , int pValues)
{
    if (pValues < kNumberOfOutputValues)
    {
        switch (pValues)
        {
            case 0:	//Condition matched count
                pStream << setprecision(0) << pStats->tNumM;
            break;
            case 1:	//<I> matched
                if (pStats->tNumM == 0)
                    pStream << "NaN";
                else
                    pStream << pStats->tMTotInt/pStats->tNumM;
            break;
            case 2:	//Condition not-matched count
                pStream << pStats->tNumNonM;
            break;
            case 3:	//<I> not matched
                if (pStats->tNumNonM == 0)
                    pStream << "NaN";
                else
                    pStream << pStats->tNonMTotInt/pStats->tNumNonM;
            break;
            case 4:	//%I < 3u(I) 
                if (pStats->tNumNonMLsInt+pStats->tNumNonMGrInt == 0)
                    pStream << "NaN";
                else
                    pStream << (float)100.0f*((float)pStats->tNumNonMLsInt/(float)(pStats->tNumNonMLsInt+pStats->tNumNonMGrInt));
            break;
            case 5:	//Score1
                pStream << pStats->tRating1;
            break;
            case 6:  //Score2
                pStream << pStats->tRating2;
            break;
        }
    }
    return pStream;
}

void Stats::outputRow(int pRow, std::ostream& pStream, const signed char pColumnsToPrint[], const int pNumOfColums,  const int pFirstColumnWidth, const int pOtherColumns)
{
    int tCCount = iConditions->length();
    String tName(iConditions->getName(pRow));
    pStream << pRow << "\n";
    pStream << tName << setw(pFirstColumnWidth-tName.length()) ;
    for (int i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setw(pOtherColumns) << iStats[pColumnsToPrint[i]*tCCount+pRow].tNumM;
        }
        else
        {
            pStream << " " << setw(pOtherColumns) << " ";
        }
    }
    pStream << "\n<I>" << setw(pFirstColumnWidth-3);
    for (int i = 0; i < pNumOfColums; i++)
    {
      //Average int of matched refelections
                if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
                {
                    if (iStats[pColumnsToPrint[i]*tCCount+pRow].tNumM == 0)
                            pStream << " " << setw(pOtherColumns) << "NaN";
                    else
                            pStream << " " << setw(pOtherColumns) << setprecision (4) << iStats[pColumnsToPrint[i]*tCCount+pRow].tMTotInt/iStats[pColumnsToPrint[i]*tCCount+pRow].tNumM;
                }
                else
                {
                    pStream << " " << setw(pOtherColumns) << " ";
                }
    }
    String tEq("==");
    String tNE("<>");
    tName.replace(tEq, tNE);
    pStream << "\n" << tName << setw(pFirstColumnWidth-tName.length());
    for (int i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setw(pOtherColumns) << iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonM;
        }
        else
        {
            pStream << " " << setw(pOtherColumns) << " ";
        }
    }
    pStream << "\n<I>" << setw(pFirstColumnWidth-3);
    for (int i = 0; i < pNumOfColums; i++)
    {	
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            if (iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonM == 0)
                            pStream << " " << setw(pOtherColumns) << "NaN";
            else
                            pStream << " " << setw(pOtherColumns) << setprecision (4) << iStats[pColumnsToPrint[i]*tCCount+pRow].tNonMTotInt/iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonM;	//Ave intensity non-matched.
        }
        else
        {
            pStream << " " << setw(pOtherColumns) << " ";
        }
    }
    pStream << "\n% I < 3u(I)" << setw(pFirstColumnWidth-11);
    for (int i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            float tLess = (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonMLsInt;
            float tGreater = (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonMGrInt;
            if (tLess+tGreater == 0)
                    pStream << " " << setw(pOtherColumns) << "NaN";
            else
                    pStream << " " << setw(pOtherColumns) << setprecision (4) << 100*(tLess/(tLess+tGreater));	//Number Int<3*sigma non-matched
        }
        else
        {
            pStream << " " << setw(pOtherColumns) << " ";
        }
    }
    pStream << "\nScore1" << setw(pFirstColumnWidth-6);
    for (int i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw(pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tRating1;
        }
        else
        {
            pStream << " " << setw(pOtherColumns) << " ";
        }
    }
    pStream << "\nScore2" << setw(pFirstColumnWidth-6);
    for (int i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw(pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tRating2;	
        }
        else
        {
            pStream << " " << setw(pOtherColumns) << " ";
        }
    }
}

void Stats::outputHeadings(std::ostream& pStream, const signed char pColumnsToPrint[], const int pNumOfColums)
{
    pStream << setw(9);
    for (int i = 0; i < pNumOfColums; i++)
    {
        pStream << "" << setw(7) << iHeadings->getName(pColumnsToPrint[i]) << "(" << (int)pColumnsToPrint[i] << ")";
    }
    pStream << "\n";
}

void Stats::calProbs()
{
    int tTotalNum = iConditions->length() * iHeadings->length();
    for (int i = 0; i < tTotalNum; i ++)
    {
        ElemStats* tCurrentStat = &(iStats[i]);
        if (tCurrentStat->iShouldDo)
        {
            float tValue1 = iStats[i].tNonMTotInt/iStats[i].tNumNonM;
            float tValue2 = iStats[i].tMTotInt/iStats[i].tNumM;
            tValue1 = tValue1/(tValue2+tValue1);			//Calculate Ave int non-matched over total.
            
            tCurrentStat->tRating1 = evaluationFunction(tValue1, AbsentAIM, AbsentAISD, PresentAIM, PresentAISD);
            
            tValue1 = (float)iStats[i].tNumNonMGrInt/((float)iStats[i].tNumNonMGrInt+(float)iStats[i].tNumNonMLsInt);
            
            tCurrentStat->tRating2= evaluationFunction(tValue1, Absent3SM, Absent3SSD, Present3SM, Present3SSD);
        }
        else
        {
            tCurrentStat->tRating1 = 0;
            tCurrentStat->tRating1 = 0;
        }
    }
    int tColumns[] = {0};
    handleFilteredData(tColumns, 1);
}

void Stats::handleFilteredData(int pColumns[], int pNumColumns)	//pColumns an array of which columns to check to see if there data has been filtered.
{
    int tCCount = iConditions->length();    //Cache lengths of the table.

    for (int i = 0; i < pNumColumns; i++)
    {
        int tOffset = pColumns[i]*tCCount;
        for (int j = 0; j < tCCount; j++)
        {
            if (iStats[tOffset+j].tNumNonM == 0)
            {
                iStats[tOffset+j].iFiltered = true;
            }
        }
    }
}

std::ostream& outputMatrix(std::ostream& pStream, Matrix<short>* pMatrix)
{
    size_t tXMax = pMatrix->sizeX(), tYMax = pMatrix->sizeY();
    
    for (size_t i = 0; i < tYMax; i++)
    {
        for (size_t j = 0; j < tXMax; j++)
        {
            pStream << pMatrix->getValue(j, i);
            if (j+1 < tXMax || i+1 < tYMax)
            	pStream << " ";
        }
    }
    return pStream;
}

std::ofstream& Stats::output(std::ofstream& pStream, const Table& pTable)
{
    pStream << "TOTAL " << iTotalNum <<"\n";
    pStream << "AVINT " << iTotalIntensity/iTotalNum << "\n";
    
    const int tConditionNum = iConditions->length();
    signed char* tConditions = new signed char[tConditionNum];
    int tCount = pTable.conditionsUsed(tConditions, tConditionNum);
    const int tColumnsNum = iHeadings->length();
    signed char* tColumns = new signed char[tColumnsNum];
    int tColumnCount = pTable.dataUsed(tColumns, tColumnsNum);
    pStream << "NREGIONS " << tColumnCount << "\n";
    for (int i = 0; i< tColumnCount; i++)
    {
        ArrayList<Index>* tHeadings = pTable.getHeadings(i);
        
        for (int j = 0; j < tHeadings->length(); j ++)
        {
            pStream << iHeadings->getID(tHeadings->get(j)->get()) << " ";
            outputMatrix(pStream, iHeadings->getMatrix(tHeadings->get(j)->get()));
            pStream << " " << iHeadings->getName(tHeadings->get(j)->get()) << "\n";
        }
    }
    pStream << "NTESTS " << tCount << "\n";
    for (int i = 0; i < tCount; i++)
    {
        pStream << iConditions->getID(tConditions[i]) << " ";
        outputMatrix(pStream, iConditions->getMatrix(tConditions[i]));
        pStream << " " << iConditions->getMult(tConditions[i]) << " " << iConditions->getName(tConditions[i]) << "\n";
    }
    pStream << "DATA " << tCount*tColumnCount << " " << numberOfOutElementValues() << "\n";
    int tNumOfElemsValues = numberOfOutElementValues();
    for (int i = 0; i < tColumnCount; i++)
    {
        for (int j = 0; j < tCount; j++)
        {
            ElemStats* tElement = &(iStats[tColumns[i]*tConditionNum+tConditions[j]]);
            for (int k=0; k < tNumOfElemsValues; k++)
            {
                outputElementValue(pStream, tElement, k);
                if (i+1 < tColumnCount || j+1 < tCount || k+1 < tNumOfElemsValues)
                    pStream << "\n";
            }
        }
    }
    delete[] tConditions;
    delete[] tColumns;
    return pStream;
}

std::ostream& Stats::output(std::ostream& pStream, const Table& pTable)
{
    pStream << "Total: " << iTotalNum <<"\n";
    pStream << "Average Int: " << iTotalIntensity/iTotalNum << "\n";
    
    const int tConditionNum = iConditions->length();
    signed char* tConditions = new signed char[tConditionNum];
    int tCount = pTable.conditionsUsed(tConditions, tConditionNum);
    const int tColumnsNum = iHeadings->length();
    signed char* tColumns = new signed char[tColumnsNum];
    int tColumnCount = pTable.dataUsed(tColumns, tColumnsNum);
    outputHeadings(pStream, tColumns, tColumnCount);
    for (int i = 0; i < tCount; i++)
    {
        outputRow(tConditions[i], pStream, tColumns, tColumnCount);
        pStream << "\n\n";
    }
    delete tConditions;
    return pStream;
}
