/*
 *  InteractiveControl.cpp
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 04 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
//#include "stdafx.h"
#include "InteractiveControl.h"

static regex_t* gCommandRE =NULL;

Command::Command()
{
    char tCommandRE[] = "(\".+\")|([[:alnum:]]+))(.*)";
    if (gCommandRE ==NULL)
    {
         regcomp(gCommandRE, tCommandRE, REG_EXTENDED);
    }
}

Command::Command(char* pCommand):String(pCommand)
{
    char tCommandRE[] = "(\"[[:alnum:]]+\")|([[:alnum:]]+)(.*)";
    if (gCommandRE ==NULL)
    {
        gCommandRE = new regex_t;
        regcomp(gCommandRE, tCommandRE, REG_EXTENDED);
    }
}

Command::Command(Command& pCommand):String((String&)pCommand)
{
    
}

Command& Command::getCommand(int i)
{
    regmatch_t tMatch[4];
    
    bzero(tMatch, sizeof(regmatch_t)*4);
    for (int j; j < i; j++)
    {
        if (regexec(gCommandRE, iString, 4, tMatch, 0))
        {
            throw MyException(kUnknownException, "Command has bad format.");
        }
    }
    Command tCommand;
    return tCommand;
}

void InteractiveControl::printHelp()
{
    cout << "Available commands.\n";
    cout << "Q: To exit the interactive mode.\n";
}


bool InteractiveControl::handleCommand(Command& pCommand)	//Returns whether interactive mode should be exited.
{
    std::cout << "Commands: " << pCommand << "\n";
    try
    {
        pCommand.getCommand(3);
    }
    catch (MyException e)
    {
        cout << "Badly formated command.";
    }
    pCommand.upcase();
    if (pCommand.cmp("?") == 0)
    {
        printHelp();
    }
    else if (pCommand.cmp("QUIT") == 0)
    {
        return true;
    }
    else
    {
        cout << "Command not recognised.\n";
    }
    return false;
}

void InteractiveControl::goInteractive()
{
    Command tReply("");
    bool tExit=false;
    std::cout << "Interactive Mode. For help type (?)\n";
    while (!tExit)
    {
        std::cout << "-->";
        std::cin >> tReply;
        tExit = handleCommand(tReply);
    }
}

InteractiveControl::InteractiveControl(Stats* pStats, RankedSpaceGroups* pRankings, Table* pTable):iStats(pStats), iRanking(pRankings), iTable(pTable)
{
}