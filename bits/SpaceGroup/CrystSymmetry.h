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

/*!
 * @class CrystSymmetry 
 * @description Not yet documented.
 * @abstract
*/
class CrystSymmetry:public string
{
	public:
		CrystSymmetry();
		CrystSymmetry(string& pSymmetryDescription, size_t pIndex);
		CrystSymmetry(const string& pSymmetryDescription);
		CrystSymmetry(const CrystSymmetry& pCrystSymmetry);
		virtual ~CrystSymmetry();

		/*!
		 * @function runCheck 
		 * @description Not yet documented.
		 * @abstract
		 */
		void runCheck();
		
		/*!
		 * @function matrix 
		 * @description Returns a metrix associated with the symmetry.
		 * @abstract Returns a matrix representing part of the symmetry
		 * in reciprical space. This is a virtual method which should be
		 * overloaded to return the appropriate matrix
		 */
		virtual Matrix<short>& matrix(const size_t pIndex) const;
		
		/*!
		 * @function matrixCount 
		 * @description Returns the number of matrix the symmetry has associated with it.
		 * @abstract This is a virtual method which is intended to be replaces.
		 */
		virtual size_t matrixCount() const;
};

extern std::ostream& operator<<(std::ostream& pStream, CrystSymmetry& pSymmetry);
extern std::ostream& operator<<(std::ostream& pStream, vector<CrystSymmetry>& pSymmetryVec);
#endif