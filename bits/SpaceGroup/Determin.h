/*
 *  Determin.h
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


class UnitCell
{
private:
    double iA, iB, iC, iAlpha, iBeta, iGamma;
    double iSEA, iSEB, iSEC, iSEAlpha, iSEBeta, iSEGamma;    
public:
    void setA(double pA);
    void setB(double pB);
    void setC(double pC);
    void setAlpha(double pAlpha);
    void setBeta(double pBeta);
    void setGamma(double pGamma);
    double getA();
    double getB();
    double getC();
    double getAlpha();
    double getBeta();
    double getGamma();
    void setSEA(double pSEA);
    void setSEB(double pSEB);
    void setSEC(double pSEC);
    void setSEAlpha(double pSEAlpha);
    void setSEBeta(double pSEBeta);
    void setSEGamma(double pSEGamma);
    double getSEA();
    double getSEB();
    double getSEC();
    double getSEAlpha();
    double getSEBeta();
    double getSEGamma();
};

