/*
 *  StringClasses.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Jan 28 2003.
 *  Copyright (c) 2003 . All rights reserved.
 *
 */
#include "StringClasses.h"
#if defined(_WIN32)
#include "PCPort.h"
#endif
#include <ctype.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

/**************************************************************************/
/***	Class String methods						***/
/**************************************************************************/
String::String()
{
    iString = new char[1];
    iString[0] = 0;
}

String::String(const char* pString)
{
    iString = new char[strlen(pString)+1];
    strcpy(iString, pString);
}

String::String(const String& pString)
{
    #ifdef __DEBUGING__
    std::cout << "String Copy " << pString.iString << "\n";
    #endif
    iString = new char[strlen(pString.iString)+1];
    strcpy(iString, pString.iString);
}

String::String(int pLength)
{
    iString = new char[pLength];
}

String::String(const char* pString, int pStartIndex, int pEndIndex)	//Create a string from a sub string of a char*
{
    iString = NULL;
    init(pString, pStartIndex, pEndIndex);
}

String::~String()
{
    delete[] iString;
    iString = NULL;
}

char * String::getCString()
{
    return iString;
}

bool String::operator<(String& pString)
{
    return strcmp(iString, pString.iString) < 0;
}

bool String::operator>(String& pString)
{
    return strcmp(iString, pString.iString) > 0;
}

bool String::operator==(String& pString)
{
    return strcmp(iString, pString.iString) == 0;
}

String& String::operator=(String& pStringToCopy)
{
    if (iString != NULL)
    {
        delete[] iString;
    }
    iString = new char[strlen(pStringToCopy.iString)+1];
    strcpy(iString, pStringToCopy.iString);
    return *this;
}

String& String::operator=(const char* pStringToCopy)
{
    if (iString != NULL)
    {
        delete[] iString;
    }
    iString = new char[strlen(pStringToCopy)+1];
    strcpy(iString, pStringToCopy);
    return *this;
}

void String::toString(char* pChars, long pSize)
{
#if !defined(_WIN32)
    snprintf(pChars, pSize, "StringClass ID = %s", iString);
#else
    sprintf(pChars, "StringClass ID = %s", iString);
#endif
}

int String::toInteger()
{
    return atoi(iString);
}	

double String::toDouble()
{
    return atof(iString);
}

float String::toFloat()
{
    return (float)atof(iString);
}

long String::toIntegerFromHex()
{
    return hex2l(iString);
}

int String::length()
{
    return (int)strlen(iString);
}

void String::upcase()
{
    String::upcase(iString);
}

void String::init(const char* pString)
{
    if (iString)
    {
        delete iString;
    }
    register int tLength = (int)strlen(pString)+1;
    iString = new char[tLength];
    memcpy(iString, pString, tLength);
}


void String::init(const char* pString, int pStartIndex, int pEndIndex)	//Create a string from a sub string of a char*
{
    if (iString)
    {
        delete iString;
    }
    const int tLength = (pEndIndex-pStartIndex)+1;
    iString = new char[tLength];
    strncpy(iString, pString+pStartIndex, pEndIndex-pStartIndex);
    iString[tLength-1] = 0;
}

int String::cmp(const char* pString)
{
    return strcmp(iString, pString);
}

void String::copy(String& pStringToCpy)
{
    delete iString;
    iString = new char[strlen(pStringToCpy.iString)+1];
    strcpy(iString, pStringToCpy.iString);
}
    
long String::hex2l(char* pString)
{
    int tLength = (int)strlen(pString);
    long tCurrentValue = 0;
    for (int i = 0; i < tLength; i++)
    {
        char iCurrentChar =  toupper(pString[i]);
        
        tCurrentValue *= 16;
        if ((iCurrentChar < '0' || iCurrentChar > '9') &&
        iCurrentChar < 'A' || iCurrentChar > 'F')
        {
            tCurrentValue = 0;
        }
        else
        {	
            if (iCurrentChar <= '9')
            {
                tCurrentValue += iCurrentChar - '0';
            }
            else
            {
                tCurrentValue += (iCurrentChar - 'A') + 10;
            }
        }
        
    }
    return tCurrentValue;
}

void String::trimNumber(char* pString)
{
    char* tStartPos = 0;
    char* tEndPos = 0;
    
    //Get Start position
    tStartPos = strpbrk(pString, "0123456789.");
    if (tStartPos)
    {
        //Get end position
        for (tEndPos = tStartPos; index("0123456789.", *tEndPos); tEndPos++);
        char* tCurrentPosition;
        for (tCurrentPosition=pString; tStartPos <  tEndPos; tCurrentPosition++, tStartPos++)
        {
            *tCurrentPosition = *tStartPos;
        }
        *tCurrentPosition = '\0';
    }
    else
    {
        //Whole string remove
        pString[0] = '\0';
    }
}

void String::upcase(char* pString)
{
    int tCount = (int)strlen(pString);
    int tInt;
    for (int i = 0; i < tCount; i++)
    {
        tInt = toupper(pString[i]);
        pString[i] = (char)tInt; 
    }
}

void String::trim(void)
{
    trim(iString);
}

void String::trim(char* pString)
{
    char* pStart = pString;
    int pEnd;

    while (index(" \t\n\r", (int)pStart[0]) != NULL && pStart[0] != '\0')
    {
        pStart++;
    }
    pEnd = (int)strlen(pStart);
    while (index(" \t\n\r", (int)pStart[pEnd]) != NULL && pEnd > 0)
    {
        pEnd--;
    }
    if (pEnd > 0 || index(" \t\n\r", (int)pStart[pEnd]) == NULL)
    {
        strncpy(pString, pStart, pEnd+1);
        pString[pEnd+1] = '\0';
    }
    else
        pString[0] = '\0';
}

