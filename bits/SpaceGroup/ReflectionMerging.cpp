/*
 *  ReflectionMerging.cpp
 *  Space Groups
 *
 *  Created by Stefan on Wed Jul 16 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#include "ReflectionMerging.h"
#include <Math.h>

MergedData::MergedData(const HKLData& pData, const Matrix<float>* pMatrice[], const int pNumOfMat)
{
    long tReflNum = pData.numberOfReflections();
    tSortedReflections = new multiset<Reflection, lsreflection>();
    for (int i = 0; i < tReflNum; i++)
    {
        Reflection tNewReflection = equivalentise(*pData.getReflection(i), pMatrice, pNumOfMat);
        tSortedReflections->insert(tNewReflection);
    }
}

MergedData::~MergedData()
{
    if (tSortedReflections)
    {
        delete tSortedReflections;
        tSortedReflections = NULL;
    }
}

bool greaterHKL(Matrix<float> pMat1, Matrix<float> pMat2)
{
    float tDelta = pMat1.getValue(0) - pMat2.getValue(0);
    if (tDelta > 0)
        return true;
    else if (tDelta == 0)
    {
        tDelta = pMat1.getValue(1) - pMat2.getValue(1);
        if (tDelta > 0)
            return true;
        else if (tDelta == 0)
        {
            tDelta = pMat1.getValue(2) - pMat2.getValue(2);
            if (tDelta > 0)
                return true;
        }
    }
    return false;
}

Reflection MergedData::equivalentise(const Reflection& pReflection, const Matrix<float>* pMatrice[], const int pNumOfMat)
{
    Matrix<float> tMaxHKL;
    tMaxHKL = *(pReflection.getHKL());
    Matrix<float> tCurrentHKL;
    tCurrentHKL = *(pReflection.getHKL());
    Matrix<float> tTempHKL;
    tTempHKL = *(pReflection.getHKL());
    Matrix<float> tZero = Matrix<float>(3, 1, 0.0f);
    
    for (int i = 0; i < pNumOfMat; i++)
    {
        tTempHKL = tCurrentHKL * (Matrix<float>&)(*(pMatrice[i]));
        for (int j = 0; j < 1; j++)
        {
            if (greaterHKL(tTempHKL, tMaxHKL))
            {
                tMaxHKL = tTempHKL;
            }
            tTempHKL = tZero - tTempHKL;
        }
    }
    Reflection tReflection(pReflection);
    Matrix<short> tNewHKL(3, 1);
    tNewHKL = tMaxHKL;
    tReflection.setHKL(tNewHKL);
    return tReflection;
}