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

#include "HKLData.h"
#include "Collections.h"
#include <stdio.h>
#include <string.h>
#include <iostream.h>
#include "Exceptions.h"
#include <sys/stat.h>
     
/**********************************/
/***	Error numbers		***/
/**********************************/
#define kBadlyFormatedStringN -1
 
/**********************************/
/***	Error string		***/
/**********************************/
#define kBadlyFormatedString "String wasn't formated as expected."

/*class Reflection
{
public:
    double h, k, l;
    double i, iSE;*/
    
bool containsOnly(char* pString, char* pChars)
{
    int tStringLength = strlen(pString);
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
        
        tHKL = new Matrix<float>(1, 3);
        if (containsOnly(pString, " 0123456789.-+"))
        {
            throw MyException(kBadlyFormatedStringN, kBadlyFormatedString);
        }
        strncpy(tempString, pString, 4);
        tempString[4] = 0;
        tHKL->setValue((float)strtol(tempString, &tEndPointer, 10), 0);
        strncpy(tempString, pString+4, 4);
        tempString[4] = 0;
        tHKL->setValue((float)strtol(tempString, &tEndPointer, 10), 1);
        strncpy(tempString, pString+8, 4);
        tempString[4] = 0;
        tHKL->setValue((float)strtol(tempString, &tEndPointer, 10), 2);
        strncpy(tempString, pString+12, 8);
        tempString[8] = 0;
        i = strtod(tempString, &tEndPointer);
        strncpy(tempString, pString+20, 8);
        tempString[8] = 0;
        iSE = strtod(tempString, &tEndPointer);
    }
    
    Matrix<float>* Reflection::getHKL()
    {
        return tHKL;
    }
    
    Reflection::~Reflection()
    {
        delete tHKL;
    }

long fsize(char* pPath)
{
    struct stat tFileStat;
    
    stat(pPath, &tFileStat);
    
    return tFileStat.st_size;
}

HKLData::HKLData(char* pPath)
{
    char tLine[255];
    FILE* tFile = fopen(pPath, "r");
    
    if (tFile == NULL)
    {
        throw FileException(errno);
    }
    long tFileSize = fsize(pPath);
    
    tReflectionList = new ArrayList<Reflection>(tFileSize/34);
    bool tHadZeros = false;
    while (fgets(tLine, 255, tFile))
    {
        Reflection* tReflection = new Reflection(tLine);
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
        tReflectionList->add(tReflection);
    }
    fclose(tFile);
}

HKLData::~HKLData()
{
    long tReflections = tReflectionList->length();
    
    cout << "Removing " << tReflections << " reflections\n";
    for (long i = tReflections-1; i >= 0; i--)
    {
        delete tReflectionList->remove(i);
    }
}

typedef struct __CenteringType
{
    int iTotalNumber;	//The number of reflections counted
    int iIntSigma;     	//The number of reflections counted where int>3sigma.
    float iIntTotal;	//The total intensity for all the reflections
    //Need to add	//The total intensity/sigma of the reflections
}CenteringType;

ostream& operator<<(ostream& pStream, CenteringType& pInfo)
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

Reflection* HKLData::getReflection(int pIndex)
{
    return tReflectionList->get(pIndex);
}

int HKLData::numberOfReflections()
{
    return tReflectionList->length();
}