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

/*!
 * @class Timer 
 * @description Not yet documented.
 * @abstract
*/
class Timer
{
	protected:
		struct timeval tStartTime, tStopTime;
	public:
		Timer();
		struct timeval start();
		struct timeval stop();

		/*!
		 * @function seconds 
		 * @description Not yet documented.
		 * @abstract
		 */
		float seconds() const;

		/*!
		 * @function timing 
		 * @description Not yet documented.
		 * @abstract
		 */
		bool timing() const;
};

std::ostream& operator<<(std::ostream& pStream, const Timer &tStopTime);
