/*
 *  MergedData.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Apr 20 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "MergedData.h"
#include "MathFunctions.h"
#include <math.h>
#include <iostream>
#include <iterator>

/********************************************************/
/* DataMerger											*/
/********************************************************/
DataMerger::DataMerger(const HKLData& pData, const float pUnitCellThreshHold, const LaueGroupRange pLaueGroupRange, const UnitCell& pUnitCell):list<MergedDataResult*>()
{
	LaueGroups* tLaueGroups = new LaueGroups();
	
	for (size_t tCurCrySysID = pLaueGroupRange.location; tCurCrySysID < (size_t)pLaueGroupRange.length+pLaueGroupRange.location; tCurCrySysID++)
	{
		LaueGroup *tCurLaueGroup;
		for (size_t j = 0; (tCurLaueGroup = tLaueGroups->laueGroupAfterFirst((SystemID)tCurCrySysID, j)) != NULL; j ++)
		{
			if (tCurLaueGroup->ratingForUnitCell(pUnitCell) < pUnitCellThreshHold) //If the unit cell fits well enough then do the merge
			{
				std::cout << "Unit cell rating " << tCurLaueGroup->ratingForUnitCell(pUnitCell) << "\n";
				push_back(new MergedDataResult(pData, *tCurLaueGroup, pUnitCell));
			}
		}
	}
}

DataMerger::DataMerger(const HKLData& pData, const SystemID pForLaueGroups[], const unsigned int pNumberOfLaueGroups, const UnitCell& pUnitCell):list<MergedDataResult*>()
{
	LaueGroups* tLaueGroups = new LaueGroups();
	
	for (size_t i = 0; i < pNumberOfLaueGroups; i++)
	{
		LaueGroup *tCurLaueGroup;
		for (size_t j = 0; (tCurLaueGroup = tLaueGroups->laueGroupAfterFirst(pForLaueGroups[i], j)) != NULL; j ++)
		{
			push_back(new MergedDataResult(pData, *tCurLaueGroup, pUnitCell));
		}
	}
	delete tLaueGroups;
}

DataMerger::~DataMerger()
{
	list<MergedDataResult*>::iterator tIterator = begin();
	
	do
	{
		delete (*tIterator);
		(*tIterator) = NULL;
	}
	while (++tIterator != end());
	
}

/*------------------------------------------------*/
/*    mostLikelyCrysSystem						  */
/*  This assumes that all the crystals systems    */
/*  will be in the order of there symmetry.		  */
/*------------------------------------------------*/
SystemID DataMerger::mostLikelyCrysSystem()
{
	list<MergedDataResult*>::iterator tIterator = begin();
	float tDifference =0;
	MergedDataResult *tLast, *tCurrent, *tCurrentBest;
	
	
	tCurrentBest = *tIterator;
	tLast = *tIterator;
	while (++tIterator != end())
	{
		tCurrent = *tIterator;
		float tTempDifference = fabsf(tLast->rFactor() - tCurrent->rFactor());
		if (tTempDifference > tDifference) //If we have found a larger difference than what we had before...
		{
			tDifference = tTempDifference;
			if (tLast->rFactor() < tCurrent->rFactor()) //Save the one with the lowest rfactor
			{
				tCurrentBest = tLast;
			}
			else
			{
				tCurrentBest = tCurrent;
			}
		}
	}
	
	return tCurrentBest->crystalSystem();
}

std::ostream& operator<<(std::ostream& pStream, DataMerger& pMergerResults)
{
	list<MergedDataResult*>::iterator tIter = pMergerResults.begin();
	
	pStream.width(15);
	pStream << "  Laue Group   |    R-Factor   \n";
	do
	{
		pStream.width(13);
		pStream << (*tIter)->laueGroup() << " | ";
		pStream.width(13);
		pStream.precision(4);
		pStream << right << (*tIter)->rFactor() << "\n";
	}
	while (++tIter != pMergerResults.end());
	return pStream;
}

/********************************************************/
/* MergedDataResult									*/
/********************************************************/

MergedDataResult::MergedDataResult(const HKLData& pData, const LaueGroup& pForLaueGroup, const UnitCell& pUnitCell)
{
	const size_t tStrLen = pForLaueGroup.length()+1;
	
	iLaueGroupSymmetry = new char[tStrLen];
	strcpy(iLaueGroupSymmetry, pForLaueGroup.c_str());
	pCrystalSystem = pForLaueGroup.crystalSystem();
	std::cout << "Merging for " << pForLaueGroup << "\n";
	MergedData tMergedData(pData, pForLaueGroup);
	iRFactor = tMergedData.rFactor();
}

MergedDataResult::~MergedDataResult()
{
	delete []iLaueGroupSymmetry;
	iLaueGroupSymmetry = NULL;
}

SystemID MergedDataResult::crystalSystem() const
{
	return pCrystalSystem;
}

char* MergedDataResult::laueGroup() const
{
	return iLaueGroupSymmetry;
}

float MergedDataResult::rFactor()const 
{
	return iRFactor;
}

