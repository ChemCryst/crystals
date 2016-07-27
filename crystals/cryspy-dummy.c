/* File: cryspy-dummy.c */
#include <setjmp.h>
//Make the declarations in the cinterface file look like imports:
#include "cinterface.h"

static jmp_buf thebeginning;


void endofcommands(){
		longjmp(thebeginning,1);
}

int setjmppoint(){
// Returns 0 on first setup, returns 1 on jump thrown.
  return setjmp(thebeginning);
}


