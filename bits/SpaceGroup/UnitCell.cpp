/*
 *  UnitCell.cpp
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
 * float tSomeVariable;   //A variable which is declared inside method.
 * float pSomeParameter   //A variable which is a parameter to a method/function
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
#include "UnitCell.h"
#include <iostream.h>

void UnitCell::setA(float pA)
{
    iA = pA;
}

void UnitCell::setB(float pB)
{
    iB = pB;
}

void UnitCell::setC(float pC)
{
    iC = pC;
}

void UnitCell::setAlpha(float pAlpha)
{
    iAlpha = pAlpha;
}

void UnitCell::setBeta(float pBeta)
{
    iBeta = pBeta;
}

void UnitCell::setGamma(float pGamma)
{
    iGamma = pGamma;
}

float UnitCell::getA()
{
    return iA;
}

float UnitCell::getB()
{
    return iB;
}

float UnitCell::getC()
{
    return iB;
}

float UnitCell::getAlpha()
{
    return iAlpha;
}

float UnitCell::getBeta()
{
    return iBeta;
}

float UnitCell::getGamma()
{
    return iGamma;
}

void UnitCell::setSEA(float pSEA)
{
    iSEA = pSEA;
}

void UnitCell::setSEB(float pSEB)
{
    iSEB = pSEB;
}

void UnitCell::setSEC(float pSEC)
{
    iSEC = pSEC;
}

void UnitCell::setSEAlpha(float pSEAlpha)
{
    iSEAlpha = pSEAlpha;
}

void UnitCell::setSEBeta(float pSEBeta)
{
    iSEBeta = pSEBeta;
}

void UnitCell::setSEGamma(float pSEGamma)
{
    iSEGamma = pSEGamma;
}

float UnitCell::getSEA()
{
    return iSEA;
}

float UnitCell::getSEB()
{
    return iSEB;
}

float UnitCell::getSEC()
{
    return iSEC;
}

float UnitCell::getSEAlpha()
{
    return iSEAlpha;
}

float UnitCell::getSEBeta()
{
    return iSEBeta;
}

float UnitCell::getSEGamma()
{
    return iSEGamma;
}

char* UnitCell::guessCrystalSystem()
{
/*    
"Triclinic"
"Monoclinic"
"Orthorhombic"
"Tetragonal"
"Trigonal"
"Hexagonal"
"Cubic"
*/
    return NULL;
}

char* getCrystalSystem()
{
    int iSelect = -1;
    do
    {
        std::cout << "0: Triclinic\n" <<
            "1: MonoclinicA\n" <<
            "2: MonoclinicB\n" <<
            "3: MonoclinicC\n" <<
            "4: Orthorhombic\n" <<
            "5: Tetragonal\n" <<
            "6: Trigonal\n" <<
            "7: Hexagonal\n" <<
            "8: Cubic\nSelect crystal system:";
        std::cin >> iSelect;
        return crystalSystemConst(iSelect);
    }
    while (iSelect < 0 && iSelect > 6);
    return 0;
}

char* crystalSystemConst(int pIndex)
{
    switch (pIndex)
    {
        case 0:
            return "Triclinic";
        break;
        case 1:
            return "MonoclinicA";
        break;
        case 2:
            return "MonoclinicB";
        break;
        case 3:
            return "MonoclinicC";
        break;
        case 4:
            return "Orthorhombic";
        break;
        case 5:
            return "Tetragonal";
        break;
        case 6:
            return "Trigonal";
        break;
        case 7:
            return "Hexagonal";
        break;
        case 8:
            return "Cubic";
        break;
    }
    return NULL;
}

void UnitCell::readInUnitCell(char* tPath)	//Reads in from the file provided
{
    
}
