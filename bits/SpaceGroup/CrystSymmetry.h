/*
 *  CrystSymmetry.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Mon May 17 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __CRYST_SYSTEM_H__
#define __CRYST_SYSTEM_H__
#include "Matrices.h"
#include <vector>

class CrystSymmetry:public string
{
	protected:
		vector<Matrix<short> > iMatrices;
	public:
		CrystSymmetry();
		CrystSymmetry(string& pSymmetryDescription, size_t pIndex);
		CrystSymmetry(const string& pSymmetryDescription);
		CrystSymmetry(const CrystSymmetry& pCrystSymmetry);
		virtual ~CrystSymmetry();
		void runCheck();
		virtual Matrix<short>& matrix(unsigned int pIndex);
		virtual unsigned int matrixCount();
};

extern std::ostream& operator<<(std::ostream& pStream, CrystSymmetry& pSymmetry);
extern std::ostream& operator<<(std::ostream& pStream, vector<CrystSymmetry>& pSymmetryVec);
#endif