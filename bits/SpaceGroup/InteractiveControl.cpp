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
    char tCommandRE[] = "((\"[[:alnum:]]+\")|([[:alnum:]]+))(.*)";
    if (gCommandRE ==NULL)
    {
        gCommandRE = new regex_t;
        regcomp(gCommandRE, tCommandRE, REG_EXTENDED);
    }
}

Command::Command(const Command& pCommand):String((String&)pCommand)
{
}

Command Command::getCommand(int i)	//returns an elemental part of a comand.
{
    regmatch_t tMatch[6];
    char* tLast;
    char* tUpto = iString;
    
    for (int j = 0; j < i+1; j++)
    {
        bzero(tMatch, sizeof(regmatch_t)*6);
        if (regexec(gCommandRE, tUpto, 6, tMatch, 0))
        {
            throw MyException(kUnknownException, "Command has bad format.\n");
        }
        tLast = tUpto;
        tUpto = (int)tMatch[1].rm_eo+tUpto;
    }
    Command tCommand;
    tCommand.init(tLast, (long)tMatch[1].rm_so, (long)tMatch[1].rm_eo);
    return tCommand;
}

void InteractiveControl::helpCommand(Command& pCommand)
{
    try
    {
        std::cout << "This hasn't been implemented yet because I'm having a bad day.\n";
    }
    catch (MyException e)
    {
        std::cout << "Available commands.\n";
        std::cout << "print: This is used to display diffrent pieces of information about the data used.\n";
        std::cout << "output: This is used to output to a file diffrent pieces of information about the data used.\n";
        std::cout << "quit: To exit.\n";
    }
}

void InteractiveControl::outputCommand(Command& pCommand)
{
    Command tCurrent = pCommand.getCommand(1);
    throw MyException(kUnknownException, "Output: Command not yet implemented.\n");
}

void InteractiveControl::printCommand(Command& pCommand)
{
    Command tCurrent = pCommand.getCommand(1);
    throw MyException(kUnknownException, "Print: Command not yet implemented.\n");
}

bool InteractiveControl::handleCommand(Command& pCommand)	//Returns whether interactive mode should be exited.
{
    try
    {
        Command tFirstCommand = pCommand.getCommand(0);
        tFirstCommand.upcase();
        if (tFirstCommand.cmp("HELP") == 0)
        {
            helpCommand(pCommand);
        }
        else if (tFirstCommand.cmp("QUIT") == 0)
        {
            return true;
        }
        else if (tFirstCommand.cmp("OUTPUT") == 0)
        {
            outputCommand(pCommand);
        }
        else if (tFirstCommand.cmp("PRINT") == 0)
        {
            printCommand(pCommand);
        }
        else
        {
            throw MyException(kUnknownException, "Command not recognised.\n");
        }
    }
    catch (MyException e)
    {
        std::cout << e.what();
    }
    return false;
}

void InteractiveControl::goInteractive()
{
    char string[255];
    
    bool tExit=false;
    std::cout << "Interactive Mode. For help type (help)\n";
    while (!tExit)
    {
        std::cout << "-->";
        std::cin.getline(string, 255);
        Command tReply(string);
        tExit = handleCommand(tReply);
    }
}

InteractiveControl::InteractiveControl(Stats* pStats, RankedSpaceGroups* pRankings, Table* pTable):iStats(pStats), iRanking(pRankings), iTable(pTable)
{
}