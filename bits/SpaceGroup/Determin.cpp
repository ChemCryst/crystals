/*
 *  Determin.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Oct 29 2002.
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
 * e.g.
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

#include "Determin.h"

void UnitCell::setA(double pA)
{
    iA = pA;
}

void UnitCell::setB(double pB)
{
    iB = pB;
}

void UnitCell::setC(double pC)
{
    iC = pC;
}

void UnitCell::setAlpha(double pAlpha)
{
    iAlpha = pAlpha;
}

void UnitCell::setBeta(double pBeta)
{
    iBeta = pBeta;
}

void UnitCell::setGamma(double pGamma)
{
    iGamma = pGamma;
}

double UnitCell::getA()
{
    return iA;
}

double UnitCell::getB()
{
    return iB;
}

double UnitCell::getC()
{
    return iB;
}

double UnitCell::getAlpha()
{
    return iAlpha;
}

double UnitCell::getBeta()
{
    return iBeta;
}

double UnitCell::getGamma()
{
    return iGamma;
}

void UnitCell::setSEA(double pSEA)
{
    iSEA = pSEA;
}

void UnitCell::setSEB(double pSEB)
{
    iSEB = pSEB;
}

void UnitCell::setSEC(double pSEC)
{
    iSEC = pSEC;
}

void UnitCell::setSEAlpha(double pSEAlpha)
{
    iSEAlpha = pSEAlpha;
}

void UnitCell::setSEBeta(double pSEBeta)
{
    iSEBeta = pSEBeta;
}

void UnitCell::setSEGamma(double pSEGamma)
{
    iSEGamma = pSEGamma;
}

double UnitCell::getSEA()
{
    return iSEA;
}

double UnitCell::getSEB()
{
    return iSEB;
}

double UnitCell::getSEC()
{
    return iSEC;
}

double UnitCell::getSEAlpha()
{
    return iSEAlpha;
}

double UnitCell::getSEBeta()
{
    return iSEBeta;
}

double UnitCell::getSEGamma()
{
    return iSEGamma;
}

typedef struct ExtraInfo
{
    bool inorganic;
};

enum
{
    kTriclinic = 0,
    kMonoclinic,
    kOrthorhombic,
    kTetragonal,
    kTrigonal,
    kHexagonal,
    kCubic
};

int predictedPointGroup(ExtraInfo *pExtra)
{
    return 0;
}


