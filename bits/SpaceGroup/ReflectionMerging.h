/*
 *  ReflectionMerging.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jul 16 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __REFLECTION_MERGING_H__
#define __REFLECTION_MERGING_H__
#include "HKLData.h"
#include "RunParameters.h"
#include "UnitCell.h"

#include <set>
#include <vector>

using namespace std;

typedef unsigned int SystemRef;

struct lsreflection
{
  bool operator()(const Reflection* pReflection1, const Reflection* pReflection2) const
  {
      Matrix<short>* tHKL1 = pReflection1->getHKL();
      Matrix<short>* tHKL2 = pReflection2->getHKL();
      int tValue = tHKL1->bytecmp(*tHKL2);
      if (tValue > 0)
      {
	  return true;
      }
      return false;
  }
};

class MergedData
{
 private:
    multiset<Reflection*, lsreflection>* iSortedReflections;
    size_t iNumRefl;
    size_t iUpto;
    Reflection** iReflections;
    float iRFactor;
   //void equivalentise(const Reflection& pReflection, Array<unsigned short>& pMatIndices, Reflection* pResult)const; 
         
    float calculateRFactor();
 public:
    MergedData(const size_t pNumRefl);
    ~MergedData();
    void releaseReflections();
//    MergedData(const MergedData& pMergedData);//Copy constructure
    void add(const Matrix<short>& pHKL, const Reflection& pRefl);
    //static char* getCrystalSystem(RunParameters& pRunParams, HKLData& pHKL);
    inline float getRFactor()
        {
            if (iRFactor == -1)
                return calculateRFactor();
            return iRFactor;
        }
    std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, MergedData& tData);

class LaueGroups
{
private:
    class LaueGroup;
    Array<LaueGroup*>* iGroups;
    
    Array<unsigned short>& getGroupIndice(const unsigned int pSystemRef, const unsigned short pGroupNum) const;
 public:
    enum systemID
    {
      kTriclinicID = 0,
      kMonoclinicAID,
      kMonoclinicBID,
      kMonoclinicCID,
      kOrtharombicID,
      kTetragonalID,
      kTrigonalID,
      kHexagonalID,
      kCubicID,
      };
    LaueGroups();
    SystemRef getSystemRef(unsigned short* pNumGroup, const LaueGroups::systemID pSystemID) const; //Returns a reference to the first system LaueGroup and the number of groups for that system in pNumGroups
    void mergeSystemGroup(const HKLData& pHKLData, const SystemRef pSystemRef, const unsigned short pGroupID, const RunParameters& pRunPara);
    void releaseMemoryFor(const SystemRef pSystemRef, const unsigned short pGroupID);
    static LaueGroups::systemID unitCellID2LaueGroupID(const UnitCell::systemID pID);
    static UnitCell::systemID laueGroupID2UnitCellID(LaueGroups::systemID pID);
    LaueGroups::systemID getCrystalSystemFor(const SystemRef pSystemRef);
    void mergeForAll(const HKLData& pHKLs, const bool pThrowRefl, const RunParameters& pRunParam)const;
    LaueGroups::systemID guessSystem(const HKLData& pHKLs, const RunParameters& pRunParam);
    size_t count();
    ~LaueGroups();
    std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, LaueGroups& tData);
#endif