/*
 *  RunParameters.cpp
 *  Space Groups
 *
 *  Created by Stefan on Tue Jun 10 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
//#include "stdafx.h"
#include <iostream>
#include <fstream>
#include "RunParameters.h"
#include "UnitCell.h"
#if defined(__APPLE__)
#include <vecLib/vDSP.h>
#endif
#include "Exceptions.h"
#if defined(_WIN32)
#include <Boost/regex.h>
#include <direct.h>
#else
#include <regex.h>
#endif



RunParameters::RunParameters()
{
#if defined(_WIN32)
	char * tWorkingPath = (char*)malloc(PATH_MAX);
	_getcwd(tWorkingPath, PATH_MAX);
#else
	char * tWorkingPath = NULL;
	tWorkingPath = getcwd(NULL, PATH_MAX);
#endif
    iTablesFile.initFormated("%s%s", tWorkingPath, kDefaultTables);
    free(tWorkingPath);
    iRequestChirality = true;
    iChiral = false;
    iVerbose = false;
    iInteractiveMode = false;
}

bool RunParameters::handleArg(int *pPos, int pMax, _TCHAR * argv[])
{
    if (strcmp(argv[(*pPos)], "-c") == 0)
    {
        iChiral = true;
        iRequestChirality = false;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[(*pPos)], "-nc") == 0)
    {
        iChiral = false;
        iRequestChirality = false;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[*pPos], "-v")==0)
    {
        iVerbose = true;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[*pPos], "-i")==0)
    {
        iInteractiveMode = true;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[*pPos], "-f")==0)
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iFileName.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-o")==0)	//Output to file.
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iOutputFile.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-t")==0)
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iTablesFile.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-b")==0)
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iParamFile.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-s")==0)
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            char* tEnd;
            int tValue = strtol(argv[*pPos], &tEnd, 10);
            char* pSystem = crystalSystemConst(tValue);
            if (tEnd != argv[*pPos]+strlen(argv[*pPos]) || pSystem == NULL)
            {
                return false;
            }
            iCrystalSys.init(pSystem);
            (*pPos)++;
            return true;
        }
    }
    return false;
}

void RunParameters::handleArgs(int pArgc, _TCHAR* argv[])
{
    int tCount = 1;
    while (tCount < pArgc)
    {
        if (!handleArg(&tCount, pArgc, argv))
        {
            std::cout << "Usage: " << argv[0] << "[-f hklfile] [-t tablefile] [-e extradatafile] [-c|-nc] [-s system]\n";
            std::cout << "-f hklfile: The path of the hkl file to read in.\n";
            std::cout << "-t tablefile: The path of the table file.\n";
            std::cout << "-o outputfile: The path to a file to output the stats table and the raking table.\n";
            std::cout << "[-c| -nc]: -c The structure is chiral. -nc The crystal isn't necessarily chiral.\n";
            std::cout << "-v: verbose output\n";
            std::cout << "-i: Interactive mode. This allows the user to veiw the stats table.\n";
            std::cout << "-s system#: The crystal system table to use.\n";
            std::cout << "-b batchfile: This supplies a file with all the parameters needed to run the program. The parameters in the file override any other parameters set on the command line.";
            std::cout << "Valid values for system are:\n" <<
            "\t0: Triclinic\n" <<
            "\t1: MonoclinicA\n" <<
            "\t2: MonoclinicB\n" <<
            "\t3: MonoclinicC\n" <<
            "\t4: Orthorhombic\n" <<
            "\t5: Tetragonal\n" <<
            "\t6: Trigonal\n" <<
            "\t7: Trigonal(rhom)\n" <<
            "\t8: Hexagonal\n" <<
            "\t9: Cubic\n";
            throw exception();
        }
    }
    readParamFile();
}

void RunParameters::getParamsFromUser()
{
    if (iFileName.empty())
    {
        char tString[255];
        std::cout << "Enter hkl file path: ";
        std::cin >> tString;
        
        iFileName.init(tString);
        iFileName.removeOutterQuotes();
    }
    char tReply[10];
    while (iRequestChirality)
    {
        std::cout << "Is the crystal chiral? [y/n]";
        std::cin >> tReply;
        
        String::upcase(tReply);
        
        if (strcmp(tReply, "NO")  == 0 || strcmp(tReply, "N") == 0 || 0 == tReply[0])
        {
            iChiral = false;
            iRequestChirality = false;
        }
        else if (strcmp(tReply, "YES") == 0 || strcmp(tReply, "Y") == 0)
        {
            iChiral = true;
            iRequestChirality = false;
        }
    }
    if (iCrystalSys.empty())
    {
        iCrystalSys.init(getCrystalSystem());
    }
}

void RunParameters::readParamFile()
{
    if (!iParamFile.empty())
    {
        try
        {
            char tClassRE[] = "CLASS[[:space:]]+([[:alpha:]]+)";
            char tUniqueRE[] = "UNIQUE[[:space:]]+(A|B|C|(NONE/UNKNOWN))";
            char tChiralRE[] = "CHIRAL[[:space:]]+((YES)|(UNKNOWN))";
            char tOutputRE[] = "OUTPUT[[:space:]]+\"([^\"]+)\"";
            char tHKLRE[] = "HKL[[:space:]]+\"([^\"]+)\"";
            char tCommentRE[] = "^#";
            filebuf tParamFile;
            if (tParamFile.open(iParamFile.getCString(), std::ios::in) == NULL)
            {
                throw FileException(errno);
            }
            std::istream tFileStream(&tParamFile);
            regex_t* tClassFSO = new regex_t;
            regex_t* tUniqueFSO = new regex_t;
            regex_t* tChiralFSO = new regex_t;
            regex_t* tOutputFSO = new regex_t;
            regex_t* tHKLFSO = new regex_t;
            regex_t* tCommentSO = new regex_t;
            regcomp(tClassFSO, tClassRE, REG_EXTENDED | REG_ICASE);
            regcomp(tUniqueFSO, tUniqueRE, REG_EXTENDED | REG_ICASE);
            regcomp(tChiralFSO, tChiralRE, REG_EXTENDED | REG_ICASE);
            regcomp(tOutputFSO, tOutputRE, REG_EXTENDED | REG_ICASE);
            regcomp(tHKLFSO, tHKLRE, REG_EXTENDED | REG_ICASE);
            regcomp(tCommentSO, tCommentRE, REG_EXTENDED | REG_ICASE);
            regmatch_t tMatchs[13];
            char tLine[255];
            int tLineNum = 0;
            String* tUniqueAxis = NULL;
            String* tClass = NULL;
            while (!tFileStream.eof())
            {
                tFileStream.getline(tLine, 255);
                String::trim(tLine);
                tLineNum ++;
                if (strlen(tLine) == 0)
                {}
                else if (regexec(tClassFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    tClass = new String(tLine, (int)tMatchs[1].rm_so, (int)tMatchs[1].rm_eo);
                    if (tUniqueAxis)
                    {
                        int tClassIndex = indexOfClass(*tClass, *tUniqueAxis);
                        if (tClassIndex < 0)
                        {
                            throw MyException(kUnknownException, "Unknown crystal class.");
                        }
                        iCrystalSys = crystalSystemConst(tClassIndex);
                    }
                }
                else if (regexec(tUniqueFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    tUniqueAxis = new String(tLine, (int)tMatchs[1].rm_so, (int)tMatchs[1].rm_eo);
                    if (tClass)
                    {
                        int tClassIndex = indexOfClass(*tClass, *tUniqueAxis);
                        if (tClassIndex < 0)
                        {
                            throw MyException(kUnknownException, "Unknown crystal class.");
                        }
                        iCrystalSys = crystalSystemConst(tClassIndex);
                    }
                }
                else if (regexec(tChiralFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    if (tMatchs[2].rm_so > 0)
                        iChiral = true;
                    else
                        iChiral = false;
                    iRequestChirality = false;
                }
                else if (regexec(tOutputFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    String tTemp(tLine, (int)tMatchs[1].rm_so, (int)tMatchs[1].rm_eo);
                    iOutputFile.copy(tTemp);
                }
                else if (regexec(tHKLFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    String tTemp(tLine, (int)tMatchs[1].rm_so, (int)tMatchs[1].rm_eo);
                    iFileName.copy(tTemp);
                }
                else if (iUnitCell.init(tLine))
                {
                    iUnitCell.guessCrystalSystem();
                }
                else if (regexec(tCommentSO, tLine, 13, tMatchs, 0) == 0)
                {
                }
                else
                {
                    tParamFile.close();
                    String tMyString;
                    tMyString.initFormated("Baddly formated param file at line %d", tLineNum);
                    throw MyException(kUnknownException, tMyString.getCString());
                }
            }
            if (tUniqueAxis)
            {
                delete tUniqueAxis;
            }
            if (tClass)
            {
                delete tClass;
            }
            tParamFile.close();
            delete tClassFSO;
            delete tUniqueFSO;
            delete tChiralFSO;
            delete tOutputFSO;
            delete tHKLFSO;
        }
        catch(MyException e)
        {
            e.addError("Error in reading the parameter file.");
            throw e;
        }
    }
}