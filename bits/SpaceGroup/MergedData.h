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

class JJMergedDataResult
{
	protected:
		SystemID pCrystalSystem;
		char* iLaueGroupSymmetry;
		float iRFactor;
	public:
		JJMergedDataResult(const HKLData& pData, const JJLaueGroup& pForLaueGroup, const UnitCell& pUnitCell);
		~JJMergedDataResult();
		SystemID crystalSystem() const;
		char* laueGroup() const;
		float rFactor() const;
};

class MergedReflections:public HKLData
{
	protected:
		JJLaueGroup* iLaueGroup; //reference. not to be released.
		float iRFactor;
	public:
		MergedReflections(float pRFactor, JJLaueGroup* pLaueGroup);
		float rFactor();
		JJLaueGroup *laueGroup();
};

class JJMergedData
{
	protected:
		multiset<Reflection*, lsreflection>* iSortedReflections;
		Reflection* iUnsortedReflections;
		float iRFactor;
	public:
		JJMergedData(const HKLData& pHKLs, const JJLaueGroup& pForLaueGroup, Matrix<short>* pTransformation = NULL);
		~JJMergedData();
		void mergeReflections(HKLData& pReflections); //Returns the merged reflections in pHKLs
		float rFactor();
};



class DataMerger:public list<JJMergedDataResult*>
{
	public:
		DataMerger(const HKLData& pData, const float pUnitCellThreshHold, const LaueGroupRange pLaueGroupRange, const UnitCell& pUnitCell);
		DataMerger(const HKLData& pData, const SystemID pForLaueGroups[], const unsigned int pNumberOfLaueGroups, const UnitCell& pUnitCell);
		~DataMerger();
		SystemID mostLikelyCrysSystem();
};

std::ostream& operator<<(std::ostream& pStream, DataMerger& pMergerResults);
#endif
