/*
 *  StringClasses.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Jan 28 2003.
 *  Copyright (c) 2003 . All rights reserved.
 *
 */
#ifndef __STRING_CLASSES_H__
#define __STRING_CLASSES_H__ 
#include "ComClasses.h"
#include <iostream>
#include <stdio.h>
#include <string>
#include <regex.h>

using namespace std;
 
#ifndef REG_STARTEND
#define __NO_REG_STARTEND_SUPPORT__
#define REG_STARTEND 100000 /*This is to support a feature which is available on Darwin but not on other platforms.*/ 
#endif

class String:public MyObject
{
protected:
    char* iString;
public:
    String();
    String(const char* pString);
    String(const String& pString);
    String(int pLength);    //Create a string of length pLength
    String(const char* pString, int pStartIndex, int pEndIndex);	//Create a string from a sub string of a char*
    ~String();    
    void init(const char* pString);
    void init(const char* pString, int pStartIndex, int pEndIndex);	//Create a string from a sub string of a char*
    char * getCString();    
    bool operator<(String& pString);    
    bool operator>(String& pString);    
    bool operator==(String& pString);    
    String& operator=(String& pStringToCopy);  
    String& operator=(const char* pStringToCopy);    
    void toString(char* pChars, long pSize);
    int toInteger();
    double toDouble();
    float toFloat();
    long toIntegerFromHex();
    int length();
    int cmp(const char* pString);
    void token(char* pString, const char* pDelimeter, char* pToken, int pMaxTokenLength, int pTokenIndex);
    void upcase();
    void trim(void);
    void copy(String& pStringToCpy);
    int initFormated(char* pFmt, ...);
    std::istream& input(std::istream& pStream);
    bool empty();
    bool containsOnly(String& pChars);
    bool containsOnly(char* pChars);
    bool contains(String& pChars);
    bool contains(char* pChars);
    static bool containsOnly(char* pString, char* pChars);
    static void upcase(char* pString);
    static void trim(char* pString);
    static long hex2l(char* pString);
    static void trimNumber(char* pString); 
    void replace(String& pSubString, String& pReplace);   
};

class Path:public String
{
    public:
        Path();
        Path(char* pString);
        Path(Path& pPath);
        static void removeOutterQuotes(char* tPath);
        void removeOutterQuotes();
};

template <class ForwardIterator>
void do_tolower(ForwardIterator first, ForwardIterator last)
{
	ForwardIterator tIter;
	
	for (tIter = first; tIter!=last; tIter++)
	{
		(*tIter) = tolower((*tIter));
	}
}

class RegexException:public exception
{
	protected:
		int iError;
		char* iMessage;
	public:
		RegexException(int pError, const regex_t* pRegEx);
		~RegexException() throw();
		char* what() const throw();
};

class Regex:public string
{
	private:
		void initWith(string& pRegExp, int pFlags);
	protected:
		regex_t iRegExFSO;
	public:
		Regex(const char *, int pFlags = 0);
		Regex(string& pRegExp, int pFlags = 0);
		void exec(string& pString, size_t pNumMatches, regmatch_t tMatch[], int pFlags=0);
};

extern std::ostream& operator<<(std::ostream & pStream, String& pString);
extern std::istream& operator>>(std::istream& pStream, Path& pPath);
extern std::istream& operator>>(std::istream& pStream, String& pString);
#endif
