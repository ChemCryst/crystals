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
        void equivalentise(const Reflection& pReflection, vector<Matrix<short>*>& pMatrice, Reflection* pResult);
        float iRFactor;
    public:
        MergedData(const HKLData& pData, vector<Matrix<short>*>& pMatrice);
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, MergedData& tData);