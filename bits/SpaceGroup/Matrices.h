/*
 *  Matrices.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Nov 05 2002.
 *  Copyright (c) 2002 __MyCompanyName__. All rights reserved.
 *
 */
 
 /*** Naming conventions ***
 ** Variable/Constant **
 * These conventions should be followed as closely as possible when coding in the file.
 * All variable names should start with one of the following lower case letters.
 * t - variables which are declared locally to the method/function
 * i - variables which are members of the object.
 * g - variables which are global to the file.
 * p - variables which are parameters to a method/function.
 * k - constants
 *
 * All variables should be have descriptive names which. Should use capitalization in 
 * variable names.
 *
 * e.g.. 
 * double tSomeVariable;   //A variable which is declared inside method.
 * double pSomeParameter   //A variable which is a parameter to a method/function
 *
 ** Classes/Structures/Typedefs **
 * All these should have the first letter as a capital and the first letter of any word 
 * in the name should be a capital letter. All other letters should be lower case.
 * 
 * e.g.
 * class MyClass
 * {
 * 	function name	
 * };
 */

#ifndef __MATRICES_H__
#define __MATRICES_H__
#include <stdio.h>
#include <iostream>
#include <math.h>
#include "ComClasses.h"
#if defined(__APPLE__)
#include <vecLib/vDSP.h>
#endif
#include "Exceptions.h"
//Error codes
#define kDimensionErrorN -1
#define kInnerDimensionErrorN -2
#define kSquareMatrixN -3

//Error strings
#define kDimensionError "Matrix dimensions must agree." 
#define kInnerDimensionError "Inner matrix dimensions must agree."
#define kSquareMatrix "Matrix must be square."

class MatrixException:public MyException
{
    public:
        MatrixException(int pErrNum, char* pErrType);
};

template <class type>
class Matrix:public MyObject
{
    protected:
        type* 	iMatrix;
        size_t 	iXSize, iYSize, iSize;
    public:
        Matrix()
        {
            iXSize = 1;
            iYSize = 1;
            iSize = 1;
            iMatrix = new type[iSize];
        }
        
