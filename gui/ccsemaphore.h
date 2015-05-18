/*
 *  CcSemaphore.h
 *  
 *
 *  Created by Stefan Pantos on 28/01/2005.
 *
 */
 
 // $Log: not supported by cvs2svn $
 // Revision 1.3  2005/02/22 22:49:24  stefan
 // 1. Added new line at the end of the file as some compiles aren't to happy not having an empty line
 //
 // Revision 1.2  2005/02/07 14:27:16  stefan
 // 1. Removed a warning which was a reminder as vc doesn't like #warning as a preprocessor instruction
 //
 // Revision 1.1  2005/02/02 15:27:23  stefan
 // 1. Initial addition to crystals. A group of classes for threading.
 //
#if !defined(CcSemaphore_H_)
#define CcSemaphore_H_

#include "ccthreadingexceptions.h"

#ifdef CRY_USEMFC
 enum
 {
	kMaxSemaphoreCount = 99999,
	kSemaphoreWaitInfinatly = INFINITE
 };
#else
 #include <wx/thread.h>

 enum
 {
	kMaxSemaphoreCount = 0,
	kSemaphoreWaitInfinatly = 0xFFFFFFFF
 };
#endif

using namespace std;

class CcSemaphore
{
	private:
		#ifdef CRY_USEMFC
			HANDLE iSemaphore;
		#else
			wxSemaphore iSemaphore;
		#endif
	public:
		/* Creates a semaphore which will allow you to 
		limit the number of threads which can be running 
		on a resourse concurrently*/
		CcSemaphore(const int pInitValue = 0, const int pMaxCount = kMaxSemaphoreCount);
		
		void wait(const unsigned int pTime=kSemaphoreWaitInfinatly); //throw(semaphore_timeout, semaphore_error);
		void signal(); //throw(semaphore_error);
};
#endif
