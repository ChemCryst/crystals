/*
 *  ReflectionMerging.cpp
 *  Space Groups
 *
 *  Created by Stefan on Wed Jul 16 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#include "ReflectionMerging.h"
#include "MathFunctions.h"
#include "Collections.h"
#include <math.h>
#include <iostream>
#include <iterator.h>

/*
 * A class which simply stores a list of all the matrices.
 */

class LaueClassMatrices:public MyObject
{
private:
  Array<MatrixReader*>* iMatrices;
public:
  LaueClassMatrices();
  ~LaueClassMatrices();
  Matrix<short>* getMatrix(unsigned int pIndex) const;
  //  Array<Matrix<short>*>* getList(unsigned int pIndex) const;
};

/*
 * Creates a large array containing all the unique matrices.
 */
LaueClassMatrices::LaueClassMatrices()
{
    MatrixReader* tMatrices[39];
 
    tMatrices[0] = new MatrixReader("[-1 0 0; -1 1 0; 0 0 1]");
    tMatrices[1] = new MatrixReader("[-1 0 0; 0 -1 0; 0 0 1]");
    tMatrices[2] = new MatrixReader("[-1 0 0; 0 0 1; 0 -1 0]");
    tMatrices[3] = new MatrixReader("[-1 0 0; 0 1 0; 0 0 -1]");
    tMatrices[4] = new MatrixReader("[-1 0 0; 0 1 0; 0 0 1]");    
    tMatrices[5] = new MatrixReader("[-1 1 0; -1 0 0; 0 0 1]");
    tMatrices[6] = new MatrixReader("[-1 1 0; -1 1 0; 0 0 1]");
    tMatrices[7] = new MatrixReader("[-1 1 0; 0 1 0; 0 0 1]");
    tMatrices[8] = new MatrixReader("[0 -1 0; -1 0 0; 0 0 1]");
    tMatrices[9] = new MatrixReader("[0 -1 0; 0 0 1; -1 0 0]");
    tMatrices[10] = new MatrixReader("[0 -1 0; 1 -1 0; 0 0 1]");
    tMatrices[11] = new MatrixReader("[0 -1 0; 1 0 0; 0 0 -1]");
    tMatrices[12] = new MatrixReader("[0 -1 0; 1 0 0; 0 0 1]");
    tMatrices[13] = new MatrixReader("[0 0 -1; 0 1 0; -1 0 0]");
    tMatrices[14] = new MatrixReader("[0 0 -1; 1 0 0; 0 -1 0]");
    tMatrices[15] = new MatrixReader("[0 0 1; -1 0 0; 0 -1 0]");
    tMatrices[16] = new MatrixReader("[0 0 1; 0 -1 0; -1 0 0]");
    tMatrices[17] = new MatrixReader("[0 0 1; 0 1 0; -1 0 0]");
    tMatrices[18] = new MatrixReader("[0 0 1; 0 1 0; 1 0 0]");
    tMatrices[19] = new MatrixReader("[0 0 1; 1 0 0; 0 -1 0]");
    tMatrices[20] = new MatrixReader("[0 0 1; 1 0 0; 0 1 0]");
    tMatrices[21] = new MatrixReader("[0 1 0; -1 0 0; 0 0 -1]");
    tMatrices[22] = new MatrixReader("[0 1 0; -1 0 0; 0 0 1]");
    tMatrices[23] = new MatrixReader("[0 1 0; -1 1 0; 0 0 1]");
    tMatrices[24] = new MatrixReader("[0 1 0; 0 0 -1; -1 0 0]");
    tMatrices[25] = new MatrixReader("[0 1 0; 0 0 1; -1 0 0]");
    tMatrices[26] = new MatrixReader("[0 1 0; 0 0 1; 1 0 0]");
    tMatrices[27] = new MatrixReader("[0 1 0; 1 0 0; 0 0 -1]");
    tMatrices[28] = new MatrixReader("[0 1 0; 1 0 0; 0 0 1]");
    tMatrices[29] = new MatrixReader("[1 -1 0; 0 -1 0; 0 0 1]");
    tMatrices[30] = new MatrixReader("[1 -1 0; 1 0 0; 0 0 1]");
    tMatrices[31] = new MatrixReader("[1 0 0; 0 -1 0; 0 0 -1]");
    tMatrices[32] = new MatrixReader("[1 0 0; 0 -1 0; 0 0 1]");
    tMatrices[33] = new MatrixReader("[1 0 0; 0 0 -1; 0 -1 0]");
    tMatrices[34] = new MatrixReader("[1 0 0; 0 0 1; 0 -1 0]");
    tMatrices[35] = new MatrixReader("[1 0 0; 0 0 1; 0 1 0]");
    tMatrices[36] = new MatrixReader("[1 0 0; 0 1 0; 0 0 -1]");
    tMatrices[37] = new MatrixReader("[1 0 0; 0 1 0; 0 0 1]");
    tMatrices[38] = new MatrixReader("[1 0 0; 1 -1 0; 0 0 1]");
    iMatrices = new Array<MatrixReader*>(tMatrices, 39);
}

