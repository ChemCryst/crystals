/*
 *  Timer.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Mon Apr 19 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include <stdlib.h>
#include <iostream>
#if defined(_WIN32)
#include "PCPort.h"
#endif

class Timer
{
	protected:
		struct timeval tStartTime, tStopTime;
	public:
		Timer();
		struct timeval start();
		struct timeval stop();
		float seconds() const;
		bool timing() const;
};

std::ostream& operator<<(std::ostream& pStream, const Timer &tStopTime);
