/*
 *  Timer.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Mon Apr 19 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "Timer.h"
#if !defined(_WIN32)
#include <sys/time.h>
#endif

Timer::Timer()
{
	tStartTime.tv_sec = 0l;
	tStartTime.tv_usec = 0l;
	tStopTime.tv_sec = 0l;
	tStopTime.tv_usec = 0l;
}

struct timeval Timer::start()
{
	gettimeofday(&tStartTime, NULL);
	tStopTime.tv_sec = -1l;
	return tStartTime;
}

struct timeval Timer::stop()
{
	gettimeofday(&tStopTime, NULL);
	return tStopTime;
}

bool Timer::timing() const
{
	return tStopTime.tv_sec == -1l;
}

float Timer::seconds() const
{
	struct timeval tEndTime;
	if (timing())
	{
		gettimeofday(&tEndTime, NULL);
	}
	else
	{
		tEndTime = tStopTime;
	}
	return (float)(tEndTime.tv_sec - tStartTime.tv_sec)+(float)(tEndTime.tv_usec-tStartTime.tv_usec)/1000000;
}

std::ostream& operator<<(std::ostream& pStream, const Timer &tTime)
{
	float tSeconds = tTime.seconds();
	int tHours = (int)(tSeconds/3600);
	int tMinutes = (int)(tSeconds/60) - (tHours*3600);
	tSeconds = tSeconds - tHours*3600 - tMinutes*60;
	
	return pStream << tHours << ":" << tMinutes << ":" << tSeconds << " sec";
}
