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
#include <iostream>
#include <iterator.h>
#include "MathFunctions.h"

/*Matrices
Triclinic
[1, 0, 0]
[0, 1, 0]
[0, 0, 1]

MonoclinicA
2/m 1 1
[1, 0, 0]
[0, -1, 0]
[0, 0, -1]

MonoclinicB
1 2/m 1
[-1, 0, 0]
[0, 1, 0]
[0, 0, -1]

MonoclinicC
1 1 2/m
[-1, 0, 0]
[0, -1, 0]
[0, 0, 1]

Ortharombic
2/m 2/m 2/m
[-1, 0, 0]	[1, 0, 0]	[-1, 0, 0]
[0, 1, 0]	[0, -1, 0]	[0, -1, 0]
[0, 0, 1]	[0, 0, 1]	[0, 0, 1]

Tetragonal
4/m
[0, -1, 0]	[-1, 0, 0]	[0, 1, 0]
[1, 0, 0]	[0, -1, 0]	[-1, 0, 0]
[0, 0, -1]	[0, 0, 1]	[0, 0, 1]
4/m m m
[0, -1, 0]	[-1, 0, 0]	[-1, 0, 0] 	[0, 1, 0]	[0, 1, 0]	[1, 0, 0]
[1, 0, 0]	[0, -1, 0]	[0, 1, 0]	[-1, 0, 0]	[1, 0, 0]	[0, -1, 0]
[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]

[0, -1, 0]
[-1, 0, 0]
[0, 0, 1]

Trigonal
-3
[0, -1, 0]	[-1, 1, 0]
[1, -1, 0]	[-1, 0, 0]
[0, 0, 1]	[0, 0, 1]

-3 m 1
[0, -1, 0]	[-1, 1, 0]	[-1, 1, 0]	[1, 0, 0]	[0, -1, 0]
[1, -1, 0]	[-1, 0, 0]	[0, 1, 0]	[1, -1, 0]	[-1, 0, 0]
[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]

-3 1 m
[0, -1, 0]	[-1, 1, 0]	[0, 1, 0]	[1, -1, 0]	[-1, 0, 0]
[1, -1, 0]	[-1, 0, 0]	[1, 0, 0]	[0, -1, 0]	[-1, 1, 0]
[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]

Hexagonal
6/m
[1, -1, 0]	[0, -1, 0]	[-1, 0, 0]	[-1, 1, 0]	[0, 1, 0]
[1, 0, 0]	[1, -1, 0]	[0, -1, 0]	[-1, 1, 0]	[-1, 1, 0]
[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]

6/m m m
[1, -1, 0]	[0, -1, 0]	[-1, 0, 0]	[-1, 1, 0]	[0, 1, 0]	[-1, 1, 0]
[1, 0, 0]	[1, -1, 0]	[0, -1, 0]	[-1, 0, 0]	[-1, 1, 0]	[0, 1, 0]
[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]

[0, 1, 0]	[1, 0, 0]	[1, -1, 0]	[0, -1, 0]	[-1, 0, 0]
[1, 0, 0]	[1, -1, 0]	[0, -1, 0]	[-1, 0, 0]	[-1, 1, 0]
[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]	[0, 0, 1]

Cubic
m -3
[0, 1, 0]	[0, 0, 1]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[0, 1, 0]
[0, 0, 1]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[1, 0, 0]	[0, 0, -1]
[1, 0, 0]	[0, 1, 0]	[0, 0, -1]	[-1, 0, 0]	[0, -1, 0]	[-1, 0, 0]

[0, 0, 1]	[0, 0, -1]	[-1, 0, 0]	[0, -1, 0]	[1, 0, 0]
[-1, 0, 0]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[0, -1, 0]
[0, -1, 0]	[0, -1, 0]	[0, 0, -1]	[-1, 0, 0]	[0, 0, -1]

m -3 m
[0, 1, 0]	[0, 0, 1]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[0, 1, 0]
[0, 0, 1]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[1, 0, 0]	[0, 0, -1]
[1, 0, 0]	[0, 1, 0]	[0, 0, -1]	[-1, 0, 0]	[0, -1, 0]	[-1, 0, 0]

[0, 0, 1]	[0, 0, -1]	[-1, 0, 0]	[0, -1, 0]	[1, 0, 0]	[0, 1, 0]
[-1, 0, 0]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[0, -1, 0]	[1, 0, 0]
[0, -1, 0]	[0, -1, 0]	[0, 0, -1]	[-1, 0, 0]	[0, 0, -1]	[0, 0, 1]

[0, 0, 1]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[1, 0, 0]	[0, 0, -1]
[0, 1, 0]	[0, 0, 1]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[0, 1, 0]
[1, 0, 0]	[0, 1, 0]	[0, 0, -1]	[-1, 0, 0]	[0, -1, 0]	[-1, 0, 0]

[-1, 0, 0]	[1, 0, 0]	[0, 1, 0]	[0, 0, 1]	[0, -1, 0]
[0, 0, 1]	[0, 0, -1]	[-1, 0, 0]	[0, -1, 0]	[1, 0, 0]
[0, -1, 0]	[0, -1, 0]	[0, 0, -1]	[-1, 0, 0]	[0, 0, -1]
*/

