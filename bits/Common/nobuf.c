
#include <stdio.h>


extern "C" {
void no_stdout_buffer() { setvbuf(stdout,0,_IONBF,0); }
	}