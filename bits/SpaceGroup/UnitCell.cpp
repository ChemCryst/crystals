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

/*
 *The unit cell class which stores the unit cell parameters.
 *
 */

//#include "stdafx.h"    //This is need for compiling on windowz. Cannot put precomp if round it because M$ are a pain.

#include "UnitCell.h"
#include "Exceptions.h"
#include "Collections.h"
#include "MathFunctions.h"
#include "StringClasses.h"
#include "Wrappers.h"
#include <iostream.h>
#include <map>
#include <cmath>

#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif


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

float UnitCell::getA() const
{
    return iA;
}

float UnitCell::getB() const
{
    return iB;
}

float UnitCell::getC() const
{
    return iB;
}

float UnitCell::getAlpha() const
{
    return iAlpha;
}

float UnitCell::getBeta() const
{
    return iBeta;
}

float UnitCell::getGamma() const
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

float UnitCell::getSEA() const
{
    return iSEA;
}

float UnitCell::getSEB() const
{
    return iSEB;
}

float UnitCell::getSEC() const
{
    return iSEC;
}

float UnitCell::getSEAlpha() const
{
    return iSEAlpha;
}

float UnitCell::getSEBeta() const
{
    return iSEBeta;
}

float UnitCell::getSEGamma() const
{
    return iSEGamma;
}

Matrix<float> UnitCell::metricTensor()const
{
    float tMatrix[] = {iA*iA, iA*iB*cos(deg2rad(iGamma)), iA*iC*cos(deg2rad(iBeta)), 
                       iB*iA*cos(deg2rad(iGamma)), iB*iB, iB*iC*cos(deg2rad(iAlpha)),
                       iC*iA*cos(deg2rad(iBeta)), iC*iB*cos(deg2rad(iAlpha)), iC*iC};
    Matrix<float> tMatricTensor(tMatrix, 3, 3);
    return tMatricTensor;
}

/*
 * This output a list of the crystal systems with there 
 * index next them
 */
std::ostream& printCrystConst(std::ostream& pStream)
{
    unsigned int i = 0;
    char* tText = crystalSystemConst((UnitCell::systemID)i);
    while (tText != NULL)
    {
        pStream << i << ": " << tText << "\n";
        i ++;
        tText = crystalSystemConst((UnitCell::systemID)i);
    }
    return pStream;
}

char* getCrystalSystem(const UnitCell::systemID pDefault)
{
    char* iSelect = new char[255];
    char* tString = NULL;
    char* tEnd = NULL;
    
    do
    {
        std::cout << "\n" << printCrystConst << "Select crystal system[" << pDefault << "]:";
        std::cin.getline(iSelect, 255);
        if (iSelect[0] == '\0')
        {
            tString = crystalSystemConst(pDefault);
        }
        tString = crystalSystemConst((UnitCell::systemID)strtol(iSelect, &tEnd, 10));
    }
    while (tEnd[0] != '\0' || tString == NULL);
    delete[] iSelect;
    return tString;
}

/*
 * Requests the user for a crystal system.
 */
char* getCrystalSystem()
{
   return getCrystalSystem(UnitCell::kMonoclinicB);
}

/*
 * Returns the index of the crystal system which is 
 * passed in pSystem
 */
UnitCell::systemID indexOfSystem(String& pSystem, String& pUnique)
{
    pSystem.upcase();
    pUnique.upcase();
    if (pSystem.cmp("TRICLINIC") == 0)
    {
        return UnitCell::kTriclinic;
    }
    else if (pSystem.cmp("MONOCLINIC") == 0)
    {
        if (pUnique.cmp("A") == 0)
        {
            return UnitCell::kMonoclinicA;
        }
        else if (pUnique.cmp("C") == 0)
        {
            return UnitCell::kMonoclinicC;
        }
        else if (pUnique.cmp("B")==0 || pUnique.cmp("UNKNOWN")==0)
        {
            return UnitCell::kMonoclinicB;
        }
    }
    else if (pSystem.cmp("ORTHORHOMBIC") == 0)
    {
        return UnitCell::kOrtharombic;
    }
    else if (pSystem.cmp("TETRAGONAL") == 0)
    {
        return UnitCell::kTetragonal;
    }
    else if(pSystem.cmp("TRIGONAL") == 0)
    {
        return UnitCell::kTrigonal;
    }
    else if(pSystem.cmp("TRIGONAL(RHOM)") == 0)
    {
        return UnitCell::kTrigonalRhom;
    }
    else if(pSystem.cmp("HEXAGONAL") == 0)
    {
        return UnitCell::kHexagonal;
    }
    else if(pSystem.cmp("CUBIC") == 0)
    {
        return UnitCell::kCubic;
    }
    return UnitCell::kTriclinic;
}