int countChar(const char* pString, const char pChar) //Counts the number of times pChar is in pString
{
    int i;
    int tCount = 0;
    
    for (i = 0; pString[i]!='\0'; i++)
    {
        if (pString[i] == pChar)
        {
            tCount ++;
        }
    }
    return tCount;
}

int String::initFormated(char* pFmt, ...)
{
    va_list argp;
#if !defined(_WIN32)
	char tTempString;
#else
    char tTempString[1000];
#endif
    
    va_start(argp, pFmt);
#if !defined(_WIN32)
    int tLength = vsnprintf(&tTempString, 1, pFmt, argp);
#else
	int tLength = vsprintf((char*)tTempString, pFmt, argp);
#endif
    va_end(argp);
    if (iString)
    {
        delete iString;
    }
    iString = new char[tLength+1];
    va_start(argp, pFmt);
#if !defined(_WIN32)
    tLength = vsnprintf(iString, tLength+1, pFmt, argp);
#else
	tLength = vsprintf(iString, pFmt, argp);
#endif
	va_end(argp);
    return tLength;
}

std::istream& String::input(std::istream& pStream)
{
    char tChar[255];
    
    pStream.getline(tChar, 255, '\n');
    init(tChar);
    return pStream;
}

bool String::empty()
{
    return iString[0] == 0;
}

void String::replace(String& pSubString, String& pReplace)
{
    char* tFound = iString;
    if (pSubString.length() > 0)
    {
        while ((tFound = strstr(tFound, pSubString.getCString()))!= NULL)
        {
            strncpy(tFound, pReplace.getCString(), pSubString.length());
        }
    }
}

bool String::containsOnly(String& pChars)
{
    return containsOnly(iString, pChars.getCString());
}

bool String::containsOnly(char* pChars)
{
    return containsOnly(iString, pChars);
}

bool String::containsOnly(char* pString, char* pChars)
{
    int tStringLength = (int)strlen(pString);
    bool tValid = true;
    for (int i = 0; i < tStringLength && tValid; i++)
    {
        tValid = strchr(pChars, pString[i]) != NULL;
    }
    return tValid;
}

bool String::contains(String& pChars)
{
    return contains(pChars.iString);
}

bool String::contains(char* pChars)
{
    if (strlen(iString))
    {
        char* tResult = strstr(iString, pChars);
        return  tResult != iString && tResult != NULL;
    }
    return false;
}

std::ostream& operator<<(std::ostream & pStream, String& pString)
{
    return pStream << pString.getCString();
}

Path::Path()
{
}

Path::Path(char* pPath):String(pPath)
{
}

Path::Path(Path& pPath):String((String&)pPath)
{
}

void Path::removeOutterQuotes(char* tPath)
{
	if (tPath[0] != 0)
	{
		if (tPath[0] == '\"')
		{
			strcpy(tPath, tPath+1);
		}
		if (tPath[strlen(tPath)-1] == '\"')
		{
			tPath[strlen(tPath)-1] = '\0';
		}
	}
}

void Path::removeOutterQuotes()
{
    removeOutterQuotes(iString);
}

std::istream& operator>>(std::istream& pStream, Path& pPath)
{
    return pPath.input(pStream);
}

std::istream& operator>>(std::istream& pStream, String& pString)
{
    return pString.input(pStream);
}

RegexException::RegexException(const int pError, const regex_t* pRegEx):iError(pError), iMessage(new char[100])
{
    regerror(iError, pRegEx, iMessage, 100);
}

RegexException::~RegexException() throw()
{
  delete iMessage;
}

const char* RegexException::what() const throw()
{
  return iMessage;
}

void Regex::initWith(string& pRegExp, int pFlags)
{
	int pError;
	
	if ((pError = regcomp(&iRegExFSO, pRegExp.c_str(), (REG_EXTENDED | pFlags))) != 0)
	{
		throw RegexException(pError, &iRegExFSO);
	}
}

Regex::Regex(const char * pRegExp, int pFlags):string(pRegExp)
{
	initWith(*this, pFlags);
}
		
Regex::Regex(string& pRegExp, int pFlags):string(pRegExp)
{
	initWith(*this, pFlags);
}

void Regex::exec(string& pString, size_t pNumMatches, regmatch_t tMatch[], int pFlags)
{
	int pError;
	const char * tSearchString = pString.c_str();

	#ifdef __NO_REG_STARTEND_SUPPORT__
	string tSubString;
	ptrdiff_t tOffset = 0; 
	if ((pFlags & REG_STARTEND) == REG_STARTEND)
	{
	  tOffset = tMatch[0].rm_so;
	  tSubString = pString.substr(tMatch[0].rm_so, tMatch[0].rm_eo - tMatch[0].rm_so);
	  tSearchString = tSubString.c_str(); 
	}
	#endif
	if ((pError = regexec(&iRegExFSO, tSearchString, pNumMatches, tMatch, pFlags)) != 0)
	{
		throw RegexException(pError, &iRegExFSO);
	}
	#ifdef __NO_REG_STARTEND_SUPPORT__
	for (int i = 0; i< pNumMatches; i++)
	{
		if (tMatch[i].rm_so > -1)
		{
			tMatch[i].rm_so += tOffset;
			tMatch[i].rm_eo += tOffset;
		}
	}
	#endif
}	
