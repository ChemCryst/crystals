/*
 *  CcSemaphore.h
 *  
 *
 *  Created by Stefan Pantos on 28/01/2005.
 *
 */
 
 // $Log: not supported by cvs2svn $
#if !defined(CcSemaphore_H_)
#define CcSemaphore_H_

#include "ccthreadingexceptions.h"

#if defined(__BOTHWX__)
#include <wx/thread.h>

enum
{
	kMaxSemaphoreCount = 0,
	kSemaphoreWaitInfinatly = 0xFFFFFFFF
};
#else
enum
{
	kMaxSemaphoreCount = 99999,
	kSemaphoreWaitInfinatly = INFINITE
};
#endif

using namespace std;

class CcSemaphore
{
	private:
		#if defined(__BOTHWX__)
			wxSemaphore iSemaphore;
		#else
			Handle iSemaphore;
		#endif
	public:
		/* Creates a semaphore which will allow you to 
		limit the number of threads which can be running 
		on a resourse concurrently*/
		CcSemaphore(const int pInitValue = 0, const int pMaxCount = kMaxSemaphoreCount);
		
		void wait(const unsigned int pTime=kSemaphoreWaitInfinatly) throw(semaphore_timeout, semaphore_error);
		void signal() throw(semaphore_error);
};
#endif