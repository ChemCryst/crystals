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
#include "StringClasses.h"
#include <iomanip>
#include <math.h>

//Average Int
static float AbsentAIM = 0.00834789f;
static float AbsentAISD = 0.01289479f;
static float PresentAIM = 0.49585336f;
static float PresentAISD = 0.16645043f;
//Num Int < 3sigma
/* Old from when the second ratting only used the matched values
static float Absent3SM = 0.00360566f;
static float Absent3SSD = 0.00859224f;
static float Present3SM = 0.63777005f;
static float Present3SSD = 0.21934966f;*/
//Num Matched Int > 3sigma + Num Not Matched Int <= 3sigma
static float Absent3SM = 0.11234f;
static float Absent3SSD = 0.079361f;
static float Present3SM = 0.46642f;
static float Present3SSD = 0.079361f;

Stats::Stats(Regions* pRegions, Conditions* pConditions):iRegions(pRegions), iConditions(pConditions)
{
    iStats = new ElemStats[pRegions->size()*pConditions->size()];
    bzero((void*)iStats, sizeof(ElemStats)*pRegions->size()*pConditions->size());
    setShouldDos(pRegions, pConditions);
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

void Stats::setShouldDos(Regions* pRegions, Conditions* pConditions)
{
    size_t tRegionCount = pRegions->size();
    size_t tCondCount = pConditions->size();
    
    for (size_t i = 0; i < tCondCount; i++)	//Conditions
    {
        Matrix<short>* tConditionMat = pConditions->getMatrix(i);
        for (size_t j = 0; j < tRegionCount; j++) //Regions.
        {
            Matrix<short>* tRegionMat = pRegions->getMatrix(j);
            Matrix<short> tResult(3, 1);
            Matrix<short> tZeros(3, 1, (short)0);
            tConditionMat->mul(*tRegionMat, tResult);
            iStats[(j*tCondCount)+i].iShouldDo = !tZeros.operator==(tResult);
        }
    }
}

void Stats::addReflectionRows(const size_t pColumn, Reflection* pReflection, Matrix<short>& pHKL)	//Goes through the rows down the specified Column adding the reflection to the stats.
{
    static Matrix<short> tMatrix(1, 1);
    
    size_t tCCount = iConditions->size();    //Cache lengths of the table.
    for (size_t i= 0; i < tCCount; i++)
    {
        Matrix<short>* tMultiMat = NULL;
        tMultiMat = iConditions->getMatrix(i);
        tMultiMat->mul(pHKL, tMatrix);
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
			if (pReflection->i/pReflection->iSE >= 3)
            {
                tStats->tNumMGrInt ++;	//Number Int>=3*sigma non-matched
            }
            else
            {
                tStats->tNumMLsInt ++;
            }
        }
    }
}

ElemStats* Stats::getElem(const size_t pHeadIndex, const size_t pCondIndex) const
{
    size_t tCCount = iConditions->size();    //Cache lengths of the table.
    return &(iStats[(pHeadIndex*tCCount)+pCondIndex]);
}

void Stats::addReflection(Reflection* pReflection, LaueGroup &pLaueGroup)
{
    static Matrix<short> tResult(1, 3);
    iTotalNum ++;
    iTotalIntensity += (float)pReflection->i;	
    size_t tHCount = iRegions->size();			//Cache lengths of the table.
    Matrix<short>* tHKLMat = pReflection->getHKL();	//Get the HKL matrix from the reflection.
	
    for (size_t i = 0; i < tHCount; i++)			//Go through Columns in the table.
    {
		Matrix<short> tNewHKL;
		if ((*iRegions)[i]->contains(*tHKLMat, pLaueGroup, tNewHKL))
		{
			addReflectionRows(i, pReflection, tNewHKL);
		}
    }
}

void Stats::addReflections(HKLData &pHKLs, LaueGroup &pLaueGroup)
{
	vector<Reflection*>::iterator tIter;

    for (tIter = pHKLs.begin(); tIter != pHKLs.end(); tIter++)
    {
        addReflection((*tIter), pLaueGroup);
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
                    pStream << (pStats->tNonMTotInt/pStats->tNumNonM);
            break;
            case 4:	//%I < 3u(I) not matched
                if (pStats->tNumNonMLsInt+pStats->tNumNonMGrInt == 0)
                    pStream << "NaN";
                else
                    pStream << (float)100.0f*((float)pStats->tNumNonMLsInt/(float)(pStats->tNumNonMLsInt+pStats->tNumNonMGrInt));
            break;
			case 5:	//%I >= 3u(I) matched
                if (pStats->tNumMLsInt+pStats->tNumMGrInt == 0)
                    pStream << "NaN";
                else
                    pStream << (float)100.0f*((float)pStats->tNumMGrInt/(float)(pStats->tNumMLsInt+pStats->tNumMGrInt));
            break;
            case 6:	//Score1
                pStream << pStats->tRating1;
            break;
            case 7:  //Score2
                pStream << pStats->tRating2;
            break;
			//case 7:
				
        }
    }
    return pStream;
}

