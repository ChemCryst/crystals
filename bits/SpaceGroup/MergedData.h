/*
 *  MergedData.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Apr 20 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __MERGED_DATE_H__
#define __MERGED_DATA_H__
#include "LaueClasses.h"
#include "HKLData.h"
#include <set>
#include <list>

class MergedDataResult
{
	protected:
		SystemID pCrystalSystem;
		char* iLaueGroupSymmetry;
		float iRFactor;
	public:
		MergedDataResult(const HKLData& pData, const LaueGroup& pForLaueGroup, const UnitCell& pUnitCell);
		~MergedDataResult();
		SystemID crystalSystem() const;
		char* laueGroup() const;
		float rFactor() const;
};

class MergedReflections:public HKLData
{
	protected:
		LaueGroup* iLaueGroup; //reference. not to be released.
		float iRFactor;
	public:
		MergedReflections(float pRFactor, LaueGroup* pLaueGroup, const Matrix<float>& pUnitCellTensor);
		float rFactor();
		LaueGroup *laueGroup();
};

class MergedData
{
	protected:
		multiset<Reflection*, lsreflection>* iSortedReflections;
		Reflection* iUnsortedReflections;
		float iRFactor;
	public:
		MergedData(const HKLData& pHKLs, const LaueGroup& pForLaueGroup, Matrix<short>* pTransformation = NULL);
		~MergedData();
		void mergeReflections(HKLData& pReflections); //Returns the merged reflections in pHKLs
		float rFactor();
};



class DataMerger:public list<MergedDataResult*>
{
	public:
		DataMerger(const HKLData& pData, const float pUnitCellThreshHold, const LaueGroupRange pLaueGroupRange, const UnitCell& pUnitCell);
		DataMerger(const HKLData& pData, const SystemID pForLaueGroups[], const unsigned int pNumberOfLaueGroups, const UnitCell& pUnitCell);
		~DataMerger();
		SystemID mostLikelyCrysSystem();
};

std::ostream& operator<<(std::ostream& pStream, DataMerger& pMergerResults);
#endif
