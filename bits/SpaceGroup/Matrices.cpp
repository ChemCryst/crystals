/*
 *  Matrices.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Nov 05 2002.
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
//#include "stdafx.h"
#include "Matrices.h"
#include "MathFunctions.h"
#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif

MatrixException::MatrixException(int pErrNum, char* pErrType):MyException(pErrNum, pErrType)
{
}

/*
 * The format for the matrix should be the same as the format used in MatLab.
 * Matrix can be matched using this regular expression ^\\[(<float>(;|[[:space:]])[[:space:]]*)*<float>\\]$
 * where <float> := -?[[:digit:]]+(\\.[[:digit:]]+)?
 */ 
MatrixReader::MatrixReader(char *pLine)
{
    char tRegExp[] = "^\\[((-?[[:digit:]]+(\\.[[:digit:]]+)?(;|[[:space:]])[[:space:]]*)*-?[[:digit:]]+(\\.[[:digit:]]+)?\\])$";	//Regular expression which checks to see if the matrix had the correct format.

    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 6;
    regmatch_t tMatch[6];
    bzero(tMatch, sizeof(regmatch_t)*6);
    if (regexec(&tRegEx, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Matrix had an invalid format!");
    }
    char* tString = pLine+tMatch[1].rm_so;
    //Workout the size of the matrix
    int tX = countMaxNumberOfColumns(tString);
    int tY = countNumberOfRows(tString);
    //Resize this matrix
    resize(tX, tY);
    fill(0);
    //Fill the matrix with the correct values
    fillMatrix(pLine);
}

int MatrixReader::countNumberOfRows(char* pString)
{
    char tRegExp[] = "^[[:space:]]*(-?[[:digit:]]+(\\.[[:digit:]]+)?[[:space:]]*)+;|\\]";	//Regular expression which checks to see if the matrix had the correct format.
    
    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 2;
    regmatch_t tMatch[2];
    bzero(tMatch, sizeof(regmatch_t)*2);
    if (regexec(&tRegEx, pString, tMatches, tMatch, 0))
    {
        return 0;
    }
    return countNumberOfRows(pString+(int)tMatch[0].rm_eo) +1;
}

int MatrixReader::countNumberOfColumns(char** pString)	//Returns the place where it reached the end of the row
{
    char tRegExp[] = "^\\[?[[:space:]]*-?[[:digit:]]+(\\.[[:digit:]]+)?[[:space:]]*\\]?";	//Regular expression which checks to see if the matrix had the correct format.
    
    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 2;
    regmatch_t tMatch[2];
    bzero(tMatch, sizeof(regmatch_t)*2);
    if (regexec(&tRegEx, *pString, tMatches, tMatch, 0))
    {
        return 0;
    }
    *pString+=(int)tMatch[0].rm_eo;
    return countNumberOfColumns(pString) +1;
}

int MatrixReader::countMaxNumberOfColumns(char* pString)
{
    char* tString = pString;
    
    if (pString[0] == 0)
    {
        return 0;
    }
    else
    {
        if (tString[0] == ';')
        {
            tString++;
        }
        int tValue = countNumberOfColumns(&tString);
        int tValue2 = countMaxNumberOfColumns(tString);
        return max(tValue, tValue2);
    }
}

void MatrixReader::fillMatrix(char* pLine, int pX, int pY)
{
    char tRegExp[] = "[[:space:]]*(-?[[:digit:]]+(\\.[[:digit:]]+)?)([[:space:]]*)(;)?";	//Regular expression which checks to see if the matrix had the correct format.
    
    regex_t tRegEx;
    regcomp(&tRegEx, tRegExp, REG_EXTENDED);
    
    size_t tMatches = 6;
    regmatch_t tMatch[6];
    bzero(tMatch, sizeof(regmatch_t)*6);
    if (regexec(&tRegEx, pLine, tMatches, tMatch, 0))
    {
        return;
    }
    setValue((float)strtod(pLine+tMatch[1].rm_so, NULL), pX, pY);
    if (tMatch[4].rm_so != -1)
    {
        fillMatrix(pLine+(int)tMatch[1].rm_eo, 0, pY+1);
    }
    else
    {
        fillMatrix(pLine+(int)tMatch[1].rm_eo, pX+1, pY);
    }
}

void MatrixReader::fillMatrix(char* pLine)
{
    fillMatrix(pLine, 0, 0);
}