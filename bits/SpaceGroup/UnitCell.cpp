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

#define _USE_MATH_DEFINES
#include "UnitCell.h"
#include "Exceptions.h"
#include "MathFunctions.h"
#include "StringClasses.h"
#include "Wrappers.h"
#include <iostream>
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

Matrix<float>& UnitCell::metricTensor(Matrix<float>& pResult)const
{
	pResult.resize(3, 3);
	pResult.setValue(iA*iA, 0, 0);
	pResult.setValue(iA*iB*cos(deg2rad(iGamma)), 0, 1);
	pResult.setValue(iA*iC*cos(deg2rad(iBeta)), 0, 2);
	pResult.setValue(iB*iB, 1, 1);
	pResult.setValue(iB*iC*cos(deg2rad(iAlpha)), 1, 2);
	pResult.setValue(iC*iC, 2, 2);
	
	pResult.setValue(pResult.getValue(0, 1), 1, 0);
	pResult.setValue(pResult.getValue(0, 2), 2, 0);
	pResult.setValue(pResult.getValue(1, 2), 2, 1);

    return pResult;
}

bool UnitCell::zero() const
{
	return ((fabsf(iA) + fabsf(iB) + fabsf(iC) + fabsf(iAlpha) + fabsf(iBeta) + fabsf(iGamma) +
	 fabsf(iSEA) + fabsf(iSEB) + fabsf(iSEC) + fabsf(iSEAlpha) + fabsf(iSEBeta) + fabsf(iSEGamma)) == 0);
}

UnitCell UnitCell::operator=(const UnitCell& pUnitCell)
{
	iA = pUnitCell.iA;
	iB = pUnitCell.iB;
	iC = pUnitCell.iC;
	iAlpha = pUnitCell.iAlpha;
	iBeta = pUnitCell.iBeta;
	iGamma = pUnitCell.iGamma;
	iSEA = pUnitCell.iSEA;
	iSEB = pUnitCell.iSEB;
	iSEC = pUnitCell.iSEC;
	iSEAlpha = pUnitCell.iSEAlpha;
	iSEBeta = pUnitCell.iSEBeta;
	iSEGamma = pUnitCell.iSEGamma;
	return *this;
}

UnitCell UnitCell::transform(Matrix<float>& pTrasformation)
{
	Matrix<float> tTensor;
	metricTensor(tTensor);
	Matrix<float> tTransformationTrans = pTrasformation; 
	tTransformationTrans.transpose();
	
	tTransformationTrans = (tTransformationTrans * tTensor ); //Reusing tTransformationTrans
	tTensor = tTransformationTrans* pTrasformation;
	return UnitCell(tTensor);
}

/*
 * This output a list of the crystal systems with there 
 * index next them
 */
std::ostream& printCrystConst(std::ostream& pStream)
{	
	for (unsigned int i = kTriclinicID; i < kUnknownID; i++)
	{
        pStream << i << ": " << crystalSystemConst((SystemID)i) << "\n";
    }
    return pStream;
}

SystemID getCrystalSystem(const SystemID pDefault)
{
    char* iSelect = new char[255];
    char* tEnd = NULL;
	SystemID tResult;
    
    do
    {
		printCrystConst(std::cout);
		std::cout << "Select crystal system[" << pDefault << "]:";
		//std::cin.ignore();
		std::cin.clear();
        std::cin.getline(iSelect, 255);
        if (iSelect[0] == '\0')
		{
            tResult = pDefault;
			tEnd = iSelect;
		}
        else
        { 
            unsigned int tCheckedResult = strtol(iSelect, &tEnd, 10);
			tResult = tCheckedResult >= kUnknownID ? kUnknownID:(SystemID)tCheckedResult;
        }
    }
    while (tEnd[0] != '\0' && tResult!=kUnknownID);
    delete[] iSelect;
    return tResult;
}