Matrix<short>* LaueClassMatrices::getMatrix(unsigned int pIndex) const
{
    return (Matrix<short>*)((*iMatrices)[pIndex]);
}

LaueClassMatrices::~LaueClassMatrices()
{
    for (int i = 0; i < 39; i ++)
    {
        delete (*iMatrices)[i];
    }
    delete iMatrices;
}

/*
 * the laue group of matrices
 */
class LaueGroups::LaueGroup
{
public:
  unsigned short iCrystalSystem;
  Array<unsigned short>* iMatIndices;
  
  LaueGroup(const unsigned short pSys, const unsigned short pIndices[], const int pNumMat):iCrystalSystem(pSys)
  {
      iMatIndices = new Array<unsigned short>(pIndices, pNumMat);
  }
  
  unsigned short getCrystalSystem() const
  {
      return iCrystalSystem;
  }
  
  Array<unsigned short>& getMatIndices() const
  {
      return *iMatIndices;
  }
  
  std::ostream& output(std::ostream& pStream)
  {
      return pStream << "LaueGroup System " << iCrystalSystem << "\n";
  }

  ~LaueGroup()
  {
      delete iMatIndices;
  }
};

LaueGroups::LaueGroups()
{
    LaueGroup* tArray[12];
    const unsigned short tIndices[] = {37, //Triclinic
				       3, //1 2/m 1
				       4, 32, 1, //2/m 2/m 2/m
				       11, 1, 22, //4/m
				       12, 1, 4, 22, 28, 32, 8,//4/m m m
				       10, 5, //-3
				       10, 5, 7, 38, 8, //-3 m 1
				       10, 5, 28, 29, 0, //  -3 1 m
				       30, 10, 1, 6, 23, //6/m
				       30, 10, 1, 5, 23, 7, 28, 38, 29, 8, 0, //6/m m m
				       26, 20, 36, 25, 19, 24, 15, 14, 3, 9, 31,//m -3
				       26, 20, 36, 25, 19, 24, 15, 14, 3, 9, 31, 28, 18, 35, 27, 17, 34, 13, 2, 33, 21, 16, 11};//m -3 m
    
    tArray[0] = new LaueGroup(kTriclinicID, tIndices, 1); //Triclinic
    tArray[1] = new LaueGroup(kMonoclinicBID, &(tIndices[1]), 1); //1 2/m 1
    tArray[2] = new LaueGroup(kOrtharombicID, &(tIndices[2]), 3); //2/m 2/m 2/m
    tArray[3] = new LaueGroup(kTetragonalID, &(tIndices[5]), 3); //4/m
    tArray[4] = new LaueGroup(kTetragonalID, &(tIndices[8]), 7); //4/m m m
    tArray[5] = new LaueGroup(kTrigonalID, &(tIndices[15]), 2); //-3
    tArray[6] = new LaueGroup(kTrigonalID, &(tIndices[17]), 5); //-3 m 1
    tArray[7] = new LaueGroup(kTrigonalID, &(tIndices[22]), 5); //  -3 1 m
    tArray[8] = new LaueGroup(kHexagonalID, &(tIndices[27]), 5); //6/m
    tArray[9] = new LaueGroup(kHexagonalID, &(tIndices[32]), 11); //6/m m m
    tArray[10] = new LaueGroup(kCubicID, &(tIndices[43]), 11); //m -3
    tArray[11] = new LaueGroup(kCubicID, &(tIndices[54]), 23); //m -3 m
    iGroups = new Array<LaueGroup*>(tArray, 12);
}

Array<unsigned short>& LaueGroups::getGroupIndice(const unsigned int pSystemRef, const unsigned short pGroupNum) const
{
    return (*iGroups)[pSystemRef+pGroupNum]->getMatIndices();
}

LaueGroups::~LaueGroups()
{
    for (unsigned int i = 0; i < iGroups->size(); i++)
    {
	delete (*iGroups)[i];
    }
    delete iGroups;
}