class LaueClassMatrices:public MyObject
{
    private:
        MatrixReader** iMatrices;
    public:
        LaueClassMatrices();
        ~LaueClassMatrices();
        Matrix<short>* getMatrix(int pIndex);
};

LaueClassMatrices::LaueClassMatrices()
{
    iMatrices = new Matrix<short>*[39];
    
    iMatrices[0] = new MatrixReader("[-1, 0, 0; -1, 1, 0; 0, 0, 1]");
    iMatrices[1] = new MatrixReader("[-1, 0, 0; 0, -1, 0; 0, 0, 1]");
    iMatrices[2] = new MatrixReader("[-1, 0, 0; 0, 0, 1; 0, -1, 0]");
    iMatrices[3] = new MatrixReader("[-1, 0, 0; 0, 1, 0; 0, 0, -1]");
    iMatrices[4] = new MatrixReader("[-1, 0, 0; 0, 1, 0; 0, 0, 1]");
    iMatrices[5] = new MatrixReader("[-1, 1, 0; -1, 0, 0; 0, 0, 1]");
    iMatrices[6] = new MatrixReader("[-1, 1, 0; -1, 1, 0; 0, 0, 1]");
    iMatrices[7] = new MatrixReader("[-1, 1, 0; 0, 1, 0; 0, 0, 1]");
    iMatrices[8] = new MatrixReader("[0, -1, 0; -1, 0, 0; 0, 0, 1]");
    iMatrices[9] = new MatrixReader("[0, -1, 0; 0, 0, 1; -1, 0, 0]");
    iMatrices[10] = new MatrixReader("[0, -1, 0; 1, -1, 0; 0, 0, 1]");
    iMatrices[11] = new MatrixReader("[0, -1, 0; 1, 0, 0; 0, 0, -1]");
    iMatrices[12] = new MatrixReader("[0, -1, 0; 1, 0, 0; 0, 0, 1]");
    iMatrices[13] = new MatrixReader("[0, 0, -1; 0, 1, 0; -1, 0, 0]");
    iMatrices[14] = new MatrixReader("[0, 0, -1; 1, 0, 0; 0, -1, 0]");
    iMatrices[15] = new MatrixReader("[0, 0, 1; -1, 0, 0; 0, -1, 0]");
    iMatrices[16] = new MatrixReader("[0, 0, 1; 0, -1, 0; -1, 0, 0]");
    iMatrices[17] = new MatrixReader("[0, 0, 1; 0, 1, 0; -1, 0, 0]");
    iMatrices[18] = new MatrixReader("[0, 0, 1; 0, 1, 0; 1, 0, 0]");
    iMatrices[19] = new MatrixReader("[0, 0, 1; 1, 0, 0; 0, -1, 0]");
    iMatrices[20] = new MatrixReader("[0, 0, 1; 1, 0, 0; 0, 1, 0]");
    iMatrices[21] = new MatrixReader("[0, 1, 0; -1, 0, 0; 0, 0, -1]");
    iMatrices[22] = new MatrixReader("[0, 1, 0; -1, 0, 0; 0, 0, 1]");
    iMatrices[23] = new MatrixReader("[0, 1, 0; -1, 1, 0; 0, 0, 1]");
    iMatrices[24] = new MatrixReader("[0, 1, 0; 0, 0, -1; -1, 0, 0]");
    iMatrices[25] = new MatrixReader("[0, 1, 0; 0, 0, 1; -1, 0, 0]");
    iMatrices[26] = new MatrixReader("[0, 1, 0; 0, 0, 1; 1, 0, 0]");
    iMatrices[27] = new MatrixReader("[0, 1, 0; 1, 0, 0; 0, 0, -1]");
    iMatrices[28] = new MatrixReader("[0, 1, 0; 1, 0, 0; 0, 0, 1]");
    iMatrices[29] = new MatrixReader("[1, -1, 0; 0, -1, 0; 0, 0, 1]");
    iMatrices[30] = new MatrixReader("[1, -1, 0; 1, 0, 0; 0, 0, 1]");
    iMatrices[31] = new MatrixReader("[1, 0, 0; 0, -1, 0; 0, 0, -1]");
    iMatrices[32] = new MatrixReader("[1, 0, 0; 0, -1, 0; 0, 0, 1]");
    iMatrices[33] = new MatrixReader("[1, 0, 0; 0, 0, -1; 0, -1, 0]");
    iMatrices[34] = new MatrixReader("[1, 0, 0; 0, 0, 1; 0, -1, 0]");
    iMatrices[35] = new MatrixReader("[1, 0, 0; 0, 0, 1; 0, 1, 0]");
    iMatrices[36] = new MatrixReader("[1, 0, 0; 0, 1, 0; 0, 0, -1]");
    iMatrices[37] = new MatrixReader("[1, 0, 0; 0, 1, 0; 0, 0, 1]");
    iMatrices[38] = new MatrixReader("[1, 0, 0; 1, -1, 0; 0, 0, 1]");
}

