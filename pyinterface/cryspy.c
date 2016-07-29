/* File: cryspy.c */
#include <Python.h>
#include <setjmp.h>
//Make the declarations in the cinterface file look like imports:
//#define DLLEXP __cdecl __declspec(dllimport) 
#include "cinterface.h"

static jmp_buf thebeginning;


static PyObject * command_wrapper(PyObject * self, PyObject * args)
{
  PyObject * ret;
  char * command_buffer;
  // parse arguments
  if (!PyArg_ParseTuple(args, "s", &command_buffer)) {
    return NULL;
  }
  setcommand(command_buffer);
  
  int i = setjmp(thebeginning);
  printf("pointer %d \n", (long*)thebeginning) ;
  if ( i == 0 ) {
//		printf("Calling ccommand.\n");
		ccommand();
  }
  else {
//		printf("Longjmp back to start.\n");
  }

  Py_RETURN_NONE;
}

// Call this to force a longjmp back to where the routine above.
void endofcommands(){
//		printf("pointer %d \n", (long*)thebeginning) ;
		longjmp(thebeginning,1);
}



static PyObject * crinit_wrapper(PyObject * self, PyObject * args)
{
  cinit();
  
  Py_RETURN_NONE;
}





static PyMethodDef cryspyMethods[] = {
 { "command", command_wrapper, METH_VARARGS, "Run commands" },
 { "init", crinit_wrapper, METH_VARARGS, "Initialise CRYSTALS" },
 { NULL, NULL, 0, NULL }
};

DL_EXPORT(void) initcryspy(void)
{
  Py_InitModule("cryspy", cryspyMethods);
}