char* crystalSystemConst(const UnitCell::systemID pIndex)
{
    switch (pIndex)
    {
        case UnitCell::kTriclinic:
            return "Triclinic";
        break;
        case UnitCell::kMonoclinicA:
            return "MonoclinicA";
        break;
        case UnitCell::kMonoclinicB:
            return "MonoclinicB";
        break;
        case UnitCell::kMonoclinicC:
            return "MonoclinicC";
        break;
        case UnitCell::kOrtharombic:
            return "Orthorhombic";
        break;
        case UnitCell::kTetragonal:
            return "Tetragonal";
        break;
        case UnitCell::kTrigonal:
            return "Trigonal";
        break;
        case UnitCell::kTrigonalRhom:
            return "Trigonal(Rhom)";
        break;
        case UnitCell::kHexagonal:
            return "Hexagonal";
        break;
        case UnitCell::kCubic:
            return "Cubic";
        break;
    }
    return NULL;
}

UnitCell::UnitCell()
{
    iAlpha = 0;
    iBeta = 0;
    iGamma = 0;
    iA = 0;
    iB = 0;
    iC = 0;
}

bool UnitCell::init(char* pLine)	//This parases the line which it is passed. Initalising the feilds of the unit cell with it. If the line is not formated correctly then an false is returned.
{
    regex_t tAngles;
    /**************************************/
    /*** Set up the regular expressions ***/
    /**************************************/
     regcomp(&tAngles, 
     "CELL[[:space:]]+([-+]?[[:digit:]]+(\\.[[:digit:]]+)?)[[:space:]]+([-+]?[[:digit:]]+(\\.[[:digit:]]+)?)[[:space:]]+([-+]?[[:digit:]]+(\\.[[:digit:]]+)?)[[:space:]]+([-+]?[[:digit:]]+(\\.[[:digit:]]+)?)[[:space:]]+([-+]?[[:digit:]]+(\\.[[:digit:]]+)?)[[:space:]]+([-+]?[[:digit:]]+(\\.[[:digit:]]+)?)",
      REG_EXTENDED);
    regmatch_t tMatch[13];
    
    //Run line through regular expression
    if (!regexec(&tAngles, pLine, 13, tMatch, 0))
    {
        String tAlpha(pLine, (int)tMatch[7].rm_so, (int)tMatch[7].rm_eo);
        String tBeta(pLine, (int)tMatch[9].rm_so, (int)tMatch[9].rm_eo);
        String tGamma(pLine, (int)tMatch[11].rm_so, (int)tMatch[11].rm_eo);
        String tA(pLine, (int)tMatch[1].rm_so, (int)tMatch[1].rm_eo);
        String tB(pLine, (int)tMatch[3].rm_so, (int)tMatch[3].rm_eo);
        String tC(pLine, (int)tMatch[5].rm_so, (int)tMatch[5].rm_eo);
        iAlpha = (float)tAlpha.toDouble();
        iBeta = (float)tBeta.toDouble();
        iGamma = (float)tGamma.toDouble();
        iA = (float)tA.toDouble();
        iB = (float)tB.toDouble();
        iC = (float)tC.toDouble();
        return true;
    }
    //Return that the line didn't match the regular expression.
    return false;
}

std::ostream& UnitCell::output(std::ostream& pStream) const
{
    pStream << "Alpha = " << iAlpha <<  " Beta = " << iBeta << " Gamma = " << iGamma << "\n";
    pStream << "a = " << iA << " b = " << iB << " c = " << iC;
    return pStream;
}

float UnitCell::volume() const
{
    float cosa = cos(iAlpha/180*M_PI);
    float cosb = cos(iBeta/180*M_PI);
    float cosg = cos(iGamma/180*M_PI);
    
    return iA*iB*iC*sqrt(1-sqr(cosa)-sqr(cosb)-sqr(cosg)+2*cosa*cosb*cosg);
}

float UnitCell::calcMaxIndex(const int pMaxNumRef, const float pAxisLength) const
{
    float V = volume();
    float value = pow(0.6e1, 0.1e1 / 0.3e1) * pow(pMaxNumRef / M_PI / V, 0.1e1 / 0.3e1) * pAxisLength / 0.2e1;
    return value;
}

std::ostream& operator<<(std::ostream& pStream, const UnitCell& pUnitCell)
{
    return pUnitCell.output(pStream);
}