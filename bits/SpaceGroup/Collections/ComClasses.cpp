/*
 *  ComClasses.cpp
 *
 *  Created by d922qg on Mon Oct 22 2001.
 *  Copyright (c) 2001 Unknown Company. All rights reserved.
 *
 */
#include "ComClasses.h"
#include <ctype.h>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>

using namespace std;

std::ostream& operator<<(std::ostream& pStream, MyObject& pObject)
{
    char tString[255];
    
    pObject.toString(tString, 255);
    return pStream << tString;
}

/**************************************************************************/
/***	Class MyObject methods						***/
/**************************************************************************/
static long iObjectNum = 0;
static long iObjectCount = 0;

MyObject::MyObject()
{
    iObjectNumber = iObjectNum++;
    iObjectCount++;
    #ifdef __EXTRA_DEBUGGING__
    std::cout << *this << " constructed.\n";
    std::cout.flush();
    #endif
}

MyObject::~MyObject()
{
    iObjectCount--;
    #ifdef __EXTRA_DEBUGGING__
    std::cout << *this << " destroyed.\n";
    std::cout.flush();
    #endif
}

void MyObject::toString(char* pChars, unsigned int pSize)
{
#if !defined(_WIN32)
    snprintf(pChars, pSize, "MyObject ID = 0x%4x", (int)iObjectNumber);
#else
	sprintf(pChars, "MyObject ID = 0x%4x", (long)iObjectNumber);
#endif
}

long MyObject::objectCount()
{
    return iObjectCount;
}

long MyObject::TotalObjectNumber()
{
    return iObjectNum;
}

