/*
 *  CystSymmetry.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Mon May 17 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "CrystSymmetry.h"
#include "Exceptions.h"
#include <string>
#include <regex.h>
#include <stdlib.h>

CrystSymmetry::CrystSymmetry():string()
{
}


CrystSymmetry::CrystSymmetry(string& pSymmetryDescription, size_t pIndex):string(pSymmetryDescription, pIndex), iMatrices(vector<Matrix<short> >())
{
	runCheck();
}

CrystSymmetry::CrystSymmetry(const string& pSymmetryDescription):string(pSymmetryDescription), iMatrices(vector<Matrix<short> >())
{
	runCheck();
}

void CrystSymmetry::runCheck()
{
	string Rot = "(-?(1|(2(_1)?)|(3(_[12])?)|(4(_[123])?)|(6(_[12345])?)))";
	string Glides = "(a|c|b|n|m)";
	string ARot = "(" + Rot + "(/" + Glides + ")?)";
	string SymOp = "(" + ARot + "|" + Glides + "|[d])";
	string sym = "^(" + SymOp + SymOp + "?" + SymOp + "?)([[:space:]]rhom)?$"; //Rhom is a special case. I don't like doing this but I cannot be bothered doing properly
	
	regex_t symFSO;
	
	regcomp(&symFSO, sym.c_str(), REG_EXTENDED | REG_NOSUB | REG_ICASE);
	if (0 != regexec(&symFSO, this->c_str(), 0, NULL, 0))
	{
		throw MyException(0, "Symmetry was invalid");
	}
}

CrystSymmetry::CrystSymmetry(const CrystSymmetry& pCrystSymmetry):string(pCrystSymmetry), iMatrices(vector<Matrix<short> >(pCrystSymmetry.iMatrices))
{
}

CrystSymmetry::~CrystSymmetry()
{
}

Matrix<short>& CrystSymmetry::matrix(unsigned int pIndex)
{
	return *(new Matrix<short>());
}

unsigned int CrystSymmetry::matrixCount()
{
	return 0;
}

std::ostream& operator<<(std::ostream& pStream, CrystSymmetry& pSymmetry)
{
	pStream << (string)pSymmetry;
	return pStream;
}

std::ostream& operator<<(std::ostream& pStream, vector<CrystSymmetry>& pSymmetryVec)
{
	vector<CrystSymmetry>::iterator tIter;
	
	for (tIter = pSymmetryVec.begin(); tIter != pSymmetryVec.end(); tIter++)
	{
		pStream << (*tIter);
		if (tIter != pSymmetryVec.end())
		{
			pStream << ", ";
		}
	}
	return pStream;
}