/*
 *  ReflectionMerging.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jul 16 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#include "HKLData.h"
#include <set>
#include <vector>

using namespace std;

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
    void equivalentise(const Reflection& pReflection, Array<unsigned short>& pMatIndices, Reflection* pResult)const; 
    float iRFactor;
 public:
    MergedData(const HKLData& pData, Array<unsigned short>& pMatIndices);
    MergedData(const MergedData& pMergedData);//Copy constructure;
    std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, MergedData& tData);

#define SystemRef unsigned int

class LaueGroups
{
private:
#define kTriclinicID 1
#define kMonoclinicBID 2
#define kOrtharombicID 3
#define kTetragonalID 4
#define kTrigonalID 5
#define kHexagonalID 6
#define kCubicID 7
    
    class LaueGroup;
    Array<LaueGroup*>* iGroups;
 public:
    LaueGroups();
    unsigned int getSystemRef(unsigned short* pNumGroup, const unsigned short pSystemID) const; //Returns a reference to the first system LaueGroup and the number of groups for that system in pNumGroups
    MergedData mergeSystemGroup(const HKLData& pHKLData, const unsigned short pSystem, const unsigned short pGroup) const;
    Array<unsigned short>& getGroupIndice(const unsigned int pSystemRef, const unsigned short pGroupNum) const;
    ~LaueGroups();
};
