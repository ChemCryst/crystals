/*
 *  HKLData.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed Oct 30 2002.
 *  Copyright (c) 2002 Unknown Company. All rights reserved.
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
#include <stdio.h>
#include "vector"
#include "Matrices.h"
#include "UnitCell.h"

using namespace std;

class Reflection:public MyObject
{
public:
    Matrix<short>* tHKL;
    float i, iSE;
    
    Reflection();
    Reflection(char* pString);
    Reflection(const Reflection& pReflection);
	Reflection(const Matrix<short>& pHKL, float pI, float pSE);
    Reflection& operator=(const Reflection& pReflection);
	bool operator<(const Reflection& pReflecton);
    ~Reflection();
    Matrix<short>* getHKL() const;
	const Matrix<short>& hkl() const;
    void setHKL(const Matrix<short>& pMatrix);
};

struct lsreflection
{
  bool operator()(const Reflection* pReflection1, const Reflection* pReflection2) const
  {
      Matrix<short>* tHKL1 = pReflection1->getHKL();
      Matrix<short>* tHKL2 = pReflection2->getHKL();
      int tValue = tHKL1->bytecmp(*tHKL2);
      if (tValue > 0)
      {
	  return true;
      }
      return false;
  }
};

std::ostream& operator<<(std::ostream& pStream, const Reflection& pReflection);

class HKLData:public vector<Reflection*>
{
	protected:
		Matrix<float> iUnitCellTensor; //The unit cell for the data
		Matrix<short> iTransf;
    public:
        /**********************************************/
        /*** HKLData				***/
        /*** Parameters:				***/
        /***	pFile - A pointer to an open 	***/
        /***	file which as read access.	***/
        /**********************************************/
		HKLData();
		HKLData(HKLData& pHKLs);
        HKLData(char* pPath, Matrix<float>& pUnitCellTensor);	
        virtual ~HKLData();
        bool find(const Reflection* pReflection);
		Matrix<float>& unitCellTensor();
		Matrix<short>& transformation();
};

static const float kMoWL = 1.5418f; //Angstroms
static const float kCuWL = 1.5418f; //Angstroms

float resipSphVol(float pAngRad, float pWaveLength);
#endif
