#if !defined(__PC_PORT_H__)
#define __PC_PORT_H__

#include <WinSock.h>

int prog_main(int argc, const char * argv[]);	//The main function

/*struct timeval{
	long tv_sec;	*//*seconds since Jan. 1, 1970*/
/*	long tv_usec;
};*/

struct timezone{
	int tz_minuteswest; /* of greenwich */
	int tz_dsttime;		/* type of dst correction to apply*/
};

#define uint unsigned int

extern void bzero(void* pPoint, size_t pBytes);
extern char* index(char* pString, int pChar);
extern int bcmp(const void *b1, const void *b2, size_t pLength);
extern float rint(float pNumber);
extern int gettimeofday(struct timeval *tp, struct timezone *tzp);
#endif
