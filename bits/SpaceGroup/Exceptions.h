/*
 *  Exceptions.h
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

#ifndef __EXCEPTIONS_H__
#define __EXCEPTIONS_H__
#include <Exception>

/******************************************/
/***	Error codes to identify what 	***/
/***	type of exception is it is. 	***/
/******************************************/
#define kFileException 0x01

class MyException : public std::exception
{
    public:
        char* iErrStr;
        int iErrNum;
        
        MyException(int pErrNum, char* iErrStr);
        MyException(const MyException& pException);
        virtual ~MyException() throw();
        virtual char* what();
        virtual int number();
        MyException& operator=(const MyException& pMatrix);
    protected:
        void setString(const char* pString);
};

class FileException: public MyException
{
    public:
        FileException(int pFileError);
};
#endif