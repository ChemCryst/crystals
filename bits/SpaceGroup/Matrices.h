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
#include <iostream.h>
#include "ComClasses.h"
#if defined(__APPLE__)
#include <vecLib/vDSP.h>
#endif
#include "Exceptions.h"
//Error codes
#define kDimensionErrorN -1
#define kInnerDimensionErrorN -2

//Error strings
#define kDimensionError "Matrix dimesions must agree." 
#define kInnerDimensionError "Inner matrix dimesions must agree."

class MatrixException:public MyException
{
    public:
        MatrixException(int pErrNum, char* pErrType);
};

template <class type>
class Matrix:public MyObject
{
    private:
        type* 	iMatrix;
        short 	iXSize, iYSize, iSize;
    public:
        Matrix()
        {
            iXSize = 1;
            iYSize = 1;
            iSize = 1;
            iMatrix = new type[iSize];
        }
        
        Matrix(short pXSize, short pYSize) //uninitalised matrix constructor
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = new type[iSize];
        }
        
        Matrix(short pXSize, short pYSize, type pC) //initalised matrix constructor with c
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = new type[iSize];
            for (short i = 0; i < iSize; i++)
            {
                iMatrix[i] = pC;
            }
        }
        
        Matrix(const Matrix<type>& pMatrix):iXSize(pMatrix.iXSize), iYSize(pMatrix.iYSize), iSize(pMatrix.iSize)  //Copy constructor
        {
            iMatrix = new type[pMatrix.iSize];
            memcpy(iMatrix, pMatrix.iMatrix, pMatrix.iSize*sizeof(type));
        }

        ~Matrix()
        {	
            delete[] iMatrix;
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
        
        Matrix<type>& operator*=(Matrix<type>& pMatrix)
        {
            if (iXSize != pMatrix.iYSize)
            {
                throw MatrixException(kInnerDimensionErrorN,  kInnerDimensionError);
            }
            type* tNewMatrix = new type[iYSize*pMatrix.iXSize];
            for (int i = 0; i < iYSize; i ++)
            {
                for (int j = 0; j < pMatrix.iXSize; j ++)
                {
                    tNewMatrix[j*iYSize+i] = getValue(0, i)*pMatrix.getValue(j, 0); 
                    for (int k = 1; k < iXSize; k++)
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
        
        inline type getValue(const short pIndex)
        {
            return iMatrix[pIndex];
        }
        
        inline type getValue(const short pXIndex, const short pYIndex)
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
        
        std::ostream& output(std::ostream& pStream)
        {
            for (int i = 0; i < iYSize; i++)
            {
                pStream << "[";
                for (int j = 0; j < iXSize; j++)
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
        
        void add(Matrix<type>& pMatrix1, Matrix<type>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            for (int i = 0; i < iSize; i++)
            {
                pResult[i] = iMatrix[i] + pMatrix1.iMatrix[i];
            }
        }
           
        void sub(Matrix<type>& pMatrix1, Matrix<type>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            for (int i = 0; i < iSize; i++)
            {
                pResult[i] = iMatrix[i] - pMatrix1.iMatrix[i];
            }
        }
          
        void mul(Matrix<type>& pMatrix1, Matrix<type>& pResult)	//A faster multiply this doesn't check to see if the result matrix is the correct size before inserting the results
        {
            pResult.iXSize = pMatrix1.iXSize;
            pResult.iYSize = iYSize;
            for (int i = 0; i < iYSize; i ++)
            {
                for (int j = 0; j < pMatrix1.iXSize; j ++)
                {
                    pResult.iMatrix[j*iYSize+i] = getValue(0, i)*pMatrix1.getValue(j, 0); 
                    for (int k = 1; k < iXSize; k++)
                    {
                        pResult.iMatrix[j*iYSize+i] += getValue(k, i)*pMatrix1.getValue(j, k);
                    }
                } 
            }
        }
        
        void resize(const short pXSize, const short pYSize)
        {
            short tSize = pXSize*pYSize;
            type* tMatrix = (type*)malloc(sizeof(type) * tSize);
            
            memcpy(tMatrix, iMatrix, sizeof(type)* (tSize < iSize?tSize:iSize));
            free(iMatrix);
            iMatrix = tMatrix;
            iXSize = pXSize;
            iYSize = pYSize;
			iSize = iXSize * iYSize;
        }
        
        void fill(const type& pValue)
        {
            for (int i = 0; i < iSize; i++)
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
            int tXsize = iYSize, tYSize = iXSize;
            int x = 0, y = 1, c =1;
             
            for (int x = 0; x < iXSize; x++)
            {
                for (int y = 1; y < iYSize; y++)
                {
                    type tTemp = iMatrix[pXIndex*tYSize+pYIndex];
                    iMatrix[x*tYSize+y] = iMatrix[x*iYSize+y];
                }
            }
            iYSize = tXSize;
            iXSize = tYSize;

        }
        
        type sum()
        {
            type tSum = 0;
            
            for (int i = 0;  i < iSize; i ++)
            {
                tSum += iMatrix[i];
            }
            return tSum;
        }
};

#if defined (__APPLE__)
//Specialisation of the matrxi class. This will only work on a Apple PowerMac. This needs Mac OS 10.1 or later
template<>
class Matrix<float>:public MyObject
{
    private:
        float* 	iMatrix;
        short 	iXSize, iYSize, iSize;
    public:
        Matrix()
        {
            iXSize = 1;
            iYSize = 1;
            iSize = 1;
            iMatrix = (float*)malloc(sizeof(float)*iSize);
        }

        Matrix(short pXSize, short pYSize) //uninitalised matrix constructor
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = (float*)malloc(sizeof(float)*iSize);
        }
        
        Matrix(short pXSize, short pYSize, float pC) //initalised matrix constructor with c
        {
            iSize = pXSize * pYSize;
            iXSize = pXSize;
            iYSize = pYSize;
            
            iMatrix = (float*)malloc(sizeof(float)*iSize);
            for (short i = 0; i < iSize; i++)
            {
                iMatrix[i] = pC;
            }
        }
        
        Matrix(const Matrix<float>& pMatrix):iXSize(pMatrix.iXSize), iYSize(pMatrix.iYSize), iSize(pMatrix.iSize)  //Copy constructor
        {
            iMatrix = (float*)malloc(sizeof(float)*iSize);;
            memcpy(iMatrix, pMatrix.iMatrix, pMatrix.iSize*sizeof(float));
        }
        
        ~Matrix()
        {
            free(iMatrix);
        }
        
        Matrix<float>& operator+=(const Matrix<float>& pMatrix)
        {
            vadd(iMatrix, 1, pMatrix.iMatrix, 1, iMatrix, 1, iSize);
            return *this;
        }
        
        Matrix<float>& operator-=(const Matrix<float>& pMatrix)
        {
            vsub(iMatrix, 1, pMatrix.iMatrix, 1, iMatrix, 1, iSize);
            return *this;
        }
        
        Matrix<float>& operator*=(const Matrix<float>& pMatrix)
        {
            float* tNewMatrix = (float*)malloc(iYSize*pMatrix.iXSize*sizeof(float));
            
            for (int i = 0; i < iYSize; i++)
            { 
                for (int j = 0; j < pMatrix.iXSize; j++)
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
        
        inline float getValue(const short pIndex)
        {
            return iMatrix[pIndex];
        }
        
        inline float getValue(const short pXIndex, const short pYIndex)
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
            for (int i = 0; i < iYSize; i++)
            {
                pStream << "[";
                for (int j = 0; j < iXSize; j++)
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
        
        void add(Matrix<float>& pMatrix1, Matrix<float>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            vadd(iMatrix, 1, pMatrix1.iMatrix, 1, pResult.iMatrix, 1, iSize);
        }
           
        void sub(Matrix<float>& pMatrix1, Matrix<float>& pResult)	//A faster subtraction this doesn't check to see if the result matrix is the correct size before inserting the results it is assumed to be the correct size already
        {
            vsub(iMatrix, 1, pMatrix1.iMatrix, 1, pResult.iMatrix, 1, iSize);
        }
          
        void mul(Matrix<float>& pMatrix1, Matrix<float>& pResult)	//A faster multiply this doesn't check to see if the result matrix is the correct size before inserting the results
        {
            pResult.iXSize = pMatrix1.iXSize;
            pResult.iYSize = iYSize;
            for (int i = 0; i < iYSize; i++)
            { 
                for (int j = 0; j < pMatrix1.iXSize; j++)
                {
                    dotpr(&(iMatrix[i]), iYSize, &(pMatrix1.iMatrix[j*pMatrix1.iYSize]), 1, &(pResult.iMatrix[j*iYSize+i]), iXSize);
                }
            }
        }
        
        void resize(const short pXSize, const short pYSize)
        {
            short tSize = pXSize*pYSize;
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
            for (int i = 0; i < iSize; i++)
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
        
        float sum()
        {
            float tSum = 0;
            
            for (int i = 0;  i < iSize; i ++)
            {
                tSum += iMatrix[i];
            }
            return tSum;
        }
};
#endif

template <class type>
Matrix<type> operator+( Matrix<type>& pMatrix1,  Matrix<type>& pMatrix2)
{
    return Matrix<type>(pMatrix1) += pMatrix2;
}

template <class type>    
Matrix<type> operator-( Matrix<type>& pMatrix1,  Matrix<type>& pMatrix2)
{
    return Matrix<type>(pMatrix1) -= pMatrix2;
}

template <class type>
Matrix<type> operator*(Matrix<type>& pMatrix1, Matrix<type>& pMatrix2)
{
    return Matrix<type>(pMatrix1) *= pMatrix2;;
}

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
        MatrixReader(char *pMatrixLine);
        ~MatrixReader();
};

#endif