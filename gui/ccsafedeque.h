/*
 *  CcSafeDeque.h
 *  
 *
 *  Created by Stefan Pantos on 27/01/2005.
 *  This is a thread safe version of the deque template.
 *  reduces the work which is needed to prevent dead locks.
 *  Can be used safely in the knowledge that two threads
 *  cannot write to it at the same time.
 */
 
 // $Log: not supported by cvs2svn $
#if !defined(CcSafeDeque_H__)
#define CcSafeDeque_H__

#include <deque>
#include "ccthreading.h"

template <typename _Tp>
class CcSafeDeque
{
	protected:
		CcMutex iLock;			    // The write lock. Prevents two writes or a write and a read colliding.
		CcSemaphore iEmptySemaphore; // Indicates whether the queue us empty or not.
		deque<_Tp>* iDeque;         // The Deque it self.
	public:
		CcSafeDeque() throw(mutex_error):iLock(), iEmptySemaphore(), iDeque(NULL)
		{
			CcLifeTimeLock tLock(iLock);
			iDeque = new deque<_Tp>();
		}
		
		CcSafeDeque(const size_t n) throw(mutex_error):iLock(), iEmptySemaphore(), iDeque(NULL)
		{
			CcLifeTimeLock tLock(iLock);
			iDeque = new deque<_Tp>(n);
		}
		
		CcSafeDeque(const size_t n, const _Tp& t) throw(mutex_error):iLock(), iEmptySemaphore(), iDeque(NULL)
		{
			CcLifeTimeLock tLock(iLock);
			iDeque = new deque<_Tp>(n, t);
		}
		
		CcSafeDeque(const deque<_Tp>& a) throw(mutex_error):iLock(), iEmptySemaphore(), iDeque(NULL)
		{
			CcLifeTimeLock tLock(iLock);
			iDeque = new deque<_Tp>(a);
		}
		
		~CcSafeDeque() throw(mutex_error)
		{
			CcLifeTimeLock tLock(iLock);
			delete iDeque;
		}
		
		void push_front(const _Tp& pItem) throw(mutex_error, semaphore_error)	//Put the passed item on the front of the list.
		{
			CcLifeTimeLock tLock(iLock);
			iDeque->push_front(pItem);
			iEmptySemaphore.signal();	//Indicate that there is something in the list.
		}
		
		void push_back(const _Tp& pItem) throw(mutex_error, semaphore_error)	//Put the passed item on the end of the list.
		{
			CcLifeTimeLock tLock(iLock);
			iDeque->push_back(pItem);
			iEmptySemaphore.signal();	//Indicate that there is something in the list.
		}
		
		/* Removes and returns the last element of the deque.
		 * If the list is empty then it blocks till something is added or
		 * The timeout is reach when an semaphore_timeout exception is thrown.
		 */
		_Tp pop_back(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw(mutex_error, semaphore_error, semaphore_timeout)
		{
			iEmptySemaphore.wait(pWaitTime);	// Wait till there is an element to return or time runs out.
												// If the timer runs out and exception is thrown.
			iLock.Lock();
			_Tp result =iDeque->back();
			iDeque->pop_back();
			iLock.Unlock();
			return result;
		}
					
		/* Removes and returns the first element of the deque in a Maybe wrapper.
		 * If the list is empty then it blocks till something is added or
		 * The timeout is reach when an semaphore_timeout exception is thrown.
		 */
		_Tp pop_front(const unsigned int pWaitTime = kSemaphoreWaitInfinatly) throw(mutex_error, semaphore_error, semaphore_timeout)	
		{
			iEmptySemaphore.wait(pWaitTime);	// Wait till there is an element to return or time runs out.
												// If the timer runs out and exception is thrown.
			iLock.Lock();
			_Tp result =iDeque->front();
			iDeque->pop_front();
			iLock.Unlock();
			return result;
		}
		
		bool empty() throw(logic_error)
		{
			bool tResult;
			CcLifeTimeLock tLock(iLock);
			tResult = iDeque->empty();
			
			return tResult;
		}
};
#endif
