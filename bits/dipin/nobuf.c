
#include <stdio.h>

no_stdout_buffer__() { setvbuf(stdout,0,_IONBF,0); }
