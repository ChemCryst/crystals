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
#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif
#include <stdlib.h>

CrystSymmetry::CrystSymmetry():string()
{
}

CrystSymmetry::CrystSymmetry(string& pSymmetryDescription, size_t pIndex):string(pSymmetryDescription, pIndex)
{
	runCheck();
}

CrystSymmetry::CrystSymmetry(const string& pSymmetryDescription):string(pSymmetryDescription)
{
	runCheck();
}

static regex_t *gSymFSO = NULL; //The compiled regualar expression. Using it this way because boost is really slow.

void CrystSymmetry::runCheck()
{
	int tError;
	string Rot = "(-?(1|(2(_1)?)|(3(_[12])?)|(4(_[123])?)|(6(_[12345])?)))";
	string Glides = "(a|c|b|n|m)";
	string ARot = "(" + Rot + "(/" + Glides + ")?)";
	string SymOp = "(" + ARot + "|" + Glides + "|d)";
	string sym = "^(" + SymOp + SymOp + "?" + SymOp + "?)([[:space:]]rhom)?$"; //Rhom is a special case. I don't like doing this but I cannot be bothered doing properly
	
	
	if (gSymFSO == NULL)
	{
		gSymFSO = new regex_t;
		regcomp(gSymFSO, sym.c_str(), REG_EXTENDED | REG_NOSUB | REG_ICASE);
	}
	if (0 != (tError = regexec(gSymFSO, string::c_str(), 0, NULL, 0)))
	{
		char tString[255];
		regerror(tError, gSymFSO, tString, 255);
		cerr << "\n" << tString << "\n";
		cerr << (*this) << "\n";
		throw MyException(0, "Symmetry was invalid");
	}
}

CrystSymmetry::CrystSymmetry(const CrystSymmetry& pCrystSymmetry):string(pCrystSymmetry)
{
}

CrystSymmetry::~CrystSymmetry()
{
	if (gSymFSO)
	{
		regfree(gSymFSO);
		delete gSymFSO;
		gSymFSO = NULL;
	}
}

Matrix<short>& CrystSymmetry::matrix(const size_t pIndex)const
{
	return *(new Matrix<short>());
}

size_t CrystSymmetry::matrixCount() const
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
