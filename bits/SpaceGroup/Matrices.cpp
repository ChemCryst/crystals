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
#include <stdlib.h>
#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif
#include "PCPort.h"

static regex_t* iFirstLineRE = NULL;
static regex_t* iMatFormRE = NULL;
static regex_t* iFirstNumRE = NULL;
static regex_t* iFirstNum2RE = NULL;

void initRegEx()	//This function constructs the finite state automata which are used in the matrix reader. This must be called before any of the global reg exp are used.
{
    if (iFirstLineRE == NULL)
    {
        char tFirstLineRE[] = "^\\[?[[:space:]]*(-?[[:digit:]]+(\\.[[:digit:]]+)?[[:space:]]*)+;|\\]";	
            //Returns the first line of a matrix in $1.
            //It matchs from the start of the string to the first occurence of ; or ]
            //It could be assumed that the matrix is in the correct format
        char tMatFormRE[] = "^\\[((-?[[:digit:]]+(\\.[[:digit:]]+)?(;|[[:space:]])[[:space:]]*)*-?[[:digit:]]+(\\.[[:digit:]]+)?\\])$";			//Regular expression which checks to see if the matrix had the correct format.
        char tFirstNumRE[] = "^\\[?[[:space:]]*-?[[:digit:]]+(\\.[[:digit:]]+)?[[:space:]]*\\]?";
            //Matchs the first float in a string.
        char tFirstNum2RE[] = "[[:space:]]*(-?[[:digit:]]+(\\.[[:digit:]]+)?)([[:space:]]*)(;)?";
            //Takes the first number in the string and puts it in $1. If the number is post seeded by a ; then $4 should point to a valid point
        iFirstLineRE = new regex_t;
        iMatFormRE = new regex_t;
        iFirstNumRE = new regex_t;
        iFirstNum2RE = new regex_t;
        regcomp(iFirstLineRE, tFirstLineRE, REG_EXTENDED);
        regcomp(iMatFormRE, tMatFormRE, REG_EXTENDED);
        regcomp(iFirstNumRE, tFirstNumRE, REG_EXTENDED);
        regcomp(iFirstNum2RE, tFirstNum2RE, REG_EXTENDED);
    }
}

void deinitRegEx()
{
    if (iFirstLineRE != NULL)
    {
        delete iFirstLineRE;
        delete iMatFormRE;
        delete iFirstNumRE;
        delete iFirstNum2RE;
        iFirstLineRE= NULL;
        iMatFormRE= NULL;
        iFirstNumRE= NULL;
        iFirstNum2RE= NULL;
    }
}

MatrixException::MatrixException(int pErrNum, char* pErrType):MyException(pErrNum, pErrType)
{
}

MatrixReader::MatrixReader(char *pLine)
{
    initRegEx();	//Init the regular expression before using them later in the class.
    
    size_t tMatches = 6;
    regmatch_t tMatch[6];
    bzero(tMatch, sizeof(regmatch_t)*6);
    if (regexec(iMatFormRE, pLine, tMatches, tMatch, 0))
    {
        throw MyException(kUnknownException, "Matrix had an invalid format.");
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

MatrixReader::~MatrixReader()
{
    deinitRegEx();
}

int MatrixReader::countNumberOfRows(char* pString)
{
    const size_t tMatches = 3;
    regmatch_t tMatch[tMatches];
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iFirstLineRE, pString, tMatches, tMatch, 0))
    {
        return 0;
    }
    return countNumberOfRows(pString+(int)tMatch[0].rm_eo) +1;
}

int MatrixReader::countNumberOfColumns(char** pString)	//Returns the place where it reached the end of the row
{
    const size_t tMatches = 5;
    regmatch_t tMatch[tMatches];
    bzero(tMatch, sizeof(regmatch_t)*tMatches);
    if (regexec(iFirstNumRE, *pString, tMatches, tMatch, 0))
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
    const size_t tMatches = 6;
    regmatch_t tMatch[6];
    bzero(tMatch, sizeof(regmatch_t)*6);
    if (regexec(iFirstNum2RE, pLine, tMatches, tMatch, 0))
    {
        return;
    }
    setValue((short)strtod(pLine+tMatch[1].rm_so, NULL), pX, pY);
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
