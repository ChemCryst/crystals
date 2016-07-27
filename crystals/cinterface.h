
/* This file contains shared library entry points for access to the CRYSTALS Fortran library.
   Ideally functions should just pass arguments along and return them with minimum interference.
*/

//#ifndef DLLEXP
//#define DLLEXP __cdecl __declspec(dllexport)
//#endif

//void DLLEXP ccommand(void);
//void DLLEXP cinit(void);
void  ccommand(void);
void  cinit(void);

void commandwrap(void);
void crinitwrap(void);

void setcommand(char *commandline);
long getcommand(char *commandline);