unsigned int LaueGroups::getSystemRef(unsigned short* pNumGroup, const unsigned short pSystem) const
{
    unsigned short i = 0;
    unsigned short tResult;

    (*pNumGroup) = 0;
    while (i < iGroups->size() && (*iGroups)[i]->getCrystalSystem() != pSystem)
    {i++;}
    tResult = i;
    while (i < iGroups->size() && (*iGroups)[i]->getCrystalSystem()==pSystem)
    {(*pNumGroup)++; i++;};
    if ((*pNumGroup) > 0)
    {
	return tResult;
    }
    return 0;
}

MergedData LaueGroups::mergeSystemGroup(const HKLData& pHKLData, const unsigned short pSystemRef, const unsigned short pGroupID) const
{
    MergedData tResult(pHKLData, (*iGroups)[pSystemRef+pGroupID]->getMatIndices());
    return tResult;
}

/*
 * Calculates the sum of the abs differences in an array of floats.
 */
float sumdiff(Array<float>& pValues, float pMean)
{
    float tTotal = 0;
    
    for (size_t i = 0; i < pValues.size(); i++)
    {
        tTotal += fabs(pMean - pValues[i]);
    }
    return tTotal;
}

MergedData::MergedData(const HKLData& pData, Array<unsigned short>& pMatIndices)
{
    long tReflNum = pData.numberOfReflections();
    multiset<Reflection*, lsreflection>* tSortedReflections = new multiset<Reflection*, lsreflection>();
    Reflection* tReflections = new Reflection[tReflNum];

    for (int i = 0; i < tReflNum; i++)
    {
        //Reflection tNewReflection =
        equivalentise(*pData.getReflection(i), pMatIndices, &(tReflections[i]));
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
        
        while (tIter != tSortedReflections->end()) //Run through all the reflections
        {
            if (!(*((*tIter)->tHKL) == tCurHKL))//If the HKL value has changed then 
	    {
		if (tValues.size()>1) //As long as there are more then one reflection
		{
		    float tSum = sum(tValues.getPointer(), tValues.size());
		    tSumSum += tSum;
		    tMeanDiffSum += sumdiff(tValues, tSum/tValues.size());
		}
		tCurHKL = *((*tIter)->tHKL); //Save the next hkl value
		tValues.clear();   //Remove all the old intensities
	    }
            tValues.add((*tIter)->i);  //Save the intensity
            tIter++; //Move on to the next reflection in the list.
        }
        iRFactor = tMeanDiffSum/tSumSum; //In the desciption this is multiplied by
	//But as these values are for comparison there isn't much point
    }
    delete[] tReflections;
}

MergedData::MergedData(const MergedData& pMergedData) //Copy constructure
{
    iRFactor = pMergedData.iRFactor;
}

/*
 * returns whether the HKL pMat1 is greater then HKL pMat2
 * (H1 > H2) || ((H1 == H2) && ((K1 >K2) || ((K1 == K2) && (L1 > L2)))  
 */
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

LaueClassMatrices gLaueMatrices;
/*
 *  Applies a vector of matrices to the hkl values of a reflection.
 * The greatest of these results are returned in pResult with the same 
 * I and sigma(I) values passed.
 */
void MergedData::equivalentise(const Reflection& pReflection, Array<unsigned short>& pMatIndices, Reflection* pResult) const
{
    Matrix<short> tMaxHKL;
    tMaxHKL = *(pReflection.getHKL()); //Get a copy of the HKL values
    Matrix<short> tCurrentHKL;
    tCurrentHKL = *(pReflection.getHKL()); //Make another copy of the HKL values
    Matrix<short> tTempHKL(1, 3); //for storing the results in.
    static Matrix<short> tZero(1, 3, 0);  //inverting the hkl values

    for (size_t i = 0; i < pMatIndices.size(); i++) //Run through all the matrices.
    {
        (gLaueMatrices.getMatrix(pMatIndices[i]))->mul(tCurrentHKL, tTempHKL); //Multiply the hkl value with the current matrix
        for (int j = 0; j < 2; j++) //Do this twice
        {
            if (!greaterHKL(tTempHKL, tMaxHKL)) //see if this new HKL value is greater then the last. This is just for consistancy could just as well be least hkl value or something.
            {
                tMaxHKL = tTempHKL;
            }
            tZero.sub(tTempHKL, tTempHKL); //Invert the hkl value.
        }
    }
    pResult->i = pReflection.i; //Copy I for result
    pResult->iSE = pReflection.iSE; //Copy sigma(I) for result
    (*pResult->tHKL) = tMaxHKL; //Set new HKL value
}

std::ostream& MergedData::output(std::ostream& pStream)
{
    return pStream << "R-Factor: " << iRFactor;
}

std::ostream& operator<<(std::ostream& pStream, MergedData& tData)
{
    return tData.output(pStream);
}

