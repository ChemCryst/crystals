/*
 *  HKLData.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed Oct 30 2002.
 *  Copyright (c) 2002 BeaverSoft. All rights reserved.
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

#ifndef __HKL_DATA_H__
#define __HKL_DATA_H__
#include "Collections.h"
#include <stdio.h>
#include "Matrices.h"

class Reflection
{
public:
    Matrix<float>* tHKL;
    double i, iSE;
    
    Reflection(char* pString);
    ~Reflection();
    Matrix<float>* getHKL();
};

class HKLData
{
    private:
        ArrayList<Reflection>* tReflectionList;
    
    public:
        /**********************************************/
        /*** HKLData				***/
        /*** Parameters:				***/
        /***	pFile - A pointer to an open 	***/
        /***	file which as read access.	***/
        /**********************************************/
        HKLData(char* pPath);	
        ~HKLData();
        int numberOfReflections();
        Reflection* getReflection(int pIndex);
        bool find(Reflection* pReflection);
        void centeringTypeInfo();
};
#endif