/*
 *  HKLData.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed Oct 30 2002.
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
//#include "stdafx.h"
#include "HKLData.h"
#include "Collections.h"
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include "Exceptions.h"
#include <errno.h>
#include <sys/stat.h>
     
/**********************************/
/***	Error numbers		***/
/**********************************/
#define kBadlyFormatedStringN -1
 
/**********************************/
/***	Error string		***/
/**********************************/
#define kBadlyFormatedString "String wasn't formated as expected."

bool containsOnly(char* pString, char* pChars)
{
    int tStringLength = (int)strlen(pString);
    bool tValid = true;
    for (int i = 0; i < tStringLength && tValid; i++)
    {
        tValid = strchr(pChars, pString[i]) != NULL;
    }
    return tValid;
}

Reflection::Reflection(char* pString)
{
    char* tEndPointer;
    char tempString[10];
    
    tHKL = new Matrix<short>(1, 3);
    if (!containsOnly(pString, " 0123456789.-+\n\r"))
    {
        throw MyException(kBadlyFormatedStringN, kBadlyFormatedString);
    }
    strncpy(tempString, pString, 4);
    tempString[4] = 0;
    tHKL->setValue((short)strtol(tempString, &tEndPointer, 10), 0); // H == 0
    strncpy(tempString, pString+4, 4);
    tempString[4] = 0;
    tHKL->setValue((short)strtol(tempString, &tEndPointer, 10), 1); //K == 1
    strncpy(tempString, pString+8, 4);
    tempString[4] = 0;
    tHKL->setValue((short)strtol(tempString, &tEndPointer, 10), 2); //L == 2
    strncpy(tempString, pString+12, 8);
    tempString[8] = 0;
    i = (float)strtod(tempString, &tEndPointer);
    strncpy(tempString, pString+20, 8);
    tempString[8] = 0;
    iSE = (float)strtod(tempString, &tEndPointer);
}

Reflection::Reflection(const Reflection& pReflection):i(pReflection.i), iSE(pReflection.iSE)
{
    tHKL = new Matrix<short>(*pReflection.tHKL);
    i = pReflection.i;
    iSE = pReflection.iSE;
}

Reflection::Reflection():i(0), iSE(0)
{
    tHKL = new Matrix<short>();
}

Reflection::Reflection(const Matrix<short>& pHKL, float pI, float pSE):i(pI), iSE(pSE)
{
	tHKL = new Matrix<short>(pHKL);
}

Reflection& Reflection::operator=(const Reflection& pReflection)
{
    delete tHKL;
    tHKL = new Matrix<short>(*pReflection.tHKL);
    i = pReflection.i;
    iSE = pReflection.iSE;
    return *this;
}

Matrix<short>* Reflection::getHKL() const
{
    return tHKL;
}

const Matrix<short>& Reflection::hkl() const
{
	return *tHKL;
}

void Reflection::setHKL(const Matrix<short>& pMatrix)
{
   (*tHKL) = pMatrix; 
}

Reflection::~Reflection()
{
    delete tHKL;
}

bool Reflection::operator<(const Reflection& pReflection)
{
	//cout << "WOrked!\n";
	Matrix<short>* tHKL1 = this->getHKL();
	Matrix<short>* tHKL2 = pReflection.getHKL();
	int tValue = tHKL1->bytecmp(*tHKL2);
	if (tValue > 0)
	{
		return true;
	}
	return false;
}

std::ostream& operator<<(std::ostream& pStream, const Reflection& pReflection)
{
    pStream << "[" << pReflection.tHKL->getValue(0) << ", " << pReflection.tHKL->getValue(1) << ", " << pReflection.tHKL->getValue(2) << "] ";
    return pStream << pReflection.i << ", " << pReflection.iSE;
}

long fsize(char* pPath)
{
    struct stat tFileStat;
    
    stat(pPath, &tFileStat);
    
    return tFileStat.st_size;
}

HKLData::HKLData():vector<Reflection*>()
{

}

HKLData::HKLData(HKLData& pHKLs):vector<Reflection*>()
{
	vector<Reflection*>::iterator tIter;
	
	for (tIter = pHKLs.begin(); tIter != pHKLs.end(); tIter++)
	{
		push_back(new Reflection(*(*tIter)));
	}
}
		
HKLData::HKLData(char* pPath):vector<Reflection*>()
{
    char tLine[255];
	size_t tNumRef = 0;
    FILE* tFile = fopen(pPath, "r");
    
    if (tFile == NULL)
    {
        throw FileException(errno);
    }
    bool tHadZeros = false;
    while (fgets(tLine, 255, tFile))
    {
        Reflection* tReflection= new Reflection(tLine);
        if (tReflection->getHKL()->getValue(0) == 0 && tReflection->getHKL()->getValue(1) == 0 && tReflection->getHKL()->getValue(2) == 0
        && tReflection->i == 0.0)	//We might have already reached the end of the file.        	
        {
            if (tHadZeros)	//We have reached the end of the file.
            {
                delete tReflection;
                break;
            }
            tHadZeros = true;;
        }
        push_back(tReflection);
		tNumRef ++;
    }
    fclose(tFile);
}

/*Reflection* HKLData::operator[](size_type __n)
{

}*/

HKLData::~HKLData()
{
	#ifdef __DEBUG__
		std::cout << "Removing " << size() << " reflections\n";
	#endif
    while (!empty())
    {
        delete back();
		pop_back();
    }
}

typedef struct __CenteringType
{
    int iTotalNumber;	//The number of reflections counted
    int iIntSigma;     	//The number of reflections counted where int>3sigma.
    float iIntTotal;	//The total intensity for all the reflections
    //Need to add	//The total intensity/sigma of the reflections
}CenteringType;

std::ostream& operator<<(std::ostream& pStream, CenteringType& pInfo)
{
    return pStream << "N: " << pInfo.iTotalNumber << " N(Int<3*sigma): " << pInfo.iIntSigma << " Mean Int: " << pInfo.iIntTotal << "\n";
}

void addReflection(CenteringType* pInfo, float pIntensity, int pSum1, int pSum2, int pSum3, int pMod, float pSigma)
{
    if ((pSum1 + pSum2 + pSum3)%pMod != 0)
    {
        pInfo->iTotalNumber ++;
        if (pIntensity/pSigma > 3)
        {
            pInfo->iIntSigma ++;
            pInfo->iIntTotal += pIntensity;
        }
    }
}

float resipSphVol(float pAngRad, float pWaveLength)
{
    float tBragg = 2.0f*sinf(pAngRad)/pWaveLength;
    tBragg = tBragg * tBragg * tBragg;
    return 4.1888f * tBragg; // 4/3* PI = 4.1888
}