        Matrix(const size_t pXSize, const size_t pYSize) //uninitalised matrix constructor
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = new type[iSize];
        }
        
        Matrix(const size_t pXSize, const size_t pYSize, const type pC) //initalised matrix constructor with c
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = new type[iSize];
            for (size_t i = 0; i < iSize; i++)
            {
                iMatrix[i] = pC;
            }
        }
        
        Matrix(const Matrix<type>& pMatrix):iXSize(pMatrix.iXSize), iYSize(pMatrix.iYSize), iSize(pMatrix.iSize)  //Copy constructor
        {
            iMatrix = new type[pMatrix.iSize];
            memcpy(iMatrix, pMatrix.iMatrix, pMatrix.iSize*sizeof(type));
        }
		
		Matrix(const type pMatrix[], const size_t pXSize, const size_t pYSize):iXSize(pXSize), iYSize(pYSize), iSize(pXSize*pYSize)
        {
            iMatrix = new type[iSize];
            memcpy(iMatrix, pMatrix, iSize*sizeof(type));
        }
        
        ~Matrix()
        {	
            delete[] iMatrix;
        }
        
        size_t sizeX() const
        {
            return iXSize;
        }
        
        size_t sizeY() const
        {
            return iYSize;
        }
        
        Matrix<type>& operator+=(const Matrix<type>& pMatrix)
        {
            if (iXSize != pMatrix.iXSize || iYSize != pMatrix.iYSize)
            {
                throw MatrixException(kDimensionErrorN, kDimensionError);
            }
            for (int i = 0; i < iSize; i++)
            {
                iMatrix[i] += pMatrix.iMatrix[i];
            }
            return *this;
        }
        
        Matrix<type>& operator-=(const Matrix<type>& pMatrix)
        {
            if (iXSize != pMatrix.iXSize || iYSize != pMatrix.iYSize)
            {
                throw MatrixException(kDimensionErrorN, kDimensionError);
            }
            for (int i = 0; i < iSize; i++)
            {
                iMatrix[i] -= pMatrix.iMatrix[i];
            }
            return *this;
        }
        
        Matrix<type>& operator*=(const Matrix<type>& pMatrix)
        {
            if (iXSize != pMatrix.iYSize)
            {
                throw MatrixException(kInnerDimensionErrorN,  kInnerDimensionError);
            }
            type* tNewMatrix = new type[iYSize*pMatrix.iXSize];
            for (size_t i = 0; i < iYSize; i ++)
            {
                for (size_t j = 0; j < pMatrix.iXSize; j ++)
                {
                    tNewMatrix[j*iYSize+i] = getValue(0, i)*pMatrix.getValue(j, 0); 
                    for (size_t k = 1; k < iXSize; k++)
                    {
                        tNewMatrix[j*iYSize+i] += getValue(k, i)*pMatrix.getValue(j, k);
                    }
                } 
            }
            delete[] iMatrix;
            iXSize = pMatrix.iXSize;
            iSize = iYSize*iXSize; 
            iMatrix=tNewMatrix;
            return *this;
        }
        
        inline type getValue(const size_t pIndex) const
        {
            return iMatrix[pIndex];
        }
		
		inline type& operator[](const size_t pIndex) const
		{
			return iMatrix[pIndex];
		}
        
        inline type getValue(const size_t pXIndex, const size_t pYIndex) const
        {
            return iMatrix[pXIndex*iYSize+pYIndex];
        }
        
        inline void setValue(const type pValue, const short pIndex)
        {
            iMatrix[pIndex] = pValue;
        }
        
        inline void setValue(const type pValue, const short pXIndex, const short pYIndex)
        {
            iMatrix[pXIndex*iYSize+pYIndex] = pValue;
        }
        
        inline void setValues(const type* pValues, size_t pLength)
        {
            memcpy(iMatrix, pValues, pLength*sizeof(type));
        }
        
        std::ostream& output(std::ostream& pStream)
        {
            for (size_t i = 0; i < iYSize; i++)
            {
                pStream << "[";
                for (size_t j = 0; j < iXSize; j++)
                {
                    if (j != 0)
                    {
                        pStream << ", ";
                    }
                    pStream << this->getValue(j, i);
                }
                pStream << "]\n";
            }
            return pStream;
        }
        
        Matrix<type>& operator=(const Matrix<type>& pMatrix)
        {
            if (iSize != pMatrix.iSize)
            {
                iSize = pMatrix.iSize;
                delete[] iMatrix;
                iMatrix = new type[iSize];
            }
            memcpy(iMatrix, pMatrix.iMatrix, sizeof(type)*iSize); 
            iXSize = pMatrix.iXSize;
            iYSize = pMatrix.iYSize;
            return *this;
        }
        
        template <class otherType>
        Matrix<type>& operator=(const Matrix<otherType>& pMatrix)
        {
            resize(pMatrix.sizeX(), pMatrix.sizeY());
            for (size_t i = 0; i< iSize; i++)
            {
                iMatrix[i] = (type)pMatrix.getValue(i);
            }
            return *this;
        }
        
        inline Matrix<type>& add(const Matrix<type>& pMatrix1, Matrix<type>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            for (int i = 0; i < iSize; i++)
            {
                pResult[i] = iMatrix[i] + pMatrix1.iMatrix[i];
            }
			return pResult;
        }

        inline float abssum()
        {
            type tSum = 0;
            
            for (size_t i = 0;  i < iSize; i ++)
            {
                tSum += fabsf(iMatrix[i]);
            }
            return tSum;
        }

        inline Matrix<type>& sub(Matrix<type>& pMatrix1, Matrix<type>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            for (size_t i = 0; i < iSize; i++)
            {
                pResult.iMatrix[i] = iMatrix[i] - pMatrix1.iMatrix[i];
            }
			return pResult;
        }
		
		inline Matrix<type>& sub(type pValue, Matrix<float>& pResult)	
        {
			Matrix<float> tSub(iXSize, iYSize, pValue);
            this->sub(tSub, pResult);
			return pResult;
        }
		
		inline Matrix<type>& mul(const type& pMult)	//A faster multiply this doesn't check to see if the result matrix is the correct size before inserting the results
        {
			for (size_t i = 0; i < iYSize; i ++)
            {
                for (size_t j = 0; j < iXSize; j ++)
                {
					iMatrix[i*iYSize+j] *= pMult;
				}
			}
			return *this;
		}
		
        inline void mul(const Matrix<type>& pMatrix1, Matrix<type>& pResult)	//A faster multiply this doesn't check to see if the result matrix is the correct size before inserting the results
        {
            pResult.iXSize = pMatrix1.iXSize;
            pResult.iYSize = iYSize;
            for (size_t i = 0; i < iYSize; i ++)
            {
                for (size_t j = 0; j < pMatrix1.iXSize; j ++)
                {
                    pResult.iMatrix[j*iYSize+i] = getValue(0, i)*pMatrix1.getValue(j, 0); 
                    for (size_t k = 1; k < iXSize; k++)
                    {
                        pResult.iMatrix[j*iYSize+i] += getValue(k, i)*pMatrix1.getValue(j, k);
                    }
                } 
            }
        }
        
        void resize(const size_t pXSize, const size_t pYSize)
        {
            size_t tSize = pXSize*pYSize;
            type* tMatrix = new type[tSize];//malloc(sizeof(type) * tSize);
            
            memcpy(tMatrix, iMatrix, sizeof(type)* (tSize < iSize?tSize:iSize));
            delete[] iMatrix;
            iMatrix = tMatrix;
            iXSize = pXSize;
            iYSize = pYSize;
            iSize = iXSize * iYSize;
        }
        
        void fill(const type& pValue)
        {
            for (size_t i = 0; i < iSize; i++)
            {
                iMatrix[i] = pValue;
            }
        }
        
        bool operator ==(const Matrix<type>& pMatrix2)
        {
            if (pMatrix2.iXSize == iXSize && pMatrix2.iYSize == iYSize)
            {
                return bcmp(iMatrix, pMatrix2.iMatrix, iSize*sizeof(type))==0;
            }
            return false;
        }
        
        void transpose()
        {
            if (iXSize == iYSize)   
            {//in situ transpose For square matrices
                for (size_t x = 0; x < iXSize; x++)
                {
                    for (size_t y = 0; y < iYSize-(iXSize-x); y++)
                    {
                        type tTemp = iMatrix[y*iYSize+x];
                        iMatrix[y*iYSize+x] = iMatrix[x*iYSize+y];
                        iMatrix[x*iYSize+y] = tTemp;
                    }
                }
            }
            else
            {
                size_t tXSize = iYSize, tYSize = iXSize;
                type* tMatrix = new type[iSize];
                for (size_t x = 0; x < iXSize; x++)
                {
                    for (size_t y = 0; y < iYSize; y++)
                    {
                        tMatrix[y*tYSize+x] = iMatrix[x*iYSize+y];
                    }
                }
                delete[] iMatrix;
                iMatrix = tMatrix;
                iYSize = tYSize;
                iXSize = tXSize;
            }
        }
        
        inline type sum()
        {
            type tSum = 0;
            
            for (size_t i = 0;  i < iSize; i ++)
            {
                tSum += iMatrix[i];
            }
            return tSum;
        }
        
        void makeDiagonal(type pDiag, type pOuter)
        {
            fill(pOuter);
            for (size_t i = 0; i < iXSize && i < iYSize; i++)
            {
                setValue(pDiag, i, i);
            }
        }
        
        int bytecmp(const Matrix<type>& pValue2)
        {
            return memcmp(iMatrix, pValue2.iMatrix, sizeof(type)*iSize);
        }
		
		
		type determinant()
		{
			if (iSize == 1)
				return getValue(0, 0);
			type tDet = 0;
			if (iXSize != iYSize)
				throw MatrixException(kSquareMatrixN, kSquareMatrix);
			for (size_t i = 0; i < iXSize; ++i)
			{
				int tSign = ( i % 2) ? -1 : 1;
				Matrix<type> tCofactor;
				cofactor(i, 0, tCofactor);
				tDet += tSign * getValue(i, 0) * tCofactor.determinant();
			}
			return tDet;
		}
		
		Matrix<type>& cofactor(size_t x, size_t y, Matrix<type>& pResult)
		{
			pResult.resize(iXSize-1, iYSize-1);
			for (size_t i = 0, k = 0; i < iXSize; ++i) 
			{
				if ( i != x) 
				{
					for (size_t j = 0, l = 0; j < iYSize; ++j) 
					{
						if ( j != y) 
						{
							pResult.setValue(getValue(i, j), k, l);
							++l;
						}
					}
					++k;
				}
			}
			return pResult;
		}
		
		Matrix<type>& inv()
		{
			if (iXSize != iYSize)
				throw MatrixException(kSquareMatrixN, kSquareMatrix);
				
			Matrix<type> tResult(iXSize, iXSize); //Using xSize because then we don't need to put ySize in a register.
												//Probably want help in the slightest but want do any harm.
			Matrix<type> tCofactor(iXSize-1, iXSize-1);
			for (size_t i = 0; i < iXSize; i++)
			{
				for (size_t j = 0; j < iXSize; j++)
				{
					int tSign = ((i+j)%2) ? -1 : 1;
					type tTemp = tSign*cofactor(i, j, tCofactor).determinant();
					tResult.setValue(tTemp, j, i);
				}
			}
			(*this) = tResult.mul(1/determinant());
			return *this;
		}
};

