/*
 *  UnitCell.h
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
 * e.g.. 
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
#ifndef __UNIT_CELL_H__
#define __UNIT_CELL_H__
#include "ComClasses.h"
#include "StringClasses.h"
#include "Matrices.h"
#include "LaueClasses.h"

class UnitCell:public MyObject
{
private:
    float iA, iB, iC, iAlpha, iBeta, iGamma;
    float iSEA, iSEB, iSEC, iSEAlpha, iSEBeta, iSEGamma;    
public:
    UnitCell();
	UnitCell(const UnitCell& pUnitCell);
	UnitCell(const Matrix<float> &pUnitCellTensor);
    bool init(char* pLine);
    void setA(float pA);
    void setB(float pB);
    void setC(float pC);
    void setAlpha(float pAlpha);
    void setBeta(float pBeta);
    void setGamma(float pGamma);
    float getA() const;
    float getB() const;
    float getC() const;
    float getAlpha() const;
    float getBeta() const;
    float getGamma() const;
    void setSEA(float pSEA);
    void setSEB(float pSEB);
    void setSEC(float pSEC);
    void setSEAlpha(float pSEAlpha);
    void setSEBeta(float pSEBeta);
    void setSEGamma(float pSEGamma);
    float getSEA() const;
    float getSEB() const;
    float getSEC() const;
    float getSEAlpha() const;
    float getSEBeta() const;
    float getSEGamma() const;
    Matrix<float>& metricTensor(Matrix<float>& pResult)const;
    float volume() const;
	bool zero() const;
    float calcMaxIndex(const int pMaxNumRef, const float pAxisLength) const;
    std::ostream& output(std::ostream& pStream)const;
	UnitCell operator=(const UnitCell& pUnitCell);
	UnitCell transform(Matrix<float>& pTrasformation);
};

SystemID getCrystalSystem(SystemID pDefault);
char* crystalSystemConst(SystemID pIndex);
SystemID indexOfSystem(String& pSystem, String& pUnique);
std::ostream& operator<<(std::ostream& pStream, const UnitCell& pUnitCell);
#endif
