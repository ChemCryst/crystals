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

/*!
 * @class UnitCell 
 * @description Not yet documented.
 * @abstract
*/
class UnitCell:public MyObject
{
private:
    float iA, iB, iC, iAlpha, iBeta, iGamma;
    float iSEA, iSEB, iSEC, iSEAlpha, iSEBeta, iSEGamma;    
public:
    UnitCell();
	UnitCell(const UnitCell& pUnitCell);
	UnitCell(const Matrix<float> &pUnitCellTensor);

    /*!
     * @function init 
     * @description Not yet documented.
     * @abstract
     */
    bool init(char* pLine);

    /*!
     * @function setA 
     * @description Not yet documented.
     * @abstract
     */
    void setA(float pA);

    /*!
     * @function setB 
     * @description Not yet documented.
     * @abstract
     */
    void setB(float pB);

    /*!
     * @function setC 
     * @description Not yet documented.
     * @abstract
     */
    void setC(float pC);

    /*!
     * @function setAlpha 
     * @description Not yet documented.
     * @abstract
     */
    void setAlpha(float pAlpha);

    /*!
     * @function setBeta 
     * @description Not yet documented.
     * @abstract
     */
    void setBeta(float pBeta);

    /*!
     * @function setGamma 
     * @description Not yet documented.
     * @abstract
     */
    void setGamma(float pGamma);

    /*!
     * @function getA 
     * @description Not yet documented.
     * @abstract
     */
    float getA() const;

    /*!
     * @function getB 
     * @description Not yet documented.
     * @abstract
     */
    float getB() const;

    /*!
     * @function getC 
     * @description Not yet documented.
     * @abstract
     */
    float getC() const;

    /*!
     * @function getAlpha 
     * @description Not yet documented.
     * @abstract
     */
    float getAlpha() const;

    /*!
     * @function getBeta 
     * @description Not yet documented.
     * @abstract
     */
    float getBeta() const;

    /*!
     * @function getGamma 
     * @description Not yet documented.
     * @abstract
     */
    float getGamma() const;

    /*!
     * @function setSEA 
     * @description Not yet documented.
     * @abstract
     */
    void setSEA(float pSEA);

    /*!
     * @function setSEB 
     * @description Not yet documented.
     * @abstract
     */
    void setSEB(float pSEB);

    /*!
     * @function setSEC 
     * @description Not yet documented.
     * @abstract
     */
    void setSEC(float pSEC);

    /*!
     * @function setSEAlpha 
     * @description Not yet documented.
     * @abstract
     */
    void setSEAlpha(float pSEAlpha);

    /*!
     * @function setSEBeta 
     * @description Not yet documented.
     * @abstract
     */
    void setSEBeta(float pSEBeta);

    /*!
     * @function setSEGamma 
     * @description Not yet documented.
     * @abstract
     */
    void setSEGamma(float pSEGamma);

    /*!
     * @function getSEA 
     * @description Not yet documented.
     * @abstract
     */
    float getSEA() const;

    /*!
     * @function getSEB 
     * @description Not yet documented.
     * @abstract
     */
    float getSEB() const;

    /*!
     * @function getSEC 
     * @description Not yet documented.
     * @abstract
     */
    float getSEC() const;

    /*!
     * @function getSEAlpha 
     * @description Not yet documented.
     * @abstract
     */
    float getSEAlpha() const;

    /*!
     * @function getSEBeta 
     * @description Not yet documented.
     * @abstract
     */
    float getSEBeta() const;

    /*!
     * @function getSEGamma 
     * @description Not yet documented.
     * @abstract
     */
    float getSEGamma() const;

    /*!
     * @function metricTensor 
     * @description Not yet documented.
     * @abstract
     */
    Matrix<float>& metricTensor(Matrix<float>& pResult)const;

    /*!
     * @function volume 
     * @description Not yet documented.
     * @abstract
     */
    float volume() const;

	/*!
	 * @function zero 
	 * @description Not yet documented.
	 * @abstract
	 */
	bool zero() const;

    /*!
     * @function calcMaxIndex 
     * @description Not yet documented.
     * @abstract
     */
    float calcMaxIndex(const int pMaxNumRef, const float pAxisLength) const;

    /*!
     * @function output 
     * @description Not yet documented.
     * @abstract
     */
    std::ostream& output(std::ostream& pStream)const;
	UnitCell operator=(const UnitCell& pUnitCell);

	/*!
	 * @function transform 
	 * @description Not yet documented.
	 * @abstract
	 */
	UnitCell transform(Matrix<float>& pTrasformation);
};


/*!
 * @function getCrystalSystem 
 * @description Not yet documented.
 * @abstract
 */
SystemID getCrystalSystem(SystemID pDefault);

/*!
 * @function crystalSystemConst 
 * @description Not yet documented.
 * @abstract
 */
char* crystalSystemConst(SystemID pIndex);

/*!
 * @function indexOfSystem 
 * @description Not yet documented.
 * @abstract
 */
SystemID indexOfSystem(String& pSystem, String& pUnique);
std::ostream& operator<<(std::ostream& pStream, const UnitCell& pUnitCell);
#endif