#if defined (__APPLE__)
//Specialisation of the matrxi class. This will only work on a Apple PowerMac. This needs Mac OS 10.1 or later
template<>
class Matrix<float>:public MyObject
{
    protected:
        float* 	iMatrix;
        size_t 	iXSize, iYSize, iSize;
    public:
        Matrix()
        {
            iXSize = 1;
            iYSize = 1;
            iSize = 1;
            iMatrix = (float*)malloc(sizeof(float)*iSize);
        }

        Matrix(const size_t pXSize, const size_t pYSize) //uninitalised matrix constructor
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = (float*)malloc(sizeof(float)*iSize);
        }
        
        Matrix(const size_t pXSize, const size_t pYSize, const float pC) //initalised matrix constructor with c
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = (float*)malloc(sizeof(float)*iSize);
            for (size_t i = 0; i < iSize; i++)
            {
                iMatrix[i] = pC;
            }
        }
        
        Matrix(const Matrix<float>& pMatrix):iXSize(pMatrix.iXSize), iYSize(pMatrix.iYSize), iSize(pMatrix.iSize)  //Copy constructor
        {
            iMatrix = (float*)malloc(sizeof(float)*iSize);
            memcpy(iMatrix, pMatrix.iMatrix, pMatrix.iSize*sizeof(float));
        }
        
        Matrix(const float pMatrix[], const size_t pXSize, const size_t pYSize):iXSize(pXSize), iYSize(pYSize), iSize(pXSize*pYSize)
        {
            iMatrix = (float*)malloc(sizeof(float)*iSize);
            memcpy(iMatrix, pMatrix, iSize*sizeof(float));
        }
        
		template <class otherType>
        Matrix(const Matrix<otherType>& pMatrix)
        {
			iYSize = pMatrix.sizeY();
			iXSize = pMatrix.sizeX();
			iSize = iXSize * iYSize;
			iMatrix = (float*)malloc(sizeof(float)*iSize);
            for (size_t i = 0; i< iSize; i++)
            {
                iMatrix[i] = (float)pMatrix.getValue(i);
            }
        }
		
        ~Matrix()
        {
            free(iMatrix);
        }
        
        short sizeX() const
        {
            return iXSize;
        }
        
        short sizeY() const
        {
            return iYSize;
        }
        
        Matrix<float>& operator+=(const Matrix<float>& pMatrix)
        {
            vadd(iMatrix, 1, pMatrix.iMatrix, 1, iMatrix, 1, iSize);
            return *this;
        }
        
        Matrix<float>& operator-=(const Matrix<float>& pMatrix)
        {
            vsub(pMatrix.iMatrix, 1, iMatrix, 1, iMatrix, 1, iSize);
            return *this;
        }
        
        Matrix<float>& operator*=(const Matrix<float>& pMatrix)
        {
            float* tNewMatrix = (float*)malloc(iYSize*pMatrix.iXSize*sizeof(float));
            
            for (size_t i = 0; i < iYSize; i++)
            { 
                for (size_t j = 0; j < pMatrix.iXSize; j++)
                {
                    dotpr(&(iMatrix[i]), iYSize, &(pMatrix.iMatrix[j*pMatrix.iYSize]), 1, &(tNewMatrix[j*iYSize+i]), iXSize);
                }
            }
            free(iMatrix);
            iXSize = pMatrix.iXSize;
            iSize = iYSize*iXSize; 
            iMatrix=tNewMatrix;
            return *this;
        }
        
        inline float getValue(const short pIndex) const
        {
            return iMatrix[pIndex];
        }
        
		inline float& operator[](const size_t pIndex) const
		{
			return iMatrix[pIndex];
		}
		
        inline float getValue(const short pXIndex, const short pYIndex) const
        {
            return iMatrix[pXIndex*iYSize+pYIndex];
        }
        
        inline void setValue(const float pValue, const short pIndex)
        {
            iMatrix[pIndex] = pValue;
        }
        
        inline void setValue(const float pValue, const short pXIndex, const short pYIndex)
        {
            iMatrix[pXIndex*iYSize+pYIndex] = pValue;
        }
        
        std::ostream& output(std::ostream& pStream)
        {
            for (size_t i = 0; i < iYSize; i++)
            {
                pStream << "[";
                for (size_t j = 0; j < iXSize; j++)
                {
                    if (j != 0)
                    {
                        pStream << ", ";
                    }
                    pStream << this->getValue(j, i);
                }
                pStream << "]";
                if (i+1 != iYSize)
                {
                    pStream << "\n";
                }
            }
            return pStream;
        }
        
        Matrix<float>& operator=(const Matrix<float>& pMatrix)
        {
            if (iSize != pMatrix.iSize)
            {
                iSize = pMatrix.iSize;
                free(iMatrix);
                iMatrix = new float[iSize];
            }
            memcpy(iMatrix, pMatrix.iMatrix, sizeof(float)*iSize); 
            iXSize = pMatrix.iXSize;
            iYSize = pMatrix.iYSize;
            return *this;
        }
        
        template <class otherType>
        Matrix<float>& operator=(const Matrix<otherType>& pMatrix)
        {
            resize(pMatrix.sizeX(), pMatrix.sizeY());
            for (size_t i = 0; i< iSize; i++)
            {
                iMatrix[i] = (float)pMatrix.getValue(i);
            }
            return *this;
        }
        
        inline Matrix<float>& add(Matrix<float>& pMatrix1, Matrix<float>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            vadd(iMatrix, 1, pMatrix1.iMatrix, 1, pResult.iMatrix, 1, iSize);
			return pResult;
        }
           
        inline Matrix<float>& sub(Matrix<float>& pMatrix1, Matrix<float>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            vsub(pMatrix1.iMatrix, 1, iMatrix, 1, pResult.iMatrix, 1, iSize);
			return pResult;
        }
		
		inline Matrix<float>& sub(float pValue, Matrix<float>& pResult)	
        {
			Matrix<float> tSub(iXSize, iYSize, pValue);
            this->sub(tSub, pResult);
			return pResult;
        }
        
		inline Matrix<float>& mul(const float pMultiplier, Matrix<float>& pResult)
		{
			vsmul(iMatrix, 1, &pMultiplier, pResult.iMatrix, 1, iSize);
			return pResult;
		}
		   
        inline void mul(Matrix<float>& pMatrix1, Matrix<float>& pResult)	//A faster multiply this doesn't check to see if the result matrix is the correct size before inserting the results
        {
            pResult.iXSize = pMatrix1.iXSize;
            pResult.iYSize = iYSize;
            for (size_t i = 0; i < iYSize; i++)
            { 
                for (size_t j = 0; j < pMatrix1.iXSize; j++)
                {
                    dotpr(&(iMatrix[i]), iYSize, &(pMatrix1.iMatrix[j*pMatrix1.iYSize]), 1, &(pResult.iMatrix[j*iYSize+i]), iXSize);
                }
            }
        }
        
        void resize(const short pXSize, const short pYSize)
        {
            size_t tSize = pXSize*pYSize;
            float* tMatrix = (float*)malloc(sizeof(float) * tSize);
            
            memcpy(tMatrix, iMatrix, sizeof(float)* (tSize < iSize?tSize:iSize));
            free(iMatrix);
            iMatrix = tMatrix;
            iSize = tSize;
            iXSize = pXSize;
            iYSize = pYSize;
        }
        
        void fill(const float pValue)
        {
            for (size_t i = 0; i < iSize; i++)
            {
                iMatrix[i] = pValue;
            }
        }
        
        bool operator ==(Matrix<float>& pMatrix2)
        {
            if (pMatrix2.iXSize == iXSize && pMatrix2.iYSize == iYSize)
            {
                return bcmp(iMatrix, pMatrix2.iMatrix, iSize*sizeof(float))==0;
            }
            return false;
        }
        
      /*  void transpose()
        {
            size_t tXSize = iYSize, tYSize = iXSize;
             
            for (size_t x = 0; x < iXSize; x++)
            {
                for (size_t y = 0; y < iYSize-(iXSize-x); y++)
                {
                    float tTemp = iMatrix[y*tYSize+x];
                    iMatrix[y*tYSize+x] = iMatrix[x*iYSize+y];
                    iMatrix[x*iYSize+y] = tTemp;
                }
            }
            iYSize = tXSize;
            iXSize = tYSize;
        }*/
        
        void transpose()
        {
            if (iXSize == iYSize)   
            {//in situ transpose For square matrices
                for (size_t x = 0; x < iXSize; x++)
                {
                    for (size_t y = 0; y < iYSize-(iXSize-x); y++)
                    {
                        float tTemp = iMatrix[y*iYSize+x];
                        iMatrix[y*iYSize+x] = iMatrix[x*iYSize+y];
                        iMatrix[x*iYSize+y] = tTemp;
                    }
                }
            }
            else
            {
                size_t tXSize = iYSize, tYSize = iXSize;
                float* tMatrix = new float[iSize];
                for (size_t x = 0; x < iXSize; x++)
                {
                    for (size_t y = 0; y < iYSize; y++)
                    {
                        tMatrix[y*tYSize+x] = iMatrix[x*iYSize+y];
                    }
                }
                delete[] iMatrix;
                iMatrix = tMatrix;
                iYSize = tYSize;
                iXSize = tXSize;
            }
        }
        
        inline float sum()
        {
            float tSum = 0;
            
            for (size_t i = 0;  i < iSize; i ++)
            {
                tSum += iMatrix[i];
            }
            return tSum;
        }
        
        inline float abssum()
        {
            float tSum = 0;
            
            for (size_t i = 0;  i < iSize; i ++)
            {
                tSum += fabs(iMatrix[i]);
            }
            return tSum;
        }
        
        void makeDiagonal(float pDiag = 1.0f, float pOuter = 0.0f)
        {
            fill(pOuter);
            for (size_t i = 0; i < iXSize && i < iYSize; i++)
            {
                setValue(pDiag, i, i);
            }
        }
        
        int bytecmp(const Matrix<float>& pValue2)
        {
            return memcmp(iMatrix, pValue2.iMatrix, sizeof(float)*iSize);
        }
		
		float determinant()
		{
			if (iSize == 1)
				return getValue(0, 0);
			float tDet = 0;
			if (iXSize != iYSize)
				throw MatrixException(kSquareMatrixN, kSquareMatrix);
			for (size_t i = 0; i < iXSize; ++i)
			{
				int sgn = ( i % 2) ? -1 : 1;
				Matrix<float> tCofactor;
				cofactor(i, 0, tCofactor);
				tDet += sgn * getValue(i, 0) * tCofactor.determinant();
			}
			return tDet;
		}
		
		Matrix<float>& cofactor(size_t x, size_t y, Matrix<float>& pResult) const
		{
			pResult.resize(iXSize-1, iYSize-1);
			for (size_t i = 0, k = 0; i < iXSize; ++i) 
			{
				if ( i != x) 
				{
					for (size_t j = 0, l = 0; j < iYSize; ++j) 
					{
						if ( j != y) 
						{
							pResult.setValue(getValue(i, j), k, l);
							++l;
						}
					}
					++k;
				}
			}
			return pResult;
		}
		
		Matrix<float>& inv()
		{
			if (iXSize != iYSize)
				throw MatrixException(kSquareMatrixN, kSquareMatrix);
				
			Matrix<float> tResult(iXSize, iXSize); //Using xSize because then we don't need to put ySize in a register.
												//Probably want help in the slightest but want do any harm.
			Matrix<float> tCofactor(iXSize-1, iXSize-1);
			for (size_t i = 0; i < iXSize; i++)
			{
				for (size_t j = 0; j < iXSize; j++)
				{
					int tSign = ((i+j)%2) ? -1 : 1;
					float tTemp = tSign*cofactor(i, j, tCofactor).determinant();
					tResult.setValue(tTemp, j, i);
				}
			}
			(*this) = tResult.mul(1/determinant(), tResult);
			return *this;
		}
};
#endif

