
/* This file contains shared library entry points for access to the CRYSTALS Fortran library.
   Ideally functions should just pass arguments along and return them with minimum interference.
*/


#define DLLEXP __cdecl __declspec(dllexport)

#include "string.h"
#include "stdio.h"
#include "cinterface.h"

static char* command_buffer;
static int command_init;

void endofcommands();

//void DLLEXP ccommand(void)
void ccommand(void)
{
	commandwrap();
}

//void DLLEXP cinit(void)
void cinit(void)
{
	crinitwrap();
}

void setcommand(char *commandline){
	command_buffer = commandline;
    command_init = 1;
}

long getcommand(char *commandline)
{
    int inputlen = strlen(commandline);
	char *command;
	int retOK = 0;
	
    if (command_init) {
		command_init = 0;
		command = strtok(command_buffer, "\n");
	}
	else{
		command = strtok(NULL, "\n");
	}

    if ( command ) {
		printf("%s\n", command);
        int commandlen = strlen(command);
		int outputlen = (inputlen < commandlen) ? inputlen : commandlen;  //Minimum of the two string lengths

		strncpy( commandline, command, outputlen ); 
		//PAD
        for (int j = commandlen; j<inputlen; j++)   //Copy
		{
			*(commandline + j) = ' ';
		}
	} else {
		printf("No more commands - raising endofcommands exception\n");
		endofcommands();
		printf("No exception raised. Returning -1\n");
		retOK = -1;
	}
	return retOK;
}


// Stubs for non Python versions.

// ...
