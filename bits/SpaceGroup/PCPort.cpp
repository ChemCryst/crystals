#if defined(_WIN32)
#include <string.h>
#include "PCPort.h"
#include <sys/types.h>
#include <sys/timeb.h>
#include <WinSock.h>

void bzero(void* pPoint, size_t pBytes)
{
	for (size_t i = 0; i < pBytes; i++)
	{
		((char*)pPoint)[i] = 0;
	}
}

char* index(char* pString, int pChar)
{
	short tStrLen = (int)strlen(pString);
	for (short i = 0; i < tStrLen; i++)
	{	
		if (pString[i] == (char)pChar)
		{
			return &(pString[i]);
		}
	}
	return NULL;
}

int bcmp(const void *b1, const void *b2, size_t pLength)
{
	return memcmp(b1, b2, pLength);
}

float rint(float pNumber)
{
	float tDiff =  pNumber - ((int)(pNumber/1));

	if (tDiff < 5)
	{
		return pNumber - tDiff;
	}
	else
	{
		return pNumber + (1 - tDiff);
	}
}

int gettimeofday(struct timeval *tp, struct timezone *tzp)
{
	struct timeb tTime;
	ftime(&tTime);
	if (tp)
	{
		tp->tv_sec = (long)tTime.time;
		tp->tv_usec = tTime.millitm;
	}
	if (tzp)
	{
		tzp->tz_minuteswest = tTime.timezone;
		tzp->tz_dsttime = tTime.dstflag;
	}
	return -1;
}

#endif
