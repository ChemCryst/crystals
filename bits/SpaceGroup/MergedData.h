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

/*!
 * @class MergedDataResult 
 * @description Not yet documented.
 * @abstract
*/
class MergedDataResult
{
	protected:
		SystemID pCrystalSystem;
		char* iLaueGroupSymmetry;
		float iRFactor;
	public:
		MergedDataResult(const HKLData& pData, const LaueGroup& pForLaueGroup, const UnitCell& pUnitCell);
		~MergedDataResult();

		/*!
		 * @function crystalSystem 
		 * @description Not yet documented.
		 * @abstract
		 */
		SystemID crystalSystem() const;

		/*!
		 * @function laueGroup 
		 * @description Not yet documented.
		 * @abstract
		 */
		char* laueGroup() const;

		/*!
		 * @function rFactor 
		 * @description Not yet documented.
		 * @abstract
		 */
		float rFactor() const;
};

/*!
 * @class MergedReflections 
 * @description Not yet documented.
 * @abstract
*/
class MergedReflections:public HKLData
{
	protected:
		LaueGroup* iLaueGroup; //reference. not to be released.
		float iRFactor;
	public:
		MergedReflections(float pRFactor, LaueGroup* pLaueGroup, const Matrix<float>& pUnitCellTensor);

		/*!
		 * @function rFactor 
		 * @description Not yet documented.
		 * @abstract
		 */
		float rFactor();
		
		/*!
		 * @function laueGroup 
		 * @description Not yet documented.
		 * @abstract
		 */
		LaueGroup *laueGroup();
};

/*!
 * @class MergedData 
 * @description Not yet documented.
 * @abstract
*/
class MergedData
{
	protected:
		multiset<Reflection*, lsreflection>* iSortedReflections;
		Reflection* iUnsortedReflections;
		float iRFactor;
	public:
		MergedData(const HKLData& pHKLs, const LaueGroup& pForLaueGroup, Matrix<short>* pTransformation = NULL);
		~MergedData();

		/*!
		 * @function mergeReflections 
		 * @description Not yet documented.
		 * @abstract
		 */
		void mergeReflections(HKLData& pReflections); //Returns the merged reflections in pHKLs

		/*!
		 * @function rFactor 
		 * @description Not yet documented.
		 * @abstract
		 */
		float rFactor();
};



/*!
 * @class DataMerger 
 * @description Not yet documented.
 * @abstract
*/
class DataMerger:public list<MergedDataResult*>
{
	public:
		DataMerger(const HKLData& pData, const float pUnitCellThreshHold, const LaueGroupRange pLaueGroupRange, const UnitCell& pUnitCell);
		DataMerger(const HKLData& pData, const SystemID pForLaueGroups[], const unsigned int pNumberOfLaueGroups, const UnitCell& pUnitCell);
		~DataMerger();

		/*!
		 * @function mostLikelyCrysSystem 
		 * @description Not yet documented.
		 * @abstract
		 */
		SystemID mostLikelyCrysSystem();
};

std::ostream& operator<<(std::ostream& pStream, DataMerger& pMergerResults);
#endif
