/*
 *  main.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Oct 29 2002.
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
 
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <regex.h>
#include "Collections.h"
#include "HKLData.h"
#include "Exceptions.h"
#include "Matrices.h"
#include "CrystalSystem.h"
#include <fstream>
using namespace std;



void readInTable(filebuf& pFile, Table* pTable);

int main (int argc, const char * argv[]) 
{  
    try
    {
        char* tNextLine;
        char* tPrevLine;

        Headings tHeadings;
        Conditions tConditions;
        
            filebuf tFile;
            tFile.open("/Users/stefan/Desktop/Tables.txt", ios::in);
            
            tHeadings.readFrom(tFile);
            tConditions.readFrom(tFile);
        
            Tables tTables(&tHeadings, &tConditions);
            tTables.readFrom(tFile);
            
          /*  Table* tTable = new Table("Monoclinic", &tHeadings, &tConditions, 3, 3);
            tTable->readColumnHeadings("0, 1, 3\t2, 4, 6\t5	2\tm\t2/m");

            tTable->readFrom(tFile);*/
            tFile.close();
        
        cout << tHeadings << "\n";
        cout << tConditions << "\n";
        cout << tTables << "\n";
    }
    catch (MyException& e)
    {
        cout << e.what() << "\n";
    }
    return 0;
}


