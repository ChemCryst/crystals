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

struct lsreflection
{
    bool operator()(const Reflection& pReflection1, const Reflection& pReflection2) const
    {
        Matrix<short>* tHKL1 = pReflection1.getHKL();
        Matrix<short>* tHKL2 = pReflection2.getHKL();
        if (tHKL1->getValue(0) < tHKL2->getValue(0))
            return true;
        else if (tHKL1->getValue(0) > tHKL2->getValue(0))
            return false;
        else
        {
            if (tHKL1->getValue(1) < tHKL2->getValue(1))
                return true;
            else if (tHKL1->getValue(1) > tHKL2->getValue(1))
                return false;
            else
            {
                if (tHKL1->getValue(2) < tHKL2->getValue(2))
                    return true;
                else
                    return false;
            }
        }
    }
};

class MergedData
{
    private:
        multiset<Reflection, lsreflection>* tSortedReflections;
        Reflection equivalentise(const Reflection& pReflection, const Matrix<float>* pMatrice[], const int pNumOfMat);
    public:
        MergedData(const HKLData& pData, const Matrix<float>* pMatrice[], const int pNumOfMat);
        ~MergedData();
};