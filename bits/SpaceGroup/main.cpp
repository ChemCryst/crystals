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
 
#include <iostream.h>
#include <stdio.h>
#include <string.h>
#include "Collections.h"
#include "HKLData.h"
#include "Exceptions.h"
#include "Matrices.h"
#include <sys/time.h>
#include "CrystalSystem.h"
#include "regex.h"



int main (int argc, const char * argv[]) 
{
    char tPath[] = "/Users/stefan/Desktop/fg13.hkl";
    FILE* tFile = NULL;
    char tHeaderLine[] = "ID	Name	Vector	Multiplier\n";
    char tHeaderLine2[] = "ID	Name	Matrix\n";
    char tLines[] = "ID	Name	Matrix
0	hkl	[1 0 0; 0 1 0; 0 0 1]	
1	0kl	[0 0 0; 0 1 0; 0 0 1]	
2	h0l	[1 0 0; 0 0 0; 0 0 1]	
3	hk0	[1 0 0; 0 1 0; 0 0 0]	
4	h00	[1 0 0; 0 0 0; 0 0 0]	
5	0k0	[0 0 0; 0 1 0; 0 0 0]	
6	00l	[0 0 0; 0 0 0; 0 0 1]	
7	hhl	[1 0 0; 1 0 0; 0 0 0]	
8	hh-0	[1 0 0; -1 0 0; 0 0 0]

ID	Name	Vector	Multiplier
0	h = 2n	[1 0 0]	2
1	k = 2n	[0 1 0]	2
2	l = 2n	[0 0 1]	2
3	h+k = 2n	[1 1 0]	2
4	k+l = 2n	[0 1 1]	2
5	h+l = 2n	[1 0 1]	2
6	h+k+l = 2n	[1 1 1]	2		
7	2h+l = 4n	[2 0 1]	4
";
      
    try
    {
        char* tNextLine;
        char* tPrevLine;
        tPrevLine = strstr(tLines, tHeaderLine2) +strlen(tHeaderLine2);

        Headings tHeadings;
        while (tNextLine = tHeadings.addHeading(tPrevLine))
        {
            tPrevLine = tNextLine;
        }
        Conditions tConditions;
        tPrevLine = strstr(tLines, tHeaderLine)+strlen(tHeaderLine);
        while (tNextLine = tConditions.addCondition(tPrevLine))
        {
            tPrevLine = tNextLine;
        }
        
        Table* tTable = new Table("Monoclinic", &tHeadings, &tConditions, 3, 3);
        tTable->readColumnHeadings("0, 1, 3\t2, 4, 6\t5	2\tm\t2/m");
        tTable->addLine("-\t-\t-\tP121\tP1m1\tP12/m1");
        tTable->addLine("-\t-\t-\tP121\tP1m1\tP12/m1");
        cout << *tTable << "\n";
        delete tTable;
        
        cout << tHeadings << "\n";
        cout << tConditions << "\n";
    }
    catch (MyException& e)
    {
        cout << e.what() << "\n";
    }
    return 0;
}
