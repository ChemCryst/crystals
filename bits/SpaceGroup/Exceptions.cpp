/*
 *  Exceptions.cpp
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
#include "Exceptions.h"
#include <String>
#include <errno.h>

MyException::MyException(int pErrNum, char* pErrStr)
{
    iErrStr = NULL;	//Make sure that it's null. Not needed but makes me feel better doing this.
    iErrStr = new char[strlen(pErrStr)+1];	//Allocate the memory for the  string.
    iErrNum = pErrNum;	//Set the error number which was passed to the exception.
    strcpy(iErrStr, pErrStr);	//Copy the error sting into the objects memory.
}

MyException::MyException(const MyException& pException)
{
    iErrStr = new char[strlen(pException.iErrStr)+1];
    strcpy(iErrStr, pException.iErrStr);
    iErrNum = pException.iErrNum;
}

MyException::~MyException() throw()
{
    delete[] iErrStr;
}

void MyException::addError(char* pErrMsg)
{
    int tLen = strlen(iErrStr)+strlen(pErrMsg)+2;
    char* tNewStr = new char[tLen];
    sprintf(tNewStr, "%s\n%s", pErrMsg, iErrStr);
    delete iErrStr;
    iErrStr = tNewStr;
}

char* MyException::what()
{
    return iErrStr;
}

int MyException::number()
{
    return iErrNum;
}

void MyException::setString(const char* pString)
{
    if (iErrStr != NULL)	//Make sure that there hasn't been some memory allocated for the string.
    {
        delete[] iErrStr;	//If there was some memory allocated then free it.
    }
    iErrStr = new char[strlen(pString)+1]; //Allocate enought space for the new string.
    strcpy(iErrStr, pString);	//Copy the new string in to the object.
}

MyException& MyException::operator=(const MyException& pException)
{
    if (iErrStr)
    {
        delete[] iErrStr;
    }
    iErrStr = new char[strlen(pException.iErrStr)+1];
    strcpy(iErrStr, pException.iErrStr);
    iErrNum = pException.iErrNum;
    return *this;
}

FileException::FileException(int pFileError):MyException(kFileException, "")
{
    switch (pFileError)
    {
        case ENOTDIR: setString("A component of the path prefix is not a directory.");
             break;
        case ENAMETOOLONG: setString("A component of a pathname exceeded {NAME_MAX} characters, or an entire path name exceeded {PATH_MAX} characters.");
             break;
        case ENOENT: setString("A component of the path name that must exist does not exist.");
            break;
        case EACCES: setString("The required permissions (for reading and/or writing) are denied for the given flags.");
             break;
#if !defined(_WIN32)
        case ELOOP: setString("Too many symbolic links were encountered in translating the pathname.");
             break;
#endif
        case EISDIR: setString("The named file is a directory, and the arguments specify it is to be opened for writing.");
            break;
        case EROFS: setString("The named file resides on a read-only file system, and the file is to be modified.");
             break;
        case EMFILE: setString("The process has already reached its limit for open file descriptors.");
             break;
        case ENXIO: setString("The named file is a character special or block special file, and the device associated with this special file does not exist.");
             break;
        case EINTR: setString("The open() operation was interrupted by a signal.");
            break;
#if !defined(_WIN32)
		case ENOSPC: setString("O_CREAT is specified, the file does not exist, and the directory in which the entry for the new file is being placed cannot be extended because there is no space left on the file system containing the directory.");
             break; 
        case EDQUOT: setString("O_CREAT is specified, the file does not exist, and the directory in which the entry for the new file is being placed cannot be extended because the user's quota of disk blocks on the file system containing the directory has been exhausted.");
             break;
#endif
        case EIO: setString("An I/O error occurred while making the directory entry or allocating the inode for O_CREAT.");
             break;
#if !defined(_WIN32)
        case ETXTBSY: setString("The file is a pure procedure (shared text) file that is being executed and the open() call requests write access.");
             break;
        case EFAULT: setString("Path points outside the process's allocated address space.");
             break;
#endif
        case EEXIST: setString("O_CREAT and O_EXCL were specified and the file exists.");
             break;
#if !defined(_WIN32)
        case EOPNOTSUPP: setString("An attempt was made to open a socket (not currently implemented).");
        break;
#endif
        default:	//If the error number isn't known then do this.
            char tString[255];
            
            sprintf(tString, "Unknown error: %d.", pFileError);
            setString(tString);
    }
}

std::ostream& operator<<(std::ostream& pStream, MyException& pExc)
{
	return pStream << "Here ";
}