LaueClassMatrices::~LaueClassMatrices()
{
    for (int i = 0; i < 39; i ++)
    {
        delete iMatrices[i];
    }
}

float sumdiff(Array<float>& pValues, float pMean)
{
    float tTotal = 0;
    
    for (size_t i = 0; i < pValues.size(); i++)
    {
        tTotal += fabs(pMean - pValues[i]);
    }
    return tTotal;
}


MergedData::MergedData(const HKLData& pData, vector<Matrix<short>*>& pMatrice)
{
    long tReflNum = pData.numberOfReflections();
    multiset<Reflection*, lsreflection>* tSortedReflections = new multiset<Reflection*, lsreflection>();
    Reflection* tReflections = new Reflection[tReflNum];
    for (int i = 0; i < tReflNum; i++)
    {
        //Reflection tNewReflection =
        equivalentise(*pData.getReflection(i), pMatrice, &(tReflections[i]));
        tSortedReflections->insert(&(tReflections[i]));
    }
    
    if (tReflNum > 0) //Just in case there are no reflections. Shouldn't happen but you never know 
    {
        Matrix<short> tCurHKL;
        Array<float> tValues(20); //This will more than likley be enough space so that there won't be any more memory needing allocating.
        tCurHKL = *((*(tSortedReflections->begin()))->tHKL);
        tValues.add((*tSortedReflections->begin())->i);
        set<Reflection*>::iterator tIter = tSortedReflections->begin(); 
        float tSumSum = 0;
        float tMeanDiffSum = 0;
        
        while (tIter != tSortedReflections->end())
        {
            if (!(*((*tIter)->tHKL) == tCurHKL))
            {
                float tSum = sum(tValues.getPointer(), tValues.size());
                tSumSum += tSum;
                tMeanDiffSum += sumdiff(tValues, tSum/tValues.size());
                tCurHKL = *((*tIter)->tHKL);
                tValues.clear();
            }
           // cout << *(*tIter) << "\n";
            tValues.add((*tIter)->i);
            tIter++;
        }
        iRFactor = 100*(tSumSum/tMeanDiffSum);
    }
 //   cout << "\nR factor: " << iRFactor << "\n";
    delete[] tReflections;
}


inline bool greaterHKL(Matrix<short> pMat1, Matrix<short> pMat2)
{
    if (pMat1.getValue(0) < pMat2.getValue(0))
        return true;
    else if (pMat1.getValue(0) > pMat2.getValue(0))
        return false;
    else
    {
        if (pMat1.getValue(1) < pMat2.getValue(1))
            return true;
        else if (pMat1.getValue(1) > pMat2.getValue(1))
            return false;
        else
        {
            if (pMat1.getValue(2) < pMat2.getValue(2))
                return true;
            else
                return false;
        }
    }
    return false;
}

void MergedData::equivalentise(const Reflection& pReflection, vector<Matrix<short>*>& pMatrice, Reflection* pResult)
{
    Matrix<short> tMaxHKL;
    tMaxHKL = *(pReflection.getHKL());
    Matrix<short> tCurrentHKL;
    tCurrentHKL = *(pReflection.getHKL());
    Matrix<short> tTempHKL(1, 3);
    static Matrix<short> tZero(1, 3, 0);

    for (size_t i = 0; i < pMatrice.size(); i++)
    {
        (pMatrice[i])->mul(tCurrentHKL, tTempHKL);
        for (int j = 0; j < 2; j++)
        {
            if (!greaterHKL(tTempHKL, tMaxHKL))
            {
                tMaxHKL = tTempHKL;
            }
            tZero.sub(tTempHKL, tTempHKL);
        }
    }
    pResult->i = pReflection.i;
    pResult->iSE = pReflection.iSE;
    //Reflection tReflection(pReflection);
    //(*tReflection.tHKL) = tMaxHKL;
    (*pResult->tHKL) = tMaxHKL;
   // return tReflection;
}

std::ostream& MergedData::output(std::ostream& pStream)
{
    return pStream << "R-Factor: " << iRFactor;
}

std::ostream& operator<<(std::ostream& pStream, MergedData& tData)
{
    return tData.output(pStream);
}