/********************************************************/
/* MergedData										    */
/********************************************************/
MergedReflections::MergedReflections(float pRFactor, LaueGroup* pLaueGroup, const Matrix<float>& pUnitCellTensor):iLaueGroup(pLaueGroup), iRFactor(pRFactor)
{
	iUnitCellTensor = pUnitCellTensor;
}

float MergedReflections::rFactor()
{
	return iRFactor;
}

LaueGroup *MergedReflections::laueGroup()
{
	return iLaueGroup;
}
		
/********************************************************/
/* MergedData										    */
/********************************************************/

MergedData::MergedData(const HKLData& pHKLs, const LaueGroup& pForLaueGroup, Matrix<short>* pTransformation):iRFactor(-1)
{
	size_t tSize = pHKLs.size();
	iUnsortedReflections = new Reflection[tSize];
	iSortedReflections = new multiset<Reflection*, lsreflection>();
	
	for (size_t i = 0; i < tSize; i++) //Run through all the refelctions adding them
	{
		Reflection* tCurrentReflection = pHKLs[i];
		iUnsortedReflections[i] = (*tCurrentReflection); //Add it to the array.
		Matrix<short> tNewHKL;
		if (pTransformation)
		
			tNewHKL = pForLaueGroup.maxEquivilentHKL((*pTransformation)*(*tCurrentReflection->tHKL));
		else
			tNewHKL = pForLaueGroup.maxEquivilentHKL((*tCurrentReflection->tHKL));
		iUnsortedReflections[i].setHKL(tNewHKL); //Change the HKL value
		iSortedReflections->insert(&(iUnsortedReflections[i])); //Add to the the tree
	}
}

void MergedData::mergeReflections(HKLData& pReflections) //Returns the merged reflections in pHKLs
{
	static Matrix<short>* tCurHKL;
	multiset<Reflection*, lsreflection>::iterator tIter; //Start at the first 
	register float tIntSum = 0;                              //Total intensity
	register float tSUSum = 0;								//Total Standard uncertainty 
	register long tCount = 0;
	
	tCurHKL = (*iSortedReflections->begin())->tHKL; //Save the pointer to the current hkl value
	for (tIter = iSortedReflections->begin(); tIter != iSortedReflections->end(); tIter++) //Run through all the reflections
	{		
		if (!((*(*tIter)->tHKL) == (*tCurHKL))) //If the HKL value has changed then 
		{
			pReflections.push_back(new Reflection((*tCurHKL), tIntSum/tCount, tSUSum/tCount));
			tCurHKL = (*tIter)->tHKL; //Save the next hkl value
			tIntSum = 0;
			tSUSum = 0;
			tCount = 0;
		}
		tIntSum += (*tIter)->i;
		tSUSum += (*tIter)->iSE;
		tCount ++;
	}//Move on to the next reflection in the list.
	if (tCount > 0)
	{
		pReflections.push_back(new Reflection((*tCurHKL), tIntSum/tCount, tSUSum/tCount));
	}
}

MergedData::~MergedData()
{
	delete[] iUnsortedReflections;
	iUnsortedReflections = NULL;
	delete iSortedReflections;
	iSortedReflections = NULL;
}

/*
 * Calculates the sum of the abs differences in an array of floats.
 */
float JJsumdiff(Array<float>& pValues, float pMean)
{
    float tTotal = 0;
    
    for (size_t i = 0; i < pValues.size(); i++)
    {
        tTotal += fabsf(pMean - pValues[i]);
    }
    return tTotal;
}

float MergedData::rFactor() 
{
	static Matrix<short>* tCurHKL;
	static Array<float> tValues(23);                //I don't think that this should need to be any greater then 23 elements long.
	tValues.clear();                                //Clear the values from the last time they were used.
	multiset<Reflection*, lsreflection>::iterator tIter;//Start at the first 
	register float tSumSum = 0;                              //Make sure that every thing is set to 0
	register float tMeanDiffSum = 0;
	register float tSum = 0;
	
	size_t tNumMerged = 0, tNumResRef=0;
	//cout << gLaueGroup << "\n";
	tIter = iSortedReflections->begin();
	tCurHKL = (*tIter)->tHKL; //Save the pointer to the current hkl value
	for (; tIter != iSortedReflections->end(); tIter++) // iterator through the list of reflections
	{
		if (  !((*(*tIter)->tHKL) == (*tCurHKL))) //If the HKL value has changed then 
		{
			if (tValues.size()>1) //As long as there are more then one reflection
			{
				tNumMerged += tValues.size();  
				tSum = fabsf(sum(tValues.getPointer(), 0.0f, tValues.size()));
				tSumSum += tSum;
				tMeanDiffSum += JJsumdiff(tValues, tSum/tValues.size());
			}
			tCurHKL = (*tIter)->tHKL; //Save the next hkl value
			tValues.clear();   //Remove all the old intensities
			tNumResRef  ++;
		}
		tValues.add((*tIter)->i);  //Save the intensity
	}

	if (tSumSum == 0)
		iRFactor = 0;
	else
		iRFactor = tMeanDiffSum/tSumSum; //In the desciption this is multiplied by
//But as these values are for comparison there isn't much point
	return iRFactor;
}