SystemID indexOfSystem(String& pSystem, String& pUnique)
{
    pSystem.upcase();
    pUnique.upcase();
    if (pSystem.cmp("TRICLINIC") == 0)
    {
        return kTriclinicID;
    }
    else if (pSystem.cmp("MONOCLINIC") == 0)
    {
        if (pUnique.cmp("A") == 0)
        {
            return kMonoclinicAID;
        }
        else if (pUnique.cmp("C") == 0)
        {
            return kMonoclinicCID;
        }
        else if (pUnique.cmp("B")==0 || pUnique.cmp("UNKNOWN")==0)
        {
            return kMonoclinicBID;
        }
    }
    else if (pSystem.cmp("ORTHORHOMBIC") == 0)
    {
        return kOrtharombicID;
    }
    else if (pSystem.cmp("TETRAGONAL") == 0)
    {
        return kTetragonalID;
    }
    else if(pSystem.cmp("TRIGONAL") == 0)
    {
        return kTrigonalID;
    }
    else if(pSystem.cmp("TRIGONAL(RHOM)") == 0)
    {
        return kTrigonalRhomID;
    }
    else if(pSystem.cmp("HEXAGONAL") == 0)
    {
        return kHexagonalID;
    }
    else if(pSystem.cmp("CUBIC") == 0)
    {
        return kCubicID;
    }
    return kUnknownID;
}


char* crystalSystemConst(const SystemID pIndex)
{
    switch (pIndex)
    {
        case kTriclinicID:
            return "TRICLINIC";
        break;
        case kMonoclinicAID:
            return "MONOCLINICA";
        break;
        case kMonoclinicBID:
            return "MONOCLINICB";
        break;
        case kMonoclinicCID:
            return "MONOCLINICC";
        break;
        case kOrtharombicID:
            return "ORTHORHOMBIC";
        break;
        case kTetragonalID:
            return "TETRAGONAL";
        break;
        case kTrigonalID:
            return "TRIGONAL";
        break;
        case kTrigonalRhomID:
            return "TRIGONAL(RHOM)";
        break;
        case kHexagonalID:
            return "HEXAGONAL";
        break;
        case kCubicID:
            return "CUBIC";
        break;
		case kUnknownID:
			throw MyException(kUnknownException, "Unknown Crystal System being used some how.");
		break;
    }
    return NULL;
}

UnitCell::UnitCell():iA(0), iB(0), iC(0), iAlpha(0), iBeta(0), iGamma(0),
    iSEA(0), iSEB(0), iSEC(0), iSEAlpha(0), iSEBeta(0), iSEGamma(0)
{
}

UnitCell::UnitCell(const UnitCell& pUnitCell):iA(pUnitCell.iA), iB(pUnitCell.iB), iC(pUnitCell.iC), iAlpha(pUnitCell.iAlpha), iBeta(pUnitCell.iBeta), iGamma(pUnitCell.iGamma),
    iSEA(pUnitCell.iSEA), iSEB(pUnitCell.iSEB), iSEC(pUnitCell.iSEC), iSEAlpha(pUnitCell.iSEAlpha), iSEBeta(pUnitCell.iSEBeta), iSEGamma(pUnitCell.iSEGamma)
{
}

/**************************************/
/*** Initilised the unitcell from a ***/
/*** matric tensor	            ***/
/**************************************/
UnitCell::UnitCell(const Matrix<float> &pT):iA(0), iB(0), iC(0), iAlpha(0), iBeta(0), iGamma(0),
    iSEA(0), iSEB(0), iSEC(0), iSEAlpha(0), iSEBeta(0), iSEGamma(0)
{
	iA = sqrt(pT.getValue(0, 0));
	iB = sqrt(pT.getValue(1, 1));
	iC = sqrt(pT.getValue(2, 2));
	iAlpha = rad2deg(acos(pT.getValue(2, 1)/(iB*iC)));
	iBeta = rad2deg(acos(pT.getValue(2, 0)/(iA*iC)));
	iGamma = rad2deg(acos(pT.getValue(1, 0)/(iB*iA)));
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
    float cosa = cosf(iAlpha/180.0f*(float)M_PI);
    float cosb = cosf(iBeta/180.0f*(float)M_PI);
    float cosg = cosf(iGamma/180.0f*(float)M_PI);
    
    return iA*iB*iC*sqrtf(1.0f-sqr(cosa)-sqr(cosb)-sqr(cosg)+2.0f*cosa*cosb*cosg);
}

float UnitCell::calcMaxIndex(const int pMaxNumRef, const float pAxisLength) const
{
    float V = volume();
    float value = powf(0.6e1f, 0.1e1f / 0.3e1f) * powf(pMaxNumRef / (float)M_PI / V, 0.1e1f / 0.3e1f) * pAxisLength / 0.2e1f;
    return value;
}

std::ostream& operator<<(std::ostream& pStream, const UnitCell& pUnitCell)
{
    return pUnitCell.output(pStream);
}