template <class type>
Matrix<type> operator+(const Matrix<type>& pMatrix1, const Matrix<type>& pMatrix2)
{
    return Matrix<type>(pMatrix1) += pMatrix2;
}

template <class type>    
Matrix<type> operator-(const Matrix<type>& pMatrix1, const Matrix<type>& pMatrix2)
{
    return Matrix<type>(pMatrix1) -= pMatrix2;
}

template <class type>
Matrix<type> operator*(const Matrix<type>& pMatrix1, const Matrix<type>& pMatrix2)
{
    return Matrix<type>(pMatrix1) *= pMatrix2;;
}

/*template <class fromType, class toType>
Matric<toType> convertTo(Matrix<fromType>& pMatrix)
{

}*/

template <class type>
std::ostream& operator<<(std::ostream& pStream, Matrix<type>& pMatrix)
{
    return pMatrix.output(pStream);
}

/* This class is used for reading in matrices with a floating point type.
 * The matrix should follow the same form as matrices defined in MatLab
 * e.g. [1.0 2.0 3.0; 4.0 5.0 6.0; 8.0 9.0 10.0] (; define the end of rows)
 * this will later be expanded so that it can handle many diffrent types of
 * matrix.
 */
class MatrixReader:public Matrix<short>
{
    private:
        static int countMaxNumberOfColumns(char* pString);
        static int countNumberOfRows(char* pString);
        static int countNumberOfColumns(char** pString);
        void fillMatrix(char* pLine, int pX, int pY);
        void fillMatrix(char* pLine);
    public:
		MatrixReader();
        MatrixReader(char *pMatrixLine);
		MatrixReader& initWith(char *pMatrixLine);
        ~MatrixReader();
};

#endif
