/*
 *  ccsafesequences.h
 *  
 *
 *  Created by Stefan Pantos on 04/02/2005.
 *
 */
 
 //   $Log: not supported by cvs2svn $
 //   Revision 1.3  2011/05/04 12:21:17  rich
 //   Remove throw statements - they are ignored by C++ compiler.
 //
 //   Revision 1.2  2005/02/07 14:25:23  stefan
 //   1. Added the threading include so that it has a reference to ccmutex and ccsemaphore.
 //   2. Added another template variable as visual c++ moans as it doesn't take into account the default values of a deque or list.
 //
 //   Revision 1.1  2005/02/04 17:21:40  stefan
 //   1. A set of classes to extent CcSafeDeque to allow easy change notification.
 //   2. A set of classese to more generalise CcSafeDeques uses.
 //
 
/*
 *	Class for the thread safe access of a front and back sequance modeled class C.
 */
 
 #if !defined(ccsafesequences_H__)
 #define ccsafesequences_H__

#include "ccthreading.h"

//using namespace ccthreading; for future use.

template <typename T, template<typename T, typename T2> class C, typename T2 = std::allocator<T> >
class CcSafeSequence
{
	protected:
		CcMutex iLock;			     // The write lock. Garrentees mutual exclution between methods.
		CcSemaphore iEmptySemaphore; // Indicates whether the queue us empty or not.
		C<T, T2> iSequence;
	public:
		CcSafeSequence():iSequence()
		{}
		
		CcSafeSequence(const C<T, T2>& pSequence):iSequence(pSequence)
		{}

		size_t size() {
			return iSequence.size();
		}
		
		virtual void push_front(const T& pItem) //throw(mutex_error, semaphore_error)	//Put the passed item on the front of the list.
		{
			CcLifeTimeLock tLock(iLock);
			iSequence.push_front(pItem);
			iEmptySemaphore.signal();	//Indicate that there is something in the list.
		}
		
		virtual void push_back(const T& pItem) //throw(mutex_error, semaphore_error)	//Put the passed item on the end of the list.
		{
			CcLifeTimeLock tLock(iLock);
			iSequence.push_back(pItem);
			iEmptySemaphore.signal();	//Indicate that there is something in the list.
		}
		
		/* Removes and returns the last element of the deque.
		 * If the list is empty then it blocks till something is added or
		 * The timeout is reach when an semaphore_timeout exception is thrown.
		 */
		virtual T pop_back(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) //throw(mutex_error, semaphore_error, semaphore_timeout)
		{
			iEmptySemaphore.wait(pWaitTime);	// Wait till there is an element to return or time runs out.
												// If the timer runs out and exception is thrown.
			iLock.Lock();
			T result =iSequence.back();
			iSequence.pop_back();
			iLock.Unlock();
			return result;
		}
					
		/* Removes and returns the first element of the deque in a Maybe wrapper.
		 * If the list is empty then it blocks till something is added or
		 * The timeout is reach when an semaphore_timeout exception is thrown.
		 */
		virtual T pop_front(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) //throw(mutex_error, semaphore_error, semaphore_timeout)	
		{
			iEmptySemaphore.wait(pWaitTime);	// Wait till there is an element to return or time runs out.
												// If the timer runs out and exception is thrown.
			iLock.Lock();
			T result =iSequence.front();
			iSequence.pop_front();
			iLock.Unlock();
			return result;
		}
		
		virtual bool empty() //throw(logic_error)
		{
			bool tResult;
			CcLifeTimeLock tLock(iLock);
			tResult = iSequence.empty();
			return tResult;
		}
};

#endif