void Stats::outputRow(const size_t pRow, std::ostream& pStream, const signed char pColumnsToPrint[], const size_t pNumOfColums,  const size_t pFirstColumnWidth, const size_t pOtherColumns)
{
    size_t tCCount = iConditions->size();
    String tName(iConditions->getName(pRow));
    pStream << (uint)pRow << "\n";
    pStream << tName << setw((uint)pFirstColumnWidth-tName.length()) ;
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setw((uint)pOtherColumns) << iStats[pColumnsToPrint[i]*tCCount+pRow].tNumM;
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
    pStream << "\n<I>" << setw((uint)pFirstColumnWidth-3);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
      //Average int of matched refelections
                if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
                {
                    if (iStats[pColumnsToPrint[i]*tCCount+pRow].tNumM == 0)
                            pStream << " " << setw((uint)pOtherColumns) << "NaN";
                    else
                            pStream << " " << setw((uint)pOtherColumns) << setprecision (4) << iStats[pColumnsToPrint[i]*tCCount+pRow].tMTotInt/iStats[pColumnsToPrint[i]*tCCount+pRow].tNumM;
                }
                else
                {
                    pStream << " " << setw((uint)pOtherColumns) << " ";
                }
    }
    String tEq("==");
    String tNE("<>");
    tName.replace(tEq, tNE);
    pStream << "\n" << tName << setw((uint)pFirstColumnWidth-tName.length());
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setw((uint)pOtherColumns) << iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonM;
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
    pStream << "\n<I>" << setw((uint)pFirstColumnWidth-3);
    for (size_t i = 0; i < pNumOfColums; i++)
    {	
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            if (iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonM == 0)
				pStream << " " << setw((uint)pOtherColumns) << "NaN";
            else
				pStream << " " << setw((uint)pOtherColumns) << setprecision (4) << (iStats[pColumnsToPrint[i]*tCCount+pRow].tNonMTotInt/iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonM);	//Ave intensity non-matched.
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
    pStream << "\n% I < 3u(I)" << setw((uint)pFirstColumnWidth-11);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            float tLess = (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonMLsInt;
            float tGreater = (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonMGrInt;
            if (tLess+tGreater == 0)
                    pStream << " " << setw((uint)pOtherColumns) << "NaN";
            else
                    pStream << " " << setw((uint)pOtherColumns) << setprecision (4) << 100*(tLess/(tLess+tGreater));	//Number Int<3*sigma non-matched
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
    pStream << "\nScore1" << setw((uint)pFirstColumnWidth-6);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw((uint)pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tRating1;
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
	pStream << "\nMatch >=" << setw((uint)pFirstColumnWidth-8);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw((uint)pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumMGrInt;	
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
	pStream << "\nMatch <" << setw((uint)pFirstColumnWidth-7);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw((uint)pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumMLsInt;	
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
	pStream << "\nNot Match >=" << setw((uint)pFirstColumnWidth-12);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw((uint)pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonMGrInt;	
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
	pStream << "\nNot Match <" << setw((uint)pFirstColumnWidth-11);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw((uint)pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tNumNonMLsInt;	
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
	pStream << "\nScore2" << setw((uint)pFirstColumnWidth-6);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        if (iStats[pColumnsToPrint[i]*tCCount+pRow].iShouldDo)
        {
            pStream << " " << setprecision (4) << setw((uint)pOtherColumns) << (float)iStats[pColumnsToPrint[i]*tCCount+pRow].tRating2;	
        }
        else
        {
            pStream << " " << setw((uint)pOtherColumns) << " ";
        }
    }
}

void Stats::outputRegions(std::ostream& pStream, const signed char pColumnsToPrint[], const size_t pNumOfColums)
{
    pStream << setw(9);
    for (size_t i = 0; i < pNumOfColums; i++)
    {
        pStream << "" << setw(7) << iRegions->getName(pColumnsToPrint[i]) << "(" << (int)pColumnsToPrint[i] << ")";
    }
    pStream << "\n";
}

void Stats::calProbs()
{
    size_t tTotalNum = iConditions->size() * iRegions->size();
    for (size_t i = 0; i < tTotalNum; i ++)
    {
        ElemStats* tCurrentStat = &(iStats[i]);
        if (tCurrentStat->iShouldDo)
        {
            float tValue1 = iStats[i].tNonMTotInt/iStats[i].tNumNonM;
            float tValue2 = iStats[i].tMTotInt/iStats[i].tNumM;
			
			float tRating1 = (tValue1)/(tValue2+tValue1);
		//	float tRating2 = (float)iStats[i].tNumNonMGrInt/(float)iStats[i].tNumNonM;
		//	float tRating3 = (float)iStats[i].tNumMLsInt/(float)iStats[i].tNumM;
			float tRating2 = ((float)iStats[i].tNumMLsInt+(float)iStats[i].tNumNonMGrInt)/(float)(iStats[i].tNumNonM+iStats[i].tNumM);

			
		/*	if ((tValue2+tValue1) != 0 && (iStats[i].tNumNonMGrInt+iStats[i].tNumNonMLsInt) != 0 
				&& (iStats[i].tNumMGrInt+iStats[i].tNumMLsInt) != 0)
					std::cerr << evaluationFunction(tRating1, AbsentAIM, AbsentAISD, PresentAIM, PresentAISD) << "\t" << tRating1 << "\t" << tRating2 << "\t" << tRating3 << "\t" << tRating4 << "\n";*/
				
            tCurrentStat->tRating1 = evaluationFunction(tRating1, AbsentAIM, AbsentAISD, PresentAIM, PresentAISD);
            tCurrentStat->tRating2= evaluationFunction(tRating2, Absent3SM, Absent3SSD, Present3SM, Present3SSD);
			//tCurrentStat->tRating3= evaluationFunction(tRating4, Absent3SM, Absent3SSD, Present3SM, Present3SSD);
        }
        else
        {
            tCurrentStat->tRating1 = 0;
            tCurrentStat->tRating2 = 0;
        }
    }
    int tColumns[] = {0};
    handleFilteredData(tColumns, 1);
}

void Stats::handleFilteredData(int pColumns[], size_t pNumColumns)	//pColumns an array of which columns to check to see if there data has been filtered.
{
    size_t tCCount = iConditions->size();    //Cache lengths of the table.

    for (size_t i = 0; i < pNumColumns; i++)
    {
        size_t tOffset = pColumns[i]*tCCount;
        for (size_t j = 0; j < tCCount; j++)
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
    
    const size_t tConditionNum = iConditions->size();
    signed char* tConditions = new signed char[tConditionNum];
    size_t tCount = pTable.conditionsUsed(tConditions, tConditionNum);
    const size_t tColumnsNum = iRegions->size();
    signed char* tColumns = new signed char[tColumnsNum];
    size_t tColumnCount = pTable.dataUsed(tColumns, tColumnsNum);
    pStream << "NREGIONS " << (uint)tColumnCount << "\n";
    for (size_t i = 0; i< tColumnCount; i++)
    {
        vector<Index>* tRegions = pTable.getRegions(i);
        
        for (size_t j = 0; j < tRegions->size(); j ++)
        {
			signed char tIndex = (*tRegions)[j].get();
            pStream << iRegions->getID(tIndex) << " ";
            outputMatrix(pStream, iRegions->getMatrix(tIndex));
            pStream << " " << iRegions->getName(tIndex) << "\n";
        }
    }
    pStream << "NTESTS " << (uint)tCount << "\n";
    for (size_t i = 0; i < tCount; i++)
    {
        pStream << iConditions->getID(tConditions[i]) << " ";
        outputMatrix(pStream, iConditions->getMatrix(tConditions[i]));
        pStream << " " << iConditions->getMult(tConditions[i]) << " " << iConditions->getName(tConditions[i]) << "\n";
    }
    pStream << "DATA " << (uint)tCount*tColumnCount << " " << (uint)numberOfOutElementValues() << "\n";
    size_t tNumOfElemsValues = numberOfOutElementValues();
    for (size_t i = 0; i < tColumnCount; i++)
    {
        for (size_t j = 0; j < tCount; j++)
        {
            ElemStats* tElement = &(iStats[tColumns[i]*tConditionNum+tConditions[j]]);
            for (size_t k=0; k < tNumOfElemsValues; k++)
            {
                outputElementValue(pStream, tElement, (int)k);
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
    
    const size_t tConditionNum = iConditions->size();
    signed char* tConditions = new signed char[tConditionNum];
    size_t tCount = pTable.conditionsUsed(tConditions, tConditionNum);
    const size_t tColumnsNum = iRegions->size();
    signed char* tColumns = new signed char[tColumnsNum];
    size_t tColumnCount = pTable.dataUsed(tColumns, tColumnsNum);
    outputRegions(pStream, tColumns, tColumnCount);
    for (size_t i = 0; i < tCount; i++)
    {
        outputRow(tConditions[i], pStream, tColumns, tColumnCount);
        pStream << "\n\n";
    }
    delete tConditions;
    return pStream;
}
