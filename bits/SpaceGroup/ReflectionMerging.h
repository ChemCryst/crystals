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
#include "LaueClasses.h"

#include <set>
#include <vector>

using namespace std;

typedef unsigned int SystemRef;

class MergedData:public MyObject
{
 private:
    size_t iUpto;
    float iRFactor;
    float calculateRFactor();
 public:
    MergedData(const size_t pNumRefl);
    ~MergedData();
    static void releaseReflections();
    void add(const Matrix<short>& pHKL, const Reflection& pRefl);
    inline float getRFactor()
        {
            if (iRFactor == -1)
                return calculateRFactor();
            return iRFactor;
        }
    std::ostream& output(std::ostream& pStream) const;
};

std::ostream& operator<<(std::ostream& pStream, const MergedData& tData);

class LaueGroups
{
private:
    class LaueGroup;
    Array<LaueGroup*>* iGroups;
    
    Array<unsigned short>& getGroupIndice(const unsigned int pSystemRef, const unsigned short pGroupNum) const;
 public:
    LaueGroups();
    SystemRef getSystemRef(unsigned short* pNumGroup, const SystemID pSystemID) const; //Returns a reference to the first system LaueGroup and the number of groups for that system in pNumGroups
    void mergeSystemGroup(const HKLData& pHKLData, const SystemRef pSystemRef, const unsigned short pGroupID, const RunParameters& pRunPara);
    static SystemID unitCellID2LaueGroupID(const SystemID pID);
    static SystemID laueGroupID2UnitCellID(SystemID pID);
    SystemID getCrystalSystemFor(const SystemRef pSystemRef);
    bool mergeForAll(const HKLData& pHKLs, const bool pThrowRefl, const RunParameters& pRunParam)const;
    SystemID guessSystem(const HKLData& pHKLs, const RunParameters& pRunParam);
    size_t count();
    ~LaueGroups();
    std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, LaueGroups& tData);
#endif